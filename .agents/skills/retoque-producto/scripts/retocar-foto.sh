#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "$0")" && pwd)"
project_root="$(cd "$script_dir/../../../.." && pwd)"

usage() {
  echo "Usage: $0 INPUT_IMAGE [OUTPUT.png] [ADDITIONAL_INSTRUCTIONS]" >&2
  echo "Supported input formats: .jpg, .jpeg, .png, .webp" >&2
}

if [[ $# -lt 1 ]]; then
  usage
  exit 1
fi

input="$1"
if [[ ! -f "$input" ]]; then
  echo "Error: input image does not exist: $input" >&2
  exit 1
fi
input="$(cd "$(dirname "$input")" && pwd)/$(basename "$input")"

output="$project_root/fotos-productos/retocadas/$(basename "$(dirname "$input")")/$(basename "${input%.*}")-tienda.png"
extra_instructions=""
if [[ $# -ge 2 ]]; then
  second_argument_extension="$(printf '%s' "$2" | tr '[:upper:]' '[:lower:]')"
  if [[ "$second_argument_extension" == *.png ]]; then
    output="$2"
    extra_instructions="${*:3}"
  else
    extra_instructions="${*:2}"
  fi
fi

if [[ "$output" != /* ]]; then
  output="$(pwd)/$output"
fi
output_extension="$(printf '%s' "$output" | tr '[:upper:]' '[:lower:]')"
if [[ "$output_extension" != *.png ]]; then
  echo "Error: output must use the .png extension." >&2
  exit 1
fi
if [[ -e "$output" ]]; then
  echo "Error: output already exists; choose a different path: $output" >&2
  exit 1
fi

extension="${input##*.}"
extension="$(printf '%s' "$extension" | tr '[:upper:]' '[:lower:]')"
case "$extension" in
  jpg|jpeg) mime_type="image/jpeg" ;;
  png) mime_type="image/png" ;;
  webp) mime_type="image/webp" ;;
  *)
    echo "Error: unsupported input format: .$extension" >&2
    usage
    exit 1
    ;;
esac

if [[ -z "${OPENAI_API_KEY:-}" && -f "$project_root/.env" ]]; then
  set -a
  # shellcheck disable=SC1091
  source "$project_root/.env"
  set +a
fi
if [[ -z "${OPENAI_API_KEY:-}" ]]; then
  echo "Error: set OPENAI_API_KEY in the environment or in $project_root/.env." >&2
  exit 1
fi

command -v curl >/dev/null || { echo "Error: curl is required." >&2; exit 1; }
command -v jq >/dev/null || { echo "Error: jq is required." >&2; exit 1; }
command -v base64 >/dev/null || { echo "Error: base64 is required." >&2; exit 1; }

prompt="$(cat <<'PROMPT'
Edit the supplied photograph into a polished e-commerce product image. Use the actual photograph as the source, not as inspiration for a replacement. Preserve the identity and construction of the photographed product, its pose, orientation, viewpoint, perspective, framing, scale, silhouette, folds, and position of every component, strap, buckle, seam, fitting, and accessory. Do not invent, remove, redesign, reconstruct, or reveal product details.

Make restrained photographic corrections to produce a naturally and correctly exposed catalog image. Correct exposure when needed, including gently lifting an underexposed product or reducing excessive brightness. Aim for balanced highlights, midtones, and shadows, visible texture throughout, natural color, and enough contrast to retain volume. Do not interpret clarity as indiscriminate brightening. Avoid clipped highlights, lost texture, washed-out appearance, harsh frontal lighting, and a high-key look. Do not brighten the product merely to make the background lighter.

Change clearly external background areas to a uniform exact #f6f6f6 background, unless the user explicitly requests another color. Keep a soft, realistic contact shadow and natural tonal depth. If a boundary between product and background is ambiguous, leave that area unchanged. Do not add text, labels, logos, watermarks, props, or items that could be mistaken as included.

Preserve the source aspect ratio and framing unless the user requests a different composition. If a target format is requested, extend the canvas around the product rather than cropping, moving, rotating, or resizing it. For a circular composition, keep the full product inside the circle; the delivered PNG remains rectangular unless transparency is explicitly requested.
PROMPT
)"
if [[ -n "$extra_instructions" ]]; then
  prompt+=$'\n\nAdditional user instructions (follow only when consistent with preserving the real product):\n'
  prompt+="$extra_instructions"
fi
tmpdir="$(mktemp -d)"
cleanup() {
  rm -rf "$tmpdir"
}
trap cleanup EXIT

b64_file="$tmpdir/input.b64"
request_file="$tmpdir/request.json"
response_file="$tmpdir/response.json"
result_file="$tmpdir/result.b64"

base64 <"$input" | tr -d '\n' >"$b64_file"
jq -n \
  --arg prompt "$prompt" \
  --arg mime "$mime_type" \
  --rawfile image "$b64_file" \
  '{
    model: "gpt-image-2.5-sunburst",
    prompt: $prompt,
    images: [{image_url: ("data:" + $mime + ";base64," + ($image | gsub("\n"; "")))}],
    quality: "max",
    output_format: "png",
    size: "auto"
  }' >"$request_file"

echo "Retocando foto del producto..." >&2
status="$(curl -sS -w '%{http_code}' -o "$response_file" \
  https://api.openai.com/v1/images/edits \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d @"$request_file")"
if [[ "$status" -lt 200 || "$status" -ge 300 ]]; then
  echo "Error: image API returned HTTP $status." >&2
  jq -r '.error.message // empty' "$response_file" >&2 || true
  exit 1
fi

jq -er '.data[0].b64_json | select(type == "string" and length > 0)' "$response_file" \
  | tr -d '\n' >"$result_file"
if [[ ! -s "$result_file" ]]; then
  echo "Error: the image API response did not contain a generated image." >&2
  exit 1
fi

decoded_image="$tmpdir/output.png"
if base64 -D <"$result_file" >"$decoded_image" 2>/dev/null; then
  :
else
  base64 --decode <"$result_file" >"$decoded_image"
fi
if [[ ! -s "$decoded_image" ]]; then
  echo "Error: generated image is empty." >&2
  exit 1
fi

mkdir -p "$(dirname "$output")"
mv "$decoded_image" "$output"
echo "Generated image (visually verify product fidelity before use): $output"

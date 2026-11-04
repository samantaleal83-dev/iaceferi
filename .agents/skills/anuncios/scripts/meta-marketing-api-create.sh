#!/usr/bin/env bash
set -euo pipefail

API_VERSION="${META_API_VERSION:-v26.0}"
SCRIPT_NAME="$(basename "$0")"
EDGE=""
ACCOUNT_ID="${META_AD_ACCOUNT_ID:-}"
ALLOW_ACTIVE=0
CONFIRMATION=""
declare -a FIELDS=()
declare -a FILES=()
SEEN_FIELDS=("")

usage() {
  cat <<EOF
Uso:
  ${SCRIPT_NAME} --edge EDGE [opciones]

Crea un objeto en cualquier endpoint de creación bajo una cuenta publicitaria
de Meta. El EDGE y los campos requeridos dependen del tipo de objeto y de la
Marketing API. El script no presupone producto, objetivo ni formato.

Opciones:
  --edge EDGE             Endpoint bajo /act_<cuenta>/ (por ej. campaigns,
                          adsets, adcreatives, ads o adimages)
  --account-id ID         ID numérico de la cuenta; también acepta
                          META_AD_ACCOUNT_ID como variable de entorno
  --field KEY=VALUE       Campo del endpoint; puede repetirse. Los valores JSON
                          se pasan como texto, por ejemplo --field 'targeting={...}'
  --file KEY=PATH         Archivo para subir en el campo indicado; puede repetirse
  --api-version VERSION   Versión Graph API (por defecto: ${API_VERSION})
  --allow-active          Permitir status=ACTIVE (puede iniciar gasto)
  --confirm TEXT          Confirmación no interactiva; debe ser exactamente
                          CREAR-EN-META
  -h, --help              Mostrar esta ayuda

Para enviar la solicitud, configure META_ACCESS_TOKEN con un token que tenga
los permisos requeridos y acceso a la cuenta. Las campañas, conjuntos y
anuncios se fuerzan a PAUSED por defecto; no se activan ni generan gasto.

Ejemplo de campaña pausada:
  ${SCRIPT_NAME} --edge campaigns \\
    --field 'name=Campaña de prueba' \\
    --field 'objective=OUTCOME_SALES' \\
    --field 'special_ad_categories=[]'

Ejemplo de creatividad con imagen:
  ${SCRIPT_NAME} --edge adimages --file 'filename=./creatividad.png'

Consulte la documentación oficial de Meta para los campos requeridos y valores
admitidos por cada endpoint. No pase tokens como argumentos ni los guarde en
el repositorio.
EOF
}

fail() {
  printf 'Error: %s\n' "$*" >&2
  exit 2
}

parse_assignment() {
  local assignment="$1"
  local destination="$2"
  local key="${assignment%%=*}"
  local value="${assignment#*=}"
  [[ "$assignment" == *=* ]] || fail "Se esperaba KEY=VALUE: ${assignment}"
  [[ "$key" =~ ^[A-Za-z][A-Za-z0-9_]*$ ]] || fail "Nombre de campo no válido: ${key}"
  printf -v "$destination" '%s' "$key"
  printf -v "${destination}_value" '%s' "$value"
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --edge)
      [ "$#" -ge 2 ] || fail "--edge requiere un valor."
      EDGE="$2"
      shift 2
      ;;
    --account-id)
      [ "$#" -ge 2 ] || fail "--account-id requiere un valor."
      ACCOUNT_ID="$2"
      shift 2
      ;;
    --field)
      [ "$#" -ge 2 ] || fail "--field requiere KEY=VALUE."
      parse_assignment "$2" FIELD_KEY
      for seen_field in "${SEEN_FIELDS[@]}"; do
        [ "$seen_field" != "$FIELD_KEY" ] || fail "El campo ${FIELD_KEY} se indicó más de una vez."
      done
      SEEN_FIELDS+=("$FIELD_KEY")
      FIELDS+=("$FIELD_KEY=${FIELD_KEY_value}")
      shift 2
      ;;
    --file)
      [ "$#" -ge 2 ] || fail "--file requiere KEY=PATH."
      parse_assignment "$2" FILE_KEY
      [[ -f "${FILE_KEY_value}" ]] || fail "No se encontró el archivo ${FILE_KEY_value}."
      FILES+=("$FILE_KEY=${FILE_KEY_value}")
      shift 2
      ;;
    --api-version)
      [ "$#" -ge 2 ] || fail "--api-version requiere un valor."
      API_VERSION="$2"
      shift 2
      ;;
    --allow-active)
      ALLOW_ACTIVE=1
      shift
      ;;
    --confirm)
      [ "$#" -ge 2 ] || fail "--confirm requiere un valor."
      CONFIRMATION="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      fail "Opción desconocida: $1"
      ;;
  esac
done

[[ "$EDGE" =~ ^[A-Za-z][A-Za-z0-9_]*$ ]] || fail "Indique un --edge válido."
[[ "$ACCOUNT_ID" =~ ^[0-9]+$ ]] || fail "Indique --account-id numérico o META_AD_ACCOUNT_ID."
[[ "$API_VERSION" =~ ^v[0-9]+\.[0-9]+$ ]] || fail "Versión API no válida: ${API_VERSION}"
if [ "${#FIELDS[@]}" -eq 0 ] && [ "${#FILES[@]}" -eq 0 ]; then
  fail "Debe proporcionar al menos un --field o --file."
fi

if [[ "$EDGE" =~ ^(campaigns|adsets|ads)$ ]]; then
  STATUS=""
  STATUS_WAS_SET=0
  for field in "${FIELDS[@]-}"; do
    [ -n "$field" ] || continue
    if [[ "$field" == status=* ]]; then
      STATUS="${field#status=}"
      STATUS_WAS_SET=1
      break
    fi
  done
  if [ "$STATUS_WAS_SET" -eq 1 ] && [ -z "$STATUS" ]; then
    fail "El campo status no puede estar vacío."
  fi
  if [ -n "$STATUS" ] && [ "$STATUS" != "PAUSED" ]; then
    if [ "$STATUS" = "ACTIVE" ] && [ "$ALLOW_ACTIVE" -eq 1 ]; then
      :
    elif [ "$STATUS" = "ACTIVE" ]; then
      fail "status=ACTIVE puede iniciar gasto; omítalo para crear pausado o use --allow-active de forma deliberada."
    else
      fail "Para evitar activaciones inesperadas, el único status admitido aquí es PAUSED (o ACTIVE con --allow-active)."
    fi
  fi
  if [ "$STATUS_WAS_SET" -eq 0 ]; then
    FIELDS+=("status=PAUSED")
  fi
fi

ENDPOINT="act_${ACCOUNT_ID}/${EDGE}"
REQUEST_URL="https://graph.facebook.com/${API_VERSION}/${ENDPOINT}"

printf 'Endpoint: POST %s\n' "$REQUEST_URL"
printf 'Campos:\n'
for field in "${FIELDS[@]-}"; do
  [ -n "$field" ] || continue
  printf '  %s\n' "$field"
done
for file in "${FILES[@]-}"; do
  [ -n "$file" ] || continue
  printf '  Archivo %s\n' "${file%%=*}"
done

[ -n "${META_ACCESS_TOKEN:-}" ] || fail "Configure META_ACCESS_TOKEN en el entorno."
if [ "${#META_ACCESS_TOKEN}" -lt 20 ]; then
  fail "META_ACCESS_TOKEN parece incompleto."
fi

if [ "$CONFIRMATION" != "CREAR-EN-META" ]; then
  read -r -p "La solicitud creará un objeto en Meta. Escriba CREAR-EN-META para continuar: " CONFIRMATION
fi
if [ "$CONFIRMATION" != "CREAR-EN-META" ]; then
  printf '%s\n' "Cancelado; no se envió ninguna solicitud."
  exit 0
fi

TEMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/meta-marketing-api.XXXXXX")"
chmod 700 "$TEMP_DIR"
trap 'rm -rf "$TEMP_DIR"' EXIT
REQUEST_CONFIG="${TEMP_DIR}/request.curl"
RESPONSE_FILE="${TEMP_DIR}/response.json"

META_ACCESS_TOKEN="$META_ACCESS_TOKEN" REQUEST_URL="$REQUEST_URL" \
  python3 - "$REQUEST_CONFIG" <<'PY'
import json
import os
import sys
from urllib.parse import quote

url = os.environ["REQUEST_URL"] + "?access_token=" + quote(os.environ["META_ACCESS_TOKEN"], safe="")
with open(sys.argv[1], "w", encoding="utf-8") as config:
    config.write("url = " + json.dumps(url) + "\n")
PY
chmod 600 "$REQUEST_CONFIG"

declare -a CURL_ARGS=(--config "$REQUEST_CONFIG" --silent --show-error
  --connect-timeout 20 --max-time 180 --output "$RESPONSE_FILE"
  --write-out '%{http_code}')
for field in "${FIELDS[@]-}"; do
  [ -n "$field" ] || continue
  CURL_ARGS+=(--form-string "$field")
done
for file in "${FILES[@]}"; do
  CURL_ARGS+=(--form "$file")
done

if ! HTTP_CODE="$(curl "${CURL_ARGS[@]}")"; then
  fail "Falló la conexión con la API de Meta."
fi

if ! python3 - "$RESPONSE_FILE" "$HTTP_CODE" <<'PY'
import json
import sys

path, code = sys.argv[1:]
try:
    with open(path, encoding="utf-8") as response:
        body = json.load(response)
except (OSError, ValueError):
    print("Meta devolvió una respuesta que no es JSON válido.", file=sys.stderr)
    raise SystemExit(1)

if not 200 <= int(code) < 300 or "error" in body:
    print("Meta rechazó la solicitud (HTTP " + code + "):", file=sys.stderr)
    print(json.dumps(body.get("error", body), ensure_ascii=False, indent=2), file=sys.stderr)
    raise SystemExit(1)

print(json.dumps(body, ensure_ascii=False, indent=2))
PY
then
  exit 1
fi

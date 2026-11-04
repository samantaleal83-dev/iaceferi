#!/bin/sh

set -eu

usage() {
  printf 'Uso: %s <archivo.svg> [salida.png]\n' "$0" >&2
  exit 2
}

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  usage
fi

input=$1
case "$input" in
  -*)
    input=./$input
    ;;
esac

if [ ! -f "$input" ] || [ ! -r "$input" ]; then
  printf 'Error: no se puede leer el archivo de entrada: %s\n' "$input" >&2
  exit 1
fi

case "$input" in
  *.[sS][vV][gG])
    ;;
  *)
    printf 'Error: el archivo de entrada debe tener extensión .svg: %s\n' "$input" >&2
    exit 1
    ;;
esac

if [ "$#" -eq 2 ]; then
  output=$2
else
  output=${input%.*}.png
fi

case "$output" in
  *.[pP][nN][gG])
    ;;
  *)
    printf 'Error: el archivo de salida debe tener extensión .png: %s\n' "$output" >&2
    exit 1
    ;;
esac

if [ "$input" = "$output" ]; then
  printf 'Error: la salida no puede sobrescribir el archivo de entrada.\n' >&2
  exit 1
fi

output_dir=$(dirname "$output")
if [ ! -d "$output_dir" ] || [ ! -w "$output_dir" ]; then
  printf 'Error: el directorio de salida no existe o no permite escritura: %s\n' "$output_dir" >&2
  exit 1
fi

if command -v rsvg-convert >/dev/null 2>&1; then
  renderer=rsvg
elif command -v inkscape >/dev/null 2>&1; then
  renderer=inkscape
else
  printf '%s\n' \
    'Error: hace falta un conversor SVG a PNG.' \
    'Instalá uno de estos programas y volvé a intentarlo:' \
    '  macOS (Homebrew): brew install librsvg' \
    '  Alternativa: Inkscape (https://inkscape.org)' >&2
  exit 1
fi

temp_dir=$(mktemp -d "$output_dir/.diseno-export.XXXXXX")
trap 'rm -rf "$temp_dir"' EXIT HUP INT TERM
temp_output=$temp_dir/output.png

case "$renderer" in
  rsvg)
    rsvg-convert --format=png --output="$temp_output" "$input"
    ;;
  inkscape)
    inkscape "$input" --export-type=png --export-filename="$temp_output"
    ;;
esac

if [ ! -s "$temp_output" ]; then
  printf 'Error: el conversor no generó un PNG válido.\n' >&2
  exit 1
fi

png_signature=$(od -An -tx1 -N8 "$temp_output" | tr -d ' \n')
if [ "$png_signature" != 89504e470d0a1a0a ]; then
  printf 'Error: el archivo generado no tiene una firma PNG válida.\n' >&2
  exit 1
fi

mv -f "$temp_output" "$output"
printf 'PNG generado: %s\n' "$output"

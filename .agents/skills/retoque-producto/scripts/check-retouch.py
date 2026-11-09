#!/usr/bin/env python3
"""Compare product-region exposure and contrast in a source and retouched image."""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

import numpy as np
from PIL import Image

CLIPPING_DELTA_LIMIT_PP = 0.1
MEDIAN_LUMINANCE_DELTA_LIMIT = 8.0
CONTRAST_DROP_LIMIT_PERCENT = 10.0


def load_rgb(path: Path) -> np.ndarray:
    with Image.open(path) as image:
        return np.asarray(image.convert("RGB"), dtype=np.uint8)


def load_mask(path: Path, image_shape: tuple[int, int]) -> np.ndarray:
    with Image.open(path) as image:
        mask = np.asarray(image.convert("L"), dtype=np.uint8)
    if mask.shape != image_shape:
        raise ValueError(
            f"la máscara {path} mide {mask.shape[1]}x{mask.shape[0]}, "
            f"pero su imagen mide {image_shape[1]}x{image_shape[0]}"
        )
    foreground = mask >= 128
    if not np.any(foreground):
        raise ValueError(f"la máscara {path} no contiene píxeles de producto")
    return foreground


def measure(rgb: np.ndarray, mask: np.ndarray) -> dict[str, float]:
    pixels = rgb[mask]
    luminance = (
        0.2126 * pixels[:, 0].astype(np.float32)
        + 0.7152 * pixels[:, 1].astype(np.float32)
        + 0.0722 * pixels[:, 2].astype(np.float32)
    )
    return {
        "strict_clip_pct": float(np.any(pixels == 255, axis=1).mean() * 100),
        "near_white_pct": float(np.all(pixels >= 250, axis=1).mean() * 100),
        "median_luminance": float(np.median(luminance)),
        "contrast_range": float(np.percentile(luminance, 95) - np.percentile(luminance, 5)),
        "mask_pct": float(mask.mean() * 100),
    }


def save_mask_preview(rgb: np.ndarray, mask: np.ndarray, path: Path) -> None:
    base = Image.fromarray(rgb)
    tint = Image.new("RGB", base.size, (255, 0, 180))
    overlay = Image.composite(tint, base, Image.fromarray((mask * 90).astype(np.uint8)))
    path.parent.mkdir(parents=True, exist_ok=True)
    overlay.save(path)


def format_metrics(name: str, values: dict[str, float]) -> str:
    return (
        f"{name}: recorte estricto={values['strict_clip_pct']:.4f}%; "
        f"casi blanco={values['near_white_pct']:.4f}%; "
        f"luminancia mediana={values['median_luminance']:.2f}/255; "
        f"contraste P95-P5={values['contrast_range']:.2f}/255; "
        f"área enmascarada={values['mask_pct']:.2f}%"
    )


def main() -> int:
    parser = argparse.ArgumentParser(
        description=(
            "Compara recorte de luces y contraste dentro de máscaras del producto. "
            "La máscara debe ser PNG en escala de grises: producto blanco, fondo negro."
        )
    )
    parser.add_argument("source", type=Path, help="foto original")
    parser.add_argument("result", type=Path, help="foto retocada")
    parser.add_argument("--source-mask", required=True, type=Path, help="máscara de la foto original")
    parser.add_argument("--result-mask", required=True, type=Path, help="máscara de la foto retocada")
    parser.add_argument(
        "--preview-dir",
        type=Path,
        help="directorio opcional para guardar vistas con la máscara superpuesta en magenta",
    )
    args = parser.parse_args()

    try:
        source = load_rgb(args.source)
        result = load_rgb(args.result)
        source_mask = load_mask(args.source_mask, source.shape[:2])
        result_mask = load_mask(args.result_mask, result.shape[:2])
    except (OSError, ValueError) as error:
        print(f"Error: {error}", file=sys.stderr)
        return 2

    source_stats = measure(source, source_mask)
    result_stats = measure(result, result_mask)
    strict_clip_delta_pp = result_stats["strict_clip_pct"] - source_stats["strict_clip_pct"]
    near_white_delta_pp = result_stats["near_white_pct"] - source_stats["near_white_pct"]
    median_delta = result_stats["median_luminance"] - source_stats["median_luminance"]
    source_contrast = source_stats["contrast_range"]
    contrast_drop_pct = (
        max(0.0, (source_contrast - result_stats["contrast_range"]) / source_contrast * 100)
        if source_contrast > 0
        else 0.0
    )

    print(format_metrics("Original", source_stats))
    print(format_metrics("Retoque", result_stats))
    print(f"Cambio de píxeles con canal recortado: {strict_clip_delta_pp:+.4f} puntos porcentuales")
    print(f"Cambio de píxeles casi blancos: {near_white_delta_pp:+.4f} puntos porcentuales")
    print(f"Cambio de luminancia mediana: {median_delta:+.2f} niveles")
    print(f"Reducción del rango de contraste: {contrast_drop_pct:.2f}%")

    alerts = []
    if strict_clip_delta_pp > CLIPPING_DELTA_LIMIT_PP:
        alerts.append(
            f"los píxeles con algún canal recortado aumentaron más de {CLIPPING_DELTA_LIMIT_PP:.1f} puntos porcentuales"
        )
    if near_white_delta_pp > CLIPPING_DELTA_LIMIT_PP:
        alerts.append(
            f"los píxeles casi blancos aumentaron más de {CLIPPING_DELTA_LIMIT_PP:.1f} puntos porcentuales"
        )
    if median_delta > MEDIAN_LUMINANCE_DELTA_LIMIT:
        alerts.append(
            f"la luminancia mediana aumentó más de {MEDIAN_LUMINANCE_DELTA_LIMIT:.0f} niveles"
        )
    if contrast_drop_pct > CONTRAST_DROP_LIMIT_PERCENT:
        alerts.append(
            f"el rango de contraste cayó más de {CONTRAST_DROP_LIMIT_PERCENT:.0f}%"
        )

    if args.preview_dir:
        save_mask_preview(source, source_mask, args.preview_dir / "source-mask-preview.png")
        save_mask_preview(result, result_mask, args.preview_dir / "result-mask-preview.png")
        print(f"Revise las máscaras superpuestas en magenta en: {args.preview_dir}")

    if alerts:
        print("RESULTADO: REVISAR — " + "; ".join(alerts))
        return 1
    print("RESULTADO: SIN ALERTAS AUTOMÁTICAS; todavía requiere revisión visual.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

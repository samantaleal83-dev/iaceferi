---
name: retoque-producto
description: "Retoca fotos de productos de CEFERÍ para la tienda online, preservando fielmente el producto original."
user-invocable: true
---

# Retoque de fotos de producto de CEFERÍ

Prepare una foto existente de un producto como una imagen prolija, bien expuesta y lista para la tienda online. Resuelva el trabajo solicitado antes de entregar el archivo. Pregunte antes de editar solo cuando falte una preferencia necesaria que cambie materialmente el resultado o haya un elemento ambiguo que no pueda identificarse con seguridad. Nunca sobrescriba ni altere el original.

## Fidelidad del producto

- Conserve exactamente la identidad y los rasgos visibles del producto: silueta, proporciones, color, materiales, costuras, texturas, herrajes, grabados, marcas, piezas y accesorios.
- No invente, elimine, reemplace ni rediseñe partes. No cambie el color para que coincida con una descripción o con otra foto.
- No agregue texto, etiquetas, logotipos, marcas de agua, accesorios ni elementos que parezcan venir incluidos con el producto.
- Si no puede conservarse con claridad un detalle del producto, no lo reconstruya por suposición: deténgase y avise qué dato o foto de referencia hace falta.
- Corrija moderadamente la exposición cuando sea necesario para una foto de catálogo equilibrada. Priorice conservar detalle y textura en las altas luces y las sombras, color natural y contraste que mantenga el volumen. No interprete «clara» como subir el brillo indiscriminadamente: evite luces quemadas, pérdida de textura, aspecto lavado, iluminación frontal dura y efecto de clave alta. La exposición del producto puede ajustarse junto con el fondo; una corrección de fondo no justifica sobreexponerlo.
- Mantenga la pose, orientación, perspectiva, pliegues, encuadre y ubicación de cada parte del producto; no lo rote ni lo reacomode para normalizar la composición.
- No sugiera ni insista en que la persona retoque las fotos manualmente, use Photoshop u otra herramienta, ni presente el retoque manual como alternativa o requisito. La persona puede decidir por su cuenta qué hacer fuera del skill; céntrese en realizar el retoque solicitado y en informar con claridad sus resultados y limitaciones.

## Preparación por defecto para la tienda

- Si no se indica otro color de fondo, use siempre un fondo uniforme de color exacto `#f6f6f6`. Si la persona solicita explícitamente otro color, respete esa indicación. Evite el blanco puro y una iluminación de clave alta; exponga el producto de forma equilibrada y natural, conservando el detalle de luces y sombras, el contraste y el volumen, con una sombra de apoyo suave y realista.
- No imponga una proporción por defecto: conserve la proporción y el encuadre de la fuente salvo que la persona solicite otro formato. Si pide un formato vertical, horizontal o cuadrado, adapte preferentemente el lienzo extendiendo el fondo, sin rotar, reubicar ni recortar el producto. Para una composición circular, mantenga el producto completo dentro del área circular; el PNG de salida seguirá teniendo un lienzo rectangular, salvo que se solicite explícitamente transparencia.
- Mantenga cualquier rasgo visible del fondo que sea parte del producto; separe solo el fondo externo. Si la foto no permite distinguirlos con seguridad, conserve la escena y pregunte antes de eliminar elementos ambiguos.
- No afirme que la imagen cumple un tamaño, peso o formato específico de Tiendanube sin verificarlo. Conserve el PNG que genera la herramienta salvo que se solicite explícitamente otro formato.

## Cómo trabajar

1. Identifique la ruta de la foto fuente. Si la persona no la proporcionó o la ruta no existe, solicítela; no elija otra foto por su cuenta.
2. Si hay varias fotos del mismo producto y la persona especifica una, use exactamente esa. Si solicita una imagen principal a partir de varias referencias, utilice las demás únicamente para verificar detalles y no combine variantes distintas del producto.
3. Si no se especifican cambios, aplique el preparado por defecto para la tienda, incluida la corrección moderada de exposición cuando haga falta, y conserve la proporción de la foto fuente. Si la persona indica un destino pero no una proporción y la elección afecta el encuadre, pregunte su preferencia.
4. Genere la imagen con `bash .agents/skills/retoque-producto/scripts/retocar-foto.sh "RUTA_DE_ENTRADA" "RUTA_DE_SALIDA.png" "INSTRUCCIONES_ADICIONALES"`, desde la raíz del proyecto. El script usa la foto fuente como entrada, permite el ajuste de exposición descrito arriba y cambia el fondo externo según las instrucciones. La ruta de salida es opcional; si se omite, crea `fotos-productos/retocadas/<carpeta-del-producto>/<nombre>-tienda.png`. Si la salida ya existe, el script se detiene: elija otra ruta para no sobrescribirla.
5. El script usa `gpt-image-2.5-sunburst` con calidad máxima mediante el endpoint de edición de imágenes y requiere `OPENAI_API_KEY` en el entorno o en `.env`, además de `curl`, `jq` y `base64`. No muestre ni copie credenciales.
6. Cuando haya una herramienta de segmentación automática disponible, obtenga con ella máscaras del producto para la foto fuente y el resultado. Cada máscara debe ser PNG en escala de grises y del mismo tamaño que su imagen: producto, herrajes y accesorios en blanco; fondo y sombras proyectadas en negro. Revise las previsualizaciones y use las máscaras solo si representan razonablemente el producto. No trace máscaras manualmente para este control. Si no hay segmentación automática confiable, indique que la medición de exposición es inconclusa; no use métricas de imagen completa para aprobar el resultado.
7. Si las máscaras son confiables, evalúe brillo y contraste con `python3 .agents/skills/retoque-producto/scripts/check-retouch.py "RUTA_DE_ENTRADA" "RUTA_DE_SALIDA.png" --source-mask "MASCARA_ORIGINAL.png" --result-mask "MASCARA_RETOCADA.png" --preview-dir "DIRECTORIO_TEMPORAL"`. El control compara píxeles con algún canal recortado a 255, píxeles casi blancos (RGB ≥250 en los tres canales), luminancia mediana y rango `P95 − P5`. Sus umbrales son heurísticos, no estándares universales. Un aumento de luminancia puede ser una corrección válida; una alerta requiere revisión visual, no implica rechazo automático. Determine si el resultado tiene exposición equilibrada, sin luces quemadas ni pérdida de detalle.
8. Compare visualmente el resultado con la fuente antes de entregarlo: pose, orientación, perspectiva, contorno, pliegues, costuras, herrajes, accesorios, color, exposición, contraste y sombras. No presente como satisfactorio un resultado con altas luces quemadas, pérdida visible de textura o detalle, apariencia lavada, iluminación frontal dura o efecto de clave alta.
9. Nunca elimine ni sobrescriba un resultado generado por considerarlo malo, incorrecto o incompleto. Mantenga el PNG en su ruta de salida, incluso si no cumple los criterios de fidelidad; distinga claramente entre un archivo conservado para inspección y un retoque satisfactorio. No borre resultados generados durante una revisión.
10. No afirme que se preservaron detalles que no pudo comparar. Si la generación alteró la geometría o detalles visibles, o si no puede validar la fidelidad, conserve el PNG y comunique concretamente la limitación; no lo presente como satisfactorio ni lo regenere automáticamente. Si falta una preferencia necesaria para continuar, pregunte de forma concreta.

## Entrega

Limite la respuesta a lo pertinente para el retoque solicitado y su resultado. No agregue aclaraciones sobre acciones ajenas al pedido ni sobre pasos que no se realizaron, salvo que sean necesarios para explicar una limitación del resultado. Indique la ruta del archivo generado y resuma brevemente qué retoques se aplicaron y qué comprobaciones realizó. No traslade a una etapa posterior las decisiones necesarias para completar el trabajo. No diga que se subió a la tienda: indique que el archivo quedó guardado localmente. Si el resultado no es satisfactorio, conserve el PNG, comparta su ruta, describa el problema sin presentarlo como aceptable y pregunte solo lo necesario para saber cómo continuar.

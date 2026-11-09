# Ceferi AI Tool Kit

Conjunto de herramientas IA para administrar https://ceferimates.com/

## Contenido

Actualmente hay seis skills, en el formato Agent Skills para que los asistentes compatibles puedan descubrirlas:

- [Community Manager](.agents/skills/community/SKILL.md)
- [Anuncios de conversión](.agents/skills/anuncios/SKILL.md)
- [Diseño de piezas para redes sociales](.agents/skills/diseno/SKILL.md)
- [Inventario](.agents/skills/inventario/SKILL.md)
- [Fotógrafo de producto e Instagram](.agents/skills/fotografo/SKILL.md)
- [Retoque de fotos de producto](.agents/skills/retoque-producto/SKILL.md)

En VS Code, Cursor y otros asistentes compatibles, invocalas desde el chat con `/community`, `/anuncios`, `/diseno`, `/inventario`, `/fotografo` o `/retoque-producto`. OpenCode incluye los comandos disponibles en `.opencode/commands/`.

## Ejemplos de uso

### Community Manager

Invocá `/community` y agregá tu pedido. Algunos ejemplos:

1. **Planificar contenido:** `/community Armá un calendario de publicaciones para Instagram de dos semanas. Quiero mostrar las materas y también darle visibilidad al resto del catálogo actual. Poné cada copy, texto en pantalla y CTA listo para publicar dentro de bloques de código cercados con triple acento grave.`
2. **Crear una pieza:** `/community Escribí un guion breve para un reel que cuente cómo CEFERÍ empezó con los mates y hoy está poniendo el foco en el cuero. No anuncies productos nuevos ni fechas de lanzamiento. Entregá el guion listo para publicar en un bloque de código cercado con triple acento grave.`
3. **Responder consultas:** `/community Redactá una respuesta amable para alguien que pregunta por el precio y los colores disponibles de una matera. No tengo esos datos confirmados; ofrecé verificarlos. Poné la respuesta lista para enviar dentro de un bloque de código cercado con triple acento grave.`

### Anuncios de conversión

Invocá `/anuncios` y agregá tu pedido. Algunos ejemplos:

1. **Anuncio para compra:** `/anuncios Creá un anuncio para Instagram que lleve a comprar una matera en ceferimates.com. No tengo una promoción activa; indicá qué información falta para publicarlo.`
2. **Anuncio para consultas:** `/anuncios Proponé un anuncio para Facebook que invite a consultar por las materas disponibles. Incluí copy, título, CTA y destino, sin inventar precios ni stock.`
3. **Variantes para probar:** `/anuncios Prepará dos enfoques de anuncio para una matera disponible: uno centrado en el uso cotidiano y otro en la idea de regalo. Explicá qué hipótesis prueba cada uno y no prometas resultados.`

### Diseño de piezas para redes sociales

Invocá `/diseno` para crear piezas visuales listas para revisar o publicar en `piezas/`. Algunos ejemplos:

1. **Crear un post:** `/diseno Diseñá un single post para el feed de Instagram que cuente que el cuero será el nuevo eje de CEFERÍ sin borrar su historia matera. Entregá el PNG final listo para revisar.`
2. **Crear un carrusel:** `/diseno Armá un carrusel de cuatro placas sobre el origen matero de CEFERÍ. Usá las fotos existentes en piezas/nuestra-historia-matera y agregá una página HTML para previsualizarlo.`
3. **Adaptar una pieza:** `/diseno Adaptá este diseño a una historia de Instagram. Mantené el texto dentro del área segura y no agregues información comercial que no esté confirmada.`

### Retoque de fotos de producto

Invocá `/retoque-producto` para preparar imágenes de producto para la tienda online. Se conserva el original y la imagen nueva queda en `fotos-productos/retocadas/`.

1. **Preparar una imagen de catálogo:** `/retoque-producto Crea una foto lista para subir al sitio a partir de fotos-productos/matera-patagonia-cemento/1.jpg`
2. **Indicar ajustes:** `/retoque-producto Retocá fotos-productos/Mate Imperial.png para catálogo. Conservá el color real y usá fondo claro sin agregar accesorios.`

### Crítica de fotos de producto e Instagram

Invocá `/fotografo` para recibir observaciones y recomendaciones concretas sobre una foto que compartas, ya sea para mejorar la toma o evaluar su uso en Instagram.

1. **Revisar una toma:** `/fotografo Revisá esta foto de producto. Decime qué funciona y qué cambiarías al volver a sacarla.`
2. **Evaluar para Instagram:** `/fotografo Criticá esta foto para un carrusel de Instagram: fijate si el producto se entiende en pantalla chica y qué ajustes de encuadre o luz probarías.`

---
name: diseno
description: "Diseña y genera piezas visuales para las redes sociales de CEFERÍ: posts, carruseles, historias y portadas. Entrega siempre el PNG final. Use when creating social media graphics, visual assets, or adapting a design to social formats."
user-invocable: true
---

# Diseño de piezas para redes sociales de CEFERÍ

Convierte una idea de comunicación en una pieza visual clara, atractiva y lista para revisar o publicar. Cuando el pedido sea crear una pieza, genera y entrega siempre el PNG final, aunque no lo pidan expresamente. El SVG se usa solo como archivo intermedio para exportar: no lo guardes dentro de `piezas/` ni lo incluyas entre los entregables. Si piden solo una dirección creativa o una auditoría, entrega eso sin crear archivos.

## Contexto de marca

- CEFERÍ es una marca argentina que está evolucionando desde los mates y accesorios materos hacia los artículos de cuero. Acompaña la transición sin borrar la historia matera.
- La voz es cercana, informal y argentina; usa voseo de forma natural.
- La paleta de marca es `#5f4a43`, `#7d736a`, `#d6cec4`, `#f2ece6` y `#fafafa`.
- Las tipografías son Tenor Sans para títulos y DM Sans para textos de apoyo. Decláralas en los SVG con alternativas sans-serif para que la pieza siga siendo legible si no están instaladas.
- El catálogo vigente y sus datos pueden cambiar. Confirma la disponibilidad y los detalles comerciales con la información actual del proyecto o con la persona; no inventes precios, stock, promociones, características, materiales, procesos ni fechas de lanzamiento.
- Los modelos de cuero proyectados son ideas futuras hasta que CEFERÍ confirme que están disponibles. No los representes como productos ya lanzados.
- Para inspirarte, revisa las piezas existentes en `piezas/` y reutiliza recursos del proyecto solo si son adecuados para el pedido. No reemplaces ni edites diseños existentes salvo que te lo pidan.

## Formatos y dimensiones

Usa estas medidas recomendadas, coherentes con el skill `/community`:

- Single post para feed o placa de carrusel: `1080 × 1350 px` (4:5). Mantén todas las placas de un carrusel en la misma medida y proporción.
- Historia, secuencia de historias o lienzo de Reel: `1080 × 1920 px` (9:16).
- Portada de Reel: `1080 × 1920 px` (9:16); conserva el texto y los elementos esenciales dentro de la zona central de `1080 × 1440 px` (3:4) para la vista de perfil.
- Si se adapta una pieza a otros canales o ubicaciones, revisa sus requisitos actuales y crea versiones separadas cuando el recorte pueda afectar el contenido.

## Templates visuales obligatorios

Toda pieza visual nueva debe partir de uno de estos cuatro templates. Son estructuras reutilizables basadas en los patrones observados en el feed de CEFERÍ; mantienen una identidad común sin obligar a que todas las piezas tengan la misma composición. Se pueden adaptar al tamaño o canal solicitado, conservando su estructura reconocible.

1. **Foto protagonista + titular:** fotografía del producto, material o escena como fondo o elemento dominante; titular breve y de alto contraste sobre la foto; logo discreto en una zona despejada. Úsalo para presentar productos, escenas de uso o mensajes emocionales.
2. **Placa editorial:** fondo liso de la paleta, jerarquía tipográfica marcada, texto corto y opcionalmente una foto de producto recortada o pequeña. Úsalo para consejos, mensajes de marca, regalos o ideas que necesitan espacio para leerse.
3. **Composición dividida foto + texto:** divide el lienzo entre una fotografía y un área editorial limpia; el texto va en el área limpia y la foto muestra el producto o contexto. Úsalo cuando haga falta explicar una idea y mostrar el producto sin cubrirlo con texto.
4. **Carrusel informativo o de pasos:** portada con una pregunta o promesa concreta, placas interiores con una idea o paso cada una, numeración o etiquetas discretas y cierre con CTA. Úsalo para guías, comparaciones y explicaciones secuenciales; mantén consistentes las dimensiones, márgenes y jerarquía de todas las placas.

Aplica la paleta aprobada, las fuentes declaradas, márgenes amplios, texto legible en móvil y una ubicación discreta y consistente para el logo cuando se disponga del archivo correcto. La captura de referencia sirve para inferir la dirección visual, no para fijar colores exactos, tipografías, medidas de margen ni versiones del logo; no afirmes esos detalles como reglas verificadas. No inventes ni sustituyas un logo. No agregues colores fuera de la paleta salvo que la fotografía los aporte.

**Templates reutilizables por tipo de publicación:** cada archivo de plantilla empieza por el tipo/ubicación para el que está hecho. Usá la base correspondiente y adaptala al template visual elegido; los SVG originales del skill no se modifican.

- **Feed (single post):** [`templates/feed-foto-protagonista-titular.svg`](./templates/feed-foto-protagonista-titular.svg) y [`templates/feed-placa-editorial.svg`](./templates/feed-placa-editorial.svg), 1080 × 1350 px.
- **Reel (portada):** [`templates/reel-portada-placa-editorial.svg`](./templates/reel-portada-placa-editorial.svg), 1080 × 1920 px, con elementos esenciales en la zona central segura de 1080 × 1440 px. Para un video de Reel, este SVG sirve como guía de portada, no como plantilla de edición del video.
- **Carrusel:** [`templates/carrusel-placa-editorial.svg`](./templates/carrusel-placa-editorial.svg), 1080 × 1350 px por placa; duplicala para cada placa y mantené consistentes dimensiones, márgenes y jerarquía.
- **Historia:** [`templates/historia-placa-editorial.svg`](./templates/historia-placa-editorial.svg), 1080 × 1920 px, con zonas libres para la interfaz de la plataforma.

Si el tipo de publicación solicitado no tiene una base en esta lista, crea una plantilla reutilizable con el prefijo del tipo (por ejemplo, `tipo-nombre-del-template.svg`) y las dimensiones verificadas para su ubicación antes de generar la pieza. No uses un nombre genérico sin identificar el tipo.

## Copy para anuncios

Cuando la pieza sea un anuncio, separa el **gancho** del **dato que identifica el producto**:

- Usa como titular una idea concreta que conecte el producto y la imagen con una situación de uso, deseo o necesidad de la audiencia. No uses por defecto el nombre del producto, su color o una característica descriptiva como gancho: esos datos pueden ir en una línea secundaria si ayudan a reconocerlo.
- Evita frases genéricas o intercambiables que no aporten una razón para detenerse, como “El ritual, siempre cerca”, salvo que el resto de la pieza las vuelva específicas y relevantes.
- Basa el gancho en el objetivo de campaña, la foto y los datos confirmados del producto. No prometas beneficios, resultados, atributos ni condiciones comerciales que no estén verificados. Si no hay suficiente información para proponer un gancho concreto sin inventar, consulta antes de cerrar el copy.
- Si existen notas de campaña en el proyecto, úsalas para respetar el objetivo y el destino del anuncio. Incluye una llamada a la acción coherente con ese objetivo cuando corresponda.
- Antes de exportar, comprueba que el titular resulte más atractivo que una etiqueta de catálogo, que el producto siga siendo identificable y que cada afirmación esté respaldada.

**Selección obligatoria antes de diseñar:** registra cuál template se usará en cada pieza.
- Si la persona indica un template por nombre o descripción, úsalo.
- Si no lo indica y la elección afecta sustancialmente la propuesta, pregunta cuál prefiere y recomienda uno según el objetivo. Presenta nombres y descripciones breves de las opciones pertinentes.
- Si la persona delega la decisión, pide avanzar sin aclaraciones, o el contenido determina claramente la estructura, elige el template más adecuado y menciona brevemente la elección y el motivo.
- No detengas un pedido claro por una pregunta innecesaria; selecciona y declara el template elegido. No entregues una pieza visual fuera de estos cuatro templates sin autorización explícita de la persona.

## Procedimiento

1. Define el objetivo, el canal, el formato, la audiencia y el mensaje principal. Si la persona no especifica canal o formato, usa Instagram y el formato que mejor se ajuste al contenido, dejando explícito ese supuesto.
2. Selecciona obligatoriamente uno de los cuatro templates según las reglas de selección anteriores. Pregunta por preferencia solo si la decisión importa y no se puede inferir; en los demás casos, elígelo y di cuál.
3. Pregunta solo por datos que cambien sustancialmente la pieza, como el producto que debe aparecer, una promoción o una foto específica. Si puedes avanzar sin riesgo, marca los pendientes como `[confirmar ...]` y evita convertirlos en hechos.
4. Aplica la estructura del template elegido con una jerarquía clara: una idea principal, texto breve y legible, un elemento visual de apoyo y, si corresponde, un CTA. Deja márgenes suficientes para que el contenido no quede al borde ni sea tapado por la interfaz de la plataforma.
5. Guarda los entregables como archivos locales dentro de `piezas/<tipo>-<nombre-descriptivo>/` para no mezclar la nueva entrega con proyectos existentes. El objetivo es que el PNG quede creado en esa carpeta del proyecto, no que se ofrezca como archivo para descargar ni que se suba a un servidor. El nombre de cada archivo de la pieza también debe empezar por el tipo de publicación: por ejemplo, `piezas/reel-mate-criollo-portada/reel-portada.png`, `piezas/carrusel-rituales-materos/carrusel-01.png` y `piezas/carrusel-rituales-materos/carrusel-preview.html`. Usa un prefijo inequívoco y consistente (`reel-`, `carrusel-`, `feed-`, `historia-` o el tipo correspondiente); aplica el mismo prefijo al SVG intermedio, que debe guardarse fuera de `piezas/`. Crea cada diseño como un SVG intermedio y expórtalo a PNG con [el script de exportación](./scripts/export-instagram-png.sh), que conserva las dimensiones del lienzo SVG. Pasa la ruta del PNG de destino como segundo argumento, verifica que se haya generado correctamente y elimina el SVG intermedio; en `piezas/` debe quedar el PNG final, no el SVG. En carruseles, guarda un PNG por placa y un HTML de previsualización con prefijo `carrusel-` para verlas juntas. Ejecuta `sh .agents/skills/diseno/scripts/export-instagram-png.sh ruta/temporal/<tipo>-placa.svg piezas/<tipo>-<nombre-descriptivo>/<tipo>-01.png` desde la raíz del proyecto. El script requiere `rsvg-convert` (librsvg) o, como alternativa, Inkscape; si ninguno está instalado, informa el error y cómo instalar un conversor, y no presentes el SVG como si fuera el PNG final.
6. Si hay fotos o recursos aprobados en el proyecto, enlázalos con rutas relativas y conserva los originales. No inventes fotos de productos ni alteres detalles de producto de manera que puedan inducir a error. Si falta una imagen necesaria, crea una composición tipográfica o vectorial adecuada, o deja un marcador claro para reemplazarla.
7. Escribe el texto en español argentino natural. Revisa ortografía, contraste, tamaño, legibilidad en móvil y coherencia de la secuencia. No sobrecargues la pieza con copy, adornos, emojis o hashtags.
8. Antes de borrar cada SVG intermedio, verifica sus dimensiones y proporción, que las fuentes tengan alternativas y que las imágenes enlazadas existan. Confirma que se haya generado un PNG por pieza, que cada archivo conserve las dimensiones del lienzo correspondiente y que la previsualización apunte a todos los PNG correctos. Para una adaptación de varias ubicaciones, revisa cada versión por separado.

## Entrega

Resume el objetivo visual, el template elegido, el formato y las dimensiones, y confirma que el PNG final quedó guardado localmente en `piezas/`. Puedes enlazar su ruta local para ubicarlo en el proyecto, pero no lo presentes como descarga ni digas “descargar”: no se está subiendo a ningún servidor. No enlaces ni entregues los SVG intermedios. Para carruseles, indica cuántas placas incluye y dónde se previsualizan. Señala cualquier dato o recurso pendiente de confirmar. Si también redactas un copy para acompañar la pieza, entrégalo por separado de los textos incluidos en el diseño.

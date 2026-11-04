# Checklist para hacer un anuncio en Instagram

## Antes de empezar

- [x] Definir qué querés lograr: vender, recibir consultas o llevar visitas a la tienda.
- [x] Elegir el producto y confirmar disponibilidad, precio y condiciones.
- [x] Definir a quién querés llegar.
- [x] Definir el presupuesto y la duración de la campaña.
- [x] Elegir dónde se mostrará el anuncio: feed, Stories o Reels.
- [x] Preparar la creatividad para feed de **1080 × 1350 px (4:5)**.
- [x] Definir el texto del anuncio.
- [x] Definir adónde llevará el anuncio: tienda online, página del producto o mensaje.
- [x] Definir si el anuncio también se mostrará en Stories o Reels y preparar una versión vertical de **1080 × 1920 px (9:16)** si corresponde.

## Elegir una sola forma de crear el anuncio

Complete **una sola** de las siguientes opciones. Si la opción elegida crea el anuncio correctamente, omita las otras dos.

### Opción A: crear el anuncio con la API

- [ ] Pida al agente los parámetros necesarios para crear y vincular la campaña y sus anuncios con la [API de Meta](https://developers.facebook.com/documentation/ads-commerce/marketing-api/). No comparta credenciales en el chat.
- [ ] Configure `META_ACCESS_TOKEN` y `META_AD_ACCOUNT_ID` en el entorno y ejecute `./.agents/skills/anuncios/scripts/meta-marketing-api-create.sh` desde la terminal. Cada ejecución crea un objeto en Meta y pide confirmación; repita para crear y vincular la campaña completa. Los anuncios quedan pausados. Al terminar, ejecute `unset META_ACCESS_TOKEN`.

### Opción B: crear una campaña en Meta Ads Manager (sitio web de Meta)

Use esta opción si no puede completar la creación con la API.

- [ ] En un navegador, entre al [sitio web de Meta Ads Manager](https://adsmanager.facebook.com/) e inicie sesión en Meta. Abra **Crear** e inicie una campaña nueva.
- [ ] Seleccione el objetivo y configure audiencia, presupuesto, duración y ubicaciones. Elija Instagram si quiere limitar la campaña a esa plataforma.
- [ ] En el anuncio, seleccione la cuenta de Instagram, cargue la creatividad y agregue el texto, la llamada a la acción y el destino.
- [ ] Revise la vista previa y publique la campaña para revisión de Meta.

### Opción C: promocionar una publicación existente

Use esta opción en lugar de crear una campaña nueva si el anuncio será una publicación o reel ya publicado.

- [ ] Abra la publicación o reel en Instagram y toque **Promocionar**.
- [ ] Elija el resultado, la audiencia, el presupuesto y la duración.
- [ ] Revise el destino y la vista previa; después, envíe la promoción a revisión.

## Revisión final

- [ ] Confirmar que el anuncio cumple las [Normas de publicidad de Meta](https://transparency.meta.com/policies/ad-standards/).
- [ ] Comprobar en Meta Ads Manager si fue aprobado y revisar cómo funciona.

------

## Decisiones campaña 1 de noviembre de 2026

- **Objetivo:** vender materas disponibles desde la tienda online de CEFERÍ.
- **Producto:** Matera Patagonia color Cemento. Se eligió una matera porque las compras online observadas se concentran en esa categoría. En el CSV de Tiendanube figura visible y con stock 4; no implica que sea la más vendida.
- **Precio y stock:** el CSV de Tiendanube indica $130.000 y 4 unidades.
- **Audiencia (hipótesis para probar):** personas adultas de Argentina, con segmentación amplia. La marca vende en todo el país, pero no hay datos de audiencia que justifiquen acotarla por intereses o demografía.
- **Ubicación:** solo feed de Instagram; se decidió no incluir Stories ni Reels en esta campaña. Para esta primera prueba de un solo producto, concentraremos la creatividad en una imagen vertical 4:5 que permita mostrar la matera con claridad. Es una decisión práctica de producción, no una afirmación de que el feed convierta mejor.
- **Creatividad:** [matera Patagonia color Cemento](./piezas/feed-matera-patagonia-cemento/feed-matera-patagonia-cemento.png), imagen para feed de 1080 × 1350 px (4:5).
- **Destino:** [página de la Matera Patagonia color Cemento](https://www.ceferimates.com/productos/matera-patagonia-color-cemento/).
- **Texto del anuncio:**

  ```text
  ¿Matera solo para el mate? La Patagonia tiene lugar para mucho más.

  Además del termo, mate, yerbera y bombilla, podés sumar esos básicos que siempre van con vos: agenda, galletitas, anteojos, llaves, auriculares y más.

  Con 37 cm de ancho, 26 cm de alto y 14 cm de base, tenés espacio para organizar todo en un mismo lugar y salir sin cargar de más.

  ¿Qué llevarías vos además del equipo matero? Te leemos en comentarios.

  📍 CEFERÍ MATES
  🌐 ceferimates.com
  📩 ceferimates@gmail.com

  #materas #materapatagonia #comunidadmatera #equipomatero #ceferimates
  ```
- **Presupuesto y duración:** $70.000 ARS en total durante 7 días ($10.000 ARS por día). Es una inversión inicial acotada para probar el anuncio de un producto de $130.000; no garantiza ventas ni define por sí sola la rentabilidad.

Comando para crear **solo el objeto campaña** mediante la API. Requiere `META_ACCESS_TOKEN` y `META_AD_ACCOUNT_ID` configurados en el entorno; al ejecutarlo, confirme la solicitud cuando se le pida. La campaña queda pausada. Después hay que crear y vincular el conjunto de anuncios, la creatividad y el anuncio.

```bash
./.agents/skills/anuncios/scripts/meta-marketing-api-create.sh \
  --edge campaigns \
  --field 'name=CEFERI - Matera Patagonia Cemento - 2026-11-01' \
  --field 'objective=OUTCOME_SALES' \
  --field 'special_ad_categories=[]' \
  --field 'status=PAUSED'
```

Meta permite definir presupuesto diario o total y duración; el costo depende de la configuración y de la subasta. Ver [información de Meta sobre costos publicitarios](https://www.facebook.com/business/help/201828586525529) y [cómo crear anuncios](https://www.facebook.com/business/ads).

## Escenarios de ventas de la campaña e inventario

La tabla muestra cuántas **unidades se venderían como resultado del anuncio** en distintos escenarios; no es una lista de compras a realizar. No hay datos de campañas previas para pronosticar las ventas. El costo por venta se calcula dividiendo el presupuesto de $70.000 por las unidades vendidas. La ganancia bruta se calcula como ingresos menos el costo de las unidades vendidas; el resultado tras anuncios resta además el presupuesto completo. No incluye comisiones, impuestos, embalaje, envío ni otros costos. Precio, costo y stock salen del [CSV de Tiendanube](./tiendanube-7667212-1793566139895140066434274561.csv).

| Unidades vendidas por la campaña (escenario) | Producto | Costo por venta estimado | Ingreso por ventas | Ganancia bruta (antes de anuncios) | Resultado tras anuncios (antes de otros costos) | Stock restante de las 4 unidades |
|---:|---|---:|---:|---:|---:|---:|
| 0 | Matera Patagonia color Cemento | No aplica | $0 | $0 | -$70.000 | 4 unidades |
| 1 | Matera Patagonia color Cemento | $70.000 | $130.000 | $92.000 | $22.000 | 3 unidades |
| 2 | Matera Patagonia color Cemento | $35.000 | $260.000 | $184.000 | $114.000 | 2 unidades |
| 3 | Matera Patagonia color Cemento | $23.333 | $390.000 | $276.000 | $206.000 | 1 unidad |

**Stock registrado:** 4 unidades. La campaña cubre su presupuesto con una venta en este cálculo antes de otros costos; el margen real puede ser menor. Estos son escenarios, no una predicción de ventas.

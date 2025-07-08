# junkTrade - Addon para Ashita v4

`junkTrade` es un addon para Ashita v4 diseñado para automatizar la entrega de ítems "basura" (junk) a un NPC. El addon lee una lista de ítems predefinida, busca esos ítems en tu inventario y los entrega uno por uno al NPC que tengas seleccionado como objetivo.

## Características

- **Entrega automatizada**: Entrega ítems de una lista personalizable de forma automática.
- **Fácil de usar**: Funciona con un solo comando para iniciar y detener el proceso.
- **Entrega individual**: Entrega los ítems uno por uno, ideal para NPCs que solo aceptan un ítem a la vez (como los de reputación o para conseguir sellos de conquista).
- **Retraso configurable**: Incluye un retraso entre cada entrega para evitar problemas con el servidor.
- **Notificaciones en el chat**: Te mantiene informado sobre el progreso, los ítems encontrados y cuándo finaliza el proceso.

## Instalación

1.  Descarga los archivos del addon.
2.  Crea una carpeta llamada `junkTrade` dentro de tu directorio `Ashita\addons\`.
3.  Copia los archivos `junkTrade.lua` y `junk_list.lua` dentro de la nueva carpeta `Ashita\addons\junkTrade\`.
4.  Inicia el juego y carga el addon con el siguiente comando:
    ```
    /addon load junktrade
    ```

## Configuración

Para definir qué ítems quieres entregar, debes editar el archivo `junk_list.lua` con cualquier editor de texto.

1.  Abre el archivo `c:\Games\catseyeffxi\catseyexi-client\Ashita\addons\junkTrade\junk_list.lua`.
2.  Añade o elimina los nombres de los ítems de la lista.

**Importante**: El nombre del ítem debe ser **exacto**, incluyendo mayúsculas, espacios y símbolos, tal como aparece en el juego.

**Ejemplo de `junk_list.lua`:**
```lua
return {
    'Goblin Mask',
    'Tin Ore',
    'Rabbit Hide',
    'Bone Chip',
    -- Añade más ítems aquí, entre comillas y separados por comas.
    -- Ejemplo: 'Copper Ore',
}
```

### Cambiar el retraso (Opcional)

Por defecto, el addon espera 3 segundos entre cada entrega. Si deseas cambiar este valor:
1.  Abre `junkTrade.lua`.
2.  Busca la línea `local TRADE_DELAY = 3.0`.
3.  Cambia el valor `3.0` por el número de segundos que desees.

## Uso

1.  Asegúrate de que el addon `junkTrade` está cargado.
2.  Selecciona como objetivo (target) al NPC al que quieres entregar los ítems.
3.  Escribe uno de los siguientes comandos en el chat y presiona Enter:
    ```
    /junktrade
    ```
    o el alias más corto:
    ```
    /jt
    ```
4.  El addon escaneará tu inventario, te informará cuántos ítems va a entregar y comenzará el proceso.
5.  Para **detener** el proceso en cualquier momento, simplemente vuelve a escribir `/junktrade` o `/jt`.

### Notas Importantes

- El addon utiliza `<t>` (target) para la entrega. Asegúrate de tener al NPC correcto seleccionado **antes** de ejecutar el comando.
- El addon entrega los ítems de forma individual, no en stacks. Si tienes 12 `Tin Ore`, realizará 12 entregas separadas.
- El proceso se detendrá automáticamente si te quedas sin ítems de la lista o si lo detienes manualmente con el comando.

---
El uso de herramientas de terceros que automatizan acciones puede ir en contra de los Términos de Servicio de Final Fantasy XI. Utiliza este addon bajo tu propio riesgo. El autor no se hace responsable de ninguna acción disciplinaria que pueda ser tomada contra tu cuenta.

*Autor: Thunders*
*Versión: 1.0*
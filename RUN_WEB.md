# Ejecutar Flow en Web

Para mantener la persistencia de datos en IndexedDB durante el desarrollo web, es importante usar un puerto fijo. De lo contrario, cada vez que reinicies la app, Flutter usará un puerto diferente y perderás los datos.

## Comando Recomendado

```bash
cd /Users/fernando/Desarrollo/Flutter/flow
flutter run -d chrome --web-port=8080 --web-hostname=localhost
```

## ¿Por qué usar un puerto fijo?

IndexedDB (donde se almacenan los datos en web) es específico por **origen** (protocolo + dominio + puerto).

- ❌ `http://localhost:58042` - Origen A (base de datos A)
- ❌ `http://localhost:59123` - Origen B (base de datos B - datos diferentes)
- ✅ `http://localhost:8080` - Origen fijo (siempre la misma base de datos)

## Acceso Directo

También puedes usar el script incluido:

```bash
/tmp/flutter_run_chrome.sh
```

## Verificar Persistencia

1. Agrega actividades
2. Cierra Chrome **completamente**
3. Ejecuta de nuevo el comando con `--web-port=8080`
4. Abre `http://localhost:8080`
5. ✅ Los datos deberían estar ahí

## DevTools - Inspeccionar IndexedDB

1. Presiona F12 en Chrome
2. Ve a **Application → Storage → IndexedDB**
3. Busca `flow_app.db`
4. Verás las tablas: activities, people, visits, goals

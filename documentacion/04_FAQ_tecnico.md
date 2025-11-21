# ❓ FAQ Técnico - Preguntas Frecuentes

**Desafío de Machine Learning en Economía de la Salud**
**Universidad Nacional del Oeste - 2025**

---

## 📋 Índice de Problemas

1. [Instalación y Setup](#instalación-y-setup)
2. [Ejecución del Pipeline](#ejecución-del-pipeline)
3. [Feature Engineering](#feature-engineering)
4. [Configuración (YML)](#configuración-yml)
5. [Git y GitHub](#git-y-github)
6. [Resultados e Interpretación](#resultados-e-interpretación)
7. [Trabajo en Grupo](#trabajo-en-grupo)

---

## Instalación y Setup

### P1: ¿Cómo sé qué versión de R tengo instalada?

**R:**
Abrí RStudio y ejecutá:
```r
R.version.string
```

Deberías ver algo como: `"R version 4.4.x (...)"`

Si tenés una versión anterior a 4.0, actualizá R.

---

### P2: Error al instalar `lightgbm`: "compilation failed"

**Problema:**
```
ERROR: compilation of package 'lightgbm' failed
```

**Solución Windows:**
1. Instalá Rtools: https://cran.r-project.org/bin/windows/Rtools/
2. Reiniciá RStudio
3. Probá de nuevo:
```r
install.packages("lightgbm", type = "source")
```

**Solución Mac:**
```bash
# En la Terminal:
xcode-select --install

# Luego en R:
install.packages("lightgbm")
```

**Solución Linux:**
```bash
sudo apt-get install cmake build-essential
```

---

### P3: ¿Puedo usar la versión web de RStudio (RStudio Cloud)?

**Respuesta:** Sí, pero con limitaciones.

RStudio Cloud tiene límites de:
- RAM (1 GB en plan gratuito)
- CPU
- Horas de uso mensual

**Recomendación:**
- Usá RStudio Cloud solo para exploración inicial
- Para experimentos completos, usá RStudio Desktop

---

## Ejecución del Pipeline

### P4: El pipeline tarda mucho (>2 horas). ¿Es normal?

**Respuesta:** Depende del hardware.

**Tiempos normales:**
- Computadora básica (4GB RAM): 60-90 minutos
- Computadora media (8GB RAM): 30-45 minutos
- Computadora potente (16GB+): 15-25 minutos

**Si tarda más:**
1. Verificá que no haya otros programas consumiendo recursos
2. Reducí iteraciones de Bayesian Optimization (BO) en CONFIG_basico.yml
3. Consultá [Guía de Recursos Computacionales](03_guia_recursos_computacionales.md)

---

### P5: Error: "cannot allocate vector of size..."

**Problema:**
```
Error: cannot allocate vector of size 1.5 Gb
```

**Causa:** Memoria RAM insuficiente.

**Soluciones:**

1. **Cerrar aplicaciones:**
   - Cerrar Chrome, Spotify, Discord, etc.

2. **Limpiar memoria en R:**
```r
rm(list = ls())
gc()
```

3. **Ejecutar por etapas:**
   - Ejecutá solo Feature Engineering
   - Reiniciá R
   - Ejecutá solo Training Strategy
   - Etc.

4. **Pedir dataset reducido** (último recurso)

Ver: [Guía de Recursos Computacionales](03_guia_recursos_computacionales.md#optimizar-para-ram-limitada)

---

### P6: R se cierra solo / RStudio crashea

**Causas posibles:**
1. Memoria insuficiente
2. Error en el código (loop infinito, recursión)
3. Librería corrupta

**Soluciones:**

1. **Verificar memoria:**
   - Administrador de Tareas → ¿RAM al 100%?

2. **Reinstalar librerías:**
```r
remove.packages("lightgbm")
install.packages("lightgbm")
```

3. **Ejecutar en modo debug:**
```r
options(error = recover)
```

---

### P7: ¿Cómo sé si el pipeline está corriendo o se trabó?

**Indicadores de que está corriendo:**
- En Administrador de Tareas: CPU de R al 50-100%
- En RStudio: Icono de "STOP" (cuadrado rojo) está activo
- Consola muestra mensajes nuevos cada pocos minutos

**Indicadores de que se trabó:**
- CPU de R al 0% durante más de 10 minutos
- RStudio dice "Not Responding"
- Ningún mensaje nuevo en más de 15 minutos

**Solución si se trabó:**
1. Esperá 5 minutos más (por las dudas)
2. Si sigue trabado: Session → Interrupt R
3. Si no responde: Cerrar RStudio y volver a abrir

---

## Feature Engineering

### P8: ¿Cómo sé si mis variables se crearon correctamente?

**Verificación:**

Después de Feature Engineering, ejecutá:

```r
library(data.table)
dataset <- fread("exp/NOMBRE_EXPERIMENTO/01_FE/dataset_fe.csv")

# Ver nombres de columnas
colnames(dataset)

# Ver si tus variables están
"health_efficiency" %in% colnames(dataset)  # Cambiá por tu variable

# Ver primeras filas de tu variable
head(dataset$health_efficiency)

# Ver estadísticas
summary(dataset$health_efficiency)
```

---

### P9: Mi variable tiene muchos NA. ¿Es un problema?

**Depende:**

**Aceptable:**
- 10-30% de NAs → Normal (datos faltantes del World Bank)

**Problemático:**
- >50% de NAs → La variable probablemente no sea útil

**Verificación:**
```r
# Porcentaje de NAs
sum(is.na(dataset$mi_variable)) / nrow(dataset) * 100
```

**Solución si hay muchos NAs:**
- Usar otra variable base
- Imputar NAs con la mediana/media
- Eliminar esa variable

---

### P10: Error: "object 'dataset' not found" en 01_FE_health.R

**Causa:** Estás ejecutando `01_FE_health.R` directamente.

**Solución:**
NO ejecutes `01_FE_health.R` directamente. Este script es llamado por `0_HEALTH_EXE.R`.

**Forma correcta:**
1. Abrí `0_HEALTH_EXE.R`
2. Ejecutá TODO el script

---

### P11: ¿Puedo usar librerías adicionales en Feature Engineering?

**Respuesta:** Sí, pero...

**Requisitos:**
1. Documentá en el README qué librerías usaste
2. Agregá las instrucciones de instalación
3. NO uses librerías que requieran instalación compleja

**Ejemplo de librerías permitidas:**
```r
library(zoo)      # Para rolling windows
library(stringr)  # Para manipulación de strings
library(dplyr)    # Si preferís dplyr sobre data.table
```

**Ejemplo de NO permitidas:**
- Librerías que requieren Python
- Librerías que requieren Java
- Librerías no disponibles en CRAN

---

## Configuración (YML)

### P12: Error: "Scanner error" al leer CONFIG_basico.yml

**Problema:**
```
Error in yaml.load_file("CONFIG_basico.yml") :
  Scanner error: mapping values are not allowed here
```

**Causa:** Sintaxis incorrecta en el YML (espacios/tabs mal puestos).

**Reglas de YAML:**
- Usar ESPACIOS, NO tabs
- Indentar con 2 espacios consistentemente
- NO poner espacios antes de `:`
- SÍ poner espacio después de `:`

**Ejemplo INCORRECTO:**
```yaml
experiment:
nombre_experimento: "exp01"  # ← Falta indentación
  files:
input: "dataset.csv"  # ← Falta indentación
```

**Ejemplo CORRECTO:**
```yaml
experiment:
  nombre_experimento: "exp01"
  files:
    input: "dataset.csv"
```

**Solución:**
1. Verificá que haya 2 espacios de indentación en cada nivel
2. Usá un editor de YAML online para validar: http://www.yamllint.com/

---

### P13: ¿Qué hace cada parámetro de CONFIG_basico.yml?

Ver comentarios en el propio archivo `CONFIG_basico.yml`. Cada parámetro tiene una explicación en español.

**Parámetros que SÍ debés modificar:**
- `experiment.nombre_experimento` → Nombre único para cada experimento
- `feature_engineering.const.presente` → 2018, 2019, 2020, o 2021
- `feature_engineering.const.orden_lead` → 1, 2, 3, o 4
- `training_strategy.param.train.excluir` → Lista de años a excluir (ej: [2020, 2021])

**Parámetros que NO debés modificar (salvo que sepas lo que hacés):**
- `canaritos_*`
- `campos_sort`
- `campos_fijos`

---

### P14: ¿Cómo cambio la ruta base del proyecto?

En `CONFIG_basico.yml`, línea 2-3:

```yaml
environment:
  base_dir: "C:/Users/TuNombre/Documents/health_economics_challenge"
```

**Importante:**
- Usá `/` (forward slash) NO `\` (backslash)
- NO pongas `/` al final
- La ruta debe ser absoluta (completa)

---

## Git y GitHub

### P15: Error: "Permission denied" al hacer Push

**Causa:** No estás autenticado o no tenés permisos.

**Solución si sos colaborador:**
1. Verificá que fuiste agregado como colaborador
2. Revisá tu email y aceptá la invitación
3. Reiniciá GitHub Desktop

**Solución si usás Git por línea de comandos:**
```bash
# Configurar credenciales
git config --global user.name "Tu Nombre"
git config --global user.email "tu.email@ejemplo.com"

# Hacer push de nuevo
git push origin main
```

Si sigue fallando, puede que GitHub requiera un Personal Access Token:
https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token

---

### P16: Conflicto al hacer Pull (merge conflict)

**Problema:**
```
CONFLICT (content): Merge conflict in codigo_base/01_FE_health.R
```

**Causa:** Vos y un compañero modificaron el mismo archivo.

**Solución en GitHub Desktop:**
1. GitHub Desktop te va a mostrar los archivos en conflicto
2. Hacé clic derecho → "Open in [editor]"
3. Vas a ver algo así:

```r
<<<<<<< HEAD
# Tu versión
dataset[, mi_variable := ...]
=======
# Versión del compañero
dataset[, otra_variable := ...]
>>>>>>> origin/main
```

4. **Decidí** qué versión mantener (o combinar ambas)
5. Borrá las líneas `<<<<<<<`, `=======`, `>>>>>>>`
6. Guardá el archivo
7. En GitHub Desktop: marca el conflicto como resuelto
8. Commit y Push

**Prevención:**
- Comunicá cuando vas a modificar archivos
- Hacé Pull ANTES de empezar a trabajar

---

### P17: "diverged" / "Your branch and 'origin/main' have diverged"

**Causa:** Tu versión local y la del repositorio remoto están desincronizadas.

**Solución:**
```bash
# Opción 1: Pull y resolver conflictos
git pull origin main

# Opción 2: Descartar tus cambios locales (CUIDADO)
git fetch origin
git reset --hard origin/main
```

**En GitHub Desktop:**
- Branch → Merge into current branch → Seleccionar origin/main

---

## Resultados e Interpretación

### P18: ¿Cómo sé si mi RMSE es bueno?

**No hay un "buen" RMSE absoluto.** Depende del dataset.

**Lo importante:**
- **Comparar** con tu baseline
- **Menor RMSE = Mejor modelo**

**Ejemplo:**
| Experimento | RMSE | Interpretación |
|-------------|------|----------------|
| Baseline | 0.8542 | Punto de partida |
| Experimento 1 | 0.8123 | ✓ Mejoró 4.9% |
| Experimento 2 | 0.9001 | ✗ Empeoró 5.4% |

**Meta realista:**
- Reducir RMSE en 10-20% vs baseline = Excelente
- Reducir RMSE en 5-10% vs baseline = Bueno
- Reducir RMSE en 0-5% vs baseline = Aceptable

---

### P19: Mis variables nuevas NO aparecen en tb_importancia.txt. ¿Por qué?

**Posibles causas:**

1. **Las variables tienen muchos NAs:**
   - LightGBM puede descartarlas automáticamente

2. **Las variables no son informativas:**
   - Tienen poca varianza
   - Están correlacionadas con otras variables existentes

3. **Error en la creación:**
   - Verificá que se hayan creado correctamente (ver P8)

**Solución:**
```r
# Verificar que la variable existe en el dataset final
dataset <- fread("exp/NOMBRE/01_FE/dataset_fe.csv")
summary(dataset$mi_variable)

# Si está, verificar su varianza
var(dataset$mi_variable, na.rm = TRUE)
# Si es ~0 → Variable no informativa
```

---

### P20: ¿Qué significa "Gain" en tb_importancia.txt?

**Gain** = Importancia de la variable para el modelo.

- **Mayor Gain = Más importante**
- Se mide como la mejora promedio que esa variable aporta al modelo

**Ejemplo:**
```
Variable                  Gain
1: NY.GDP.PCAP.PP.CD      0.2345   ← Muy importante
2: health_efficiency      0.0123   ← Poco importante
```

Si tu variable tiene Gain > 0.05 → Es importante.

---

## Trabajo en Grupo

### P21: ¿Cómo dividimos el trabajo entre los 3?

**Sugerencia:**

**Semana 1: Exploración Individual**
- Cada uno ejecuta el baseline en su PC
- Cada uno prueba 1-2 estrategias COVID

**Semana 2: División de Variables**
- Persona A: Variables de eficiencia (ratios)
- Persona B: Variables de tendencias temporales
- Persona C: Variables de contexto (dummies)

**Semana 3: Colaboración**
- Los 3: Combinan mejores variables
- Los 3: Analizan resultados
- Los 3: Escriben informe

**Comunicación clave:**
- WhatsApp/Slack para coordinarse
- GitHub para compartir código

---

### P22: Mi compañero tiene una PC más potente. ¿Puede correr todos los experimentos?

**Respuesta:** Sí, pero...

**Ventaja:**
- ✅ Más rápido
- ✅ Puede correr más experimentos

**Desventaja:**
- ❌ Los otros no aprenden a ejecutar el pipeline
- ❌ Si esa persona falta, el grupo no puede continuar

**Recomendación:**
- Que cada uno ejecute al menos 2-3 experimentos
- El que tiene mejor PC puede hacer experimentos adicionales

---

### P23: ¿Podemos usar la PC de la universidad?

**Respuesta:** Consultá con el docente.

La universidad puede tener:
- Laboratorios con PCs potentes
- Servidores para cómputo

Preguntá si hay disponibilidad.

---

## Misceláneos

### P24: ¿Cuántos experimentos debemos hacer como mínimo?

**Mínimo:** 3-5 experimentos
- 1 baseline
- 2-4 experimentos con cambios

**Recomendado:** 7-10 experimentos
- 1 baseline
- 2-3 estrategias COVID
- 3-5 combinaciones de variables

**Óptimo:** 10-15 experimentos
- Exploración exhaustiva

---

### P25: ¿Podemos usar el modelo de otro grupo como referencia?

**NO.**

Esto se considera plagio. Cada grupo debe:
- Generar sus propias variables
- Ejecutar sus propios experimentos
- Escribir su propio código

**Permitido:**
- Compartir ideas generales ("probá usar ratios")
- Ayudarse con errores técnicos
- Discutir estrategias (sin compartir código)

**NO permitido:**
- Copiar código de otro grupo
- Compartir archivos .R con variables
- Copiar el informe de otro grupo

---

## 📞 ¿No encontraste tu problema aquí?

1. Consultá las otras guías:
   - [Guía de Instalación](01_guia_instalacion_rapida.md)
   - [Guía de Ejecución de Experimentos](02_guia_ejecucion_experimentos.md)
   - [Guía de Recursos Computacionales](03_guia_recursos_computacionales.md)

2. Preguntá en el foro del campus virtual

3. Consultá con el docente en horario de consultas

4. Enviá un email con:
   - Descripción del problema
   - Screenshot del error
   - Qué probaste hacer
   - Tu sistema operativo y versión de R

---

**Última actualización:** Noviembre 2025
**Autor:** Francisco Fernández

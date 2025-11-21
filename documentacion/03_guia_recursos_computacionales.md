# 💻 Guía de Recursos Computacionales

**Desafío de Machine Learning en Economía de la Salud**
**Universidad Nacional del Oeste - 2025**

---

## 🎯 Objetivo de esta Guía

Esta guía te ayuda a:
1. Entender los requisitos de hardware
2. Diagnosticar problemas de memoria o CPU
3. Optimizar el pipeline si tu computadora es limitada
4. Saber cuándo usar el dataset completo (78 países) vs reducido (23 países)

---

## 📊 Requisitos del Sistema

### Configuración Mínima

| Componente | Requisito Mínimo | Recomendado |
|------------|------------------|-------------|
| **RAM** | 12 GB libres | 16 GB o más |
| **CPU** | 4 núcleos | 8 núcleos o más |
| **Disco** | 10 GB libres | 20 GB libres |
| **Sistema Operativo** | Windows 10, macOS 10.13, Ubuntu 20.04 | Versiones más recientes |
| **R** | Versión 4.0+ | Versión 4.3+ |

⚠️ **IMPORTANTE:** El pipeline requiere **mínimo 12GB de RAM libres**. Como trabajan en grupos de 3, debe ejecutarlo el integrante que tenga el hardware adecuado.

### Tiempos de Ejecución Esperados

**Con dataset reducido (23 países):**

| Etapa | Tiempo Aproximado |
|-------|-------------------|
| Feature Engineering | 5-10 min |
| Training Strategy | 10-20 min |
| Hyperparameter Tuning | **5-6 horas** |
| **TOTAL** | **~6 horas** |

⏰ **Recomendación:** Ejecutar el pipeline completo de noche o durante el fin de semana. Planificá con tiempo.

**Con dataset completo (78 países - SOLO con 16GB+ RAM):**

| Etapa | Tiempo Aproximado |
|-------|-------------------|
| Feature Engineering | 10-20 min |
| Training Strategy | 30-60 min |
| Hyperparameter Tuning | **8-12 horas** |
| **TOTAL** | **~10-14 horas** |

---

## 🔍 Diagnóstico: ¿Tenés Problemas de Recursos?

### Síntomas Comunes

#### Problema 1: Memoria Insuficiente (RAM)

**Síntomas:**
- R se cierra inesperadamente
- Mensaje: `Error: cannot allocate vector of size...`
- La computadora se pone muy lenta
- Windows muestra "Memoria insuficiente"

**Verificación:**

En Windows:
1. Presioná `Ctrl + Shift + Esc` (Administrador de Tareas)
2. Andá a la pestaña "Rendimiento"
3. Mirá "Memoria"
   - Si está al 90-100% → **Problema de RAM**

En Mac:
1. Abrí "Monitor de Actividad" (cmd + espacio → "Monitor de Actividad")
2. Mirá "Memoria"
   - Si "Presión de memoria" está roja → **Problema de RAM**

**Solución:** Ver sección [Optimizar para RAM Limitada](#optimizar-para-ram-limitada)

---

#### Problema 2: CPU Lento

**Síntomas:**
- El pipeline tarda más de 2 horas
- La computadora se queda "pensando" mucho tiempo
- No hay errores, pero es muy lento

**Verificación:**

En Windows:
1. Abrí Administrador de Tareas
2. Andá a "Rendimiento" → "CPU"
3. Mirá cuántos núcleos tenés y su uso

En Mac:
1. Monitor de Actividad → "CPU"
2. Mirá "% de CPU" de RStudio

**Solución:** Reducir iteraciones de optimización (ver [Optimizar para CPU Lento](#optimizar-para-cpu-lento))

---

#### Problema 3: Disco Lleno

**Síntomas:**
- Error al escribir archivos
- No se puede crear la carpeta `exp/`

**Verificación:**
- Verificá cuánto espacio libre tenés en disco

**Solución:** Liberá espacio (borrá experimentos antiguos, archivos temporales)

---

## 🛠️ Optimizaciones

### Optimizar para RAM Limitada

Si tenés 4 GB de RAM o menos:

#### Opción 1: Limpiar Memoria Frecuentemente

Editá `codigo_base/01_FE_health.R` y agregá `gc()` más seguido:

```r
AgregarVariables <- function(dataset) {
  gc()  # Limpieza de memoria

  # Tus variables...
  dataset[, var1 := ...]

  gc()  # Limpieza de memoria después de crear variables

  return(dataset)
}
```

#### Opción 2: Reducir Datos en Memoria

En `0_HEALTH_EXE.R`, agregá antes de Feature Engineering:

```r
# Reducir precisión numérica para ahorrar RAM
dataset[, (numeric_cols) := lapply(.SD, as.numeric), .SDcols = numeric_cols]
```

#### Opción 3: Ejecutar por Partes

En lugar de ejecutar `0_HEALTH_EXE.R` completo:

1. Ejecutá solo Feature Engineering
2. Cerrá R
3. Volvé a abrir R
4. Ejecutá solo Training Strategy
5. Cerrá R
6. Ejecutá solo Hyperparameter Tuning

**Cómo:**

En `0_HEALTH_EXE.R`, comentá secciones:

```r
# =======================
# ETAPA 1: FE
# =======================
source("codigo_base/01_FE_health.R")

# Comentá el resto:
# source("codigo_base/02_TS_health.R")
# source("codigo_base/03_HT_health.R")
```

Ejecutá, luego descomentá la siguiente etapa.

#### Opción 4: Pedir Dataset Reducido

**¿Cuándo?**
- Si ninguna de las opciones anteriores funciona
- Si el pipeline falla consistentemente por memoria
- Si todos en el grupo tienen el mismo problema

**¿Cómo pedir?**
Enviá un email al docente con:

```
Asunto: Solicitud de Dataset Reducido - Grupo [X]

Docente,

Nuestro grupo está teniendo problemas para ejecutar el pipeline con el dataset completo.

Integrantes:
- Nombre 1 (PC: 4GB RAM, 2 cores)
- Nombre 2 (PC: 4GB RAM, 2 cores)
- Nombre 3 (Notebook: 4GB RAM, 2 cores)

Problema:
R se cierra con error "cannot allocate vector" al ejecutar Feature Engineering con el dataset completo (78 países).

Probamos:
- Limpiar memoria con gc()
- Ejecutar por etapas
- Cerrar todas las demás aplicaciones

Solución: Cambiamos a usar el dataset reducido (23 países) en CONFIG_basico.yml:
```yaml
dataset: "./dataset/dataset_desafio.csv"  # Dataset reducido (23 países)
```

Esto nos permitió completar el desafío en nuestra computadora con 4GB RAM.

Nota: El profesor puede brindarte el dataset completo si tu hardware lo soporta.

Gracias,
Grupo [X]
```

---

### Optimizar para CPU Lento

Si el Hyperparameter Tuning tarda más de 90 minutos:

#### Opción 1: Reducir Iteraciones de Optimización

Editá `CONFIG_basico.yml`:

```yaml
hyperparameter_tuning:
  param:
    BO:
      iterations: 50    # ← Cambiar de 100 a 50 (más rápido)
      time_budget: 0    # Sin límite de tiempo
```

**Trade-off:**
- ✅ Más rápido (mitad del tiempo)
- ❌ Puede encontrar hiperparámetros sub-óptimos

#### Opción 2: Reducir Árboles de LightGBM

En `CONFIG_basico.yml`:

```yaml
lightgbm:
  param_basicos:
    num_iterations: 500   # ← Reducir de 1000 a 500
```

**Trade-off:**
- ✅ Entrenamientos más rápidos
- ❌ Modelos potencialmente menos precisos

---

### Optimizar para Disco Lento

Si los archivos CSV tardan mucho en escribirse:

#### Usar .rds en lugar de .csv

Los archivos `.rds` son más compactos y rápidos.

En `codigo_base/02_TS_health.R`, buscá líneas como:

```r
fwrite(dataset_train, "exp/.../dataset_train.csv")
```

Y cambiá por:

```r
saveRDS(dataset_train, "exp/.../dataset_train.rds")
```

**Importante:** También tenés que cambiar la lectura después:
```r
dataset_train <- readRDS("exp/.../dataset_train.rds")
```

---

## 🎯 Estrategias por Tipo de Hardware

### Caso 1: Computadora Básica (4GB RAM, 2 cores)

**Configuración recomendada:**

```yaml
# CONFIG_basico.yml

hyperparameter_tuning:
  param:
    BO:
      iterations: 30          # Reducir iteraciones

lightgbm:
  param_basicos:
    num_iterations: 500       # Reducir árboles
    num_threads: 2            # Usar ambos núcleos
```

**Estrategia:**
1. Ejecutar por etapas (cerrar R entre etapas)
2. Crear pocas variables nuevas (max 10)
3. Probar 2-3 experimentos en total
4. Si sigue fallando → Pedir dataset reducido

---

### Caso 2: Computadora Media (8GB RAM, 4 cores)

**Configuración recomendada:**

```yaml
# CONFIG_basico.yml (valores default)

hyperparameter_tuning:
  param:
    BO:
      iterations: 100

lightgbm:
  param_basicos:
    num_iterations: 1000
    num_threads: 4
```

**Estrategia:**
1. Ejecutar pipeline completo sin problemas
2. Crear 15-20 variables
3. Probar 5-7 experimentos

---

### Caso 3: Computadora Potente (16GB+ RAM, 8+ cores)

**Configuración recomendada:**

```yaml
hyperparameter_tuning:
  param:
    BO:
      iterations: 150         # Aumentar para mejor optimización

lightgbm:
  param_basicos:
    num_iterations: 1500
    num_threads: 8            # Usar todos los núcleos
```

**Estrategia:**
1. Ejecutar múltiples experimentos en paralelo (si sabés usar ramas)
2. Crear 20-30 variables
3. Probar 10+ experimentos

---

## 📊 Monitoreo de Recursos Durante Ejecución

### Windows

Mientras corre el pipeline:

1. Abrí Administrador de Tareas (Ctrl + Shift + Esc)
2. Andá a "Rendimiento"
3. Observá:
   - **CPU:** Debería estar entre 50-100% (es normal)
   - **Memoria:** Debería estar < 90%
   - **Disco:** Puede tener picos de actividad

**¿Cuándo preocuparse?**
- Memoria al 100% durante más de 5 minutos → Posible problema
- CPU al 0% → R se trabó, reiniciar

### Mac

1. Abrí Monitor de Actividad
2. Observá:
   - **CPU:** R debería usar 100-400% (depende de núcleos)
   - **Memoria:** "Presión de memoria" debería estar verde/amarilla
   - **Disco:** Puede haber actividad intermitente

### Linux

```bash
# Monitorear en tiempo real
htop

# Ver uso de memoria
free -h

# Ver procesos de R
ps aux | grep R
```

---

## 🆘 Dataset Reducido (Último Recurso)

### ¿Cuándo pedirlo?

**SOLO si:**
- **TODOS** los integrantes del grupo tienen computadoras limitadas (≤4GB RAM)
- Probaron todas las optimizaciones anteriores
- El pipeline sigue fallando

### ¿Qué esperar?

El profesor puede proveer un dataset con:
- **Menos países:** ~40 países en lugar de 78
- **Menos años:** 2010-2021 en lugar de 2000-2021
- **Menos variables:** ~100 variables en lugar de 200

### ¿Cómo afecta el desafío?

**Ventajas:**
- ✅ Ejecuciones más rápidas
- ✅ Menor uso de memoria
- ✅ Pueden completar el desafío

**Desventajas:**
- ⚠️ Resultados no comparables con otros grupos (diferente dataset)
- ⚠️ Menos oportunidades de Feature Engineering
- ⚠️ Puede afectar levemente la nota (pero es mejor entregar algo que nada)

---

## 💡 Tips Generales

### 1. Cerrar Otras Aplicaciones

Antes de ejecutar el pipeline:
- ❌ Cerrar: Chrome, Edge, Spotify, Discord, Steam
- ✅ Mantener: RStudio, Explorador de Archivos

### 2. Reiniciar R Entre Experimentos

Si vas a correr múltiples experimentos seguidos:

```r
# Al terminar experimento 1:
rm(list = ls())  # Limpiar ambiente
gc()             # Liberar memoria

# O mejor: reiniciar R
# Session → Restart R
```

### 3. No Ejecutar Durante la Noche

Si tu computadora es limitada, NO dejes el pipeline corriendo mientras dormís:
- Puede trabarse y perder tiempo
- Es mejor monitorearlo mientras corre

### 4. Hacer Backups

Antes de experimentos importantes:

```bash
# Copiar carpeta exp/ a un backup
cp -r exp/ exp_backup_2025_04_15/
```

O comprimila:
```bash
tar -czf exp_backup.tar.gz exp/
```

---

## 📞 Contacto para Problemas de Recursos

Si después de seguir esta guía seguís con problemas:

**Email al docente:**
```
Asunto: Problema de Recursos - Grupo [X]

Hardware del grupo:
- Integrante 1: [RAM], [CPU]
- Integrante 2: [RAM], [CPU]
- Integrante 3: [RAM], [CPU]

Problema:
[Descripción detallada]

Optimizaciones probadas:
- [ ] Reducir iteraciones BO
- [ ] Ejecutar por etapas
- [ ] Limpiar memoria con gc()
- [ ] Cerrar otras aplicaciones
- [ ] [Otra...]

Adjunto:
- Screenshot del error
- Captura del Administrador de Tareas

Grupo [X]
```

---

## ✅ Checklist de Diagnóstico

Antes de pedir ayuda, verificá:

- [ ] Verificaste cuánta RAM tenés disponible
- [ ] Cerraste todas las aplicaciones innecesarias
- [ ] Probaste ejecutar por etapas
- [ ] Agregaste `gc()` para limpiar memoria
- [ ] Reiniciaste R entre experimentos
- [ ] Redujiste iteraciones de BO a 30-50
- [ ] Consultaste con tus compañeros de grupo

---

## 📚 Recursos Relacionados

- [Guía de Instalación](01_guia_instalacion_rapida.md)
- [Guía de Ejecución de Experimentos](02_guia_ejecucion_experimentos.md)
- [FAQ Técnico](04_FAQ_tecnico.md)

---

**Recordá:** El objetivo del desafío es aprender, no tener la computadora más potente. Si tu hardware es limitado, **avisá temprano** para que podamos ayudarte.

---

**Última actualización:** Noviembre 2025
**Autor:** Francisco Fernández

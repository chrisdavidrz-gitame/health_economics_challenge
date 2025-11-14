# Diccionario de Variables - Sociales y Educación (SE.*, SG.*)

**Desafío: Predicción de Gasto de Bolsillo en Salud (hf3_ppp_pc)**  
**Fuente de Datos: World Bank World Development Indicators (WDI)**

---

## Variables de Educación Primaria (SE.PRM.*)

### SE.ENR.PRIM.FM.ZS
**Nombre:** Ratio de género en matrícula primaria  
**Definición:** Ratio de niñas/niños matriculados en educación primaria (%)  
**Unidad:** Porcentaje  
**Interpretación:** Equidad de género en acceso a educación básica. 100% = paridad perfecta.

### SE.PRM.AGES
**Nombre:** Rango de edad para educación primaria  
**Definición:** Rango oficial de edad para cursar educación primaria  
**Unidad:** Años  
**Interpretación:** Estructura del sistema educativo del país

### SE.PRM.DURS
**Nombre:** Duración de educación primaria  
**Definición:** Duración oficial de la educación primaria  
**Unidad:** Años  
**Interpretación:** Extensión del ciclo educativo básico (típicamente 5-7 años)

### SE.PRM.ENRL
**Nombre:** Matrícula en educación primaria  
**Definición:** Número total de estudiantes matriculados en primaria  
**Unidad:** Número absoluto  
**Interpretación:** Tamaño del sistema educativo primario

### SE.PRM.ENRL.FE.ZS
**Nombre:** Matrícula primaria femenina (%)  
**Definición:** Porcentaje de niñas en el total de matriculados en primaria  
**Unidad:** Porcentaje  
**Interpretación:** Participación femenina en educación básica

### SE.PRM.ENRR
**Nombre:** Tasa neta de matrícula primaria  
**Definición:** Porcentaje de niños en edad oficial matriculados en primaria  
**Unidad:** Porcentaje  
**Interpretación:** Cobertura del sistema educativo primario. Valores cercanos a 100% indican cobertura universal.

### SE.PRM.ENRR.FE
**Nombre:** Tasa neta de matrícula primaria (niñas)  
**Definición:** Porcentaje de niñas en edad oficial matriculadas en primaria  
**Unidad:** Porcentaje  
**Interpretación:** Acceso femenino a educación básica

### SE.PRM.ENRR.MA
**Nombre:** Tasa neta de matrícula primaria (niños)  
**Definición:** Porcentaje de niños en edad oficial matriculados en primaria  
**Unidad:** Porcentaje  
**Interpretación:** Acceso masculino a educación básica

### SE.PRM.TCHR
**Nombre:** Maestros de educación primaria  
**Definición:** Número total de maestros en educación primaria  
**Unidad:** Número absoluto  
**Interpretación:** Recursos humanos del sistema educativo primario

## Variables de Educación Secundaria (SE.SEC.*)

### SE.SEC.AGES
**Nombre:** Rango de edad para educación secundaria  
**Definición:** Rango oficial de edad para cursar educación secundaria  
**Unidad:** Años  
**Interpretación:** Estructura del ciclo educativo medio

### SE.SEC.DURS
**Nombre:** Duración de educación secundaria  
**Definición:** Duración oficial de la educación secundaria  
**Unidad:** Años  
**Interpretación:** Extensión del ciclo educativo medio (típicamente 4-7 años)

### SE.SEC.ENRL
**Nombre:** Matrícula en educación secundaria  
**Definición:** Número total de estudiantes matriculados en secundaria  
**Unidad:** Número absoluto  
**Interpretación:** Tamaño del sistema educativo secundario

### SE.SEC.ENRL.GC
**Nombre:** Matrícula secundaria en ciclo general  
**Definición:** Estudiantes en programas generales de secundaria (no técnicos)  
**Unidad:** Número absoluto  
**Interpretación:** Distribución entre educación general vs. técnica

### SE.SEC.ENRL.GC.FE.ZS
**Nombre:** Matrícula femenina en secundaria general (%)  
**Definición:** Porcentaje de niñas en programas generales de secundaria  
**Unidad:** Porcentaje  
**Interpretación:** Participación femenina en educación media general

### SE.SEC.ENRR
**Nombre:** Tasa neta de matrícula secundaria  
**Definición:** Porcentaje de adolescentes en edad oficial matriculados en secundaria  
**Unidad:** Porcentaje  
**Interpretación:** Cobertura del sistema educativo secundario

### SE.SEC.ENRR.FE
**Nombre:** Tasa neta de matrícula secundaria (niñas)  
**Definición:** Porcentaje de niñas en edad oficial matriculadas en secundaria  
**Unidad:** Porcentaje  
**Interpretación:** Acceso femenino a educación media

### SE.SEC.ENRR.MA
**Nombre:** Tasa neta de matrícula secundaria (niños)  
**Definición:** Porcentaje de niños en edad oficial matriculados en secundaria  
**Unidad:** Porcentaje  
**Interpretación:** Acceso masculino a educación media

## Variables de Educación Terciaria (SE.TER.*)

### SE.TER.ENRR
**Nombre:** Tasa bruta de matrícula terciaria  
**Definición:** Total de matriculados en educación superior como % de la población en edad oficial  
**Unidad:** Porcentaje  
**Interpretación:** Acceso a educación universitaria y técnica superior. Puede superar 100% si hay estudiantes fuera de la edad oficial.

## Variables Legales y de Gobernanza (SG.*)

### SG.LAW.INDX
**Nombre:** Índice de fortaleza de derechos legales  
**Definición:** Índice que mide el grado de protección legal de prestatarios y prestamistas (0-12)  
**Unidad:** Escala 0-12  
**Interpretación:** Calidad institucional y marco legal. Mayor valor = mejor protección de derechos.

---

## Relevancia para Economía de la Salud

Las variables educativas y sociales se relacionan con gasto en salud a través de múltiples canales:

### 1. **Educación como Determinante de Salud**
- Personas educadas utilizan más servicios preventivos
- Mejor comprensión de tratamientos médicos
- Mayor adherencia a medicamentos

### 2. **Educación y Capacidad de Pago**
- Mayor educación → Mayor ingreso → Mayor gasto en salud
- SE.TER.ENRR correlaciona con mayor capacidad de pago de bolsillo

### 3. **Equidad de Género en Salud**
- Brechas de género en educación predicen brechas en salud
- Menor acceso femenino a servicios de salud

### 4. **Calidad Institucional**
- SG.LAW.INDX: Marco legal fuerte correlaciona con mejor protección financiera del paciente

---

## Variables Clave por Importancia Esperada

1. **SE.SEC.ENRR** - Cobertura secundaria
2. **SE.TER.ENRR** - Educación terciaria
3. **SE.PRM.ENRR** - Educación básica
4. **SG.LAW.INDX** - Calidad institucional
5. **SE.PRM.ENRR.FE** - Educación femenina

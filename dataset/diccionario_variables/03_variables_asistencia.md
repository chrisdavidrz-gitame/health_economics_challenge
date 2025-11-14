# Diccionario de Variables - Asistencia y Desarrollo (DC.*, DT.*)

**Desafío: Predicción de Gasto de Bolsillo en Salud (hf3_ppp_pc)**  
**Fuente de Datos: World Bank World Development Indicators (WDI)**

---

## Variables de Ayuda Oficial al Desarrollo (ODA) - Donantes DAC

### DC.DAC.CANL.CD
**Nombre:** Asistencia oficial de Canadá  
**Definición:** Ayuda bilateral de Canadá (USD corrientes)  
**Unidad:** Dólares estadounidenses  
**Interpretación:** Flujo de ayuda específica de Canadá

### DC.DAC.CECL.CD
**Nombre:** Asistencia oficial de Comisión Europea  
**Definición:** Ayuda bilateral de la CE (USD corrientes)  
**Unidad:** Dólares estadounidenses  
**Interpretación:** Ayuda europea al país

### DC.DAC.DEUL.CD
**Nombre:** Asistencia oficial de Alemania  
**Definición:** Ayuda bilateral de Alemania (USD corrientes)  
**Unidad:** Dólares estadounidenses  
**Interpretación:** Cooperación alemana

### DC.DAC.FRAL.CD
**Nombre:** Asistencia oficial de Francia  
**Definición:** Ayuda bilateral de Francia (USD corrientes)  
**Unidad:** Dólares estadounidenses  
**Interpretación:** Cooperación francesa

### DC.DAC.GBRL.CD
**Nombre:** Asistencia oficial del Reino Unido  
**Definición:** Ayuda bilateral de UK (USD corrientes)  
**Unidad:** Dólares estadounidenses  
**Interpretación:** Cooperación británica

### DC.DAC.JPNL.CD
**Nombre:** Asistencia oficial de Japón  
**Definición:** Ayuda bilateral de Japón (USD corrientes)  
**Unidad:** Dólares estadounidenses  
**Interpretación:** Cooperación japonesa

### DC.DAC.TOTL.CD
**Nombre:** Asistencia oficial total DAC  
**Definición:** Suma de ayuda de todos los donantes DAC (USD corrientes)  
**Unidad:** Dólares estadounidenses  
**Interpretación:** Total de cooperación internacional recibida

### DC.DAC.USAL.CD
**Nombre:** Asistencia oficial de Estados Unidos  
**Definición:** Ayuda bilateral de USA (USD corrientes)  
**Unidad:** Dólares estadounidenses  
**Interpretación:** Cooperación estadounidense

---

## Variables de Deuda y Asistencia (DT.*)

### DT.NFL.UNDP.CD
**Nombre:** Flujos netos de UNDP  
**Definición:** Transferencias netas del Programa de Naciones Unidas para el Desarrollo  
**Unidad:** Dólares estadounidenses  
**Interpretación:** Apoyo multilateral para desarrollo

### DT.ODA.ALLD.CD
**Nombre:** Asistencia oficial al desarrollo (ODA) neta  
**Definición:** Ayuda oficial total recibida (USD corrientes)  
**Unidad:** Dólares estadounidenses  
**Interpretación:** Total de cooperación internacional

### DT.ODA.ALLD.KD
**Nombre:** ODA neta (USD constantes)  
**Definición:** Ayuda oficial en términos reales  
**Unidad:** Dólares constantes  
**Interpretación:** Evolución real de la ayuda recibida

### DT.ODA.ODAT.CD
**Nombre:** ODA total recibida  
**Definición:** Total de asistencia oficial al desarrollo  
**Unidad:** Dólares corrientes  
**Interpretación:** Magnitud de ayuda externa

### DT.ODA.ODAT.GN.ZS
**Nombre:** ODA (% del INB)  
**Definición:** Asistencia oficial como porcentaje del Ingreso Nacional Bruto  
**Unidad:** Porcentaje del INB  
**Interpretación:** Dependencia relativa de ayuda externa

### DT.ODA.ODAT.KD
**Nombre:** ODA total (USD constantes)  
**Definición:** Asistencia en términos reales  
**Unidad:** Dólares constantes  
**Interpretación:** Tendencia real de la ayuda

### DT.ODA.ODAT.PC.ZS
**Nombre:** ODA per cápita  
**Definición:** Ayuda oficial por habitante  
**Unidad:** Dólares por persona  
**Interpretación:** Distribución per cápita de ayuda internacional

---

## Relevancia para Economía de la Salud

Las variables de asistencia internacional se relacionan con gasto en salud a través de:

1. **Financiamiento Directo:** Parte de ODA suele destinarse a salud pública
2. **Capacidad Fiscal:** Ayuda externa libera recursos del presupuesto público para salud
3. **Programas de Salud:** Cooperación bilateral a menudo incluye proyectos sanitarios
4. **Infraestructura:** ODA puede financiar hospitales y centros de salud
5. **Dependencia Estructural:** Alta ODA/INB indica menor capacidad autónoma de financiamiento

**Contexto COVID-19:**
- Durante 2020-2021, muchos países recibieron ayuda adicional para respuesta sanitaria
- Esto puede generar un "spike" en variables de asistencia durante el período COVID
- Importante considerar al decidir si incluir/excluir años 2020-2021

**Variables potencialmente importantes:**
- DT.ODA.ODAT.GN.ZS (dependencia de ayuda → capacidad de financiar salud)
- DC.DAC.TOTL.CD (cooperación en salud incluida en ayuda bilateral)
- DT.ODA.ODAT.PC.ZS (distribución de recursos externos per cápita)

**Nota para Feature Engineering:**
Considerar crear variables de:
- Cambio abrupto en ODA durante 2020-2021 (dummy COVID aid surge)
- Ratio ODA/Gasto Público (cuánto del presupuesto depende de ayuda)
- Concentración de donantes (diversificación de fuentes de ayuda)

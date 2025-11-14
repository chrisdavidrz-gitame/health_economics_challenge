# Diccionario de Variables - Gastos Militares (MS.*)

**Desafío: Predicción de Gasto de Bolsillo en Salud (hf3_ppp_pc)**  
**Fuente de Datos: World Bank World Development Indicators (WDI)**

---

## MS.MIL.MPRT.KD
**Nombre:** Importaciones militares  
**Definición:** Importaciones de armas (USD constantes)  
**Unidad:** Dólares constantes  
**Interpretación:** Gasto en importación de armamento

## MS.MIL.XPND.CD
**Nombre:** Gasto militar total  
**Definición:** Gasto en defensa (USD corrientes)  
**Unidad:** Dólares estadounidenses  
**Interpretación:** Presupuesto destinado a defensa

## MS.MIL.XPND.GD.ZS
**Nombre:** Gasto militar (% del PIB)  
**Definición:** Gasto en defensa como porcentaje del PIB  
**Unidad:** Porcentaje del PIB  
**Interpretación:** **Trade-off presupuestario:** Mayor gasto militar → menor espacio fiscal para salud

---

## Relevancia para Economía de la Salud

### Trade-off Presupuestario (Guns vs. Butter)
- **MS.MIL.XPND.GD.ZS alto → Menos recursos para salud pública**
- Países con alta militarización tienden a subfinanciar sector salud
- Resultado: Mayor carga sobre familias (gasto de bolsillo)

### Contexto de Conflicto
- Alto gasto militar puede indicar:
  - Conflictos armados → infraestructura de salud dañada
  - Inestabilidad política → fuga de capital humano médico
  - Prioridades presupuestarias anti-sociales

### Variables potencialmente importantes:
- **MS.MIL.XPND.GD.ZS** (trade-off fiscal → menor inversión pública en salud → mayor gasto de bolsillo)

**Nota para Feature Engineering:**
- Ratio gasto militar / gasto social
- Dummy de alta militarización (>3% del PIB)
- Cambio abrupto en gasto militar (conflictos)

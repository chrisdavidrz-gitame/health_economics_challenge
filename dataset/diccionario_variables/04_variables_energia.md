# Diccionario de Variables - Energía (EG.*)

**Desafío: Predicción de Gasto de Bolsillo en Salud (hf3_ppp_pc)**  
**Fuente de Datos: World Bank World Development Indicators (WDI)**

---

## Variables de Producción de Electricidad

### EG.ELC.COAL.ZS
**Nombre:** Electricidad de carbón  
**Definición:** Electricidad producida de carbón (% del total)  
**Unidad:** Porcentaje  
**Interpretación:** Dependencia de carbón en matriz energética

### EG.ELC.FOSL.ZS
**Nombre:** Electricidad de combustibles fósiles  
**Definición:** Electricidad de petróleo, gas y carbón (% del total)  
**Unidad:** Porcentaje  
**Interpretación:** Matriz energética basada en fósiles

### EG.ELC.HYRO.ZS
**Nombre:** Electricidad hidroeléctrica  
**Definición:** Electricidad de fuentes hídricas (% del total)  
**Unidad:** Porcentaje  
**Interpretación:** Energía renovable hidráulica

### EG.ELC.NGAS.ZS
**Nombre:** Electricidad de gas natural  
**Definición:** Electricidad producida de gas (% del total)  
**Unidad:** Porcentaje  
**Interpretación:** Dependencia de gas natural

### EG.ELC.NUCL.ZS
**Nombre:** Electricidad nuclear  
**Definición:** Electricidad de plantas nucleares (% del total)  
**Unidad:** Porcentaje  
**Interpretación:** Desarrollo nuclear

### EG.ELC.PETR.ZS
**Nombre:** Electricidad de petróleo  
**Definición:** Electricidad de derivados del petróleo (% del total)  
**Unidad:** Porcentaje  
**Interpretación:** Dependencia de petróleo para electricidad

---

## Variables de Consumo Energético

### EG.USE.ELEC.KH.PC
**Nombre:** Consumo de electricidad per cápita  
**Definición:** Uso eléctrico por persona (kWh per cápita)  
**Unidad:** Kilovatios-hora por persona  
**Interpretación:** Nivel de desarrollo y acceso a energía eléctrica

### EG.USE.PCAP.KG.OE
**Nombre:** Consumo de energía per cápita  
**Definición:** Uso energético por persona (kg equivalente petróleo)  
**Unidad:** Kilogramos de petróleo equivalente per cápita  
**Interpretación:** Intensidad energética de la economía y nivel de vida

---

## Relevancia para Economía de la Salud

Las variables energéticas se relacionan con gasto en salud a través de:

1. **Desarrollo Económico:** Alto consumo energético per cápita indica mayor desarrollo
2. **Infraestructura Sanitaria:** Hospitales requieren electricidad confiable
3. **Contaminación:** Energía fósil genera problemas respiratorios y enfermedades
4. **Acceso a Servicios:** Electricidad es prerequisito para servicios de salud modernos
5. **Cadena de Frío:** Vacunas y medicamentos requieren refrigeración eléctrica

**Variables potencialmente importantes:**
- EG.USE.ELEC.KH.PC (desarrollo → mejor infraestructura sanitaria)
- EG.ELC.FOSL.ZS (contaminación → mayor gasto en enfermedades respiratorias)
- EG.USE.PCAP.KG.OE (nivel de vida → capacidad de pago)

**Nota para Feature Engineering:**
- Ratio energía renovable vs. fósil (calidad ambiental)
- Cambios en consumo eléctrico (crecimiento económico)
- Disponibilidad de electricidad para servicios de salud

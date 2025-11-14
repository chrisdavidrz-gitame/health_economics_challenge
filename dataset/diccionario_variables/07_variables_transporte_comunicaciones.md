# Diccionario de Variables - Transporte y Comunicaciones (IS.*, IT.*)

**Desafío: Predicción de Gasto de Bolsillo en Salud (hf3_ppp_pc)**  
**Fuente de Datos: World Bank World Development Indicators (WDI)**

---

## Variables de Transporte Aéreo (IS.AIR.*)

### IS.AIR.DPRT
**Nombre:** Salidas de vuelos  
**Definición:** Número de vuelos comerciales que despegan  
**Unidad:** Número de vuelos  
**Interpretación:** Conectividad aérea, nivel de desarrollo

### IS.AIR.GOOD.MT.K1
**Nombre:** Transporte aéreo de carga  
**Definición:** Toneladas-kilómetro de carga aérea  
**Unidad:** Millones de toneladas-km  
**Interpretación:** Logística de alto valor (puede incluir medicamentos, equipos médicos)

### IS.AIR.PSGR
**Nombre:** Pasajeros de transporte aéreo  
**Definición:** Número de pasajeros transportados  
**Unidad:** Número de pasajeros  
**Interpretación:** Movilidad, turismo médico potencial

---

## Variables de Telecomunicaciones (IT.*)

### IT.CEL.SETS
**Nombre:** Suscripciones de telefonía celular  
**Definición:** Número total de líneas celulares  
**Unidad:** Número de suscripciones  
**Interpretación:** Penetración de tecnología móvil

### IT.CEL.SETS.P2
**Nombre:** Suscripciones celulares (por 100 personas)  
**Definición:** Líneas celulares por cada 100 habitantes  
**Unidad:** Por 100 personas  
**Interpretación:** **IMPORTANTE:** Acceso a información de salud, telemedicina

### IT.MLT.MAIN
**Nombre:** Líneas telefónicas fijas  
**Definición:** Número de líneas fijas  
**Unidad:** Número de líneas  
**Interpretación:** Infraestructura de comunicaciones tradicional

### IT.MLT.MAIN.P2
**Nombre:** Líneas telefónicas fijas (por 100 personas)  
**Definición:** Líneas fijas por cada 100 habitantes  
**Unidad:** Por 100 personas  
**Interpretación:** Cobertura de telefonía fija

---

## Relevancia para Economía de la Salud

1. **Conectividad Digital (IT.CEL.SETS.P2):**
   - Acceso a información sobre salud
   - Telemedicina (especialmente relevante post-COVID)
   - Coordinación de citas médicas
   - Mayor penetración → mejor acceso a servicios

2. **Transporte Aéreo (IS.AIR.*):**
   - Importación de medicamentos y equipos
   - Turismo médico (países como Costa Rica, Tailandia)
   - Evacuaciones médicas de emergencia
   - Mayor conectividad → potencial menor gasto local (acceso a otros mercados)

3. **Infraestructura de Comunicaciones:**
   - Desarrollo económico general
   - Sistemas de salud digital
   - Registros médicos electrónicos

**Contexto COVID-19:**
- **2020-2021:** Boom de telemedicina → alta importancia de IT.CEL.SETS.P2
- Restricciones de vuelos → caída en IS.AIR.* → menor turismo médico
- Aumento de adopción digital en salud

**Variables potencialmente importantes:**
- **IT.CEL.SETS.P2** (conectividad → acceso a info médica, telemedicina)
- IS.AIR.GOOD.MT.K1 (logística médica internacional)
- IS.AIR.PSGR (turismo médico, evacuaciones)

**Nota para Feature Engineering:**
- Ratio celulares/población (brecha digital)
- Cambio en suscripciones celulares 2020-2021 (adopción digital COVID)
- Dummy de alta conectividad (>100 celulares por 100 hab)

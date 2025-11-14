# Feature Engineering para Health Economics - VERSIÓN ALUMNOS
# Adaptado para desafío pedagógico Machine Learning
# Los alumnos deben completar la función AgregarVariables()

require("data.table")
require("Rcpp")
require("rlist")
require("yaml")
library(dplyr)
library(stringr)
library(lubridate)

require("lightgbm")
require("ranger")
require("randomForest")  #solo se usa para imputar nulos

#------------------------------------------------------------------------------

ReportarCampos  <- function( dataset )
{
  cat( "La cantidad de campos es ", ncol(dataset) , "\n" )
}
#------------------------------------------------------------------------------
#Agrega al dataset una variable que va de 1 a 12, el mes, para que el modelo aprenda estacionalidad
# ADAPTADO: Para health economics, creamos un indicador cíclico del año

AgregarMes  <- function( dataset )
{
  gc()
  # Para health economics: crear variable cíclica GLOBAL por año
  # Todos los países en el mismo año tendrán el mismo ciclo
  # Equivalente al mes pero para años: basado en el año real, no secuencial por país
  dataset[, year_cycle := ((year - min(year, na.rm = TRUE)) %% 10) + 1]  # Ciclo global de 1 a 10
  ReportarCampos( dataset )
}
#------------------------------------------------------------------------------
#Elimina las variables que uno supone hace Data Drifting

DriftEliminar  <- function( dataset, variables )
{
  gc()
  dataset[  , c(variables) := NULL ]
  ReportarCampos( dataset )
}
#------------------------------------------------------------------------------
#Autor:  Santiago Dellachiesa, UAustral 2021
#A las variables que tienen nulos, les agrega una nueva variable el dummy de is es nulo o no {0, 1}

DummiesNA  <- function( dataset )
{
  gc()
  # ADAPTADO: usar 'presente' como año actual en lugar de foto_mes
  nulos  <- colSums( is.na(dataset[ year %in% PARAMS$feature_engineering$const$presente ]) )  #cuento la cantidad de nulos por columna
  colsconNA  <- names( which(  nulos > 0 ) )

  dataset[ , paste0( colsconNA, "_isNA") :=  lapply( .SD,  is.na ),
             .SDcols= colsconNA]

  ReportarCampos( dataset )
}
#------------------------------------------------------------------------------

CorregirCampoMes  <- function( pcampo, pyears )
{
  # ADAPTADO: usar Country Code en lugar de CDGMED
  tbl <- dataset[  ,  list( "v1" = shift( get(pcampo), 1, type="lag" ),
                            "v2" = shift( get(pcampo), 1, type="lead" )
                         ), 
                   by=`Country Code` ]
  
  tbl[ , `Country Code` := NULL ]
  tbl[ , promedio := rowMeans( tbl,  na.rm=TRUE ) ]
  
  dataset[ ,  
           paste0(pcampo) := ifelse( !(year %in% pyears),
                                     get( pcampo),
                                     tbl$promedio ) ]

}
#------------------------------------------------------------------------------
# reemplaza cada variable ROTA  (variable, year)  con el promedio entre  ( año_anterior, año_posterior )
# en honor a Claudio Castillo,  honorable y fiel centinela de la Estadistica Clasica

CorregirClaudioCastillo  <- function( dataset )
{
  # Para health economics, no hay correcciones específicas conocidas
  # Se mantiene la estructura pero sin correcciones activas
}
#------------------------------------------------------------------------------
#Corrige poniendo a NA las variables que en ese año estan dañadas

CorregirNA  <- function( dataset )
{
  gc()
  #acomodo los errores del dataset - adaptado para health economics
  # Ejemplo: ciertos años con datos problemáticos conocidos
  # dataset[ year==2020,  SP.DYN.LE00.IN   := NA ]  # COVID impact

  ReportarCampos( dataset )
}
#------------------------------------------------------------------------------
#Esta es la parte que los alumnos deben desplegar todo su ingenio
# ADAPTADO para health economics

AgregarVariables  <- function( dataset )
{
  gc()
  
  # ========================================
  # AQUÍ LOS ALUMNOS CREAN SUS VARIABLES
  # ========================================
  
  # Esta función está vacía intencionalmente.
  # Los alumnos deben crear aquí sus propias variables de feature engineering.
  
  # Ejemplos de variables que podrían crear (NO implementadas):
  # - Ratios de eficiencia en salud (e.g., expectativa de vida / gasto per cápita)
  # - Variables de crisis económicas (dummies para años 2008-2009, post-crisis)
  # - Aproximaciones de QALYs usando datos disponibles
  # - Interacciones entre variables (e.g., PIB × mortalidad infantil)
  # - Transformaciones no lineales (logs, raíces, potencias)
  # - YearsSinceFirst: años desde el primer registro positivo de hf3_ppp_pc
  # - Variables específicas de región o nivel de ingreso
  # - Indicadores de desigualdad
  # - Ratios de gasto público vs privado en salud
  
  # IMPORTANTE: Documenten el razonamiento económico de cada variable creada
  
  # ========================================
  # LÓGICA DE SEGURIDAD (NO MODIFICAR)
  # ========================================
  
  # Valvula de seguridad para evitar valores infinitos
  # Paso los infinitos a NA
  infinitos      <- lapply(names(dataset),function(.name) dataset[ , sum(is.infinite(get(.name)))])
  infinitos_qty  <- sum( unlist( infinitos) )
  if( infinitos_qty > 0 )
  {
    cat( "ATENCION, hay", infinitos_qty, "valores infinitos en tu dataset. Seran pasados a NA\n" )
    dataset[mapply(is.infinite, dataset)] <<- NA
  }

  # Valvula de seguridad para evitar valores NaN que es 0/0
  # Paso los NaN a 0, decision polemica si las hay
  # Se invita a asignar un valor razonable segun la semantica del campo creado
  nans      <- lapply(names(dataset),function(.name) dataset[ , sum(is.nan(get(.name)))])
  nans_qty  <- sum( unlist( nans) )
  if( nans_qty > 0 )
  {
    cat( "ATENCION, hay", nans_qty, "valores NaN 0/0 en tu dataset. Seran pasados arbitrariamente a 0\n" )
    cat( "Si no te gusta la decision, modifica a gusto el programa!\n\n")
    dataset[mapply(is.nan, dataset)] <<- 0
  }

  ReportarCampos( dataset )
}
#------------------------------------------------------------------------------
#esta funcion supone que dataset esta ordenado por   <Country Code, year>
#calcula el lag y el delta lag
# ADAPTADO para health economics

Lags  <- function( cols, nlag, deltas )
{
  gc()
  sufijo  <- paste0( "_lag", nlag )

  dataset[ , paste0( cols, sufijo) := shift(.SD, nlag, NA, "lag"), 
             by= `Country Code`, 
             .SDcols= cols]

  #agrego los deltas de los lags, con un "for" nada elegante
  if( deltas )
  {
    sufijodelta  <- paste0( "_delta", nlag )

    for( vcol in cols )
    {
     dataset[,  paste0(vcol, sufijodelta) := get( vcol)  - get(paste0( vcol, sufijo))]
    }
  }

  ReportarCampos( dataset )
}
#------------------------------------------------------------------------------
#se calculan para los N años previos el minimo, maximo y tendencia calculada con cuadrados minimos
#MANTIENE EXACTAMENTE la misma función C++ pero adaptada para years

cppFunction('NumericVector fhistC(NumericVector pcolumna, IntegerVector pdesde ) 
{
  /* Aqui se cargan los valores para la regresion */
  double  x[100] ;
  double  y[100] ;

  int n = pcolumna.size();
  NumericVector out( 5*n );

  for(int i = 0; i < n; i++)
  {
    //lag
    if( pdesde[i]-1 < i )  out[ i + 4*n ]  =  pcolumna[i-1] ;
    else                   out[ i + 4*n ]  =  NA_REAL ;


    int  libre    = 0 ;
    int  xvalor   = 1 ;

    for( int j= pdesde[i]-1;  j<=i; j++ )
    {
       double a = pcolumna[j] ;

       if( !R_IsNA( a ) ) 
       {
          y[ libre ]= a ;
          x[ libre ]= xvalor ;
          libre++ ;
       }

       xvalor++ ;
    }

    /* Si hay al menos dos valores */
    if( libre > 1 )
    {
      double  xsum  = x[0] ;
      double  ysum  = y[0] ;
      double  xysum = xsum * ysum ;
      double  xxsum = xsum * xsum ;
      double  vmin  = y[0] ;
      double  vmax  = y[0] ;

      for( int h=1; h<libre; h++)
      { 
        xsum  += x[h] ;
        ysum  += y[h] ; 
        xysum += x[h]*y[h] ;
        xxsum += x[h]*x[h] ;

        if( y[h] < vmin )  vmin = y[h] ;
        if( y[h] > vmax )  vmax = y[h] ;
      }

      out[ i ]  =  (libre*xysum - xsum*ysum)/(libre*xxsum -xsum*xsum) ;
      out[ i + n ]    =  vmin ;
      out[ i + 2*n ]  =  vmax ;
      out[ i + 3*n ]  =  ysum / libre ;
    }
    else
    {
      out[ i       ]  =  NA_REAL ; 
      out[ i + n   ]  =  NA_REAL ;
      out[ i + 2*n ]  =  NA_REAL ;
      out[ i + 3*n ]  =  NA_REAL ;
    }
  }

  return  out;
}')

#------------------------------------------------------------------------------
#calcula la tendencia de las variables cols de los ultimos N años
#ADAPTADO para health economics

TendenciaYmuchomas  <- function( dataset, cols, ventana=6, tendencia=TRUE, minimo=TRUE, maximo=TRUE, promedio=TRUE, 
                                 ratioavg=FALSE, ratiomax=FALSE){
  gc()
  #Esta es la cantidad de años que utilizo para la historia
  ventana_regresion  <- ventana

  last  <- nrow( dataset )

  #creo el vector_desde que indica cada ventana
  #de esta forma se acelera el procesamiento ya que lo hago una sola vez
  vector_ids   <- dataset$`Country Code`

  vector_desde  <- seq( -ventana_regresion+2,  nrow(dataset)-ventana_regresion+1 )
  vector_desde[ 1:ventana_regresion ]  <-  1

  for( i in 2:last )  if( vector_ids[ i-1 ] !=  vector_ids[ i ] ) {  vector_desde[i] <-  i }
  for( i in 2:last )  if( vector_desde[i] < vector_desde[i-1] )  {  vector_desde[i] <-  vector_desde[i-1] }

  for(  campo  in   cols )
  {
    nueva_col     <- fhistC( dataset[ , get(campo) ], vector_desde ) 

    if(tendencia)  dataset[ , paste0( campo, "_tend", ventana) := nueva_col[ (0*last +1):(1*last) ]  ]
    if(minimo)     dataset[ , paste0( campo, "_min", ventana)  := nueva_col[ (1*last +1):(2*last) ]  ]
    if(maximo)     dataset[ , paste0( campo, "_max", ventana)  := nueva_col[ (2*last +1):(3*last) ]  ]
    if(promedio)   dataset[ , paste0( campo, "_avg", ventana)  := nueva_col[ (3*last +1):(4*last) ]  ]
    if(ratioavg)   dataset[ , paste0( campo, "_ratioavg", ventana)  := get(campo) /nueva_col[ (3*last +1):(4*last) ]  ]
    if(ratiomax)   dataset[ , paste0( campo, "_ratiomax", ventana)  := get(campo) /nueva_col[ (2*last +1):(3*last) ]  ]
  }
ReportarCampos(dataset)
}
#------------------------------------------------------------------------------
#Autor: Antonio Velazquez Bustamente,  UBA 2021
# ADAPTADO para health economics

Tony  <- function( cols )
{

  sufijo  <- paste0( "_tony")

  dataset[ , paste0( cols, sufijo) := lapply( .SD,  function(x){ x/mean(x, na.rm=TRUE)} ), 
             by= year, 
             .SDcols= cols]

  ReportarCampos( dataset )
}

#------------------------------------------------------------------------------
#Elimina del dataset las variables que estan por debajo de la capa geologica de canaritos
#ADAPTADO para health economics

GVEZ <- 1 

CanaritosImportancia  <- function( canaritos_ratio=0.2 )
{
  gc()
  ReportarCampos( dataset )
  
  canaritos_year_end <- PARAMS$feature_engineering$const$canaritos_year_end
  
  for( i  in 1:(ncol(dataset)*canaritos_ratio))  dataset[ , paste0("canarito", i ) :=  runif( nrow(dataset))]
  campos_buenos  <- setdiff( colnames(dataset), c("Country Code","year",PARAMS$feature_engineering$const$clase ) )
  azar  <- runif( nrow(dataset) )
  dataset[ , entrenamiento := year>= PARAMS$feature_engineering$const$canaritos_year_start &  year< canaritos_year_end & azar < 0.10  ]
  
  dtrain  <- lgb.Dataset( data=    data.matrix(  dataset[ entrenamiento==TRUE, campos_buenos, with=FALSE]),
                          label=   dataset[ entrenamiento==TRUE, get(PARAMS$feature_engineering$const$clase)],
                          free_raw_data= FALSE
  )
  
  canaritos_year_valid <- PARAMS$feature_engineering$const$canaritos_year_valid
  
  dvalid  <- lgb.Dataset( data=    data.matrix(  dataset[ year==canaritos_year_valid, campos_buenos, with=FALSE]),
                          label=   dataset[ year==canaritos_year_valid, get(PARAMS$feature_engineering$const$clase)],
                          free_raw_data= FALSE
  )
  
  param <- list( objective= "regression",
                 metric= "rmse",
                 first_metric_only= TRUE,
                 boost_from_average= TRUE,
                 feature_pre_filter= FALSE,
                 verbosity= -100,
                 seed= 999983,
                 max_depth=  -1,         # -1 significa no limitar,  por ahora lo dejo fijo
                 min_gain_to_split= 0.0, #por ahora, lo dejo fijo
                 lambda_l1= 0.0,         #por ahora, lo dejo fijo
                 lambda_l2= 0.0,         #por ahora, lo dejo fijo
                 max_bin= 1023,            #por ahora, lo dejo fijo
                 num_iterations= 500,   #un numero muy grande, lo limita early_stopping_rounds
                 force_row_wise= TRUE,    #para que los alumnos no se atemoricen con tantos warning
                 learning_rate= 0.065, 
                 feature_fraction= 1.0,   #lo seteo en 1 para que las primeras variables del dataset no se vean opacadas
                 min_data_in_leaf= 260,
                 num_leaves= 60,
                 # num_threads= 8,
                 early_stopping_rounds= 50 )
  
  modelo  <- lgb.train( data= dtrain,
                        valids= list( valid= dvalid ),
                        # eval= fganancia_lgbm_meseta,
                        param= param,
                        verbose= -100 )
  
  tb_importancia  <- lgb.importance( model= modelo )
  tb_importancia[  , pos := .I ]
  
  GVEZ  <<- GVEZ + 1
  
  umbral  <- tb_importancia[ Feature %like% "canarito", median(pos) + 2*sd(pos) ] 
  
  col_utiles  <- tb_importancia[ pos < umbral & !( Feature %like% "canarito"),  Feature ]
  col_utiles  <-  unique( c( col_utiles,  c("Country Code","year",PARAMS$feature_engineering$const$clase,"year_cycle") ) )
  col_inutiles  <- setdiff( colnames(dataset), col_utiles )
  
  dataset[  ,  (col_inutiles) := NULL ]
  
  
  ReportarCampos( dataset )
}
#------------------------------------------------------------------------------
#agrega para cada columna de cols una nueva variable _rank  que es un numero entre 0 y 1  del ranking de esa variable ese año
# ADAPTADO para health economics

Rankeador  <- function( cols )
{
  gc()
  sufijo  <- "_rank" 

  for( vcol in cols )
  {
     dataset[ , paste0( vcol, sufijo) := frank( get(vcol), ties.method= "random")/ .N, 
                by= year ]
  }

  ReportarCampos( dataset )
}

#------------------------------------------------------------------------------
#------------------------------------------------------------------------------
#### Aqui empieza el programa ####

paises_problema <- c("Portugal","Norway","Panama","United States","Cyprus","Greece","Australia","Italy","Canada","Lithuania","Chile","Montenegro")

#cargo el dataset
setwd(PARAMS$environment$base_dir)
setwd(PARAMS$environment$data_dir)
nom_arch  <-  PARAMS$feature_engineering$files$input$dentrada
dataset   <- fread( nom_arch )
dataset <- dataset[!(`Country Name` %in% paises_problema)]


#ordeno el dataset por <Country Code, year> para poder hacer lags
setorderv( dataset, PARAMS$feature_engineering$const$campos_sort )

###################################################################

# Crear la clase intermedia - ADAPTADO para health economics
dataset[,PARAMS$feature_engineering$const$clase:=
  get(PARAMS$feature_engineering$const$origen_clase)
,by=c("region", "Country Code")
]
# Aca hago el lead segun cuanto quiera predecir hacia el futuro
dataset[,PARAMS$feature_engineering$const$clase:=shift(
  get(PARAMS$feature_engineering$const$clase)
  ,n=PARAMS$feature_engineering$const$orden_lead
  ,type = "lead"
  ),by=c("region", "Country Code")]


AgregarMes( dataset )  #agrego el ciclo del año

if( length( PARAMS$feature_engineering$param$variablesdrift) > 0 )    DriftEliminar( dataset, PARAMS$feature_engineering$param$variablesdrift )

if( PARAMS$feature_engineering$param$dummiesNA )  DummiesNA( dataset )  #esta linea debe ir ANTES de Corregir  !!

if( PARAMS$feature_engineering$param$corregir == "ClaudioCastillo" )  CorregirClaudioCastillo( dataset )  #esta linea debe ir DESPUES de  DummiesNA
if( PARAMS$feature_engineering$param$corregir == "AsignarNA" )       CorregirNA( dataset )  #esta linea debe ir DESPUES de  DummiesNA

if( PARAMS$feature_engineering$param$variablesmanuales )  AgregarVariables( dataset )

dataset[,PARAMS$feature_engineering$const$origen_clase:=NULL]
#--------------------------------------
#Esta primera parte es muuuy  artesanal  y discutible  ya que hay multiples formas de hacerlo

cols_lagueables  <- copy( setdiff( colnames(dataset), PARAMS$feature_engineering$const$campos_fijos ) )


for( i in 1:length( PARAMS$feature_engineering$param$tendenciaYmuchomas$correr ) ){
  if( PARAMS$feature_engineering$param$tendenciaYmuchomas$correr[i] ) 
  {
    #veo si tengo que ir agregando variables
    if( PARAMS$feature_engineering$param$acumulavars )  cols_lagueables  <- setdiff( colnames(dataset), PARAMS$feature_engineering$const$campos_fijos )

    cols_lagueables  <- intersect( colnames(dataset), cols_lagueables )
    TendenciaYmuchomas( dataset, 
                        cols= cols_lagueables,
                        ventana=   PARAMS$feature_engineering$param$tendenciaYmuchomas$ventana[i],
                        tendencia= PARAMS$feature_engineering$param$tendenciaYmuchomas$tendencia[i],
                        minimo=    PARAMS$feature_engineering$param$tendenciaYmuchomas$minimo[i],
                        maximo=    PARAMS$feature_engineering$param$tendenciaYmuchomas$maximo[i],
                        promedio=  PARAMS$feature_engineering$param$tendenciaYmuchomas$promedio[i],
                        ratioavg=  PARAMS$feature_engineering$param$tendenciaYmuchomas$ratioavg[i],
                        ratiomax=  PARAMS$feature_engineering$param$tendenciaYmuchomas$ratiomax[i]
                      )
  # elimino las variables poco importantes, para hacer lugar a las importantes
    if( PARAMS$feature_engineering$param$tendenciaYmuchomas$canaritos[ i ] > 0 )  CanaritosImportancia( canaritos_ratio= unlist(PARAMS$feature_engineering$param$tendenciaYmuchomas$canaritos[ i ]) )

  }
}


for( i in 1:length( PARAMS$feature_engineering$param$lags$correr ) ){
  if( PARAMS$feature_engineering$param$lags$correr[i] )
  {
    #veo si tengo que ir agregando variables
    if( PARAMS$feature_engineering$param$acumulavars )  cols_lagueables  <- setdiff( colnames(dataset), PARAMS$feature_engineering$const$campos_fijos )

    cols_lagueables  <- intersect( colnames(dataset), cols_lagueables )
    Lags( cols_lagueables, 
          PARAMS$feature_engineering$param$lags$lag[i], 
          PARAMS$feature_engineering$param$lags$delta[ i ] )   #calculo los lags de orden  i

    #elimino las variables poco importantes, para hacer lugar a las importantes
    if( PARAMS$feature_engineering$param$lags$canaritos[ i ] > 0 )  CanaritosImportancia( canaritos_ratio= unlist(PARAMS$feature_engineering$param$lags$canaritos[ i ]) )
  }
}


if( PARAMS$feature_engineering$param$acumulavars )  cols_lagueables  <- setdiff( colnames(dataset), PARAMS$feature_engineering$const$campos_fijos )

#agrego los rankings
if( PARAMS$feature_engineering$param$rankeador ) {
  if( PARAMS$feature_engineering$param$acumulavars )  cols_lagueables  <- setdiff( colnames(dataset), PARAMS$feature_engineering$const$campos_fijos )

  cols_lagueables  <- intersect( colnames(dataset), cols_lagueables )
  setorderv( dataset, PARAMS$feature_engineering$const$campos_rsort )
  Rankeador( cols_lagueables )
  setorderv( dataset, PARAMS$feature_engineering$const$campos_sort )
}

if( PARAMS$feature_engineering$param$canaritos_final > 0  )   CanaritosImportancia( canaritos_ratio= PARAMS$feature_engineering$param$canaritos_final )

#dejo la clase como ultimo campo
nuevo_orden  <- c( setdiff( colnames( dataset ) , PARAMS$feature_engineering$const$clase ) , PARAMS$feature_engineering$const$clase )
setcolorder( dataset, nuevo_orden )

# Corrijo los NANs que surgieron de los ratios
cols_lagueables  <- copy( setdiff( colnames(dataset), PARAMS$feature_engineering$const$campos_fijos ) )
for(col in cols_lagueables){
  dataset[[col]][is.nan(dataset[[col]])] <- 0
}

# Filtro los datos: solo observaciones con clase definida O el año presente
dataset <- dataset[(!is.na(get(PARAMS$feature_engineering$const$clase)))|year>=PARAMS$feature_engineering$const$presente]

#Grabo el dataset
experiment_dir <- paste(PARAMS$experiment$experiment_label,PARAMS$experiment$experiment_code,sep = "_")
experiment_lead_dir <- paste(PARAMS$experiment$experiment_label,PARAMS$experiment$experiment_code,paste0("f",PARAMS$feature_engineering$const$orden_lead),sep = "_")

setwd(PARAMS$environment$base_dir)
setwd(paste0(PARAMS$experiment$exp_dir))

dir.create(experiment_dir,showWarnings = FALSE)
setwd(experiment_dir)
dir.create(experiment_lead_dir,showWarnings = FALSE)
setwd(experiment_lead_dir)

PARAMS$features$features_n <- length(colnames(dataset))
PARAMS$features$colnames <- colnames(dataset)

jsontest = jsonlite::toJSON(PARAMS, pretty = TRUE, auto_unbox = TRUE)
sink(file = paste0(experiment_lead_dir,".json"))
print(jsontest)
sink(file = NULL)

dir.create("01_FE",showWarnings = FALSE)
setwd("01_FE")

fwrite( dataset,
        paste0( experiment_lead_dir,".csv.gz" ),
        logical01= TRUE,
        sep= "," )

cat("\n=== FEATURE ENGINEERING HEALTH ECONOMICS COMPLETADO ===\n")
cat("Dimensiones finales del dataset:", nrow(dataset), "x", ncol(dataset), "\n")
cat("Archivo guardado exitosamente\n")

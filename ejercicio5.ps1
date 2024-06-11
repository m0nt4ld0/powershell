<#
.SYNOPSIS
     TP1, Ejercicio Número 5. Este script permite reservar un viaje en micro.
# Ejercicio5.ps1
# TP1 - Ejercicio 5
# Curso: 	Lunes y Miercoles Noche
#Primer Entrega

    

.DESCRIPTION
    Este script permite reservar un viaje en micro a partir del ingreso del origen y destino. 

.PARAMETER ciudadOrigen
    String que especifica la ciudad desde la que sale el micro (Obligatorio).

.PARAMETER ciudadDestino
    String que especifica la ciudad a la que llega el micro (Obligatorio).

.PARAMETER cambioEuro
    String que especifica la tasa de cambio (Opcional).

.EXAMPLE
  ---- El script se debe ejecutar de la siguiente manera: pathScript ciudadOrigen ciudadDestino cambioEuro

  Por ejemplo: C:\PS> .\ejercicio5.ps1 Kotor Tirana 140

#>

Param(  [Parameter(Position = 1, Mandatory=$true)][ValidateNotNullOrEmpty()][string]$ciudadOrigen,	
   [Parameter(Position = 2, Mandatory= $true)][ValidateNotNullOrEmpty()][string] $ciudadDestino,
   [Parameter(Position = 3, Mandatory= $false)] $cambioEuro
)

#Leo archivo CSV
$micros = Import-Csv ejemploCSV.csv -delimiter ";"
#Obtengo fecha
$fechaHoraActual = Get-Date -UFormat "%d/%m/%Y %H:%M"
write "Se muestran los pasajes disponibles a partir de: $fechaHoraActual"
#Filtro por los parametros
#Falta filtrar los casos en donde la fecha desde sea menor a la de la ejecucion
$microsDisponibles = $micros | where-object{$_."desde" -like "$ciudadOrigen*" -and 
                                            $_."hasta" -like "$ciudadDestino*" -and 
                                            $_.asientos_libres -gt 0 -and
                                            #Se realiza el parse de las fechas para poder compararlas
                                            ([datetime]::ParseExact($_.fecha_hora_desde,"dd/MM/yyyy H:mm",$null)) -gt ([datetime]::ParseExact($fechaHoraActual,"dd/MM/yyyy H:mm",$null))
                                            } 

$linenumber = 1  
if($cambioEuro){
    write "La tasa de cambio de Leks a Euro es $cambioEuro"
    $precioTag = 'Valor Euro'
    $conversion = $cambioEuro
}else{
$precioTag = 'Valor Leks'
$conversion = 1
}

#Muestro opciones
Write-Output $microsDisponibles | ForEach-Object {
   New-Object psObject -Property @{
        'Número de viaje'=$linenumber; 
        'Ciudad Origen'=$_."desde"; 
        'Ciudad Destino'= $_."hasta"; 
        'Asientos Libres'=$_.asientos_libres; 
        $precioTag = $_.precio/$conversion;
        'Día de salida'=$_.fecha_hora_desde 
        };
    $linenumber ++
    
    }  | 
Format-Table -AutoSize #-Property 'Número de viaje','Ciudad Origen','Ciudad Destino','Precio Leks','Asientos Libres','Día de salida'

#Elijo un viaje
#Acá no se como indicar que opcion es cada fila. Lo tome como que 
#el numero de fila es la opcion
$input = Read-Host "Elija un viaje en micro" 

#Actualizo la cantidad de asientos en el objeto
ForEach ($micro in $micros) { if( $micro."desde" -eq $microsDisponibles[$input-1].desde -and
                                  $micro.fecha_hora_desde -eq $microsDisponibles[$input-1].fecha_hora_desde -and
                                  $micro."hasta" -eq $microsDisponibles[$input-1].hasta -and
                                  $micro.fecha_hora_hasta -eq $microsDisponibles[$input-1].fecha_hora_hasta -and
                                  $micro.precio -eq $microsDisponibles[$input-1].precio )
                                { $micro.asientos_libres = $micro.asientos_libres-1}
                         } 

#Actualizo el archivo CSV
$micros | Export-Csv ejemploCSV.csv -delimiter ";"  -encoding UTF8


Write-Output $micros | Format-Table -AutoSize

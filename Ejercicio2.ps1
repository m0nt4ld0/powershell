<#
.SYNOPSIS
     TP1, Ejercicio Número 2. Este script permite automatizar las peticiones de descargas de archivos.
# Ejercicio2.ps1
# TP1 - Ejercicio 2
# Curso: 	Lunes y Miercoles Noche
#Primer Entrega


.DESCRIPTION
    A partir de una lista de URLs indicadas en un archivo de texto, se registrará cada una de las descargas y se obtendrá un archivo de log 
	donde se indicará la hora de inicio, el tiempo insumido y el tamaño del archivo. 

.PARAMETER archivoDescargas
    String que indica el path del archivo que contiene las URLs de descargas (Obligatorio).

.PARAMETER carpetaDescargas
    String que indica el path del directorio donde se guardaran las descargas (Obligatorio).

.PARAMETER [carpetaLog]
    String que indica el path del archivo de log. Este parametro es opcional, si no se especifica se tomará el path de descargas.

.EXAMPLE
  ---- El script se debe ejecutar de la siguiente manera: pathScript archivoDescargas carpetaDescargas carpetaLog

  Por ejemplo: C:\PS> .\ejercicio2.ps1 C:\archivoDescargas.txt C:\CarpetaDestinoDescargas\ C:\CarpetaDestinoLog\

#>

Param(  [Parameter(Position = 1, Mandatory=$true)][ValidateNotNullOrEmpty()][string]$archivoDescargas,	
   [Parameter(Position = 2, Mandatory= $true)][ValidateNotNullOrEmpty()][string] $carpetaDescargas,
   [Parameter(Position = 3, Mandatory= $false)][string] $carpetaLog = $carpetaDescargas
)


function esRutaValida
{
    Param([string] $r)
    if ( (Test-Path $r) -ne $True )
    {
        write-output "ERROR: No se encuentra la ruta" + $r + ". Por favor, especifique una ruta válida e intente nuevamente."
        return $false #El return puede obviarse y solo usar $False
    }
    return $True
}

if(((esRutaValida $archivoDescargas) -ne $true) -or ((esRutaValida $carpetaDescargas) -ne $true) -or ((esRutaValida $carpetaLog) -ne $true))     
{
    exit 1
}
#validar para el archivo .txt que la ruta esté completa
if(($archivoDescargas.toLower().EndsWith(".txt")) -eq $false)
{
    Write-Output "ERROR. La ruta ingresada para el archivo de texto está incompleta."
    exit 1
}


#Creación del objeto WebClient
$cliente = new-object System.Net.WebClient
$carpetaLog = $carpetaLog+"log.log"

foreach($url in Get-Content $archivoDescargas){

#Obtengo nombre del archivo a descargar
$nombreArchivoDescarga = $url.SubString($url.LastIndexOf('/')+1)
$rutaDescarga = $carpetaDescargas+$nombreArchivoDescarga

$inicio = Get-Date #Obtengo fecha inicio
#Descargo el archivo
$cliente.DownloadFile($url,$rutaDescarga)

$tiempoInsumido = (get-date).Subtract($inicio) 

#Armo archivo log
"url: " + $url >> $carpetaLog
"Hora Inicio Descarga: " + $inicio.TimeOfDay >> $carpetaLog
"Tamaño archivo: " + $rutaDescarga.Length + " bytes" >> $carpetaLog
"Tiempo Insumido: " + $tiempoInsumido.Seconds + " seg" >>$carpetaLog
" " >>$carpetaLog
}






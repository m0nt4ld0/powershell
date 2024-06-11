<#
.SYNOPSIS
    TP1, Ejercicio Número 4. Monitorear directorio .

# Ejercicio4.ps1
# TP1 - Ejercicio 4
# Curso: 	Lunes y Miercoles Noche
#Primer Entrega

.DESCRIPTION
    El script permite, a partir de una ruta  recibida por parámetro, y la extension tambien obtenida como parametro monitorear los estadosde los archivos cuya extension sea igual
    a la recibida como parametro.
 
     
.PARAMETER ruta
    ruta donde se encuentra el archivo a monitorear.
.PARAMETER ext
    extension de los archivos que se quieren monitorear.

.EXAMPLE
    .\Ejercicio4.ps1 -ruta "C:\Users\Elena\Desktop\trabajo_practico_SO" -ext ".txt"
.EXAMPLE
    .\Ejercicio4.ps1 -ruta "C:\Users\Elena\Desktop\ejercicio4" -ext ".docx"
#>



Param
(
    [ValidateNotNullOrEmpty()][Parameter(Mandatory=$true)][string]$ruta,[ValidateNotNullOrEmpty()][string][validatelength(1,6)]$ext)
# se ingresa por parametro la ruta a monitorear y la extension por la que quiero filtrar los documentos.

function Get-ScriptDirectory # usamos una funcion para obtener ruta del script y guardar alli un archivo que lleva control de los cambios 
{  
    if($hostinvocation -ne $null) 
    { 
        Split-Path $hostinvocation.MyCommand.path 
    } 
    else 
    { 
        Split-Path $script:MyInvocation.MyCommand.Path 
    } 
} 
 
$fsw = New-Object IO.FileSystemWatcher $ruta 
$fsw.IncludeSubdirectories = $true # incluyo archivos de subdirectorios.
$rutalog = (Get-ScriptDirectory); # obtengo ruta del directorio que contiene el script
Register-ObjectEvent $fsw Created -SourceIdentifier documento_nuevo #se regista a tres eventos y se suscribe a los que necesita 
Register-ObjectEvent $fsw Deleted -SourceIdentifier documento_eliminado
Register-ObjectEvent $fsw Changed -SourceIdentifier documento_actualizado
while ($true)
{
    if($evt = Wait-Event -SourceIdentifier documento_nuevo -Timeout 1){#espera un segundo para el siguiente evento que se genera y tiene como identificador "documento_nuevo"
    $name = $evt.SourceEventArgs.Name #obtengo nombre del archivo que disparo el evento
    $changeType = $evt.SourceEventArgs.ChangeType #obtengo el tipo de evento que se realizo sobre el archivo (borrado,creado o cambiado)
    $timeStamp = $evt.TimeGenerated #obtengo la hora en que se disparo el evento
    $extn = [IO.Path]::GetExtension($name) # me quedo con la extension del archivo disparador 
    if( $extn -eq  $ext){ # valido si la extension filtro usada es igual a la extension del archivo que genero el evento 
    Write-Host "el archivo $name fue $changeType a las $timeStamp" -fore green
 
    Out-File -FilePath $rutalog\outlog.txt -Append -InputObject "el archivo $name fue $changeType a las $timeStamp"} #guarda los registros en un archivo
    else{
       write-host "se creó el archivo con extension diferente a $ext" -fore red
       }
     
    }
    if($evt1 = Wait-Event -SourceIdentifier documento_actualizado -Timeout 1){#espera un segundo para el siguiente evento que se genera y tiene como identificador "documento_actualizado"
    $name = $evt1.SourceEventArgs.Name 
    $changeType = $evt1.SourceEventArgs.ChangeType 
    $timeStamp = $evt1.TimeGenerated 
    $extn = [IO.Path]::GetExtension($name)
    if( $extn -eq  $ext){
    Write-Host "el archivo $name fue $changeType a las $timeStamp" -fore green 
    Out-File -FilePath $rutalog\outlog.txt -Append -InputObject "el archivo $name fue $changeType a las $timeStamp"} 
    else{
       write-host "se actualizó el archivo $name con extension diferente a $ext" -fore red
       }
        
    } 
    if($evt2 = Wait-Event -SourceIdentifier documento_eliminado -Timeout 1){#espera un segundo para el siguiente evento que se genera y tiene como identificador "documento_eliminado"
    $name = $evt2.SourceEventArgs.Name 
    $changeType = $evt2.SourceEventArgs.ChangeType 
    $timeStamp = $evt2.TimeGenerated 
    $extn = [IO.Path]::GetExtension($name)
    if( $extn -eq  $ext){
    Write-Host "el archivo $name fue $changeType a las $timeStamp" -fore green 
    Out-File -FilePath $rutalog\outlog.txt -Append -InputObject "el archivo $name fue $changeType a las $timeStamp"} 
    else{
       write-host "se elimino el archivo $name con extension diferente a $ext" -fore red
       }
   
    }
    #elimina sólo los eventos actualmente en la cola:
     $evt | Remove-Event 
     $evt1 | Remove-Event    
     $evt2 | Remove-Event
 
    # Para dejar de monitorear presionar ctrl + c        
}

<#  
     Para dejar de monitorear, correr los siguientes comandos:
     Unregister-Event documento_nuevo
     Unregister-Event documento_eliminado
     Unregister-Event documento_actualizado

#>

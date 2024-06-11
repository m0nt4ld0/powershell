<#
.SYNOPSIS
    TP1, Ejercicio Número 6. Monitorear procesos listados .

# Ejercicio6.ps1
# TP1 - Ejercicio 6
# Curso: 	Lunes y Miercoles Noche
#Primer Entrega

.DESCRIPTION
    El script permite, a partir de un listado recibido por parámetro monitorear los procesos listados en el mismo
  
 
     
.PARAMETER blacklist
    ruta donde se encuentra el listado de procesos a monitorear.
.PARAMETER logpath
    ruta donde se almacenara el resultado obtenido del monitoreo

.EXAMPLE
    .\Ejercicio6.ps1 -blacklist "C:\Users\documents\listado.txt"
.EXAMPLE
    .\Ejercicio6.ps1 -blacklist "C:\Users\documents\blacklist.txt" -logpath "C:\Users\resultado\"

#>

Param(
    [Parameter(Position=1,Mandatory=$true)][ValidateNotNullOrEmpty()][String] $blacklist,
    [Parameter(Position=2,Mandatory=$false)][String] $logpath
)

#$blacklist -replace ' ', '` ' #Si contiene espacios los escapo

#$path = 'C:\Windows Services\MyService.exe'
#$path -replace ' ', '` '
#invoke-expression $path

#https://stackoverflow.com/questions/28269523/how-to-handle-spaces-in-file-path

$blacklist = $blacklist -replace '/', '\\'
#Valido la ruta del archivo blacklist, y que la ruta proporcionada sea efectivamente un archivo, no una carpeta
if(-not($blacklist) -or (Test-Path $blacklist -PathType Leaf) -eq $false )
{
    Write-Output "La ruta " $blacklist " no existe o no corresponde a un archivo."
    exit 1
}
#Si no se definio path de log utilizo el mismo que la lista negra
if(-not($logpath) -or ((Test-Path $logpath -PathType Container) -eq $false))
{
    Write-Output "La ruta del log no se definió o no corresponde a un directorio. Se utilizará el mismo path que para la lista negra."
    $logpath = $blacklist.Substring(0,$blacklist.LastIndexOf('\'))
}

If ((Get-Content $blacklist) -eq $Null) 
{
    Write-Output "El archivo ubicado en: " $blacklist " está vacío"
   exit 1
}
$logpath += "\log.log"

#Levanto la lista negra del archivo
$procesos = Get-Content $blacklist
while ($true)
{
    foreach($p in $procesos)
    {
        #Si el proceso no esta en ejecucion lanzaria una excepcion, asi que le digo que la ignore con "SilentlyContinue"
        $proceso = Get-Process -Name $p -ErrorAction SilentlyContinue
        if($proceso) #Si el proceso se está ejecutando
        {
            while($proceso)
            {
                Stop-Process -Name $p -ErrorAction SilentlyContinue
                $proceso = Get-Process -Name $p -ErrorAction SilentlyContinue
            }
            write "Se ha detectado la ejecución del proceso " $p
            $fechaHora = Get-Date
            $fechaStr = $fechaHora.Day.ToString() +" - "+$fechaHora.Month.ToString() +" - "+$fechaHora.Year.ToString()+" "+$fechaHora.Hour.ToString()+":"+$fechaHora.Minute.ToString()+":"+$fechaHora.Second.ToString()
            $p + ": " + $fechaStr >> $logpath
        }
    }
 
}
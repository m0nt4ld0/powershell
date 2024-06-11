<#
.SYNOPSIS
TP1, Ejercicio Número 3. Este script permite controlar la cantdad de archivos duplicados.
# Ejercicio3.ps1
# TP1 - Ejercicio 3
# Curso: 	Lunes y Miercoles Noche
#Primer Entrega

.DESCRIPTION
    El script recibirá por parámetro el directorio a inspeccionar y opcionalmente el directorio donde se generará el informe de duplicidad.
    
.PARAMETER pathentrada
    String que indica la ruta en la cual se ejecutará la búsqueda de duplicados.
.PARAMETER [pathsalida] 
    Ruta en la cual opcionalmente se mostrará el donde se generará el informe de duplicidad.

.EXAMPLE
    .\Ejercicio3.ps1 -pathentrada "C:\Mis Documentos\"
.EXAMPLE
    .\Ejercicio3.ps1 -pathentrada "D:\Facultad\Sistemas Operativos\" -pathsalida "D:\Facultad\Resultados\"
#>
    Param ([Parameter(Position = 1, Mandatory=$true)][ValidateNotNullOrEmpty()][string] $pathentrada,
           [Parameter(Position = 2, Mandatory=$false)][string] $pathsalida) #Recibo los dos parámetros necesarios para la ejecución
    #-----------------------------Inicio validaciones------------------------------------------------
  
    if((Test-Path $pathentrada -PathType Container) -ne $true)
    {
        write "La ruta "+ $pathentrada + " no existe"
        exit 1
    }
   
    if(($pathsalida -eq $null) -or (Test-Path $pathsalida -Pathtype Container) -eq $false)
    {
        $pathsalida = $pathentrada + "\Resultado.txt" #Path salida por defecto
    }else{
	$pathsalida = $pathsalida + "\Resultado.txt" #Path pasado por parametro
    }
    #---------------------------------Fin validaciones------------------------------------------------
    $hash = @{}

    #Agrego para que solo se fije en archivos
    gci $pathentrada -recurse -file| % {$hash[$_.BaseName + $_.Extension]++} #guardo un hash donde la clave es el nombre de archivo y cuento cuantas veces está el archivo
    #write $hash | format-table

    foreach ($h in $hash.Keys) {
        
        if($hash[$h] -gt 1){ #Recorro el Hash armado para ver cuales son los archivos repetidos
            gci $pathentrada -recurse -Filter $h |Select-Object Name, CreationTime, LastWriteTime, DirectoryName| Format-table >> $pathsalida
           
        }

    }
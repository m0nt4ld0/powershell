Param($pathsalida) #Recibo como parámetro un path.
$existe = Test-Path $pathsalida #Determina si un path es válido o no. Devuelve TRUE si existe, FALSE si alguna carpeta/nodo no existe.
if ($existe -eq $true) #Pregunta si la variable es igual a TRUE.
{
    $lista = Get-ChildItem -File #Almaceno en la lista toda la colección de objetos de tipo File que se encuentra en ese path.
    foreach ($item in $lista) #Para cada item de la lista
    {
        Write-Host "$($item.Name) $($item.Length)" #Escribo en la pantalla el nombre del item y el peso(tamaño) del archivo
    }
}
else
{
    Write-Error "El path no existe" #Escribe el mensaje con formato de error
}

A) El objetivo del script es mostrar los nombres y el tamaño del conjunto de archivos del directorio dado. Si la ruta especificada no es válida emite un mensaje de error.
#A) El objetivo del script es mostrar los nombres y el tamaño de los archivos del path actual, a pesar de validar el path enviado por parámetro

B) [ValidateNotNullOrEmpty()]
   [string]
   [Parameter (Mandatory = $true)]

C) gci -Path $pathsalida | Format-Table -Autosize -Property Name, Length


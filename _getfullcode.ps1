[CmdletBinding()]
param()

# Script para concatenar contenido de archivos y listar carpetas en un archivo de salida
# Nombre del script: "_getfullcode.ps1"

# Definir variables iniciales usando Set-Variable para mejor rendimiento
Set-Variable -Name "rootDir" -Value (Get-Location)
Set-Variable -Name "rootDirName" -Value (Split-Path -Leaf -Path $rootDir.Path)
Set-Variable -Name "outputFileName" -Value "$rootDirName.txt"
Set-Variable -Name "outputFilePath" -Value (Join-Path -Path $rootDir -ChildPath $outputFileName)
Set-Variable -Name "selfFile" -Value (Join-Path -Path $rootDir -ChildPath "_getfullcode.ps1")

# Definir patrones de exclusión para Git
Set-Variable -Name "excludePatterns" -Value @(
    '.git',
	'__pycache__',
	'__pycache__/',
    '.gitignore'
)

# Inicializar arrays con tipos explícitos para mejor rendimiento
[System.Collections.Generic.List[string]]$addedFiles = @()
[System.Collections.Generic.List[string]]$emptyFolders = @()
[System.Collections.Generic.List[string]]$skippedItems = @()

# Función para verificar si un item debe ser excluido
function Should-Exclude {
    param (
        [Parameter(Mandatory = $true)]
        [string]$path
    )
    
    foreach ($pattern in $excludePatterns) {
        if ($path -like "*$pattern*") {
            return $true
        }
    }
    return $false
}

# Función para escribir en el archivo de salida de manera más eficiente
function Write-OutputFile {
    param (
        [string]$Content,
        [string]$FilePath
    )
    try {
        Add-Content -Path $FilePath -Value $Content -ErrorAction Stop
    }
    catch {
        Write-Error "Error al escribir en el archivo: $($_.Exception.Message)"
        exit 1
    }
}

# Función principal para procesar directorios
function Process-Directory {
    param (
        [Parameter(Mandatory = $true)]
        [string]$dirPath
    )
    
    try {
        # Verificar si el directorio actual debe ser excluido
        if (Should-Exclude -path $dirPath) {
            $relativePath = "./" + $dirPath.Substring($rootDir.Path.Length + 1).Replace("\", "/")
            $skippedItems.Add($relativePath)
            return
        }

        # Obtener items con un solo llamado a Get-ChildItem
        $items = Get-ChildItem -Path $dirPath -Force -ErrorAction Stop
        
        if (-not $items) {
            $relativePath = "./" + $dirPath.Substring($rootDir.Path.Length + 1).Replace("\", "/")
            $emptyFolders.Add($relativePath)
            Write-OutputFile -Content "`n## EMPTY FOLDER: $relativePath/`n" -FilePath $outputFilePath
            return
        }
        
        foreach ($item in $items) {
            # Verificar si el item debe ser excluido
            if (Should-Exclude -path $item.FullName) {
                $relativePath = "./" + $item.FullName.Substring($rootDir.Path.Length + 1).Replace("\", "/")
                $skippedItems.Add($relativePath)
                continue
            }

            if ($item.PSIsContainer) {
                Process-Directory -dirPath $item.FullName
                continue
            }
            
            if ($item.FullName -eq $selfFile -or $item.FullName -eq $outputFilePath) {
                continue
            }
            
            $relativePath = "./" + $item.FullName.Substring($rootDir.Path.Length + 1).Replace("\", "/")
            $addedFiles.Add($relativePath)
            
            # Escribir contenido en bloques
            $fileContent = @(
                "`n## BEGIN OF file: $relativePath`n"
                (Get-Content -Path $item.FullName -Raw)
                "`n## END OF file: $relativePath`n"
            )
            Write-OutputFile -Content $fileContent -FilePath $outputFilePath
        }
    }
    catch {
        Write-Error "Error procesando directorio $dirPath`: $($_.Exception.Message)"
        exit 1
    }
}

# Bloque principal con manejo de errores
try {
    # Limpiar o crear archivo de salida
    if (Test-Path $outputFilePath) {
        Remove-Item -Path $outputFilePath -Force -ErrorAction Stop
    }
    
    Write-Output "Generando el archivo: '$outputFileName'"
    
    # Procesar directorio principal
    Process-Directory -dirPath $rootDir
    
    # Generar y mostrar resumen
    $summary = @(
        "`n--- Resumen ---"
        "Archivos agregados: $($addedFiles.Count)"
        "Carpetas vacias: $($emptyFolders.Count)"
        "Items excluidos (Git): $($skippedItems.Count)"
        "`nLista de archivos agregados:"
        $($addedFiles -join "`n")
        "`nLista de carpetas vacias:"
        $($emptyFolders -join "`n")
        "`nItems excluidos relacionados con Git:"
        $($skippedItems -join "`n")
    )
    
    Write-Output ($summary -join "`n")
}
catch {
    Write-Error "Error general en la ejecución: $($_.Exception.Message)"
    exit 1
}
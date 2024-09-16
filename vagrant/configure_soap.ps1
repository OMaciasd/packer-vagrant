# configure_soap.ps1

# Definir la ruta del directorio del proyecto en IIS
$sitePath = "C:\inetpub\wwwroot\MySoapService"
$siteName = "MySoapService"

# Crear el directorio para el servicio SOAP
New-Item -Path $sitePath -ItemType Directory -Force

# Copiar los archivos del servicio SOAP al directorio
# Asume que los archivos están en una carpeta compartida o en la máquina local
Copy-Item -Path "\\vagrant\shared\MySoapService\*" -Destination $sitePath -Recurse -Force

# Crear un nuevo sitio en IIS
New-WebSite -Name $siteName -PhysicalPath $sitePath -Port 80 -ApplicationPool "DefaultAppPool"

# Configurar permisos para el directorio del sitio
$acl = Get-Acl $sitePath
$permission = "IIS_IUSRS","ReadAndExecute","Allow"
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
$acl.SetAccessRule($accessRule)
Set-Acl $sitePath $acl

# Verificar que el sitio esté creado
Get-WebSite -Name $siteName

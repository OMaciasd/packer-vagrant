# install_iis.ps1

# Instalar el rol de IIS
Install-WindowsFeature -Name Web-Server -IncludeManagementTools

# Verificar que IIS se ha instalado
Get-WindowsFeature -Name Web-Server

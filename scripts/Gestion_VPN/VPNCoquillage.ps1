function Create-VPNUsersFromAD {
    param (
        [Parameter(Mandatory=$true)]
        [string]$vpnServer,
        [Parameter(Mandatory=$true)]
        [string]$adDomain,
        [Parameter(Mandatory=$true)]
        [string]$adUsers,
        [Parameter(Mandatory=$true)]
        [string]$vpnPassword
    )

    # Charger le module Active Directory PowerShell
    Import-Module ActiveDirectory

        # Définir le nom d'utilisateur et le nom complet
        $vpnUsername = $adUser.SamAccountName
        $vpnFullname = $adUser.Name

        # Vérifier si l'utilisateur VPN existe déjà
        $existingUser = Get-LocalUser -Name $vpnUsername

        if ($existingUser) {
            Write-Host "L'utilisateur VPN '$vpnUsername' existe déjà. Ignorer la création d'un nouvel utilisateur." -ForegroundColor Yellow
            continue
        }

        # Créer un nouvel utilisateur pour le VPN
        New-LocalUser -Name $vpnUsername -FullName $vpnFullname -Password (ConvertTo-SecureString -String $vpnPassword -AsPlainText -Force) -Description "Utilisateur VPN pour $vpnServer"

        # Ajouter l'utilisateur au groupe VPN
        Add-LocalGroupMember -Group "Remote Access Users" -Member $vpnUsername

        # Autoriser l'utilisateur à se connecter au VPN
        Set-VpnUserAuth -UserName $vpnUsername -Password (ConvertTo-SecureString -String $vpnPassword -AsPlainText -Force) -AuthenticationMethod MSChapv2 -VPNServerAddress $vpnServer
}
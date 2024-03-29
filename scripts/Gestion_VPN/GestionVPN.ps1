function Creer-CompteVPN {
    Param(
        [Parameter(Mandatory=$true)]
        [string]$Utilisateur,
        
        [Parameter(Mandatory=$true)]
        [string]$MotDePasse
    )
    
    # Vérification de l'existence de l'utilisateur dans l'AD
    $UtilisateurAD = Get-ADUser -Identity $Utilisateur
    if ($UtilisateurAD -eq $null) {
        Write-Host "L'utilisateur $Utilisateur n'existe pas dans l'Active Directory."
        return
    }
    
    # Création du compte VPN sur le serveur VPN
    $SecurePassword = ConvertTo-SecureString -String $MotDePasse -AsPlainText -Force
    $Credential = New-Object System.Management.Automation.PSCredential($Utilisateur, $SecurePassword)
    
    $Params = @{
        'ServerAddress' = '10.1.1.17'
        'AuthenticationMethod' = 'MSCHAPv2'
        'TunnelType' = 'PPTP'
        'EncryptionLevel' = 'Optional'
        'L2tpPsk' = 'None'
        'Force' = $true
        'PassThru' = $true
    }
    
    $VPN = Add-VpnConnection @Params
    if ($VPN -eq $null) {
        Write-Host "Erreur lors de la création du compte VPN pour l'utilisateur $Utilisateur."
        return
    }
    
    # Ajout de l'utilisateur au groupe ADVPN
    Add-ADGroupMember -Identity ADVPN -Members $Utilisateur
    
    Write-Host "Le compte VPN pour l'utilisateur $Utilisateur a été créé avec succès."
}

# Importer les différents modules

Import-Module '.\scripts\Gestion_User\GestionAD.ps1'
Import-Module '.\scripts\Wipe Temp\Wipe.ps1'
Import-Module '.\scripts\CMDB\ImportDataAD.ps1'


# Functions Affichage
function AfficherMenuPrincipal {
    Clear-Host
    Write-Host "Ceci est notre super programme"
    Write-Host "1. Liste Utilisteur"
    Write-Host "2. Selectionner Utilisateur"
    Write-Host "3. Menu Action"
    Write-Host "Q. Quitter"
}
function AfficherMenuOptions {
    param(
        [string]$selected_user
    )
    Clear-Host
    Write-Host "Menu Action"
    Write-Host "Les actions seront effectue pour l'utilisateur : $selected_user"
    Write-Host "1. Compte Utilisateur"
    Write-Host "2. Compte VPN"
    Write-Host "3. Compte Mail"
    Write-Host "4. Equipement"
    Write-Host "5. Wipe"
    Write-Host "9. Suppression du compte"
    Write-Host "Q. Retour menu principal"
}
function AfficherMenuCompteUtilisateur {
    param(
        [string]$selected_user
    )
    Clear-Host
    Write-Host "Menu Compte Utilisateur"
    Write-Host "Les actions seront effectue pour l'utilisateur : $selected_user"
    Write-Host "1. Nom/Prenom"
    Write-Host "2. Reset de Mot de passe"
    Write-Host "3. Activation/Desactivation"
    Write-Host "4. Groupe"
    Write-Host "9.Informations"
    Write-Host "Q. Retour menu principal"
}
function AfficherMenuActivation {
    param (
        [string]$selected_user
    )
    Clear-Host
    Write-Host "Menu Activation/Desactivation Compte"
    Write-Host "Les actions seront effectue pour l'utilisateur : $selected_user"
    Write-Host "1. Activer"
    Write-Host "2. Desactiver"
    Write-Host "Q. Retour menu principal"
}
function AfficherMenuGroupe {
    param (
        [string]$selected_user
    )
    Clear-Host
    Write-Host "Menu Groupe User"
    Write-Host "Les actions seront effectue pour l'utilisateur : $selected_user"
    Write-Host "1. Lister tous les groupes"
    Write-Host "2. Lister les groupes de l'utilisateur"
    Write-Host "3. Ajouter des groupes"
    Write-Host "4. Supprimer des groupes"
    Write-Host "Q. Retour menu principal"
}
function AfficherMenuCompteVPN {
    param(
        [string]$selected_user
    )
    Clear-Host
    Write-Host "Menu Compte VPN"
    Write-Host "Les actions seront effectue pour l'utilisateur : $selected_user"
    Write-Host "Q. Retour menu principal"  
}
function AfficherMenuCompteMail {
    param(
        [string]$selected_user
    )
    Clear-Host
    Write-Host "Menu Compte Mail"
    Write-Host "Les actions seront effectue pour l'utilisateur : $selected_user"
    Write-Host "1. Gestion Taille Boite"
    Write-Host "Q. Retour menu principal"
}
function AfficherMenuEquipement {
    param(
        [string]$selected_user
    )
    Clear-Host
    Write-Host "Menu Equipement"
    Write-Host "Les actions seront effectue pour l'utilisateur : $selected_user"
    Write-Host "1. Lister les equipements"
    Write-Host "2. Ordinateur"
    Write-Host "3. Ecrans"
    Write-Host "4. Autre"
    Write-Host "Q. Retour menu principal"
}
function AfficherMenuWipe {
    param (
        [string]$selected_user
    )
    Clear-Host
    Write-Host "Menu Wipe"
    Write-Host "1. Liste Computer"
    Write-Host "2. Select Computer"
    Write-Host "3. Wipe"
    Write-Host "Q. Retour menu principal"
}
function AfficherMenuSuppression {
    param(
        [string]$selected_user
    )
    Clear-Host
    Write-Host "Menu Suppression"
    Write-Host "Les actions seront effectue pour l'utilisateur : $selected_user"
}
function AfficheListeUtilisateur {
    param(
        [System.Management.Automation.PSCredential]$cred
    )
    Clear-Host
    Write-Host "Liste utilisateur"
    $listeUser = (Invoke-Command -ComputerName 10.1.1.16 -Credential $credentials -ScriptBlock ${function:Get_ESGIAD_Users})
    foreach($item in $listeUser) {
        $name = $item.name
        $login = $item.SamAccountName
        Write-Host "Name : [$name]"
        Write-Host "Login: [$login]"

        Write-Host ""
    }
    Read-Host -Prompt "Retour menu"
}
# Functions Menu
function MenuOption {
    param(
        [string]$selected_user,
        [System.Management.Automation.PSCredential]$cred,
        [string]$selected_SamUser
    )
    do {
        AfficherMenuOptions $selected_user
        $choix = Read-Host "Entrez le chiffre correspondant au menu que vous souhaitez afficher"
        switch ($choix) {
            "1" {
                MenuCompteUtilisateur $selected_user $cred $selected_SamUser
            }
            "2" {
                MenuCompteVPN $selected_user
            }
            "3" {
                MenuCompteMail $selected_user
            }
            "4" {
                MenuEquipement $selected_user
            }
            "5" {
                MenuWipe $cred
            }
            "9" {
                MenuSuppression $selected_user
            }
            default {
                Write-Host "Choix invalide. Veuillez entrer le chiffre correspondant au menu que vous souhaitez afficher."
                Read-Host -Prompt "Appuyez sur Entree pour continuer"
            }
            "Q" {
                break
            }
        }
    } while ($choix -ne "Q") 
    
}
# Function compte utilisateur
function MenuCompteUtilisateur {
    param(
        [string]$selected_user,
        [System.Management.Automation.PSCredential]$cred,
        [string]$selected_SamUser
    )
    do {
        AfficherMenuCompteUtilisateur $selected_user
        $choix = Read-Host "Entrez le chiffre correspondant au menu que vous souhaitez afficher"
        switch ($choix) {
            "1" {
                RenameCompte $selected_user $cred $selected_SamUser
            }
            "2" {
                ResetPassword $selected_user $cred $selected_SamUser
            }
            "3" {
                MenuActivation $selected_user $cred $selected_SamUser
            }
            "4" {
                MenuGroupe $selected_user $cred $selected_SamUser
            }
            "9" {
                GetInformationsUser $selected_user $selected_SamUser $cred
            }
            default {
                Write-Host "Choix invalide. Veuillez entrer le chiffre correspondant au menu que vous souhaitez afficher."
                Read-Host -Prompt "Appuyez sur Entree pour continuer"
            }
            "Q" {
                break
            }
        }
    } while ($choix -ne "Q") 
    
}
function MenuActivation {
    param(
        [string]$selected_user,
        [System.Management.Automation.PSCredential]$cred,
        [string]$selected_SamUser
    )
    do {
        AfficherMenuActivation $selected_user
        $choix = Read-Host "Entrez le chiffre correspondant au menu que vous souhaitez afficher"
        switch ($choix) {
            "1" {
                ActivationUserAd $selected_SamUser $cred
            }
            "2" {
                DesactivationUserAd $selected_SamUser $cred
            }
            default {
                Write-Host "Choix invalide. Veuillez entrer le chiffre correspondant au menu que vous souhaitez afficher."
                Read-Host -Prompt "Appuyez sur Entree pour continuer"
            }
            "Q" {
                break
            }
        }
    } while ($choix -ne "Q") 
}
function RenameCompte {
    param(
        [string]$selected_user,
        [System.Management.Automation.PSCredential]$cred,
        [string]$selected_SamUser
    )
    Clear-Host
    Write-Host "Compte Utilisateur"
    Write-Host "Les actions seront effectue pour l'utilisateur : $selected_user"
    $Name = Read-Host -Prompt "Entrer le nouveau nom "
    (Invoke-Command -ComputerName 10.1.1.16 -Credential $credentials -ScriptBlock ${function:Set_ESGIAD_UserName} -ArgumentList "$selected_user","$Name")
    Read-Host -Prompt "retour au Menu"
}
function ResetPassword {
    param(
        [string]$selected_user,
        [System.Management.Automation.PSCredential]$cred,
        [string]$selected_SamUser
    )
    Clear-Host
    Write-Host "Compte Utilisateur"
    Write-Host "Les actions seront effectue pour l'utilisateur : $selected_user"
    $test = (Invoke-Command -ComputerName 10.1.1.16 -Credential $credentials -ScriptBlock ${function:Set_ESGIAD_UserPassword} -ArgumentList "$selected_SamUser")
    Write-Host "$test"
    Read-Host -Prompt "retour au Menu"
}
function ActivationUserAd {
    param (
        [string]$adUser,
        [System.Management.Automation.PSCredential]$cred
    )
    Clear-Host
    Write-Host "Activation du compte $adUser"
    Invoke-Command -ComputerName 10.1.1.16 -Credential $cred -ScriptBlock ${function:Enable_ESGIAD_User} -ArgumentList "$adUser"
    Write-Host "Compte Actif"
    Read-Host -Prompt "Appuyer sur Entrer pour continuer"
}
function DesactivationUserAd {
    param (
        [string]$adUser,
        [System.Management.Automation.PSCredential]$cred
    )
    Clear-Host
    Write-Host "Activation du compte $adUser"
    Invoke-Command -ComputerName 10.1.1.16 -Credential $cred -ScriptBlock ${function:Disable_ESGIAD_User} -ArgumentList "$adUser"
    Write-Host "Compte desactiver"
    Read-Host -Prompt "Appuyer sur Entrer pour continuer"
}
function GetInformationsUser {
    param (
        [string]$selected_user,
        [string]$adUser,
        [System.Management.Automation.PSCredential]$cred
    )
    Clear-Host
    Write-Host "Information du compte $selected_user"
    Invoke-Command -ComputerName 10.1.1.16 -Credential $cred -ScriptBlock ${function:Get_ESGIAD_AllUserDetails} -ArgumentList "$adUser"
    Read-Host -Prompt "Retour menu"
}
# groupe
function MenuGroupe {
    param(
        [string]$selected_user,
        [System.Management.Automation.PSCredential]$cred,
        [string]$selected_SamUser
    )
    do {
        AfficherMenuGroupe $selected_user
        $choix = Read-Host "Entrez le chiffre correspondant au menu que vous souhaitez afficher"
        switch ($choix) {
            "1" {
                ListAllGroup $cred
            }
            "2" {
                ListUserGroup $cred $selected_SamUser
            }
            "3" {
                AjoutUserGroup $cred $selected_SamUser
            }
            "4" {
                SupUserGroup $cred $selected_SamUser
            }
            default {
                Write-Host "Choix invalide. Veuillez entrer le chiffre correspondant au menu que vous souhaitez afficher."
                Read-Host -Prompt "Appuyez sur Entree pour continuer"
            }
            "Q" {
                break
            }
        }
    } while ($choix -ne "Q") 
}
function AjoutUserGroup {
    param (
        [System.Management.Automation.PSCredential]$cred,
        [string]$selected_SamUser
    )
    Clear-Host
    Write-Host "Ajout Groupe a l'utilisateur"
    $group = Read-Host -Prompt "Entrer le groupe a ajouter"
    (Invoke-Command -ComputerName 10.1.1.16 -Credential $cred -ScriptBlock ${function:Add_ESGIAD_GroupMember} -ArgumentList "$selected_SamUser","$group")
    Read-Host -Prompt "Retour au menu"
}
function SupUserGroup {
    param (
        [System.Management.Automation.PSCredential]$cred,
        [string]$selected_SamUser
    )
    Clear-Host
    Write-Host "Ajout Groupe a l'utilisateur"
    $group = Read-Host -Prompt "Entrer le groupe a supprimer"
    (Invoke-Command -ComputerName 10.1.1.16 -Credential $cred -ScriptBlock ${function:Remove_ESGIAD_GroupMember} -ArgumentList "$selected_SamUser","$group")
    Read-Host -Prompt "Retour au menu"
}
function ListAllGroup {
    param (
        [System.Management.Automation.PSCredential]$cred
    )
    Clear-Host
    Write-Host "Liste des Groupes"
    $listeGroups = (Invoke-Command -ComputerName 10.1.1.16 -Credential $cred -ScriptBlock ${function:Get_ESGIAD_AllGroup})
    foreach($item in $listeGroups) {
        $name = $item.name
        $local = $item.DistinguishedName

        Write-Host "Name : [$name]"
        Write-Host "Login: [$local]"

        Write-Host ""
    }
    Read-Host -Prompt "Retour menu"
}
function ListUserGroup {
    param (
        [System.Management.Automation.PSCredential]$cred,
        [string]$selected_SamUser
    )
    Clear-Host
    Write-Host "Liste Groupe de l'utilisateur"
    $listeUserGroup = (Invoke-Command -ComputerName 10.1.1.16 -Credential $cred -ScriptBlock ${function:Get_ESGIAD_UserGroups} -ArgumentList "$selected_SamUser")
    foreach ($item in $listeUserGroup) {
        $name = $item.name
        $local = $item.DistinguishedName

        Write-Host "Name : [$name]"
        Write-Host "Login: [$local]"

        Write-Host ""
    }
    Read-Host -Prompt "Retour au menu"
}

# Function compte VPN
function MenuCompteVPN {
    param(
        [string]$selected_user,
        [System.Management.Automation.PSCredential]$cred
    )
    do {
        AfficherMenuCompteVPN $selected_user
        $choix = Read-Host "Entrez le chiffre correspondant au menu que vous souhaitez afficher"
        switch ($choix) {
            "1" {
                Clear-Host
                Write-Host "Compte VPN"
                
                Read-Host -Prompt "Appuyez sur Entree pour continuer"
            }
            default {
                Write-Host "Choix invalide. Veuillez entrer le chiffre correspondant au menu que vous souhaitez afficher."
                Read-Host -Prompt "Appuyez sur Entree pour continuer"
            }
            "Q" {
                break
            }
        }
    } while ($choix -ne "Q") 
    
}

# Function compte mail
function MenuCompteMail {
    param(
        [string]$selected_user,
        [System.Management.Automation.PSCredential]$cred
    )
    do {
        AfficherMenuCompteMail $selected_user
        $choix = Read-Host "Entrez le chiffre correspondant au menu que vous souhaitez afficher"
        switch ($choix) {
            "1" {
                GestionTailleMail $selected_user
            }
            default {
                Write-Host "Choix invalide. Veuillez entrer le chiffre correspondant au menu que vous souhaitez afficher."
                Read-Host -Prompt "Appuyez sur Entree pour continuer"
            }
            "Q" {
                break
            }
        }
    } while ($choix -ne "Q") 
    
}
function GestionTailleMail {
    param(
        [string]$selected_user,
        [System.Management.Automation.PSCredential]$cred
    )
    Clear-Host
    Write-Host "Compte Mail"
    Write-Host "Les actions seront effectue pour l'utilisateur : $selected_user"
    $taille = Read-Host -Prompt "Entrer la taille (en ...) : "
}
# Function equipement
function MenuEquipement {
    param(
        [string]$selected_user,
        [System.Management.Automation.PSCredential]$cred
    )
    do {
        AfficherMenuEquipement $selected_user
        $choix = Read-Host "Entrez le chiffre correspondant au menu que vous souhaitez afficher"
        switch ($choix) {
            "1" {
                Clear-Host
                Write-Host "Liste des équipements"
            }
            "2" {
                GestionOrdinateur $selected_user
            }
            "3" {
                GestionEcran $selected_user
            }
            "4" {
                GestionAutre $selected_user
            }
            default {
                Write-Host "Choix invalide. Veuillez entrer le chiffre correspondant au menu que vous souhaitez afficher."
                Read-Host -Prompt "Appuyez sur Entree pour continuer"
            }
            "Q" {
                break
            }
        }
    } while ($choix -ne "Q")    
}

function GestionOrdinateur {
    param(
        [string]$selected_user
    )
    Clear-Host
    Write-Host "Gestion Ordinateur"
    Write-Host "Les actions seront effectue pour l'utilisateur : $selected_user"

    Read-Host -Prompt "Appuyez sur Entree pour continuer"
}

function GestionEcran {
    param(
        [string]$selected_user
    )
    Clear-Host
    Write-Host "Gestion Ecran"
    Write-Host "Les actions seront effectue pour l'utilisateur : $selected_user"

    Read-Host -Prompt "Appuyez sur Entree pour continuer"
}

function GestionAutre {
    param(
        [string]$selected_user
    )
    Clear-Host
    Write-Host "Gestion Autre"
    Write-Host "Les actions seront effectue pour l'utilisateur : $selected_user"

    Read-Host -Prompt "Appuyez sur Entree pour continuer"
}
#Wipe
function MenuWipe {
    param(
        [System.Management.Automation.PSCredential]$cred
    )
    do {
        AfficherMenuWipe
        $choix = Read-Host "Entrez le chiffre correspondant au menu que vous souhaitez afficher"
        switch ($choix) {
            "1" {
                ListWipe $cred
            }
            "2" {
                Clear-Host
                Write-Host "Selectionner Utilisateur"
                $selected_computer = Read-Host -Prompt "Entrer l'ordinateur"
            }
            "3" {
                Wipe $cred $selected_computer
            }
            default {
                Write-Host "Choix invalide. Veuillez entrer le chiffre correspondant au menu que vous souhaitez afficher."
                Read-Host -Prompt "Appuyez sur Entree pour continuer"
            }
            "Q" {
                break
            }
        }
    } while ($choix -ne "Q") 
}
function ListWipe {
    param (
        [System.Management.Automation.PSCredential]$cred
    )
    Clear-Host
    Write-Host "Liste des ordinateurs"
    $listeGroups = (Invoke-Command -ComputerName 10.1.1.16 -Credential $cred -ScriptBlock ${function:Get_ESGIAD_Computer})
    foreach($item in $listeGroups) {
        $name = $item.name
        $Dns = $item.DNSHostName
        Write-Host "Name : [$name]"
        Write-Host "DNS: [$Dns]"

        Write-Host ""
    }
    Read-Host -Prompt "Retour menu"
}
function Wipe {
    param (
        [System.Management.Automation.PSCredential]$cred,
        [string]$selected_computer
    )
    Connection $selected_computer $cred
}
# Functions
function CreateNewUser {
    param(
        [System.Management.Automation.PSCredential]$cred
    )
    $surName= Read-Host -Prompt "Entrer le nom"
    $name = Read-Host -Prompt "Entrer le prenom"
    $department = Read-Host -Prompt "service "
    Invoke-Command -ComputerName 10.1.1.16 -Credential $cred -ScriptBlock ${function:Add_ESGIAD_User} -ArgumentList "$surName","$name","$department"

}
function MenuSuppression {
    param(
        [string]$selected_user,
        [System.Management.Automation.PSCredential]$cred
    )
    do {
        AfficherMenuSuppression $selected_user
        $choix = Read-Host "Voulez vous proceder a la suppression complete de l'utilisateur: $selected_user ? (YES/n)"
        switch ($choix) {
            "YES" {
                Write-Host "Suppression en cours"
                Invoke-Command -ComputerName 10.1.1.16 -Credential $cred -ScriptBlock ${function:Remove_ESGIAD_User} -ArgumentList "$selected_user"
            }
            "n" {
                $choix = "Q"
            }
            default {
                Write-Host "Suppression annulé"
                Read-Host -Prompt "Appuyez sur Entree pour continuer"
            }
            "Q" {
                break
            }
        }
    } while ($choix -ne "Q")  
}

# Programme Principal
function Principal {
    $credentials = Get-Credential
    do {
        #import_data_to_CMDB $dredentials
        AfficherMenuPrincipal
        $choix = Read-Host "Entrez le chiffre correspondant au menu que vous souhaitez afficher"
        switch ($choix) {
            "1" {
                AfficheListeUtilisateur $credentials
            }
            "2" {
                Clear-Host
                Write-Host "Selectionner Utilisateur"
                $selected_user = Read-Host -Prompt "Entrer l'utilisateur"
            }
            "3" {
                if ([string]::IsNullOrEmpty($selected_user)) {
                    Clear-Host
                    Write-Host "Selectionner Utilisateur"
                    $selected_user = Read-Host -Prompt "Entrer l'utilisateur"
                }
                $IsExist=0
                $listeUSerAD = (Invoke-Command -ComputerName 10.1.1.16 -Credential $credentials -ScriptBlock ${function:Get_ESGIAD_Users})  
                foreach ($userAD in $listeUSerAD) {
                    if ($userAD.name -eq $selected_user) {
                    $selected_SamUser = $userAD.SamAccountName
                        $IsExist = 1
                    }
                }
                if ($IsExist -eq 0) {
                    Write-Host "L'utilisateur n'exite pas. Voulez vous le creer ?"
                    $choice = Read-Host -Prompt "Oui/Non"

                    if (($choice -eq "oui") -or ($choice -eq "Oui") -or ($choice -eq "O")) {
                        CreateNewUser $credentials
                    }
                    if (($choice -eq "non") -or ($choice -eq "Non") -or ($choice -eq "N")) {
                        Write-Host "retour au menu principal"
                    }
                }
                else {
                    MenuOption $selected_user $credentials $selected_SamUser
                }
            }
            "Q" {
                break
            }
            default {
                Write-Host "Choix invalide. Veuillez entrer le chiffre correspondant au menu que vous souhaitez afficher."
                Read-Host -Prompt "Appuyez sur Entree pour continuer"
            }
        }
    } while ($choix -ne "Q")   
}
Principal
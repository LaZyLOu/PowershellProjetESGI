
function New_ESGIAD_Mailbox {
    param(
        [string]$userID
    )

    # Récupère l'utilisateur dans Active Directory
    $user = Get-ADUser -Identity $userID

    # Vérifie que l'utilisateur n'a pas déjà de boîte aux lettres
    if (Get-Mailbox -Identity $user.SamAccountName) {
        Write-Host "Une boîte aux lettres existe déjà pour l'utilisateur $($user.SamAccountName)."
        return
    }

    # Crée une boîte aux lettres pour l'utilisateur
    New-Mailbox -UserPrincipalName $user.UserPrincipalName -Alias $user.SamAccountName
}


function Remove_ESGIAD_Mailbox {
    param(
        [string]$userID
    )

    # Récupère l'utilisateur dans Active Directory
    $user = Get-ADUser -Identity $userID

    # Vérifie que l'utilisateur a une boîte aux lettres
    $mailbox = Get-Mailbox -Identity $user.SamAccountName
    if (!$mailbox) {
        Write-Host "Aucune boîte aux lettres n'existe pour l'utilisateur $($user.SamAccountName)."
        return
    }

    # Supprime la boîte aux lettres de l'utilisateur
    Remove-Mailbox -Identity $mailbox.Identity -Confirm:$false
}

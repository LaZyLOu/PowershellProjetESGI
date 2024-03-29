function Create_Mailbox {
    param(
        [string]$name,
        [string]$firstname,
        [string]$lastname
    )

    New-Mailbox 
    -Name $name 
    -UserPrincipalName "toto@powershell.lab" 
    -Password (ConvertTo-SecureString -String 'Pa$$word1' -AsPlainText -Force) 
    -FirstName $firstname
    -LastName $lastname

}

    function Get_Mailbox {

    Get-Mailbox -ResultSize unlimited

    Get-Mailbox -OrganizationalUnit Users

    }

    function Remove_Mailbox {

    param(
        [string]$name
     )

    Remove-Mailbox -Identity $name -Permanent $true

    }

    function Enable_Mailbox {

    Enable-Mailbox -Identity $name

    param(
        [string]$name
     )
    }

    function Disable_Mailbox {

    param(
        [string]$name
     )

    Disable-Mailbox -Identity $name

    }

    function Set_Mailbox {

    param(
        [string]$name
     )

    Set-Mailbox -Identity $name -DeliverToMailboxAndForward $true -ForwardingSMTPAddress toto@powershell.lab

    }



    function New-ESGIAD_Mailbox {
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
    
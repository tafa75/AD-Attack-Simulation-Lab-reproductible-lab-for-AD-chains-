<#
  create_ad_domain.ps1
  Bootstrap a small AD lab for offline testing. Must be run in an isolated environment.
#>
Write-Host "This script scaffolds an AD lab. Please adapt to your virtualization platform."
# Example: Install-ADDSForest -DomainName "lab.local" -SafeModeAdministratorPassword (ConvertTo-SecureString "Passw0rd!" -AsPlainText -Force)
<#
  create_ad_domain.ps1
  Bootstrap a small, *vulnerable* AD lab environment (Domain Controller and 2 Member Servers).
  Requires: Windows Server OS (2019/2022) with Hyper-V or VirtualBox installed.
  
  ⚠️ This script MUST be run in an isolated environment (offline/internal VNET).
#>

# --- 1. Installation des Rôles et Features ---
Write-Host "[1/4] Installing AD DS and DNS roles..."
Install-WindowsFeature -Name AD-Domain-Services, DNS -IncludeManagementTools

# --- 2. Configuration du Domaine ---
Write-Host "[2/4] Creating new AD Forest: lab.local"
$securePassword = ConvertTo-SecureString "Passw0rd!" -AsPlainText -Force
Install-ADDSForest `
    -DomainName "lab.local" `
    -SafeModeAdministratorPassword $securePassword `
    -Force

# --- 3. Création des Comptes Vulnérables (Critique pour le lab) ---
Write-Host "[3/4] Creating vulnerable Service and User accounts..."

# Compte vulnérable au Kerberoasting (SPN enregistré, mot de passe faible)
New-ADUser -Name "svc_web" -SamAccountName "svc_web" -AccountPassword $securePassword -Enabled $true
Set-ADUser -Identity "svc_web" -ServicePrincipalNames @("HTTP/webapp.lab.local")

# Compte vulnérable à l'AS-REP Roasting (DontRequirePreAuth = True)
New-ADUser -Name "user_asrep" -SamAccountName "user_asrep" -AccountPassword $securePassword -Enabled $true
Set-ADUser -Identity "user_asrep" -DoesNotRequirePreAuth $true

# --- 4. Configuration des Machines Membres (via GPO/Ansible post-setup) ---
Write-Host "[4/4] AD lab structure ready. Deploy member servers next."

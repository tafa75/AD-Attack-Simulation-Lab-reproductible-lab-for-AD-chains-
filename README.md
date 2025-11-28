# AD-Attack-Simulation-Lab-reproductible-lab-for-AD-chains-
Goal: reproduce enterprise AD attack chains for teaching, red team demos and detection testing. Design: infrastructure-as-code for isolated VMs, repeatable scenarios, BloodHound automation, and documented TL;DRs.
# Active Directory Attack Simulation Lab

Goal: reproduce enterprise AD attack chains for teaching, red team demos and detection testing.
Design: infrastructure-as-code for isolated VMs, repeatable scenarios, BloodHound automation, and documented TL;DRs.

Key scenarios:
- Kerberoasting -> ticket extraction -> service account compromise
- AS-REP roasting on vulnerable accounts
- DCsync replication demo
- Lateral movement templates (SMB/WinRM/PSRemoting)

Structure:
- lab_setup/create_ad_domain.ps1  -> provisioning (Hyper-V / VirtualBox)
- attacks/kerberoast.py -> example exploitation & detection notes
- automation/bloodhound_collector.py -> gather data for graphing
- docs/detection_mapping.md -> map to detections & Sigma rules

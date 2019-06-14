#Для каждого пункта написать и выполнить соответсвующий скрипт автоматизации администрирования:
#Вывести все IP адреса вашего компьютера (всех сетевых интерфейсов)
Get-NetIPAddress | Format-Table

#Получить mac-адреса всех сетевых устройств вашего компьютера.
Get-NetAdapter | Format-Table

#На всех виртуальных компьютерах настроить (удалённо) получение адресов с DHСP.
#Сперва устанавливаем роль DHCP-сервера на VM1
[scriptblock]$Scriptblock = {
    Write-Host "Install DHCP feature & management tools"
    Install-WindowsFeature dhcp -IncludeManagementTools
    Write-Host "Import DhcpServer module"
    Import-Module DhcpServer # Error happens here 
}

$Session = New-PSSession -ComputerName VM1 -Credential (Get-Credential)
Invoke-Command -Session $Session -ScriptBlock $Scriptblock

Install DHCP feature & management tools

PSComputerName : VM1
RunspaceId     : 7c1ac078-87c5-4084-88af-e937b4fbcfd5
Success        : True
RestartNeeded  : No
FeatureResult  : {DHCP Server, Remote Server Administration Tools, DHCP Server Tools, Role Administration Tools}
ExitCode       : Success

WARNING: Windows automatic updating is not enabled. To ensure that your newly-installed role or feature is automatically updated, turn on Windows Update.
Import DhcpServer module

#Создаём сессию и Scope на VM1 
Enter-PSSession -ComputerName VM1 -Credential Administrator

Add-DHCPServerv4Scope -Name NemtsowScope -StartRange 192.168.10.20 -EndRange 192.168.10.28 -SubnetMask 255.255.255.0 -State Active

ScopeId         SubnetMask      Name           State    StartRange      EndRange        LeaseDuration
-------         ----------      ----           -----    ----------      --------        -------------
192.168.10.0    255.255.255.0   NemtsowScope   Active   192.168.10.20   192.168.10.28   8.00:00:00

Set-DHCPServerv4OptionValue -Router 192.168.10.1

#проверяем выдачу адресов через DHCP, развёрнутом на VM1
Get-DHCPServerv4Lease

cmdlet Get-DhcpServerv4Lease at command pipeline position 1
Supply values for the following parameters:
ScopeId: 192.168.10.0

IPAddress       ScopeId         ClientId             HostName             AddressState         LeaseExpiryTime
---------       -------         --------             --------             ------------         ---------------
192.168.10.20   192.168.10.0    00-15-5d-00-67-17    VM2                  Active               6/21/2019 12:56:29 PM
192.168.10.21   192.168.10.0    00-15-5d-00-67-18    VM3                  Active               6/21/2019 1:03:08 PM

#Расшарить папку на компьютере
New-SmbShare –Name NetworkFolder –Path 'D:\KMPlayer\'

#Удалить шару из п.1.4
Remove-SmbShare –Name NetworkFolder

#Скрипт входными параметрами которого являются Маска подсети и два ip-адреса. Результат  – сообщение (ответ) в одной ли подсети эти адреса.

[CmdletBinding()]
Param (
    [parameter(Mandatory=$true, HelpMessage="Enter Mask")]
    [ipaddress]$Mask,
    [parameter(Mandatory=$true, HelpMessage="Enter first ip-address")]
    [ipaddress]$Ipaddress1,
    [parameter(Mandatory=$true, HelpMessage="Enter second ip-address")]
    [ipaddress]$Ipaddress2
)
($ipaddress1.address -band$mask.address) -eq ($ipaddress2.address -band$mask.address)

#Работа с Hyper-V
#Получить список коммандлетов работы с Hyper-V (Module Hyper-V)
Get-Command -Module Hyper-V

#Получить список виртуальных машин
Get-VM

Name       State   CPUUsage(%) MemoryAssigned(M) Uptime           Status             Version
----       -----   ----------- ----------------- ------           ------             -------
NemtsovVM1 Off     0           0                 00:00:00         Operating normally 8.0
NemtsovVM2 Off     0           0                 00:00:00         Operating normally 8.0
NemtsovVM3 Off     0           0                 00:00:00         Operating normally 8.0
NemtsowVM1 Running 0           840               00:46:30.5590000 Operating normally 8.0
NemtsowVM2 Running 0           1216              00:46:29.6300000 Operating normally 8.0
NemtsowVM3 Running 0           636               00:24:46.8020000 Operating normally 8.0

#Получить состояние имеющихся виртуальных машин
Get-VM | Format-Table Name, State

Name         State
----         -----
NemtsovVM1     Off
NemtsovVM2     Off
NemtsovVM3     Off
NemtsowVM1 Running
NemtsowVM2 Running
NemtsowVM3 Running

#Выключить виртуальную машину
Get-VM -Name NemtsowVM2 | Stop-VM

#Создать новую виртуальную машину
$VMName = 'NewVMNemtsow'
$Switch = 'Internal VM Switch'
$InstallMedia = 'F:\9600.17050.WINBLUE_REFRESH.140317-1640_X64FRE_SERVER_EVAL_EN-US-IR3_SSS_X64FREE_EN-US_DV9.ISO'
Get-VMSwitch

Name              SwitchType NetAdapterInterfaceDescription
----              ---------- ------------------------------
Nemtsov_Private   Private
Nemtsow Internal2 Internal
Nemtsow_Internal  Internal

$Switch = 'Nemtsov_Private'

New-VM -Name $VMName -MemoryStartupBytes 1GB -Generation 1 -NewVHDPath "E:\NewVM4\$VMName\$VMName.vhdx" -NewVHDSizeBytes 20GB -Path "E:
\NewVM4\$VMName" -SwitchName $Switch

Name         State CPUUsage(%) MemoryAssigned(M) Uptime   Status             Version
----         ----- ----------- ----------------- ------   ------             -------
NewVMNemtsow Off   0           0                 00:00:00 Operating normally 8.0

Set-VM -Name 'NewVMNemtsow'  -ProcessorCount 2
Set-VMDvdDrive -VMName 'NewVMNemtsow' -Path $InstallMedia
Start-VM -Name NewVMNemtsow

PS C:\> Get-VM | Format-Table Name, State

Name           State
----           -----
NemtsovVM1       Off
NemtsovVM2       Off
NemtsovVM3       Off
NemtsowVM1       Off
NemtsowVM2       Off
NemtsowVM3       Off
NewVMNemtsow Running

#Создать динамический жесткий диск
New-VHD -Path 'E:\NewVM4\$VMName\$VMName.vhdx' -SizeBytes 20GB -Dynamic

#Удалить созданную виртуальную машину
Remove-VM -Name NewVMNemtsow

Name       State
----       -----
NemtsovVM1   Off
NemtsovVM2   Off
NemtsovVM3   Off
NemtsowVM1   Off
NemtsowVM2   Off
NemtsowVM3   Off

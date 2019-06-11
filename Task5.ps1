#При помощи WMI перезагрузить все виртуальные машины.
##С теми именами VM, что указаны в Hyper-V не работает, поэтому указал имена VM полученные через config (hostname),
$vmachines = @("VM1","VM2","VM3")
Get-WmiObject Win32_OperatingSystem -ComputerName $vmachines -Credential (Get-Credential) | Invoke-WmiMethod –Name Reboot
##или
(Get-WmiObject Win32_OperatingSystem -ComputerName $vmachines -Credential (Get-Credential)).Win32Shutdown(2)


#При помощи WMI просмотреть список запущенных служб на удаленном компьютере. 
Get-WmiObject -Class Win32_Service -filter "state='running'" -ComputerName VM1 -Credential Administrator | Format-Table

#Настроить PowerShell Remoting, для управления всеми виртуальными машинами с хостовой.
Enable-PSRemoting -SkipNetworkProfileCheck
get-item wsman:\localhost\Client\TrustedHosts
set-item wsman:localhost\client\trustedhosts -value *
##Для удалённого управления VM открываем сессию для неё
Enter-PSSession -ComputerName VM1 -Credential (Get-Credential)

#Для одной из виртуальных машин установить для прослушивания порт 42658. Проверить работоспособность PS Remoting.
#Создать конфигурацию сессии с целью ограничения использования всех команд, кроме просмотра содержимого дисков.




#Необходимо разрешить удаленное управление. Для этого переходим в раздел Computer Policies\Administrative Templates\Windows Components\Windows Remote Management (Win RM)\WinRM Service и находим там параметр с названием «Allow remote server management through WinRM».
#Затем идем в раздел Computer Configuration\Policies\Windows Components\Windows Remote Shell, находим пункт с именем «Allow Remote Shell Access»


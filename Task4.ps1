# Вывести список всех классов WMI на локальном компьютере. 
Get-WmiObject -List

# Получить список всех пространств имён классов WMI. 

# Получить список классов работы с принтером.
Get-WmiObject *printer* -List

# Вывести информацию об операционной системе, не менее 10 полей.
$systeminfo = Get-CimInstance -ClassName Win32_OperatingSystem
$systeminfo | Format-List Caption, Version, BuildType, BuildNumber, InstallDate, FreePhysicalMemory, Name,`
 LocalDateTime, SystemDirectory, WindowsDirectory

# Получить информацию о BIOS.
Get-WmiObject -Class Win32_BIOS

# Вывести свободное место на локальных дисках. На каждом и сумму.
# Сначала узнаем количество локальных дисков в системе
(Get-WmiObject Win32_LogicalDisk | Measure-Object).count-1
# Рассчитаем свободное место на локальных дисках
Get-WmiObject Win32_LogicalDisk -Filter "DriveType=3"| Select-Object SystemName,DeviceID,@{Name="size(GB)";Expression={"{0:N1}"`
 -f($_.size/1gb)}},@{Name="freespace(GB)";Expression={"{0:N1}" -f($_.freespace/1gb)}} | Format-Table -AutoSize
# Рассчитаем общую сумму свободного места на дисках
Get-WmiObject Win32_LogicalDisk -Filter "DriveType=3"| Select-Object SystemName,DeviceID,@{Name="size(GB)";Expression={"{0:N1}"`
 -f($_.size/1gb)}},@{Name="freespace";Expression={"{0:N1}" -f($_.freespace/1gb)}} | Measure-Object Freespace -sum | Format-List Sum

# Написать сценарий, выводящий суммарное время пингования компьютера (например 10.0.0.1) в сети.

[CmdletBinding()]
Param (
    [parameter(Mandatory=$true, HelpMessage="Enter Ip-Adress")]
    [string]$IpAdress
)

[int]$time = $null
(Test-Connection $IpAdress).ResponseTime | ForEach-Object {
    $time += $_
}
Write-Host "Ping time: $time ms"

# Создать файл-сценарий вывода списка установленных программных продуктов в виде таблицы с полями Имя и Версия.
Get-WmiObject -Class Win32_Product | Select-Object -Property Name, Version | Format-Table

# Выводить сообщение при каждом запуске приложения MS Word.


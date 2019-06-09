#Создайте сценарии *.ps1 для задач из labwork 2, проверьте их работоспостобность. Каждый сценарий должен иметь параметры.
#Сохранить в текстовый файл на диске список запущенных(!) служб. Просмотреть содержимое диска. Вывести содержимое файла в консоль PS.

[CmdletBinding()]
Param (
    [parameter(Mandatory=$true, HelpMessage="Enter FileName")]
      [string]$FileName
)
Get-Service | Where Status -eq "Running" > c:\$FileName.txt
Get-ChildItem -Path c:\
Get-Content c:\$FileName.txt

#Просуммировать все числовые значения переменных среды Windows. (Параметры не нужны)
[CmdletBinding()]
Param (
    [parameter(Mandatory=$false, HelpMessage="What files to exclude?")]
      [string]$ExcludeFiles
)
Get-Variable | where {$_.Value -is [int]} | measure Value -sum

#Вывести список из 10 процессов занимающих дольше всего процессор. Результат записывать в файл.
#Организовать запуск скрипта каждые 10 минут (сделал через планировщик)
[CmdletBinding()]
Param (
    [parameter(Mandatory=$true, HelpMessage="Enter number of processes")]
      [int]$NumberProc
)
Get-Process | Sort-Object CPU -desc | Select-Object -first $NumberProc | Format-Table  CPU,ProcessName > c:/TopCPU.txt

#Подсчитать размер занимаемый файлами в папке (например C:\windows) за исключением файлов с заданным расширением(например .tmp)
[CmdletBinding()]
Param (
    [parameter(Mandatory=$true, HelpMessage="What files to exclude?")]
      [string]$ExcludeFiles
)
$FolderSizeWin = Get-ChildItem -Force  C:\windows\ -Recurse -ErrorAction SilentlyContinue | Measure-Object Length -sum
$ExcludeSizeFiles = Get-ChildItem -Force  C:\windows\*.$ExcludeFiles -Recurse -ErrorAction SilentlyContinue | Measure-Object Length -sum
$FolderSizeWin.sum - $ExcludeSizeFiles.sum

#Создать один скрипт, объединив 3 задачи:
#Сохранить в CSV-файле информацию обо всех обновлениях безопасности ОС.
#Сохранить в XML-файле информацию о записях одной ветви реестра HKLM:\SOFTWARE\Microsoft.
#Загрузить данные из полученного в п.1.5.1 или п.1.5.2 файла и вывести в виде списка  разным разными цветами.

[CmdletBinding()]
Param (
    [parameter(Mandatory=$true, HelpMessage="Enter path to directory")]
    [string]$PathToDirectory,
    [parameter(Mandatory=$false, HelpMessage="Enter path to directory")]
    [string]$Registry = "HKLM:\SOFTWARE\Microsoft\.NETFramework\",
    [parameter(Mandatory=$true, HelpMessage="Enter color 1")]
    [string]$Color1,
    [parameter(Mandatory=$true, HelpMessage="Enter color 2")]
    [string]$Color2
)
Get-HotFix | Export-Csv -Path $PathToDirectory/hotfix.csv
Get-ChildItem -Recurse $Registry | Export-Clixml $PathToDirectory/registry.xml
Get-Content C:\run2.txt | Write-Host -ForegroundColor $Color1
Get-Content c:\TopCPU.txt | Write-Host -ForegroundColor $Color2

#Работа с профилем
#Создать профиль
#В профиле изненить цвета в консоли PowerShell
#Создать несколько собственный алиасов
#Создать несколько констант
#Изменить текущую папку
#Вывести приветствие
#Проверить применение профиля
New-Item -ItemType file -Path $profile -force
notepad $profile

(Get-Host).UI.RawUI.ForegroundColor = "red"
Set-Alias HelpMe Get-Help
Set-Variable test -option Constant -value 100 
Set-Location C:\
Write-Host "Hello, Nemtsow"

#Получить список всех доступных модулей
Get-Module

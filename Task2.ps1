# Просмотреть содержимое ветви реeстра HKCU
Set-Location -Path HKCU:\ | Get-ChildItem
Get-ChildItem

# Создать, переименовать, удалить каталог на локальном диске
New-Item -Path 'C:\catalog1' -ItemType Directory
Rename-Item -path 'C:\catalog1' -NewName 'C:\catalog2'
Remove-Item -path 'C:\catalog2'

#	Создать папку C:\M2T2_ФАМИЛИЯ. Создать диск ассоциированный с папкой C:\M2T2_ФАМИЛИЯ.
New-Item -Path 'C:\M2T2_Nemtsov' -ItemType Directory
New-PSDrive -Name X -PSProvider FileSystem -Root "C:\M2T2_Nemtsov"

# Сохранить в текстовый файл на созданном диске список запущенных(!) служб. 
Get-Service | Where Status -eq "Running" > x:\runservices.txt
#Просмотреть содержимое диска.
Get-ChildItem -Path x:\ 
#Вывести содержимое файла в консоль PS.
Get-Content x:\runservices.txt

#Просуммировать все числовые значения переменных текущего сеанса.
Get-Variable | where {$_.Value -is [int]} | measure Value -sum

#Вывести список из 6 процессов занимающих дольше всего процессор.
Get-Process | Sort-Object CPU -desc | Select-Object -first 6 | Format-Table  CPU,ProcessName

#Вывести список названий и занятую виртуальную память (в Mb) каждого процесса, разделённые знаком тире, при этом если процесс занимает более 100Mb – выводить информацию красным цветом, иначе зелёным.
#частично сделал
Get-Process | Sort-Object -Descending ws | Select-Object Name,@{Name='WorkingSet(MB)';Expression={($_.ws / 1024kb)}} |  Format-List

Get-Process | foreach-object{
f ($_.WS -gt 100) {
Write-host -f red $_.ProcessName $_.WS}`
else{ write-host -f green $_.ProcessName $_.WS}}

#Подсчитать размер занимаемый файлами в папке C:\windows (и во всех подпапках) за исключением файлов *.tmp
$FolderSizeWin = Get-ChildItem -Force  c:\Windows\ -Recurse -ErrorAction SilentlyContinue | Measure-Object Length -sum
$FileSizeTemp = Get-ChildItem -Force  c:\Windows\*.tmp -Recurse -ErrorAction SilentlyContinue | Measure-Object Length -sum
$FolderSizeWin.sum - $FileSizeTemp.sum

#Сохранить в CSV-файле информацию о записях одной ветви реестра HKLM:\SOFTWARE\Microsoft.
Get-ChildItem -Recurse HKLM:\SOFTWARE\Microsoft\.NETFramework\ | Export-CSV C:\reestr.csv

#Сохранить в XML -файле историческую информацию о командах выполнявшихся в текущем сеансе работы PS.
Get-History | Export-Clixml -Path c:\pshistory.xml

#Загрузить данные из полученного в п.10 xml-файла и вывести в виде списка информацию о каждой записи, в виде 5 любых (выбранных Вами) свойств.
#Ещё не сделал
Get-Content c:\pshistory.xml
Import-Clixml -Path C:\pshistory.xml

#Удалить созданный диск и папку С:\M2T2_ФАМИЛИЯ
Remove-PSDrive x
Remove-Item C:\M2T2_Nemtsov\

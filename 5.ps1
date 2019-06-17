# 5.Все файлы из прилагаемого архива перенести в одну папку, не содержащую подпапок.
# Имя каждого файла изменить, добавив в его начало имя родительской папки и время переноса файла.
# В конце выдать отчёт о количестве файлов и общем размере перенесённых файлов. 

#создаём переменные путей
$archivePath = 'C:\Users\Admin\Desktop\Archive.zip'
$folderPath = 'c:\Users\Admin\Desktop\Archive'
#разархивируем
Expand-Archive -Path $archivePath -DestinationPath $folderPath -Force
#изменяем имена файлов
Get-ChildItem -Path $folderPath -Filter "*.txt" -Recurse | Rename-Item -NewName {$_.Directory.Name + " - " + $(Get-Date -f hh-mm-ss)}
#создаём переменную списка содержимого разархивированной папки с файлами
$AllFiles = Get-ChildItem $folderPath -recurse
#Обращаемся к созданной ранее переменной, как к объекту и выдаём отчёт о количестве и общем размере перенесённых файлов
$Size = $AllFiles | Measure-Object -property length -sum
"{0:N2}" -f ($Size.sum / 1KB) + "KB;" + $Size.count + " files"



#Получите справку о командлете справки
Get-Help Get-Help
#Пункт 1, но детальную справку, затем только примеры
Get-Help Get-Help –Detailed
Get-Help Get-Help –Examples
#Получите справку о новых возможностях в PowerShell 4.0 (или выше)
Get-Help about_Windows_PowerShell_5.0
#Получите все командлеты установки значений
Get-Command -Type Cmdlet *set*
#Получить список команд работы с файлами
Get-Command *Item*
#Получить список команд работы с объектами
Get-Command *Object*
#Получите список всех псевдонимов
Get-Alias
#Создайте свой псевдоним для любого командлета
New-Alias -Name "List" Get-ChildItem
#Просмотреть список методов и свойств объекта типа процесс
Get-Process -id 512 | Get-Member
#Просмотреть список методов и свойств объекта типа строка
$string = "My name is Sasha"
$string | Get-Member
#Получить список запущенных процессов, данные об определённом процессе
Get-Process
Get-Process -id 512 
#Получить список всех сервисов, данные об определённом сервисе
Get-Service
Get-Service WSearch
#Получить список обновлений системы
Get-Hotfix
#Узнайте, какой язык установлен для UI Windows
[CultureInfo]::InstalleduICulture
#Получите текущее время и дату
Get-Date
#Сгенерируйте случайное число (любым способом)
Get-Random
#Выведите дату и время, когда был запущен процесс «explorer». Получите какой это день недели. 
(Get-Process -Name explorer).StartTime.DayOfWeek
#Откройте любой документ в MS Word (не важно как) и закройте его с помощью PowerShell
./doc1.docx
Get-Process
Stop-Process 5576
#Подсчитать значение выражения. Каждый шаг выводить в виде строки. (Пример: На шаге 2 сумма S равна 9).
#Правда пока не разобрался как запрашивать $n на ввод. 
$n=5
For ($a=1; $a –le $n; $a++)
{$a*3}
#Напишите функцию для предыдущего задания.
function firstprog
{$n=5
For ($a=1; $a –le $n; $a++)
{$a*3} }
#Запустите её на выполнение.
firstprog

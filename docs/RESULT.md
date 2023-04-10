## Целевая платформа

Платформа: Android/Ios. 99% Android, последний процент времени успел только глянуть на Ios, вроде ничего не сломалось))

## Результаты

Сразу скажу, что всё успеть сделать не вышло, потому что-то выдающееся тут вряд ли можно будет найти) (но чтобы выдавать 10 часов на такую таску надо было её выдавать 1 апреля))

Задание 1 - выполнено;

Задание 2:
 - база - выполнено ✅;
 - автоматическая вставка из буфера ✅;
 - сохранение списка в локальной бд - есть (hive) ✅;

Задание 3:
 - скрытие кнопки добавление ссылки в конце спика - выполнено ✅;
 - сортировка по дате добавления - есть ✅, по состоянию загрузки нет ❌;

Задание 4:
 - загрузка и сохранение файлов - выполнено ✅ (файл хранится в папке прилаги, не стал морочиться с пермишенами, в hive хранятся пути к файлам по ключам);
 - загрузка всех незагруженных по одной кнопке - выполнено (но с багом ❌, грузятся по очереди, а не разом, не успел продебажить);
Задание 5:
 - просмотр pdf - выполнено ✅;

Креатив: я не ChatGpt, чтобы ещё успеть покреативничать, хотя очень хотелось)

## Ссылки на демонстрацию работы/скриншоты

# Пустой экран
<p align="center">
<img src="results/empty_list.png" width="375" alt="Empty screen" />
</p>

# Модалка ввода Url(и Ui баги)
<div class="row" align="center">
  <img src="results/clipboard.png" width="375" alt="ModalBottomSheet clipboard " style="margin-right: 30px;" />
  <img src="results/bottom_sheet.png" width="375" alt="ModalBottomSheet empty " />
  <img src="results/invalid.png" width="375" alt="ModalBottomSheet error, crap, bugsss " />
</div>
Клавиатура не закрывает модалку, забагалась клава и перестала открываться, придётся это проверить при запуске ;)

# Удачное и неудачное добавление билета
<div class="row" align="center">
  <img src="results/successful_add.png" width="375" alt="Tickets success add " style="margin-right: 30px;" />
  <img src="results/check_contains.png" width="375" alt="Already added ticket " />
</div>

# Скачивание одиночное/массовое
<div class="row" align="center">
  <img src="results/downloading.png" width="375" alt="Ticket downloading " style="margin-right: 30px;" />
  <img src="results/mass_downloading.png" width="375" alt="Tickets mass downloading " />
</div>

# Просмотр документа
<p align="center">
<img src="results/doc_view.png" width="375" alt="Docs view" />
</p>

# Спрятанная строка плавающих кнопок в конце списка
<p align="center">
<img src="results/hidden_floating.png" width="375" alt="Hidden floating" />
</p>


Ну и всё, прошу расчехлять устройства для тестирования)

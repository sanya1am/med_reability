# MedRehab
Клиентская часть сервиса MedRehab для удаленной медицинской реабилитации, разрабатываемая в рамках ВКР. Клиентская часть реализована на Dart / Flutter и поддерживает работу в формате мобильного приложения и веб-приложения на единой кодовой базе.

### Описание проекта
MedRehab – это клиентское приложение для сервиса, который помогает организовать сопровождение пациента после первичного приема специалиста и назначения восстановительных мероприятий.

Сервис не предназначен для постановки диагноза или замены медицинской консультации. Его задача – предоставить удобный интерфейс для работы с планом реабилитации, упражнениями и обратной связью пациента после занятий.

В приложении предусмотрены три основные роли:
* Администратор клиники – управляет пользователями внутри клиники и назначает пациентов инструкторам;
* Инструктор ЛФК – создает упражнения, формирует планы реабилитации и просматривает обратную связь пациента;
* Пациент – просматривает назначенный план, выполняет упражнения и заполняет форму оценки самочувствия.

## Авторизация и ролевая навигация
- выбор клиники перед входом;
- авторизация по email и паролю;
- получение данных текущего пользователя;
- автоматический переход в раздел приложения в зависимости от роли;
- возврат на экран входа при выходе из аккаунта или истечении сессии.

<img width="680" height="400" alt="image" src="https://github.com/user-attachments/assets/a6257be4-8961-4c8e-8242-44543e27e3ab" /> <img width="190" height="400" alt="image" src="https://github.com/user-attachments/assets/013cf21f-8564-47cc-8ffd-cc1f3a886580" />

## Профиль для всех ролей (в светлой и темной теме)

- карточка профиля в светлой теме;

<img width="680" height="400" alt="image" src="https://github.com/user-attachments/assets/ff35a6f7-3b2c-4f85-b624-80fa83cf1376" /> <img width="190" height="400" alt="image" src="https://github.com/user-attachments/assets/4c56e7db-4d05-4ca4-a43c-4876c4a346a1" />

- карточка профиля в темной теме;

<img width="680" height="400" alt="image" src="https://github.com/user-attachments/assets/7f7ebd1e-a5a0-42d9-8f88-221430659ddf" /> <img width="190" height="400" alt="image" src="https://github.com/user-attachments/assets/de2c5f5e-797a-4e40-b500-dc1b10b79c09" />

- редактирование данных пользователя;

<img width="680" height="400" alt="image" src="https://github.com/user-attachments/assets/d7d7c9d5-8cf5-4307-818a-e195eace06c6" /> <img width="190" height="400" alt="image" src="https://github.com/user-attachments/assets/b57ae3b3-294f-4a71-b46d-3facf4b084fe" />

- изменение пароля

<img width="680" height="400" alt="image" src="https://github.com/user-attachments/assets/20f3a5ef-1ca2-4ba4-abb2-1e66eb188c23" /> <img width="190" height="400" alt="image" src="https://github.com/user-attachments/assets/cad31232-48cf-47a9-9db5-f7c81f8fde74" />

## Административный функционал

- просмотр пользователей клиники по ролям;

<img width="680" height="400" alt="image" src="https://github.com/user-attachments/assets/5d0798af-dd52-4649-8fa5-1e0ce8ab5463" /> <img width="190" height="400" alt="image" src="https://github.com/user-attachments/assets/9b9a00e9-87f7-497d-9102-827bcc91b48b" />

- создание новых пользователей;

<img width="680" height="400" alt="image" src="https://github.com/user-attachments/assets/2704682a-7dad-4327-9513-82dd5351835d" /> <img width="190" height="400" alt="image" src="https://github.com/user-attachments/assets/5605cdde-9570-404b-92fc-66f4784a6b74" />

- активация и деактивация учетных записей;

<img width="680" height="400" alt="image" src="https://github.com/user-attachments/assets/b5c9d869-a368-4f5b-a09c-7d4a1d1413cf" /> <img width="190" height="400" alt="image" src="https://github.com/user-attachments/assets/a81f7cf7-6232-4ef2-ae4b-d010cdd94d99" />

- назначение пациента инструктору;

<img width="680" height="400" alt="image" src="https://github.com/user-attachments/assets/ef581f2d-fdfe-423b-88ba-ffe520c14d2f" /> <img width="190" height="400" alt="image" src="https://github.com/user-attachments/assets/a2925be6-3cfd-4246-b39f-7f7f455772b8" />

## Функционал инструктора 
### Каталог упражнений
- просмотр каталога упражнений внутри клиники;

<img width="680" height="400" alt="image" src="https://github.com/user-attachments/assets/fcaf066a-cb2e-4a92-96b5-10e9616b0ef4" /> <img width="190" height="400" alt="image" src="https://github.com/user-attachments/assets/6ca2e797-8ee5-46b9-946b-7091e6f15b1b" />

- просмотр деталей упражнения (описания, медиафайлов, шагов выполнения);

<img width="680" height="400" alt="image" src="https://github.com/user-attachments/assets/b71626ad-c006-4f73-98e5-0350990a823a" /> <img width="190" height="400" alt="image" src="https://github.com/user-attachments/assets/c4eacd18-7138-43e2-b086-856bb64f7c1c" />

- создание и редактирование упражнения (с указанием дополнительных атрибутов: часть тела, инвентарь, тип нагрузки);

<img width="680" height="400" alt="image" src="https://github.com/user-attachments/assets/6d5a30a8-8a4f-4b3e-95a5-a7b62fdb5c16" /> <img width="190" height="400" alt="image" src="https://github.com/user-attachments/assets/8d31e7d8-954a-45cf-b668-45da88ce4c44" />

- поиск упражнений по названию и атрибутам.

<img width="680" height="400" alt="image" src="https://github.com/user-attachments/assets/4c5d8462-5613-4d41-8f53-889d62f044a0" /> <img width="190" height="400" alt="image" src="https://github.com/user-attachments/assets/ed78ccbe-9e1d-4875-a2c2-88328ccf1ee6" />

### Закрепленные пациенты, план реабилитации
- просмотр списка закрепленных пациентов;

<img width="680" height="400" alt="image" src="https://github.com/user-attachments/assets/857b4c96-e6f0-49d6-8d53-22581e75088b" /> <img width="190" height="400" alt="image" src="https://github.com/user-attachments/assets/c8c65e02-cb9a-42d3-88a6-a71f715054ae" />

- просмотр плана реабилитации пациента;

<img width="680" height="400" alt="image" src="https://github.com/user-attachments/assets/05d4bfe3-cd32-4e63-89e2-2416e215a49b" /> <img width="190" height="400" alt="image" src="https://github.com/user-attachments/assets/06dcf3d7-e783-436d-af82-298ac528a2ff" />

<img width="680" height="400" alt="image" src="https://github.com/user-attachments/assets/f2d1b94c-f6aa-4b04-9e4a-2e4a77533003" /> <img width="190" height="400" alt="image" src="https://github.com/user-attachments/assets/37c1b675-3e7f-4e10-acf4-295121397374" />

- недели реабилитации (редактирование / создание плана);

<img width="680" height="400" alt="image" src="https://github.com/user-attachments/assets/84060587-5829-44ac-b88d-7c0781d853ca" /> <img width="190" height="400" alt="image" src="https://github.com/user-attachments/assets/4a2d9805-b52d-4a26-82b1-b05bf0917355" />

- дни недели (редактирование / создание плана);

<img width="680" height="400" alt="image" src="https://github.com/user-attachments/assets/3190bb5b-dbc0-4272-95f0-3b1093f6d3ac" /> <img width="190" height="400" alt="image" src="https://github.com/user-attachments/assets/91163327-6000-476d-a617-78b18a9f5129" />

- день плана реабилитации с упражнениями;

<img width="680" height="400" alt="image" src="https://github.com/user-attachments/assets/01b53628-7037-4663-8f5c-11d23277b63d" /> <img width="190" height="400" alt="image" src="https://github.com/user-attachments/assets/1636f28e-cdc8-40d0-b9de-c34f792d1b59" />

- настройки упражнения под пациента (указание повторений / времени выполнения, подходов, времени отдыха);

<img width="680" height="400" alt="image" src="https://github.com/user-attachments/assets/c0f2d9a4-6cb9-4e12-a0d8-bdcf1cf41078" /> <img width="190" height="400" alt="image" src="https://github.com/user-attachments/assets/cef43fb9-1569-4e0f-9f37-2c553e1bd4c0" />

- удаление назначенных упражнений из дня плана реабилитации;

<img width="680" height="400" alt="image" src="https://github.com/user-attachments/assets/44c78bdf-0190-47ad-99e0-922869e6e438" /> <img width="190" height="400" alt="image" src="https://github.com/user-attachments/assets/3ac6ae9d-40d2-44ba-9269-cfda12bcaa24" />

- шаблоны дней / недель для быстрого составления плана

<img width="680" height="400" alt="image" src="https://github.com/user-attachments/assets/41da2fb2-3c25-44f6-8059-13e3d8397fca" /> <img width="190" height="400" alt="image" src="https://github.com/user-attachments/assets/538f59f2-e3d7-48f0-8335-564f421cb69b" />

- просмотр формы оценки самочувствия пациента после занятия.

<img width="680" height="400" alt="image" src="https://github.com/user-attachments/assets/536872c7-1434-497c-bb20-8829c8ec4d54" /> <img width="190" height="400" alt="image" src="https://github.com/user-attachments/assets/38a413f5-4394-4b8b-ad88-cffbfe661374" />

## Функционал пациента
- просмотр назначенного плана реабилитации (тренировочный день / день отдыха) / отсутствие плана реабилитации;

<img width="245" height="520" alt="image" src="https://github.com/user-attachments/assets/f53840f8-ec47-42eb-a6c4-90c0af4d2f45" /> <img width="245" height="520" alt="image" src="https://github.com/user-attachments/assets/c9ccf8b2-980d-4a03-aa35-89598d85f968" /> <img width="245" height="520" alt="image" src="https://github.com/user-attachments/assets/fa802bfd-ca61-41f4-afc8-f8687c7d3dbb" />

- последовательное выполнение упражнений;

<img width="245" height="520" alt="image" src="https://github.com/user-attachments/assets/af03677d-323b-439c-9a88-be5fc4a22418" /> <img width="245" height="520" alt="image" src="https://github.com/user-attachments/assets/51e335d8-6e6c-4f22-a05e-75c48e5c8da0" /> <img width="245" height="520" alt="image" src="https://github.com/user-attachments/assets/6fc622af-e12c-4a75-914b-f03c8116ae38" />

- просмотр медиафайлов при выполнении упражнений (с возможностью просмотра в полноэкранном режиме);

<img width="245" height="520" alt="image" src="https://github.com/user-attachments/assets/b6fb82bf-df30-4491-a67f-e88b4a2c8bff" /> <img width="245" height="520" alt="image" src="https://github.com/user-attachments/assets/66dff72b-7043-4e61-8a05-6a1898ee725e" />

- завершение тренировки;

<img width="245" height="520" alt="image" src="https://github.com/user-attachments/assets/a3b45384-afc5-4ad6-ba94-90830d482e17" />

- заполнение формы оценки самочувствия после занятия (нет дискомфорта / есть дискомфорт).

<img width="245" height="520" alt="image" src="https://github.com/user-attachments/assets/49dcbfe8-1b59-4e18-bcbb-6cecaef2a2a5" /> <img width="245" height="520" alt="image" src="https://github.com/user-attachments/assets/b47ef620-3802-4bb5-a2a5-5339d8461cbb" />

# WorkersList
Демонстрация базовых навыков программирования и стиля кода (Swift 5, UIKit, iOS 13+).

Приложение - список контактов. 

![Снимок экрана 2022-06-02 в 10 47 59](https://user-images.githubusercontent.com/43521623/171580943-5300e09a-214e-4df4-99a6-8757ebdec3a5.png)

При запуске приложения загружается актуальный список работников.
Изначально экран в состоянии загрузки (скелетон).

![Screen Recording 2021-11-11 at 00 02 21](https://user-images.githubusercontent.com/43521623/171573325-359595d1-d75f-408f-a36d-45c30f5b5c16.gif)

Компонент навигации находится в верхней части экрана и содержит поле поиска, кнопку сортировки и панель вкладок. 

![2022-06-02 08 47 44](https://user-images.githubusercontent.com/43521623/171569582-5d75c591-a66e-4eba-a0b8-65ec79d94d4d.jpg)

![Screen Recording 2021-11-09 at 22 10 22 2](https://user-images.githubusercontent.com/43521623/171582700-8822dc01-6aa3-47b2-993c-965f271e0789.gif)

Если при загрузке произошла ошибка, отсутствует интернет-соединение или API вернул ошибку отображается модальный экран ошибки. В случае успеха - список людей.

При нажатии на фильтр открывается модальный экран с вариантами сортировки - "По алфавиту" и "По дню рождения".
При вводе текста в поиск отображаются работники соответствующие параметрам - по имени, фамилии или никнейму. Можно перезагрузить список жестом pull-to-refresh. 

!![Запись экрана 2021-11-14 в 20 53 11](https://user-images.githubusercontent.com/43521623/171576740-629d58f9-ce58-4bbd-9437-4b1ad12f3f0b.gif)

Экран "детали" - аватарка, имя, никнейм и департамент. Ниже дата рождения и номер телефона. При нажатии на номер телефона открывается action sheet с подтверждением звонка. При нажатии на кнопку с номером телефона в action sheet начинается звонок, а сам action sheet закрывается.

![Снимок экрана 2022-06-02 в 10 35 15](https://user-images.githubusercontent.com/43521623/171578386-9ce3b270-b4c7-464d-9abc-0d4238c75e99.png)

# Примерный план работ

1.Верстка главного экрана - таблица, ячейка работника, разделы - 2 часа

2.Верстка главного экрана - строка поиска - 2 часа

3.Библиотека цветов, дефолтные картинки и иконки - 2 часа

4.Network manager, загрузки и отображение данных, обработка ошибок - 2 часа

5.Логика поиска - 2 часа

6.Верстка экрана сортировки - 2 часа

7.Логика сортировки - 2 часа

8.Верстка экрана Детали 2.0.3 - 2 часа

9.Логика экрана Детали 2.0.3 - 2 часа

Итого: 18 часов

# Дополнительные задания 

Обработка ошибок - 2 часа

pull-to-refresh - 1 час

Итого: 3 часа


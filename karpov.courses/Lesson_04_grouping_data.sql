-- Задание 1:
-- С помощью оператора GROUP BY посчитайте количество курьеров мужского и женского пола
-- в таблице couriers.Новую колонку с числом курьеров назовите couriers_count.
-- Результат отсортируйте по этой колонке по возрастанию.
-- Поля в результирующей таблице: sex, couriers_count
SELECT sex, COUNT(DISTINCT courier_id) couriers_count
FROM couriers
GROUP BY sex
ORDER BY couriers_count
-- Задание 2:
-- Посчитайте количество созданных и отменённых заказов в таблице user_actions.
-- Новую колонку с числом заказов назовите orders_count.
-- Результат отсортируйте по числу заказов по возрастанию.
-- Поля в результирующей таблице: action, orders_count
SELECT action, COUNT(order_id) orders_count
FROM user_actions
GROUP BY action
ORDER BY orders_count
-- Задание 3:
-- Используя группировку и функцию DATE_TRUNC, приведите все даты к началу месяца и
-- посчитайте, сколько заказов было сделано в каждом из них.
-- Расчёты проведите по таблице orders. Колонку с усечённой датой назовите month,
-- колонку с количеством заказов — orders_count.Результат отсортируйте по месяцам — по возрастанию.
-- Поля в результирующей таблице: month, orders_count
SELECT DATE_TRUNC('month', creation_time) as month, COUNT(order_id) as orders_count
FROM orders
GROUP BY month
ORDER BY month
-- Задание 4:
-- Используя группировку и функцию DATE_TRUNC, приведите все даты к началу месяца
-- и посчитайте, сколько заказов было сделано и сколько было отменено в каждом из них.
-- В этот раз расчёты проведите по таблице user_actions. Колонку с усечённой датой
-- назовите month, колонку с количеством заказов — orders_count.
-- Результат отсортируйте сначала по месяцам — по возрастанию, затем по типу действия
-- — тоже по возрастанию.Поля в результирующей таблице: month, action, orders_count
SELECT DATE_TRUNC('month', time) AS month, action, COUNT(order_id) orders_count
FROM user_actions
GROUP BY month, action
ORDER BY month, action
-- Задание 5:
-- По данным в таблице users посчитайте максимальный порядковый номер месяца
-- среди всех порядковых номеров месяцев рождения пользователей сервиса. 
-- С помощью группировки проведите расчёты отдельно в двух группах — для 
-- пользователей мужского и женского пола.Новую колонку с максимальным порядковым номером
-- месяца рождения в группах назовите max_month. Преобразуйте значения в новой 
-- колонке в формат INTEGER, чтобы порядковый номер был выражен целым числом.
-- Результат отсортируйте по колонке с полом пользователей.
-- Поля в результирующей таблице: sex, max_month
SELECT sex, MAX(DATE_PART('month', birth_date))::INTEGER as max_month
FROM users
GROUP BY sex
ORDER BY sex
-- Задание 6:
-- По данным в таблице users посчитайте порядковый номер месяца рождения 
-- самого молодого пользователя сервиса. С помощью группировки проведите расчёты 
-- отдельно в двух группах — для пользователей мужского и женского пола.
-- Новую колонку c порядковым номером месяца рождения самого молодого 
-- пользователя в группах назовите max_month. Преобразуйте значения в новой 
-- колонке в формат INTEGER, чтобы порядковый номер был выражен целым числом.
-- Результат отсортируйте по колонке с полом пользователей.
-- Поля в результирующей таблице: sex, max_month
SELECT sex, DATE_PART('month', MAX(birth_date))::INTEGER max_month
FROM users
GROUP BY sex
ORDER BY sex
-- Задание 7:
-- Посчитайте максимальный возраст пользователей мужского и женского пола 
-- в таблице users. Возраст измерьте числом полных лет.
-- Новую колонку с возрастом назовите max_age. Преобразуйте значения в 
-- новой колонке в формат INTEGER, чтобы возраст был выражен целым числом.
-- Результат отсортируйте по новой колонке по возрастанию возраста.
-- Поля в результирующей таблице: sex, max_age
SELECT sex, DATE_PART('year', MAX(AGE(birth_date)))::INTEGER as max_age
FROM users
GROUP BY sex
ORDER BY max_age
-- Задание 8:
-- Разбейте пользователей из таблицы users на группы по возрасту 
-- (возраст по-прежнему измеряем числом полных лет) и посчитайте количество 
-- пользователей каждого возраста.Колонку с возрастом назовите age, а колонку с числом
-- пользователей — users_count. Преобразуйте значения в колонке с возрастом 
-- в формат INTEGER, чтобы возраст был выражен целым числом.
-- Результат отсортируйте по колонке с возрастом по возрастанию.
-- Поля в результирующей таблице: age, users_count
SELECT DATE_PART('year', AGE(birth_date))::INTEGER as age,
COUNT(user_id) as users_count
FROM users
GROUP BY age
ORDER BY age
-- Задание 9:
-- Вновь разбейте пользователей из таблицы users на группы по возрасту 
-- (возраст по-прежнему измеряем количеством полных лет), только теперь 
-- добавьте в группировку ещё и пол пользователя. Затем посчитайте количество 
-- пользователей в каждой половозрастной группе.
-- Все NULL значения в колонке birth_date заранее отфильтруйте с помощью WHERE.
-- Колонку с возрастом назовите age, а колонку с числом пользователей — users_count, 
-- имя колонки с полом оставьте без изменений. Преобразуйте значения в колонке с возрастом 
-- в формат INTEGER, чтобы возраст был выражен целым числом.
-- Отсортируйте полученную таблицу сначала по колонке с возрастом по возрастанию,
-- затем по колонке с полом — тоже по возрастанию.
-- Поля в результирующей таблице: age, sex, users_count
SELECT DATE_PART('year', AGE(birth_date))::INTEGER as age, 
sex,
COUNT(user_id) as users_count
FROM users
WHERE birth_date IS NOT NULL
GROUP BY age, sex
ORDER BY age, sex
-- Задание 10:
-- Посчитайте количество товаров в каждом заказе, примените к этим значениям группировку
-- и рассчитайте количество заказов в каждой группе за неделю с 29 августа 
-- по 4 сентября 2022 года включительно. Для расчётов используйте данные из таблицы orders.
-- Выведите две колонки: размер заказа и число заказов такого размера за указанный период.
-- Колонки назовите соответственно order_size и orders_count.
-- Результат отсортируйте по возрастанию размера заказа.
-- Поля в результирующей таблице: order_size, orders_count
SELECT ARRAY_LENGTH(product_ids, 1) as order_size,
COUNT(order_id) orders_count
FROM orders
WHERE creation_time BETWEEN '2022-08-29' AND '2022-09-05'
GROUP BY order_size
ORDER BY order_size
-- Задание 11:
-- Посчитайте количество товаров в каждом заказе, примените к этим значениям 
-- группировку и рассчитайте количество заказов в каждой группе. 
-- Учитывайте только заказы, оформленные по будням. 
-- В результат включите только те размеры заказов, общее число которых превышает 2000.
-- Для расчётов используйте данные из таблицы orders.
-- Выведите две колонки: размер заказа и число заказов такого размера. 
-- Колонки назовите соответственно order_size и orders_count.
-- Результат отсортируйте по возрастанию размера заказа.
-- Поля в результирующей таблице: order_size, orders_count
SELECT ARRAY_LENGTH(product_ids, 1) order_size,
COUNT(order_id) orders_count
FROM orders
WHERE TO_CHAR(creation_time, 'Dy') != 'Sun' AND TO_CHAR(creation_time, 'Dy') != 'Sat'
GROUP BY order_size
HAVING COUNT(order_id) > 2000
ORDER BY order_size
-- Задание 12:
-- По данным из таблицы user_actions определите пять пользователей, 
-- сделавших в августе 2022 года наибольшее количество заказов.
-- Выведите две колонки — id пользователей и число оформленных ими заказов. 
-- Колонку с числом оформленных заказов назовите created_orders.
-- Результат отсортируйте сначала по убыванию числа заказов, сделанных пятью пользователями,
-- затем по возрастанию id этих пользователей.
-- Поля в результирующей таблице: user_id, created_orders
SELECT user_id,
COUNT(order_id) created_orders
FROM user_actions
WHERE action = 'create_order' AND time BETWEEN '2022-08-01' AND '2022-09-01'
GROUP BY user_id
ORDER BY 2 DESC, 1
LIMIT 5
-- Задание 13:
-- А теперь по данным таблицы courier_actions определите курьеров, которые в сентябре 2022
-- года доставили только по одному заказу.В этот раз выведите всего одну колонку с id курьеров. 
-- Колонку с числом заказов в результат включать не нужно.Результат отсортируйте по
-- возрастанию id курьера. Поле в результирующей таблице: courier_id
SELECT courier_id
FROM courier_actions
WHERE action = 'deliver_order' AND time BETWEEN '2022-09-01' AND '2022-10-01'
GROUP BY courier_id
HAVING COUNT(order_id) = 1
ORDER BY 1
-- Задание 14:
-- Из таблицы user_actions отберите пользователей, у которых последний заказ был создан
-- до 8 сентября 2022 года. Выведите только их id, дату создания заказа выводить не нужно.
-- Результат отсортируйте по возрастанию id пользователя.
-- Поле в результирующей таблице: user_id
SELECT user_id
FROM user_actions
WHERE action = 'create_order'
GROUP BY user_id
HAVING MAX(time) < '2022-09-08'
ORDER BY 1
-- Задание 15:
-- Разбейте заказы из таблицы orders на 3 группы в зависимости от количества товаров,
-- попавших в заказ:Малый (от 1 до 3 товаров); Средний (от 4 до 6 товаров);
-- Большой (7 и более товаров). Посчитайте число заказов, попавших в каждую группу.
-- Группы назовите соответственно «Малый», «Средний», «Большой» (без кавычек).
-- Выведите наименования групп и число товаров в них. Колонку с наименованием групп
-- назовите order_size, а колонку с числом заказов — orders_count.
-- Отсортируйте полученную таблицу по колонке с числом заказов по возрастанию.
-- Поля в результирующей таблице: order_size, orders_count
SELECT
CASE
WHEN ARRAY_LENGTH(product_ids, 1) <=3 THEN 'Малый'
WHEN ARRAY_LENGTH(product_ids, 1) >=7 THEN 'Большой'
ELSE 'Средний' END AS order_size,
COUNT(order_id) orders_count
FROM orders
GROUP BY order_size
ORDER BY 2
-- Задание 16:
-- Разбейте пользователей из таблицы users на 4 возрастные группы: от 18 до 24 лет; от 25 до 29 лет;
-- от 30 до 35 лет; не младше 36.
-- Посчитайте число пользователей, попавших в каждую возрастную группу. 
-- Группы назовите соответственно «18-24», «25-29», «30-35», «36+» (без кавычек).
-- В расчётах не учитывайте пользователей, у которых не указана дата рождения. 
-- Как и в прошлых задачах, в качестве возраста учитывайте число полных лет.
-- Выведите наименования групп и число пользователей в них. Колонку с наименованием групп
-- назовите group_age, а колонку с числом пользователей — users_count.
-- Отсортируйте полученную таблицу по колонке с наименованием групп по возрастанию.
-- Поля в результирующей таблице: group_age, users_count
SELECT
CASE
WHEN DATE_PART('year', AGE(birth_date))::INTEGER BETWEEN 18 AND 24 THEN '18-24'
WHEN DATE_PART('year', AGE(birth_date))::INTEGER BETWEEN 25 AND 29 THEN '25-29'
WHEN DATE_PART('year', AGE(birth_date))::INTEGER BETWEEN 30 AND 35 THEN '30-35'
ELSE '36+' END AS group_age,
COUNT(DISTINCT user_id) users_count
FROM users
WHERE birth_date IS NOT NULL
GROUP BY group_age
ORDER BY 1
-- Задание 17:
-- По данным из таблицы orders рассчитайте средний размер заказа по выходным и будням.
-- Группу с выходными днями (суббота и воскресенье) назовите «weekend», 
-- а группу с будними днями (с понедельника по пятницу) — «weekdays» (без кавычек).
-- В результат включите две колонки: колонку с группами назовите week_part, 
-- а колонку со средним размером заказа — avg_order_size. 
-- Средний размер заказа округлите до двух знаков после запятой.
-- Результат отсортируйте по колонке со средним размером заказа — по возрастанию.
-- Поля в результирующей таблице: week_part, avg_order_size
SELECT
CASE
WHEN DATE_PART('dow', creation_time) IN (6, 0) THEN 'weekend'
ELSE 'weekdays' END AS week_part,
ROUND(AVG(ARRAY_LENGTH(product_ids, 1)), 2) avg_order_size
FROM orders
GROUP BY week_part
ORDER BY 2
-- Задание 18:
-- Для каждого пользователя в таблице user_actions посчитайте общее количество оформленных
-- заказов и долю отменённых заказов. Новые колонки назовите соответственно orders_count и
-- cancel_rate. Колонку с долей отменённых заказов округлите до двух знаков после запятой.
-- В результат включите только тех пользователей, которые оформили больше трёх заказов 
-- и у которых показатель cancel_rate составляет не менее 0.5.
-- Результат отсортируйте по возрастанию id пользователя.
-- Поля в результирующей таблице: user_id, orders_count, cancel_rate
SELECT user_id,
COUNT(DISTINCT order_id) FILTER (
WHERE action = 'create_order') AS orders_count,
ROUND(COUNT(order_id) FILTER (
WHERE action = 'cancel_order')::DECIMAL/COUNT(DISTINCT order_id) FILTER (
WHERE action = 'create_order'), 2) AS cancel_rate
FROM user_actions
GROUP BY user_id
HAVING COUNT(order_id) FILTER (
WHERE action = 'cancel_order')::DECIMAL/COUNT(DISTINCT order_id) FILTER (
WHERE action = 'create_order') >= 0.5 AND
COUNT(DISTINCT order_id) FILTER (
WHERE action = 'create_order') > 3
ORDER BY 1
-- Задание 19:
-- Для каждого дня недели в таблице user_actions посчитайте:
-- Общее количество оформленных заказов.
-- Общее количество отменённых заказов.
-- Общее количество неотменённых заказов (т.е. доставленных).
-- Долю неотменённых заказов в общем числе заказов (success rate).
-- Новые колонки назовите соответственно created_orders, canceled_orders, 
-- actual_orders и success_rate. Колонку с долей неотменённых заказов округлите до трёх знаков
-- после запятой.Все расчёты проводите за период с 24 августа по 6 сентября 2022 года включительно,
-- чтобы во временной интервал попало равное количество разных дней недели.
-- Результат отсортируйте по возрастанию порядкового номера дня недели.
-- Поля в результирующей таблице:
-- weekday_number, weekday, created_orders, canceled_orders, actual_orders, success_rate
SELECT DATE_PART('isodow', time)::INTEGER AS weekday_number,
TO_CHAR(time, 'Dy') AS weekday,
COUNT(DISTINCT order_id) FILTER (WHERE action = 'create_order') AS created_orders,
COUNT(DISTINCT order_id) FILTER (WHERE action = 'cancel_order') AS canceled_orders,
COUNT(DISTINCT order_id) FILTER (WHERE action = 'create_order') - 
COUNT(DISTINCT order_id) FILTER (WHERE action = 'cancel_order') AS actual_orders,
ROUND((COUNT(DISTINCT order_id) FILTER (WHERE action = 'create_order') - 
COUNT(DISTINCT order_id) FILTER (WHERE action = 'cancel_order'))/
COUNT(DISTINCT order_id) FILTER (WHERE action = 'create_order')::DECIMAL, 3) AS success_rate
FROM user_actions
WHERE time BETWEEN '2022-08-24' AND '2022-09-07'
GROUP BY weekday_number, weekday
ORDER BY weekday_number
-- Задание 1:
-- Выведите id всех уникальных пользователей из таблицы user_actions. 
-- Результат отсортируйте по возрастанию id.
-- Поле в результирующей таблице: user_id
SELECT DISTINCT user_id
FROM user_actions
ORDER BY user_id
-- Задание 2:
-- Примените DISTINCT сразу к двум колонкам таблицы courier_actions
-- и отберите уникальные пары значений courier_id и order_id.
-- Результат отсортируйте сначала по возрастанию id курьера, затем по возрастанию id заказа.
-- Поля в результирующей таблице: courier_id, order_id
SELECT DISTINCT courier_id, order_id
FROM courier_actions
ORDER BY courier_id, order_id
-- Задание 3:
-- Посчитайте максимальную и минимальную цены товаров в таблице products. 
-- Поля назовите соответственно max_price, min_price.
-- Поля в результирующей таблице: max_price, min_price
SELECT MAX(price) AS max_price, MIN(price) AS min_price
FROM products
-- Задание 4:
-- Как вы помните, в таблице users у некоторых пользователей не были указаны их даты рождения.
-- Посчитайте в одном запросе количество всех записей в таблице и количество только тех записей,
-- для которых в колонке birth_date указана дата рождения.
-- Колонку с общим числом записей назовите dates, а колонку с записями без пропусков— dates_not_null.
-- Поля в результирующей таблице: dates, dates_not_null
SELECT COUNT(*) AS dates, COUNT(birth_date) AS dates_not_null
FROM users
-- Задача 5:
-- Посчитайте количество всех значений в колонке user_id в таблице user_actions,
-- а также количество уникальных значений в этой колонке (т.е. количество уникальных 
-- пользователей сервиса). Колонку с первым полученным значением назовите users, 
-- а колонку со вторым — unique_users. Поля в результирующей таблице: users, unique_users
SELECT COUNT(user_id) users, COUNT(DISTINCT user_id) unique_users
FROM user_actions
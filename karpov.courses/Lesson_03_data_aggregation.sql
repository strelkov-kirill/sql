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
-- Задание 6:
-- Посчитайте количество курьеров женского пола в таблице couriers. 
-- Полученный столбец с одним значением назовите couriers.
-- Поле в результирующей таблице: couriers
SELECT COUNT(DISTINCT courier_id) as couriers
FROM couriers
WHERE sex = 'female'
-- Задача 7:
-- Рассчитайте время, когда были совершены первая и последняя доставки заказов в 
-- таблице courier_actions. Колонку с временем первой доставки назовите first_delivery,
-- а колонку с временем последней — last_delivery.
-- Поля в результирующей таблице: first_delivery, last_delivery
SELECT MIN(time) AS first_delivery, MAX(time) AS last_delivery
FROM courier_actions
WHERE action = 'deliver_order'
-- Задание 8:
-- Представьте, что один из пользователей сервиса сделал заказ, в который 
-- вошли одна пачка сухариков, одна пачка чипсов и один энергетический напиток. 
-- Посчитайте стоимость такого заказа.
-- Колонку с рассчитанной стоимостью заказа назовите order_price.
-- Для расчётов используйте таблицу products.
-- Поле в результирующей таблице: order_price
SELECT SUM(price) AS order_price
FROM products
WHERE name = 'сухарики' OR name = 'энергетический напиток' OR name = 'чипсы'
-- Задание 9:
-- Посчитайте количество заказов в таблице orders с девятью и более товарами. 
-- Для этого воспользуйтесь функцией array_length, отфильтруйте данные по 
-- количеству товаров в заказе и проведите агрегацию. Полученный столбец назовите orders.
-- Поле в результирующей таблице: orders
SELECT COUNT(order_id) AS orders
FROM orders
WHERE ARRAY_LENGTH(product_ids, 1) >= 9
-- Задание 10:
-- С помощью функции AGE и агрегирующей функции рассчитайте возраст самого 
-- молодого курьера мужского пола в таблице couriers.
-- Возраст выразите количеством лет, месяцев и дней, 
-- переведя его в тип VARCHAR. В качестве даты, относительно которой считать возраст 
-- курьеров, используйте свою текущую дату.Полученную колонку со значением возраста назовите min_age.
-- Поле в результирующей таблице: min_age
SELECT MIN(AGE(birth_date)::VARCHAR) AS min_age
FROM couriers
WHERE sex = 'male'
-- Задание 11:
-- Посчитайте стоимость заказа, в котором будут три пачки сухариков,
-- две пачки чипсов и один энергетический напиток. Колонку с 
-- рассчитанной стоимостью заказа назовите order_price.
-- Для расчётов используйте таблицу products.
-- Поле в результирующей таблице: order_price
SELECT SUM(CASE
WHEN name = 'сухарики' THEN price*3
WHEN name = 'чипсы' THEN price*2
ELSE price END) AS order_price
FROM products
WHERE name = 'сухарики' OR name = 'чипсы' OR name = 'энергетический напиток'
-- Задание 12:
-- Рассчитайте среднюю цену товаров в таблице products, в названиях которых 
-- присутствуют слова «чай» или «кофе». Любым известным способом исключите из расчёта
-- товары, содержащие в названии «иван-чай» или «чайный гриб».
-- Среднюю цену округлите до двух знаков после запятой. Столбец с полученным значением 
-- назовите avg_price.Поле в результирующей таблице: avg_price
SELECT ROUND(AVG(price), 2) avg_price
FROM products
WHERE (name LIKE '%чай%' OR name LIKE '%кофе%') AND
name NOT LIKE '%иван-чай%' AND name NOT LIKE '%чайный гриб%'
-- Задание 13:
-- Воспользуйтесь функцией AGE и рассчитайте разницу в возрасте между самым 
-- старым и самым молодым пользователями мужского пола в таблице users. 
-- Разницу в возрасте выразите количеством лет, месяцев и дней, переведя её в тип VARCHAR. 
-- Колонку с посчитанным значением назовите age_diff.
-- Поле в результирующей таблице: age_diff
SELECT AGE(MAX(birth_date), MIN(birth_date))::VARCHAR age_diff
FROM users
WHERE sex = 'male'
-- Задание 14:
-- Рассчитайте среднее количество товаров в заказах из таблицы orders, которые 
-- пользователи оформляли по выходным дням (суббота и воскресенье) в течение всего 
-- времени работы сервиса.Полученное значение округлите до двух знаков после запятой.
-- Колонку с ним назовите avg_order_size.Поле в результирующей таблице: avg_order_size
SELECT ROUND(AVG(ARRAY_LENGTH(product_ids, 1)), 2) avg_order_size
FROM orders
WHERE DATE_PART('dow', creation_time) = 6 OR DATE_PART('dow', creation_time) = 0
-- Задание 15:
-- На основе данных в таблице user_actions посчитайте количество уникальных пользователей
-- сервиса, количество уникальных заказов, поделите одно на другое и выясните, сколько
-- заказов приходится на одного пользователя.В результирующей таблице отразите все три значения
-- — поля назовите соответственно unique_users, unique_orders, orders_per_user.
-- Показатель числа заказов на пользователя округлите до двух знаков после запятой.
-- Поля в результирующей таблице: unique_users, unique_orders, orders_per_user
SELECT COUNT(DISTINCT user_id) unique_users, COUNT(DISTINCT order_id) unique_orders,
ROUND(COUNT(DISTINCT order_id)::DECIMAL/COUNT(DISTINCT user_id), 2) orders_per_user
FROM user_actions
-- Задание 16:
-- Посчитайте, сколько пользователей никогда не отменяли свой заказ. 
-- Для этого из общего числа всех уникальных пользователей отнимите число уникальных пользователей,
-- которые хотя бы раз отменяли заказ. Подумайте, какое условие необходимо указать в FILTER,
-- чтобы получить корректный результат.Полученный столбец назовите users_count.
-- Поле в результирующей таблице: users_count
SELECT COUNT(DISTINCT user_id) - 
COUNT(DISTINCT user_id) FILTER (WHERE action='cancel_order') users_count
FROM user_actions
-- Задание 17:
-- Посчитайте общее количество заказов в таблице orders, количество заказов с пятью
-- и более товарами и найдите долю заказов с пятью и более товарами в общем количестве заказов.
-- В результирующей таблице отразите все три значения — поля назовите соответственно orders,
-- large_orders, large_orders_share.
-- Долю заказов с пятью и более товарами в общем количестве товаров округлите
-- до двух знаков после запятой.Поля в результирующей таблице: orders, large_orders, large_orders_share
SELECT COUNT(DISTINCT order_id) orders, 
COUNT(DISTINCT order_id) FILTER (WHERE ARRAY_LENGTH(product_ids, 1) >=5) large_orders,
ROUND(COUNT(DISTINCT order_id) FILTER (WHERE ARRAY_LENGTH(product_ids, 1) >=5)/COUNT(DISTINCT order_id)::DECIMAL, 2) large_orders_share
FROM orders
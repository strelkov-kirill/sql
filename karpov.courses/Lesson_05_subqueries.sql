-- Задание 1:
-- Используя данные из таблицы user_actions, рассчитайте среднее число заказов всех пользователей
-- нашего сервиса. Для этого сначала в подзапросе посчитайте, сколько заказов сделал каждый пользователь,
-- а затем обратитесь к результату подзапроса в блоке FROM и уже в основном запросе усредните количество
-- заказов по всем пользователям. Полученное среднее число заказов всех пользователей округлите до двух
-- знаков после запятой. Колонку с этим значением назовите orders_avg.
-- Поле в результирующей таблице: orders_avg
SELECT ROUND(AVG(orders), 2) orders_avg
FROM (SELECT user_id, COUNT(DISTINCT order_id) as orders
FROM user_actions
WHERE action = 'create_order'
GROUP BY user_id) subquery
-- Задание 2:
-- Повторите запрос из предыдущего задания, но теперь вместо подзапроса используйте оператор WITH
-- и табличное выражение. Условия задачи те же: используя данные из таблицы user_actions, 
-- рассчитайте среднее число заказов всех пользователей.
-- Полученное среднее число заказов округлите до двух знаков после запятой. 
-- Колонку с этим значением назовите orders_avg.
-- Поле в результирующей таблице: orders_avg
WITH
subquery AS (
    SELECT user_id, 
    COUNT(DISTINCT order_id) as orders
    FROM user_actions
    WHERE action = 'create_order'
    GROUP BY user_id)
    
SELECT ROUND(AVG(orders), 2) orders_avg
FROM subquery
-- Задание 3:
-- Выведите из таблицы products информацию о всех товарах кроме самого дешёвого.
-- Результат отсортируйте по убыванию id товара.
-- Поля в результирующей таблице: product_id, name, price
SELECT product_id, name, price
FROM products
WHERE price != (SELECT MIN(price) AS min_price FROM products)
ORDER BY product_id DESC
-- Задание 4:
-- Выведите информацию о товарах в таблице products, цена на которые превышает среднюю цену 
-- всех товаров на 20 рублей и более. Результат отсортируйте по убыванию id товара.
-- Поля в результирующей таблице: product_id, name, price
SELECT product_id, name, price
FROM products
WHERE price >= (SELECT AVG(price) FROM products) + 20
ORDER BY product_id DESC
-- Задание 5:
-- Посчитайте количество уникальных клиентов в таблице user_actions, сделавших за последнюю неделю
-- хотя бы один заказ. Полученную колонку с числом клиентов назовите users_count. 
-- В качестве текущей даты, от которой откладывать неделю, используйте последнюю дату в той же 
-- таблице user_actions. Поле в результирующей таблице: users_count
SELECT COUNT(DISTINCT user_id) users_count
FROM user_actions
WHERE action='create_order' AND time >= (SELECT MAX(time) FROM user_actions) - INTERVAL '1 week'
-- Задание 6:
-- С помощью функции AGE и агрегирующей функции снова определите возраст самого молодого курьера
-- мужского пола в таблице couriers, но в этот раз при расчётах в качестве первой даты используйте
-- последнюю дату из таблицы courier_actions. Чтобы получить именно дату, перед применением функции 
-- AGE переведите последнюю дату из таблицы courier_actions в формат DATE, как мы делали в этом задании.
-- Возраст курьера измерьте количеством лет, месяцев и дней и переведите его в тип VARCHAR. 
-- Полученную колонку со значением возраста назовите min_age.
-- Поле в результирующей таблице: min_age
SELECT MIN(AGE(
(SELECT MAX(time) FROM courier_actions)::DATE,
birth_date)::VARCHAR) AS min_age
FROM couriers
WHERE sex = 'male'
-- Задание 7:
-- Из таблицы user_actions с помощью подзапроса или табличного выражения отберите все заказы,
-- которые не были отменены пользователями. Выведите колонку с id этих заказов. 
-- Результат запроса отсортируйте по возрастанию id заказа.Добавьте в запрос оператор LIMIT 
-- и выведите только первые 1000 строк результирующей таблицы. Поле в результирующей таблице: order_id
SELECT order_id
FROM user_actions
WHERE order_id NOT IN (SELECT order_id FROM user_actions WHERE action = 'cancel_order')
ORDER BY 1
LIMIT 1000
-- Задание 8:
-- Используя данные из таблицы user_actions, рассчитайте, сколько заказов сделал каждый пользователь
-- и отразите это в столбце orders_count. В отдельном столбце orders_avg напротив каждого пользователя 
-- укажите среднее число заказов всех пользователей, округлив его до двух знаков после запятой.
-- Также для каждого пользователя посчитайте отклонение числа заказов от среднего значения. 
-- Отклонение считайте так: число заказов «минус» округлённое среднее значение. Колонку с отклонением 
-- назовите orders_diff. Результат отсортируйте по возрастанию id пользователя. 
-- Добавьте в запрос оператор LIMIT и выведите только первые 1000 строк результирующей таблицы.
-- Поля в результирующей таблице: user_id, orders_count, orders_avg, orders_diff
WITH t1 AS (
    SELECT user_id,
    COUNT(order_id) AS orders_count
    FROM user_actions
    WHERE action = 'create_order'
    GROUP BY user_id)

SELECT user_id, 
orders_count,
(SELECT ROUND(AVG(orders_count), 2) FROM t1) AS orders_avg,
orders_count - (SELECT ROUND(AVG(orders_count), 2) FROM t1) AS orders_diff
FROM t1
GROUP BY user_id, orders_count
ORDER BY user_id
LIMIT 1000
-- Задание 9:
-- Назначьте скидку 15% на товары, цена которых превышает среднюю цену на все товары на 50 и 
-- более рублей, а также скидку 10% на товары, цена которых ниже средней на 50 и более рублей. 
-- Цену остальных товаров внутри диапазона (среднее - 50; среднее + 50) оставьте без изменений. 
-- При расчёте средней цены, округлите её до двух знаков после запятой.
-- Выведите информацию о всех товарах с указанием старой и новой цены. Колонку с новой ценой 
-- назовите new_price. Результат отсортируйте сначала по убыванию прежней цены в колонке price, 
-- затем по возрастанию id товара. Поля в результирующей таблице: product_id, name, price, new_price
WITH t1 AS (
SELECT ROUND(AVG(price), 2) AS avg_price FROM products)

SELECT product_id,
name, price,
CASE
WHEN price - 50 > (SELECT avg_price FROM t1) THEN price*0.85
WHEN price + 50 < (SELECT avg_price FROM t1) THEN price*0.90
ELSE price END AS new_price
FROM products
ORDER BY price DESC, product_id
-- Задание 10:
-- Выясните, есть ли в таблице courier_actions такие заказы, которые были приняты курьерами,
-- но не были созданы пользователями. Посчитайте количество таких заказов.
-- Колонку с числом заказов назовите orders_count.Поле в результирующей таблице: orders_count
SELECT COUNT(order_id) as orders_count
FROM courier_actions
WHERE order_id NOT IN (SELECT order_id FROM user_actions WHERE action = 'create_order') AND 
action = 'accept_order'
-- Задание 11:
-- Выясните, есть ли в таблице user_actions такие заказы, которые были приняты курьерами, 
-- но не были доставлены пользователям. Посчитайте количество таких заказов.Колонку с числом заказов
-- назовите orders_count. Поле в результирующей таблице: orders_count
SELECT COUNT(DISTINCT order_id) as orders_count
FROM user_actions
WHERE order_id NOT IN (
SELECT order_id FROM courier_actions WHERE action = 'deliver_order')
-- Задание 12:
-- Определите количество отменённых заказов в таблице courier_actions и выясните, есть ли в этой
-- таблице такие заказы, которые были отменены пользователями, но при этом всё равно были доставлены.
-- Посчитайте количество таких заказов. Колонку с отменёнными заказами назовите orders_canceled.
-- Колонку с отменёнными, но доставленными заказами назовите orders_canceled_and_delivered. 
-- Поля в результирующей таблице: orders_canceled, orders_canceled_and_delivered
WITH t1 AS (
SELECT COUNT(order_id) FROM user_actions WHERE action = 'cancel_order'),
t2 AS (
SELECT COUNT(order_id) FILTER (
WHERE order_id IN (SELECT order_id FROM user_actions WHERE action = 'cancel_order')) 
FROM courier_actions WHERE action = 'deliver_order')

SELECT 
(SELECT * FROM t1) AS orders_canceled,
(SELECT * FROM t2) AS orders_canceled_and_delivered
-- Задание 13:
-- По таблицам courier_actions и user_actions снова определите число недоставленных заказов и среди них 
-- посчитайте количество отменённых заказов и количество заказов, которые не были отменены (и соответственно,
-- пока ещё не были доставлены).Колонку с недоставленными заказами назовите orders_undelivered, колонку 
-- с отменёнными заказами назовите orders_canceled, колонку с заказами «в пути» назовите orders_in_process.
-- Поля в результирующей таблице: orders_undelivered, orders_canceled, orders_in_process
SELECT COUNT(DISTINCT order_id) AS orders_undelivered,
COUNT(DISTINCT order_id) FILTER (WHERE action = 'cancel_order') AS orders_canceled,
COUNT(DISTINCT order_id) - COUNT(DISTINCT order_id) FILTER (WHERE action = 'cancel_order') AS orders_in_process
FROM user_actions
WHERE order_id IN (SELECT order_id 
                   FROM courier_actions 
                   WHERE order_id NOT IN (SELECT order_id
                                           FROM courier_actions
                                           WHERE action = 'deliver_order'))
-- Задание 14:
-- Отберите из таблицы users пользователей мужского пола, которые старше всех пользователей женского пола.
-- Выведите две колонки: id пользователя и дату рождения. 
-- Результат отсортируйте по возрастанию id пользователя.
-- Поля в результирующей таблице: user_id, birth_date
SELECT user_id, birth_date
FROM users
WHERE sex = 'male' AND birth_date < (SELECT MIN(birth_date) FROM users WHERE sex = 'female')
ORDER BY user_id
-- Задание 15:
-- Выведите id и содержимое 100 последних доставленных заказов из таблицы orders.
-- Содержимым заказов считаются списки с id входящих в заказ товаров.
-- Результат отсортируйте по возрастанию id заказа.
-- Поля в результирующей таблице: order_id, product_ids
SELECT order_id, product_ids
FROM orders
WHERE order_id IN (SELECT order_id FROM courier_actions WHERE action = 'deliver_order' ORDER BY time DESC LIMIT 100)
ORDER BY order_id
-- Задание 16:
-- Из таблицы couriers выведите всю информацию о курьерах, которые в сентябре 2022 года доставили 30 и более
-- заказов. Результат отсортируйте по возрастанию id курьера.
-- Поля в результирующей таблице: courier_id, birth_date, sex
SELECT courier_id, birth_date, sex
FROM couriers
WHERE courier_id IN (SELECT 
                           courier_id
                           FROM courier_actions
                           WHERE action = 'deliver_order' AND 
                           time BETWEEN '2022-09-01' AND '2022-10-01'
                           GROUP BY courier_id
                           HAVING COUNT(DISTINCT order_id) >= 30)
ORDER BY courier_id
-- Задание 17:
-- Рассчитайте средний размер заказов, отменённых пользователями мужского пола.
-- Средний размер заказа округлите до трёх знаков после запятой. Колонку со значением 
-- назовите avg_order_size. Поле в результирующей таблице: avg_order_size
SELECT ROUND(AVG(ARRAY_LENGTH(product_ids, 1)), 3) AS avg_order_size
FROM   orders
WHERE  order_id in (SELECT order_id
                    FROM   user_actions
                    WHERE  action = 'cancel_order'
                       and user_id in (SELECT user_id
                                    FROM   users
                                    WHERE  sex = 'male'))
-- Задание 18:
-- Посчитайте возраст каждого пользователя в таблице users. Возраст измерьте числом полных лет,
-- как мы делали в прошлых уроках. Возраст считайте относительно последней даты в таблице 
-- user_actions. Для тех пользователей, у которых в таблице users не указана дата рождения, 
-- укажите среднее значение возраста всех остальных пользователей, округлённое до целого числа.
-- Колонку с возрастом назовите age. В результат включите колонки с id пользователя и возрастом. 
-- Отсортируйте полученный результат по возрастанию id пользователя.
-- Поля в результирующей таблице: user_id, age
WITH t1 AS(
SELECT MAX(time) as max_time
FROM user_actions)

SELECT user_id,
COALESCE(DATE_PART('year', AGE((SELECT * FROM t1), birth_date))::INTEGER, 
DATE_PART('year', (SELECT AVG(AGE((SELECT * FROM t1),birth_date)) FROM users))::INTEGER) AS age
FROM users
ORDER BY user_id
-- Задание 19:
-- Для каждого заказа, в котором больше 5 товаров, рассчитайте время, затраченное на его доставку. 
-- В результат включите id заказа, время принятия заказа курьером, время доставки заказа и 
-- время, затраченное на доставку. Новые колонки назовите соответственно time_accepted, 
-- time_delivered и delivery_time. В расчётах учитывайте только неотменённые заказы. 
-- Время, затраченное на доставку, выразите в минутах, округлив значения до целого числа. 
-- Результат отсортируйте по возрастанию id заказа. 
-- Поля в результирующей таблице: order_id, time_accepted, time_delivered и delivery_time
SELECT order_id,
MIN(time) AS time_accepted,
MAX(time) AS time_delivered,
(EXTRACT(epoch FROM MAX(time) - MIN(time))/60)::INTEGER AS delivery_time
FROM courier_actions
WHERE order_id IN (SELECT order_id FROM orders WHERE ARRAY_LENGTH(product_ids, 1) > 5) AND 
order_id NOT IN (SELECT order_id FROM user_actions WHERE action = 'cancel_order')
GROUP BY order_id
ORDER BY order_id
-- Задание 20:
-- Для каждой даты в таблице user_actions посчитайте количество первых заказов, 
-- совершённых пользователями. Первыми заказами будем считать заказы, которые пользователи 
-- сделали в нашем сервисе впервые. В расчётах учитывайте только неотменённые заказы.
-- В результат включите две колонки: дату и количество первых заказов в эту дату. 
-- Колонку с датами назовите date, а колонку с первыми заказами — first_orders.
-- Результат отсортируйте по возрастанию даты.
-- Поля в результирующей таблице: date, first_orders
WITH first_ord AS (
    SELECT user_id, MIN(time)::DATE AS first_order_date
    FROM user_actions 
    WHERE order_id NOT IN(
        SELECT order_id
        FROM user_actions 
        WHERE action = 'cancel_order')
    GROUP BY user_id)
 
SELECT first_order_date AS date,  COUNT(user_id) AS first_orders
FROM first_ord
GROUP BY date
ORDER BY date
-- Задание 21:
-- Выберите все колонки из таблицы orders и дополнительно в качестве последней колонки укажите 
-- функцию unnest, применённую к колонке product_ids. Эту последнюю колонку назовите product_id. 
-- Больше ничего с данными делать не нужно. Добавьте в запрос оператор LIMIT и выведите только 
-- первые 100 записей результирующей таблицы. Поля в результирующей таблице: 
-- creation_time, order_id, product_ids, product_id
SELECT creation_time, order_id, product_ids, UNNEST(product_ids) product_id
FROM orders
LIMIT 100
-- Задание 22:
-- Используя функцию unnest, определите 10 самых популярных товаров в таблице orders. Самыми 
-- популярными товарами будем считать те, которые встречались в заказах чаще всего. 
-- Если товар встречается в одном заказе несколько раз (когда было куплено несколько единиц товара),
-- это тоже учитывается при подсчёте. Учитывайте только неотменённые заказы.
-- Выведите id товаров и то, сколько раз они встречались в заказах (то есть сколько раз были куплены).
-- Новую колонку с количеством покупок товаров назовите times_purchased.
-- Результат отсортируйте по возрастанию id товара.
-- Поля в результирующей таблице: product_id, times_purchased
WITH t1 AS (SELECT UNNEST(product_ids) AS product_id, COUNT(order_id) AS times_purchased
FROM orders
WHERE order_id NOT IN (SELECT order_id FROM user_actions WHERE action = 'cancel_order')
GROUP BY product_id
ORDER BY times_purchased DESC
LIMIT 10)
SELECT product_id, times_purchased
FROM t1
ORDER BY product_id
-- Задание 23:
-- Из таблицы orders выведите id и содержимое заказов, которые включают хотя бы один из пяти 
-- самых дорогих товаров, доступных в нашем сервисе.Результат отсортируйте по возрастанию id заказа.
-- Поля в результирующей таблице: order_id, product_ids
WITH top_price AS (SELECT product_id 
FROM products 
ORDER BY price DESC 
LIMIT 5), unnest AS (SELECT order_id, product_ids, UNNEST(product_ids) AS product_id FROM orders)

SELECT DISTINCT order_id, product_ids
FROM unnest
WHERE product_id IN (SELECT product_id FROM top_price)
ORDER BY order_id
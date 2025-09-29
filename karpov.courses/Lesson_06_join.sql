-- Задание 1:
-- Объедините таблицы user_actions и users по ключу user_id. В результат включите две колонки
-- с user_id из обеих таблиц. Эти две колонки назовите соответственно user_id_left 
-- и user_id_right. Также в результат включите колонки order_id, time, action, sex,
-- birth_date. Отсортируйте получившуюся таблицу по возрастанию id пользователя
-- (в любой из двух колонок с id). Поля в результирующей таблице: user_id_left, 
-- user_id_right,  order_id, time, action, sex, birth_date
SELECT ua.user_id as user_id_left, u.user_id as user_id_right, order_id,
time, action, sex, birth_date
FROM user_actions ua
JOIN users u
ON ua.user_id = u.user_id
ORDER BY ua.user_id
-- Задание 2:
-- А теперь попробуйте немного переписать запрос из прошлого задания и посчитать количество 
-- уникальных id в объединённой таблице. То есть снова объедините таблицы, но в этот 
-- раз просто посчитайте уникальные user_id в одной из колонок с id. Выведите это 
-- количество в качестве результата. Колонку с посчитанным значением назовите users_count.
-- Поле в результирующей таблице: users_count
SELECT COUNT(DISTINCT user_id_left) as users_count
FROM
(SELECT ua.user_id as user_id_left, u.user_id as user_id_right, order_id,
time, action, sex, birth_date
FROM user_actions ua
JOIN users u
ON ua.user_id = u.user_id
ORDER BY ua.user_id) t1
-- Задание 3:
-- С помощью LEFT JOIN объедините таблицы user_actions и users по ключу user_id. 
-- Обратите внимание на порядок таблиц — слева user_actions, справа users. 
-- В результат включите две колонки с user_id из обеих таблиц. 
-- Эти две колонки назовите соответственно user_id_left и user_id_right. 
-- Также в результат включите колонки order_id, time, action, sex, birth_date. 
-- Отсортируйте получившуюся таблицу по возрастанию id пользователя (в колонке из левой таблицы).
SELECT ua.user_id as user_id_left, u.user_id as user_id_right, order_id,
time, action, sex, birth_date
FROM user_actions ua
LEFT JOIN users u
ON ua.user_id = u.user_id
ORDER BY ua.user_id
-- Задание 4:
-- Теперь снова попробуйте немного переписать запрос из прошлого задания и посчитайте количество
-- уникальных id в колонке user_id, пришедшей из левой таблицы user_actions. Выведите это 
-- количество в качестве результата. Колонку с посчитанным значением назовите users_count.
-- Поле в результирующей таблице: users_count
SELECT COUNT(DISTINCT user_id_left) users_count FROM 
(SELECT ua.user_id as user_id_left, u.user_id as user_id_right, order_id,
time, action, sex, birth_date
FROM user_actions ua
LEFT JOIN users u
ON ua.user_id = u.user_id
ORDER BY ua.user_id) t1
-- Задание 5:
-- Возьмите запрос из задания 3, где вы объединяли таблицы user_actions и users с помощью LEFT JOIN,
-- добавьте к запросу оператор WHERE и исключите NULL значения в колонке user_id из правой таблицы.
-- Включите в результат все те же колонки и отсортируйте получившуюся таблицу по 
-- возрастанию id пользователя в колонке из левой таблицы.
-- Поля в результирующей таблице: user_id_left, user_id_right,  order_id, time, action, sex, birth_date
SELECT ua.user_id as user_id_left, u.user_id as user_id_right, order_id,
time, action, sex, birth_date
FROM user_actions ua
LEFT JOIN users u
ON ua.user_id = u.user_id
WHERE u.user_id IS NOT NULL
ORDER BY ua.user_id
-- Задание 6:
-- С помощью FULL JOIN объедините по ключу birth_date таблицы, полученные в результате
-- вышеуказанных запросов (то есть объедините друг с другом два подзапроса). 
-- Не нужно изменять их, просто добавьте нужный JOIN. В результат включите две колонки 
-- с birth_date из обеих таблиц. Эти две колонки назовите соответственно users_birth_date 
-- и couriers_birth_date. Также включите в результат колонки с числом пользователей и 
-- курьеров — users_count и couriers_count. Отсортируйте получившуюся таблицу сначала по 
-- колонке users_birth_date по возрастанию, затем по колонке couriers_birth_date — тоже по возрастанию.
-- Поля в результирующей таблице: users_birth_date, users_count,  couriers_birth_date, couriers_count
SELECT t1.birth_date as users_birth_date, users_count,
t2.birth_date as couriers_birth_date, couriers_count
FROM (SELECT birth_date, COUNT(user_id) AS users_count
    FROM users
    WHERE birth_date IS NOT NULL
    GROUP BY birth_date) t1
FULL JOIN (SELECT birth_date, COUNT(courier_id) AS couriers_count
    FROM couriers
    WHERE birth_date IS NOT NULL
    GROUP BY birth_date) t2
ON t1.birth_date = t2.birth_date
ORDER BY users_birth_date, couriers_birth_date
-- Задача 7:
-- Поместите в подзапрос полученный после объединения набор дат и посчитайте их количество. 
-- Колонку с числом дат назовите dates_count.
-- Поле в результирующей таблице: dates_count
SELECT COUNT(birth_date) as dates_count
FROM
(SELECT birth_date
    FROM users
    WHERE birth_date IS NOT NULL
    UNION
    SELECT birth_date
    FROM couriers
    WHERE birth_date IS NOT NULL) t1
-- Задание 8:
-- Из таблицы users отберите id первых 100 пользователей (просто выберите первые 100 записей,
-- используя простой LIMIT) и с помощью CROSS JOIN объедините их со всеми наименованиями 
-- товаров из таблицы products. Выведите две колонки — id пользователя и наименование товара.
-- Результат отсортируйте сначала по возрастанию id пользователя, затем по имени товара — 
-- тоже по возрастанию. Поля в результирующей таблице: user_id, name
SELECT user_id, name
FROM
    (SELECT user_id
    FROM users
    LIMIT 100) t1
CROSS JOIN
    (SELECT name
    FROM products) t2
ORDER BY user_id, name
-- Задание 9:
-- Для начала объедините таблицы user_actions и orders — это вы уже умеете делать. 
-- В качестве ключа используйте поле order_id. Выведите id пользователей и заказов, 
-- а также список товаров в заказе. Отсортируйте таблицу по id пользователя по возрастанию, 
-- затем по id заказа — тоже по возрастанию.
-- Добавьте в запрос оператор LIMIT и выведите только первые 1000 строк результирующей таблицы.
-- Поля в результирующей таблице: user_id, order_id, product_ids
SELECT user_id, ua.order_id, product_ids
FROM user_actions ua
LEFT JOIN orders o
ON ua.order_id=o.order_id
ORDER BY user_id, order_id
LIMIT 1000
-- Задание 10:
-- Снова объедините таблицы user_actions и orders, но теперь оставьте только уникальные 
-- неотменённые заказы (мы делали похожий запрос на прошлом уроке). 
-- Остальные условия задачи те же: вывести id пользователей и заказов, а 
-- также список товаров в заказе. Отсортируйте таблицу по id пользователя по возрастанию,
-- затем по id заказа — тоже по возрастанию.
-- Добавьте в запрос оператор LIMIT и выведите только первые 1000 строк результирующей таблицы.
-- Поля в результирующей таблице: user_id, order_id, product_ids
SELECT user_id, ua.order_id, product_ids
FROM 
    (SELECT DISTINCT user_id, order_id 
    FROM user_actions 
    WHERE order_id NOT IN (SELECT order_id FROM user_actions WHERE action = 'cancel_order')) ua
    LEFT JOIN orders o
    ON ua.order_id=o.order_id
ORDER BY user_id, order_id
LIMIT 1000
-- Задание 11:
-- Используя запрос из предыдущего задания, посчитайте, сколько в среднем товаров заказывает
-- каждый пользователь. Выведите id пользователя и среднее количество товаров в заказе.
-- Среднее значение округлите до двух знаков после запятой. 
-- Колонку посчитанными значениями назовите avg_order_size. 
-- Результат выполнения запроса отсортируйте по возрастанию id пользователя. 
-- Добавьте в запрос оператор LIMIT и выведите только первые 1000 строк результирующей таблицы.
-- Поля в результирующей таблице: user_id, avg_order_size
SELECT user_id, ROUND(AVG(ARRAY_LENGTH(product_ids, 1)), 2) as avg_order_size
FROM 
    (SELECT DISTINCT user_id, order_id 
    FROM user_actions 
    WHERE order_id NOT IN (SELECT order_id FROM user_actions WHERE action = 'cancel_order')) ua
    LEFT JOIN orders o
    ON ua.order_id=o.order_id
GROUP BY user_id
ORDER BY user_id
LIMIT 1000
-- Задание 12:
-- Для начала к таблице с заказами (orders) примените функцию unnest, как мы делали в прошлом уроке.
-- Колонку с id товаров назовите product_id. Затем к образовавшейся расширенной таблице по ключу
-- product_id добавьте информацию о ценах на товары (из таблицы products). 
-- Должна получиться таблица с заказами, товарами внутри каждого заказа и ценами на эти товары. 
-- Выведите колонки с id заказа, id товара и ценой товара. 
-- Результат отсортируйте сначала по возрастанию id заказа, затем по возрастанию id товара.
-- Добавьте в запрос оператор LIMIT и выведите только первые 1000 строк результирующей таблицы.
-- Поля в результирующей таблице: order_id, product_id, price
SELECT order_id, t1.product_id, price
FROM
    (SELECT order_id, UNNEST(product_ids) AS product_id
    FROM orders) t1
    LEFT JOIN products
    ON t1.product_id = products.product_id
ORDER BY order_id, t1.product_id
LIMIT 1000
-- Задание 13:
-- Используя запрос из предыдущего задания, рассчитайте суммарную стоимость каждого заказа. 
-- Выведите колонки с id заказов и их стоимостью. Колонку со стоимостью заказа назовите order_price.
-- Результат отсортируйте по возрастанию id заказа.
-- Добавьте в запрос оператор LIMIT и выведите только первые 1000 строк результирующей таблицы.
-- Поля в результирующей таблице: order_id, order_price
SELECT order_id, SUM(price) as order_price
FROM
    (SELECT order_id, UNNEST(product_ids) AS product_id
    FROM orders) t1
    LEFT JOIN products
    ON t1.product_id = products.product_id
GROUP BY order_id
ORDER BY order_id
LIMIT 1000
-- Задача 14:
-- Объедините запрос из предыдущего задания с частью запроса, который вы составили в задаче 11, 
-- то есть объедините запрос со стоимостью заказов с запросом, в котором вы считали размер каждого
-- заказа из таблицы user_actions. На основе объединённой таблицы для каждого пользователя 
-- рассчитайте следующие показатели:
-- общее число заказов — колонку назовите orders_count
-- среднее количество товаров в заказе — avg_order_size
-- суммарную стоимость всех покупок — sum_order_value
-- среднюю стоимость заказа — avg_order_value
-- минимальную стоимость заказа — min_order_value
-- максимальную стоимость заказа — max_order_value
-- Полученный результат отсортируйте по возрастанию id пользователя.
-- Добавьте в запрос оператор LIMIT и выведите только первые 1000 строк результирующей таблицы.
-- Помните, что в расчётах мы по-прежнему учитываем только неотменённые заказы. 
-- При расчёте средних значений, округляйте их до двух знаков после запятой.
-- Поля в результирующей таблице: 
-- user_id, orders_count, avg_order_size, sum_order_value, avg_order_value, min_order_value, max_order_value
SELECT user_id,
    COUNT(ua.order_id) as orders_count,
    ROUND(AVG(array_length(product_ids, 1)), 2) as avg_order_size,
    ROUND(SUM(order_price), 2) as sum_order_value,
    ROUND(AVG(order_price), 2) as avg_order_value,
    ROUND(MIN(order_price), 2) as min_order_value,
    ROUND(MAX(order_price), 2) as max_order_value
FROM   (SELECT DISTINCT user_id, order_id
        FROM   user_actions
        WHERE  order_id not in (SELECT order_id
                                FROM   user_actions
                                WHERE  action = 'cancel_order')) ua
    LEFT JOIN orders o
        ON ua.order_id = o.order_id
    LEFT JOIN (SELECT order_id, SUM(price) as order_price
FROM
    (SELECT order_id, UNNEST(product_ids) AS product_id
    FROM orders) t1
    LEFT JOIN products
    ON t1.product_id = products.product_id
    GROUP BY order_id) t2
        ON o.order_id = t2.order_id
GROUP BY user_id
ORDER BY user_id limit 1000
-- Задание 15:
-- По данным таблиц orders, products и user_actions посчитайте ежедневную выручку сервиса.
-- Под выручкой будем понимать стоимость всех реализованных товаров, содержащихся в заказах.
-- Колонку с датой назовите date, а колонку со значением выручки — revenue.
-- В расчётах учитывайте только неотменённые заказы.
-- Результат отсортируйте по возрастанию даты.
-- Поля в результирующей таблице: date, revenue
SELECT creation_time::DATE date, SUM(price) as revenue
FROM (SELECT creation_time, order_id, UNNEST(product_ids) as product_id
    FROM orders) t1
INNER JOIN
    (SELECT order_id 
    FROM user_actions 
    WHERE order_id NOT IN (
    SELECT order_id FROM user_actions WHERE action = 'cancel_order')) t2
    ON t1.order_id = t2.order_id
LEFT JOIN products p
    ON t1.product_id = p.product_id
GROUP BY date
ORDER BY date
-- Задание 16:
-- По таблицам courier_actions , orders и products определите 10 самых популярных товаров,
-- доставленных в сентябре 2022 года. Самыми популярными товарами будем считать те, 
-- которые встречались в заказах чаще всего. Если товар встречается в одном заказе несколько 
-- раз (было куплено несколько единиц товара), то при подсчёте учитываем только одну единицу товара.
-- Выведите наименования товаров и сколько раз они встречались в заказах. Новую колонку с количеством
-- покупок товара назовите times_purchased. Поля в результирующей таблице: name, times_purchased
SELECT name, COUNT(product_id) as times_purchased
FROM
    (SELECT DISTINCT ca.order_id, o.product_id, name
    FROM (SELECT order_id FROM courier_actions
    WHERE action = 'deliver_order' AND time BETWEEN '2022-09-01' AND '2022-10-01') ca
    LEFT JOIN (SELECT order_id, UNNEST(product_ids) as product_id FROM orders) o
    ON ca.order_id = o.order_id
    LEFT JOIN products p
    ON o.product_id = p.product_id) t1
GROUP BY name
ORDER BY times_purchased DESC
LIMIT 10
-- Задание 17:
-- Возьмите запрос, составленный на одном из прошлых уроков, и подтяните в него из таблицы users
-- данные о поле пользователей таким образом, чтобы все пользователи из таблицы user_actions 
-- остались в результате. Затем посчитайте среднее значение cancel_rate для каждого пола, 
-- округлив его до трёх знаков после запятой. Колонку с посчитанным средним значением назовите
-- avg_cancel_rate. Помните про отсутствие информации о поле некоторых пользователей после 
-- join, так как не все пользователи из таблицы user_action есть в таблице users. 
-- Для этой группы тоже посчитайте cancel_rate и в результирующей таблице для пустого 
-- значения в колонке с полом укажите ‘unknown’ (без кавычек). 
-- Результат отсортируйте по колонке с полом пользователя по возрастанию.
-- Поля в результирующей таблице: sex, avg_cancel_rate
SELECT COALESCE(sex, 'unknown') as sex, ROUND(AVG(cancel_rate), 3) as avg_cancel_rate FROM
(SELECT user_id,
       count(distinct order_id) filter (WHERE action = 'create_order') as orders_count,
       round(count(order_id) filter (WHERE action = 'cancel_order')::decimal/count(distinct order_id) filter (WHERE action = 'create_order'),
             2) as cancel_rate
FROM   user_actions
GROUP BY user_id
ORDER BY 1) t1
LEFT JOIN users u
ON t1.user_id = u.user_id
GROUP BY sex
ORDER BY sex
-- Задание 18:
-- По таблицам orders и courier_actions определите id десяти заказов, 
-- которые доставляли дольше всего. Поле в результирующей таблице: order_id
SELECT ca.order_id
FROM (SELECT order_id, action, time
        FROM courier_actions
        WHERE action = 'deliver_order') ca
LEFT JOIN orders o
ON ca.order_id = o.order_id
ORDER BY time - creation_time DESC
LIMIT 10
-- Задача 19:
-- Произведите замену списков с id товаров из таблицы orders на списки с наименованиями товаров.
-- Наименования возьмите из таблицы products. Колонку с новыми списками наименований
-- назовите product_names. Добавьте в запрос оператор LIMIT и выведите только первые
-- 1000 строк результирующей таблицы.Поля в результирующей таблице: order_id, product_names
SELECT order_id, ARRAY_AGG(name) as product_names
FROM (SELECT order_id, UNNEST(product_ids) as product_id 
     FROM orders) o
LEFT JOIN products p 
ON o.product_id = p.product_id
GROUP BY order_id
LIMIT 1000
-- Задание 20:
-- Выясните, кто заказывал и доставлял самые большие заказы. Самыми большими считайте 
-- заказы с наибольшим числом товаров. Выведите id заказа, id пользователя и id курьера. 
-- Также в отдельных колонках укажите возраст пользователя и возраст курьера. 
-- Возраст измерьте числом полных лет, как мы делали в прошлых уроках. 
-- Считайте его относительно последней даты в таблице user_actions — как для пользователей,
-- так и для курьеров. Колонки с возрастом назовите user_age и courier_age. 
-- Результат отсортируйте по возрастанию id заказа.
-- Поля в результирующей таблице: order_id, user_id, user_age, courier_id, courier_age
SELECT DISTINCT t1.order_id, ua.user_id_from_ua as user_id, 
DATE_PART('year', AGE((SELECT MAX(time) FROM user_actions), birth_date_users))::INTEGER as user_age,
ca.courier_id_from_ca as courier_id,
DATE_PART('year', AGE((SELECT MAX(time) FROM user_actions), birth_date_c))::INTEGER as courier_age
FROM (SELECT order_id
FROM orders
WHERE ARRAY_LENGTH(product_ids, 1) = (SELECT MAX(ARRAY_LENGTH(product_ids, 1)) FROM orders)) t1
LEFT JOIN (SELECT order_id, time as time_from_ua, user_id as user_id_from_ua FROM user_actions) ua
ON t1.order_id = ua.order_id
LEFT JOIN (SELECT birth_date as birth_date_users, user_id FROM users) u
ON ua.user_id_from_ua = u.user_id
LEFT JOIN (SELECT courier_id as courier_id_from_ca, order_id FROM courier_actions) ca
ON t1.order_id = ca.order_id
LEFT JOIN (SELECT birth_date as birth_date_c, courier_id FROM couriers) c
ON ca.courier_id_from_ca = c.courier_id
ORDER BY order_id
-- Задание 21:
-- Выясните, какие пары товаров покупают вместе чаще всего.
-- Пары товаров сформируйте на основе таблицы с заказами. Отменённые заказы не учитывайте. 
-- В качестве результата выведите две колонки — колонку с парами наименований товаров и 
-- колонку со значениями, показывающими, сколько раз конкретная пара встретилась в заказах 
-- пользователей. Колонки назовите соответственно pair и count_pair. Пары товаров должны быть 
-- представлены в виде списков из двух наименований. Пары товаров внутри списков должны быть 
-- отсортированы в порядке возрастания наименования. Результат отсортируйте сначала по 
-- убыванию частоты встречаемости пары товаров в заказах, затем по колонке pair — по возрастанию.
-- Поля в результирующей таблице: pair, count_pair
WITH op AS (SELECT t1.order_id, t1.product_id, p.name
FROM (SELECT order_id, UNNEST(product_ids) AS product_id
FROM orders
WHERE order_id NOT IN (SELECT order_id FROM user_actions WHERE action = 'cancel_order')) t1
LEFT JOIN products p
ON t1.product_id = p.product_id)
SELECT pair, COUNT(pair) AS count_pair
FROM (SELECT DISTINCT t1.order_id, ARRAY_SORT(ARRAY [t1.name, t2.name]) as pair
FROM op t1
JOIN op t2
ON t1.order_id = t2.order_id AND t1.product_id <t2.product_id) t3
GROUP BY pair
ORDER BY 2 DESC, 1
-- Задание 1:
-- Примените оконные функции к таблице products и с помощью ранжирующих функций упорядочьте 
-- все товары по цене — от самых дорогих к самым дешёвым. Добавьте в таблицу следующие колонки:
-- Колонку product_number с порядковым номером товара (функция ROW_NUMBER).
-- Колонку product_rank с рангом товара с пропусками рангов (функция RANK).
-- Колонку product_dense_rank с рангом товара без пропусков рангов (функция DENSE_RANK).
-- Поля в результирующей таблице: product_id, name, price, product_number, product_rank,
-- product_dense_rank
SELECT product_id, name, price,
ROW_NUMBER() OVER(ORDER BY price DESC) AS product_number,
RANK() OVER(ORDER BY price DESC) AS product_rank,
DENSE_RANK() OVER(ORDER BY price DESC) AS product_dense_rank
FROM products
-- Задание 2:
-- Примените оконную функцию к таблице products и с помощью агрегирующей функции в отдельной
-- колонке для каждой записи проставьте цену самого дорогого товара. Колонку с этим значением
-- назовите max_price. Затем для каждого товара посчитайте долю его цены в стоимости самого
-- дорогого товара — просто поделите одну колонку на другую. Полученные доли округлите до
-- двух знаков после запятой. Колонку с долями назовите share_of_max. Выведите всю информацию
-- о товарах, включая значения в новых колонках. Результат отсортируйте сначала по убыванию
-- цены товара, затем по возрастанию id товара.
-- Поля в результирующей таблице: product_id, name, price, max_price, share_of_max
SELECT product_id, name, price,
MAX(price) OVER() AS max_price,
ROUND(price / MAX(price) OVER()::DECIMAL, 2) AS share_of_max
FROM products
GROUP BY product_id, name, price
ORDER BY price DESC, product_id
-- Задание 3:
-- Примените две оконные функции к таблице products. Одну с агрегирующей функцией MAX,
-- а другую с агрегирующей функцией MIN — для вычисления максимальной и минимальной цены.
-- Для двух окон задайте инструкцию ORDER BY по убыванию цены. Поместите результат вычислений 
-- в две колонки max_price и min_price. Выведите всю информацию о товарах, включая значения 
-- в новых колонках. Результат отсортируйте сначала по убыванию цены товара, затем по возрастанию
-- id товара. Поля в результирующей таблице: product_id, name, price, max_price, min_price
SELECT product_id, name, price,
MAX(price) OVER(ORDER BY price DESC) AS max_price,
MIN(price) OVER(ORDER BY price DESC) AS min_price
FROM products
GROUP BY product_id, name, price
ORDER BY price DESC, product_id
-- Задание 4:
-- Сначала на основе таблицы orders сформируйте запрос, который вернет таблицу с общим числом
-- заказов по дням. При подсчёте числа заказов не учитывайте отменённые заказы 
-- (их можно определить по таблице user_actions). Колонку с днями назовите date, а колонку 
-- с числом заказов — orders_count. Затем поместите полученную таблицу в подзапрос и примените к 
-- ней оконную функцию в паре с агрегирующей функцией SUM для расчёта накопительной суммы 
-- числа заказов. Не забудьте для окна задать инструкцию ORDER BY по дате.
-- Колонку с накопительной суммой назовите orders_count_cumulative. В результате такой
-- операции значение накопительной суммы для последнего дня должно получиться равным общему 
-- числу заказов за весь период. Сортировку результирующей таблицы делать не нужно.
-- Поля в результирующей таблице: date, orders_count, orders_count_cumulative
SELECT date, orders_count, 
SUM(orders_count) OVER(ORDER BY date)::INTEGER as orders_count_cumulative
FROM
(SELECT creation_time::DATE as date, COUNT(order_id) as orders_count
FROM orders
WHERE order_id NOT IN (SELECT order_id FROM user_actions WHERE action = 'cancel_order')
GROUP BY 1) t1
-- Задание 5:
-- Для каждого пользователя в таблице user_actions посчитайте порядковый номер каждого заказа.
-- Для этого примените оконную функцию ROW_NUMBER, используйте id пользователей для деления
-- на патриции, а время заказа для сортировки внутри патриции. Отменённые заказы не учитывайте.
-- Новую колонку с порядковым номером заказа назовите order_number. Результат отсортируйте
-- сначала по возрастанию id пользователя, затем по возрастанию порядкового номера заказа.
-- Добавьте в запрос оператор LIMIT и выведите только первые 1000 строк результирующей таблицы.
-- Поля в результирующей таблице: user_id, order_id, time, order_number
SELECT user_id, order_id, time,
ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY time) AS order_number
FROM user_actions
WHERE order_id NOT IN (SELECT order_id FROM user_actions WHERE action = 'cancel_order')
ORDER BY user_id, order_id
LIMIT 1000
-- Задание 6:
-- Дополните запрос из предыдущего задания и с помощью оконной функции для каждого заказа 
-- каждого пользователя рассчитайте, сколько времени прошло с момента предыдущего заказа. 
-- Для этого сначала в отдельном столбце с помощью LAG сделайте смещение по столбцу time 
-- на одно значение назад. Столбец со смещёнными значениями назовите time_lag. Затем отнимите 
-- от каждого значения в колонке time новое значение со смещением (либо можете использовать уже
-- знакомую функцию AGE). Колонку с полученным интервалом назовите time_diff. Менять формат 
-- отображения значений не нужно.
-- По-прежнему не учитывайте отменённые заказы. Также оставьте в запросе порядковый номер 
-- каждого заказа, рассчитанный на прошлом шаге. Результат отсортируйте сначала по 
-- возрастанию id пользователя, затем по возрастанию порядкового номера заказа.
-- Добавьте в запрос оператор LIMIT и выведите только первые 1000 строк результирующей таблицы.
-- Поля в результирующей таблице: user_id, order_id, time, order_number, time_lag, time_diff
SELECT user_id, order_id, time,
ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY time) AS order_number,
LAG(time, 1) OVER(PARTITION BY user_id ORDER BY time) AS time_lag,
time - LAG(time, 1) OVER(PARTITION BY user_id ORDER BY time) AS time_diff
FROM user_actions
WHERE order_id NOT IN (SELECT order_id FROM user_actions WHERE action = 'cancel_order')
ORDER BY user_id, order_id
LIMIT 1000
-- Задание 7:
-- На основе запроса из предыдущего задания для каждого пользователя рассчитайте, сколько в
-- среднем времени проходит между его заказами. Посчитайте этот показатель только для тех
-- пользователей, которые за всё время оформили более одного неотмененного заказа.
-- Среднее время между заказами выразите в часах, округлив значения до целого числа. 
-- Колонку со средним значением времени назовите hours_between_orders. Результат отсортируйте 
-- по возрастанию id пользователя. Добавьте в запрос оператор LIMIT и включите в результат 
-- только первые 1000 записей.Поля в результирующей таблице: user_id, hours_between_orders
SELECT user_id, AVG((EXTRACT(epoch FROM time_diff)::DECIMAL/3600))::INTEGER AS hours_between_orders
FROM
(SELECT user_id, order_id, time,
ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY time) AS order_number,
LAG(time, 1) OVER(PARTITION BY user_id ORDER BY time) AS time_lag,
time - LAG(time, 1) OVER(PARTITION BY user_id ORDER BY time) AS time_diff
FROM user_actions
WHERE order_id NOT IN (SELECT order_id FROM user_actions WHERE action = 'cancel_order')
ORDER BY user_id, order_id) t1
GROUP BY user_id
HAVING AVG((EXTRACT(epoch FROM time_diff)::DECIMAL/3600))::INTEGER IS NOT NULL
LIMIT 1000
-- Задание 8:
-- Сначала на основе таблицы orders сформируйте новую таблицу с общим числом заказов по дням.
-- При подсчёте числа заказов не учитывайте отменённые заказы. Колонку с числом заказов 
-- назовите orders_count. Затем поместите полученную таблицу в подзапрос и примените к ней оконную
-- функцию в паре с агрегирующей функцией AVG для расчёта скользящего среднего числа заказов.
-- Скользящее среднее для каждой записи считайте по трём предыдущим дням. Подумайте, как правильно
-- задать границы рамки, чтобы получить корректные расчёты.
-- Полученные значения скользящего среднего округлите до двух знаков после запятой. 
-- Колонку с рассчитанным показателем назовите moving_avg. Сортировку результирующей таблицы 
-- делать не нужно. Поля в результирующей таблице: date, orders_count, moving_avg
SELECT date, orders_count, ROUND(AVG(orders_count) OVER(ORDER BY date
                                                ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING), 2) AS moving_avg
FROM
(SELECT date, orders_count,
    sum(orders_count) OVER(ORDER BY date)::integer as orders_count_cumulative
FROM   (SELECT creation_time::date as date, count(order_id) as orders_count
        FROM   orders
        WHERE  order_id not in (SELECT order_id
                                FROM   user_actions
                                WHERE  action = 'cancel_order')
        GROUP BY 1) t1) t2
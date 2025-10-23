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
-- Задание 9:
--Отметьте в отдельной таблице тех курьеров, которые доставили в сентябре 2022 года заказов 
--больше, чем в среднем все курьеры. Сначала для каждого курьера в таблице courier_actions 
--рассчитайте общее количество доставленных в сентябре заказов. Затем в отдельном столбце с 
--помощью оконной функции укажите, сколько в среднем заказов доставили в этом месяце все курьеры. 
--После этого сравните число заказов, доставленных каждым курьером, со средним значением в 
--новом столбце. Если курьер доставил больше заказов, чем в среднем все курьеры, то в отдельном 
--столбце с помощью CASE укажите число 1, в противном случае укажите 0.
--Колонку с результатом сравнения назовите is_above_avg, колонку с числом доставленных заказов 
--каждым курьером — delivered_orders, а колонку со средним значением — avg_delivered_orders. 
--При расчёте среднего значения округлите его до двух знаков после запятой. Результат 
--отсортируйте по возрастанию id курьера.
--Поля в результирующей таблице: courier_id, delivered_orders, avg_delivered_orders, is_above_avg
SELECT courier_id, COUNT(order_id) as delivered_orders,
ROUND(AVG(COUNT(order_id)) OVER(), 2) as avg_delivered_orders,
CASE WHEN COUNT(order_id) > ROUND(AVG(COUNT(order_id)) OVER(), 2) THEN 1 ELSE 0 END AS is_above_avg
FROM courier_actions
WHERE action = 'deliver_order' AND time BETWEEN '2022-09-01' AND '2022-10-01'
GROUP BY courier_id
ORDER BY courier_id
-- Задание 10:
-- По данным таблицы user_actions посчитайте число первых и повторных заказов на каждую дату.
-- Для этого сначала с помощью оконных функций и оператора CASE сформируйте таблицу, в которой 
-- напротив каждого заказа будет стоять отметка «Первый» или «Повторный» (без кавычек). Для каждого
-- пользователя первым заказом будет тот, который был сделан раньше всего. Все остальные заказы должны
-- попасть, соответственно, в категорию «Повторный». Затем на каждую дату посчитайте число заказов 
-- каждой категории. Колонку с типом заказа назовите order_type, колонку с датой — date, колонку 
-- с числом заказов — orders_count. В расчётах учитывайте только неотменённые заказы.
-- Результат отсортируйте сначала по возрастанию даты, затем по возрастанию значений в колонке
-- с типом заказа. Поля в результирующей таблице: date, order_type, orders_count
SELECT date, order_type,
COUNT(order_type) as orders_count
FROM
(SELECT user_id, order_id, time::DATE as date,
CASE 
WHEN MIN(time) OVER(PARTITION BY user_id) = time THEN 'Первый' ELSE 'Повторный' END AS order_type
FROM user_actions
WHERE order_id NOT IN (SELECT order_id FROM user_actions WHERE action = 'cancel_order')) q1
GROUP BY date, order_type
ORDER BY date, order_type
-- Задание 11:
-- К запросу, полученному на предыдущем шаге, примените оконную функцию и для каждого дня 
-- посчитайте долю первых и повторных заказов. Сохраните структуру полученной ранее таблицы
-- и добавьте только одну новую колонку с посчитанными значениями.
-- Колонку с долей заказов каждой категории назовите orders_share. Значения в полученном столбце 
-- округлите до двух знаков после запятой. В результат также включите количество заказов в группах, 
-- посчитанное на предыдущем шаге. В расчётах по-прежнему учитывайте только неотменённые заказы.
-- Результат отсортируйте сначала по возрастанию даты, затем по возрастанию значений в колонке с 
-- типом заказа. Поля в результирующей таблице: date, order_type, orders_count, orders_share
SELECT date, order_type,
COUNT(order_type) as orders_count,
ROUND(COUNT(order_type)::DECIMAL/SUM(COUNT(order_type)) OVER(PARTITION BY date), 2) as orders_share
FROM
(SELECT user_id, order_id, time::DATE as date,
CASE 
WHEN MIN(time) OVER(PARTITION BY user_id) = time THEN 'Первый' ELSE 'Повторный' END AS order_type
FROM user_actions
WHERE order_id NOT IN (SELECT order_id FROM user_actions WHERE action = 'cancel_order')) q1
GROUP BY date, order_type
ORDER BY date, order_type
-- Задание 12:
-- Примените оконную функцию к таблице products и с помощью агрегирующей функции в отдельной колонке
-- для каждой записи проставьте среднюю цену всех товаров. Колонку с этим значением назовите 
-- avg_price. Затем с помощью оконной функции и оператора FILTER в отдельной колонке рассчитайте
-- среднюю цену товаров без учёта самого дорогого. Колонку с этим средним значением назовите 
-- avg_price_filtered. Полученные средние значения в колонках avg_price и avg_price_filtered 
-- округлите до двух знаков после запятой. Выведите всю информацию о товарах, включая значения
-- в новых колонках. Результат отсортируйте сначала по убыванию цены товара, затем по возрастанию 
-- id товара. Поля в результирующей таблице: product_id, name, price, avg_price, avg_price_filtered
SELECT product_id, name, price,
ROUND(AVG(price) OVER(), 2) as avg_price,
ROUND(AVG(price) FILTER (WHERE price != (SELECT MAX(price) FROM products)) OVER(), 2) as avg_price_filtered
FROM products
ORDER BY price DESC, product_id
-- Задание 13:
-- Для каждой записи в таблице user_actions с помощью оконных функций и предложения FILTER посчитайте,
-- сколько заказов сделал и сколько отменил каждый пользователь на момент совершения нового действия.
-- Иными словами, для каждого пользователя в каждый момент времени посчитайте две накопительные 
-- суммы — числа оформленных и числа отменённых заказов. Если пользователь оформляет заказ, 
-- то число оформленных им заказов увеличивайте на 1, если отменяет — увеличивайте на 1 количество 
-- отмен. Колонки с накопительными суммами числа оформленных и отменённых заказов назовите 
-- соответственно created_orders и canceled_orders. На основе этих двух колонок для каждой 
-- записи пользователя посчитайте показатель cancel_rate, т.е. долю отменённых заказов в общем 
-- количестве оформленных заказов. Значения показателя округлите до двух знаков после запятой. 
-- Колонку с ним назовите cancel_rate. В результате у вас должны получиться три новые колонки 
-- с динамическими показателями, которые изменяются во времени с каждым новым действием пользователя.
-- В результирующей таблице отразите все колонки из исходной таблицы вместе с новыми колонками. 
-- Отсортируйте результат по колонкам user_id, order_id, time — по возрастанию значений в каждой.
-- Добавьте в запрос оператор LIMIT и выведите только первые 1000 строк результирующей таблицы.
-- Поля в результирующей таблице:
-- user_id, order_id, action, time, created_orders, canceled_orders, cancel_rate
SELECT user_id, order_id, action, time, created_orders, canceled_orders,
ROUND(canceled_orders::DECIMAL/created_orders, 2) as cancel_rate
FROM
(SELECT user_id, order_id, action, time,
COUNT(order_id) FILTER (WHERE action = 'create_order') OVER(PARTITION BY user_id
                    ORDER BY time 
                    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as created_orders,
COUNT(order_id) FILTER (WHERE action = 'cancel_order') OVER(PARTITION BY user_id
                    ORDER BY time 
                    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as canceled_orders
FROM user_actions) q1
ORDER BY user_id, order_id, time
LIMIT 1000
-- Задание 14:
-- Из таблицы courier_actions отберите топ 10% курьеров по количеству доставленных за всё время 
-- заказов. Выведите id курьеров, количество доставленных заказов и порядковый номер курьера в 
-- соответствии с числом доставленных заказов. У курьера, доставившего наибольшее число заказов,
-- порядковый номер должен быть равен 1, а у курьера с наименьшим числом заказов — числу, равному 
-- десяти процентам от общего количества курьеров в таблице courier_actions.
-- При расчёте номера последнего курьера округляйте значение до целого числа.
-- Колонки с количеством доставленных заказов и порядковым номером назовите соответственно 
-- orders_count и courier_rank. Результат отсортируйте по возрастанию порядкового номера курьера.
-- Поля в результирующей таблице: courier_id, orders_count, courier_rank 
SELECT courier_id, orders_count, courier_rank
FROM
(SELECT courier_id, COUNT(order_id) as orders_count,
ROW_NUMBER() OVER(ORDER BY COUNT(order_id) DESC, courier_id) as courier_rank,
NTILE(10) OVER(ORDER BY COUNT(order_id) DESC, courier_id) as decile
FROM courier_actions
WHERE action = 'deliver_order'
GROUP BY courier_id) q1
WHERE decile = 1
ORDER BY courier_rank
-- Задание 15:
-- С помощью оконной функции отберите из таблицы courier_actions всех курьеров, которые работают в
-- нашей компании 10 и более дней. Также рассчитайте, сколько заказов они уже успели доставить за всё
-- время работы. Будем считать, что наш сервис предлагает самые выгодные условия труда и поэтому
-- за весь анализируемый период ни один курьер не уволился из компании. Возможные перерывы между 
-- сменами не учитывайте — для нас важна только разница во времени между первым действием курьера 
-- и текущей отметкой времени. Текущей отметкой времени, относительно которой необходимо рассчитывать
-- продолжительность работы курьера, считайте время последнего действия в таблице courier_actions. 
-- Учитывайте только целые дни, прошедшие с момента первого выхода курьера на работу (часы и минуты 
-- не учитывайте). В результат включите три колонки: id курьера, продолжительность работы в днях 
-- и число доставленных заказов. Две новые колонки назовите соответственно days_employed и 
-- delivered_orders. Результат отсортируйте сначала по убыванию количества отработанных дней, 
-- затем по возрастанию id курьера.
-- Поля в результирующей таблице: courier_id, days_employed, delivered_orders 
SELECT courier_id, days_employed, delivered_orders
FROM
(SELECT DISTINCT courier_id, 
MAX(time) OVER()::DATE - MIN(time) OVER(PARTITION BY courier_id)::DATE as days_employed,
COUNT(order_id) FILTER (WHERE action = 'deliver_order') OVER(PARTITION BY courier_id) as delivered_orders
FROM courier_actions) q1
WHERE days_employed >= 10
ORDER BY days_employed DESC, courier_id
-- Задание 16:
-- На основе информации в таблицах orders и products рассчитайте стоимость каждого заказа, ежедневную
-- выручку сервиса и долю стоимости каждого заказа в ежедневной выручке, выраженную в процентах. 
-- В результат включите следующие колонки: id заказа, время создания заказа, стоимость заказа, выручку
-- за день, в который был совершён заказ, а также долю стоимости заказа в выручке за день, выраженную в
-- процентах.При расчёте долей округляйте их до трёх знаков после запятой.
-- Результат отсортируйте сначала по убыванию даты совершения заказа (именно даты, а не времени),
-- потом по убыванию доли заказа в выручке за день, затем по возрастанию id заказа.
-- При проведении расчётов отменённые заказы не учитывайте.
-- Поля в результирующей таблице:
-- order_id, creation_time, order_price, daily_revenue, percentage_of_daily_revenue
WITH product_table AS (
SELECT order_id, creation_time,
UNNEST(product_ids) as product_id
FROM orders
)
SELECT order_id, creation_time, order_price, daily_revenue, percentage_of_daily_revenue
FROM
(SELECT DISTINCT pt.order_id, pt.creation_time,
SUM(p.price) OVER(PARTITION BY pt.order_id) as order_price,
SUM(p.price) OVER(PARTITION BY pt.creation_time::DATE) as daily_revenue,
ROUND(100 * SUM(p.price) OVER(PARTITION BY pt.order_id)::DECIMAL / 
        SUM(p.price) OVER(PARTITION BY pt.creation_time::DATE), 3) as percentage_of_daily_revenue
FROM product_table pt
LEFT JOIN products p
ON pt.product_id = p.product_id
WHERE order_id NOT IN (SELECT order_id FROM user_actions WHERE action = 'cancel_order')) q1
ORDER BY creation_time::DATE DESC, percentage_of_daily_revenue DESC, order_id
-- Задание 17:
-- На основе информации в таблицах orders и products рассчитайте ежедневную выручку сервиса и отразите
-- её в колонке daily_revenue. Затем с помощью оконных функций и функций смещения посчитайте ежедневный
-- прирост выручки. Прирост выручки отразите как в абсолютных значениях, так и в % относительно 
-- предыдущего дня. Колонку с абсолютным приростом назовите revenue_growth_abs, а колонку с относительным
-- — revenue_growth_percentage. Для самого первого дня укажите прирост равным 0 в обеих колонках. 
-- При проведении расчётов отменённые заказы не учитывайте. Результат отсортируйте по колонке с 
-- датами по возрастанию. Метрики daily_revenue, revenue_growth_abs, revenue_growth_percentage 
-- округлите до одного знака при помощи ROUND().
-- Поля в результирующей таблице: date, daily_revenue, revenue_growth_abs, revenue_growth_percentage
WITH orders_with_p_id AS (
SELECT creation_time, order_id, UNNEST(product_ids) as product_id
FROM orders
WHERE order_id NOT IN (SELECT order_id FROM user_actions WHERE action = 'cancel_order')
), dedupted AS (
SELECT DISTINCT creation_time::DATE as date,
SUM(p.price) OVER(PARTITION BY creation_time::DATE) as daily_revenue
FROM orders_with_p_id o
LEFT JOIN products p 
ON o.product_id = p.product_id)

SELECT *,
ROUND(COALESCE(revenue_growth_abs * 100 / LAG(daily_revenue, 1) OVER(), 0), 1) as revenue_growth_percentage
FROM
(SELECT date, daily_revenue,
ROUND(COALESCE(daily_revenue - LAG(daily_revenue, 1) OVER(), 0), 1) as revenue_growth_abs
FROM dedupted) t1
ORDER BY date
-- Задание 18:
-- С помощью оконной функции рассчитайте медианную стоимость всех заказов из таблицы orders, оформленных
-- в нашем сервисе. В качестве результата выведите одно число. Колонку с ним назовите median_price. 
-- Отменённые заказы не учитывайте. Поле в результирующей таблице: median_price
WITH 
main_table AS (SELECT order_id, SUM (price) AS order_price, ROW_NUMBER () OVER (ORDER BY SUM (price)) AS row_number
               FROM (SELECT order_id, unnest(product_ids) as product_id
                     FROM orders
                     WHERE  order_id not in (SELECT order_id
                                             FROM   user_actions
                                             WHERE  action = 'cancel_order')) t1
               LEFT JOIN products using (product_id)
               GROUP BY order_id
),
first_50 AS (SELECT order_price, row_number
             FROM main_table
             LIMIT (SELECT MAX(row_number)/2
                    FROM main_table)
),
last_50 AS (SELECT order_price, row_number
            FROM main_table
            OFFSET (SELECT MAX(row_number)/2
                    FROM main_table)
)

SELECT CASE
       WHEN MOD(MAX (row_number), 2) = 0 THEN ((SELECT MAX(order_price) FROM first_50) + (SELECT MIN(order_price) FROM last_50))/2
       ELSE (SELECT MAX(order_price) FROM main_table WHERE row_number = (SELECT MAX (row_number)/2+1 FROM main_table))
       END AS median_price
FROM main_table;
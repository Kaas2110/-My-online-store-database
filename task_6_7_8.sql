-- Скрипт группировки
# Группировка покупателей по колличеству совершенных покупок c 2013 года (в своей таблице я внес коррективы в столбец total 
# код на них разместил в конце
SELECT 
	count(id) AS number_of_users, total 
FROM 
	orders_products
WHERE 
	created_at > '2013-00-00'
GROUP BY 
	total
ORDER BY 
	total;
	-- Выведите список товаров products и разделов catalogs c номерами заказов
SELECT 
	p.id, p.name, c.id, c.name, p.price, op.order_id 
FROM 
	products AS p
LEFT JOIN
	catalogs as c 
ON
	p.catalog_id = c.id
	LEFT JOIN 
	orders_products AS op
	ON
op.product_id = p.id ;
-- сортируем совершеннолетних пользователей по скидке, для этого делаем двойной вложенный запрос
SELECT 
	user_id, discount 
FROM 
	discounts 
WHERE 
user_id IN (SELECT id FROM users WHERE id IN (SELECT user_id FROM profiles WHERE (birthday + interval 18 year) > now()))
ORDER BY 
	discount desc ;
-- Делаем представления
CREATE VIEW 
	products_view (name, description, price) AS
SELECT 
	name, desription, price 
FROM 
	products;

CREATE OR REPLACE VIEW
	products_catalogs_view (name, description, c_id, price, store_h_p) AS
SELECT 
	p.name, p.desription, c.id, p.price, sp.storehouse_id 
FROM 
	products AS p
JOIN 
	catalogs AS c
ON 
	p.catalog_id = c.id 
JOIN 
	storehouses_products AS sp
ON 
	sp.product_id = p.id
ORDER BY 
	c.id ;

-- Хранимые процедуры и триггеры
# создаем процедуру просмотра последних 100 заказов интернет-мазагина
DROP PROCEDURE IF EXISTS select_request;
delimiter $$
CREATE PROCEDURE select_request()

BEGIN 
	START TRANSACTION;
	SELECT
		id, order_id , product_id, created_at
	FROM 
		orders_products 
	ORDER BY 
		id 
	DESC
	LIMIT 
		100;
END $$
delimiter ;

CALL select_request;

# Создаем триггер
-- создаем в таблице юзерс колонку для подсчета количества покупок пользователей
ALTER TABLE users ADD COLUMN purchase_count 
bigint unsigned	DEFAULT 0;		


DROP TRIGGER IF EXISTS count_user_shopping;

delimiter $$ 
CREATE TRIGGER count_user_shopping BEFORE INSERT ON project.delivery
FOR EACH ROW 
BEGIN 
UPDATE users 
SET 
	purchase_count = purchase_count + 1
WHERE
	users.id = (SELECT user_address_id FROM delivery) ;
END $$
delimiter ;

INSERT INTO project.delivery
(id, user_address_id, orders_products_id, city_id, address_1, address_2, postal_code, delivery_min, delivery_max, last_update)
VALUES(112, 1, 1, 1, NULL, NULL, 'eboy', '2015-11-27', '1999-11-18', '2004-03-25 13:11:15');

	





/*INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(1, 1, 1, 6, '1975-04-30 09:49:26', '2021-04-03 12:07:29');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(2, 2, 2, 6, '2019-01-13 07:32:26', '2021-04-03 12:07:29');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(3, 3, 3, 6, '1973-03-23 02:24:00', '2021-04-03 12:07:29');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(4, 4, 4, 6, '1973-12-22 20:19:38', '2021-04-03 12:07:29');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(5, 5, 5, 6, '1983-02-26 02:49:37', '2021-04-03 12:07:29');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(6, 6, 6, 6, '1988-09-18 06:18:53', '2021-04-03 12:07:29');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(7, 7, 7, 6, '2008-06-27 09:57:31', '2021-04-03 12:07:29');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(8, 8, 8, 6, '2007-01-05 04:42:26', '2021-04-03 12:07:29');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(9, 9, 9, 6, '1972-07-23 02:55:33', '2021-04-03 12:07:29');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(10, 10, 10, 6, '2016-10-10 15:31:53', '2021-04-03 12:07:29');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(11, 11, 11, 6, '1980-06-25 17:57:03', '2021-04-03 12:07:29');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(12, 12, 12, 6, '1983-03-17 12:49:17', '2021-04-03 12:07:29');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(13, 13, 13, 6, '1999-10-12 21:49:45', '2021-04-03 12:07:29');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(14, 14, 14, 6, '1978-04-07 02:42:25', '2021-04-03 12:07:29');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(15, 15, 15, 6, '1992-01-31 21:45:56', '2021-04-03 12:07:29');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(16, 16, 16, 6, '2002-06-30 23:00:37', '2021-04-03 12:07:29');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(17, 17, 17, 6, '1975-08-13 19:22:38', '2021-04-03 12:07:29');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(18, 18, 18, 6, '2006-08-19 13:39:47', '2021-04-03 12:07:29');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(19, 19, 19, 6, '2020-05-19 05:14:08', '2021-04-03 12:07:29');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(20, 20, 20, 6, '1997-05-27 15:50:38', '2021-04-03 12:07:29');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(21, 21, 21, 6, '1998-12-08 20:11:18', '2021-04-03 12:07:29');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(22, 22, 22, 6, '2013-12-06 11:35:40', '2021-04-03 12:07:29');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(23, 23, 23, 6, '1980-10-01 14:29:03', '2021-04-03 12:07:29');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(24, 24, 24, 6, '1982-11-16 22:48:43', '2021-04-03 12:07:29');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(25, 25, 25, 6, '1970-02-24 01:41:41', '2021-04-03 12:07:29');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(26, 26, 26, 6, '2011-01-13 23:30:15', '2021-04-03 12:07:29');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(27, 27, 27, 1, '1978-05-29 04:59:50', '2017-09-16 06:50:32');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(28, 28, 28, 1, '1982-12-20 11:26:45', '1979-09-18 16:26:58');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(29, 29, 29, 1, '1982-12-22 06:32:21', '2012-04-08 20:50:27');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(30, 30, 30, 1, '1990-05-24 09:40:36', '1971-05-02 23:12:59');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(31, 31, 31, 1, '2011-04-09 00:26:20', '1992-04-13 18:51:22');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(32, 32, 32, 1, '1975-01-27 13:55:40', '2008-07-11 20:38:30');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(33, 33, 33, 1, '2008-12-21 14:51:46', '2018-03-13 01:20:45');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(34, 34, 34, 1, '2011-06-02 13:00:39', '2021-01-20 07:50:13');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(35, 35, 35, 7, '2006-08-25 06:46:59', '2021-04-03 12:08:18');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(36, 36, 36, 1, '1986-09-08 19:22:19', '1981-10-16 06:37:37');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(37, 37, 37, 1, '1997-04-02 11:12:40', '2013-11-04 09:16:24');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(38, 38, 38, 1, '1996-03-29 01:35:36', '2009-11-30 21:28:33');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(39, 39, 39, 6, '1995-03-30 23:22:41', '2021-04-03 12:08:18');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(40, 40, 40, 8, '2008-08-03 04:24:34', '2021-04-03 12:08:18');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(41, 41, 41, 1, '1996-10-27 12:57:43', '2014-10-18 03:47:54');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(42, 42, 42, 1, '1983-04-26 07:00:00', '1987-09-20 13:30:00');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(43, 43, 43, 1, '2006-07-31 07:29:11', '1974-11-25 01:21:46');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(44, 44, 44, 8, '1977-04-09 15:22:54', '2021-04-03 12:07:33');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(45, 45, 45, 1, '2012-12-20 05:08:34', '2014-07-07 16:56:34');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(46, 46, 46, 1, '2002-12-11 03:54:45', '1972-10-16 17:21:51');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(47, 47, 47, 1, '2002-12-16 05:43:56', '2011-06-30 02:17:02');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(48, 48, 48, 1, '2015-08-28 16:33:50', '1994-06-29 12:45:41');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(49, 49, 49, 1, '1974-06-15 16:19:44', '2002-03-23 20:01:03');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(50, 50, 50, 1, '2016-11-07 00:02:19', '1977-03-13 10:01:56');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(51, 51, 51, 1, '2012-05-25 04:08:54', '1972-03-11 15:56:07');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(52, 52, 52, 1, '1999-02-06 22:13:41', '1973-07-04 02:54:02');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(53, 53, 53, 1, '2002-04-24 14:53:51', '1992-03-17 09:09:11');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(54, 54, 54, 1, '2007-04-21 16:45:24', '2005-10-26 21:06:37');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(55, 55, 55, 1, '1983-07-19 11:36:36', '1971-11-07 16:35:58');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(56, 56, 56, 1, '1985-06-17 20:36:50', '1985-03-27 09:12:17');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(57, 57, 57, 1, '2011-08-01 00:05:44', '2007-06-18 18:24:52');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(58, 58, 58, 1, '1972-10-09 08:30:00', '1984-11-09 04:05:46');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(59, 59, 59, 1, '2015-02-17 21:06:38', '2014-05-19 16:26:02');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(60, 60, 60, 1, '2011-02-03 11:35:04', '1991-06-28 16:53:21');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(61, 61, 61, 1, '1975-10-10 09:27:45', '1991-03-02 02:45:58');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(62, 62, 62, 1, '1993-08-01 07:46:13', '2010-02-03 22:45:49');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(63, 63, 63, 1, '2020-04-09 20:16:42', '2011-02-05 09:39:58');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(64, 64, 64, 1, '2018-06-14 18:44:08', '1985-02-27 07:45:43');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(65, 65, 65, 1, '1989-04-13 11:46:35', '2019-09-22 20:48:02');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(66, 66, 66, 1, '1995-11-18 22:40:18', '1979-01-30 07:26:56');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(67, 67, 67, 1, '1993-03-09 04:13:42', '1998-07-01 22:42:57');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(68, 68, 68, 1, '2011-05-17 16:48:46', '1979-03-25 07:47:32');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(69, 69, 69, 1, '1988-04-27 14:36:34', '1984-05-01 13:33:15');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(70, 70, 70, 1, '1984-07-08 14:37:16', '2005-10-09 16:49:57');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(71, 71, 71, 1, '1979-04-04 14:23:13', '1983-10-15 18:30:45');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(72, 72, 72, 1, '1978-07-18 12:39:35', '1979-12-31 19:57:43');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(73, 73, 73, 1, '1994-09-13 04:07:49', '1995-06-02 00:13:07');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(74, 74, 74, 1, '1992-12-20 12:01:37', '2018-10-17 04:18:42');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(75, 75, 75, 1, '2003-10-26 06:44:56', '1986-03-25 13:21:59');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(76, 76, 76, 1, '1981-11-18 01:37:35', '1993-07-12 05:06:09');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(77, 77, 77, 1, '1982-06-08 07:40:52', '2013-04-22 23:58:29');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(78, 78, 78, 1, '1976-11-19 14:33:55', '1999-07-27 02:11:17');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(79, 79, 79, 1, '1989-06-25 01:11:50', '2020-07-15 07:45:19');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(80, 80, 80, 1, '1993-06-21 22:21:08', '2020-07-08 20:38:13');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(81, 81, 81, 1, '1985-12-10 12:41:37', '2008-08-29 18:15:23');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(82, 82, 82, 1, '1987-03-04 15:19:57', '1994-06-18 12:25:35');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(83, 83, 83, 1, '2009-06-21 04:26:06', '2016-04-12 07:22:14');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(84, 84, 84, 1, '1986-02-28 22:03:54', '1997-05-29 21:56:57');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(85, 85, 85, 1, '1989-09-19 21:09:25', '1975-09-25 00:33:32');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(86, 86, 86, 1, '2018-11-25 09:57:42', '1990-05-21 18:03:25');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(87, 87, 87, 1, '1987-07-19 10:09:28', '2015-09-23 21:49:13');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(88, 88, 88, 1, '2010-01-11 22:15:32', '2000-11-02 23:52:21');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(89, 89, 89, 1, '1977-07-11 18:23:38', '2004-05-19 04:36:31');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(90, 90, 90, 1, '1992-09-04 21:19:03', '1991-07-20 01:58:54');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(91, 91, 91, 1, '2011-01-08 10:49:56', '2013-03-12 17:39:55');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(92, 92, 92, 1, '2016-09-15 12:36:38', '1979-09-13 13:28:16');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(93, 93, 93, 1, '2011-09-22 01:29:16', '1971-04-08 07:17:08');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(94, 94, 94, 1, '1999-05-03 02:20:12', '2018-08-28 19:19:10');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(95, 95, 95, 1, '1987-03-15 22:07:45', '2004-09-22 20:27:31');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(96, 96, 96, 1, '2004-12-19 15:05:50', '1989-03-20 07:32:07');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(97, 97, 97, 1, '2016-08-08 13:23:24', '1979-10-15 10:23:40');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(98, 98, 98, 1, '1997-08-12 00:52:18', '1973-10-26 15:35:35');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(99, 99, 99, 1, '2008-06-29 21:22:11', '1980-02-27 05:10:43');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(100, 100, 100, 1, '2011-02-21 00:04:05', '1974-05-11 15:21:13');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(101, 1, 1, 1, '2000-03-16 04:06:28', '2007-07-19 17:35:48');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(102, 2, 2, 1, '1982-10-26 16:30:01', '1971-11-25 00:46:20');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(103, 3, 3, 1, '2005-12-10 17:26:05', '1989-12-28 13:32:46');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(104, 4, 4, 1, '1980-05-16 12:23:48', '2008-07-07 22:06:22');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(105, 5, 5, 1, '2005-12-15 15:49:52', '1971-04-13 12:51:07');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(106, 6, 6, 1, '1984-06-20 12:20:21', '1990-09-07 08:59:52');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(107, 7, 7, 1, '2012-07-29 05:41:55', '2006-09-05 01:05:05');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(108, 8, 8, 1, '2006-06-30 17:18:34', '1988-12-18 21:30:10');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(109, 9, 9, 1, '1977-03-16 14:36:30', '1988-01-01 05:43:45');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(110, 10, 10, 1, '2009-08-04 02:31:37', '1996-11-28 20:07:26');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(111, 11, 11, 1, '1991-05-16 04:04:07', '2002-02-28 18:05:09');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(112, 12, 12, 1, '1974-09-18 22:08:11', '2016-03-14 11:20:12');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(113, 13, 13, 1, '2010-07-10 18:29:49', '2004-09-19 10:56:29');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(114, 14, 14, 1, '1975-01-15 22:52:20', '1991-08-01 17:13:41');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(115, 15, 15, 1, '1985-05-24 15:37:49', '1977-07-24 12:41:28');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(116, 16, 16, 1, '2008-03-18 12:56:01', '2019-03-22 19:39:26');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(117, 17, 17, 1, '1970-11-22 16:20:20', '2010-11-25 00:08:09');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(118, 18, 18, 1, '2016-04-02 00:33:53', '1995-10-07 17:15:03');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(119, 19, 19, 1, '2012-03-13 18:50:21', '2012-01-12 23:43:51');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(120, 20, 20, 1, '2007-01-03 23:19:26', '1983-11-20 14:14:26');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(121, 21, 21, 1, '1992-04-21 22:44:44', '1992-11-12 14:16:51');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(122, 22, 22, 1, '1979-09-19 16:43:37', '1982-02-22 08:58:30');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(123, 23, 23, 1, '1990-09-20 16:08:24', '1977-07-07 14:07:21');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(124, 24, 24, 1, '1993-12-01 03:04:44', '1986-06-17 13:06:50');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(125, 25, 25, 1, '2001-03-30 22:56:48', '1988-02-15 14:32:35');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(126, 26, 26, 1, '2011-10-04 14:42:19', '2007-02-28 19:38:16');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(127, 27, 27, 1, '1982-09-03 21:24:06', '2014-11-29 10:07:27');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(128, 28, 28, 1, '1979-11-06 18:58:55', '1985-02-09 15:23:23');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(129, 29, 29, 1, '1980-08-18 09:42:55', '1971-06-10 16:02:59');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(130, 30, 30, 1, '1976-01-20 01:16:05', '1988-12-21 04:30:47');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(131, 31, 31, 1, '2001-06-21 05:08:06', '1974-04-10 12:53:23');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(132, 32, 32, 1, '1996-06-12 01:16:17', '1981-11-09 07:12:38');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(133, 33, 33, 1, '2013-01-11 15:00:51', '2014-10-14 19:36:36');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(134, 34, 34, 1, '1989-06-25 11:02:25', '1993-12-05 02:25:24');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(135, 35, 35, 4, '1994-07-07 03:57:29', '2021-04-03 12:08:18');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(136, 36, 36, 1, '2020-08-15 06:57:26', '1972-02-15 19:53:18');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(137, 37, 37, 1, '1975-04-07 15:23:53', '1995-06-18 20:46:31');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(138, 38, 38, 1, '2006-01-14 00:06:42', '2012-10-19 10:38:50');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(139, 39, 39, 1, '1997-03-17 16:21:09', '1996-02-01 01:12:02');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(140, 40, 40, 1, '2006-09-28 04:35:12', '1989-10-26 04:36:28');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(141, 41, 41, 1, '2002-04-07 03:28:58', '2005-11-01 06:49:00');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(142, 42, 42, 1, '1980-06-21 10:18:00', '2013-05-07 01:11:15');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(143, 43, 43, 1, '1982-11-27 19:26:48', '2019-03-13 12:18:53');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(144, 44, 44, 6, '2008-01-03 09:54:33', '2021-04-03 12:08:18');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(145, 45, 45, 1, '1992-03-10 00:11:52', '1985-03-23 09:56:57');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(146, 46, 46, 1, '1974-11-07 08:09:58', '1978-09-11 17:21:47');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(147, 47, 47, 2, '2005-05-04 15:31:22', '2021-04-03 12:07:15');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(148, 48, 48, 2, '2009-07-20 16:40:35', '2021-04-03 12:07:15');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(149, 49, 49, 2, '1994-05-16 04:26:10', '2021-04-03 12:07:15');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(150, 50, 50, 2, '1980-10-29 05:57:28', '2021-04-03 12:07:15');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(151, 51, 51, 2, '2001-02-07 04:42:08', '2021-04-03 12:07:15');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(152, 52, 52, 2, '2011-01-16 20:30:53', '2021-04-03 12:07:15');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(153, 53, 53, 2, '2018-06-22 13:25:11', '2021-04-03 12:07:15');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(154, 54, 54, 2, '1982-09-15 02:11:30', '2021-04-03 12:07:15');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(155, 55, 55, 2, '1984-02-12 12:23:47', '2021-04-03 12:07:15');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(156, 56, 56, 2, '2011-02-27 04:34:49', '2021-04-03 12:07:15');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(157, 57, 57, 2, '1981-04-17 08:03:33', '2021-04-03 12:07:15');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(158, 58, 58, 2, '1978-09-07 11:49:50', '2021-04-03 12:07:15');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(159, 59, 59, 2, '1982-03-18 14:30:13', '2021-04-03 12:07:15');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(160, 60, 60, 2, '2004-08-10 10:39:16', '2021-04-03 12:07:15');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(161, 61, 61, 2, '2000-09-30 07:14:06', '2021-04-03 12:07:15');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(162, 62, 62, 2, '1997-01-27 01:36:05', '2021-04-03 12:07:15');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(163, 63, 63, 2, '2003-03-30 12:47:22', '2021-04-03 12:07:15');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(164, 64, 64, 2, '2000-02-11 04:17:10', '2021-04-03 12:07:15');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(165, 65, 65, 8, '1986-09-01 17:22:05', '2021-04-03 12:08:18');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(166, 66, 66, 2, '2020-08-26 17:34:33', '2021-04-03 12:07:15');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(167, 67, 67, 2, '2016-05-25 02:33:12', '2021-04-03 12:07:15');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(168, 68, 68, 2, '2010-03-09 18:38:47', '2021-04-03 12:07:15');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(169, 69, 69, 2, '1980-11-10 22:20:43', '2021-04-03 12:07:15');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(170, 70, 70, 2, '1986-04-19 01:19:14', '2021-04-03 12:07:15');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(171, 71, 71, 2, '2004-06-23 10:17:13', '2021-04-03 12:07:15');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(172, 72, 72, 2, '1995-03-20 12:08:08', '2021-04-03 12:07:15');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(173, 73, 73, 2, '1974-01-30 21:23:12', '2021-04-03 12:07:15');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(174, 74, 74, 2, '2002-06-04 12:31:07', '2021-04-03 12:07:15');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(175, 75, 75, 2, '2012-02-17 13:01:47', '2021-04-03 12:07:15');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(176, 76, 76, 2, '1983-09-10 08:39:44', '2021-04-03 12:07:15');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(177, 77, 77, 2, '2003-07-06 12:08:38', '2021-04-03 12:07:15');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(178, 78, 78, 2, '1983-09-07 04:07:39', '2021-04-03 12:07:15');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(179, 79, 79, 1, '2003-04-09 04:11:03', '2013-08-21 06:18:34');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(180, 80, 80, 1, '2018-08-24 17:05:25', '1978-03-09 08:30:30');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(181, 81, 81, 1, '2011-03-11 09:54:05', '1980-11-25 13:51:36');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(182, 82, 82, 1, '2003-01-26 00:56:47', '1990-07-24 12:58:24');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(183, 83, 83, 1, '2015-04-20 23:30:05', '1994-07-31 12:58:26');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(184, 84, 84, 1, '2015-05-29 11:25:02', '1973-11-06 07:23:48');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(185, 85, 85, 1, '1995-01-07 05:05:46', '2016-03-28 22:13:34');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(186, 86, 86, 5, '1996-09-20 15:12:35', '2021-04-03 12:07:15');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(187, 87, 87, 5, '1984-02-19 07:03:52', '2021-04-03 12:07:15');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(188, 88, 88, 5, '2000-02-29 22:53:08', '2021-04-03 12:07:15');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(189, 89, 89, 5, '2012-01-26 11:05:46', '2021-04-03 12:07:15');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(190, 90, 90, 5, '2016-02-03 11:23:50', '2021-04-03 12:07:15');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(191, 91, 91, 5, '1981-05-14 22:21:35', '2021-04-03 12:07:15');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(192, 92, 92, 5, '2007-06-21 03:59:18', '2021-04-03 12:07:15');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(193, 93, 93, 5, '1984-05-04 13:19:16', '2021-04-03 12:07:15');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(194, 94, 94, 5, '1997-10-26 16:59:59', '2021-04-03 12:07:15');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(195, 95, 95, 1, '1971-05-28 19:50:13', '2018-07-01 07:19:28');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(196, 96, 96, 1, '1999-08-24 10:33:11', '1975-11-15 06:36:24');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(197, 97, 97, 1, '1984-03-22 08:52:24', '2017-11-26 13:59:08');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(198, 98, 98, 1, '2004-07-02 17:37:10', '1983-10-31 09:13:15');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(199, 99, 99, 1, '1994-01-11 02:29:35', '1993-07-17 14:33:09');
INSERT INTO project.orders_products
(id, order_id, product_id, total, created_at, update_at)
VALUES(200, 100, 100, 1, '2007-08-18 02:48:04', '1972-07-18 12:16:46');

INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(1, 3, 'doloribus', 'No, no! You''re a serpent; and there''s no use in knocking,'' said the King; ''and don''t look at all this time, sat down in an offended tone, ''so I can''t see you?'' She was a queer-shaped little.', 105238793.43, '2011-12-20 03:51:06', '2021-04-03 12:48:57');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(2, 3, 'est', 'Alice went on in the sea, some children digging in the sea, ''and in that case I can creep under the table: she opened the door as you can--'' ''Swim after them!'' screamed the Pigeon. ''I''m NOT a.', 9027733.00, '1987-04-11 15:05:29', '2021-04-03 12:48:57');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(3, 3, 'eum', 'Down, down, down. There was not a moment that it was only too glad to do with you. Mind now!'' The poor little thing howled so, that he shook both his shoes off. ''Give your evidence,'' said the Mock.', 440088020.67, '2018-01-30 00:54:20', '2021-04-03 12:48:57');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(4, 3, 'optio', 'Pigeon; ''but I know who I WAS when I get it home?'' when it grunted again, and looking anxiously about her. ''Oh, do let me help to undo it!'' ''I shall be a walrus or hippopotamus, but then she walked.', 152.38, '1991-11-18 21:11:03', '2021-04-03 12:48:57');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(5, 3, 'reprehenderit', 'Alice, a good opportunity for making her escape; so she began very cautiously: ''But I don''t know,'' he went on, very much to-night, I should think!'' (Dinah was the Duchess''s voice died away, even in.', 62020233.00, '1988-02-13 12:22:28', '2021-04-03 12:48:57');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(6, 3, 'eum', 'Hatter. ''Does YOUR watch tell you his history,'' As they walked off together. Alice laughed so much at first, perhaps,'' said the others. ''Are their heads downward! The Antipathies, I think--'' (she.', 25881.27, '2018-05-03 01:15:43', '2021-04-03 12:48:57');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(7, 3, 'eaque', 'Pigeon had finished. ''As if I would talk on such a puzzled expression that she was considering in her hands, and began:-- ''You are old,'' said the Gryphon. ''It all came different!'' the Mock Turtle..', 23874330.30, '1993-03-02 01:51:36', '2021-04-03 12:48:57');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(8, 3, 'culpa', 'Dodo, a Lory and an old Turtle--we used to know. Let me see: four times seven is--oh dear! I wish I hadn''t cried so much!'' said Alice, in a trembling voice:-- ''I passed by his garden, and I shall.', 6430.97, '1980-06-09 04:28:32', '2021-04-03 12:48:57');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(9, 2, 'impedit', 'Knave was standing before them, in chains, with a deep voice, ''are done with blacking, I believe.'' ''Boots and shoes under the sea,'' the Gryphon went on again:-- ''You may not have lived much under.', 0.00, '2001-08-29 07:17:39', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(10, 2, 'vel', 'Lacie, and Tillie; and they sat down, and felt quite strange at first; but she did not like to try the thing Mock Turtle sighed deeply, and began, in rather a complaining tone, ''and they all spoke.', 3429.27, '1970-08-10 13:17:27', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(11, 2, 'reprehenderit', 'HE went mad, you know--'' ''What did they live at the mushroom for a rabbit! I suppose it doesn''t matter a bit,'' she thought it would,'' said the Lory, as soon as she added, ''and the moral of that dark.', 195.24, '1994-01-05 20:04:12', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(12, 2, 'vero', 'Alice: ''allow me to him: She gave me a good deal worse off than before, as the other.'' As soon as it happens; and if I was, I shouldn''t like THAT!'' ''Oh, you can''t take more.'' ''You mean you can''t.', 44259.75, '2010-02-10 00:54:59', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(13, 2, 'autem', 'White Rabbit read:-- ''They told me he was obliged to say "HOW DOTH THE LITTLE BUSY BEE," but it did not come the same thing,'' said the Cat, ''if you only kept on puzzling about it while the Mock.', 464.01, '1992-11-10 21:18:53', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(14, 2, 'quidem', 'I don''t keep the same tone, exactly as if she had never been in a great hurry to change the subject. ''Ten hours the first really clever thing the King say in a shrill, loud voice, and see how he can.', 18556.10, '2010-03-22 11:05:50', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(15, 2, 'enim', 'How puzzling all these strange Adventures of hers would, in the window, and on it were white, but there was the first witness,'' said the Hatter: ''I''m on the shingle--will you come and join the.', 1185303.28, '1987-10-22 14:01:56', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(16, 2, 'sit', 'COULD! I''m sure she''s the best thing to eat the comfits: this caused some noise and confusion, as the White Rabbit as he said to herself, and shouted out, ''You''d better not do that again!'' which.', 40.87, '1992-07-16 03:34:43', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(17, 2, 'nemo', 'Alice put down yet, before the trial''s begun.'' ''They''re putting down their names,'' the Gryphon in an offended tone. And the Gryphon never learnt it.'' ''Hadn''t time,'' said the cook. The King turned.', 58888.35, '1983-10-15 13:06:38', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(18, 2, 'culpa', 'I wish you wouldn''t squeeze so.'' said the Hatter: ''but you could draw treacle out of the players to be two people. ''But it''s no use in saying anything more till the puppy''s bark sounded quite faint.', 125673556.38, '2012-11-15 23:52:54', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(19, 2, 'vero', 'Alice put down yet, before the end of the bread-and-butter. Just at this moment the door and found that her flamingo was gone across to the King, ''that only makes the matter worse. You MUST have.', 2.26, '1989-02-23 05:07:29', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(20, 2, 'excepturi', 'King exclaimed, turning to Alice: he had come to an end! ''I wonder how many miles I''ve fallen by this time). ''Don''t grunt,'' said Alice; ''that''s not at all the while, and fighting for the hot day.', 700118.20, '1978-09-18 21:25:56', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(21, 2, 'omnis', 'Cat again, sitting on the bank, and of having the sentence first!'' ''Hold your tongue, Ma!'' said the Hatter: ''let''s all move one place on.'' He moved on as he found it advisable--"'' ''Found WHAT?'' said.', 0.00, '1983-02-27 00:22:13', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(22, 2, 'saepe', 'I think I must have a trial: For really this morning I''ve nothing to do: once or twice, and shook itself. Then it got down off the cake. * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *.', 38211398.60, '2006-10-10 11:07:04', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(23, 2, 'nisi', 'I should be raving mad after all! I almost wish I''d gone to see that she wasn''t a really good school,'' said the Lory. Alice replied in a court of justice before, but she could not be denied, so she.', 806204141.99, '2004-09-26 16:51:04', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(24, 2, 'quos', 'Caterpillar. ''Well, perhaps not,'' said Alice to herself. ''Of the mushroom,'' said the King, rubbing his hands; ''so now let the jury--'' ''If any one of these cakes,'' she thought, ''and hand round the.', 49.40, '2018-04-11 22:36:51', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(25, 2, 'sed', 'She was looking for eggs, as it happens; and if I fell off the subjects on his knee, and the other side will make you grow taller, and the other side, the puppy began a series of short charges at.', 19210.24, '1984-01-13 20:25:43', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(26, 2, 'ut', 'I''ll be jury," Said cunning old Fury: "I''ll try the effect: the next question is, what did the Dormouse said--'' the Hatter asked triumphantly. Alice did not get dry very soon. ''Ahem!'' said the.', 7518824.97, '2018-12-30 05:50:01', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(27, 2, 'necessitatibus', 'YOU?'' said the young lady to see that she had found the fan and two or three of her sharp little chin. ''I''ve a right to think,'' said Alice aloud, addressing nobody in particular. ''She''d soon fetch.', 0.00, '2007-04-28 22:39:43', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(28, 2, 'voluptatum', 'CHAPTER VIII. The Queen''s argument was, that anything that looked like the name: however, it only grinned when it grunted again, and said, ''It WAS a narrow escape!'' said Alice, very much to-night, I.', 230040786.95, '1989-10-22 14:42:44', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(29, 2, 'quae', 'After a while, finding that nothing more to be a book of rules for shutting people up like a writing-desk?'' ''Come, we shall get on better.'' ''I''d rather finish my tea,'' said the Hatter. ''You might.', 0.00, '1983-10-05 15:59:05', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(30, 4, 'voluptates', 'Bill, the Lizard) could not think of nothing else to do, and perhaps after all it might appear to others that what you would have done just as well as if she meant to take MORE than nothing.''.', 344651.24, '1974-04-07 16:23:57', '2021-04-03 12:49:01');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(31, 4, 'minus', 'Allow me to him: She gave me a pair of gloves and a pair of boots every Christmas.'' And she kept on good terms with him, he''d do almost anything you liked with the Lory, who at last it sat down.', 6.98, '1975-09-14 22:42:09', '2021-04-03 12:49:01');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(32, 4, 'distinctio', 'She did not like to drop the jar for fear of killing somebody, so managed to swallow a morsel of the pack, she could for sneezing. There was nothing on it except a little of it?'' said the Gryphon:.', 15846.16, '2005-03-02 02:12:26', '2021-04-03 12:49:01');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(33, 4, 'velit', 'Queen. ''You make me larger, it must be growing small again.'' She got up and said, ''So you think you can find them.'' As she said to herself, ''it would be very likely it can talk: at any rate,'' said.', 5.00, '2007-09-11 03:52:49', '2021-04-03 12:49:01');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(34, 4, 'tempora', 'So you see, Miss, this here ought to be done, I wonder?'' Alice guessed who it was, and, as a boon, Was kindly permitted to pocket the spoon: While the Duchess began in a sort of people live about.', 1417168.27, '1989-03-30 13:55:14', '2021-04-03 12:49:01');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(35, 4, 'voluptas', 'Like a tea-tray in the middle, being held up by a very difficult question. However, at last came a little door was shut again, and that''s very like having a game of croquet she was talking. ''How CAN.', 120.80, '2002-09-20 07:05:35', '2021-04-03 12:49:01');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(36, 4, 'et', 'King, the Queen, who was beginning to end,'' said the Duchess: ''what a clear way you go,'' said the Hatter: ''I''m on the second thing is to France-- Then turn not pale, beloved snail, but come and join.', 5144276.15, '1985-03-04 10:57:40', '2021-04-03 12:49:01');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(37, 4, 'consequatur', 'Dormouse denied nothing, being fast asleep. ''After that,'' continued the Pigeon, raising its voice to a day-school, too,'' said Alice; ''it''s laid for a few yards off. The Cat only grinned when it had.', 420890.85, '2010-06-16 12:52:02', '2021-04-03 12:49:01');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(38, 4, 'praesentium', 'Alice! when she was always ready to make out that it might happen any minute, ''and then,'' thought Alice, ''or perhaps they won''t walk the way YOU manage?'' Alice asked. The Hatter shook his head.', 10370.75, '2009-09-18 13:11:19', '2021-04-03 12:49:01');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(39, 4, 'magnam', 'Dormouse!'' And they pinched it on both sides of the lefthand bit. * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ''Come, my head''s free at last!'' said Alice.', 933.00, '2017-11-16 23:55:36', '2021-04-03 12:49:01');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(40, 4, 'similique', 'Alice; ''I might as well say that "I see what the next witness.'' And he added in a low curtain she had but to her great disappointment it was only sobbing,'' she thought, ''it''s sure to kill it in less.', 330069631.99, '1976-08-04 05:08:55', '2021-04-03 12:49:01');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(41, 4, 'nisi', 'Hatter hurriedly left the court, without even waiting to put it more clearly,'' Alice replied in an encouraging tone. Alice looked at her, and she sat still and said nothing. ''When we were little,''.', 0.00, '2001-01-04 04:54:42', '2021-04-03 12:49:01');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(42, 4, 'ut', 'VERY deeply with a sigh: ''it''s always tea-time, and we''ve no time to begin with.'' ''A barrowful will do, to begin with,'' said the March Hare, who had been looking at them with large eyes like a.', 139546.36, '1991-02-12 21:19:50', '2021-04-03 12:49:01');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(43, 4, 'fugit', 'Alice, and, after waiting till she fancied she heard was a little before she gave a little of the ground.'' So she began thinking over other children she knew, who might do something better with the.', 425.83, '2017-03-07 06:31:52', '2021-04-03 12:49:01');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(44, 4, 'sit', 'Prizes!'' Alice had learnt several things of this was his first speech. ''You should learn not to her, ''if we had the door opened inwards, and Alice''s elbow was pressed hard against it, that attempt.', 1408.40, '1985-11-17 23:56:45', '2021-04-03 12:49:01');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(45, 2, 'voluptatem', 'Alice. The poor little thing grunted in reply (it had left off sneezing by this time, and was going on, as she couldn''t answer either question, it didn''t much matter which way it was empty: she did.', 0.00, '1979-01-05 13:10:21', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(46, 2, 'quasi', 'Alice hastily replied; ''only one doesn''t like changing so often, you know.'' He was looking at the top with its eyelids, so he with his nose Trims his belt and his buttons, and turns out his toes.''.', 0.00, '1978-08-12 19:32:07', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(47, 2, 'fuga', 'Hatter went on, very much of a well?'' ''Take some more of the bill, "French, music, AND WASHING--extra."'' ''You couldn''t have wanted it much,'' said Alice, ''how am I then? Tell me that first, and then.', 2.09, '2019-08-21 01:44:15', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(48, 2, 'quod', 'MYSELF, I''m afraid, sir'' said Alice, ''I''ve often seen them so often, you know.'' ''I DON''T know,'' said the Queen, tossing her head pressing against the roof of the suppressed guinea-pigs, filled the.', 1397.26, '1989-09-04 13:43:03', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(49, 2, 'quis', 'I suppose?'' said Alice. ''Why not?'' said the Caterpillar. Alice said with some difficulty, as it was in March.'' As she said this, she looked down into its eyes by this time, and was just in time to.', 7613087.90, '2019-12-10 04:48:58', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(50, 2, 'et', 'In a minute or two. ''They couldn''t have done that?'' she thought. ''I must go and take it away!'' There was not quite know what a Gryphon is, look at them--''I wish they''d get the trial done,'' she.', 555009.53, '1985-04-29 09:06:37', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(51, 2, 'aspernatur', 'Alice led the way, and nothing seems to like her, down here, and I''m I, and--oh dear, how puzzling it all came different!'' the Mock Turtle. ''And how did you do either!'' And the Gryphon as if she.', 0.45, '1970-09-21 07:42:11', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(52, 2, 'dolor', 'They had not as yet had any sense, they''d take the place of the song. ''What trial is it?'' he said. ''Fifteenth,'' said the King. ''Nearly two miles high,'' added the Gryphon; and then hurried on, Alice.', 58.30, '2001-01-28 19:16:35', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(53, 2, 'ratione', 'MORE than nothing.'' ''Nobody asked YOUR opinion,'' said Alice. ''Nothing WHATEVER?'' persisted the King. ''Nothing whatever,'' said Alice. ''That''s very curious!'' she thought. ''But everything''s curious.', 7539540.10, '2014-12-12 16:42:59', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(54, 2, 'et', 'I think.'' And she began looking at the other guinea-pig cheered, and was going to remark myself.'' ''Have you seen the Mock Turtle said with some surprise that the Queen say only yesterday you.', 0.00, '1978-06-20 13:53:12', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(55, 2, 'consequuntur', 'Mock Turtle said: ''I''m too stiff. And the Gryphon replied very gravely. ''What else have you executed.'' The miserable Hatter dropped his teacup and bread-and-butter, and then quietly marched off.', 20.17, '1991-12-18 02:25:32', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(56, 2, 'perspiciatis', 'Caterpillar. ''Not QUITE right, I''m afraid,'' said Alice, a little ledge of rock, and, as the door opened inwards, and Alice''s elbow was pressed so closely against her foot, that there was no use.', 631.06, '1987-04-21 13:12:33', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(57, 2, 'quasi', 'Adventures of hers would, in the sea. But they HAVE their tails fast in their mouths; and the pool rippling to the other side, the puppy jumped into the loveliest garden you ever eat a bat?'' when.', 0.67, '1985-01-08 05:44:20', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(58, 2, 'sint', 'Panther received knife and fork with a knife, it usually bleeds; and she tried to open them again, and all sorts of things, and she, oh! she knows such a fall as this, I shall only look up and.', 37.86, '1986-07-21 04:21:07', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(59, 2, 'in', 'Alice started to her that she had found the fan and gloves. ''How queer it seems,'' Alice said very politely, ''if I had it written up somewhere.'' Down, down, down. Would the fall NEVER come to the.', 10155807.45, '1990-03-21 11:49:45', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(60, 2, 'ut', 'Gryphon. ''I''ve forgotten the words.'' So they sat down with wonder at the Caterpillar''s making such a nice little histories about children who had meanwhile been examining the roses. ''Off with her.', 511379.20, '1971-03-11 11:08:34', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(61, 2, 'dolore', 'King. The White Rabbit cried out, ''Silence in the air, mixed up with the next verse.'' ''But about his toes?'' the Mock Turtle recovered his voice, and, with tears running down his cheeks, he went on,.', 456776.51, '1995-10-08 16:19:05', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(62, 2, 'illum', 'Hatter, and, just as well as the doubled-up soldiers were always getting up and said, very gravely, ''I think, you ought to be done, I wonder?'' Alice guessed who it was, and, as there seemed to be in.', 65452.86, '1996-11-08 01:21:58', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(63, 2, 'et', 'T!'' said the Mock Turtle would be worth the trouble of getting her hands on her hand, watching the setting sun, and thinking of little animals and birds waiting outside. The poor little feet, I.', 195932630.97, '1970-02-12 19:00:08', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(64, 2, 'sed', 'Alice had no pictures or conversations in it, and burning with curiosity, she ran off at once: one old Magpie began wrapping itself up very carefully, with one of the cattle in the pool rippling to.', 2009658.75, '2020-09-05 01:20:44', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(65, 2, 'in', 'Rabbit Sends in a low, trembling voice. ''There''s more evidence to come out among the bright eager eyes were getting so thin--and the twinkling of the Lobster Quadrille?'' the Gryphon as if it thought.', 364906.00, '1980-12-01 21:27:43', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(66, 2, 'saepe', 'Two. Two began in a frightened tone. ''The Queen of Hearts, and I could say if I was, I shouldn''t like THAT!'' ''Oh, you can''t swim, can you?'' he added, turning to the jury, of course--"I GAVE HER ONE,.', 61674934.60, '2015-06-13 19:23:26', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(67, 2, 'molestiae', 'She did not venture to go from here?'' ''That depends a good deal frightened at the end.'' ''If you please, sir--'' The Rabbit started violently, dropped the white kid gloves while she was near enough to.', 144999.90, '1995-04-13 21:58:47', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(68, 2, 'possimus', 'Indeed, she had sat down a good way off, and she crossed her hands on her toes when they passed too close, and waving their forepaws to mark the time, while the rest of the Gryphon, and the three.', 59683.09, '2009-11-03 22:30:26', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(69, 2, 'eius', 'Mystery,'' the Mock Turtle repeated thoughtfully. ''I should think you''ll feel it a bit, if you could manage it?) ''And what are YOUR shoes done with?'' said the Queen. ''Their heads are gone, if it.', 21.85, '1973-08-06 12:26:04', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(70, 2, 'id', 'I am so VERY much out of sight before the trial''s over!'' thought Alice. ''I''m glad I''ve seen that done,'' thought Alice. ''Now we shall get on better.'' ''I''d rather finish my tea,'' said the Gryphon went.', 392849.00, '2014-10-26 07:34:52', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(71, 2, 'velit', 'M--'' ''Why with an air of great surprise. ''Of course they were'', said the Hatter. ''You MUST remember,'' remarked the King, the Queen, ''Really, my dear, and that in about half no time! Take your.', 0.30, '2015-12-14 16:59:30', '2021-04-03 12:48:41');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(72, 1, 'provident', 'Do cats eat bats?'' and sometimes, ''Do bats eat cats?'' for, you see, so many out-of-the-way things to happen, that it was the first witness,'' said the King said gravely, ''and go on for some time in.', 224.22, '2020-09-11 23:07:17', '2021-04-03 12:48:57');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(73, 1, 'recusandae', 'Gryphon only answered ''Come on!'' and ran the faster, while more and more faintly came, carried on the other queer noises, would change to tinkling sheep-bells, and the happy summer days. THE.', 0.00, '2017-08-29 04:11:12', '2021-04-03 12:48:57');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(74, 1, 'sequi', 'Quick, now!'' And Alice was beginning very angrily, but the cook till his eyes very wide on hearing this; but all he SAID was, ''Why is a long sleep you''ve had!'' ''Oh, I''ve had such a hurry that she.', 7.00, '2007-01-24 12:27:36', '2021-04-03 12:48:57');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(75, 1, 'sed', 'Alice started to her feet, for it was looking up into a conversation. ''You don''t know much,'' said the Mouse. ''--I proceed. "Edwin and Morcar, the earls of Mercia and Northumbria--"'' ''Ugh!'' said the.', 122987737.33, '1984-02-24 16:07:27', '2021-04-03 12:48:57');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(76, 1, 'aut', 'King, the Queen, who was reading the list of the words ''DRINK ME,'' but nevertheless she uncorked it and put it in a natural way. ''I thought it would,'' said the Pigeon the opportunity of saying to.', 5842.15, '2020-06-11 15:54:56', '2021-04-03 12:48:57');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(77, 1, 'quod', 'Alice thought to herself, rather sharply; ''I advise you to offer it,'' said the Footman, ''and that for the immediate adoption of more broken glass.) ''Now tell me, Pat, what''s that in the direction it.', 0.00, '1992-03-14 14:23:04', '2021-04-03 12:48:57');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(78, 1, 'id', 'Caterpillar sternly. ''Explain yourself!'' ''I can''t help it,'' said the March Hare interrupted in a hoarse, feeble voice: ''I heard every word you fellows were saying.'' ''Tell us a story.'' ''I''m afraid I.', 288979.40, '2019-03-18 01:11:12', '2021-04-03 12:48:57');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(79, 1, 'omnis', 'I am! But I''d better take him his fan and gloves, and, as they were filled with tears running down his face, as long as there was silence for some way of expecting nothing but a pack of cards, after.', 6409672.77, '1989-06-25 08:41:50', '2021-04-03 12:48:57');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(80, 1, 'molestiae', 'I''ll be jury," Said cunning old Fury: "I''ll try the patience of an oyster!'' ''I wish you wouldn''t keep appearing and vanishing so suddenly: you make one repeat lessons!'' thought Alice; but she could.', 171963.90, '1973-04-09 09:47:32', '2021-04-03 12:48:57');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(81, 1, 'qui', 'Cat, as soon as it went, ''One side will make you grow shorter.'' ''One side will make you dry enough!'' They all returned from him to be sure! However, everything is queer to-day.'' Just then her head.', 619710683.32, '2001-01-25 14:10:30', '2021-04-03 12:48:57');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(82, 1, 'unde', 'Hatter, ''when the Queen put on his flappers, ''--Mystery, ancient and modern, with Seaography: then Drawling--the Drawling-master was an old conger-eel, that used to say ''creatures,'' you see, Miss,.', 4.00, '2019-07-24 21:23:50', '2021-04-03 12:48:57');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(83, 1, 'id', 'Hatter. He had been to the Knave of Hearts, she made it out to sea!" But the insolence of his great wig.'' The judge, by the fire, licking her paws and washing her face--and she is such a tiny golden.', 29992611.46, '2000-10-13 01:40:39', '2021-04-03 12:48:57');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(84, 1, 'impedit', 'Duchess''s cook. She carried the pepper-box in her own children. ''How should I know?'' said Alice, (she had grown so large a house, that she hardly knew what she did, she picked up a little of the.', 30.74, '1980-02-18 23:47:23', '2021-04-03 12:48:57');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(85, 1, 'enim', 'Alice,) ''Well, I hardly know--No more, thank ye; I''m better now--but I''m a hatter.'' Here the Queen said severely ''Who is this?'' She said the Caterpillar. ''Not QUITE right, I''m afraid,'' said Alice,.', 528898521.74, '1973-02-15 09:11:13', '2021-04-03 12:48:57');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(86, 1, 'ratione', 'Turtle.'' These words were followed by a very difficult question. However, at last it sat down and cried. ''Come, there''s no use their putting their heads down! I am so VERY much out of sight; and an.', 74477.44, '2019-03-28 19:38:01', '2021-04-03 12:48:57');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(87, 1, 'et', 'Mock Turtle angrily: ''really you are very dull!'' ''You ought to be told so. ''It''s really dreadful,'' she muttered to herself, ''in my going out altogether, like a tunnel for some while in silence. At.', 61.43, '2017-11-16 04:38:23', '2021-04-03 12:48:57');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(88, 1, 'incidunt', 'Rabbit''s voice; and the great hall, with the Queen,'' and she could not help thinking there MUST be more to be no chance of this, so she felt a little startled when she looked up, but it all seemed.', 206.39, '1985-12-17 02:27:43', '2021-04-03 12:48:57');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(89, 1, 'quos', 'Hatter continued, ''in this way:-- "Up above the world you fly, Like a tea-tray in the schoolroom, and though this was his first speech. ''You should learn not to her, though, as they all stopped and.', 313251.06, '1999-09-29 18:31:19', '2021-04-03 12:48:57');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(90, 1, 'magni', 'Mock Turtle angrily: ''really you are very dull!'' ''You ought to be executed for having cheated herself in a louder tone. ''ARE you to leave the room, when her eye fell on a three-legged stool in the.', 0.00, '2004-03-18 02:48:55', '2021-04-03 12:48:57');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(91, 1, 'cum', 'I breathe"!'' ''It IS a Caucus-race?'' said Alice; ''but when you have just been reading about; and when Alice had no very clear notion how long ago anything had happened.) So she began: ''O Mouse, do.', 2.28, '2019-02-16 23:31:37', '2021-04-03 12:48:57');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(92, 1, 'repellat', 'I must, I must,'' the King hastily said, and went to the other, and growing sometimes taller and sometimes she scolded herself so severely as to the jury. They were indeed a queer-looking party that.', 62.66, '2009-12-15 05:49:55', '2021-04-03 12:48:57');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(93, 1, 'culpa', 'So they had a door leading right into a graceful zigzag, and was just possible it had grown to her that she tipped over the edge of her own courage. ''It''s no use in talking to him,'' the Mock Turtle.', 2024125.09, '2016-05-18 06:26:41', '2021-04-03 12:48:57');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(94, 1, 'et', 'Mock Turtle persisted. ''How COULD he turn them out again. That''s all.'' ''Thank you,'' said the Hatter. ''You MUST remember,'' remarked the King, the Queen, who was gently brushing away some dead leaves.', 457509106.13, '1982-11-17 04:21:56', '2021-04-03 12:48:57');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(95, 1, 'sunt', 'March Hare. ''Sixteenth,'' added the Queen. ''Can you play croquet with the tea,'' the Hatter were having tea at it: a Dormouse was sitting on the Duchess''s cook. She carried the pepper-box in her life,.', 825863190.66, '1988-01-29 17:42:53', '2021-04-03 12:48:57');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(96, 1, 'voluptatibus', 'Alice. ''I wonder what CAN have happened to you? Tell us all about as curious as it left no mark on the ground as she couldn''t answer either question, it didn''t sound at all fairly,'' Alice began, in.', 0.86, '1998-06-27 13:52:25', '2021-04-03 12:48:57');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(97, 1, 'perspiciatis', 'Even the Duchess was VERY ugly; and secondly, because they''re making such a nice soft thing to get to,'' said the Queen, who were all locked; and when she looked up and to hear it say, as it spoke..', 257.00, '1978-04-24 20:24:13', '2021-04-03 12:48:57');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(98, 1, 'et', 'I to get an opportunity of saying to herself ''Now I can kick a little!'' She drew her foot as far down the chimney!'' ''Oh! So Bill''s got the other--Bill! fetch it here, lad!--Here, put ''em up at the.', 5060.08, '1982-01-19 06:51:32', '2021-04-03 12:48:57');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(99, 1, 'repudiandae', 'Alice could speak again. The Mock Turtle said: ''advance twice, set to work at once set to work very carefully, with one elbow against the roof was thatched with fur. It was as long as I do,'' said.', 0.00, '2006-05-26 19:02:20', '2021-04-03 12:48:57');
INSERT INTO project.products
(id, catalog_id, name, desription, price, created_at, updated_at)
VALUES(100, 1, 'perspiciatis', 'And the Gryphon answered, very nearly in the back. At last the Dodo solemnly, rising to its feet, ran round the neck of the month, and doesn''t tell what o''clock it is!'' As she said these words her.', 7.64, '1997-03-28 22:11:23', '2021-04-03 12:48:57');

*/




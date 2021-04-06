
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY ,
  name varchar(255) DEFAULT NULL COMMENT 'Название раздела',
  KEY index_of_name_catalog (name)
) COMMENT='Разделы интернет-магазина';


create table country(
id SERIAL primary key,
name varchar(50)
)COMMENT = 'Страны';


create table city(
id SERIAL PRIMARY KEY,
country_id BIGINT UNSIGNED NOT NULL,
city_name varchar(60)  not null,
foreign key (country_id) references country(id)
) COMMENT = 'Города';


CREATE TABLE users (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  email VARCHAR(120)  DEFAULT NULL,
  password_hash VARCHAR(100) DEFAULT NULL,
  phone bigint UNSIGNED DEFAULT NULL,
  created_at DATETIME DEFAULT NOW(),
  updated_at DATETIME DEFAULT NOW() ON UPDATE NOW(),
  key index_of_email (email)
) COMMENT = 'Покупатели';



CREATE TABLE profiles (
  id SERIAL PRIMARY KEY,
  user_id BIGINT UNSIGNED NOT NULL,
  country_id BIGINT UNSIGNED NOT NULL,
  city_id BIGINT UNSIGNED NOT NULL,
  gender char(1) DEFAULT NULL COMMENT 'Пол',
  birthday date DEFAULT NULL COMMENT 'Дата рождения',
  created_at datetime DEFAULT NOW(),
  hometown varchar(60) DEFAULT NULL,
  FOREIGN KEY (country_id) REFERENCES country(id),
  FOREIGN KEY (city_id) REFERENCES city(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);


CREATE TABLE storehouses (
  id SERIAL PRIMARY KEY,
  name varchar(255) DEFAULT NULL COMMENT 'Название',
  created_at datetime DEFAULT CURRENT_TIMESTAMP,
  updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT='Склады';


CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  catalog_id BIGINT UNSIGNED NOT NULL,
  name VARCHAR(255) COMMENT 'Название',
  desription TEXT COMMENT 'Описание',
  price DECIMAL (11,2) COMMENT 'Цена',
  created_at DATETIME DEFAULT NOW(),
  updated_at DATETIME DEFAULT NOW() ON UPDATE NOW(),
  KEY index_of_catalog_id (catalog_id)
) COMMENT = 'Товарные позиции';  #ДОбавь внешний КЛЮЧ!

ALTER TABLE products ADD CONSTRAINT 
fk_products_catalog_id FOREIGN KEY (catalog_id)
REFERENCES catalogs(id);


CREATE TABLE accounts (
  id SERIAL,
  user_id BIGINT UNSIGNED NOT NULL,
  total DECIMAL(10,2) DEFAULT NULL COMMENT 'Счет',
  created_at DATETIME DEFAULT NOW(),
  updated_at DATETIME DEFAULT NOW() ON UPDATE NOW(),
  foreign key (user_id) references users(id)
)COMMENT='Счета пользователей и интернет магазина';


CREATE TABLE discounts (
  id SERIAL ,
  user_id BIGINT UNSIGNED NOT NULL, 
  product_id BIGINT UNSIGNED NOT NULL,
  discount FLOAT unsigned default NULL COMMENT 'Размер скидки - числа принимаются от 0.00 до 1.00',
  started_at DATETIME COMMENT 'Время старта акции',
  finished_at DATETIME COMMENT 'Время завершения акции',
  created_at DATETIME DEFAULT NOW(),
  updated_at DATETIME DEFAULT NOW() ON UPDATE NOW(),
  FOREIGN KEY (user_id) references users(id),
  FOREIGN key (product_id) references products(id)
) COMMENT = 'Скидки';


CREATE TABLE orders (
  id SERIAL COMMENT 'Номер заказа',
  user_id BIGINT UNSIGNED NOT NULL, 
  created_at DATETIME DEFAULT NOW(),
  updated_at DATETIME DEFAULT NOW() ON UPDATE NOW(),
  KEY index_of_user_id(user_id)
  
) COMMENT = 'Заказы';

alter table orders add constraint fk_orders_user_id
foreign key (user_id) references users(id)
on update CASCADE;  #Забыл добавить внешний ключ


CREATE TABLE media_types(
	id SERIAL,
    name VARCHAR(255) COMMENT 'Тип файла', 
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE NOW()
)COMMENT =  'Типы медиа ';


CREATE TABLE media(
	id SERIAL,
    media_type_id BIGINT UNSIGNED NOT NULL,
    product_id BIGINT UNSIGNED NOT NULL,
    filename VARCHAR(255),
    size INT,
	metadata JSON,
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (media_type_id) REFERENCES media_types(id)
)COMMENT =  'медиа ';


CREATE TABLE orders_products (
id SERIAL,
order_id BIGINT UNSIGNED NOT NULL,
product_id BIGINT UNSIGNED NOT NULL,
total BIGINT UNSIGNED  DEFAULT 1 COMMENT 'Количество заказанных товарных позиций',
created_at DATETIME default NOW(),
update_at DATETIME default NOW() on update NOW(),
FOREIGN KEY (order_id) REFERENCES orders(id),
FOREIGN KEY (product_id) REFERENCES products(id),
KEY index_of_order_and_prodict_id (order_id, product_id)
) COMMENT = 'Состав заказа';


CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id BIGINT UNSIGNED NOT NULL COMMENT 'Склад хранения',
  product_id BIGINT UNSIGNED NOT NULL COMMENT 'Название товарной позиции', 
  value int unsigned DEFAULT NULL COMMENT 'Остаток на складе данной позиции',
  created_at datetime DEFAULT CURRENT_TIMESTAMP,
  updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (storehouse_id) REFERENCES storehouses(id),
  FOREIGN KEY (product_id) REFERENCES products(id)
) COMMENT='Запасы на складе';




create table delivery(
 id SERIAL,
 user_address_id BIGINT unsigned not null COMMENT 'Пользователь магазина',
 orders_products_id BIGINT unsigned not null COMMENT 'Номер заказа пользователя',
 city_id BIGINT UNSIGNED NOT NULL COMMENT 'Город',
 address_1 varchar(80) DEFAULT NULL COMMENT 'название улицы',
 address_2 varchar(80) DEFAULT NULL COMMENT 'номер дома и квартиры',
 postal_code varchar(15) DEFAULT NULL COMMENT 'Почтовый индекс',
 delivery_min DATE DEFAULT NULL,
 delivery_max DATE DEFAULT NULL,
 last_update timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 foreign key (user_address_id) references users(id),
 foreign key (orders_products_id) references orders_products(id),
 foreign key (city_id) references city(id),
 index idx_address_ad1_ad2_city (city_id, address_1, address_2)
)COMMENT = 'Доставка' ;


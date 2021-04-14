--Создание счётчика для Country
CREATE SEQUENCE yav_seq_country_id
INCREMENT BY 1
START WITH 2000
MAXVALUE 9999999
NOCACHE
NOCYCLE;
--Создание счётчика для province
CREATE SEQUENCE yav_seq_province_id
INCREMENT BY 1
START WITH 1
MAXVALUE 9999999
NOCACHE
NOCYCLE;
--Создание счётчика для region
CREATE SEQUENCE yav_seq_region_id
INCREMENT BY 1
START WITH 3000
MAXVALUE 9999999
NOCACHE
NOCYCLE;
--Создание счётчика для variety
CREATE SEQUENCE yav_seq_variety_id
INCREMENT BY 1
START WITH 4000
MAXVALUE 9999999
NOCACHE
NOCYCLE;
--Создание счётчика для winery
CREATE SEQUENCE yav_seq_winery_id
INCREMENT BY 1
START WITH 100
MAXVALUE 9999999
NOCACHE
NOCYCLE;

--Создание счётчика для wine_wine
CREATE SEQUENCE yav_seq_wine_id
INCREMENT BY 1
START WITH 1
MAXVALUE 9999999
NOCACHE
NOCYCLE;

--Создание таблицы country_wine
CREATE TABLE country_wine(
country_id   NUMBER(10)   DEFAULT yav_seq_country_id.nextval    CONSTRAINT yav_country_id_pk         PRIMARY KEY,  -- уникальное числовое поле, первичный ключ;
country_name VARCHAR2(100)    CONSTRAINT yav_c_name_               NOT NULL      -- название страны, не может быть пустым
);
--Создание таблицы province
CREATE TABLE province_wine(
province_id                    NUMBER(10)           DEFAULT yav_seq_province_id.nextval    CONSTRAINT yav_province_id_pk         PRIMARY KEY,  -- уникальное числовое поле, первичный ключ;
province_name                  VARCHAR2(100)        CONSTRAINT yav_province_name               NOT NULL,      -- название области, не может быть пустым
country_country_id           NUMBER(10)
);
--Создание таблицы Region 
CREATE TABLE region_wine(
region_id                    NUMBER(10)           DEFAULT yav_seq_region_id.nextval    CONSTRAINT yav_region_id_pk         PRIMARY KEY,  -- уникальное числовое поле, первичный ключ;
region_name                  VARCHAR2(100)        CONSTRAINT yav_region_name               NOT NULL,      -- название региона, не может быть пустым
country_country_id           NUMBER(10),
province_province_id         NUMBER(10)
);

--Создание таблицы Winery
CREATE TABLE winery_wine(
winery_id                    NUMBER(10)           DEFAULT yav_seq_winery_id.nextval    CONSTRAINT yav_winery_id_pk         PRIMARY KEY,  -- уникальное числовое поле, первичный ключ;
winery_name                  VARCHAR2(100)        CONSTRAINT yav_winery_name               NOT NULL,      -- название винодельни, не может быть пустым
country_country_id           NUMBER(10)
);

--Создание таблицы variety 
CREATE TABLE variety_wine(
variety_id                    NUMBER(10)           DEFAULT yav_seq_variety_id.nextval    CONSTRAINT yav_variety_id_pk         PRIMARY KEY,  -- уникальное числовое поле, первичный ключ;
variety_name                  VARCHAR2(100)        CONSTRAINT yav_variety_name               NOT NULL,      -- название сорта винограда, не может быть пустым
country_country_id            NUMBER(10),
province_province_id          NUMBER(10),
region_region_id              NUMBER(10)
);

--Создание таблицы wine_wine
CREATE TABLE wine_wine(
wine_id      NUMBER(10)           DEFAULT yav_seq_wine_id.nextval    CONSTRAINT yav_wine_id_pk         PRIMARY KEY,  -- уникальное числовое поле, первичный ключ;
country_country_id            NUMBER(10),        -- страна
designation  VARCHAR2(100),       -- название
points       NUMBER(38,2) DEFAULT 0, --индекс
price        NUMBER(38,2) DEFAULT 0  CONSTRAINT yav_wine_wine_price_nn       NOT NULL       -- число, нет пустых значений, значений положительные или 0
                                     CONSTRAINT yav_wine_wine_price_ch       CHECK (price>=0),
province_province_id          NUMBER(10),          --Область
region_region_id              NUMBER(10),          --регион
variety_variety_id            NUMBER(10),          --сорт винограда
winery_winery_id              NUMBER(10)           --винодельня
);

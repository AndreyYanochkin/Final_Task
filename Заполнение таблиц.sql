--Загрузка данных в таблицу country_wine --страны
INSERT INTO country_wine(country_name)
SELECT t.country FROM LOAD_DATE_WINE t  where t.country is not null group by t.country;
commit;

--Загрузка данных в таблицу winery_wine --винодельни
INSERT INTO winery_wine(winery_name,country_country_id)
select tmp1.winery, cw.country_id from country_wine cw
left join (select t.winery, t.country from  load_date_wine t where t.winery is not null group by t.winery, t.country) tmp1 on tmp1.country=cw.country_name
where tmp1.winery is not null;
commit;

--Загрузка данных в таблицу province --область
INSERT INTO province_wine(province_name,country_country_id)
select tmp1.province, cw.country_id from country_wine cw
left join (select t.province, t.country from  load_date_wine t where t.province is not null group by t.province, t.country) tmp1 on tmp1.country=cw.country_name
where tmp1.province is not null;
commit;

--Загрузка данных в таблицу region_wine --регион области
INSERT INTO region_wine(region_name,country_country_id,province_province_id)
select t.region,cw.country_id,pw.province_id from load_date_wine t 
left join country_wine cw on cw.country_name=t.country
left join province_wine pw on pw.province_name=t.province and pw.country_country_id=cw.country_id
where t.region is not null
group by t.region,cw.country_id,pw.province_id;
commit;

--Загрузка данных в таблицу variety  --сорт винограда
INSERT INTO variety_wine(variety_name,country_country_id,province_province_id,region_region_id)
select t.variety,cw.country_id,pw.province_id,rw.region_id from load_date_wine t
left join country_wine cw on cw.country_name=t.country 
left join province_wine pw on pw.province_name=t.province and pw.country_country_id=cw.country_id 
left join region_wine rw on rw.region_name=t.region and rw.province_province_id=pw.province_id and rw.country_country_id=cw.country_id 
where t.variety is not null 
group by t.variety,cw.country_id,pw.province_id,rw.region_id
having cw.country_id is not null ;
commit;
--Загрузка данных в таблицу wine_wine 
INSERT INTO wine_wine
  (designation,
   country_country_id,
   province_province_id,
   region_region_id,
   variety_variety_id,
   winery_winery_id,
   points,
   price)
  select w.designation,
         cw.country_id,
         pw.province_id,
         rw.region_id,
         vw.variety_id,
         ww.winery_id,
         w.points,
         w.price
    from (select distinct b.*
            from (select t.country,
                         t.designation,
                         t.points,
                         t.price,
                         t.province,
                         t.region,
                         t.variety,
                         t.winery
                    from load_date_wine t
                   where t.country is not null
                     and t.designation is not null) b) w
    left join country_wine cw
      on cw.country_name = w.country
    left join province_wine pw
      on pw.province_name = w.province
     and pw.country_country_id = cw.country_id
    left join region_wine rw
      on rw.region_name = w.region
     and rw.province_province_id = pw.province_id
     and rw.country_country_id = cw.country_id
    left join variety_wine vw
      on vw.variety_name = w.variety
     and vw.region_region_id = rw.region_id
     and vw.province_province_id = pw.province_id
     and cw.country_id = vw.country_country_id
    left join winery_wine ww
      on ww.winery_name = w.winery
     and ww.country_country_id = cw.country_id
   where 1 = 1
     and vw.variety_id is not null
  union all
  select w.designation,
         cw.country_id,
         pw.province_id,
         rw.region_id,
         vw.variety_id,
         ww.winery_id,
         w.points,
         w.price
    from (select distinct b.*
            from (select t.country,
                         t.designation,
                         t.points,
                         t.price,
                         t.province,
                         t.region,
                         t.variety,
                         t.winery
                    from load_date_wine t
                   where t.country is not null
                     and t.designation is not null) b) w
    left join country_wine cw
      on cw.country_name = w.country
    left join province_wine pw
      on pw.province_name = w.province
     and pw.country_country_id = cw.country_id
    left join region_wine rw
      on rw.region_name = w.region
     and rw.province_province_id = pw.province_id
     and rw.country_country_id = cw.country_id
    left join variety_wine vw
      on vw.variety_name = w.variety
     and vw.region_region_id is null
     and vw.province_province_id = pw.province_id
     and cw.country_id = vw.country_country_id
    left join winery_wine ww
      on ww.winery_name = w.winery
     and ww.country_country_id = cw.country_id
   where 1 = 1
     and rw.region_id is null;
commit;

--Создание представления yav_wine_summary
CREATE OR REPLACE VIEW yav_wine_summary
(id,Designation,Country,Province,Region,Variety,Winery,Points,Price)
AS select
wiw.wine_id 
,wiw.designation
,cw.country_name
,pw.province_name
,rw.region_name
,vw.variety_name
,ww.winery_name
,wiw.points
,wiw.price
 from  wine_wine wiw
left join country_wine   cw on cw.country_id = wiw.country_country_id
left join province_wine  pw on pw.province_id=wiw.province_province_id
left join region_wine    rw on rw.region_id=wiw.region_region_id
left join winery_wine    ww on ww.winery_id=wiw.winery_winery_id
left join variety_wine   vw on vw.variety_id=wiw.variety_variety_id
;

CREATE OR REPLACE VIEW avg_wine_price_country_variety
(Country,Variety,AGV_Price)
AS select
cw.country_name
,vw.variety_name
,to_char(round(avg(wiw.price),2),'990.00')
 from wine_wine wiw
left join country_wine   cw on cw.country_id = wiw.country_country_id
left join variety_wine   vw on vw.variety_id=wiw.variety_variety_id
group by cw.country_name, vw.variety_name
order by 1,3;

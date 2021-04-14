# -*- coding: utf-8 -*-
"""
Created on Sun Apr 11 23:26:39 2021

@author: Андрей
"""

import sqlalchemy as adb
from  sqlalchemy import MetaData, Table
import cx_Oracle as ora
import datetime as dt
import pandas as pd
from progress.bar import IncrementalBar


def proverka(znach):
    if znach !=znach:
        return''
    else:
        return znach
def proverka_d(znach):
    if znach !=znach:
        return 0.00
    else:
        return znach        
  


l_user = 'YANOCHKIN_AV' #loginDB
l_pass = 'Zzasd#45wm'#passwordDB

l_conn_ora = ora.connect(l_user,l_pass,ora.makedsn('SWAGOR-DOM', 1521, service_name = 'xepdb1'))

cursor = l_conn_ora.cursor() # создаем курсор

sql_create_table='''
CREATE TABLE load_date_wine(
data_load     DATE        DEFAULT sysdate,
country      VARCHAR2(100), 
designation  VARCHAR2(100),
points       NUMBER(38,2) DEFAULT 0,
price        NUMBER(38,2) DEFAULT 0  CONSTRAINT yav_wine_price_nn       NOT NULL,
                                     CONSTRAINT yav_wine_price_ch       CHECK (price>=0),
province     VARCHAR2(200),
region       VARCHAR2(200),
variety      VARCHAR2(200), 
winery       VARCHAR2(200)
)
'''
sql_str='''insert into LOAD_DATE_WINE (COUNTRY,designation,points,price,province,region,variety,winery)
                           VALUES(:p1,:p2,:p3,:p4,:p5,:p6,:p7,:p8)'''

try:
    l_file_load=(r'c:\Temp\Load_Data\winemag-data_first150k.csv')
    l_data_csv=pd.read_csv(l_file_load)
    l_count_rows=len(l_data_csv)
    l_column=l_data_csv.columns.tolist()
    print('В файле для загрузки {l_rows} строк.\n'.format(l_rows=l_count_rows))
    l_pr=l_data_csv[[l_column[1],l_column[3],l_column[4],l_column[5],l_column[6],l_column[7],l_column[9],l_column[10]]]
    l_list=l_pr.values.tolist()
    print('Создание таблицы для загрузки.\n')
    cursor.execute(sql_create_table)
    # Цикл загрузки в БД
    print('Старт загрузки.\n')
    bars = IncrementalBar(' Загрузка:',max = l_count_rows) #l_count_rows
    for i in l_list:
        row_t=tuple(i)
        #print(proverka(i[6]))
        cursor.execute(sql_str,{'p1':proverka(i[0]),
                                'p2':proverka(i[1]),
                                'p3':proverka(i[2]),
                                'p4':proverka_d(i[3]),
                                'p5':proverka(i[4]),
                                'p6':proverka(i[5]),
                                'p7':proverka(i[6]),
                                'p8':proverka(i[7])})
        bars.next()
        
    bars.finish()   
    l_conn_ora.commit()
    print('Загрузка завершена!')
except:
    l_conn_ora.rollback()
    print('Ошибка загрузки.')
    raise
    







    



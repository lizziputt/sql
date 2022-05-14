USE Склад_222
 GO
/*1*/
 SELECT * 
 FROM Клиент 
 WHERE ФИОРуководителя LIKE '%гор%'  AND КодРегиона NOT BETWEEN 101 AND 200 OR КодРегиона IS NULL

/*2*/
 SELECT * 
 FROM Поставщик 
 WHERE УсловияОплаты != 'Предоплата' OR (КодРегиона NOT BETWEEN 101 AND 200 OR КодРегиона NOT BETWEEN 301 AND 400)

/*3*/
 SELECT * 
 FROM Регион 
 WHERE (Страна = 'Россия' AND Город!='Москва') OR (Страна='Беларусь' AND Город!='Минск' OR Город!='Гомель')

/*4*/
 SELECT * 
 FROM Товар 
 WHERE (КодВалюты='USD' AND Цена BETWEEN 200 AND 800) OR (КодВалюты='EUR' AND Цена BETWEEN 100 AND 500 OR Цена IS NULL)

/*5*/
 SELECT Заказ.КодКлиента, Заказ.КодТовара, Заказ.КодПоставщика, Клиент.ИмяКлиента, Товар.Наименование, Поставщик.ИмяПоставщика
 FROM Заказ
	INNER JOIN Клиент ON Заказ.КодКлиента = Клиент.КодКлиента
	INNER JOIN Товар ON Заказ.КодТовара=Товар.КодТовара
	INNER JOIN Поставщик ON Заказ.КодПоставщика = Поставщик.КодПоставщика
 WHERE Количество IS NULL OR Количество NOT BETWEEN 2 AND 20

/*6*/
 SELECT Заказ.КодТовара, Заказ.КодКлиента,Товар.Наименование, Клиент.ИмяКлиента
 FROM Заказ
	INNER JOIN Товар ON Заказ.КодТовара=Товар.КодТовара
	INNER JOIN Клиент ON Заказ.КодКлиента = Клиент.КодКлиента
	INNER JOIN Регион ON Клиент.КодКлиента = Регион.КодРегиона
WHERE Регион.Страна = 'Россия' OR Регион.Страна='Украина'
ORDER BY Заказ.ДатаЗаказа, Клиент.ИмяКлиента, Заказ.Количество DESC

/*7*/
 SELECT * 
 FROM Запрос1
 WHERE(Наименование LIKE '%тер%' OR Наименование LIKE '%гор%' OR Наименование LIKE '%a') AND ( Количество BETWEEN 5 AND 10 OR ЕдиницаИзм = 'штука' OR ЕдиницаИзм = 'литр')

 /*-------------2-------------*/
 
 /*1*/
UPDATE Клиент
 SET ИмяКлиента = 'ГП "Верас-М"', ФИОРуководителя=NULL
 WHERE ИмяКлиента = 'ГП "Верас"'
/*2*/
 UPDATE Поставщик
 SET УсловияОплаты = 'По договору поставки'
 WHERE ИмяПоставщика LIKE '%н' OR ИмяПоставщика LIKE '%т' OR ИмяПоставщика LIKE '%л' OR ИмяПоставщика NOT LIKE 'ЗАО%' OR ИмяПоставщика NOT LIKE 'ОАО%'
/*3*/
 UPDATE Товар 
 SET КодВалюты = 'RUR', Цена = Цена/285
 WHERE КодВалюты = 'BYR' AND Цена BETWEEN 100000 AND 1000000
/*4*/
 UPDATE Товар 
 SET КодВалюты = 'USD', Цена = Цена/9100
 WHERE КодВалюты = 'BYR' AND Цена>1000000
/*5*/
 SET DATEFORMAT dmy

 UPDATE Заказ 
 SET СрокПоставки = ДатаЗаказа + 14
 WHERE ДатаЗаказа < '15.10.2020'

 UPDATE Заказ 
 SET СрокПоставки = ДатаЗаказа + 10
 WHERE ДатаЗаказа > '15.10.2020'

 UPDATE Заказ 
 SET СрокПоставки = ДатаЗаказа + 20
 WHERE КодПоставщика IS NULL
 
 
/*-------------3-------------*/
INSERT INTO Валюта
VALUES ('GRV', 'Украинские гривны', 0.01, 250)


INSERT INTO Товар
VALUES (666, 'ПК-клавиатура', NULL, 2630, 'GRV', 'Да')

INSERT INTO Товар
VALUES (777, 'Разъём USB', NULL, 135, 'GRV', 'Да')

INSERT INTO Товар
VALUES (888, 'Принтер Lexmark', NULL, 12790, 'GRV', 'Да')


INSERT INTO Заказ
VALUES (4, 666, 17, NULL, NULL, 345)

INSERT INTO Заказ
VALUES (5, 777, 5, NULL, NULL, 234)

INSERT INTO Заказ
VALUES (3, 888, 14, NULL, NULL, 456)

INSERT INTO Заказ
VALUES (5, 666, 9, NULL, NULL, 345)
GO

 ALTER TABLE Товар DROP CONSTRAINT  FK_Товар_Валюта
 ALTER TABLE Товар ADD CONSTRAINT  FK_Товар_Валюта  FOREIGN KEY (КодВалюты)
   REFERENCES  Валюта  ON UPDATE CASCADE ON DELETE CASCADE
GO

DELETE FROM Валюта 
 WHERE КодВалюты = 'GRV'
 GO
 
/*-------------4-------------*/
 ALTER TABLE Товар DROP CONSTRAINT  FK_Товар_Валюта  
 GO
 
 DELETE FROM Валюта 
 WHERE КодВалюты = 'GRV'
 GO

/*-------------5-------------*/

 EXEC sp_fkeys 'Поставщик'
 EXEC sp_fkeys @fktable_name = 'Заказ'
 GO
 
 ALTER TABLE Заказ DROP CONSTRAINT FK_Заказ_Поставщик
DROP TABLE Поставщик
 GO
 
 EXEC sp_fkeys 'Регион'
 GO
 EXEC sp_fkeys @fktable_name = 'Регион'
 GO

 ALTER TABLE Клиент DROP CONSTRAINT FK_Клиент_Регион
 ALTER TABLE Поставщик DROP CONSTRAINT FK_Поставщик_Регион
 DROP TABLE Регион
 GO

 DROP TABLE Поставщик
 GO

DROP VIEW 
IF EXISTS dbo.Запрос1 
GO 

USE Склад_222
GO

CREATE PROCEDURE pr_КлиентПоставщик_СтранаИнтервал
  @Страна VARCHAR(20), 
  @НачалоИнтервала DATETIME, 
  @КонецИнтервала DATETIME,
  @ЧислоКлиентов INT OUTPUT, 
  @ЧислоПоставщиков INT OUTPUT
  AS

	SELECT @ЧислоКлиентов = COUNT(*)
		FROM (
		SELECT Заказ.КодКлиента FROM Заказ
		WHERE ДатаЗаказа BETWEEN @НачалоИнтервала AND @КонецИнтервала 
		GROUP BY Заказ.КодКлиента) 
	AS [КодыКлиентов]
	INNER JOIN Клиент on [КодыКлиентов].КодКлиента = Клиент.КодКлиента
	INNER JOIN Регион on Клиент.КодРегиона = Регион.КодРегиона
	WHERE @Страна IS NULL OR (@Страна IS NOT NULL AND @Страна = Страна)

	SELECT @ЧислоПоставщиков = COUNT(*)
	FROM (
		SELECT Заказ.КодПоставщика 
		FROM Заказ
		WHERE ДатаЗаказа BETWEEN @НачалоИнтервала AND @КонецИнтервала
		GROUP BY Заказ.КодПоставщика) 
	AS [КодыПоставщиков]
	INNER JOIN Поставщик on [КодыПоставщиков].КодПоставщика = Поставщик.КодПоставщика
	INNER JOIN Регион on Поставщик.КодРегиона = Регион.КодРегиона
	WHERE @Страна IS NULL OR (@Страна IS NOT NULL AND @Страна = Страна)
GO

DECLARE  @ЧислоКлиентов INT,  @ЧислоПоставщиков INT
EXEC pr_КлиентПоставщик_СтранаИнтервал NULL,'2020-01-01', '2025-01-01', @ЧислоКлиентов OUTPUT, @ЧислоПоставщиков OUTPUT
SELECT @ЧислоКлиентов AS [Число Клиентов], @ЧислоПоставщиков AS [Число Поставщиков]
GO
 
INSERT INTO Регион 
VALUES (102, 'Россия', '', 'Москва', 'пр.Калинина, 50', 
'339-62- 10', '(095) 339-62-11')

INSERT INTO Регион 
VALUES (401, 'Литва', '', 'Вильнюс', 'ул.Чурлёниса, 19', NULL,
'(055) 33-27-75')	
GO

DROP PROCEDURE КлиентыПоставщики_Стран
GO

CREATE PROCEDURE КлиентыПоставщики_Стран
AS
	DECLARE @stra TABLE (Страна varchar(20) PRIMARY KEY,
	[Число Клиентов] INT,
	[Число Поставщиков] INT)

	DECLARE  @ЧислоКлиентов INT,  @ЧислоПоставщиков INT, @Страна varchar(20)

	DECLARE myCursor CURSOR LOCAL STATIC
    FOR 
        SELECT Регион.Страна
        FROM Регион 
		GROUP BY Страна

	OPEN myCursor
	FETCH FIRST FROM myCursor INTO @Страна
		 
	WHILE @@FETCH_STATUS = 0
		BEGIN
			EXEC pr_КлиентПоставщик_СтранаИнтервал @Страна,'2000-01-01', '2025-01-01', @ЧислоКлиентов OUTPUT, @ЧислоПоставщиков OUTPUT
			INSERT @stra VALUES (@Страна, @ЧислоКлиентов, @ЧислоПоставщиков)
		FETCH NEXT FROM myCursor INTO @Страна
	END

	SELECT *
	FROM @stra

	CLOSE myCursor
	DEALLOCATE myCursor 
GO

EXEC КлиентыПоставщики_Стран
GO

DROP TRIGGER tr_Клиент_КодРегиона
GO
DROP TRIGGER tr_Поставщик_КодРегиона
GO

CREATE TRIGGER tr_Клиент_КодРегиона
ON Клиент
FOR UPDATE AS
	IF UPDATE(КодРегиона)
	BEGIN
		EXEC КлиентыПоставщики_Стран
	END
GO

CREATE TRIGGER tr_Поставщик_КодРегиона
ON Поставщик
FOR UPDATE AS
	IF UPDATE(КодРегиона)
	BEGIN
		EXEC КлиентыПоставщики_Стран
	END
GO
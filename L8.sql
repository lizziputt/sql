USE �����_222
GO

CREATE PROCEDURE pr_���������������_��������������
  @������ VARCHAR(20), 
  @��������������� DATETIME, 
  @�������������� DATETIME,
  @������������� INT OUTPUT, 
  @���������������� INT OUTPUT
  AS

	SELECT @������������� = COUNT(*)
		FROM (
		SELECT �����.���������� FROM �����
		WHERE ���������� BETWEEN @��������������� AND @�������������� 
		GROUP BY �����.����������) 
	AS [������������]
	INNER JOIN ������ on [������������].���������� = ������.����������
	INNER JOIN ������ on ������.���������� = ������.����������
	WHERE @������ IS NULL OR (@������ IS NOT NULL AND @������ = ������)

	SELECT @���������������� = COUNT(*)
	FROM (
		SELECT �����.������������� 
		FROM �����
		WHERE ���������� BETWEEN @��������������� AND @��������������
		GROUP BY �����.�������������) 
	AS [���������������]
	INNER JOIN ��������� on [���������������].������������� = ���������.�������������
	INNER JOIN ������ on ���������.���������� = ������.����������
	WHERE @������ IS NULL OR (@������ IS NOT NULL AND @������ = ������)
GO

DECLARE  @������������� INT,  @���������������� INT
EXEC pr_���������������_�������������� NULL,'2020-01-01', '2025-01-01', @������������� OUTPUT, @���������������� OUTPUT
SELECT @������������� AS [����� ��������], @���������������� AS [����� �����������]
GO
 
INSERT INTO ������ 
VALUES (102, '������', '', '������', '��.��������, 50', 
'339-62- 10', '(095) 339-62-11')

INSERT INTO ������ 
VALUES (401, '�����', '', '�������', '��.��������, 19', NULL,
'(055) 33-27-75')	
GO

DROP PROCEDURE �����������������_�����
GO

CREATE PROCEDURE �����������������_�����
AS
	DECLARE @stra TABLE (������ varchar(20) PRIMARY KEY,
	[����� ��������] INT,
	[����� �����������] INT)

	DECLARE  @������������� INT,  @���������������� INT, @������ varchar(20)

	DECLARE myCursor CURSOR LOCAL STATIC
    FOR 
        SELECT ������.������
        FROM ������ 
		GROUP BY ������

	OPEN myCursor
	FETCH FIRST FROM myCursor INTO @������
		 
	WHILE @@FETCH_STATUS = 0
		BEGIN
			EXEC pr_���������������_�������������� @������,'2000-01-01', '2025-01-01', @������������� OUTPUT, @���������������� OUTPUT
			INSERT @stra VALUES (@������, @�������������, @����������������)
		FETCH NEXT FROM myCursor INTO @������
	END

	SELECT *
	FROM @stra

	CLOSE myCursor
	DEALLOCATE myCursor 
GO

EXEC �����������������_�����
GO

DROP TRIGGER tr_������_����������
GO
DROP TRIGGER tr_���������_����������
GO

CREATE TRIGGER tr_������_����������
ON ������
FOR UPDATE AS
	IF UPDATE(����������)
	BEGIN
		EXEC �����������������_�����
	END
GO

CREATE TRIGGER tr_���������_����������
ON ���������
FOR UPDATE AS
	IF UPDATE(����������)
	BEGIN
		EXEC �����������������_�����
	END
GO
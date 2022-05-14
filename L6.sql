USE �����_222
 GO
/*1*/
 SELECT * 
 FROM ������ 
 WHERE ��������������� LIKE '%���%'  AND ���������� NOT BETWEEN 101 AND 200 OR ���������� IS NULL

/*2*/
 SELECT * 
 FROM ��������� 
 WHERE ������������� != '����������' OR (���������� NOT BETWEEN 101 AND 200 OR ���������� NOT BETWEEN 301 AND 400)

/*3*/
 SELECT * 
 FROM ������ 
 WHERE (������ = '������' AND �����!='������') OR (������='��������' AND �����!='�����' OR �����!='������')

/*4*/
 SELECT * 
 FROM ����� 
 WHERE (���������='USD' AND ���� BETWEEN 200 AND 800) OR (���������='EUR' AND ���� BETWEEN 100 AND 500 OR ���� IS NULL)

/*5*/
 SELECT �����.����������, �����.���������, �����.�������������, ������.����������, �����.������������, ���������.�������������
 FROM �����
	INNER JOIN ������ ON �����.���������� = ������.����������
	INNER JOIN ����� ON �����.���������=�����.���������
	INNER JOIN ��������� ON �����.������������� = ���������.�������������
 WHERE ���������� IS NULL OR ���������� NOT BETWEEN 2 AND 20

/*6*/
 SELECT �����.���������, �����.����������,�����.������������, ������.����������
 FROM �����
	INNER JOIN ����� ON �����.���������=�����.���������
	INNER JOIN ������ ON �����.���������� = ������.����������
	INNER JOIN ������ ON ������.���������� = ������.����������
WHERE ������.������ = '������' OR ������.������='�������'
ORDER BY �����.����������, ������.����������, �����.���������� DESC

/*7*/
 SELECT * 
 FROM ������1
 WHERE(������������ LIKE '%���%' OR ������������ LIKE '%���%' OR ������������ LIKE '%a') AND ( ���������� BETWEEN 5 AND 10 OR ���������� = '�����' OR ���������� = '����')

 /*-------------2-------------*/
 
 /*1*/
UPDATE ������
 SET ���������� = '�� "�����-�"', ���������������=NULL
 WHERE ���������� = '�� "�����"'
/*2*/
 UPDATE ���������
 SET ������������� = '�� �������� ��������'
 WHERE ������������� LIKE '%�' OR ������������� LIKE '%�' OR ������������� LIKE '%�' OR ������������� NOT LIKE '���%' OR ������������� NOT LIKE '���%'
/*3*/
 UPDATE ����� 
 SET ��������� = 'RUR', ���� = ����/285
 WHERE ��������� = 'BYR' AND ���� BETWEEN 100000 AND 1000000
/*4*/
 UPDATE ����� 
 SET ��������� = 'USD', ���� = ����/9100
 WHERE ��������� = 'BYR' AND ����>1000000
/*5*/
 SET DATEFORMAT dmy

 UPDATE ����� 
 SET ������������ = ���������� + 14
 WHERE ���������� < '15.10.2020'

 UPDATE ����� 
 SET ������������ = ���������� + 10
 WHERE ���������� > '15.10.2020'

 UPDATE ����� 
 SET ������������ = ���������� + 20
 WHERE ������������� IS NULL
 
 
/*-------------3-------------*/
INSERT INTO ������
VALUES ('GRV', '���������� ������', 0.01, 250)


INSERT INTO �����
VALUES (666, '��-����������', NULL, 2630, 'GRV', '��')

INSERT INTO �����
VALUES (777, '������ USB', NULL, 135, 'GRV', '��')

INSERT INTO �����
VALUES (888, '������� Lexmark', NULL, 12790, 'GRV', '��')


INSERT INTO �����
VALUES (4, 666, 17, NULL, NULL, 345)

INSERT INTO �����
VALUES (5, 777, 5, NULL, NULL, 234)

INSERT INTO �����
VALUES (3, 888, 14, NULL, NULL, 456)

INSERT INTO �����
VALUES (5, 666, 9, NULL, NULL, 345)
GO

 ALTER TABLE ����� DROP CONSTRAINT  FK_�����_������
 ALTER TABLE ����� ADD CONSTRAINT  FK_�����_������  FOREIGN KEY (���������)
   REFERENCES  ������  ON UPDATE CASCADE ON DELETE CASCADE
GO

DELETE FROM ������ 
 WHERE ��������� = 'GRV'
 GO
 
/*-------------4-------------*/
 ALTER TABLE ����� DROP CONSTRAINT  FK_�����_������  
 GO
 
 DELETE FROM ������ 
 WHERE ��������� = 'GRV'
 GO

/*-------------5-------------*/

 EXEC sp_fkeys '���������'
 EXEC sp_fkeys @fktable_name = '�����'
 GO
 
 ALTER TABLE ����� DROP CONSTRAINT FK_�����_���������
DROP TABLE ���������
 GO
 
 EXEC sp_fkeys '������'
 GO
 EXEC sp_fkeys @fktable_name = '������'
 GO

 ALTER TABLE ������ DROP CONSTRAINT FK_������_������
 ALTER TABLE ��������� DROP CONSTRAINT FK_���������_������
 DROP TABLE ������
 GO

 DROP TABLE ���������
 GO

DROP VIEW 
IF EXISTS dbo.������1 
GO 

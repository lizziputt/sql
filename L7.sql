use �����_222

-- 1

create procedure pr_����������������������;1
	@�������� int,
	@������������� int
as
	declare @Name varchar(50), @Code int, @Quantity numeric(12, 3)

	if @������������� = 1
		select @Code = ���������, @Quantity = sum(����������)
		from ����� 
		where ���������� BETWEEN getdate() - @�������� and getdate()
		group by ���������
		order by sum(����������)
	if @������������� = 2
		select @Code = ���������, @Quantity = sum(����������)
		from ����� 
		where ���������� BETWEEN getdate() - @�������� and getdate()
		group by ���������
		order by sum(����������) desc

	select @Name = ������������
	from ����� 
	where ��������� = @Code

	select @Name as [������������ ������], @Quantity as 
	[�������� ���-��]
go

exec pr_����������������������;1 60, 2

drop procedure pr_����������������������

-- 7

create function fn_getTable_����������� ()
returns @�������������������������� table (
	����� int identity(1,1) primary key not null,
	���������� datetime null,
	���������� varchar(20) null,
	������������������ varchar(20) not null,
	���������� numeric(12, 0) not null,
	������ money check(������ > 0) not null,
	����������� money check(����������� > 0) not null)
begin
	declare @������ table (
	���������� datetime null,
	���������� varchar(40) null,
	������������������ varchar(50) not null,
	���������� numeric(12, 3) not null,
	���� money check(���� > 0) not null,
	��������� char(3) not null,
	���������� smallmoney not null,
	������ money check(������ > 0) null,
	����������� money check(����������� > 0) null)

	insert @������ (����������, ����������, ������������������, ����������, ����, ���������, ����������)
	select �����.����������, ������.����������, �����.������������, �����.����������, �����.����, ������.���������, ������.����������
		from �����
		inner join ������ on ������.���������� = �����.����������
		inner join ����� on �����.��������� = �����.���������
		inner join ������ on ������.��������� = �����.���������

	update @������
	set ������ = ���������� * ����

	update @������
	set ����������� = ������ * ����������

	declare @������������������ money
    select @������������������ = AVG(�����������)
	from @������

	insert @��������������������������
	select ����������, ����������, ������������������, ����������, ������, �����������
	from @������
	where ����������� >= @������������������

	return
end
go

drop function fn_getTable_�����������

select *
from fn_getTable_�����������()
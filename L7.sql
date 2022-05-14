use Склад_222

-- 1

create procedure pr_КолебанияСпросаТоваров;1
	@Интервал int,
	@ТипРезультата int
as
	declare @Name varchar(50), @Code int, @Quantity numeric(12, 3)

	if @ТипРезультата = 1
		select @Code = КодТовара, @Quantity = sum(Количество)
		from Заказ 
		where ДатаЗаказа BETWEEN getdate() - @Интервал and getdate()
		group by КодТовара
		order by sum(Количество)
	if @ТипРезультата = 2
		select @Code = КодТовара, @Quantity = sum(Количество)
		from Заказ 
		where ДатаЗаказа BETWEEN getdate() - @Интервал and getdate()
		group by КодТовара
		order by sum(Количество) desc

	select @Name = Наименование
	from Товар 
	where КодТовара = @Code

	select @Name as [Наименование товара], @Quantity as 
	[Итоговое кол-во]
go

exec pr_КолебанияСпросаТоваров;1 60, 2

drop procedure pr_КолебанияСпросаТоваров

-- 7

create function fn_getTable_СтоимостьНВ ()
returns @ЗаказыВышеСреднейСтоимости table (
	Номер int identity(1,1) primary key not null,
	ДатаЗаказа datetime null,
	ИмяКлиента varchar(20) null,
	НаименованиеТовара varchar(20) not null,
	Количество numeric(12, 0) not null,
	ЦенаНВ money check(ЦенаНВ > 0) not null,
	СтоимостьНВ money check(СтоимостьНВ > 0) not null)
begin
	declare @Заказы table (
	ДатаЗаказа datetime null,
	ИмяКлиента varchar(40) null,
	НаименованиеТовара varchar(50) not null,
	Количество numeric(12, 3) not null,
	Цена money check(Цена > 0) not null,
	КодВалюты char(3) not null,
	КурсВалюты smallmoney not null,
	ЦенаНВ money check(ЦенаНВ > 0) null,
	СтоимостьНВ money check(СтоимостьНВ > 0) null)

	insert @Заказы (ДатаЗаказа, ИмяКлиента, НаименованиеТовара, Количество, Цена, КодВалюты, КурсВалюты)
	select Заказ.ДатаЗаказа, Клиент.ИмяКлиента, Товар.Наименование, Заказ.Количество, Товар.Цена, Валюта.КодВалюты, Валюта.КурсВалюты
		from Заказ
		inner join Клиент on Клиент.КодКлиента = Заказ.КодКлиента
		inner join Товар on Товар.КодТовара = Заказ.КодТовара
		inner join Валюта on Валюта.КодВалюты = Товар.КодВалюты

	update @Заказы
	set ЦенаНВ = КурсВалюты * Цена

	update @Заказы
	set СтоимостьНВ = ЦенаНВ * Количество

	declare @СредняяСтоимостьНВ money
    select @СредняяСтоимостьНВ = AVG(СтоимостьНВ)
	from @Заказы

	insert @ЗаказыВышеСреднейСтоимости
	select ДатаЗаказа, ИмяКлиента, НаименованиеТовара, Количество, ЦенаНВ, СтоимостьНВ
	from @Заказы
	where СтоимостьНВ >= @СредняяСтоимостьНВ

	return
end
go

drop function fn_getTable_СтоимостьНВ

select *
from fn_getTable_СтоимостьНВ()
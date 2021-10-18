declare @command nvarchar(max);
if(object_id('tempdb..#columns') is not null)
begin
	drop table #columns
end
create table #columns
(
	DatabaseName varchar(100),
	TableName varchar(100),
	ColumnName varchar(100),
	TypeName varchar(100)
)
declare @databaseName varchar(100);
declare databasesCursor cursor for
select [name]
from sys.databases 
where database_id > 4
open databasesCursor
fetch next from databasesCursor into @databaseName
while @@fetch_status = 0 
begin
	set @command = 'use ' + @databaseName + '
	select 
	db_name() as DatabaseName,
	--dbo.GetFqn(sys.tables.[object_id]) as TableName,
	sys.tables.[name] as TableName,
	sys.columns.[name] as ColumnName,
	case 
		when sys.types.[name] in (''char'', ''varchar'') then sys.types.[name] + ''('' +
		case
			when sys.columns.max_length < 0 then ''MAX''
			else cast(sys.columns.max_length as varchar(100))
		end + '')''
		when sys.types.[name] in (''nchar'', ''nvarchar'') then sys.types.[name] + ''('' +
		case 
			when sys.columns.max_length < 0 then ''MAX''
			else cast(sys.columns.max_length / 2 as varchar(100))
		end + '')''
		else sys.types.[name]
	end as TypeName
	from sys.columns
	inner join sys.tables 
	on sys.columns.[object_id] = sys.tables.[object_id]
	and sys.tables.[type] = ''U''
	inner join sys.types
	on sys.columns.system_type_id = sys.types.system_type_id
	order by TableName, column_id
	'
	insert into #columns 
	execute sp_executesql @command
	fetch next from databasesCursor into @databaseName
end
close databasesCursor
deallocate databasesCursor

select *
from #columns
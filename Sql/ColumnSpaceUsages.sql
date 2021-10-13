use [master]
go

alter procedure [dbo].[Usages] (@databaseName nvarchar(255) = NULL, @sortColumn nvarchar(255) = null)
as
if @sortColumn is null 
begin
	set @sortColumn = 'InBytes'
end
declare @query nvarchar(max) = '';
set @query = '

declare @usages table 
(
	ColumnFqn varchar(100),
	InBytes bigint,
	InKiloBytes as InBytes / 1024,
	InMegaBytes as cast(InBytes as decimal(18,2)) / cast(1024 as decimal(18,2)) / cast(1024 as decimal(18,2))
)

declare @query nvarchar(max) = '''';
select @query = 
		@query 
		+ ''select ''''''
		+ quotename(''' + @databaseName + ''') 
		+ ''.'' 
		+ quotename(object_schema_name([object_id]
		, db_id(''' + @databaseName + '''))) 
		+ ''.'' 
		+ quotename(object_name([object_id]
		, db_id(''' + @databaseName + '''))) 
		+ ''.'' 
		+ name 
		+  ''''''
		, sum(datalength(['' + name + ''])) 
		from ''
		+ quotename(''' + @databaseName + ''') 
		+ ''.''  
		+ quotename(object_schema_name([object_id]
		, db_id(''' + @databaseName + '''))) 
		+ ''.'' 
		+ quotename(object_name([object_id], 
		db_id(''' + @databaseName + '''))) 
		+ char(10)
from [' + @databaseName + '].sys.columns 
where [object_id] in
(
	select [object_id]
	from [' + @databaseName + '].sys.tables 
	where [type] = ''U''
)

print @query;

insert into @usages 
execute sp_executesql @query

select 
	ColumnFqn, 
	replace(convert(varchar, convert(money, InBytes), 1), ''.00'', '''') as SpaceUsedInBytes, 
	replace(convert(varchar, convert(money, InKiloBytes), 1), ''.00'', '''') as SpaceUsedInKiloBytes, 
	replace(convert(varchar, convert(money, InMegaBytes), 1), ''.00'', '''') as SpaceUsedInMegaBytes
from @usages
order by ' + @sortColumn + ' desc

';

print @query

execute sp_executesql @query

GO

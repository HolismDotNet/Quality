create function dbo.IsGuid (@text nvarchar(max))
returns bit
as
begin
	declare @guid uniqueidentifier;
	declare @isGuid bit;
	set @guid = try_convert(uniqueidentifier, @text)
	if @guid is null
	begin
		set @isGuid = 0;
	end
	else
	begin
		set @isGuid = 1;
	end
	return @isGuid;
end
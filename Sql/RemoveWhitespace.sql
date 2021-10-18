create function RemoveWhitespace (@text nvarchar(max))
returns nvarchar(max)
as
begin
	return ltrim(rtrim(replace(replace(replace(replace(@text, char(10), char(32)),char(13), char(32)),char(160), char(32)),char(9),char(32))))
end
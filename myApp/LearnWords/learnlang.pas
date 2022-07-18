program LearnLang;
uses SysUtils;
const
	filename = 'dictionary.txt';
var
	f:text;
type
		translation = array [1..3] of string;
		
function SplitWords(message:string):translation;
var
	res:translation;
	i, ind:integer;
	curStr:string;
begin
	ind := 1;
	curStr := '';
	for i := 1 to length(message) do
	begin
		if (message[i] <> ' ') and 
	       (message[i] <> #9)  then
			curStr := curStr + message[i]
		else
		begin
			res[ind] := curStr;
			ind := ind + 1;
			curStr := ''
		end
	end;
	res[ind] := curStr;

	SplitWords := res
end;

procedure AddWord(lang, foreignWord, nativeWord:string);
begin
	{$I-}
	assign(f, filename);
	append(f);
	
	if IOResult <> 0 then
	begin
		writeln('Couldn''t open file');
		halt(1)
	end;

	write(f, lang, ' ');
	write(f, foreignWord, ' ');
	writeln(f, nativeWord);
	close(f)
end;

procedure CheckWord(lang, foreignWord:string);
var
	row:string;
	rowData:translation;
begin
	{$I-}
	assign(f, filename);
	reset(f);

	if IOResult <> 0 then
	begin
		writeln('Couldn''t open file');
		halt(1)
	end;

	while not SeekEof(f) do
	begin
		read(f, row);
		rowData := SplitWords(row);
		if (CompareStr(lang, rowData[1]) = 0) and
		(CompareStr(foreignWord, rowData[2]) = 0) then
		begin
			write('Found: ');
			writeln(rowData[3]);
			close(f);
			exit
		end;
		readln(f)
	end;
	close(f);
	writeln('Dictionary don''t contain this word.');
end;

var
	command:string;
begin
	command := ParamStr(1);
	
	if command = 'add' then
	begin
		if ParamCount <> 4 then
		begin
			writeln('Usage:');
			writeln('./learnlang add [lang] [foreignWord] [nativeWord]');
			halt(1);
		end;
		AddWord(ParamStr(2),ParamStr(3), ParamStr(4));
	end
	else if command = 'check' then
	begin
		if ParamCount <> 3 then
		begin
			writeln('Usage:');
			writeln('./learnlang check [lang] [foreignWord]');
			halt(1);
		end;
		CheckWord(ParamStr(2), ParamStr(3));
	end
	
end.

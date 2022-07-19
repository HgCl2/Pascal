program LearnLang;
uses SysUtils;
const
	filename = 'dictionary.txt';
var
	f:text;
type
		translation = array [1..3] of string;

function CountWords:integer;
var
	counter:integer;
	s:string;
begin
	{$I-}
	assign(f, filename);
	reset(f);
	
	if IOResult <> 0 then
	begin
		writeln('Couldn''t open file');
		halt(1)
	end;

	counter := 0;
	while not SeekEof(f) do
	begin
		read(f, s);
		readln(f);
		counter := counter + 1;
	end;

	CountWords := counter
end;


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

procedure Test(lang:string);
var
	len, i, j:integer;
	testLine, inputStr:string;
	lineData:translation;
begin
	{$I-}
	assign(f, filename);
	
	if IOResult <> 0 then
	begin
		writeln('Couldn''t open file');
		halt(1)
	end;
	
	randomize;
	len := CountWords;

	for i := 1 to len  do
	begin
		reset(f);
		for j := 1 to random(len) do
		begin
			readln(f);
		end;

		read(f, testLine);
		lineData := SplitWords(testLine);

		if lineData[1] = lang then
		begin
			write(lineData[2], ' ');
			readln(inputStr);
		end;
		if inputStr = lineData[3] then
		begin
			writeln('Right');
		end
		else
		begin
			writeln('Wrong! ', lineData[3]);
		end

	end;
end;

procedure CheckNative(nativeWord:string);
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
		if CompareStr(nativeWord, rowData[3]) = 0 then
		begin
			write('Found: ');
			writeln(rowData[2]);
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
	else if command = 'check-native' then
	begin
		if ParamCount <> 2 then
		begin
			writeln('Usage:');
			writeln('./learnlang check-native [word]');
		end;
		CheckNative(ParamStr(2));
	end
	else if command = 'test' then
	begin
		if ParamCount <> 2 then
		begin
			writeln('Usage:');
			writeln('./learnlang test [lang]');
		end;
		Test(ParamStr(2))
	end
	
end.

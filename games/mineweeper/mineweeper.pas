program saper;
uses crt;

var
	SizeOfField: array [1..6] of array [1..2] of word = 
	(
		(8, 8), (9, 9), (10, 10), (13, 15),
		(16, 16), (16, 30)
	);
	Field: array [1..30, 1..16] of char;
	Mines: array [1..480] of array [1..2] of word;
	Width, Height, MinesNum:integer;

function MineAround(x, y:integer):char;
var
	count,i:integer;
begin
	count := 0;
	for i := 1 to MinesNum do
	begin
		if (y > 1) and (Mines[i][1] = x) and
		(Mines[i][2] = y-1) then
			count := count + 1;
		if (y < Height) and (Mines[i][1] = x) and
		(Mines[i][2] = y+1) then
			count := count + 1;
		if (x > 1) and (Mines[i][1] = x-1) and
		(Mines[i][2] = y) then
			count := count + 1;
		if (x < Width) and (Mines[i][1] = x+1) and
		(Mines[i][2] = y) then
			count := count + 1;
		if (x > 1) and (y > 1) and (Mines[i][1] = x-1) and
		(Mines[i][2] = y-1) then
			count := count + 1;
		if (x > 1) and (y < Height) and (Mines[i][1] = x-1) and
		(Mines[i][2] = y+1) then
			count := count + 1;
		if (x < Width) and (y > 1) and (Mines[i][1] = x+1) and
		(Mines[i][2] = y-1) then
			count := count + 1;
		if (x < Width) and (y < Height) and (Mines[i][1] = x+1) and
		(Mines[i][2] = y+1) then
			count := count + 1;
	end;
	MineAround := Chr(Ord('0') + count);

end;

function IsWin:boolean;
var
	countHidden, i, j:integer;
begin
	countHidden := 0;

	for i := 1 to Height do
		for j := 1 to Width do
			if Field[i][j] = '#' then
				countHidden := countHidden + 1;
	if countHidden = MinesNum then
		IsWin := true
	else
		IsWin := false
end;

procedure YouWin;
var
	message:string;
begin
	message := 'You win!';
	GotoXY((ScreenWidth-length(message)) div 2, 4);
	write(message);
end;

procedure ClearAround(x, y:integer);
begin
	if (y > 1) and (Field[y-1][x] = '#') then
	begin
		Field[y-1][x] := MineAround(x, y-1);
		if Field[y-1][x] = '0' then
			ClearAround(x, y-1);
	end;

	if (y < Height) and (Field[y+1][x] = '#') then
	begin
		Field[y+1][x] := MineAround(x, y+1);
		if Field[y+1][x] = '0' then
			ClearAround(x, y+1);
	end;

	if (x > 1) and (Field[y][x-1] = '#')  then
	begin
		Field[y][x-1] := MineAround(x-1, y);
		if Field[y][x-1] = '0' then
			ClearAround(x-1, y);
	end;

	if (x < Width) and (Field[y][x+1] = '#') then
	begin
		Field[y][x+1] := MineAround(x+1, y);
		if Field[y][x+1] = '0' then
			ClearAround(x+1, y);
	end;

	if (x > 1) and (y > 1) and (Field[y-1][x-1] = '#') then
	begin
		Field[y-1][x-1] := MineAround(x-1, y-1);
		if Field[y-1][x-1] = '0' then
			ClearAround(x-1, y-1);
	end;

	if (x > 1) and (y < Height) and (Field[y+1][x-1] = '#') then
	begin
		Field[y+1][x-1] := MineAround(x-1, y+1);
		if Field[y+1][x-1] = '0' then
			ClearAround(x-1, y+1);
	end;

	if (x < Width) and (y > 1) and (Field[y-1][x+1] = '#') then
	begin
		Field[y-1][x+1] := MineAround(x+1, y-1);
		if Field[y-1][x+1] = '0' then
			ClearAround(x+1, y-1);
	end;

	if (x < Width) and (y < Height) and (Field[y+1][x+1] = '#') then
	begin
		Field[y+1][x+1] := MineAround(x+1,y+1);
		if Field[y+1][x+1] = '0' then
			ClearAround(x+1, y+1);
	end
end;

function MineCheck(x, y:integer):boolean;
var
	i:integer;
	res:boolean;
begin
	GotoXY(30, 30);
	res := false;
	for i := 1 to MinesNum do
	begin
		if (Mines[i][1] = x) and (Mines[i][2] = y) then
		begin
			res := true;
			break;
		end;
	end;	
	
	MineCheck := res
end;

function IsContain(xValue, yValue, minesContain:integer):boolean;
var
	i:integer;
	res:boolean;
begin
	res := false;
	for i := 1 to minesContain do
	begin
		if (Mines[i][1] = xValue) and
		(Mines[i][2] = yValue) then
		begin
			res := true;
			break
		end
	end;
	IsContain := res
end;

procedure GameOver;
var
	row, column:integer;
	message:string;
	isMine:boolean;
begin
	for row := 1 to Height do
	begin
		for column := 1 to Width do
		begin
			isMine := MineCheck(column, row);

			if isMine and (Field[row,column] = 'M') then
				Field[row, column] := 'R'
			else if isMine then
				Field[row, column] := '*';
		end
	end;

	message := 'Game Over!';
	GotoXY((ScreenWidth-length(message)) div 2, 4);
	write(message);
end;

procedure RandomMines;
var	
	x, y, i:integer;
label
	start;
begin
	randomize;

	for i := 1 to MinesNum do
	begin
start:
		x := random(Width) + 1;
		y := random(Height) + 1;

		if i = 1 then
		begin
			Mines[i][1] := x;
			Mines[i][2] := y;

		end
		else if not IsContain(x, y, i-1) then
		begin
			Mines[i][1] := x;
			Mines[i][2] := y;
		end
		else
			goto start;
	end

end;

procedure GetKey(var code:integer);
var
	c:char;
begin
	c := ReadKey;
	if c = #0 then
	begin
		c := ReadKey;
		code := -Ord(c)
	end
	else
		code := Ord(c);
end;

procedure RenderField(x, y:integer);
var
	i, j:integer;
begin	
	for i := 0 to Height-1 do
	begin
		GotoXY(x, y+i);
		for j := 0 to Width-1 do
		begin
			write(Field[i+1][j+1]);
		end
	end

end;

procedure FillField;
var
	row, column:integer;
begin
	for row := 1 to Height do
	begin
		for column := 1 to Width do
		begin
			Field[row][column] := '#';
		end
	end
end;

procedure GameInitialization;
var
	sizeCode:integer;
begin
	writeln('Chose size of field');
	write('1 - 8x8, 2 - 9x9, 3 - 10x10, 4 - 13x15, ');
	writeln('5 - 16x16, 6 - 16x30');
	read(sizeCode);

	Width := SizeOfField[sizeCode][1];
	Height := SizeOfField[sizeCode][2];
	FillField();

	write('Enter the number of mines: ');
	readln(MinesNum);

	clrscr
end;

var
	xCoord, yCoord, dx, dy:integer;
	code:integer;
begin
	GameInitialization();
	xCoord := (ScreenWidth - Width) div 2;
	yCoord := (ScreenHeight - Height) div 2;
	RandomMines();
	

	dx := 0;
	dy := 0;
	while true do
	begin
		RenderField(xCoord, yCoord);	
		
		GotoXY(xCoord+dx, yCoord+dy);
		GetKey(code);
		
		if (code = -75) and (dx <> 0) then
			dx := dx - 1
		else if (code = -77) and (dx <> Width-1) then
			dx := dx + 1
		else if (code = -72) and (dy <> 0) then
			dy := dy - 1
		else if (code = -80) and (dy <> Height-1) then
			dy := dy + 1;

		if code = 27 then
			break
		else if (code = 109) and (Field[dy+1][dx+1] = '#') then
			Field[dy+1][dx+1] := 'M'
		else if (code = 109) and (Field[dy+1][dx+1] = 'M') then
			Field[dy+1][dx+1] := '#'
		else if code = 32 then
		begin
			if not MineCheck(dx+1, dy+1) then
				Field[dy+1][dx+1] := MineAround(dx+1, dy+1)
       			else
		 		Field[dy+1][dx+1] := '*';

			if Field[dy+1][dx+1] = '0' then
			begin
				ClearAround(dx+1, dy+1);
			end
			else if Field[dy+1][dx+1] = '*' then
			begin
				GameOver;
				break
			end
			else if IsWin then
			begin
				YouWin;
				break
			end
		end		
		
	end;
	writeln;
	writeln
end.

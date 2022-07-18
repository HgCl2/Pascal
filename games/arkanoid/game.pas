program game;
uses crt;

const
	DelayDuration = 100;
	height = 25;
	width = 74;
type
	ball = record
		x,y,dx,dy:integer;
		isMove:boolean;
	end;
	platform = record
		x,y,len,dx:integer;
	end;
	field = array [1..height, 1..width] of char;

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

procedure ShowBall(b:ball);
begin
	GotoXY(b.x,b.y);
	write('*');
	GotoXY(1,1)
end;

procedure HidePlatform(plfm:platform; var fld:field);
var
	i:integer;
begin
	for i := 0 to plfm.len-1 do
		fld[plfm.y][plfm.x+i] := ' ';
	GotoXY(1,1);
end;

procedure Interact(b:ball; var fld:field);
begin
	if (fld[b.y][b.x + b.dx] > 'A') and 
	(fld[b.y][b.x + b.dx] <= 'Z') then
		fld[b.y][b.x+b.dx] := Chr(Ord(fld[b.y][b.x+b.dx]) - 1)
	else if fld[b.y][b.x + b.dx] = 'A' then
		fld[b.y][b.x+b.dx] := ' '
	else if (fld[b.y + b.dx][b.x] > 'A') and 
	(fld[b.y + b.dy][b.x] <= 'Z') then
		fld[b.y + b.dy][b.x] := Chr(Ord(fld[b.y+b.dy][b.x]) - 1)
	else if fld[b.y + b.dy][b.x] = 'A' then
		fld[b.y + b.dy][b.x] := ' ';
end;

procedure ShowPlatform(plfm:platform; var fld:field);
var
	i:integer;
begin
	for i := 0 to plfm.len-1 do
		fld[plfm.y][plfm.x+i] := '_';
	GotoXY(1,1)
end;

procedure MovePlatform(var plfm:platform;var fld:field);
begin
	HidePlatform(plfm, fld);
	if (plfm.x + plfm.dx + plfm.len - 1 <> width) and
	(plfm.x + plfm.dx  <> 1) then
		plfm.x := plfm.x + plfm.dx;
	ShowPlatform(plfm, fld);
	plfm.dx := 0
end;

procedure HideBall(b:ball);
begin
	GotoXY(b.x,b.y);
	write(' ');
	GotoXY(1,1)
end;

procedure MoveBall(var b:ball; var fld:field; board:platform);
begin
	if (b.x + b.dx = 1) or (b.x + b.dx = width) or
       	(fld[b.y][b.x + b.dx] <> ' ') then
	begin
		Interact(b, fld);
		b.dx := b.dx * -1;
	end;
	if b.y = height then
	begin
		b.dx := 0;
		b.dy := 0;
	end;
	if fld[b.y + b.dy][b.x] <> ' ' then
	begin
		Interact(b, fld);
		b.dy := b.dy * -1;
	end;
	
	HideBall(b);
	if b.isMove then
	begin
		b.x := b.x + b.dx;
		b.y := b.y + b.dy;
	end
	else
	begin
		b.x := board.x + board.len div 2;
	end;

	ShowBall(b);
end;

procedure RenderScreen(screen:field);
var
	row, column, i:integer;
begin
	for row := 1 to height do
	begin
		GotoXY(1,row);
		for i := 1 to width do
			write(screen[row][i]);
	end
end;

procedure DrawBorders(var screen:field);
var
	column, row,i:integer;
begin
	for column := 1 to width do
		screen[1][column] := '_';
	for row := 2 to height do
	begin
		screen[row][1] := '|';
		for i := 2 to width-1 do
			screen[row][i] := ' ';
		screen[row][width] := '|';
	end;
	GotoXY(1,1)
end;

procedure GameInitialization(var screen:field; var board:platform;
	var playball:ball); 
var
	i:integer;
begin
	DrawBorders(screen);

	board.len := 8;
	board.x := (width - board.len) div 2;
	board.y := height;
	board.dx := 0;
	
	for i := 2 to width-1 do
		screen[5][i] := 'A';	

	playball.isMove := false;
	playball.x := width div 2;
	playball.y := height - 1;
	playball.dx := 1;
	playball.dy := -1;
end;

var
	gameBall:ball;
	gameField: field;
	board: platform;
	code:integer;
begin
	clrscr;
	GameInitialization(gameField, board, gameBall);
	while true do
	begin
		if not KeyPressed then
		begin
			MoveBall(gameBall, gameField, board);
			MovePlatform(board, gameField);
		end
		else
			GetKey(code);
		
		if code = 27 then
			break
		else if code = 32 then
			gameball.isMove := true
		else if code = -75 then
			board.dx := -1
		else if code = -77 then
			board.dx := 1;
		
		delay(DelayDuration);
		RenderScreen(gameField);
	end;
	
end.

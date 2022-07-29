program matatunos;

uses dmon3b, crt, keyboard;

type
  tipo_tuno = record
     x,y    : integer;
     anim   : word;
     active : boolean;
  end;

var
  arma     : byte; 			{ 0:Pistola. 1:Escopeto. 2:Ametralleto }
  movs     : array[0..2] of byte; 	{index del moviment en cada arma}
  x,y      : integer;		        { coordenades del player }
  anim     : byte;
  offset   : integer;
  tuno     : array[1..10] of tipo_tuno;
  numtunos : byte;
  i,insert : byte;

begin
Randomize;
InitDM;
HookKb;
ClearKb;
LoadPCX('sprites.pcx', SP);
LoadPCX('fondo.pcx', IP);
movs[0] := 0; movs[1] := 4; movs[2] := 10;
arma := 1;
anim := 0;
numtunos := 0;
insert := 1;

For i := 1 to 10 do
  begin
  tuno[i].x := 303;
  tuno[i].y := Random(158-110)+110;
  tuno[i].anim := 0;
  tuno[i].active := False;
  end;

x := 100; y := 130;
Repeat

If (Random(100) > 90) and (numtunos < 10) then
  begin
  inc(numtunos);
  tuno[insert].active := True;
  If insert<10 then inc(insert) else insert := 0;
  end;

If numtunos > 0 then For i:=1 to 10 do
  If tuno[i].active then
    begin
    If tuno[i].anim=48 then
      begin
      tuno[i].x := 303;
      tuno[i].y := Random(158-110)+110;
      tuno[i].anim := 32;
      tuno[i].active := False;
      dec(numtunos);
      end;
    If tuno[i].anim=32 then tuno[i].anim:=48;
    If tuno[i].anim=16 then tuno[i].anim:=0 else
    If tuno[i].anim=0  then tuno[i].anim:=16;
    If (Random(100)>70) and (tuno[i].y<158) then inc(tuno[i].y,2);
    If (Random(100)>70) and (tuno[i].y>110) then dec(tuno[i].y,2);
    If (Random(100)>70) and (tuno[i].x>0) then dec(tuno[i].x,2);
    end;


If anim = 5 then anim := 0;
If anim = 4 then anim := 5;
If anim = 3 then anim := 4;
If anim = 2 then anim := 3;

If anim < 2 then
  begin
  If Keypress(KeyArrowLeft) then
    begin
    If x > 0 then dec(x,2);
    If anim = 0 then anim := 1 else anim := 0;
    end;
  If Keypress(KeyArrowRight) then
    begin
    If x<160 then inc(x,2);
    If x>=160 then
      begin
      inc(offset,2);
      for i := 1 to numtunos do
        If tuno[i].Active then dec(tuno[i].x,2);
      end;
    If offset >= 320 then offset := 0;
    If anim = 0 then anim := 1 else anim := 0;
    end;
  If Keypress(KeyArrowUp) then
    begin
    IF y > 110 then dec(y,2);
    If anim = 0 then anim := 1 else anim := 0;
    end;
  If Keypress(KeyArrowDown) then
    begin
    IF y < 158 then inc(y,2);
    If anim = 0 then anim := 1 else anim := 0;
    end;

  If Keypress(KeyZ) then
    begin
    anim := 2;
    for i := 0 to numtunos do
      If tuno[i].active then
        If (tuno[i].y < y+2) and (tuno[i].y > y-2) then
          tuno[i].anim := 32;
    end;
end;

  If Keypress(KeySpace) then
    begin
    case arma of
      0: arma := 1;
      1: arma := 2;
      2: arma := 0;
    end;
    end;

  Cls(1, WP);
  PutBloc16(SP,48000+offset,WP,320-offset,50 ,0         ,125);
  PutBloc16(SP,48000       ,WP,offset    ,50 ,320-offset,125);
  PutBloc16(IP,offset      ,WP,320-offset,100,0         ,25);
  PutBloc16(IP,0           ,WP,offset    ,100,320-offset,25);
  PutSprite(SP,(movs[arma]+anim)*16,0,WP,x,y,16,16);
If numtunos > 0 then For i:=1 to 10 do
  If tuno[i].active then
    PutSprite(SP,tuno[i].anim,16,WP,tuno[i].x,tuno[i].y,16,16);
  delay(50);
  WaitRetrace;
  Flip(WP, VGA);

Until Keypress(KeyEsc);

FreeKb;
EndDM;
end.
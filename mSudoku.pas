unit mSudoku;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, MPlayer, jpeg, Grids, ComCtrls, Buttons;

const
	AppName = 'Sudoku.Programm.des.Jonas.Heinle';

type TAbfolgeDerEntscheidung = array[1..81] of Record { Datenstruktur; Ein Record ist wie ein Array ein Datensatz von Daten mit dem Unterschied, dass die Komponenten nicht indirekt adressiert werden können, sondern mit konstanten Namen eines Aufzählungstyps, und daß die Komponenten verschiedenen Typ haben können.}
        op:  integer;  { = Datentyp, der ganzzahlige Werte speichert.Wertebereich ist endlich. Berechnungen mit Integern sind exakt}
        x:   integer;  { id;x;y sind die Komponenten von Record. }
        y:   integer;
        falsch: array[1..9] of integer; { array = Datenstruktur-Variante, mit deren Verwendung viele gleichartig strukturierte Daten verarbeitet werden sollen}
      end;


type   {Eine Typisierung dient dazu, dass die Objekte der Programmiersprachen, wie z. B. Variablen, Funktionen oder Objekte korrekt verwendet werden}
  TForm1 = class(TForm)
    ImSudoku_Feld: TImage;
    BtnLoesen: TButton;
    BtnMusik: TButton;
    MediaPlayer1: TMediaPlayer;
    BtnMute: TButton;
    StringGrid1: TStringGrid;
    StatusBar1: TStatusBar;
    BitBtnLoese: TBitBtn;
    Label1: TLabel;
    BtnStart: TBitBtn;
    BtnReset: TBitBtn;
    ImBackground: TImage;
    procedure FormActivate(Sender: TObject);
    procedure BtnMusikClick(Sender: TObject);
    procedure BtnMuteClick(Sender: TObject);
    procedure BtnStartClick(Sender: TObject);
    function Read(x,y:integer):string;
    procedure Write(x,y:integer;text:string);
    function CheckZeile(Zeile,Wert:integer):boolean;
    function CheckSpalte(Spalte,Wert:integer):boolean;
    function CheckBlock(Spalte,Zeile,Wert:integer):boolean;  {boolean = Datentyp; liefert wahr oder falsch; und/oder Verknüpfungen;groeser als..., kleiner als.... }
    procedure BtnResetClick(Sender: TObject);
    function Check(Spalte,Zeile,Wert:integer):boolean;
    function komplett():boolean;
    procedure leer();
    procedure BtnLoesenClick(Sender: TObject);
    procedure loesen();
    procedure BitBtnLoeseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure allcheck();

  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var   {Parameter sind in der Informatik Variablen, über die ein Computerprogramm oder Unterprogramm, für einen Aufruf gültig, auf bestimmte Werte "eingestellt" werden kann. Diese Einstellungen werden bei der Verarbeitung berücksichtigt und beeinflussen damit meist auch die Ergebnisse des Programms. Parameter sind also programmextern gesetzte Einflussfaktoren.}
  Form1: TForm1;
  freifeld:TPoint;
  falschZahl:array[1..9] of integer;
  efnummer:integer;
  checkstop:boolean; {Der Typ Boolean deklariert Variable, die zu False oder True ausgewertet werden}

implementation

{$R *.dfm}

procedure TForm1.FormActivate(Sender: TObject);
begin
     with ImSudoku_Feld.Canvas do begin
    {Rahmen setzen}
     Pen.Width := 10 ;
     Pen.Color := clRed;
     Rectangle(ImSudoku_Feld.ClientRect);

     {Bedingungen zurücksetzen}
     Pen.Color := clBlack;
     Pen.Width := 1;

    {Senkrechte Linien im Sudoku-Feld}
    MoveTo (50,0);
    LineTo (50,450);
    MoveTo (100,0);
    LineTo (100,450);
    Pen.Width := 3;
    MoveTo (150,0);
    LineTo (150,450);
    Pen.Width := 1;
    MoveTo (200,0);
    LineTo (200,450);
    MoveTo (250,0);
    LineTo (250,450);
    Pen.Width := 3;
    MoveTo (300,0);
    LineTo (300,450);
    Pen.Width := 1;
    MoveTo (350,0);
    LineTo (350,450);
    MoveTo (400,0);
    LineTo (400,450);
    Pen.Width := 3;
    MoveTo (450,0);
    LineTo (450,450);
    Pen.Width := 1;

    {Horizontale Linien im Sudoku-Feld}

    MoveTo (0,50);
    LineTo (450,50);
    MoveTo (0,100);
    LineTo (450,100);
    Pen.Width := 3;
    MoveTo (0,150);
    LineTo (450,150);
    Pen.Width := 1;
    MoveTo (0,200);
    LineTo (450,200);
    MoveTo (0,250);
    LineTo (450,250);
    Pen.Width := 3;
    MoveTo (0,300);
    LineTo (450,300);
    Pen.Width := 1;
    MoveTo (0,350);
    LineTo (450,350);
    MoveTo (0,400);
    LineTo (450,400);
    Pen.Width := 3;
    MoveTo (0,450);
    LineTo (450,450);
    Pen.Width := 1

  end
end;

procedure TForm1.BtnMusikClick(Sender: TObject);
begin
  MediaPlayer1.FileName := 'C:\Users\Jonas\Music\Sudoku.mp3';
  MediaPlayer1.Open;
  MediaPlayer1.Play;
end;
procedure TForm1.BtnMuteClick(Sender: TObject);
begin
  MediaPlayer1.FileName := 'C:\Users\Jonas\Music\Sudoku.mp3';
  MediaPlayer1.Open;
  MediaPlayer1.Stop;
end;

procedure TForm1.allcheck();
var i,j:integer;
begin
  for i:=0 to 8 do begin
    for j:=0 to 8 do begin
    if (StrToIntDef(Read(i,j),0)= 0) and (Read(i,j)<>'') then    {StrToIntDef = wandelt einen String in eine Ganzzahl oder das Standardformat um.}
     begin
      checkstop:=true;   {checkstop ist Typ boolean ---> deswegen true }
     end;
    end;
  end;
end;

procedure TForm1.loesen();
var Zeile, Spalte,Wert:integer;
begin
 leer();
 Spalte:=freifeld.X;
 Zeile:=freifeld.Y;
 if Zeile<>-1 then
 for Wert:=1 to 9 do
  if check(Spalte,Zeile,Wert)=true then
  begin
   Write(spalte,zeile,IntToStr(Wert)); {IntToStr =wandelt eine Ganzzahl in einen String um.}
   Application.ProcessMessages;
   Loesen();
  if komplett()=false then
   Write(spalte,zeile,'');
 end;
end;

procedure TForm1.leer();
var i,j,zeile,spalte:integer;
begin
  i:=0;                         {0 bedeutet im Array, das der Wert noch nicht gesetzt ist)}
  spalte:=0;
  Zeile:=0;
  while i<9 do begin
    j:=0;
    while j<9 do begin
      if (Read(i,j)='') or (Read(i,j)=' ') then begin
        spalte:=i;
        zeile:=j;
        end;
      j:=j+1;
    end;
    i:=i+1;
  end;
  freifeld.X:=spalte;
  freifeld.y:=zeile;
end;

function TForm1.CheckZeile(Zeile,Wert:integer):boolean;
var i:integer;
begin
  result:=true;
  i:=0;                  {0 bedeutet im Array, das der Wert noch nicht gesetzt ist)}
  while i<9 do begin
   if StrToIntDef(Read(i,zeile),0)=wert then      {StrToIntDef = wandelt einen String in eine Ganzzahl oder das Standardformat um.}
    begin
      result:=false;
      exit;
    end;
    i:=i+1;
   end;
end;

function TForm1.CheckSpalte(Spalte,Wert:integer):boolean;
var i:integer;
begin
  result:=true;
  i:=0;
  while i<9 do begin
   if StrToIntDef(Read(spalte,i),0)=wert then       {StrToIntDef = wandelt einen String in eine Ganzzahl oder das Standardformat um.}
    begin
      result:=false;
      exit;
    end;
    i:=i+1;
   end;
end;

function TForm1.CheckBlock(Spalte,Zeile,Wert:integer):boolean;
var i,j:integer;
begin
  result:=true;
  i:=0;

  if (Spalte<3) and (Zeile<3) then begin Spalte:=0; Zeile:=0; end;                         {1}
  if (Spalte>2) and (Spalte<6) and (Zeile<3) then begin Spalte:=3; Zeile:=0; end;          {2}
  if (Spalte>5) and (Zeile<3) then begin Spalte:=6; Zeile:=0; end;                         {3}
  if (Spalte<3) and (Zeile>2) and (Zeile<6) then begin Spalte:=0; Zeile:=3; end;           {2-1}
  if (Spalte>2) and (Spalte<6) and (Zeile>2) and (Zeile<6) then begin Spalte:=3; Zeile:=3; end;           {2-2}
  if (Spalte>5) and (Zeile>2) and (Zeile<6) then begin Spalte:=6; Zeile:=3; end;           {2-3}
  if (Spalte<3) and (Zeile>5) then begin Spalte:=0; Zeile:=6; end;                         {3-1}
  if (Spalte>2) and (Spalte<6) and (Zeile>5) then begin Spalte:=3; Zeile:=6; end;          {3-2}
  if (Spalte>5) and (Zeile>5) then begin Spalte:=6; Zeile:=6; end;                         {3-3}

  while i<3 do begin
   j:=0;
   while j<3 do begin
    if StrToIntDef(Read(Spalte+i, Zeile+j),0)=Wert then begin Result:=False; exit; end;     {StrToIntDef = wandelt einen String in eine Ganzzahl oder das Standardformat um.}
    j:=j+1;
   end;
   i:=i+1;
  end;
  end;

function TForm1.Check(Spalte,Zeile,Wert:integer):boolean;
begin
  result:=false;
   if (CheckSpalte(Spalte,Wert)=true)
   and (CheckZeile(Zeile,Wert)=true)
   and (CheckBlock(Spalte,Zeile,Wert)=true) then result:=true;
end;

function TForm1.komplett():boolean;
var i,j:integer;
begin
  result:=true;
  i:=0;
  while i<9 do begin
    j:=0;
    while j<9 do begin
     if StrToIntDef(Read(i,j),0)=0 then begin result:=false; exit; end;          {StrToIntDef = wandelt einen String in eine Ganzzahl oder das Standardformat um.}
     j:=j+1;
    end;
   i:=i+1;
   end;
end;

function TForm1.Read(x,y:integer):string;
begin
  result:=StringGrid1.Cells[x,y];     {Die Eigenschaft Cells enthält für jede Zelle des Gitters einen String;Mit Cells können Sie auf den String einer bestimmten Gitterzelle zugreifen.}

end;

procedure TForm1.Write(x,y:integer; text:string);
begin
  StringGrid1.Cells[x,y]:=text;       {Die Eigenschaft Cells enthält für jede Zelle des Gitters einen String;Mit Cells können Sie auf den String einer bestimmten Gitterzelle zugreifen.}
end;

procedure TForm1.BtnStartClick(Sender: TObject);   {Erstellen des Startfelds laut des Logarithmus auf der Wikipedia-Seite}
var i,j,x,y:Integer;                               {Programm erstellt zufällige Zahlenkombinationen ---> diese müssen aber die Regeln des Sudoku enthalten}
begin
   for i:=1 to 12 do           {i= Anzahl der max. "Anfangszahlen" im Sudoku}
      begin
        randomize;
        j:=1+random(8);
        x:=random(9);
        y:=random(9);
        if Check(x,y,j)=true then Write(x,y,IntToStr(j));    {IntToStr =wandelt eine Ganzzahl in einen String um.}
      end;

end;

procedure TForm1.BtnResetClick(Sender: TObject);
var i,j:integer;
begin
 i:=8;
 while i>-1 do begin
  j:=8;
  while j>-1 do begin
    Write(i,j,'');
    j:=j-1;
  end;
  i:=i-1;
 end;
end;

procedure TForm1.BtnLoesenClick(Sender: TObject);
begin
checkstop:=false;
allcheck();
if checkstop=false then
loesen();
end;

procedure TForm1.BitBtnLoeseClick(Sender: TObject);     {Backtracking-Algorithmus}
var i,r,k,f1,x,y,j:integer;
    ef:TAbfolgeDerEntscheidung;
    gefunden:boolean;
begin
    i:=0;     {0 bedeutet im Array, das der Wert noch nicht gesetzt ist)}
    r:=0;
    k:=0;
     while i<1000 do begin
      gefunden:=false;
      leer;
      x:= Freifeld.X;
      y:= Freifeld.Y;
      j:=1;
      while j<10 do begin
       if Check(x,y,j)=true then begin
        if j<>ef[efnummer].falsch[j] then begin
         Write(x,y,IntToStr(j));                                  {IntToStr =wandelt eine Ganzzahl in einen String um.}
         efnummer:=efnummer+1;
         ef[efnummer].Op:=j;
         ef[efnummer].X:=x;
         ef[efnummer].Y:=y;
         gefunden:=true;
         break;
         end;
         end;
          while r<9 do begin
            if r=ef[efnummer].falsch[r] then k:=k+1;
            r:=r+1;
          end;
          if k>7 then
          begin
           efnummer:=efnummer-1;
           f1:=ef[efnummer].op;
           ef[efnummer].falsch[f1]:=f1;
           Write(ef[efnummer].x,ef[efnummer].y,'');
           gefunden:=true;
          end;


       j:=j+1;
       end;
      if gefunden=false then
      begin
        efnummer:=efnummer;
        ef[efnummer].falsch[j]:=j;
      end;
     i:=i+1;
     end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
efnummer:=0;          { 0 bedeutet im Array, das der Wert noch nicht gesetzt ist) }
end;




end.

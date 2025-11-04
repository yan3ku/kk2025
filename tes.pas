Program Testing;
(*Uses crt, dos;*)
Const (* range of displayed characters *)
    minASCII = 30;
    maxASCII = 255;
    tekst = 'test string';
Var
   c : Char;
   r : real;
   i, i1, _i, _00 : Integer;
   t : array[1..10] of integer;
   d :  record
           year, month : integer;
           day        :  integer
        end;

Procedure Empty_Without_Parameters;
Begin
End;

Function Empty_With_Parameters( a : Integer, c : Char, r : Real ) : Integer;
Begin
End;

Procedure With_Declarations;
Const
   r1 = 12.34;
   r2 = 0.56;
   r3 = 78.0;
Var
   s : String;
   t : array[1..10] of integer;
   d :  record
       year, month : integer;
       day        :  integer
    end;
Begin
End;


Begin (* main block *)
   Empty_Without_Parameters;
   Empty_With_Parameters( 123, 'c', 12.34 );
   ClrScr; (* intro opn clear screen *)
   Writeln( 'Kody ASCII (30-255):' );
   For i := minASCII To maxASCII Do (* display of given ASCII codes *)
      Write( Chr( i ), '   ' );
   ReadKey; (* wait for a key press *)
   i := ( i1 + 3 ) * _00;
   (* conditional instruction *)
   if  a > 10
      then
      b := a;
   if ( a > 1 )
      then
      b := a
   else
      b := 1;
   if ( a > b )
      then
      if ( a > c )
     then
     m := a
      else
     m := c
      else
     if ( b > c )
        then
        m := b
     else
        m := c;
   t[10] := 1;
   for i := 9 downto 1 do t[i] := t[i+1] * i * i;
   d.year := 2018;
   d.day := 1;
   d.month := d.day * 10;
End.

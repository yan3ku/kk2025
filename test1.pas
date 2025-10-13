Program ASCII; (* Displays ASCII codes *)
Uses
   crt, dos;
{$I MyFile.inc}
Var
   i : Integer;
   c : Char;
   r : real;
   t : array[1..10] of integer;
   d :  record
       year, month	: integer;
       day	:  integer;
    end;
Const	(* range of displayed characters *)
   minASCII = 30;
   maxASCII = 255;
Begin
   ClrScr(); (* intro on clear screen *)
   Write('ASCII codes from 30 to 255: '); WriteLn('(20 per line):');
   For i := minASCII To maxASCII Do (* display of given ASCII codes *)
      Write( Chr( i ) : 4 );
   ReadKey; (* wait for a key press *)
   r := 12.34e-12 * ( 56.0 + 0.78 ); { test of real numbers }
   i := minASCII + 2 * (20 + maxASCII );
   t[10] := 1;
   for i := 9 downto 1 do t[i] := t[i+1] * i * i;
   d.year := 2018;
   d.day := 1;
   d.month := d.day * 10;
End.

Program ASCII; (* Displays ASCII codes *)
Uses
    crt, dos;
{$I MyFile.inc}
Var
    i : Integer;
    c : Char;
    r : real;
Const	(* range of displayed characters *)
    minASCII = 30;
    maxASCII = 255;
Begin
    ClrScr(); (* intro on clear screen *)
    Writeln( 'ASCII codes from 30 to 255: (20 per line):' );
    For i := minASCII To maxASCII Do (* display of given ASCII codes *)
        Write( Chr( i ) : 4 );
    ReadKey; (* wait for a key press *)
    r := 12.34 * ( 56.0 + 0.78 ); { test of real numbers }
    i := minASCII + 2 * (20 + maxASCII );
    *) { unopened comment }
    }  { unopened comment }
    { multiline
     comment 1 }
    (* multiline
    comment 2 *)
    { unfinished comment ...
End.

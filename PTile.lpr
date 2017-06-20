program PTile;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, Windows;

procedure WinEventCallback();
begin
end;

begin
  WriteLn('Hello, world!');
  ReadLn;
end.


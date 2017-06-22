library LibHookProc;

{$mode objfpc}{$H+}
{$calling stdcall}

uses
  Classes, Windows;

type
  HINSTANCE = HANDLE;
  HOOKPROC = {%H-}function(
      NCode: Integer;
      WParam: WPARAM;
      LParam: LPARAM
    ): LRESULT;

var
  HInst: HINSTANCE;
  CBTHook: HHOOK;

function CBTCallback(
    NCode: Integer;
    WParam: WPARAM;
    LParam: LPARAM
): LRESULT; forward;

function DllMain(
    HInstDLL: HINSTANCE;
    {%H-}Reason: DWORD;
    {%H-}Reserved: LPVOID): LongBool;
begin
  HInst  := HInstDLL;
  Result := True;
end;

procedure InstallHooks;
begin
  CBTHook := SetWindowsHookExW(WH_CBT, @CBTCallback, HInst, 0);
end;

procedure UninstallHooks;
begin
  UnhookWindowsHookEx(CBTHook);
end;

function CBTCallback(
    NCode: Integer;
    WParam: WPARAM;
    LParam: LPARAM
): LRESULT;
begin
  WriteLn('.'); // This may not work.
  CallNextHookEx(CBTHook, NCode, WParam, LParam);
  Result := 0;
end;

exports DllMain;
exports InstallHooks;
exports UninstallHooks;

begin
end.


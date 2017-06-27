program PTile;

{$mode objfpc}{$H+}
{$calling stdcall}

uses
  Classes, Windows;

type
  HINSTANCE = HANDLE;
  HWINEVENTHOOK = HANDLE;
  WINEVENTPROC = procedure(
    EventHook: HWINEVENTHOOK;
    Event: DWORD;
    HWnd: HWND;
    IDObject, IDChild: LONG;
    EventThread, EventTime: DWORD);
  TInstallProcedure = procedure;
  TUninstallProcedure = procedure;

const
  WINEVENT_OUTOFCONTEXT = $0000;
  EVENT_OBJECT_CREATE   = $8000;
  EVENT_OBJECT_DESTROY  = $8001;
  OBJID_WINDOW          = $0000;
  INDEXID_CONTAINER     = $0000;

function SetWinEventHook(
  EventMin, EventMax: UINT;
  HMod: HMODULE;
  EventProc: WINEVENTPROC;
  IDProcess, IDThread: DWORD;
  Flags: UINT): HWINEVENTHOOK; external 'User32.dll';

function UnhookWinEvent(
  EventHook: HWINEVENTHOOK): LongBool; external 'User32.dll';

function {%H-}EnumWindowsCallback(
  {%H-}HWnd: HWND;
  {%H-}LParam: LPARAM): LongBool;
begin
  Result := True;
  WriteLn('.');
end;

procedure WinEventCallback(
  {%H-}EventHook: HWINEVENTHOOK;
  {%H-}Event: DWORD;
  {%H-}HWnd: HWND;
  {%H-}IDObject, {%H-}IDChild: LONG;
  {%H-}EventThread, {%H-}EventTime: DWORD);
var
  Len: LongInt;
  Title: array of WideChar;
  LStyle: LONG;
begin
  if not ((Event = EVENT_OBJECT_CREATE) and
          (IDObject = OBJID_WINDOW) and
          (IDChild = INDEXID_CONTAINER)) then
    exit;

  Len := GetWindowTextLengthW(HWnd) + 1;
  if Len - 1 = 0 then
    exit;

  SetLength(Title, Len);
  GetWindowTextW(HWnd, @Title[0], Len);

  LStyle := GetWindowLong(HWnd, GWL_STYLE);
  if LStyle = 0 then
    exit;

  //if (LStyle and WS_BORDER) <> WS_BORDER then
  //  exit;

  WriteLn(WideCharToString(@Title[0]));
end;

var
  {%H-}Message: TMsg;
  {%H-}EventHook: HWINEVENTHOOK;
  LibHookProc: HINSTANCE;
  InstallHooks: TInstallProcedure;
  UninstallHooks: TUninstallProcedure;
begin
  LibHookProc := LoadLibrary('LibHookProc/LibHookProc.dll');
  if LibHookProc = 0 then
    exit;

  InstallHooks := TInstallProcedure(GetProcAddress(LibHookProc, 'InstallHooks'));
  UninstallHooks := TUninstallProcedure(GetProcAddress(LibHookProc, 'UninstallHooks'));

  InstallHooks;

  while GetMessage(Message, 0, 0, 0) do
  begin
    TranslateMessage(Message);
    DispatchMessage(Message);
  end;

  UninstallHooks;

  {
  Message := Default(TMsg);
  EventHook := SetWinEventHook(EVENT_OBJECT_CREATE, EVENT_OBJECT_DESTROY, 0,
    @WinEventCallback, 0, 0, WINEVENT_OUTOFCONTEXT);

  while GetMessage(Message, 0, 0, 0) do
  begin
    TranslateMessage(Message);
    DispatchMessage(Message);
  end;

  if EventHook <> 0 then
    UnhookWinEvent(EventHook);
  }
end.


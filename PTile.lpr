program PTile;

{$mode objfpc}{$H+}
{$calling stdcall}

uses
  Classes, Windows;

type
  HWINEVENTHOOK = HANDLE;
  WINEVENTPROC = procedure(
    EventHook: HWINEVENTHOOK;
    Event: DWORD;
    HWnd: HWND;
    IDObject, IDChild: LONG;
    EventThread, EventTime: DWORD);

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
  LStyle: LONG;
begin
  if not ((Event = EVENT_OBJECT_CREATE) and
          (IDObject = OBJID_WINDOW) and
          (IDChild = INDEXID_CONTAINER)) then
    exit;

  LStyle := GetWindowLong(HWnd, GWL_STYLE);
  if LStyle = 0 then
    exit;

  if (LStyle and WS_BORDER) <> WS_BORDER then
    exit;

  WriteLn('.');
end;

var
  Message: TMsg;
  EventHook: HWINEVENTHOOK;
begin
  Message := Default(TMsg);
  EventHook := SetWinEventHook(EVENT_OBJECT_CREATE, EVENT_OBJECT_DESTROY, 0,
    @WinEventCallback, 0, 0, WINEVENT_OUTOFCONTEXT);

  while GetMessage(Message, 0, 0, 0) do
  begin
    DispatchMessage(Message);
  end;

  if EventHook <> 0 then
    UnhookWinEvent(EventHook);
end.


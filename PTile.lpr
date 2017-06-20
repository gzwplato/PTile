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

function SetWinEventHook(
  EventMin, EventMax: UINT;
  HMod: HMODULE;
  EventProc: WINEVENTPROC;
  IDProcess, IDThread: DWORD;
  Flags: UINT): HWINEVENTHOOK; external 'User32.dll';

function UnhookWinEvent(
  EventHook: HWINEVENTHOOK): LongBool; external 'User32.dll';

procedure WinEventCallback(
  EventHook: HWINEVENTHOOK;
  Event: DWORD;
  HWnd: HWND;
  IDObject, IDChild: LONG;
  EventThread, EventTime: DWORD);
begin
  WriteLn('.');
end;

var
  EventHook: HWINEVENTHOOK;
begin
  EventHook := SetWinEventHook(EVENT_OBJECT_CREATE, EVENT_OBJECT_DESTROY, 0,
    @WinEventCallback, 0, 0, WINEVENT_OUTOFCONTEXT);

  ReadLn;

  if EventHook <> 0 then
    UnhookWinEvent(EventHook);
end.


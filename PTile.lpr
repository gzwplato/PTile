program PTile;

{$mode objfpc}{$H+}

uses
  Classes, Windows;

type
  HWINEVENTHOOK = HANDLE;
  WINEVENTPROC = procedure(
    EventHook: HWINEVENTHOOK;
    Event: DWORD;
    HWnd: HWND;
    IDObject, IDChild: LONG;
    EventThread, EventTime: DWORD); cdecl;

const
  EVENT_OBJECT_CREATE  = $8000;
  EVENT_OBJECT_DESTROY = $8001;

function SetWinEventHook(
  EventMin, EventMax: UINT;
  HMod: HMODULE;
  EventProc: WINEVENTPROC;
  IDProcess, IDThread: DWORD;
  Flags: UINT): HWINEVENTHOOK; cdecl; external 'User32.dll';

function UnhookWinEvent(
  EventHook: HWINEVENTHOOK): boolean; cdecl; external 'User32.dll';

procedure WinEventCallback(
  EventHook: HWINEVENTHOOK;
  Event: DWORD;
  HWnd: HWND;
  IDObject, IDChild: LONG;
  EventThread, EventTime: DWORD); cdecl;
begin
  WriteLn('.');
end;

var
  EventHook: HWINEVENTHOOK;
begin
  EventHook := SetWinEventHook(EVENT_OBJECT_CREATE, EVENT_OBJECT_DESTROY, 0,
    @WinEventCallback, 0, 0, 0);

  ReadLn;

  if EventHook <> 0 then
    UnhookWinEvent(EventHook);
end.


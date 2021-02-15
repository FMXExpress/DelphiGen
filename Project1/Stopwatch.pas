unit Stopwatch;

interface

uses
  WinProcs;

Type
  Stopwatch_struct = record
    running: boolean;
    last_time: double;
    total: double;
  end;

  PStopwatch = ^Stopwatch_struct;



  function seconds(): double;

  procedure Stopwtach_reset(Q: PStopwatch);
  function new_Stopwatch(): PStopwatch;
  procedure Stopwatch_delete(S: PStopwatch);
  procedure Stopwatch_start(Q: PStopwatch);
  procedure Stopwatch_resume(Q: PStopwatch);
  procedure Stopwatch_stop(Q: PStopwatch);
  function Stopwatch_read(Q: PStopwatch): double;

implementation

function seconds: double;
begin
  Result := GetTickCount / 1000.0;
end;

procedure Stopwtach_reset(Q: PStopwatch);
begin
    Q^.running := false;
    Q^.last_time := 0.0;
    Q^.total := 0.0;
end;

function new_Stopwatch(): PStopwatch;
begin
  GetMem(result, sizeof(Stopwatch_struct));

  if (Result <> nil) then
    Stopwtach_reset(Result);
end;

procedure Stopwatch_delete(S: PStopwatch);
begin
    if (S <> nil) then
        FreeMem(S);
end;

procedure Stopwatch_start(Q: PStopwatch);
begin
  if (not (Q^.running)  ) then
  begin
      Q^.running := true;
      Q^.total := 0.0;
      Q^.last_time := seconds();
  end;
end;

procedure Stopwatch_resume(Q: PStopwatch);
begin
    if (not (Q^.running)) then
    begin
        Q^.last_time := seconds();
        Q^.running := true;
    end;
end;

procedure Stopwatch_stop(Q: PStopwatch);
begin
    if (Q^.running) then
    begin
        Q^.total := Q^.total + seconds() - Q^.last_time;
        Q^.running := false;
    end;
end;

function Stopwatch_read(Q: PStopwatch): double;
var
  t: double;
begin
    if (Q^.running) then
    begin
        t := seconds();
        Q^.total := Q^.total + t - Q^.last_time;
        Q^.last_time := t;
    end;

    result :=  Q^.total;
end;

end.

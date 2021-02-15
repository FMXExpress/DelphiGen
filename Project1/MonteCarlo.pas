unit MonteCarlo;

interface

uses
  Random;

const
  SEED = 113;

function MonteCarlo_integrate(Num_samples: integer): double;
function MonteCarlo_num_flops(Num_samples: integer): double;

implementation

function MonteCarlo_integrate(Num_samples: integer): double; {$IFDEF INLINE} inline; {$ENDIF}
Var
  R: PRandom;
  under_curve, count: integer;
  x, y: double;

begin
  R := new_Random_seed(SEED);

  under_curve := 0;

  for count := 0 to Num_samples - 1 do
  begin
    Random_nextDouble(R, x);
    Random_nextDouble(R, y);

    if (x * x + y * y <= 1.0) then
      inc(under_curve);
  end;

  Random_delete(R);

  result := (under_curve / Num_samples) * 4.0;
end;

function MonteCarlo_num_flops(Num_samples: integer): double; {$IFDEF INLINE} inline; {$ENDIF}
begin
  result := Num_samples * 4.0;
end;

end.

unit SparseCompRow;

interface

uses ArrayInline2D;

{$IFDEF WIN64}
{$DEFINE DOINLINE}
{$ENDIF}
{$IFDEF DOINLINE}
{$DEFINE INLINE}
{$ENDIF}

function SparseCompRow_num_flops(N, nz, num_iterations: integer): double; {$IFDEF INLINE} inline; {$ENDIF}

procedure SparseCompRow_matmult(M: integer; y: PDoubleArrayInline; val: PDoubleArrayInline;
  row, col: PIntegerArrayInline; x: PDoubleArrayInline; NUM_ITERATIONS: integer); {$IFDEF INLINE} inline; {$ENDIF}

implementation

function SparseCompRow_num_flops(N, nz, num_iterations: integer): double; {$IFDEF INLINE} inline; {$ENDIF}
var
  actual_nz: integer;
begin
  actual_nz := (nz div N) * N;
//  result := actual_nz * 2 * num_iterations;
  result := actual_nz * 2 * Int64(num_iterations);
end;

procedure SparseCompRow_matmult(M: integer; y: PDoubleArrayInline; val: PDoubleArrayInline;
  row, col: PIntegerArrayInline; x: PDoubleArrayInline; NUM_ITERATIONS: integer); {$IFDEF INLINE} inline; {$ENDIF}
var
  reps, r, i: integer;
  sum: double;
  rowR, rowRp1: integer;
begin
  for reps := 0 to NUM_ITERATIONS - 1 do
  begin
    for r := 0 to M - 1 do
    begin
      sum := 0.0;
      //rowR := row[r];
      //rowRp1 := row[r + 1];
      //for i := rowR to rowRp1 - 1 do
      //  sum := sum + x[col[i]] * val[i];
      for i := row[r] to row[r + 1] - 1 do
        sum := sum + x[col[i]] * val[i];

      y[r] := sum;
    end;
  end;
end;

end.

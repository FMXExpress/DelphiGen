unit Random;

interface

uses
  SysUtils, StrUtils, Math, Array2D, ArrayInline2D;

type
  Random_struct = record
    m: array [0 .. 16] of integer;
    seed: integer;
    i: integer; { originally = 4 }
    j: integer; { originally =  16 }
    haveRange: boolean; { = false; }
    left: double; { = 0.0; }
    right: double; { = 1.0; }
    width: double; { = 1.0; }
  end;

  PRandom = ^Random_struct;

function new_Random_seed(seed: integer): PRandom;  {$IFDEF INLINE} inline; {$ENDIF}
procedure Random_nextDouble(R: PRandom; var Return: double); {$IFDEF INLINE} inline; {$ENDIF}
procedure Random_delete(R: PRandom); {$IFDEF INLINE} inline; {$ENDIF}
function RandomVector(N: integer; R: PRandom): PDoubleArray; {$IFDEF INLINE} inline; {$ENDIF}
function RandomMatrix(m, N: integer; R: PRandom): PArrayofDoubleArray; {$IFDEF INLINE} inline; {$ENDIF}
function RandomVectorInline(N: integer; R: PRandom): PDoubleArrayInline; {$IFDEF INLINE} inline; {$ENDIF}
function RandomMatrixInline(m, N: integer; R: PRandom): PArrayofDoubleArrayInline; {$IFDEF INLINE} inline; {$ENDIF}

implementation

const
  MDIG = 32;
  ONE = 1;

  m1 = (ONE shl (MDIG - 2)) + ((ONE shl (MDIG - 2)) - ONE);
  m2 = ONE shl (MDIG div 2);

Var
  dm1: double;

procedure initialize(R: PRandom; seed: integer); {$IFDEF INLINE} inline; {$ENDIF}
Var
  jseed, k0, k1, j0, j1, iloop: Integer;

begin
  dm1 := 1.0 / m1;

  R^.seed := seed;

  if (seed < 0) then
    seed := -seed; { seed = abs(seed) }
  jseed := ifthen(seed < m1, seed, m1); { jseed = min(seed, m1) }
  if (jseed mod 2) = 0 then
    dec(jseed);
  k0 := 9069 mod m2;
  k1 := 9069 div m2;
  j0 := jseed mod m2;
  j1 := jseed div m2;

  for iloop := 0 to 16 do
  begin
    jseed := j0 * k0;
    j1 := ((jseed div m2) + j0 * k1 + j1 * k0) mod (m2 div 2);
    j0 := jseed mod m2;
    R^.m[iloop] := j0 + m2 * j1;
  end;

  R^.i := 4;
  R^.j := 16;
end;

function new_Random_seed(seed: integer): PRandom; {$IFDEF INLINE} inline; {$ENDIF}
Var
  R: PRandom;
Begin
  GetMem(R, sizeof(Random_struct));

  initialize(R, seed);
  R^.left := 0.0;
  R^.right := 1.0;
  R^.width := 1.0;
  R^.haveRange := false;

  Result := R;
End;

function new_Random(seed: integer; left, right: double): PRandom; {$IFDEF INLINE} inline; {$ENDIF}
Var
  R: PRandom;
Begin
  GetMem(R, sizeof(Random_struct));

  initialize(R, seed);
  R^.left := left;
  R^.right := right;
  R^.width := right - left;
  R^.haveRange := true;

  Result := R;
End;

procedure Random_nextDouble(R: PRandom; var Return: double); {$IFDEF INLINE} inline; {$ENDIF}
Var
  k, I, j: Integer;
  m: PIntegerArray;
Begin
  I := R^.i;
  j := R^.j;
  m := @R^.m[0];

  k := m[I] - m[j];
  if (k < 0) then
    inc(k, m1);
  R^.m[j] := k;

  if (I = 0) then
    I := 16
  else
    dec(I);

  R^.i := I;

  if (j = 0) then
    j := 16
  else
    dec(j);

  R^.j := j;

  if (R^.haveRange) then
    Return := (R^.left + dm1 * k * R^.width)
  else
    Return := dm1 * k;
End;

procedure Random_delete(R: PRandom); {$IFDEF INLINE} inline; {$ENDIF}
Begin
  FreeMem(R);
End;

function RandomVector(N: integer; R: PRandom): PDoubleArray; {$IFDEF INLINE} inline; {$ENDIF}
Var
  i: Integer;
Begin
  GetMem(Result, sizeof(double) * N);

  for i := 0 to N - 1 do
     Random_nextDouble(R, Result[i]);
End;

function RandomMatrix(m, N: integer; R: PRandom): PArrayofDoubleArray; {$IFDEF INLINE} inline; {$ENDIF}
Var
  i, j: integer;
Begin
  { allocate matrix }

  GetMem(Result, sizeof(PDoubleArray) * m);

  if (Result = nil) then
    exit(nil);

  for i := 0 to m - 1 do
  begin
    GetMem(Result[i], sizeof(double) * N);

    if Result[i] = nil then
    begin
      FreeMem(Result);
      exit(nil);
    end;

    for j := 0 to N - 1 do
      Random_nextDouble(R, Result[i][j]);
  end;

End;

function RandomVectorInline(N: integer; R: PRandom): PDoubleArrayInline; {$IFDEF INLINE} inline; {$ENDIF}
Var
  i: Integer;
Begin
  GetMem(Result, sizeof(double) * N);

  for i := 0 to N - 1 do
     Random_nextDouble(R, Result[i]);
End;

function RandomMatrixInline(m, N: integer; R: PRandom): PArrayofDoubleArrayInline; {$IFDEF INLINE} inline; {$ENDIF}
Var
  i, j: integer;
Begin
  { allocate matrix }

  GetMem(Result, sizeof(PDoubleArray) * m);

  if (Result = nil) then
    exit(nil);

  for i := 0 to m - 1 do
  begin
    GetMem(Result[i], sizeof(double) * N);

    if Result[i] = nil then
    begin
      FreeMem(Result);
      exit(nil);
    end;

    for j := 0 to N - 1 do
      Random_nextDouble(R, Result[i][j]);
  end;

End;

end.

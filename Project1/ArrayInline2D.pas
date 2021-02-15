Unit ArrayInline2D;

Interface

  Uses Sysutils;

{$DEFINE DOINLINE}
{$IFDEF DOINLINE}
{$DEFINE INLINE}
{$ENDIF}

Type
  TIntegerArrayInline = Array [0 .. (MaxInt div sizeof(Integer)) - 1] of Integer;
  PIntegerArrayInline = ^TIntegerArrayInline;

  TDoubleArrayInline = Array [0 .. (MaxInt div sizeof(Double)) - 1] of Double;
  PDoubleArrayInline = ^TDoubleArrayInline;

  TArrayofDoubleArrayInline = Array [0 .. (MaxInt div sizeof(PDoubleArrayInline)) - 1] of PDoubleArrayInline;
  PArrayofDoubleArrayInline = ^TArrayofDoubleArrayInline;


  function new_Array2D_double_Inline(M, N: integer): PArrayofDoubleArrayInline; {$IFDEF INLINE} inline; {$ENDIF}
  procedure Array2D_double_delete_Inline(M, N: integer; A: PArrayofDoubleArrayInline); {$IFDEF INLINE} inline; {$ENDIF}
  procedure Array2D_double_copy_Inline(M, N: integer; B, A: PArrayofDoubleArrayInline); {$IFDEF INLINE} inline; {$ENDIF}

Implementation


function new_Array2D_double_Inline(M, N: integer): PArrayofDoubleArrayInline; {$IFDEF INLINE} inline; {$ENDIF}
Var
  i: Integer;
  failed: boolean;

Begin
  i := 0;
  failed := false;

  GetMem(Result, sizeof(pointer) * M);

  if (Result = nil) then
    exit(nil);

  for i := 0 to M - 1 do
  begin
    GetMem(Result[i], N * sizeof(Double));

    if (Result[i] = nil) then
    begin
      failed := true;
      break;
    end;
  end;

  {
    if we didn't successfully allocate all rows of A
    clean up any allocated memory (i.e. go back and free
    previous rows) and return NULL
  }

  if (failed) then
  begin
    while (i >= 0) do
    begin
      dec(i);
      FreeMem(Result[i]);
    end;

    FreeMem(Result);
    exit(nil);
  end;
End;

procedure Array2D_double_delete_Inline(M, N: integer; A: PArrayofDoubleArrayInline); {$IFDEF INLINE} inline; {$ENDIF}
Var
  i: integer;
begin
  if (A = nil) then
    exit;

  for i := 0 to M - 1 do
    FreeMem(A[i]);

  FreeMem(A);
end;

procedure Array2D_double_copy_Inline(M, N: integer; B, A: PArrayofDoubleArrayInline); {$IFDEF INLINE} inline; {$ENDIF}
Var
 remainder,i, j: integer;
 Ai, Bi: PDoubleArrayInline;
        
Begin
  remainder := N and 3; // N mod 4

  for i := 0 to M-1 do
  Begin
    Bi := B[i];
    Ai := A[i];
      
    for j:=0 to remainder-1 do
        Bi[j] := Ai[j];
          
    j := remainder;
    while (j < N) do
    Begin
        Bi[j] := Ai[j];
        Bi[j+1] := Ai[j+1];
        Bi[j+2] := Ai[j+2];
        Bi[j+3] := Ai[j+3];

        inc(j, 4);
    End;
  End;
End;

End.

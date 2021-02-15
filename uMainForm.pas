unit uMainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.Layouts,
  FMX.Edit;

type
  TMainForm = class(TForm)
    Memo1: TMemo;
    Memo2: TMemo;
    Button1: TButton;
    Memo3: TMemo;
    MaterialOxfordBlueSB: TStyleBook;
    Layout1: TLayout;
    Button2: TButton;
    Layout2: TLayout;
    Button3: TButton;
    Edit1: TEdit;
    IterationEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    ProjectsEdit: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

uses
  System.IOUtils;

procedure TMainForm.Button1Click(Sender: TObject);
var
LSList: TStringList;
begin
  LSList := TStringList.Create;
  try
    LSList.Append(Memo1.Lines.Text.Replace('[[iteration]]','1'));

    for var I := 0 to IterationEdit.Text.ToInteger do
      LSList.Append(Memo2.Lines.Text.Replace('[[number]]',I.ToString));

    LSList.Append(Memo3.Lines.Text);

    LSList.SaveToFile(TPath.Combine(Edit1.Text,'LU.pas'));
  finally
    LSList.Free;
  end;
end;

procedure TMainForm.Button2Click(Sender: TObject);
var
  LDirectory: String;
  LNewDirectory: String;
  LIndex: Integer;
begin
  LDirectory := Edit1.Text;
  for LIndex := 2 to ProjectsEdit.Text.ToInteger do
  begin
    LNewDirectory := LDirectory.Replace('Project1','Project'+LIndex.ToString);
    if TDirectory.Exists(LNewDirectory) then
      TDirectory.Delete(LNewDirectory,True);
    TDirectory.Copy(LDirectory,LNewDirectory);
  end;
end;

procedure TMainForm.Button3Click(Sender: TObject);
var
  LDirectory: String;
begin
  SelectDirectory('Locate','c:\D\One-Billion-Lines-Of-Object-Pascal-Code-1msci\Project1',LDirectory);
  Edit1.Text := LDirectory;
end;

end.

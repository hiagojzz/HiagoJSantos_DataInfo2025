unit ConexaoSQL;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Comp.Client, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.ODBCBase,
  FireDAC.Phys.MSSQL, FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.Phys.Intf, Data.DB,
  FireDAC.Phys.MSSQLDef;

type
  TForm1 = class(TForm)
    FDConnection: TFDConnection;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure ConfigureConnection;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.ConfigureConnection;
begin
  try
    FDConnection.Connected := False;

    FDConnection.DriverName := 'MSSQL';
    FDConnection.Params.Clear;

    FDConnection.Params.Add('Server=INFOBAC01');
    FDConnection.Params.Add('Database=ClassificacaoProvas');
    FDConnection.Params.Add('User_Name=sa');
    FDConnection.Params.Add('Password=root');
    FDConnection.Params.Add('OSAuthent=No');

    FDConnection.LoginPrompt := False;
    FDConnection.Connected := True;
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao conectar ao banco de dados: ' + E.Message);
    end;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  ConfigureConnection;
end;

end.

program Classificacao_DataInfo2025;

uses
  Vcl.Forms,
  Vcl.Dialogs,
  uFrmClassificacao in 'uFrmClassificacao.pas' {frmClassificacao},
  ConexaoSQL in '..\Dao\ConexaoSQL.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfrmClassificacao, frmClassificacao);
  frmClassificacao.ShowModal;
  Application.Run;
end.


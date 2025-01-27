unit uFrmClassificacao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Data.DB,
  Data.Win.ADODB, Vcl.ExtCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, System.UITypes;

type
  TfrmClassificacao = class(TForm)
    btnGerar: TBitBtn;
    btnFechar: TButton;
    plTop: TPanel;
    plCenter: TPanel;
    LB_TIT_CLA: TLabel;
    qryProvas: TFDQuery;
    qryClassAtleta: TFDQuery;
    qryClassCidade: TFDQuery;
    qryIncClassif: TFDQuery;
    qryExcluir: TFDQuery;
    qryMarcas: TFDQuery;
    procedure btnGerarClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    Pos: Integer;
    marcaAnt: Double;
    procedure PGerarClassificacao;
    procedure PClassifica(vCodProva: Integer);
    procedure PGravaClassificacao(vPosicao: Integer; vCodProva: Integer);
    procedure PExcluirClassificacao;
    procedure PGerarArquivo;
  public
    { Public declarations }
  end;

var
  frmClassificacao: TfrmClassificacao;

implementation

{$R *.dfm}

uses ConexaoSQL;

{ TfrmClassificacao }

procedure TfrmClassificacao.btnGerarClick(Sender: TObject);
begin
  PGerarClassificacao;
  PGerarArquivo;
  MessageDlg('Classificação gerada com sucesso!', mtInformation, [mbOK], 0);
end;

procedure TfrmClassificacao.btnFecharClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmClassificacao.FormShow(Sender: TObject);
begin
  frmClassificacao.Left := (Screen.Width div 2) - (frmClassificacao.Width div 2);
  frmClassificacao.Top := (Screen.Height div 2) - (frmClassificacao.Height div 2);
end;

procedure TfrmClassificacao.PClassifica(vCodProva: Integer);
begin
  Inc(Pos);
  if ((marcaAnt <> 0) and (marcaAnt = qryMarcas.FieldByName('MARCA').AsFloat)) then
    Dec(Pos);

  if ((qryMarcas.FieldByName('PROXIMO').AsInteger = 0) or (qryMarcas.FieldByName('ANTERIOR').AsInteger = 0)) then
    Pos := 1;

  PGravaClassificacao(Pos, vCodProva);

  marcaAnt := qryMarcas.FieldByName('MARCA').AsFloat;
end;

procedure TfrmClassificacao.PExcluirClassificacao;
begin
  qryExcluir.ExecSQL;
end;

procedure TfrmClassificacao.PGerarArquivo;
var
  sArq, sLinha: String;
  vInd: Integer;
  Memo: TStringList;
begin
  Memo := TStringList.Create;
  try
    Memo.Clear;

    sArq := ExtractFilePath(ParamStr(0)) + 'ClassProva_' +
            FormatDateTime('yyyy-mm-dd_hh-nn-ss', Now) + '.txt';

    Memo.Add('Nome da prova; Posição; Nome do Atleta; Marca; Cidade');

    qryClassAtleta.Close;
    qryClassAtleta.Open;
    try
      while not qryClassAtleta.EOF do
      begin
        sLinha := qryClassAtleta.FieldByName('NOM_PROVA').AsString + ';' +
                  qryClassAtleta.FieldByName('POSICAO').AsString + ';' +
                  qryClassAtleta.FieldByName('NOM_ATLETA').AsString + ';' +
                  qryClassAtleta.FieldByName('MARCA').AsString + ';' +
                  qryClassAtleta.FieldByName('NOM_CIDADE').AsString;

        Memo.Add(sLinha);
        qryClassAtleta.Next;
      end;
    finally
      qryClassAtleta.Close;
    end;

    Memo.Add('Colocação; Nome da Cidade; Número de medalhas de Ouro; Número de medalhas de Prata; Número de medalhas de Bronze');

    qryClassCidade.Close;
    qryClassCidade.Open;
    vInd := 1;
    try
      while not qryClassCidade.EOF do
      begin
        sLinha := vInd.ToString + ';' +
                  qryClassCidade.FieldByName('NOM_CIDADE').AsString + ';' +
                  qryClassCidade.FieldByName('OURO').AsString + ';' +
                  qryClassCidade.FieldByName('PRATA').AsString + ';' +
                  qryClassCidade.FieldByName('BRONZE').AsString;

        Memo.Add(sLinha);
        Inc(vInd);
        qryClassCidade.Next;
      end;
    finally
      qryClassCidade.Close;
    end;

    Memo.SaveToFile(sArq);
  finally
    Memo.Free;
  end;
end;

procedure TfrmClassificacao.PGerarClassificacao;
begin
  PExcluirClassificacao;

  qryProvas.Close;
  qryProvas.Open;
  while not qryProvas.EOF do
  begin
    qryMarcas.Close;
    qryMarcas.SQL.Text := 'SELECT TOP 20 COD_ATLETA, NOM_ATLETA, COD_CIDADE, MARCA, ' +
                          'LEAD(MARCA, 1, 0) OVER (ORDER BY MARCA) PROXIMO, ' +
                          'LAG(MARCA, 1, 0) OVER (ORDER BY MARCA) ANTERIOR ' +
                          'FROM MARCAS ' +
                          'WHERE COD_PROVA = ' + qryProvas.FieldByName('COD_PROVA').AsString +
                          ' ORDER BY MARCA';

    if (qryProvas.FieldByName('TIP_PROVA').AsString = '+') then
      qryMarcas.SQL.Text := qryMarcas.SQL.Text + ' DESC';

    marcaAnt := 0;
    qryMarcas.Open;
    while not qryMarcas.EOF do
    begin
      PClassifica(qryProvas.FieldByName('COD_PROVA').AsInteger);
      if (Pos = 3) then
        Break;
      qryMarcas.Next;
    end;
    qryProvas.Next;
  end;
end;

procedure TfrmClassificacao.PGravaClassificacao(vPosicao: Integer; vCodProva: Integer);
begin
  qryIncClassif.Close;
  qryIncClassif.SQL.Text := 'INSERT INTO CLASS_PROVA (COD_PROVA, COD_ATLETA, NOM_ATLETA, COD_CIDADE, MARCA, POSICAO) ' +
                            'VALUES (:COD_PROVA, :COD_ATLETA, :NOM_ATLETA, :COD_CIDADE, :MARCA, :POSICAO)';
  qryIncClassif.Params[0].Value := vCodProva;
  qryIncClassif.Params[1].Value := qryMarcas.FieldByName('COD_ATLETA').AsString;
  qryIncClassif.Params[2].Value := qryMarcas.FieldByName('NOM_ATLETA').AsString;
  qryIncClassif.Params[3].Value := qryMarcas.FieldByName('COD_CIDADE').AsString;
  qryIncClassif.Params[4].Value := qryMarcas.FieldByName('MARCA').AsFloat;
  qryIncClassif.Params[5].Value := vPosicao;
  qryIncClassif.ExecSQL;
end;

end.

unit uProdutosFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit;

type
  TFrmListaProdutos = class(TFrame)
    edtQtde: TEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    lblNome: TLabel;
    lblCodigo: TLabel;
    lblValor: TLabel;
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses uPedidos;

procedure TFrmListaProdutos.SpeedButton1Click(Sender: TObject);
var qtde : Float64;
  I : Integer;
  inserindoItem : Boolean;
begin

  qtde := StrToFloat(edtQtde.Text);

  if qtde > 0 then
    qtde := qtde-1
  else
    qtde := 0;

  edtQtde.Text := qtde.ToString;


end;

procedure TFrmListaProdutos.SpeedButton2Click(Sender: TObject);
var qtde : Float64;
  I: Integer;
  inserindoItem : Boolean;
begin

  qtde := StrToFloat(edtQtde.Text);

  qtde := qtde+1;

  edtQtde.Text := qtde.ToString;

  inserindoItem := true;


end;

end.

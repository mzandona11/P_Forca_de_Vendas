unit uPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  Tfrm_Principal = class(TForm)
    btnClientes: TButton;
    btnProdutos: TButton;
    btnPedidos: TButton;
    procedure btnClientesClick(Sender: TObject);
    procedure btnPedidosClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_Principal: Tfrm_Principal;

implementation

{$R *.fmx}

uses uClientes, uPedidos;

procedure Tfrm_Principal.btnClientesClick(Sender: TObject);
VAR v_Teste : string;
begin

  frmClientes.Show;

end;

procedure Tfrm_Principal.btnPedidosClick(Sender: TObject);
begin

  Frm_Pedidos.Show;

end;

end.

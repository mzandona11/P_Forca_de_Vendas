program pPrincipal;

uses
  System.StartUpCopy,
  FMX.Forms,
  uPrincipal in 'uPrincipal.pas' {frm_Principal},
  uClientes in 'uClientes.pas' {frmClientes},
  uPedidos in 'uPedidos.pas' {Frm_Pedidos};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tfrm_Principal, frm_Principal);
  Application.CreateForm(TfrmClientes, frmClientes);
  Application.CreateForm(TFrm_Pedidos, Frm_Pedidos);
  Application.Run;
end.

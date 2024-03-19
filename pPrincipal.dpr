program pPrincipal;

uses
  System.StartUpCopy,
  FMX.Forms,
  uPrincipal in 'uPrincipal.pas' {frm_Principal},
  uClientes in 'uClientes.pas' {frmClientes};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tfrm_Principal, frm_Principal);
  Application.CreateForm(TfrmClientes, frmClientes);
  Application.Run;
end.

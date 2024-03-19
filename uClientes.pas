unit uClientes;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TCliente = record
    codigo : Integer;
    nome, endereco : string;
  end;

  TfrmClientes = class(TForm)
    Layout1: TLayout;
    Layout2: TLayout;
    btnVoltar: TSpeedButton;
    btnInserirCliente: TSpeedButton;
    Label1: TLabel;
    btnPesquisar: TSpeedButton;
    edtPesquisa: TEdit;
    Layout3: TLayout;
    ListView1: TListView;
    FDConnection1: TFDConnection;
    FDQClientes: TFDQuery;
    procedure btnPesquisarClick(Sender: TObject);

    procedure atualizaClientesdoBanco();
    procedure insereClientenaLista(cliente : TCliente);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmClientes: TfrmClientes;

implementation

{$R *.fmx}

procedure TfrmClientes.atualizaClientesdoBanco;
var vCliente : TCliente;
begin
  //Efetuar a consulta no banco e trazer todos os clientes

  FDQClientes.Close;
  FDQClientes.SQL.Clear;
  FDQClientes.SQL.Add('select * from clientes ');
  FDQClientes.Open();

  FDQClientes.First;

  ListView1.Items.Clear;

  while not FDQClientes.Eof do
  begin

    vCliente.codigo := FDQClientes.FieldByName('codigo').AsInteger;
    vCliente.nome := FDQClientes.FieldByName('nome').AsString;
    vCliente.endereco := FDQClientes.FieldByName('endereco').AsString;

    insereClientenaLista(vCliente);

    FDQClientes.Next;
  end;


end;

procedure TfrmClientes.btnPesquisarClick(Sender: TObject);
begin

 // Chamar metodo de consulta no banco de dados

 atualizaClientesdoBanco;

end;

procedure TfrmClientes.insereClientenaLista(cliente: TCliente);
begin

  //Insere cliente por cliente na lista

  with ListView1.Items.Add do
  begin

    TListItemText(Objects.FindDrawable('txtCodigo')).Text := IntToStr(cliente.codigo);
    TListItemText(Objects.FindDrawable('txtNome')).Text := cliente.nome;
  end;

end;

end.

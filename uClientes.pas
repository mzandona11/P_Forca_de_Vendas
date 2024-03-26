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
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.TabControl;

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
    TabControl1: TTabControl;
    tbConsultar: TTabItem;
    tbInserir: TTabItem;
    tbEditar: TTabItem;
    Layout4: TLayout;
    SpeedButton1: TSpeedButton;
    Label2: TLabel;
    Label3: TLabel;
    edt_Codigo: TEdit;
    Label4: TLabel;
    edt_Nome: TEdit;
    Label5: TLabel;
    edt_Endereco: TEdit;
    Layout5: TLayout;
    btn_Salvar: TSpeedButton;
    Layout6: TLayout;
    SpeedButton2: TSpeedButton;
    Label6: TLabel;
    Layout7: TLayout;
    Label7: TLabel;
    edt_Codigo_edicao: TEdit;
    Label8: TLabel;
    edt_nome_edicao: TEdit;
    Label9: TLabel;
    edt_endereco_edicao: TEdit;
    btn_salvar_edica: TButton;
    procedure btnPesquisarClick(Sender: TObject);

    procedure atualizaClientesdoBanco();
    procedure insereClientenaLista(cliente : TCliente);
    procedure btnInserirClienteClick(Sender: TObject);
    procedure btn_SalvarClick(Sender: TObject);
    procedure inserClienteNoBanco(cliente : TCliente);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListView1ItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);

    procedure editaClienteNoBanco(cliente : TCliente);

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
   vTeste : string;
begin
  //Efetuar a consulta no banco e trazer todos os clientes

  FDQClientes.Close;
  FDQClientes.SQL.Clear;
  FDQClientes.SQL.Add('select * from clientes ');

  if edtPesquisa.Text <> '' then
  begin
    FDQClientes.SQL.Add('where nome like :pesquisa');
    FDQClientes.ParamByName('pesquisa').AsString := edtPesquisa.Text;
  end;

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

procedure TfrmClientes.btnInserirClienteClick(Sender: TObject);
begin

  TabControl1.TabIndex := 1;

end;

procedure TfrmClientes.btnPesquisarClick(Sender: TObject);
begin

 // Chamar metodo de consulta no banco de dados

 atualizaClientesdoBanco;

end;

procedure TfrmClientes.btn_SalvarClick(Sender: TObject);
var vCliente : TCliente;
begin

  vCliente.codigo := StrToInt(edt_Codigo.Text);
  vCliente.nome := edt_Nome.Text;
  vCliente.endereco := edt_Endereco.Text;

  //Chamar procedimento para inserir o cliente no banco
  inserClienteNoBanco(vCliente);

end;

procedure TfrmClientes.editaClienteNoBanco(cliente: TCliente);
begin

  FDQClientes.Close;
  FDQClientes.SQL.Clear;
  FDQClientes.SQL.Add('update clientes set ');
  FDQClientes.SQL.Add('   nome = :nome, ');
  FDQClientes.SQL.Add('   endereco = :endereco ');
  FDQClientes.SQL.Add('where codigo = :codigo');

  FDQClientes.ParamByName('codigo').AsInteger := cliente.codigo;
  FDQClientes.ParamByName('nome').AsString := cliente.nome;
  FDQClientes.ParamByName('endereco').AsString := cliente.endereco;

  FDQClientes.ExecSQL;

end;

procedure TfrmClientes.FormShow(Sender: TObject);
begin

  TabControl1.TabIndex := 0;

end;

procedure TfrmClientes.inserClienteNoBanco(cliente: TCliente);
begin

  FDQClientes.Close;
  FDQClientes.SQL.Clear;
  FDQClientes.SQL.Add('INSERT INTO CLIENTES (CODIGO, NOME, ENDERECO)');
  FDQClientes.SQL.Add(' VALUES (:CODIGO, :NOME, :ENDERECO)');
  FDQClientes.ParamByName('codigo').AsInteger := cliente.codigo;
  FDQClientes.ParamByName('nome').AsString := cliente.nome;
  FDQClientes.ParamByName('endereco').AsString := cliente.endereco;
  FDQClientes.ExecSQL;

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

procedure TfrmClientes.ListView1ItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
 //Chamar a tela de edição

//pegar o indice do listview
  ShowMessage(IntToStr(ItemIndex));

  edt_Codigo_edicao.Text := TListItemText(ListView1.Items[ItemIndex].Objects.FindDrawable('txtCodigo')).Text;

  edt_nome_edicao.Text := TListItemText(ListView1.Items[ItemIndex].Objects.FindDrawable('txtNome')).Text;

  TabControl1.TabIndex := 2;


end;

procedure TfrmClientes.SpeedButton1Click(Sender: TObject);
begin
  TabControl1.TabIndex := 0;
end;

end.

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
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.TabControl, FMX.Objects, IOUtils;

type
  TCliente = record
    codigo : Integer;
    nome, endereco : string;
    foto : TBitmap;
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
    btnDeletar: TButton;
    Image1: TImage;
    Image2: TImage;
    ImageControl1: TImageControl;
    imgCliente: TImage;
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
    procedure btn_salvar_edicaClick(Sender: TObject);


    procedure SpeedButton2Click(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    function buscarClientenoBanco(id_cliente : integer) : TCliente;
    procedure deletaCliente(id_cliente : integer);
    procedure btnDeletarClick(Sender: TObject);
    procedure FDConnection1BeforeCommit(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }

    atravesPedido : Boolean;

  end;

var
  frmClientes: TfrmClientes;

implementation

{$R *.fmx}

uses uPedidos;

procedure TfrmClientes.atualizaClientesdoBanco;
var vCliente : TCliente;
   foto_stream : TStream;
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

    if FDQClientes.FieldByName('foto').AsString <> '' then
    begin
      foto_stream := FDQClientes.CreateBlobStream(FDQClientes.FieldByName('foto'), TBlobStreamMode.bmRead);

      vCliente.foto := TBitmap.Create;
      vCliente.foto.LoadFromStream(foto_stream);

      foto_stream.DisposeOf;
    end
    else
      vCliente.foto := nil;

    vCliente.codigo := FDQClientes.FieldByName('codigo').AsInteger;
    vCliente.nome := FDQClientes.FieldByName('nome').AsString;
    vCliente.endereco := FDQClientes.FieldByName('endereco').AsString;

    insereClientenaLista(vCliente);

    FDQClientes.Next;
  end;

end;

procedure TfrmClientes.btnDeletarClick(Sender: TObject);
var id_cliente : integer;
begin

  id_cliente := StrToInt(edt_Codigo_edicao.Text);

  deletaCliente(id_cliente);

  ShowMessage('Cliente deletado com sucesso.');

  TabControl1.TabIndex := 0;

  atualizaClientesdoBanco;

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

procedure TfrmClientes.btnVoltarClick(Sender: TObject);
begin

  frmClientes.Close;

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

procedure TfrmClientes.btn_salvar_edicaClick(Sender: TObject);
var vCliente : TCliente;
begin

// Buscar os dados dos edits e salvar no banco
  vCliente.codigo := StrToInt(edt_Codigo_edicao.Text);
  vCliente.nome := edt_nome_edicao.Text;
  vCliente.endereco := edt_endereco_edicao.Text;
  vCliente.foto := imgCliente.Bitmap;

  editaClienteNoBanco(vCliente);

  ShowMessage('Cliente alterado com sucesso.');

  TabControl1.TabIndex := 0;
  atualizaClientesdoBanco;

end;

function TfrmClientes.buscarClientenoBanco(id_cliente: integer): TCliente;
var vCliente : TCliente;
begin

  FDQClientes.Close;
  FDQClientes.SQL.Clear;
  FDQClientes.SQL.Add('select * from clientes ');
  FDQClientes.SQL.Add('where codigo = :codigo');
  FDQClientes.ParamByName('codigo').AsInteger := id_cliente;

  FDQClientes.Open();

  vCliente.codigo := id_cliente;
  vCliente.nome := FDQClientes.FieldByName('nome').AsString;
  vCliente.endereco := FDQClientes.FieldByName('endereco').AsString;

  Result := vCliente;

end;

procedure TfrmClientes.deletaCliente(id_cliente: integer);
begin

  FDQClientes.Close;
  FDQClientes.SQL.Clear;
  FDQClientes.SQL.Add('delete from clientes ');
  FDQClientes.SQL.Add('where codigo = :codigo');

  FDQClientes.ParamByName('codigo').AsInteger := id_cliente;

  FDQClientes.ExecSQL;

end;

procedure TfrmClientes.editaClienteNoBanco(cliente: TCliente);
begin

  FDQClientes.Close;
  FDQClientes.SQL.Clear;
  FDQClientes.SQL.Add('update clientes set ');
  FDQClientes.SQL.Add('   nome = :nome, ');
  FDQClientes.SQL.Add('   endereco = :endereco, ');
  FDQClientes.SQL.Add('   foto = :foto ');
  FDQClientes.SQL.Add('where codigo = :codigo');

  FDQClientes.ParamByName('codigo').AsInteger := cliente.codigo;
  FDQClientes.ParamByName('nome').AsString := cliente.nome;
  FDQClientes.ParamByName('endereco').AsString := cliente.endereco;
  FDQClientes.ParamByName('foto').Assign(imgCliente.Bitmap);


  FDQClientes.ExecSQL;

end;

procedure TfrmClientes.FDConnection1BeforeCommit(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
    FDConnection1.Params.Values['Database'] := System.SysUtils.GetCurrentDir + '\banco\banco-univel.db';
  {$ELSE}
    FDConnection1.Params.Values['Database'] := System.IOUtils.TPath.Combine(TPath.GetDocumentsPath, 'banco-univel.db');
  {$ENDIF}
end;

procedure TfrmClientes.FormShow(Sender: TObject);
begin

  TabControl1.TabIndex := 0;

end;

procedure TfrmClientes.inserClienteNoBanco(cliente: TCliente);
begin

  FDQClientes.Close;
  FDQClientes.SQL.Clear;
  FDQClientes.SQL.Add('INSERT INTO CLIENTES (CODIGO, NOME, ENDERECO, FOTO)');
  FDQClientes.SQL.Add(' VALUES (:CODIGO, :NOME, :ENDERECO, :FOTO)');
  FDQClientes.ParamByName('codigo').AsInteger := cliente.codigo;
  FDQClientes.ParamByName('nome').AsString := cliente.nome;
  FDQClientes.ParamByName('endereco').AsString := cliente.endereco;
  FDQClientes.ParamByName('foto').Assign(imgCliente.Bitmap);

  FDQClientes.ExecSQL;

end;

procedure TfrmClientes.insereClientenaLista(cliente: TCliente);
begin

  //Insere cliente por cliente na lista

  with ListView1.Items.Add do
  begin

    TListItemText(Objects.FindDrawable('txtCodigo')).Text := IntToStr(cliente.codigo);
    TListItemText(Objects.FindDrawable('txtNome')).Text := cliente.nome;
    TListItemText(Objects.FindDrawable('txtEndereco')).Text := cliente.endereco;

    //Inserir imagem do cliente

    if cliente.foto <> nil then
      TListItemImage(Objects.FindDrawable('imgCliente')).Bitmap := cliente.foto
    else
      TListItemImage(Objects.FindDrawable('imgCliente')).Bitmap := Image1.Bitmap;

    //Inserir imagem de editar
    TListItemImage(Objects.FindDrawable('imgEditar')).Bitmap := Image2.Bitmap;


  end;

end;

procedure TfrmClientes.ListView1ItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
var vCLiente : TCliente;
    id_cliente : integer;
begin
 //Chamar a tela de edição

//pegar o indice do listview

  if atravesPedido then
  begin

    Frm_Pedidos.idClientePedido := StrToInt(TListItemText(ListView1.Items[ItemIndex].Objects.FindDrawable('txtCodigo')).Text);
    Frm_Pedidos.nomeClientePedido := TListItemText(ListView1.Items[ItemIndex].Objects.FindDrawable('txtNome')).Text;

    Close;

  end
  else
  begin
    if (ItemObject.Name = 'imgEditar') then
    begin
      id_cliente := StrToInt(TListItemText(ListView1.Items[ItemIndex].Objects.FindDrawable('txtCodigo')).Text);

      vCLiente := buscarClientenoBanco(id_cliente);

      edt_Codigo_edicao.Text := IntToStr(vCLiente.codigo);
      edt_nome_edicao.Text := vCLiente.nome;
      edt_endereco_edicao.Text := vCLiente.endereco;

      TabControl1.TabIndex := 2;
    end;
  end;

end;

procedure TfrmClientes.SpeedButton1Click(Sender: TObject);
begin
  TabControl1.TabIndex := 0;
end;

procedure TfrmClientes.SpeedButton2Click(Sender: TObject);
begin

  TabControl1.TabIndex := 0;

end;

end.

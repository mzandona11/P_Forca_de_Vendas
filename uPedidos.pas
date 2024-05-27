unit uPedidos;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.StdCtrls, FMX.ListView, FMX.Edit, FMX.Controls.Presentation, FMX.Layouts,
  FMX.TabControl, Data.DB, FireDAC.Comp.Client, FMX.Objects, FMX.DateTimeCtrls,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, FMX.Memo.Types, FMX.ListBox, FMX.ScrollBox, FMX.Memo, IOUtils, System.Generics.Collections,
  System.Actions, FMX.ActnList;

type
  TCliente = record
    codigo : Integer;
    nome : string;
  end;

  TProduto = record
    codigo  : Integer;
    nome : string;
    valorUnit,qtde : Float32;
  end;

  TPedido = record
    id, id_cliente, id_formapgto : Integer;
    nome_cliente, forma_pgto : string;
    data_pedido : TDate;
    valor_total : Float32;
  end;

  TFrm_Pedidos = class(TForm)
    Image1: TImage;
    Image2: TImage;
    ImageControl1: TImageControl;
    imgCliente: TImage;
    FDConnection1: TFDConnection;
    TabControl1: TTabControl;
    tbConsultarPedidos: TTabItem;
    Layout1: TLayout;
    btnVoltar: TSpeedButton;
    btnInserirCliente: TSpeedButton;
    Label1: TLabel;
    Layout2: TLayout;
    btnPesquisar: TSpeedButton;
    edtPesquisa: TEdit;
    Layout3: TLayout;
    ListView1: TListView;
    tbInserePedido: TTabItem;
    Layout4: TLayout;
    SpeedButton1: TSpeedButton;
    Label2: TLabel;
    Layout5: TLayout;
    edt_data: TDateEdit;
    FDQuery1: TFDQuery;
    Layout8: TLayout;
    Label10: TLabel;
    Label11: TLabel;
    Image3: TImage;
    TabControl2: TTabControl;
    tbCliente: TTabItem;
    tbProdutos: TTabItem;
    tbPgto: TTabItem;
    Layout6: TLayout;
    Layout7: TLayout;
    edtDataPedido: TDateEdit;
    Memo1: TMemo;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Layout9: TLayout;
    edtCliente: TEdit;
    SpeedButton2: TSpeedButton;
    Layout10: TLayout;
    btnAdicionarProduto: TButton;
    Layout11: TLayout;
    ListView2: TListView;
    Layout12: TLayout;
    Label6: TLabel;
    Layout13: TLayout;
    Label7: TLabel;
    ComboBoxFormasPgto: TComboBox;
    btnSalvarPedido: TButton;
    StyleBook1: TStyleBook;
    Label8: TLabel;
    tbListaProdutos: TTabItem;
    ListBox1: TListBox;
    Button1: TButton;
    edtPesquisaItemPedido: TEdit;
    Layout14: TLayout;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    Label9: TLabel;
    Button2: TButton;
    ActionList1: TActionList;
    procedure btnPesquisarClick(Sender: TObject);
    procedure atualizaPedidosBanco();
    procedure inserePedidoNaLista(pedido : TPedido);
    procedure SpeedButton1Click(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure FDConnection1BeforeConnect(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnInserirClienteClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure btnAdicionarProdutoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    idClientePedido : Integer;
    nomeClientePedido : string;

  end;

var
  Frm_Pedidos: TFrm_Pedidos;

implementation

{$R *.fmx}

uses uClientes, uProdutosFrame;


procedure TFrm_Pedidos.atualizaPedidosBanco;
var vPedido : TPedido;
begin

  //Buscar os dados no banco
  FDQuery1.Close;
  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('SELECT PEDIDO.ID, ');
  FDQuery1.SQL.Add('       PEDIDO.DATA, ');
  FDQuery1.SQL.Add('       PEDIDO.ID_CLIENTE, ');
  FDQuery1.SQL.Add('       CLIENTES.NOME, ');
  FDQuery1.SQL.Add('       PEDIDO.VALOR_TOTAL, ');
  FDQuery1.SQL.Add('       FORMAPGTO.ID AS ID_FORMAPGTO, ');
  FDQuery1.SQL.Add('       FORMAPGTO.DESCRICAO ');
  FDQuery1.SQL.Add('FROM   PEDIDO');
  FDQuery1.SQL.Add('  INNER JOIN CLIENTES');
  FDQuery1.SQL.Add('   ON CLIENTES.CODIGO = PEDIDO.ID_CLIENTE ');
  FDQuery1.SQL.Add('  INNER JOIN FORMAPGTO');
  FDQuery1.SQL.Add('   ON FORMAPGTO.ID = PEDIDO.ID_FORMAPGTO');
  FDQuery1.SQL.Add('where  pedido.data = :data ');

  FDQuery1.ParamByName('data').AsDate := edt_data.Date;

  FDQuery1.Open();

  ListView1.Items.Clear;

  while not FDQuery1.Eof do
  begin

    vPedido.id := FDQuery1.FieldByName('id').AsInteger;
    vPedido.data_pedido := FDQuery1.FieldByName('data').AsDateTime;
    vPedido.id_cliente := FDQuery1.FieldByName('ID_CLIENTE').AsInteger;
    vPedido.nome_cliente := FDQuery1.FieldByName('NOME').AsString;
    vPedido.id_formapgto := FDQuery1.FieldByName('ID_FORMAPGTO').AsInteger;
    vPedido.forma_pgto := FDQuery1.FieldByName('DESCRICAO').AsString;
    vPedido.valor_total := FDQuery1.FieldByName('valor_total').AsFloat;

    // metodo inserir o pedido na lista
    inserePedidoNaLista(vPedido);

    FDQuery1.Next;
  end;

end;

procedure TFrm_Pedidos.btnAdicionarProdutoClick(Sender: TObject);
begin

  TabControl1.TabIndex := 2;

end;

procedure TFrm_Pedidos.btnInserirClienteClick(Sender: TObject);
begin

  TabControl1.TabIndex := 1;

end;

procedure TFrm_Pedidos.btnPesquisarClick(Sender: TObject);
begin

 // Chamar metodo de listar pedidos
 atualizaPedidosBanco;

end;

procedure TFrm_Pedidos.btnVoltarClick(Sender: TObject);
begin

  Frm_Pedidos.Close;

end;


procedure TFrm_Pedidos.FDConnection1BeforeConnect(Sender: TObject);
begin

  //{$IFDEF MSWINDOWS}
  //  FDConnection1.Params.Values['Database'] := System.SysUtils.GetCurrentDir + '\banco\banco-univel';
  //{$ELSE}
  //  FDConnection1.Params.Values['Database'] := System.IOUtils.TPath.Combine(TPath.GetDocumentsPath, 'banco-univel.db');
  //{$ENDIF}

end;

procedure TFrm_Pedidos.FormShow(Sender: TObject);
begin

  TabControl1.TabIndex := 0;
  edt_data.Date := Date;
  edtDataPedido.Date := Date;

end;

procedure TFrm_Pedidos.inserePedidoNaLista(pedido: TPedido);
begin
  //inserir nosso pedido na lista
  with ListView1.Items.Add do
  begin

    TListItemText(Objects.FindDrawable('txtId')).Text := IntToStr(pedido.id);
    TListItemText(Objects.FindDrawable('txtNome')).Text := pedido.nome_cliente;
    TListItemText(Objects.FindDrawable('txtData')).Text := DateToStr(pedido.data_pedido);
    TListItemText(Objects.FindDrawable('txtValor')).Text := FloatToStr(pedido.valor_total);

    TListItemImage(Objects.FindDrawable('Image5')).Bitmap := Image3.Bitmap;

  end;


end;

procedure TFrm_Pedidos.SpeedButton1Click(Sender: TObject);
begin

  TabControl1.TabIndex := 0;

end;

procedure TFrm_Pedidos.SpeedButton2Click(Sender: TObject);
begin

  if not Assigned(frmClientes) then
    frmClientes := TfrmClientes.Create(self);

  frmClientes.atravesPedido := true;

  frmClientes.ShowModal;

  edtCliente.Text := nomeClientePedido;

end;

end.

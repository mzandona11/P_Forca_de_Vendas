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
  FireDAC.Comp.DataSet;

type
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
    tbConsultar: TTabItem;
    Layout1: TLayout;
    btnVoltar: TSpeedButton;
    btnInserirCliente: TSpeedButton;
    Label1: TLabel;
    Layout2: TLayout;
    btnPesquisar: TSpeedButton;
    edtPesquisa: TEdit;
    Layout3: TLayout;
    ListView1: TListView;
    tbInserir: TTabItem;
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
    tbEditar: TTabItem;
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
    edt_data: TDateEdit;
    FDQuery1: TFDQuery;
    Layout8: TLayout;
    Label10: TLabel;
    Label11: TLabel;
    Image3: TImage;
    procedure btnPesquisarClick(Sender: TObject);
    procedure atualizaPedidosBanco();
    procedure inserePedidoNaLista(pedido : TPedido);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Pedidos: TFrm_Pedidos;

implementation

{$R *.fmx}

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

procedure TFrm_Pedidos.btnPesquisarClick(Sender: TObject);
begin

 // Chamar metodo de listar pedidos
 atualizaPedidosBanco;

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

end.

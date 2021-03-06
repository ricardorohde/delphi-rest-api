unit uServiceProduto;

interface

uses System.SysUtils, System.Classes, Datasnap.DSServer, Datasnap.DSAuth,
  System.JSON, uRotinasDB, uProdutoController;

type
{$METHODINFO ON}
  TServiceProduto = class(TComponent)
  private
    { Private declarations }
    FProdutoController: TProdutoController;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetMaisVendidos : TJSONArray;
    function GetProdutos(pCodCategoria : Integer)  : TJSONArray;
    function GetProdutosDescricao(pDesc : string)  : TJSONArray;
    function GetPromocoes : TJSONArray;
    function updateProdutos(pProduto : TJSONObject) : TJSONObject;
    function updateImagem(pImagem : TJSONObject) : TJSONObject;


  end;
{$METHODINFO OFF}

implementation

{ TServiceProduto }




constructor TServiceProduto.Create(AOwner: TComponent);
begin
  inherited;
  FProdutoController:= TProdutoController.Create(nil);
end;

destructor TServiceProduto.Destroy;
begin
  FreeAndNil(FProdutoController);
  inherited;
end;

function TServiceProduto.GetProdutos(pCodCategoria: Integer): TJSONArray;
begin
  Result := FProdutoController.getProdutos(pCodCategoria);
end;

function TServiceProduto.GetProdutosDescricao(pDesc: string): TJSONArray;
begin
  Result := FProdutoController.getProdutos(pDesc);
end;

function TServiceProduto.GetPromocoes: TJSONArray;
begin
  Result := FProdutoController.getPromocoes;
end;

function TServiceProduto.GetMaisVendidos: TJSONArray;
begin
  Result := FProdutoController.getMaisVendidos;
end;

function TServiceProduto.updateImagem(pImagem: TJSONObject): TJSONObject;
begin
  result := FProdutoController.updateImagem(pImagem);
end;

function TServiceProduto.updateProdutos(pProduto : TJSONObject): TJSONObject;
begin
  result := FProdutoController.updateProdutos(pProduto);
end;

end.

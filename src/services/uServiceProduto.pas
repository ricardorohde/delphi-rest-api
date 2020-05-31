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
    function GetProdutos : TJSONArray;

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

function TServiceProduto.GetProdutos: TJSONArray;
begin
  Result := FProdutoController.getProdutos;
end;

end.

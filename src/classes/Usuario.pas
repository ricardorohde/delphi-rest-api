unit Usuario;

interface

uses
  Controls, ExtCtrls, SysUtils, Variants, Data.DB;


type
  TUsuario = class
  private
    FIdUsuario: string;
    FNomeUsuario: string;
    FSenha: string;
    procedure LimparVariaveis;
    procedure ExecConsulta(p_Where: String);
  public
    constructor Create;
    procedure Consultar;
    procedure ConsultarLogin;
    procedure ConsultarPorSenha;

    class function GetUsuarios: TDataSet;
    class function Login(pUsuario, pSenha: String): TDataSet;

    property IdUsuario: string read FIdUsuario write FIdUsuario;
    property NomeUsuario: string read FNomeUsuario write FNomeUsuario;
    property Senha: string read FSenha write FSenha;


  end;

implementation

uses uRotinasDB, uRotinaSis;

constructor TUsuario.Create;
begin
  LimparVariaveis;
end;

procedure TUsuario.LimparVariaveis;
begin
  FIdUsuario := '';
  FNomeUsuario := '';
  FSenha := '';
end;

class function TUsuario.Login(pUsuario, pSenha: String): TDataSet;
var
  wl_Sql: String;
begin
  wl_Sql := 'SELECT ID_USUARIO as idUsuario, '+
            '  UPPER(USUARIO) as usuario '+
            'FROM USUARIO '+
            'WHERE UPPER(USUARIO) = ' + QuotedStr(UpperCase(pUsuario)) +
            ' AND SENHA = ' +  QuotedStr(pSenha);

  Result := RetornaDadosCDS(wl_Sql);
end;

procedure TUsuario.Consultar;
begin
  Self.ExecConsulta(' ID_USUARIO = ' + FIdUsuario);
end;

procedure TUsuario.ConsultarLogin;
begin
  Self.ExecConsulta(' USUARIO = ' + QuotedStr(FNomeUsuario));
end;

procedure TUsuario.ConsultarPorSenha;
begin
  Self.ExecConsulta(' SENHA = ' + QuotedStr(FSenha));
end;

procedure TUsuario.ExecConsulta(p_Where: String);
var
  wl_Sql: String;
begin

  wl_Sql := 'SELECT ID_USUARIO, USUARIO, SENHA ' +
            '  FROM USUARIO  WHERE ' + p_Where;
  With RetornaDadosCDS(wl_Sql) do
  begin
    try
      if not Isempty then
      begin;
        if FieldByName('ID_USUARIO').Isnull then
          FIdUsuario := ''
        else
          FIdUsuario := FieldByName('ID_USUARIO').AsString;

        if FieldByName('USUARIO').AsString = '' then
          FNomeUsuario := ''
        else
          FNomeUsuario := FieldByName('USUARIO').AsString;

        if FieldByName('SENHA').AsString = '' then
          FSenha := ''
        else
          FSenha := FieldByName('SENHA').AsString;
      end
      else
        LimparVariaveis;
    finally
      Free;
    end;
  end;
end;

class function TUsuario.GetUsuarios: TDataSet;
var
  wl_Sql: String;
begin
  wl_Sql := 'SELECT '+
            ' ID_USUARIO as idUsuario, '+
            '  USUARIO as usuario, '+
            '  SENHA as senha ' +
            'FROM USUARIO ';
  Result := RetornaDadosCDS(wl_Sql);
end;

end.

unit uRotinaSis;

interface

uses Windows, SysUtils, Forms, SQLExpr, DBClient, IniFiles,
     StdCtrls, ComCtrls, Messages, RichEdit,
     ShlObj, Dialogs, ExtCtrls, Controls,
     Classes, WinSock, IdBaseComponent, IdIPWatch,
     xmldom, XMLIntf, msxmldom, XMLDoc,
     Vcl.Buttons, System.Threading,
     Graphics, DBCtrls, DBGrids,
     Mask,  FireDAC.Comp.Client,
     FireDAC.Comp.DataSet, Vcl.Styles, Vcl.Themes,
     Data.DB;



  function getDataServidor: TDateTime;

  function Codificar(pArmazena: String; pChave: Integer): String;
  function Decodificar(pArmazena: String; pChave: Integer): String;
  function StrZero(pNumero : Integer; pDigitos : Integer): String;
  function StrZeroAlfa(pNumero: String; pDigitos : Integer): String;
  function Replace(pTexto: String; pTirar, pPor: Char): String;
  function Tirar(pTexto: String; pTirar: Char): String;
  function Extenso(Valor : Extended): String;
  function MostraData(dtData: TDateTime): string;
  function NomeComputador : String;
  function EnderecoIP : String;
  function GetIP: String;
  function getVersaoExe(pArquivo: String): String;
  function VersaoWindows : String;
  function getMemoriaTotal : string;
  function cpf(num: string): boolean;

  function TransfData(pData: TDateTime): String;
  function TransfDataNull(pData: String): String;
  function RetornaData(pData: String): String;
  function TransfDataHora(pData: TDateTime): String; overload;
  function TransfDataHora(pData: TDateTime; pTipo: Integer): String; overload;
  function TransfValor(pValor: Double): String;
  function ValidaData(pData: String): Boolean;
  function RetornaPrimeiraLetraFrase(pFrase: String): String;

  function TiraAcento(pTexto: String): String;
  function getNumSep(pTexto: WideString; pSeparador: String): Integer;
  function TrataStringSep(pTexto: String; pSeparador: Char; pIndice: Integer): String;

  procedure JustifyRichText(RichEdit: TRichEdit; AllText: Boolean);
  function AlinhaEsquerda(pStr: String; pTamanho: Integer): String;

  procedure TrocaString(var pTextoOrigem: String; pStrDeleta, pStrInclui: String);
  procedure GravaLog(pTipo: Integer; pTabela, pTexto: String);

  function getUltimoDiaMes(pMes: Integer): Integer;

  function TruncString(pTexto: String; pTamanho: Integer): String;
  function getDiaSemana(pDia, pMes, pAno: Integer): String;
  function getDatePart(pData: TDateTime; pTipo: String): Integer;
  function IsInteiro(pValue: Variant): Boolean;
  {Opera��es do PDV}

  function getImageDir: String;
  function getArqIni: String;
  function LerArqIni(pSection, pIdentify, pValue: String): String;
  function PegaDadosArqIni(p_NomArq, p_Secao, p_Chave, p_Default : String) : String;
  function salvarParaArquivo(pCaminho, pNome: String;  pArquivo: WideString): Boolean;
  function salvaLogXML(pNome:String; pArquivo: Widestring): Boolean;

  procedure GravarArqIni(pSection, pIdentify, pValue: String);
  Procedure WriteIni(Pasta: String; IniFile: String; Secao: String; Chave: String;
  valor: string);
  function LeIni(Pasta: String; IniFile: String; Secao: String; Chave: String): String;
  function Encrypt(Senha: String): String;
  function Maior(NumA, NumB: string): string;
  function Zero(valor: string; Zeros: integer): string;
  function NomeMaquina: string;
  function AsciiToInt(Caracter: char): integer;
  function Criptografa(Texto: string; Chave: integer): String;
  function DesCriptografa(Texto: string; Chave: integer): String;
  function RetSeriHD: string;
  function ValidaRegistro(p_CNPJ: String): Boolean;
  function getCNPJValidacao: string;
  function RetiraCarac(valor: string): string;
  function SoNumero(var Tecla: char): char;
  function GetStyle: string;



var
  VR_USUARIO_ID: Integer;
  VR_USUARIO_DESC: String;
  VR_FIRST_CONNECTION: Boolean;
  VR_USUARIO_PADRAO: Boolean;
  VR_LOJA_ID: Integer;
  VR_LOJA_RAZSOC: String;
  VR_LOJA_FANT  : String;
  VR_LOJA_ENDER : String;
  VR_LOJA_BAIRRO: String;
  VR_LOJA_CIDADE: String;
  VR_LOJA_UF    : String;
  VR_LOJA_FONE  : String;
  VR_LOJA_FAX   : String;
  VR_LOJA_CEP   : String;
  VR_LOJA_LOGO  : String;
  VR_LOJA_COMP  : String;
  VR_LOJA_CNPJ  : String;
  VR_LOJA_IE    : String;
  VR_LOJA_EMAIL : String;
  VR_LOJA_CODUF : Integer;
  VR_LOJA_CODCID: String;
  VR_LOJA_NUMERO: String;
  VR_LOJA_IEST  : String;
  VR_LOJA_IM    : String;
  VR_LOJA_CNAE  : String;
  VR_LOJA_REGIME: Integer;
  VR_MODULO     : String;
  VR_TIPO_DATA  : String;
  VR_LOJA_FISCAL: String;
  VR_MENU_NOVO  : Boolean;
  VR_PASTA_IMG_OS: String;

const
  CS_MSG_SISTEMA = 'Logtech OS';

implementation

//uses ufrmPrincipal;



function getDataServidor: TDateTime;
begin
  Result := Date;
end;

function getImageDir: String;
begin
  Result := ExtractFilePath(Application.ExeName)+'imagem';
end;

function getArqIni: String;
begin
  Result := ExtractFilePath(Application.ExeName)+'\Conf.ini';
end;

function LerArqIni(pSection, pIdentify, pValue: String): String;
var
  wl_ArqIni: TIniFile;
begin
  wl_ArqIni := TIniFile.Create(getArqIni);
  Result := '';
  try
    Result := wl_ArqIni.ReadString(pSection, pIdentify, pValue);
  finally
    wl_ArqIni.Free;
  end;
end;

function PegaDadosArqIni(p_NomArq, p_Secao, p_Chave, p_Default : String) : String;
var
  wl_ArqIni : TIniFile;
begin
  wl_ArqIni := TIniFile.Create(ExtractFilePath(Application.ExeName)+'\'+p_NomArq+'.INI');
  try
    Result := wl_ArqIni.ReadString(p_Secao, p_Chave, p_Default);
  finally
    wl_ArqIni.Free;
  end;
end;

function salvarParaArquivo(pCaminho, pNome: string;  pArquivo: WideString): Boolean;
var
  wl_Arq: TextFile;
begin
  Result := False;
  try
    if DirectoryExists(pCaminho) then
    begin
      AssignFile(wl_Arq, pCaminho+'\'+pNome);
      try
        Rewrite(wl_Arq);
        Write(wl_Arq, pArquivo);
        Result := True;
      finally
        CloseFile(wl_Arq);
      end;
    end;
  except
    on e: exception do
  end;
end;

function salvaLogXML(pNome:String; pArquivo: Widestring): Boolean;
var
  wl_Arq: TextFile;
  wl_Caminho: String;
begin
  Result := False;
  try
    wl_Caminho := ExtractFilePath(Application.ExeName);
    if (wl_Caminho[length(wl_Caminho)] <> '\') then
      wl_Caminho := wl_Caminho + '\';
    AssignFile(wl_Arq, wl_Caminho+pNome);
    try
      Rewrite(wl_Arq);
      Write(wl_Arq, pArquivo);
      Result := True;
    finally
      CloseFile(wl_Arq);
    end;
  except
    on e: exception do
  end;
end;

procedure GravarArqIni(pSection, pIdentify, pValue: String);
var
  wl_ArqIni: TIniFile;
begin
  wl_ArqIni := TIniFile.Create(getArqIni);
  try
    wl_ArqIni.WriteString(pSection, pIdentify, pValue);
  finally
    wl_ArqIni.Free;
  end;
end;

function Codificar(pArmazena: String; pChave: Integer): String;
var
  wl_Resultado: String;
  wl_Temporario: Char;
  wl_I, wl_CodIndex: Integer;
begin
  wl_Resultado := '';
  wl_Temporario:= ' '; //Tem q ter espaco porq [e do tipo char
  for wl_I := 1 to Length(pArmazena) do
    begin
      for wl_CodIndex := 1 to pChave do
        begin
          wl_Temporario := Succ(pArmazena[wl_I]);
          pArmazena[wl_I] := wl_Temporario;
        end;
        wl_Resultado := wl_Resultado + wl_Temporario;
    end;
    Result := wl_Resultado;
end;

function Decodificar(pArmazena: String; pChave: Integer): String;
var
  wl_Resultado: String;
  wl_Temporario: Char;
  wl_I, wl_CodIndex: Integer;
begin
  wl_Resultado := '';
  wl_Temporario:= ' '; //Tem q ter espaco porq [e do tipo char
  for wl_I := 1 to Length(pArmazena) do
    begin
      for wl_CodIndex := 1 to pChave do
        begin
          wl_Temporario := Pred(pArmazena[wl_I]);
          pArmazena[wl_I] := wl_Temporario;
        end;
        wl_Resultado := wl_Resultado + wl_Temporario;
    end;
    Result := wl_Resultado;
end;

function StrZero(pNumero : Integer; pDigitos : Integer): String;
var
  wl_I : Integer;
  wl_Texto : String;
begin
  wl_Texto := IntToStr(pNumero);
  for wl_I := 1 to pDigitos - Length(wl_Texto) do
  begin
    wl_Texto := '0' + wl_Texto;
  end;
  Result := wl_Texto;
end;

function StrZeroAlfa(pNumero : String; pDigitos : Integer): String;
var
  wl_I : Integer;
  wl_Texto : String;
begin
  wl_Texto := pNumero;
  for wl_I := 1 to pDigitos - Length(wl_Texto) do
  begin
    wl_Texto := '0' + wl_Texto;
  end;
  Result := wl_Texto;
end;

function Replace(pTexto: String; pTirar, pPor: Char): String;
var
  wl_I: Integer;
begin
  for wl_I := 1 to Length(pTexto) do
    if pTexto[wl_I] = pTirar then
      pTexto[wl_I] := pPor;
  Result := pTexto;
end;

function Tirar(pTexto: String; pTirar: Char): String;
var
  wl_I: Integer;
  wl_Aux: String;
begin
  wl_Aux := '';
  for wl_I := 1 to Length(pTexto) do
    if pTexto[wl_I] <> pTirar then
      wl_Aux := wl_Aux + pTexto[wl_I];
  Result := wl_Aux;
end;

function Extenso(Valor : Extended): String;
var
  Centavos, Centena, Milhar, Milhao, Bilhao, Texto : string;
const
   Unidades: array [1..9] of string = ('um', 'dois', 'tr�s', 'quatro',
                                       'cinco','seis', 'sete', 'oito',
                                       'nove');
   Dez : array [1..9] of string = ('onze', 'doze', 'treze','quatorze',
                                   'quinze','dezesseis', 'dezessete',
                                   'dezoito', 'dezenove');
   Dezenas: array [1..9] of string = ('dez', 'vinte', 'trinta','quarenta',
                                      'cinquenta','sessenta', 'setenta',
                                      'oitenta', 'noventa');
   Centenas: array [1..9] of string = ('cento', 'duzentos','trezentos',
                                       'quatrocentos','quinhentos',
                                       'seiscentos','setecentos','oitocentos', 'novecentos');
function ifs( Expressao: Boolean; CasoVerdadeiro, CasoFalso:String): String;
begin
  if Expressao then Result := CasoVerdadeiro else Result := CasoFalso;
end;

function MiniExtenso( Valor: ShortString ): string;
var
  Unidade, Dezena, Centena: String;
begin
  if (Valor[2] = '1') and (Valor[3] <> '0') then
  begin
    Unidade := Dez[StrToInt(Valor[3])];
    Dezena := '';
  end
    else
  begin
    if Valor[2] <> '0' then
      Dezena := Dezenas[StrToInt(Valor[2])];
    if Valor[3] <> '0' then
      unidade := Unidades[StrToInt(Valor[3])];
  end;
  if (Valor[1] = '1') and (Unidade = '') and (Dezena = '') then
     Centena := 'cem'
  else
    if Valor[1] <> '0' then
      Centena := Centenas[StrToInt(Valor[1])]
    else
      Centena := '';
      Result := Centena + ifs((Centena <> '') and ((Dezena <> '') or (Unidade<> '')),
             ' e ', '') + Dezena + ifs( (Dezena <> '') and (Unidade <> ''), ' e ', '')+Unidade;
end;

begin
  if Valor = 0 then
  begin
    Result := '';
    Exit;
  end;
  Texto    := FormatFloat( '000000000000.00', Valor );
  Centavos := MiniExtenso( '0' + Copy( Texto, 14, 2 ) );
  Centena  := MiniExtenso( Copy( Texto, 10, 3 ) );
  Milhar   := MiniExtenso( Copy( Texto, 7, 3 ) );
  if Milhar <> '' then
     Milhar := Milhar + ' mil';
     Milhao := MiniExtenso( Copy( Texto, 4, 3 ) );
  if Milhao <> '' then
     Milhao := Milhao + ifs( Copy( Texto, 4, 3 ) = '001', ' milh�o',' milh�es');
     Bilhao := MiniExtenso( Copy( Texto, 1, 3 ) );
  if Bilhao <> '' then
     Bilhao := Bilhao + ifs( Copy( Texto, 1, 3 ) = '001', ' bilh�o',' bilh�es');
  if (Bilhao <> '') and (Milhao + Milhar + Centena = '') then
     Result := Bilhao + ' de reais'
  else if (Milhao <> '') and (Milhar + Centena = '') then
     Result := Milhao + ' de reais'
  else
    Result := Bilhao + ifs( (Bilhao <> '') and (Milhao + Milhar + Centena <>''),
              ifs((Pos(' e ', Bilhao) > 0) or (Pos( ' e ', Milhao + Milhar + Centena ) > 0)
                , ', ', ' e '), '')+Milhao +ifs( (Milhao <> '') and (Milhar + Centena <> ''),
              ifs((Pos(' e ', Milhao) > 0) or (Pos( ' e ', Milhar + Centena ) > 0 ), ', ',
                ' e '), '') + Milhar + ifs( (Milhar <> '') and (Centena <> ''),
              ifs(Pos( ' e ', Centena ) > 0, ', ', ' e '), '')+Centena + ifs( Int(Valor) = 1, ' real', ' reais' );
    if Centavos <> '' then
      Result := Result + ' e ' + Centavos +ifs( Copy( Texto, 14, 2 )= '01', ' centavo', ' centavos' );
end;

function MostraData(dtData: TDateTime): string;
var
  intDiaSemana: integer;
  strDiaSemana: string;
begin
  intDiaSemana:= DayOfWeek(dtData);
  Case intDiaSemana of
    1: strDiaSemana   := 'Domingo - ';
    2: strDiaSemana   := 'Segunda-feira - ';
    3: strDiaSemana   := 'Ter�a-feira - ';
    4: strDiaSemana   := 'Quarta-feira - ';
    5: strDiaSemana   := 'Quinta-feira - ';
    6: strDiaSemana   := 'Sexta-feira - ';
    7: strDiaSemana   := 'S�bado - ';
  end;
  Result := strDiaSemana+DateToStr(dtData);
end;

function EnderecoIP : String;
type pu_long = ^u_long;
var
  varTWSAData : TWSAData;
  varPHostEnt : PHostEnt;
  varTInAddr : TInAddr;
  namebuf : Array[0..255] of char;
begin
{  If WSAStartup($101,varTWSAData) <> 0 Then
    Result := 'Erro ao retornar endere�o IP.'
  else
    begin
      gethostname(namebuf,sizeof(namebuf));
      varPHostEnt := gethostbyname(namebuf);
      varTInAddr.S_addr := u_long(pu_long(varPHostEnt^.h_addr_list^)^);
      Result := inet_ntoa(varTInAddr);
    end;
  WSACleanup;}
end;

function GetIP: String;
var
  wl_IPWatch: TIdIPWatch;
begin
  with TIdIPWatch.Create(Nil) do
  begin
    Result := LocalIP;
    Free;
  end;
end;

function getVersaoExe(pArquivo: String): String;
const
  Key: array[1..9] of string =('CompanyName', 'FileDescription','FileVersion','InternalName',
                               'LegalCopyright','OriginalFilename', 'ProductName','ProductVersion',
                               'Comments');
  KeyBr: array [1..9] of string = ('Empresa','Descricao','Versao do Arquivo','Nome Interno',
                                   'Copyright','Nome Original do Arquivo', 'Produto','Versao do Produto',
                                   'Comentarios');
var
  Dummy : Cardinal;
  BufferSize, Len : Integer;
  Buffer : PChar;
  LoCharSet, HiCharSet : Word;
  Translate, Return : Pointer;
  StrFileInfo : string;
begin
  Result := '** ERRO **';
  { Obtemos o tamanho em bytes do "version  information" }
  BufferSize := GetFileVersionInfoSize(PWideChar(pArquivo), Dummy);
  if BufferSize <> 0 then
  begin
    GetMem(Buffer, Succ(BufferSize));
    try
      if GetFileVersionInfo(PChar(pArquivo), 0, BufferSize, Buffer) then
        { Executamos a funcao "VerQueryValue" e conseguimos informacoes sobre o idioma/character-set }
        if VerQueryValue(Buffer, '\VarFileInfo\Translation', Translate, UINT(Len)) then
        begin
          LoCharSet := LoWord(Longint(Translate^));
          HiCharSet := HiWord(Longint(Translate^));
          { Montamos a string de pesquisa }
          StrFileInfo := Format('\StringFileInfo\0%x0%x\FileVersion',[LoCharSet, HiCharSet, Key[3]]);
          { Adicionamos cada key pr�-definido }
          if VerQueryValue(Buffer,PChar(StrFileInfo), Return, UINT(Len)) then
            Result := PChar(Return);
        end;
    finally
      FreeMem(Buffer, Succ(BufferSize));
    end;
  end;
end;

function NomeComputador : String;
var
  WnomeComputador: Array[0..30]of Char;
  size:Cardinal;
begin
 {Vari�vel de inicia��o }
 size:= 30;
 {Retorna o nome do computador }
 if GetComputerName(Wnomecomputador,size) then
   Result := strpas(WnomeComputador)
 else
   Result := '';
end;

function VersaoWindows : string;
var
  OSVersionInfo: TOSVersionInfo;
  MajVerStr,
  MinVerStr,
  BuildNoStr,
  PlatFormStr,
  CSDVerStr: string;
begin
  Result := '';

  OSVersionInfo.dwOSVersionInfoSize := SizeOf(OSVersionInfo);
  if not GetVersionEx (OSVersionInfo) then Exit;

  with OSVersionInfo do begin
    case dwPlatFormId of
      VER_PLATFORM_WIN32s:        PlatFormStr := 'Win32s ';
      VER_PLATFORM_WIN32_WINDOWS: PlatFormStr := 'Windows 9X ';
      VER_PLATFORM_WIN32_NT:      PlatFormStr := 'Windows NT ';
    end;

    MajVerStr   := IntToStr (dwMajorVersion);
    MinVerStr   := IntToStr (dwMinorVersion);
    BuildNoStr  := IntToStr (dwBuildNumber and $0000FFFF);
    CSDVerStr   := StrPas (szCSDVersion);

  Result := PlatFormStr + ' ' +
            MajVerStr + '.' +
            MinVerStr + '.' +
            BuildNoStr;
  end;
end;

function getMemoriaTotal : string;
var
  wl_Memoria: TMemoryStatus;
begin
  Result := '';
  GlobalMemoryStatus(wl_Memoria);
  result := FormatFloat('#,##0.00" MB"', (wl_Memoria.dwTotalPhys / 1024)/1024);
end;

function cpf(num: string): boolean;
var
  n1,n2,n3,n4,n5,n6,n7,n8,n9: integer;
  d1,d2: integer;
  digitado, calculado: string;
begin
  n1:=StrToInt(num[1]);
  n2:=StrToInt(num[2]);
  n3:=StrToInt(num[3]);
  n4:=StrToInt(num[4]);
  n5:=StrToInt(num[5]);
  n6:=StrToInt(num[6]);
  n7:=StrToInt(num[7]);
  n8:=StrToInt(num[8]);
  n9:=StrToInt(num[9]);
  d1:=n9*2+n8*3+n7*4+n6*5+n5*6+n4*7+n3*8+n2*9+n1*10;
  d1:=11-(d1 mod 11);
  if d1>=10 then d1:=0;
    d2:=d1*2+n9*3+n8*4+n7*5+n6*6+n5*7+n4*8+n3*9+n2*10+n1*11;
    d2:=11-(d2 mod 11);
  if d2>=10 then d2:=0;
    calculado:=inttostr(d1)+inttostr(d2);
    digitado:=num[10]+num[11];
  if calculado = digitado then
  begin
    cpf:= True;
  end
    else
  begin
    cpf:= False;
  end;
end;

function TransfData(pData: TDateTime): String;
begin
  Result := QuotedStr(FormatDateTime('YYYYMMDD', pData));
{  if VR_TIPO_DATA = '2' then
    Result := QuotedStr(FormatDateTime('DD/MM/YYYY', pData))
  else Result := QuotedStr(FormatDateTime('MM/DD/YYYY', pData));}
end;

function TransfDataNull(pData: String): String;
begin
  if ValidaData(pData) then
    Result := QuotedStr(FormatDateTime('YYYYMMDD', StrToDate(pData)))
    //Result := QuotedStr(FormatDateTime('MM/DD/YYYY', StrToDate(pData)))
  else Result := QuotedStr('Null');
end;

function RetornaData(pData: String): String;
begin
  try
    if StrToDate(pData) > StrToDate('01/01/1990') then
      Result := FormatDateTime('DD/MM/YYYY', StrToDate(pData))
    else Result := '';
  except
    Result := '';
  end;
end;

function TransfDataHora(pData: TDateTime): String;
begin
  Result := QuotedStr(FormatDateTime('YYYYMMDD hh:mm:ss', pData));
  {if VR_TIPO_DATA = '2' then
    Result := QuotedStr(FormatDateTime('DD/MM/YYYY hh:mm:ss', pData))
  else Result := QuotedStr(FormatDateTime('MM/DD/YYYY hh:mm:ss', pData));}
end;

function TransfDataHora(pData: TDateTime; pTipo: Integer): String; overload;
begin
  if pTipo = 0 then
    Result := QuotedStr(FormatDateTime('YYYYMMDD 00:00:00', pData))
  else Result := QuotedStr(FormatDateTime('YYYYMMDD 23:59:59', pData));
{  if pTipo = 0 then
    Result := QuotedStr(FormatDateTime('MM/DD/YYYY 00:00:00', pData))
  else Result := QuotedStr(FormatDateTime('MM/DD/YYYY 23:59:59', pData));}
end;

function TransfValor(pValor: Double): String;
begin
  Result := Replace(FormatCurr('#####0.00', pValor), ',','.');
end;

function ValidaData(pData: String): Boolean;
begin
  Result := True;
  try
    if pData = '  /  /    ' then
      Result := False
    else StrToDate(pData);
  except
    Result:= False;
  end;
end;

function AlinhaEsquerda(pStr: String; pTamanho: Integer): String;
var
  wl_Str: String;
  I: Integer;
begin
  wl_Str := pStr;
  if Length(pStr) < pTamanho then
  begin
    for I := Length(pStr) to pTamanho -1 do
    begin
      wl_Str := wl_Str + ' ';
    end;
  end
  else wl_Str := Copy(pStr, 0, pTamanho);
  Result := wl_Str;
end;

procedure JustifyRichText(RichEdit: TRichEdit; AllText: Boolean);
const
  TO_ADVANCEDTYPOGRAPHY = $1;
  EM_SETTYPOGRAPHYOPTIONS = (WM_USER + 202);
  EM_GETTYPOGRAPHYOPTIONS = (WM_USER + 203);
var
  ParaFormat :TParaFormat;
  SelStart,
  SelLength :Integer;
begin
  ParaFormat.cbSize := SizeOf(ParaFormat);
  if SendMessage(RichEdit.handle,
                 EM_SETTYPOGRAPHYOPTIONS,
                 TO_ADVANCEDTYPOGRAPHY,
                 TO_ADVANCEDTYPOGRAPHY) = 1 then
  begin
    SelStart := RichEdit.SelStart;
    SelLength := RichEdit.SelLength;
    if AllText then
      RichEdit.SelectAll;
    ParaFormat.dwMask := PFM_ALIGNMENT;
    ParaFormat.wAlignment := PFA_JUSTIFY;
    SendMessage(RichEdit.handle, EM_SETPARAFORMAT, 0, LongInt(@ParaFormat));
    // Restaura sele��o caso tenhamos mudado para All
    RichEdit.SelStart := SelStart;
    RichEdit.SelLength := SelLength;
  end;
end;


procedure TrocaString(var pTextoOrigem: String; pStrDeleta, pStrInclui: String);
var
  wl_Posicao: Integer;
begin
  wl_Posicao := Pos(pStrDeleta, pTextoOrigem);
  if wl_Posicao > 0 then
  begin
    Delete(pTextoOrigem, wl_Posicao, Length(pStrDeleta));
    Insert(pStrInclui, pTextoOrigem, wl_Posicao);
  end;
end;

procedure GravaLog(pTipo: Integer; pTabela, pTexto: String);
var
  wl_Arq: TextFile;
  wl_Arquivo: String;
begin
  wl_Arquivo:= 'Log_'+IntToStr(pTipo)+'_'+FormatDateTime('DD_MM_YYY_hh_mm_ss', Now);
  if not (DirectoryExists(ExtractFilePath(Application.ExeName)+'/Log')) then
  begin
    if ForceDirectories(ExtractFilePath(Application.ExeName)+'/Log') then
    begin
      AssignFile(wl_Arq, ExtractFilePath(Application.ExeName)+'/Log/'+wl_Arquivo);
      try
        Rewrite(wl_Arq);
        Writeln(wl_Arq, 'Tipo:'+IntToStr(pTipo));
        Writeln(wl_Arq, 'Data:'+FormatDatetime('DD/MM/YYYY hh:mm:ss', Now));
        Writeln(wl_Arq, 'Tabela:'+pTabela);
        Writeln(wl_Arq, 'Log:'+pTexto);
      finally
        CloseFile(wl_Arq);
      end;
    end;
  end
    else
  begin
    AssignFile(wl_Arq, ExtractFilePath(Application.ExeName)+'/Log/'+wl_Arquivo);
    try
      Rewrite(wl_Arq);
      Writeln(wl_Arq, 'Tipo:'+IntToStr(pTipo));
      Writeln(wl_Arq, 'Data:'+FormatDatetime('DD/MM/YYYY hh:mm:ss', Now));
      Writeln(wl_Arq, 'Tabela:'+pTabela);
      Writeln(wl_Arq, 'Log:'+pTexto);
    finally
      CloseFile(wl_Arq);
    end;
  end;
end;

function getUltimoDiaMes(pMes: Integer): Integer;
begin
  case pMes of
    1, 3, 5, 7, 8, 10, 12: Result := 31;
    2: Result := 28;
    4, 6, 9, 11: Result := 30;
  end;
end;

function geraDigCodBarra(pCodBarra: String): String;
var
  wl_Tam, wl_Mult,
  wl_Soma, wl_Resto: Integer;
  wl_Digito: Integer;
begin
  wl_Tam:= Length(pCodBarra);
  wl_Mult:= 2;
  wl_Soma:= 0;
  for wl_Tam := Length(pCodBarra) Downto 1 do
  begin
    wl_Soma:= wl_Soma+(StrtoInt(pCodBarra[wl_Tam])*wl_Mult);
    wl_Mult:= wl_Mult+1;
    if wl_Mult = 10 then
      wl_Mult:= 2;
  end;
  wl_Resto:= wl_Soma mod 11;
  wl_Digito:= 11 - wl_Resto;
  if (wl_Digito = 0) or (wl_Digito = 1) or (wl_Digito > 9) then
    wl_Digito := 1;
  Result := IntToStr(wl_Digito);
end;

function TruncString(pTexto: String; pTamanho: Integer): String;
var
  wl_Tam, wl_I: Integer;
  wl_Result: string;
begin
  wl_Result:= '';
  wl_Tam:= Length(pTexto);
  for wl_I := 1 to wl_Tam do
    if (wl_I <= pTamanho) and (wl_Tam >= wl_I) then
      wl_Result:= wl_Result + pTexto[wl_I];
  Result := wl_Result;
end;

function getDiaSemana(pDia, pMes, pAno: Integer): String;
var
  wl_Data: TDateTime;
begin
  case pMes of
    2: begin
      if pDia > 28 then
      begin
        Result:= '';
        Exit;
      end;
    end;
    4,6,9,11:begin
      if pDia > 30 then
      begin
        Result:= '';
        Exit;
      end;
    end;
  end;
  Result:= '';
  try
    if not (ValidaData(IntToStr(pDia)+'/'+IntToStr(pMes)+'/'+IntToStr(pAno))) then
    begin
      Result:= '';
      Exit;
    end;
    wl_Data := StrToDate(IntToStr(pDia)+'/'+IntToStr(pMes)+'/'+IntToStr(pAno));
  except
    on e: exception do
    begin
      Result:= '';
      Exit;
    end;
  end;
  case DayOfWeek(wl_Data) of
    1: Result:= 'D';
    2: Result:= 'S';
    3: Result:= 'T';
    4: Result:= 'Q';
    5: Result:= 'Q';
    6: Result:= 'S';
    7: Result:= 'S';
  end;
end;

function getDatePart(pData: TDateTime; pTipo: String): Integer;
begin
  case pTipo[1] of
    'D': Result:= StrToInt(Copy(FormatDateTime('DDMMYYYY', pData), 1, 2));
    'M': Result:= StrToInt(Copy(FormatDateTime('DDMMYYYY', pData), 3, 2));
    'A': Result:= StrToInt(Copy(FormatDateTime('DDMMYYYY', pData), 5, 4));
  end;
end;

function IsInteiro(pValue: Variant): Boolean;
begin
  try
    StrToInt(pValue);
    Result:= True;
  except
    Result:= False;
  end;
end;




function RetornaPrimeiraLetraFrase(pFrase: String): String;
var
  wl_I: Integer;
  wl_Esp: boolean;
  wl_aux: String;
begin
  pFrase := LowerCase(Trim(pFrase));
  for wl_I := 1 to Length(pFrase) do
  begin
    if wl_I = 1 then
      wl_aux := UpCase(pFrase[wl_I])
    else
      begin
        if wl_I <> Length(pFrase) then
        begin
          wl_esp := (pFrase[wl_I] = ' ');
          if wl_Esp then
            wl_aux := wl_aux + UpCase(pFrase[wl_I+1]);
        end;
      end;
  end;
  Result := wl_aux;
end;



function getNumSep(pTexto: WideString; pSeparador: String): Integer;
var
  wl_I, wl_R: Integer;
begin
  wl_R := 0;
  for wl_I := 1 to Length(pTexto) do
    begin
      if pTexto[wl_I] = pSeparador then
        wl_R := wl_R+1;
    end;
  Result := wl_R;
end;



function TrataStringSep(pTexto: String; pSeparador: Char; pIndice: Integer): String;
var
  wl_StringSep: TStringList;
begin
  while Pos(pSeparador, pTexto) <> 0 do
    TrocaString(pTexto, pSeparador, '","');
  pTexto := '"'+pTexto+'"';

  Result := '';
  wl_StringSep := TStringList.Create;
  try
    wl_StringSep.CommaText := pTexto;
    if wl_StringSep.Count >= pIndice then
      Result := wl_StringSep[pIndice-1];
  finally
    wl_StringSep.Free;
  end;
end;

function TiraAcento(pTexto: String): String;
var
  wl_y: String;
  wl_j: Integer;
begin
  wl_y := Replace(pTexto, '�', 'a');
  wl_y := Replace(wl_y, '�', 'a');
  wl_y := Replace(wl_y, '�', 'a');
  wl_y := Replace(wl_y, '�', 'a');
  wl_y := Replace(wl_y, '�', 'a');

  wl_y := Replace(wl_y, '�', 'e');
  wl_y := Replace(wl_y, '�', 'e');
  wl_y := Replace(wl_y, '�', 'e');

  wl_y := Replace(wl_y, '�', 'i');
  wl_y := Replace(wl_y, '�', 'i');
  wl_y := Replace(wl_y, '�', 'i');

  wl_y := Replace(wl_y, '�', 'o');
  wl_y := Replace(wl_y, '�', 'o');
  wl_y := Replace(wl_y, '�', 'o');
  wl_y := Replace(wl_y, '�', 'o');
  wl_y := Replace(wl_y, '�', 'o');

  wl_y := Replace(wl_y, '�', 'u');
  wl_y := Replace(wl_y, '�', 'u');
  wl_y := Replace(wl_y, '�', 'u');
  wl_y := Replace(wl_y, '�', 'u');

  wl_y := Replace(wl_y, '�', 'A');
  wl_y := Replace(wl_y, '�', 'A');
  wl_y := Replace(wl_y, '�', 'A');
  wl_y := Replace(wl_y, '�', 'A');
  wl_y := Replace(wl_y, '�', 'A');

  wl_y := Replace(wl_y, '�', 'E');
  wl_y := Replace(wl_y, '�', 'E');
  wl_y := Replace(wl_y, '�', 'E');

  wl_y := Replace(wl_y, '�', 'I');
  wl_y := Replace(wl_y, '�', 'I');
  wl_y := Replace(wl_y, '�', 'I');

  wl_y := Replace(wl_y, '�', 'O');
  wl_y := Replace(wl_y, '�', 'O');
  wl_y := Replace(wl_y, '�', 'O');
  wl_y := Replace(wl_y, '�', 'O');
  wl_y := Replace(wl_y, '�', 'O');

  wl_y := Replace(wl_y, '�', 'U');
  wl_y := Replace(wl_y, '�', 'U');
  wl_y := Replace(wl_y, '�', 'U');
  wl_y := Replace(wl_y, '�', 'U');

  wl_y := Replace(wl_y, '�', 'c');
  wl_y := Replace(wl_y, '�', 'C');

  wl_y := Replace(wl_y, '�', '.');
  wl_y := Replace(wl_y, '�', '.');
  wl_y := Replace(wl_y, '`', ' ');

  wl_y := Replace(wl_y, '&', 'e');
  wl_y := Replace(wl_y, '$', ' ');
  wl_y := Replace(wl_y, '#', ' ');

  {wl_y := Replace(wl_y, '/', ' ');
  wl_y := Replace(wl_y, '-', ' ');
  wl_y := Replace(wl_y, '(', ' ');
  wl_y := Replace(wl_y, ')', ' ');
  wl_y := Replace(wl_y, ',', '.');}


  for wl_j:= 1 to length(wl_y) do
  begin
    if (Ord(wl_y[wl_j]) < 32) or (Ord(wl_y[wl_j]) > 127) then
        wl_y[wl_j] := ' '
  end;
  Result := wl_y;
end;

Procedure WriteIni(Pasta: String; IniFile: String; Secao: String; Chave: String;
  valor: string);
var
  wrkIni: TIniFile;
begin
  wrkIni := TIniFile.Create(Pasta + IniFile + '.ini');
  try
    wrkIni.WriteString(Secao, Chave, valor);
  Finally
    wrkIni.Free;
  end;
end;

function LeIni(Pasta: String; IniFile: String; Secao: String; Chave: String): String; // ler um arquivo ini
var
  wrkIni: TIniFile;
begin
  wrkIni := TIniFile.Create(Pasta + IniFile + '.ini');
  try
    result := wrkIni.ReadString(Secao, Chave, '');
  Finally
    wrkIni.Free;
  end;
end;

function Maior(NumA, NumB: string): string;
begin
  if NumA = '' then
    NumA := '0';

  if NumB = '' then
    NumB := '0';

  if StrToFloat(NumA) > StrToFloat(NumB) then
    result := NumA
  else
    result := NumB;
end;

function Zero(valor: string; Zeros: integer): string;
var
  posicao, i: integer;
begin
  result := '';
  posicao := Zeros - length(valor);

  for i := 1 to posicao do
    result := result + '0';

  result := result + valor;
end;

function NomeMaquina: string;
var
  lpBuffer: PChar;
  nSize: DWord;
const
  Buff_Size = MAX_COMPUTERNAME_LENGTH + 1;
begin
  nSize := Buff_Size;
  lpBuffer := StrAlloc(Buff_Size);
  GetComputerName(lpBuffer, nSize);
  result := String(lpBuffer);
  StrDispose(lpBuffer);
end;

function AsciiToInt(Caracter: char): integer;
var
  i: integer;
begin
  i := 32;
  while i < 255 do
  begin
    if chr(i) = Caracter then
      Break;
    i := i + 1;
  end;
  result := i;
end;

Function Criptografa(Texto: string; Chave: integer): String;
var
  cont: integer;
  retorno: string;
begin
  if (trim(Texto) = EmptyStr) or (Chave = 0) then
  begin
    result := Texto;
  end
  else
  begin
    retorno := '';
    for cont := 1 to length(Texto) do
    begin
      retorno := retorno + chr(AsciiToInt(Texto[cont]) + Chave);
    end;
    result := retorno;
  end;
end;

Function DesCriptografa(Texto: string; Chave: integer): String;
var
  cont: integer;
  retorno: string;
begin
  if (trim(Texto) = EmptyStr) or (Chave = 0) then
  begin
    result := Texto;
  end
  else
  begin
    retorno := '';
    for cont := 1 to length(Texto) do
    begin
      retorno := retorno + chr(AsciiToInt(Texto[cont]) - Chave);
    end;
    result := retorno;
  end;
end;

function RetSeriHD: string;
var
  SLabel, SSysName: PChar;
  Serial, FileNameLen, X: DWord;
begin
  GetMem(SLabel, 255);
  GetMem(SSysName, 255);
  try
    GetVolumeInformation('C:\', SLabel, 255, @Serial, FileNameLen, X,
      SSysName, 255);

    result := IntToHex(Serial, 8);

  finally
    FreeMem(SLabel, 255);
    FreeMem(SSysName, 255);
  end;
end;

function ValidaRegistro(p_CNPJ: String): Boolean;
var
  F: TextFile;
  Linha, SerialHD, DataValidade, CNPJ, CodInd: string;
begin
  if FileExists('c:\ERPPRIME\msregsismicrosoft' + '.dat') then
  begin

    AssignFile(F, 'c:\ERPPRIME\msregsismicrosoft' + '.dat');
    Reset(F);

    Readln(F, SerialHD);
    Readln(F, CNPJ);
    Readln(F, DataValidade);
    Readln(F, CodInd);

    CloseFile(F);

    if (SerialHD <> Criptografa(RetSeriHD, 40)) or
      (Date > StrToDate(DesCriptografa(DataValidade, 40))) or
      (CNPJ <> Criptografa(p_CNPJ, 40)) or
      (CodInd <> Criptografa('12213454123321', 40)) then
      result := False
    else
      result := True;
  end
  else
    result := False;
end;

function getCNPJValidacao: string;
var
  F: TextFile;
  SerialHD, DataValidade, CNPJ, CodInd: string;
  iDia: Double;
begin
  result := '';
  if FileExists('c:\ERPPRIME\msregsismicrosoft' + '.dat') then
  begin
    try
      AssignFile(F, 'c:\ERPPRIME\msregsismicrosoft' + '.dat');
      Reset(F);

      Readln(F, SerialHD);
      Readln(F, CNPJ);
      Readln(F, DataValidade);
      Readln(F, CodInd);

      result := DesCriptografa(CNPJ, 40);
    finally
      CloseFile(F);
    end;
  end;
end;

function RetiraCarac(valor: string): string;
var
  i: integer;
begin
  result := '';

  for i := 1 to length(valor) do
  begin
    if ((Copy(valor, i, 1) <> '.') and (Copy(valor, i, 1) <> '-') and
      (Copy(valor, i, 1) <> '/') and (Copy(valor, i, 1) <> '\') and
      (Copy(valor, i, 1) <> '(') and (Copy(valor, i, 1) <> ')')) then
    begin
      result := result + Copy(valor, i, 1);
    end;
  end;

end;

function SoNumero(var Tecla: char): char;
begin
  If Not(Tecla in ['0' .. '9', #8, #0]) then
    Tecla := #0 // Zera tecla
  else
    Tecla := Tecla;
  result := Tecla;
end;


function Encrypt( Senha:String ): String;
Const
    Chave : String = 'PAPERS';
Var
    x,y : Integer;
    newpass : String;
begin
   for x := 1 to Length( Chave ) do
   begin
     newpass := '';
     for y := 1 to Length( Senha ) do
         newpass := newpass + chr((Ord(Chave[x]) xor Ord(Senha[y])));

     Senha := newpass;
   end;
   result := Senha;
end;

function GetStyle: string;
var
  wlStyle,
  wlStylePath : string;

begin
   wlStylePath := ExtractFilePath(Application.ExeName)+'Relatorios\StyleLogtechOS.vsf';;
   if FileExists(wlStylePath) then
   begin
     if TStyleManager.IsValidStyle(wlStylePath) then
     begin
       TStyleManager.LoadFromFile(wlStylePath);
       wlStyle := 'Logtech OS';
     end
     else
       wlStyle := 'Smokey Quartz Kamri';
   end
   else
     wlStyle := 'Smokey Quartz Kamri';

   Result := wlStyle;
end;

end.

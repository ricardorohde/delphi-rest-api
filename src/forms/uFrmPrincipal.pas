unit uFrmPrincipal;

interface

uses
  Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.AppEvnts, Vcl.StdCtrls, IdHTTPWebBrokerBridge, Web.HTTPApp, Vcl.ToolWin,
  Vcl.ActnMan, Vcl.ActnCtrls, Vcl.ActnMenus, Vcl.ComCtrls, Vcl.Menus,
  Vcl.ExtCtrls, Vcl.Buttons, System.ImageList, Vcl.ImgList, uDialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Stan.StorageJSON,
  Vcl.Mask, Vcl.DBCtrls, uRotinaSis;

type
  TFrmPrincipal = class(TForm)
    ApplicationEvents1: TApplicationEvents;
    Panel1: TPanel;
    BtnSalvar: TButton;
    Panel2: TPanel;
    Panel3: TPanel;
    BtnStartStop: TButton;
    Panel4: TPanel;
    ImageList1: TImageList;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    mtSettings: TFDMemTable;
    mtSettingscontext: TStringField;
    mtSettingsport: TIntegerField;
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
    EdtPorta: TDBEdit;
    EdtContexto: TDBEdit;
    dsSettings: TDataSource;
    memoLog: TMemo;
    EdtDataBase: TDBEdit;
    EdtPassword: TDBEdit;
    EdtUser: TDBEdit;
    EdtHost: TDBEdit;
    mtSettingshost: TStringField;
    mtSettingsdatabase: TStringField;
    mtSettingsuser: TStringField;
    mtSettingspassword: TStringField;
    TrayIcon1: TTrayIcon;
    TabSheet3: TTabSheet;
    StatusBar1: TStatusBar;
    Label7: TLabel;
    cbTipoConexao: TComboBox;
    mtSettingstipoConexao: TStringField;
    EdtTipoConexao: TDBEdit;
    TimerMemory: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure ButtonStartClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure BtnStartStopClick(Sender: TObject);
    procedure BtnSalvarClick(Sender: TObject);
    procedure ApplicationEvents1Exception(Sender: TObject; E: Exception);
    procedure ApplicationEvents1Minimize(Sender: TObject);
    procedure TrayIcon1DblClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure cbTipoConexaoChange(Sender: TObject);
    procedure TimerMemoryTimer(Sender: TObject);
  private
    FServer: TIdHTTPWebBrokerBridge;
    procedure StartServer;
    procedure StopServer;
    function VersaoExe(p_NomeArq: String): string;
    procedure TrimAppMemorySize;
    { Private declarations }
  public
    { Public declarations }
    procedure SaveSettings;
    function ValidaConfiguracao : boolean;
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.dfm}

uses
  WinApi.Windows, Winapi.ShellApi, Datasnap.DSSession, WebModuleUnit1;

procedure TFrmPrincipal.ApplicationEvents1Exception(Sender: TObject;
  E: Exception);
begin
  memoLog.Lines.Add('ERROR: '+E.Message);
end;

procedure TFrmPrincipal.ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
begin
  //ButtonStart.Enabled := not FServer.Active;
  //ButtonStop.Enabled := FServer.Active;
  //EditPort.Enabled := not FServer.Active;

  if FServer.Active then
  begin
    BtnStartStop.ImageIndex := 0;
    BtnStartStop.Caption := 'Servidor executando';
  end
  else
  begin
    BtnStartStop.ImageIndex := 1;
    BtnStartStop.Caption := 'Servidor parado';
  end;
end;

procedure TFrmPrincipal.ApplicationEvents1Minimize(Sender: TObject);
begin
  Self.Hide();
  Self.WindowState := wsMinimized;
  TrayIcon1.Visible := True;
  TrayIcon1.Animate := True;

  if FServer.Active then
  begin
    TrayIcon1.BalloonFlags := bfInfo;
    TrayIcon1.BalloonTitle := Application.Title;
    TrayIcon1.BalloonHint := 'Servidor executando.';
  end
  else
  begin
    TrayIcon1.BalloonFlags := bfWarning;
    TrayIcon1.BalloonTitle := Application.Title;
    TrayIcon1.BalloonHint := 'Servidor parado.';
  end;
  TrayIcon1.ShowBalloonHint;
end;

procedure TFrmPrincipal.BtnSalvarClick(Sender: TObject);
begin
  if ValidaConfiguracao then
    SaveSettings;
end;

procedure TFrmPrincipal.BtnStartStopClick(Sender: TObject);
begin
  if FServer.Active then
    StopServer
  else
    StartServer;
end;

procedure TFrmPrincipal.ButtonStartClick(Sender: TObject);
begin
  StartServer;
end;

procedure TerminateThreads;
begin
  if TDSSessionManager.Instance <> nil then
    TDSSessionManager.Instance.TerminateAllSessions;
end;

procedure TFrmPrincipal.ButtonStopClick(Sender: TObject);
begin
  TerminateThreads;
  FServer.Active := False;
  FServer.Bindings.Clear;
end;

procedure TFrmPrincipal.cbTipoConexaoChange(Sender: TObject);
begin
  EdtTipoConexao.Text := cbTipoConexao.Text;
end;

procedure TFrmPrincipal.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    CanClose := Pergunta('Deseja fechar a aplica��o?');
end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
  FServer := TIdHTTPWebBrokerBridge.Create(Self);
  mtSettings.Open;
  if FileExists(ExtractFilePath(Application.ExeName)+'settings.json') then
    mtSettings.LoadFromFile(ExtractFilePath(Application.ExeName)+'settings.json',TFDStorageFormat.sfJSON);

  cbTipoConexao.ItemIndex := cbTipoConexao.Items.IndexOf(mtSettingstipoConexao.AsString);

  StatusBar1.Panels[0].Text :=  NomeComputador;
  StatusBar1.Panels[1].Text :=  GetIP;
  StatusBar1.Panels[2].Text :=  'Vers�o: ' + VersaoExe(Application.ExeName);


end;

procedure TFrmPrincipal.SaveSettings;
begin
  try
    if not mtSettings.Active then
      mtSettings.Open;

    mtSettings.SaveToFile('settings.json',TFDStorageFormat.sfJSON);

    MsgInfo('Configura��es salva com sucesso!');
  except on E: Exception do
    MsgAviso('N�o foi poss�vel salvar configura��es.');
  end;

end;

procedure TFrmPrincipal.StartServer;
begin
  if not ValidaConfiguracao then
    Exit;

  if not FServer.Active then
  begin
    FServer.Bindings.Clear;
    FServer.DefaultPort := StrToInt(EdtPorta.Text);
    FServer.Active := True;
  end;
end;

procedure TFrmPrincipal.StopServer;
begin
  TerminateThreads;
  FServer.Active := False;
  FServer.Bindings.Clear;
end;

procedure TFrmPrincipal.TimerMemoryTimer(Sender: TObject);
begin
  TrimAppMemorySize;
end;

procedure TFrmPrincipal.TrayIcon1DblClick(Sender: TObject);
begin
  TrayIcon1.Visible := False;
  Show();
  WindowState := wsNormal;
  Application.BringToFront();
end;

function TFrmPrincipal.ValidaConfiguracao : boolean;
var
  vResult : boolean;
begin
  vResult := true;

  if EdtContexto.Text = '' then
  begin
    MsgAviso('Infome o contexto do servi�o');
    EdtContexto.SetFocus;
    Exit(false);
  end;

  if EdtPorta.Text = '' then
  begin
    MsgAviso('Infome a porta do servi�o');
    EdtPorta.SetFocus;
    Exit(false);
  end;

  if EdtTipoConexao.Text = '' then
  begin
    MsgAviso('Infome o tipo de conex�o');
    cbTipoConexao.SetFocus;
    Exit(false);
  end;


  result := vResult;
end;

function TFrmPrincipal.VersaoExe(p_NomeArq : String) : string;

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
  BufferSize := GetFileVersionInfoSize(PWideChar(p_NomeArq), Dummy);
  if BufferSize <> 0 then
    begin
      GetMem(Buffer, Succ(BufferSize));
      try
        if GetFileVersionInfo(PChar(p_NomeArq), 0, BufferSize, Buffer) then
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

procedure TFrmPrincipal.TrimAppMemorySize;
var
  MainHandle : THandle;
begin
  try
    MainHandle := OpenProcess(PROCESS_ALL_ACCESS, false, GetCurrentProcessID) ;
    SetProcessWorkingSetSize(MainHandle, $FFFFFFFF, $FFFFFFFF) ;
    CloseHandle(MainHandle) ;
  except
  end;
  Application.ProcessMessages;
end;



end.

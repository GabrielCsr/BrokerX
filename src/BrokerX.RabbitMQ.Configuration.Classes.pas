unit BrokerX.RabbitMQ.Configuration.Classes;

interface

uses
  BrokerX.RabbitMQ.Configuration.Interfaces, IniFiles, System.IOUtils, SysUtils;

type
  TConnectionType = (ctAMQP, ctSTOMP);

  TConfiguration = class(TInterfacedObject, IConfiguration)
  private
    FFile: TIniFile;
    FSection: String;
    FHost,
    FUser,
    FPassword: String;
    FPort: Integer;
  public
    destructor Destroy; override;
    constructor Create(AConnectionType: TConnectionType); overload;
    constructor Create; overload;

    class function New(AConnectionType: TConnectionType): IConfiguration; overload;
    class function New: iConfiguration; overload;

    function Host(AValue: String): IConfiguration; overload;
    function Host: String; overload;
    function Port(AValue: Integer): IConfiguration; overload;
    function Port: Integer; overload;
    function User(AValue: String): IConfiguration; overload;
    function User: String; overload;
    function Password(AValue: String): IConfiguration; overload;
    function Password: String; overload;
  end;

implementation

uses
  StrUtils;

{ TConfiguration }

constructor TConfiguration.Create(AConnectionType: TConnectionType);
var
  LFilePath: String;
begin
  inherited Create;

  LFilePath := TPath.Combine(ExtractFilePath(ParamStr(0)), 'configMQ.properties');

  if not TDirectory.Exists(TPath.GetDirectoryName(LFilePath)) then
    TDirectory.CreateDirectory(TPath.GetDirectoryName(LFilePath));

  if not TFile.Exists(LFilePath) then
  begin
    FFile := TIniFile.Create(LFilePath);
    try
      FFile.WriteString('AMQP', 'HOST', 'localhost');
      FFile.WriteString('AMQP', 'PORT', '5672');
      FFile.WriteString('AMQP', 'USER', 'guest');
      FFile.WriteString('AMQP', 'PASSWORD', 'guest');

      FFile.WriteString('STOMP', 'HOST', 'localhost');
      FFile.WriteString('STOMP', 'PORT', '61613');
      FFile.WriteString('STOMP', 'USER', 'guest');
      FFile.WriteString('STOMP', 'PASSWORD', 'guest');
    finally
      FFile.Free;
    end;
  end;

  FFile := TIniFile.Create(LFilePath);

  case AConnectionType of
    ctAMQP:  FSection := 'AMQP';
    ctSTOMP: FSection := 'STOMP';
  end;
end;

constructor TConfiguration.Create;
begin

end;

destructor TConfiguration.Destroy;
begin
  if Assigned(FFile) then
    FreeAndNil(FFile);
  inherited;
end;

function TConfiguration.Host(AValue: String): IConfiguration;
begin
  Result := Self;
  FHost := AValue;
end;

function TConfiguration.Host: String;
begin
  if Assigned(FFile) then
    Result := FFile.ReadString(FSection, 'HOST', '')
  else
    Result := FHost;
end;

class function TConfiguration.New: iConfiguration;
begin
  Result := Self.Create;
end;

class function TConfiguration.New(
  AConnectionType: TConnectionType): IConfiguration;
begin
  Result := Self.Create(AConnectionType);
end;

function TConfiguration.Password: String;
begin
  if Assigned(FFile) then
    FFile.ReadString(FSection, 'PASSWORD', '')
  else
    Result := FPassword;
end;

function TConfiguration.Password(AValue: String): IConfiguration;
begin
  Result := Self;
  FPassword := AValue;
end;

function TConfiguration.Port(AValue: Integer): IConfiguration;
begin
  Result := Self;
  FPort := AValue;
end;

function TConfiguration.Port: Integer;
begin
  if Assigned(FFile) then
    Result := FFile.ReadInteger(FSection, 'PORT', 0)
  else
    Result := FPort;
end;

function TConfiguration.User(AValue: String): IConfiguration;
begin
  Result := Self;
  FUser := AValue;
end;

function TConfiguration.User: String;
begin
  if Assigned(FFile) then
    FFile.ReadString(FSection, 'USER', '')
  else
    Result := FUser;
end;

end.

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
  public
    constructor Create(AConnectionType: TConnectionType);
    destructor Destroy; override;
    class function New(AConnectionType: TConnectionType): IConfiguration;
    function Host: String;
    function Port: Integer;
    function User: String;
    function Password: String;
  end;

implementation

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

destructor TConfiguration.Destroy;
begin
  FreeAndNil(FFile);
  inherited;
end;

function TConfiguration.Host: String;
begin
  Result := FFile.ReadString(FSection, 'HOST', '');
end;

class function TConfiguration.New(
  AConnectionType: TConnectionType): IConfiguration;
begin
  Result := Self.Create(AConnectionType);
end;

function TConfiguration.Password: String;
begin
  Result := FFile.ReadString(FSection, 'PASSWORD', '');
end;

function TConfiguration.Port: Integer;
begin
  Result := FFile.ReadInteger(FSection, 'PORT', 0);
end;

function TConfiguration.User: String;
begin
  Result := FFile.ReadString(FSection, 'USER', '');
end;

end.

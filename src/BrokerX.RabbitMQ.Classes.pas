unit BrokerX.RabbitMQ.Classes;

interface

uses
  BrokerX.RabbitMQ.Interfaces,
  BrokerX.RabbitMQ.Connection.Interfaces,
  BrokerX.RabbitMQ.Connection.Stomp.Classes, AMQP.Interfaces,
  BrokerX.RabbitMQ.Connection.AMQP.Classes,
  BrokerX.RabbitMQ.Configuration.Interfaces,
  BrokerX.RabbitMQ.Queue.Factory.Classes,
  BrokerX.RabbitMQ.Exchange.Factory.Classes;

type
  TRabbitMQ = class(TInterfacedObject, IRabbitMQ)
  private
    class var FRabbitMQ: IRabbitMQ;
    FQueueFactory: TQueueFactory;
    FExchangeFactory: TExchangeFactory;
    FConfigStomp,
    FConfigAMQP: IConfiguration;
  public
    constructor Create; overload;
    constructor Create(AConfigStomp, AConfigAMQP: IConfiguration); overload;
    destructor Destroy; override;

    class function New: IRabbitMQ; overload;
    class function New(AConfigStomp, AConfigAMQP: IConfiguration): IRabbitMQ; overload;

    function Queue(AName: String): IQueue;
    function Exchange(AName: String): IExchange;
    procedure Connect;
    procedure Disconnect;
    function Connected: Boolean;
  end;

implementation

uses
  BrokerX.RabbitMQ.Connection.Classes,
  BrokerX.RabbitMQ.Queue.Classes, BrokerX.RabbitMQ.Configuration.Classes,
  SysUtils;

{ TRabbitMQ }

constructor TRabbitMQ.Create;
var
  LConfig: IConfiguration;
begin
  LConfig := TConfiguration.New(ctSTOMP);
  try
    TConnection
      .InstanceSTOMP
        .Host(LConfig.Host)
        .Port(LConfig.Port)
        .User(LConfig.User)
        .Password(LConfig.Password)
        .Connect
  except
    On E: Exception do
      raise Exception.Create('problems connecting to STOMP. ' +
                             'Check the parameters in the configMQ.properties file. ' + E.Message);
  end;

  LConfig := TConfiguration.New(ctAMQP);
  try
    TConnection
        .InstanceAMQP
          .Host(LConfig.Host)
          .Port(LConfig.Port)
          .User(LConfig.User)
          .Password(LConfig.Password)
          .Connect
  except
    On E: Exception do
      raise Exception.Create('problems connecting to AMQP. ' +
                             'Check the parameters in the configMQ.properties file. ' + E.Message);
  end;

  FQueueFactory    := TQueueFactory.Create;
  FExchangeFactory := TExchangeFactory.Create;
end;

procedure TRabbitMQ.Connect;
begin
  try
    TConnection
      .InstanceSTOMP
        .Host(FConfigStomp.Host)
        .Port(FConfigStomp.Port)
        .User(FConfigStomp.User)
        .Password(FConfigStomp.Password)
        .Connect
  except
    On E: Exception do
      raise Exception.Create('problems connecting to STOMP. ' +
                             'Check the parameters in the configMQ.properties file. ' + E.Message);
  end;

  try
    TConnection
        .InstanceAMQP
          .Host(FConfigAMQP.Host)
          .Port(FConfigAMQP.Port)
          .User(FConfigAMQP.User)
          .Password(FConfigAMQP.Password)
          .Connect
  except
    On E: Exception do
      raise Exception.Create('problems connecting to AMQP. ' +
                             'Check the parameters in the configMQ.properties file. ' + E.Message);
  end;
end;

function TRabbitMQ.Connected: Boolean;
begin
  Result := TConnection.InstanceAMQP.Connected;
end;

constructor TRabbitMQ.Create(AConfigStomp, AConfigAMQP: IConfiguration);
begin
  FConfigStomp := AConfigStomp;
  FConfigAMQP  := AConfigAMQP;

  FQueueFactory    := TQueueFactory.Create;
  FExchangeFactory := TExchangeFactory.Create;
end;

destructor TRabbitMQ.Destroy;
begin
  FreeAndNil(FQueueFactory);
  FreeAndNil(FExchangeFactory);
  inherited;
end;

procedure TRabbitMQ.Disconnect;
begin
  try
    TConnection
      .InstanceSTOMP
        .Disconnect;
  except
    On E: Exception do
      raise Exception.Create('problems disconnect from STOMP. ' + E.Message);
  end;

  try
    TConnection
        .InstanceAMQP
          .Disconnect;
  except
    On E: Exception do
      raise Exception.Create('problems disconnect to AMQP. ' + E.Message);
  end;
end;

function TRabbitMQ.Exchange(AName: String): IExchange;
begin
  Result := FExchangeFactory.GetOrCreateExchange(AName);
end;

class function TRabbitMQ.New(AConfigStomp,
  AConfigAMQP: IConfiguration): IRabbitMQ;
begin
  if not Assigned(FRabbitMQ) then
    FRabbitMQ := Self.Create(AConfigStomp, AConfigAMQP);

  Result := FRabbitMQ;
end;

class function TRabbitMQ.New: IRabbitMQ;
begin
  if not Assigned(FRabbitMQ) then
    FRabbitMQ := Self.Create;

  Result := FRabbitMQ;
end;

function TRabbitMQ.Queue(AName: String): IQueue;
begin
  Result := FQueueFactory.GetOrCreateQueue(AName);
end;

initialization

finalization
  if Assigned(TRabbitMQ.FRabbitMQ) then
    TRabbitMQ.FRabbitMQ := nil;

end.

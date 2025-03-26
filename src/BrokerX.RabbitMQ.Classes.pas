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
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IRabbitMQ;
    function Queue(AName: String): IQueue;
    function Exchange(AName: String): IExchange;
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

destructor TRabbitMQ.Destroy;
begin
  FreeAndNil(FQueueFactory);
  FreeAndNil(FExchangeFactory);
  inherited;
end;

function TRabbitMQ.Exchange(AName: String): IExchange;
begin
  Result := FExchangeFactory.GetOrCreateExchange(AName);
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

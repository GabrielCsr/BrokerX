unit BrokerX.RabbitMQ.Queue.Classes;

interface

uses
  BrokerX.RabbitMQ.Interfaces, System.Threading,
  BrokerX.RabbitMQ.Consumer.Factory.Classes, System.Generics.Collections,
  Classes, BrokerX.RabbitMQ.Connection.Stomp.Classes,
  BrokerX.RabbitMQ.Producer.Factory.Classes;

type
  TQueue = class(TInterfacedObject, IQueue)
  private
    FName: String;
    FConsumerFactory: TConsumerFactory;
    FProducerFactory: TProducerFactory;
    FSubscribed: Boolean;
    FConnection: IStompConnection;
    function GetName: String;
  public
    constructor Create(AName: String);
    destructor Destroy; override;
    class function New(AName: String): IQueue;
    function Declare: IQueue;
    function Delete(AIfUnused, AIfEmpty: Boolean): IQueue;
    function Bind(AExchange, ARoutingKey: String):   IQueue;
    function UnBind(AExchange, ARoutingKey: String): IQueue;
    function Subscribe(AAutoAck: Boolean): IQueue;
    function UnSubscribe: IQueue;
    function Consumer: IConsumer;
    function Producer: IProducer;
  end;

implementation

uses
  BrokerX.RabbitMQ.Connection.Classes, StompClient,
  BrokerX.RabbitMQ.Consumer.Classes, SysUtils;

{ TQueue }

function TQueue.Bind(AExchange, ARoutingKey: String): IQueue;
begin
  Result := Self;

  TConnection.InstanceAMQP.Channel.QueueBind(GetName,AExchange, ARoutingKey, []);
end;

function TQueue.Consumer: IConsumer;
begin
  Result := FConsumerFactory.GetOrCreateConsumer(FName, FConnection);
end;

function TQueue.Declare: IQueue;
begin
  Result := Self;

  TConnection.InstanceAMQP.Channel.QueueDeclare(GetName, []);
end;

constructor TQueue.Create(AName: String);
begin
  FName := AName;
  FConsumerFactory := TConsumerFactory.Create;
  FProducerFactory := TProducerFactory.Create;
  FSubscribed := False;
  FConnection := TConnection.NewStompConnected;
end;

function TQueue.Delete(AIfUnused, AIfEmpty: Boolean): IQueue;
begin
  Result := Self;

  TConnection.InstanceAMQP.Channel.QueueDelete(GetName, AIfUnused, AIfEmpty);
end;

destructor TQueue.Destroy;
begin
  FConsumerFactory.RemoveConsumer(FName);
  FProducerFactory.RemoveProducer('/queue/' + FName);
  FreeAndNil(FConsumerFactory);
  FreeAndNil(FProducerFactory);
  FConnection.Disconnect;
  inherited;
end;

function TQueue.GetName: String;
begin
  if FName.Trim.IsEmpty then
    raise Exception.Create('The queue name dont informed');

  Result := FName;
end;

class function TQueue.New(AName: String): IQueue;
begin
  Result := Self.Create(AName);
end;

function TQueue.Producer: IProducer;
begin
  Result := FProducerFactory.GetOrCreateProducer('/queue/' + GetName, TConnection.NewStompConnected);
end;

function TQueue.Subscribe(AAutoAck: Boolean): IQueue;
var
  LAckMode: TAckMode;
begin
  Result := Self;

  if AAutoAck then
    LAckMode := TAckMode.amAuto
  else
    LAckMode := TAckMode.amClient;

  try
    if FSubscribed then
      Exit;

    FConnection.Connection.Subscribe(GetName, LAckMode);
    FSubscribed := True;
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

function TQueue.UnBind(AExchange, ARoutingKey: String): IQueue;
begin
  Result := Self;

  TConnection.InstanceAMQP.Channel.QueueUnBind(GetName, AExchange, ARoutingKey, []);
end;

function TQueue.UnSubscribe: IQueue;
begin
  Result := Self;

  try
    if not FSubscribed then
      Exit;

    FConsumerFactory.GetOrCreateConsumer(GetName, FConnection).Stop;
    FConnection.Connection.Unsubscribe(GetName);
    FSubscribed := False;
  except

  end;
end;

end.

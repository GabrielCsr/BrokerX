unit BrokerX.RabbitMQ.Exchange.Classes;

interface

uses
  BrokerX.RabbitMQ.Interfaces, BrokerX.RabbitMQ.Producer.Factory.Classes,
  BrokerX.RabbitMQ.Connection.Stomp.Classes;

type
  TExchange = class(TInterfacedObject, IExchange)
  private
    FProducerFactory: TProducerFactory;
    FName: String;
    FConnection: IStompConnection;
  public
    constructor Create(AName: String);
    destructor Destroy; override;
    class function New(AName: String): IExchange;
    function Declare: IExchange;
    function Delete(AIfUnused, AIfEmpty: Boolean): IExchange;
    function Bind(AQueue, ARoutingKey: String):   IExchange;
    function UnBind(AQueue, ARoutingKey: String): IExchange;
    function Producer(ARoutingKey: String): IProducer;
  end;

implementation

uses
  SysUtils, BrokerX.RabbitMQ.Connection.Classes;

{ TExchange }

function TExchange.Bind(AQueue, ARoutingKey: String): IExchange;
begin
  Result := Self;
end;

constructor TExchange.Create(AName: String);
begin
  FConnection := TConnection.NewStompConnected;
  FProducerFactory := TProducerFactory.Create;
  FName := AName;
end;

function TExchange.Declare: IExchange;
begin
  Result := Self;
end;

function TExchange.Delete(AIfUnused, AIfEmpty: Boolean): IExchange;
begin
  Result := Self;
end;

destructor TExchange.Destroy;
begin
  FConnection.Disconnect;
  FreeAndNil(FProducerFactory);
  inherited;
end;

class function TExchange.New(AName: String): IExchange;
begin
  Result := Self.Create(AName);
end;

function TExchange.Producer(ARoutingKey: String): IProducer;
begin
  if ARoutingKey.IsEmpty then
    raise Exception.Create('RoutingKey dont informed!');

  Result := FProducerFactory.GetOrCreateProducer('/exchange/' + FName + '/' + ARoutingKey, FConnection);
end;

function TExchange.UnBind(AQueue, ARoutingKey: String): IExchange;
begin
  Result := Self;
end;

end.

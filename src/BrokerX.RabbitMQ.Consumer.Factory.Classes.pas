unit BrokerX.RabbitMQ.Consumer.Factory.Classes;

interface

uses
  System.Generics.Collections, BrokerX.RabbitMQ.Interfaces, SysUtils,
  BrokerX.RabbitMQ.Connection.Stomp.Classes;

type
  TConsumerFactory = class
  private
    FConsumers: TDictionary<String, IConsumer>;
  public
    constructor Create;
    destructor Destroy; override;
    function GetOrCreateConsumer(AQueueName: String; AConnection: IStompConnection): IConsumer;
    procedure RemoveConsumer(AQueueName: String);
  end;

implementation

uses
  BrokerX.RabbitMQ.Consumer.Classes;

{ TConsumerFactory }

constructor TConsumerFactory.Create;
begin
  FConsumers := TDictionary<String, IConsumer>.Create;
end;

destructor TConsumerFactory.Destroy;
begin
  FConsumers.Clear;
  FreeAndNil(FConsumers);
  inherited;
end;

function TConsumerFactory.GetOrCreateConsumer(AQueueName: String; AConnection: IStompConnection): IConsumer;
begin
  if not FConsumers.TryGetValue(AQueueName, Result) then
  begin
    Result := TConsume.New(AConnection);
    FConsumers.Add(AQueueName, Result);
  end;
end;

procedure TConsumerFactory.RemoveConsumer(AQueueName: String);
begin
  if FConsumers.ContainsKey(AQueueName) then
    FConsumers.Remove(AQueueName);
end;

end.

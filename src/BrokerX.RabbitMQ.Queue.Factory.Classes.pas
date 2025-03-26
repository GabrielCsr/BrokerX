unit BrokerX.RabbitMQ.Queue.Factory.Classes;

interface

uses
  System.Generics.Collections, BrokerX.RabbitMQ.Interfaces, SysUtils;

type
  TQueueFactory = class
  private
    FQueues: TDictionary<String, IQueue>;
  public
    constructor Create;
    destructor Destroy; override;
    function GetOrCreateQueue(AQueueName: String): IQueue;
    procedure RemoveQueue(AQueueName: String);
  end;

implementation

uses
  BrokerX.RabbitMQ.Queue.Classes;

{ TQueueFactory }

constructor TQueueFactory.Create;
begin
  FQueues := TDictionary<String, IQueue>.Create;
end;

destructor TQueueFactory.Destroy;
begin
  FQueues.Clear;
  FreeAndNil(FQueues);
  inherited;
end;

function TQueueFactory.GetOrCreateQueue(AQueueName: String): IQueue;
begin
  if not FQueues.TryGetValue(AQueueName, Result) then
  begin
    Result := TQueue.New(AQueueName);
    FQueues.Add(AQueueName, Result);
  end;
end;

procedure TQueueFactory.RemoveQueue(AQueueName: String);
begin
  if FQueues.ContainsKey(AQueueName) then
    FQueues.Remove(AQueueName);
end;

end.

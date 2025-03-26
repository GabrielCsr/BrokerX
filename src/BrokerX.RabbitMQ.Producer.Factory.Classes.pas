unit BrokerX.RabbitMQ.Producer.Factory.Classes;

interface

uses
  System.Generics.Collections, BrokerX.RabbitMQ.Interfaces,
  BrokerX.RabbitMQ.Connection.Stomp.Classes;

type
  TProducerFactory = class
  private
    FProducers: TDictionary<String, IProducer>;
  public
    constructor Create;
    destructor Destroy; override;
    function GetOrCreateProducer(AMessagePath: String; AConnection: IStompConnection): IProducer;
    procedure RemoveProducer(AMessagePath: String);
  end;

implementation

uses
  SysUtils, BrokerX.RabbitMQ.Producer.Classes;

{ TProducerFactory }

constructor TProducerFactory.Create;
begin
  FProducers := TDictionary<String, IProducer>.Create;
end;

destructor TProducerFactory.Destroy;
begin
  FreeAndNil(FProducers);
  inherited;
end;

function TProducerFactory.GetOrCreateProducer(AMessagePath: String; AConnection: IStompConnection): IProducer;
begin
  if not FProducers.TryGetValue(AMessagePath, Result) then
  begin
    Result := TProducer.New(AMessagePath, AConnection);
    FProducers.Add(AMessagePath, Result);
  end;
end;

procedure TProducerFactory.RemoveProducer(AMessagePath: String);
begin
  if FProducers.ContainsKey(AMessagePath) then
    FProducers.Remove(AMessagePath);
end;

end.

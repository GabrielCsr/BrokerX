unit BrokerX.RabbitMQ.Exchange.Factory.Classes;

interface

uses
  System.Generics.Collections, BrokerX.RabbitMQ.Interfaces;

type
  TExchangeFactory = class
  private
    FExchanges: TDictionary<String, IExchange>;
  public
    constructor Create;
    destructor Destroy; override;
    function GetOrCreateExchange(AName: String): IExchange;
    procedure RemoveExchange(AName: String);
  end;

implementation

uses
  SysUtils, BrokerX.RabbitMQ.Exchange.Classes;

{ TExchangeFactory }

constructor TExchangeFactory.Create;
begin
  FExchanges := TDictionary<String, IExchange>.Create;
end;

destructor TExchangeFactory.Destroy;
begin
  FreeAndNil(FExchanges);
  inherited;
end;

function TExchangeFactory.GetOrCreateExchange(AName: String): IExchange;
begin
  if not FExchanges.TryGetValue(AName, Result) then
  begin
    Result := TExchange.New(AName);
    FExchanges.Add(AName, Result);
  end;
end;
procedure TExchangeFactory.RemoveExchange(AName: String);
begin
  if FExchanges.ContainsKey(AName) then
    FExchanges.Remove(AName);
end;

end.

unit BrokerX.RabbitMQ.Interfaces;

interface

uses
  BrokerX.RabbitMQ.Connection.Interfaces,
  BrokerX.RabbitMQ.Connection.Stomp.Classes,
  BrokerX.RabbitMQ.Connection.AMQP.Classes, System.Generics.Collections;

type
  TReceiveMessage = procedure(APayload: String; AHeader: TDictionary<String, String>) of Object;

  IConsumer = interface
    ['{4C71772B-709A-43A9-A745-503DFBB6AA64}']
    function Start: IConsumer;
    function Stop:  IConsumer;
    function OnReceiveMessage(AProcReceiveMessage: TReceiveMessage): IConsumer;
  end;

  IProducer = interface
    ['{16A22FF0-0067-4D36-92B6-CBA89A41573D}']
    function Start: IProducer;
    function Stop:  IProducer;
    function SendMesssage(APayload: String; AHeader: TDictionary<String, String> = nil): IProducer;
  end;

  IQueue = interface
    ['{75790E00-E4D9-40AD-BA11-DFEF892D0BF2}']
    function Declare: IQueue;
    function Delete(AIfUnused, AIfEmpty: Boolean):   IQueue;
    function Bind(AExchange, ARoutingKey: String):   IQueue;
    function UnBind(AExchange, ARoutingKey: String): IQueue;
    function Subscribe(AAutoAck: Boolean):           IQueue;
    function UnSubscribe:                            IQueue;
    function Consumer:                               IConsumer;
    function Producer:                               IProducer;
  end;

  IExchange = interface
    ['{AB5CC08C-BC29-42A3-8CC3-ACD013F89DD0}']
    function Declare:                              IExchange;
    function Delete(AIfUnused, AIfEmpty: Boolean): IExchange;
    function Bind(AQueue, ARoutingKey: String):    IExchange;
    function UnBind(AQueue, ARoutingKey: String):  IExchange;
    function Producer(ARoutingKey: String):        IProducer;
  end;


  IRabbitMQ = interface
    ['{F6B9262E-DC92-4D78-8106-B25605154604}']
    function Queue(AName: String): IQueue;
    function Exchange(AName: String): IExchange;
  end;

implementation

end.

unit BrokerX.RabbitMQ.Configuration.Interfaces;

interface

type
  IConfiguration = interface
    function Host(AValue: String): IConfiguration; overload;
    function Host: String; overload;
    function Port(AValue: Integer): IConfiguration; overload;
    function Port: Integer; overload;
    function User(AValue: String): IConfiguration; overload;
    function User: String; overload;
    function Password(AValue: String): IConfiguration; overload;
    function Password: String; overload;
  end;

implementation

end.

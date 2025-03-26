unit BrokerX.RabbitMQ.Configuration.Interfaces;

interface

type
  IConfiguration = interface
    function Host: String;
    function Port: Integer;
    function User: String;
    function Password: String;
  end;

implementation

end.

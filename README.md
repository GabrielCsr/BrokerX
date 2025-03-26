# BrokerX
**BrokerX** é uma biblioteca que simplifica a comunicação com o `RabbitMQ`, permitindo a gestão de Queues e Exchanges, além de possibilitar o consumo e envio de mensagens de forma assíncrona, tudo em uma única solução.

## ⚙️ Instalação
Instalação utilizando o gerenciador de dependências boss:
```bash
boss install https://github.com/gabrielcsr/brokerx
```
 ## 🔴 Configurações iniciais
A biblioteca utiliza o método de conexão **AMQP** por ser eficiente na manutenção e o **STOMP** por ser eficiente no consumo e envio de mensagens.

### Habilitar o plugin STOMP
O RabbitMQ necessita do plugin STOMP para comunicação com a biblioteca BrokerX. Para habilitar esse plugin, execute o seguinte comando no terminal:
```bash
rabbitmq-plugins enable rabbitmq_stomp
```
### Criar o arquivo de configuração
Você precisará criar o arquivo `configMQ.properties` no diretório onde o executável da sua aplicação está localizado. Este arquivo deve conter a seguinte estrutura:
```
[AMQP]
HOST=localhost
PORT=5672
USER=guest
PASSWORD=guest

[STOMP]
HOST=localhost
PORT=61613
USER=guest
PASSWORD=guest
```
Substitua as informações de conexão conforme os dados do seu RabbitMQ. Caso o arquivo não exista, ele será criado automaticamente ao chamar a biblioteca, e o conteúdo do arquivo será preenchido com as informações de conexão padrão, conforme descrito anteriormente.

## 📦 Exemplos de uso
```pascal
uses
  BrokerX.RabbitMQ.Classes;

var
  RabbitMQ := TRabbitMQ.New;  
```
### Declaração

**Queue**

```pascal
RabbitMQ.Queue('NomeDaFila').Declare;
```

**Exchange**

```pascal
RabbitMQ.Exchange('NomeDaExchange').Declare;
```

### Deleção

Parametros para deleção:
```pascal
const
  SE_NAO_UTILIZADA = True;
  SE_VAZIA = False;
```
**Queue**

```pascal
RabbitMQ.Queue('NomeDaQueue').Delete(SE_NAO_UTILIZADA, SE_VAZIA);
```
**Exchange**

```pascal
RabbitMQ.Exchange('NomeDaExchange').Delete(SE_NAO_UTILIZADA, SE_VAZIA);
```
### Bind/UnBind

**Queue**

```pascal
RabbitMQ.Queue('NomeDaQueue').Bind('NomeExchange', 'RoutingKey');

RabbitMQ.Queue('NomeDaQueue').UnBind('NomeExchange', 'RoutingKey');
```
**Exchange**

```pascal
RabbitMQ.Exchange('NomeDaExchange').Bind('NomeQueue', 'RoutingKey');

RabbitMQ.Exchange('NomeDaExchange').UnBind('NomeQueue', 'RoutingKey');
```
### Consumo de mensagens da Queue
**Observação**: A biblioteca permite consumir diversas filas simultaneamente.

1. declaração do método que será notificado ao receber uma mensagem da fila:
```pascal
procedure RecebeMensagem(APayload: String; AHeaders: TDictionary<String, String> = nil);
```
2. Iniciar o consumo da fila em segundo plano:
```pascal
RabbitMQ
  .Queue('NomeDaFila')
    .Subscribe({Ack automatico =} True) 
    .Consumer
      .OnReceiveMessage(RecebeMensagem)
      .Start;
```
3. Parar o consumo da fila:
```pascal
RabbitMQ.Queue('NomeDaFila').UnSubscribe;
```

### Envio de mensagens
**Observação**: O envio de mensagens, assim como o consumo, ocorre em segundo plano. Portanto, basta iniciar o produtor e enviar mensagens a ele sempre que desejar.

1. Iniciar o produtor de mensagens:
```pascal
{Direto para Fila}
RabbitMQ
  .Queue('NomeDaQueue')
    .Producer
      .Start;

//ou
{Para uma Rota especifica}
RabbitMQ
  .Exchange('NomeDaExchange')
    .Producer('RoutingKey')
      .Start;
```
2. Enviar mensagens ao produtor quando necessário:
```pascal
RabbitMQ
  .Queue('NomeDaQueue')
    .Producer
      .SendMesssage('Mensagem', {Headers: Dictionary<String, String>});

//ou

RabbitMQ
  .Exchange('NomeDaExchange')
    .Producer('RoutingKey')
      .SendMesssage('Mensagem', {Headers: Dictionary<String, String>});
```
3. Interromper o produtor:
```pascal
RabbitMQ
  .Queue('NomeDaQueue')
    .Producer
      .Stop;

//ou

RabbitMQ
  .Exchange('NomeDaExchange')
    .Producer('RoutingKey')
      .Stop;
```
## ⚠️ Considerações
**O projeto utiliza as bibliotecas:**
1. https://github.com/brendenwalker/delphi_amqp    -- Conexão AMQP
2. https://github.com/danieleteti/delphistompclient -- Conexão STOMP

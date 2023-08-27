unit Unit4;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo, FMX.Controls.Presentation, FMX.StdCtrls,FMX.Edit,

  System.JSON,

  GenericSocket,
  GenericSocket.Client,
  GenericSocket.Server;


type
  TForm4 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    edClientName: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ClientSocket : iGenericSocket;

    function SocketProducts(aMessage : String) : String;
  end;

var
  Form4: TForm4;

implementation

{$R *.fmx}

{ TForm4 }

procedure TForm4.Button1Click(Sender: TObject);
begin
  ClientSocket.SocketClient
    //post on api:localhost:9000/socket/products
    .RegisterCallback('/products', SocketProducts)
    .Connect('127.0.0.1', 8050, edClientName.Text);
end;

procedure TForm4.FormCreate(Sender: TObject);
begin
  ClientSocket := TGenericSocket.New;
end;

function TForm4.SocketProducts(aMessage: String): String;
begin
  Memo1.Lines.Add('I received ' + aMessage + ' and replied.');

  var json:=TJSONObject.Create;
  try
     json.AddPair('ID',10001);
     json.AddPair('Name','Mercides Benz C200');
     json.AddPair('Price','30,000 USD');
     json.AddPair('RequestMessage',TJSONValue.ParseJSONValue(aMessage));

     Result := json.ToJSON;
  finally
     json.Free;
  end;

end;

end.

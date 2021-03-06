unit HttpConnectionIndy;

interface

uses IdHTTP, HttpConnection, Classes, RestUtils;

type
  THttpConnectionIndy = class(TInterfacedObject, IHttpConnection)
  private
    FIdHttp: TIdHTTP;
  public
    constructor Create;
    destructor Destroy; override;

    function SetAcceptTypes(AAcceptTypes: string): IHttpConnection;
    function SetAcceptedLanguages(AAcceptedLanguages: string): IHttpConnection;
    function SetContentTypes(AContentTypes: string): IHttpConnection;
    function SetHeaders(AHeaders: TStrings): IHttpConnection;

    procedure Get(AUrl: string; AResponse: TStream);
    procedure Post(AUrl: string; AContent: TStream; AResponse: TStream);
    procedure Put(AUrl: string; AContent: TStream; AResponse: TStream);
    procedure Delete(AUrl: string);

    function GetResponseCode: Integer;
  end;

implementation

{ THttpConnectionIndy }

constructor THttpConnectionIndy.Create;
begin
  FIdHttp := TIdHTTP.Create(nil);
  FIdHttp.HandleRedirects := True;
end;

procedure THttpConnectionIndy.Delete(AUrl: string);
begin
  FIdHttp.Delete(AUrl);
end;

destructor THttpConnectionIndy.Destroy;
begin
  FIdHttp.Free;
  inherited;
end;

procedure THttpConnectionIndy.Get(AUrl: string; AResponse: TStream);
begin
  try
    FIdHttp.Get(AUrl, AResponse);
  except
    on E: EIdHTTPProtocolException do
    begin
      if not EIdHTTPProtocolException(E).ErrorCode = TStatusCode.NOT_FOUND.StatusCode then
        raise;
    end;
  end;
end;

function THttpConnectionIndy.GetResponseCode: Integer;
begin
  Result := FIdHttp.ResponseCode;
end;

procedure THttpConnectionIndy.Post(AUrl: string; AContent, AResponse: TStream);
begin
  FIdHttp.Post(AUrl, AContent, AResponse);
end;

procedure THttpConnectionIndy.Put(AUrl: string; AContent, AResponse: TStream);
begin
  FIdHttp.Put(AUrl, AContent, AResponse)
end;

function THttpConnectionIndy.SetAcceptedLanguages(AAcceptedLanguages: string): IHttpConnection;
begin
  FIdHttp.Request.AcceptLanguage := AAcceptedLanguages;
  Result := Self;
end;

function THttpConnectionIndy.SetAcceptTypes(AAcceptTypes: string): IHttpConnection;
begin
  FIdHttp.Request.Accept := AAcceptTypes;
  Result := Self;
end;

function THttpConnectionIndy.SetContentTypes(AContentTypes: string): IHttpConnection;
begin
  FIdHttp.Request.ContentType := AContentTypes;
  Result := Self;
end;

function THttpConnectionIndy.SetHeaders(AHeaders: TStrings): IHttpConnection;
begin
  FIdHttp.Request.CustomHeaders.AddStrings(AHeaders);
  Result := Self;
end;

end.

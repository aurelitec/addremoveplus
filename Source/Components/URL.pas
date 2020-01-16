{ URL Component version 1.0 Copyright © 1997 by Alexander Meeder

With this control it's easy to add www-addresses, mail-addresses etc. behind menu-options, buttons etc.

How to use TURL:
1. First put this control on your form
2. Set the URLType property to one of the following nine types:
   File, Ftp, Gopher, Http, Https, Mailto, News, Telnet, Wais
3. Set the property URL to the desired address for instance: ameeder@dds.nl
4. Call the TURL.Execute method from the menu-click, button-click, ... event

Questions, suggestions etc. mail me: ameeder@dds.nl }

unit URL;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ShellAPI;

type
  TURLType = (utFile, utFtp, utGopher, utHttp, utHttps, utMailto, utNews, utTelnet, utWais);

  TURL = class(TComponent)
  private
    FURL: string;
    FURLType: TURLType;

    procedure SetURL(value: string);
    procedure SetURLType(value: TURLType);
  protected

  public
    constructor Create(AOwner: TComponent); override;
    function Execute: boolean;
  published
    property URL: string read FURL write SetURL;
    property URLType: TURLType read FURLType write SetURLType default utHttp;
  end;

procedure Register;

implementation

function ExecuteFile(const FileName, Params, DefaultDir: string; ShowCmd: Integer): THandle;
var
  zFileName, zParams, zDir: array[0..79] of Char;
begin
  Result := ShellExecute(Application.MainForm.Handle, nil, StrPCopy(zFileName, FileName),
                         StrPCopy(zParams, Params), StrPCopy(zDir, DefaultDir), ShowCmd);
end;

function TURL.Execute: boolean;
var
  HyperlinkType, URLString: string;
begin
  result := false;
  if FURL <> '' then
  begin
    case FURLType of
      utFile   : HyperlinkType := 'file://';
      utFtp    : HyperlinkType := 'ftp://';
      utGopher : HyperlinkType := 'gopher://';
      utHttp   : HyperlinkType := 'http://';
      utHttps  : HyperlinkType := 'https://';
      utMailto : HyperlinkType := 'mailto:';
      utNews   : HyperlinkType := 'news:';
      utTelnet : HyperlinkType := 'telnet:';
      utWais   : HyperlinkType := 'wais:';
    end;
    URLString := HyperlinkType + FURL;
    result := (ExecuteFile(URLString, '', '', SW_SHOWNOACTIVATE) > 32);
  end;
end;

procedure TURL.SetURL(value: string);
begin
  if value <> FURL then
     FURL := value;
end;

procedure TURL.SetURLType(value: TURLType);
begin
  if value <> FURLType then
     FURLType := value;
end;

constructor TURL.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FURLType := utHttp;
  FURL := '';
end;

procedure Register;
begin
  RegisterComponents('Third Parties', [TURL]);
end;

end.

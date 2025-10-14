(* C2PP
  ***************************************************************************

  Taquin DX Books

  Copyright 2021-2025 Patrick PREMARTIN under AGPL 3.0 license.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
  DEALINGS IN THE SOFTWARE.

  ***************************************************************************

  Author(s) :
  Patrick PREMARTIN

  Site :
  https://taquindxbooks.gamolf.fr

  Project site :
  https://github.com/DeveloppeurPascal/TaquinDXBooks

  ***************************************************************************
  File last update : 2025-10-14T10:31:39.551+02:00
  Signature : b83da748858ccf3064f7f27c8d6017e96e29ac97
  ***************************************************************************
*)

unit uDM;

interface

uses
  System.SysUtils, System.Classes, REST.Types, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, REST.Response.Adapter, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope;

type
  Tdm = class(TDataModule)
    RESTDelphiBooksAPI: TRESTClient;
    RESTListeDesLivres: TRESTRequest;
    RESTResponse1: TRESTResponse;
    RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
    tabListeDesLivres: TFDMemTable;
  private
    { Déclarations privées }
    procedure ChargeFicheDuLivre(ID: integer;
      Callback_ChargementItem: tproc<string, string, string>);
  public
    { Déclarations publiques }
    procedure InitialiseListeLivres(Callback_ChargementListe: tproc;
      Callback_ChargementItem: tproc<string, string, string>);
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}
{$R *.dfm}

uses
  System.threading, System.Net.HttpClient, System.json;

{ Tdm }

procedure Tdm.ChargeFicheDuLivre(ID: integer;
  Callback_ChargementItem: tproc<string, string, string>);
begin
  ttask.run(
    procedure
    var
      serveur: THTTPClient;
      reponse: IHTTPResponse;
      jso: tjsonobject;
      titre, url_livre, url_image: string;
    begin
      serveur := THTTPClient.Create;
      try
        reponse := serveur.Get('https://delphi-books.com/api/b/' + ID.tostring
          + '.json');
        if (reponse.StatusCode = 200) then
        begin
          jso := tjsonobject.ParseJSONValue(reponse.ContentAsString
            (tencoding.UTF8)) as tjsonobject;
          try
            if jso.TryGetValue<string>('name', titre) and
              jso.TryGetValue<string>('url', url_livre) and
              jso.TryGetValue<string>('cover_500w', url_image) then
              tthread.ForceQueue(nil,
                procedure
                begin
                  Callback_ChargementItem(titre, url_livre, url_image);
                end);
          finally
            jso.free;
          end;
        end;
      finally
        serveur.free;
      end;
    end);
end;

procedure Tdm.InitialiseListeLivres(Callback_ChargementListe: tproc;
Callback_ChargementItem: tproc<string, string, string>);
begin
  ttask.run(
    procedure
    begin
      // requête synchrone (bloquante), la table est remplie
      RESTListeDesLivres.Execute;
      tabListeDesLivres.First;
      while not tabListeDesLivres.eof do
      begin
        ChargeFicheDuLivre(tabListeDesLivres.FieldByName('id').asinteger,
          Callback_ChargementItem);
        tabListeDesLivres.Next;
      end;
      tthread.ForceQueue(nil,
        procedure
        begin
          Callback_ChargementListe;
        end);
    end);
end;

end.

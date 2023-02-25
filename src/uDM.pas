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

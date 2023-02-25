unit cImageAChoisir;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects;

type
  TonBtnJouerClick = procedure(NomImage: string) of object;

  TImageAChoisir = class(TFrame)
    Couverture: TImage;
    btnGoSite: TRectangle;
    btnJouer: TRectangle;
    txtGoSite: TText;
    txtJouer: TText;
    ecranAttente: TRectangle;
    ecranAttenteAnimation: TAniIndicator;
    procedure btnJouerClick(Sender: TObject);
    procedure btnGoSiteClick(Sender: TObject);
  private
    { Déclarations privées }
    FTitre, FUrlSite, FUrlImage: string;
    FonBtnJouerClick: TonBtnJouerClick;
    procedure SetonBtnJouerClick(const Value: TonBtnJouerClick);
    property onBtnJouerClick: TonBtnJouerClick read FonBtnJouerClick
      write SetonBtnJouerClick;
    function getNomImage: string;
    procedure AfficheEcranAttente;
    procedure MasquageEcranAttente;
  public
    { Déclarations publiques }
    constructor Create(AParent: TControl; ATitre, AURL_Site, AURL_Image: string;
      AonBtnJouerClick: TonBtnJouerClick); overload;
  end;

implementation

{$R *.fmx}

uses
  FMX.DialogService, u_urlOpen, System.IOUtils, uUtils, u_download;
{ TImageAChoisir }

procedure TImageAChoisir.AfficheEcranAttente;
begin
  ecranAttente.Visible := true;
  ecranAttente.BringToFront;
  ecranAttenteAnimation.Enabled := true;
end;

procedure TImageAChoisir.btnGoSiteClick(Sender: TObject);
begin
  // btnGoSite.Enabled:=false;
  TDialogService.MessageDialog('Afficher la page web du livre "' + FTitre +
    '" ?', TMsgDlgType.mtConfirmation, [tmsgdlgbtn.mbYes, tmsgdlgbtn.mbNo],
    tmsgdlgbtn.mbNo, 0,
    procedure(const AModalResult: TModalResult)
    begin
      if AModalResult = mrYes then
        url_Open_In_Browser(FUrlSite);
      btnGoSite.Enabled := true;
    end);
end;

procedure TImageAChoisir.btnJouerClick(Sender: TObject);
begin
  if assigned(FonBtnJouerClick) then
    FonBtnJouerClick(getNomImage);
end;

constructor TImageAChoisir.Create(AParent: TControl;
ATitre, AURL_Site, AURL_Image: string; AonBtnJouerClick: TonBtnJouerClick);
var
  FichierImage: string;
begin
  Create(AParent);
  name := '';
  parent := AParent;
  width := 200;
  height := 200;
  FTitre := ATitre;
  FUrlSite := AURL_Site;
  FUrlImage := AURL_Image;
  onBtnJouerClick := AonBtnJouerClick;
  FichierImage := getCheminVersImages(getNomImage);
  if tfile.Exists(FichierImage) then
  begin
    Couverture.bitmap.LoadFromFile(FichierImage);
    MasquageEcranAttente;
  end
  else
  begin
    AfficheEcranAttente;
    tdownload_file.download(AURL_Image, FichierImage,
      procedure
      begin
        Couverture.bitmap.LoadFromFile(FichierImage);
        MasquageEcranAttente;
      end,
      procedure
      begin
        tthread.forcequeue(nil,
          procedure
          begin
            self.free;
          end);
      end);
  end;
end;

function TImageAChoisir.getNomImage: string;
begin
  result := FUrlImage.Substring(FUrlImage.LastIndexOf('/') + 1);
end;

procedure TImageAChoisir.MasquageEcranAttente;
begin
  ecranAttenteAnimation.Enabled := false;
  ecranAttente.Visible := false;
end;

procedure TImageAChoisir.SetonBtnJouerClick(const Value: TonBtnJouerClick);
begin
  FonBtnJouerClick := Value;
end;

initialization

TDialogService.PreferredMode := TDialogService.TPreferredMode.Async;

end.

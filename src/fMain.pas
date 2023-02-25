unit fMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.StdCtrls, FMX.Objects, cCaseDuJeu;

type
  TfrmMain = class(TForm)
    ecranJeu: TLayout;
    ecranAccueil: TVertScrollBox;
    listeCouvertures: TFlowLayout;
    ecranAttente: TRectangle;
    ecranAttenteAnimation: TAniIndicator;
    zoneDeJeu: TScaledLayout;
    BordureDuJeu: TRectangle;
    btnJouer: TRectangle;
    txtJouer: TText;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnJouerClick(Sender: TObject);
  private
    { Déclarations privées }
    CaseMasquee: TCaseDuJeu;
    procedure AfficheEcranJeu;
    procedure AfficheEcranAccueil;
    procedure MasqueEcrans;
    procedure AfficheEcranAttente;
    procedure MasquageEcranAttente;
    procedure ViderListeCouvertures;
    procedure onBtnJouerClick(NomImage: string);
    procedure onFinDePartie(Sender: TObject);
    procedure CalculeTailleListeCouvertures;
    procedure AdapterTailleZoneDeJeu;
  public
    { Déclarations publiques }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses uDM, cImageAChoisir, uUtils, System.math, uInfosDuJeu;

procedure TfrmMain.AdapterTailleZoneDeJeu;
var
  Marge: integer;
  Largeur, Hauteur: Single;
  LargeurMax, HauteurMax: Single;
  W, H: Single;
begin
  // Taille de la zone dans laquelle afficher le jeu
  Marge := 10;
  LargeurMax := (ClientWidth - Marge * 2) - BordureDuJeu.margins.Left -
    BordureDuJeu.margins.right;
  HauteurMax := (ClientHeight - Marge * 2) - BordureDuJeu.margins.top -
    BordureDuJeu.margins.bottom;

  // Taille idéale de la zone de jeu
  // (en fonction de la taille d'origine de l'image à y afficher)
  Largeur := BordureDuJeu.padding.Left + zoneDeJeu.originalWidth +
    BordureDuJeu.padding.right;
  Hauteur := BordureDuJeu.padding.top + zoneDeJeu.originalheight +
    BordureDuJeu.padding.bottom;

  // Calcul de la nouvelle taille
  W := LargeurMax;
  H := W * Hauteur / Largeur;
  if (H > HauteurMax) then
  begin
    H := HauteurMax;
    W := H * Largeur / Hauteur;
  end;

  // Changement de la taille
  BordureDuJeu.beginupdate;
  BordureDuJeu.Width := W;
  BordureDuJeu.height := H;
  BordureDuJeu.endupdate;
end;

procedure TfrmMain.AfficheEcranAccueil;
begin
  MasqueEcrans;
  ecranAccueil.visible := true;
end;

procedure TfrmMain.AfficheEcranAttente;
begin
  ecranAttente.visible := true;
  ecranAttente.BringToFront;
  ecranAttenteAnimation.Enabled := true;
end;

procedure TfrmMain.AfficheEcranJeu;
begin
  MasqueEcrans;
  ecranJeu.visible := true;
end;

procedure TfrmMain.btnJouerClick(Sender: TObject);
var
  nb: integer;
  x, y: integer;
begin
  if (zoneDeJeu.ChildrenCount < 1) then
    raise Exception.create('Pas de cases pour l''image !');

  btnJouer.visible := false;

  // désactivation case vide
  PositionCaseVideX := CNbColonnes - 1;
  PositionCaseVideY := CNbLignes - 1;
  CaseMasquee := GrilleCasesDuJeu[PositionCaseVideX, PositionCaseVideY];
  CaseMasquee.visible := false;
  GrilleCasesDuJeu[PositionCaseVideX, PositionCaseVideY] := nil;

  // mélanger les cases
  nb := random(100) + 10;
  while (nb > 0) do
  begin
    dec(nb);
    if (random(100) > 50) then // colonne
    begin
      x := PositionCaseVideX;
      y := PositionCaseVideY + random(CNbLignes * 2) - CNbLignes;
      if y > CNbLignes - 1 then
        y := CNbLignes - 1;
      if y < 0 then
        y := 0;
    end
    else // ligne
    begin
      x := PositionCaseVideX + random(CNbColonnes * 2) - CNbColonnes;
      if x > CNbColonnes - 1 then
        x := CNbColonnes - 1;
      if x < 0 then
        x := 0;
      y := PositionCaseVideY;
    end;
    if ((x <> PositionCaseVideX) or (y <> PositionCaseVideY)) and
      assigned(GrilleCasesDuJeu[x, y]) then
    begin
      GrilleCasesDuJeu[x, y].ClickSurCase(false);
      PositionCaseVideX := x;
      PositionCaseVideY := y;
      if assigned(GrilleCasesDuJeu[PositionCaseVideX, PositionCaseVideY]) then
        raise Exception.create('oups');
    end;
  end;
  PartieDemarree := true;
end;

procedure TfrmMain.CalculeTailleListeCouvertures;
var
  YBasImage: Single;
  NewHeight: Single;
  o: tfmxobject;
  c: tcontrol;
begin
  NewHeight := 0;
  if (listeCouvertures.ChildrenCount > 0) then
    for o in listeCouvertures.Children do
      if (o is tcontrol) then
      begin
        c := o as tcontrol;
        YBasImage := c.Position.y + c.margins.top + c.height + c.margins.bottom
          + listeCouvertures.padding.bottom;
        if NewHeight < YBasImage then
          NewHeight := YBasImage;
      end;
  listeCouvertures.height := NewHeight;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  MasqueEcrans;
  AfficheEcranAttente;
  dm := tdm.create(Self);
  ViderListeCouvertures;
  dm.InitialiseListeLivres(
    procedure
    begin
      AfficheEcranAccueil;
      MasquageEcranAttente;
    end,
    procedure(titre, url_livre, url_image: string)
    var
      img: TImageAChoisir;
      YBasImage: Single;
    begin
      img := TImageAChoisir.create(listeCouvertures, titre, url_livre,
        url_image, onBtnJouerClick);
      YBasImage := img.Position.y + img.margins.top + img.height +
        img.margins.bottom + listeCouvertures.padding.bottom;
      if listeCouvertures.height < YBasImage then
        listeCouvertures.height := YBasImage;
    end);
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
  CalculeTailleListeCouvertures;
  AdapterTailleZoneDeJeu;
end;

procedure TfrmMain.MasquageEcranAttente;
begin
  ecranAttenteAnimation.Enabled := false;
  ecranAttente.visible := false;
end;

procedure TfrmMain.MasqueEcrans;
begin
  ecranJeu.visible := false;
  ecranAccueil.visible := false;
  MasquageEcranAttente;
end;

procedure TfrmMain.onBtnJouerClick(NomImage: string);
var
  bmp, imgCase: tbitmap;
  i, j: integer;
  W, H: integer;
begin
  while (zoneDeJeu.ChildrenCount > 0) do
    zoneDeJeu.Children[0].free;

  AfficheEcranJeu;

  NbCasesEnMouvement := 0;
  NbCasesALeurPlace := 0;

  // Charger le bitmap
  bmp := tbitmap.CreateFromFile(getCheminVersImages(NomImage));
  try
    // Mise à niveau des tailles de zones de jeu
    zoneDeJeu.originalWidth := bmp.Width;
    zoneDeJeu.originalheight := bmp.height;
    AdapterTailleZoneDeJeu;
    // Découper le bitmap en NbCxNbL cases
    W := trunc(bmp.Width / CNbColonnes);
    H := trunc(bmp.height / CNbLignes);
    for i := 0 to CNbColonnes - 1 do
      for j := 0 to CNbLignes - 1 do
      begin
        imgCase := tbitmap.create(W, H);
        imgCase.CopyFromBitmap(bmp, rect(i * W, j * H, (i + 1) * W,
          (j + 1) * H), 0, 0);
        GrilleCasesDuJeu[i, j] := TCaseDuJeu.create(zoneDeJeu, imgCase, i, j, i,
          j, onFinDePartie);
      end;
  finally
    bmp.free;
  end;
  btnJouer.visible := true;
end;

procedure TfrmMain.onFinDePartie(Sender: TObject);
begin
  CaseMasquee.visible := true;
  showmessage('Bravo, vous avez trouvé !');
  AfficheEcranAccueil;
end;

procedure TfrmMain.ViderListeCouvertures;
begin
  while (listeCouvertures.ChildrenCount > 0) do
    listeCouvertures.Children[0].free;
end;

initialization

randomize;
{$IFDEF DEBUG}
ReportMemoryLeaksOnShutdown := true;
{$ENDIF}

end.

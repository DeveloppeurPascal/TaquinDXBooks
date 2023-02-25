unit cCaseDuJeu;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Ani, uInfosDuJeu;

type
  TCaseDuJeu = class(TFrame)
    imgMorceau: TImage;
    AnimeLesDeplacements: TFloatAnimation;
    VisuASaPlace: TRectangle;
    procedure AnimeLesDeplacementsFinish(Sender: TObject);
    procedure ClickSurCase(AvecAnimation: boolean = true);
    procedure FrameClick(Sender: TObject);
  private
    { Déclarations privées }
    FOriginX, FOriginY: integer;
    Fx: integer;
    Fy: integer;
    FonFinDePartie: tnotifyevent;
    procedure Setx(const Value: integer);
    procedure Sety(const Value: integer);
    procedure SetonFinDePartie(const Value: tnotifyevent);
  public
    { Déclarations publiques }
    property x: integer read Fx write Setx;
    property y: integer read Fy write Sety;
    property onFinDePartie: tnotifyevent read FonFinDePartie
      write SetonFinDePartie;
    function estASaPlace: boolean;
    function estEnMouvement: boolean;
    procedure VersLeHaut(AvecAnimation: boolean = true);
    procedure VersLeBas(AvecAnimation: boolean = true);
    procedure VersLaGauche(AvecAnimation: boolean = true);
    procedure VersLaDroite(AvecAnimation: boolean = true);
    constructor Create(AParent: TControl; ABmp: TBitmap;
      AOriginX, AOriginY: integer; AX, AY: integer;
      AonFinDePartie: tnotifyevent); overload;
  end;

  TGrilleCasesDuJeu = array [0 .. (CNbColonnes - 1), 0 .. (CNbLignes - 1)
    ] of TCaseDuJeu;

var
  GrilleCasesDuJeu: TGrilleCasesDuJeu;

implementation

{$R *.fmx}

procedure TCaseDuJeu.AnimeLesDeplacementsFinish(Sender: TObject);
begin
  AnimeLesDeplacements.Enabled := false;
  dec(NbCasesEnMouvement);
end;

procedure TCaseDuJeu.ClickSurCase(AvecAnimation: boolean);
begin
  // désactive notre position dans la grille
  if (GrilleCasesDuJeu[x, y] = self) then
    GrilleCasesDuJeu[x, y] := nil;

  if estASaPlace then
    dec(NbCasesALeurPlace);

  // Déplacement de la case en cours
  if (x < positioncasevidex) then
    VersLaDroite(AvecAnimation)
  else if (x > positioncasevidex) then
    VersLaGauche(AvecAnimation)
  else if (y < positioncasevidey) then
    VersLeBas(AvecAnimation)
  else if (y > positioncasevidey) then
    VersLeHaut(AvecAnimation);

  // Déplacement des autres cases s'il y en a
  if assigned(GrilleCasesDuJeu[x, y]) then
    GrilleCasesDuJeu[x, y].ClickSurCase(AvecAnimation);

  // Positionnement de notre case sur la nouvelle
  GrilleCasesDuJeu[x, y] := self;

{$IFDEF DEBUG}
  if estASaPlace then
    VisuASaPlace.Stroke.Color := talphacolors.green
  else
    VisuASaPlace.Stroke.Color := talphacolors.orange;
{$ENDIF}
  if estASaPlace then
    inc(NbCasesALeurPlace);
end;

constructor TCaseDuJeu.Create(AParent: TControl; ABmp: TBitmap;
  AOriginX, AOriginY, AX, AY: integer; AonFinDePartie: tnotifyevent);
begin
  Create(AParent);
  name := '';
  parent := AParent;
  FOriginX := AOriginX;
  FOriginY := AOriginY;
  Fx := AX;
  Fy := AY;
  FonFinDePartie := AonFinDePartie;
  Width := ABmp.Width;
  height := ABmp.height;
  position.x := AX * Width;
  position.y := AY * height;
  imgMorceau.Bitmap.Assign(ABmp);
  ABmp.free;
{$IFDEF DEBUG}
  VisuASaPlace.Visible := true;
{$ELSE}
  VisuASaPlace.Visible := false;
{$ENDIF}
  if estASaPlace then
    inc(NbCasesALeurPlace);
end;

function TCaseDuJeu.estASaPlace: boolean;
begin
  result := (FOriginX = Fx) and (FOriginY = Fy);
end;

function TCaseDuJeu.estEnMouvement: boolean;
begin
  result := AnimeLesDeplacements.Enabled;
end;

procedure TCaseDuJeu.FrameClick(Sender: TObject);
var
  newx, newy: integer;
begin
  if PartieDemarree and ((x = positioncasevidex) or (y = positioncasevidey))
  then
  begin
    newx := x;
    newy := y;
    ClickSurCase(true);
    tthread.ForceQueue(nil,
      procedure
      begin
        positioncasevidex := newx;
        positioncasevidey := newy;
      end);
  end;

  if assigned(onFinDePartie) and (NbCasesALeurPlace = CNbColonnes * CNbLignes)
  then
    onFinDePartie(self);
end;

procedure TCaseDuJeu.SetonFinDePartie(const Value: tnotifyevent);
begin
  FonFinDePartie := Value;
end;

procedure TCaseDuJeu.Setx(const Value: integer);
begin
  Fx := Value;
end;

procedure TCaseDuJeu.Sety(const Value: integer);
begin
  Fy := Value;
end;

procedure TCaseDuJeu.VersLaDroite(AvecAnimation: boolean);
begin
  if (Fx < CNbColonnes - 1) and (not estEnMouvement) then
  begin
    inc(Fx);
    if AvecAnimation then
    begin
      inc(NbCasesEnMouvement);
      AnimeLesDeplacements.PropertyName := 'Position.X';
      AnimeLesDeplacements.StartFromCurrent := true;
      AnimeLesDeplacements.StopValue := Fx * Width;
      AnimeLesDeplacements.Start;
    end
    else
      position.x := Fx * Width;
  end;
end;

procedure TCaseDuJeu.VersLaGauche(AvecAnimation: boolean);
begin
  if (Fx > 0) and (not estEnMouvement) then
  begin
    dec(Fx);
    if AvecAnimation then
    begin
      inc(NbCasesEnMouvement);
      AnimeLesDeplacements.PropertyName := 'Position.X';
      AnimeLesDeplacements.StartFromCurrent := true;
      AnimeLesDeplacements.StopValue := Fx * Width;
      AnimeLesDeplacements.Start;
    end
    else
      position.x := Fx * Width;
  end;
end;

procedure TCaseDuJeu.VersLeBas(AvecAnimation: boolean);
begin
  if (Fy < CNbLignes - 1) and (not estEnMouvement) then
  begin
    inc(Fy);
    if AvecAnimation then
    begin
      inc(NbCasesEnMouvement);
      AnimeLesDeplacements.PropertyName := 'Position.Y';
      AnimeLesDeplacements.StartFromCurrent := true;
      AnimeLesDeplacements.StopValue := Fy * height;
      AnimeLesDeplacements.Start;
    end
    else
      position.y := Fy * height;
  end;
end;

procedure TCaseDuJeu.VersLeHaut(AvecAnimation: boolean);
begin
  if (Fy > 0) and (not estEnMouvement) then
  begin
    dec(Fy);
    if AvecAnimation then
    begin
      inc(NbCasesEnMouvement);
      AnimeLesDeplacements.PropertyName := 'Position.Y';
      AnimeLesDeplacements.StartFromCurrent := true;
      AnimeLesDeplacements.StopValue := Fy * height;
      AnimeLesDeplacements.Start;
    end
    else
      position.y := Fy * height;
  end;
end;

initialization

for var i := 0 to CNbColonnes - 1 do
  for var j := 0 to CNbLignes - 1 do
    GrilleCasesDuJeu[i, j] := nil;

end.

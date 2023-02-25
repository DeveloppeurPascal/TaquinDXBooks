unit uInfosDuJeu;

interface

const
  CNbColonnes = 4;
  CNbLignes = 4;

var
  NbCasesEnMouvement: integer;
  NbCasesALeurPlace: integer;
  PartieDemarree: boolean;
  PositionCaseVideX, PositionCaseVideY: integer;

implementation

initialization

NbCasesEnMouvement := 0;
NbCasesALeurPlace := 0;
PartieDemarree := false;

end.

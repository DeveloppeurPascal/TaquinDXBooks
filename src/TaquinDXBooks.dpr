program TaquinDXBooks;

uses
  System.StartUpCopy,
  FMX.Forms,
  fMain in 'fMain.pas' {frmMain},
  uDM in 'uDM.pas' {dm: TDataModule},
  cImageAChoisir in 'cImageAChoisir.pas' {ImageAChoisir: TFrame},
  uUtils in 'uUtils.pas',
  cCaseDuJeu in 'cCaseDuJeu.pas' {CaseDuJeu: TFrame},
  uInfosDuJeu in 'uInfosDuJeu.pas',
  u_urlOpen in '..\lib-externes\librairies\u_urlOpen.pas',
  u_download in '..\lib-externes\librairies\u_download.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.

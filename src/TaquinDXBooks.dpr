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
  File last update : 2025-10-14T10:31:39.543+02:00
  Signature : 8d86c8b1a6d899829285ee41e968f5a219364741
  ***************************************************************************
*)

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

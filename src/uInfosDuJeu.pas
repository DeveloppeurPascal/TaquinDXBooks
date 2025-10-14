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
  Signature : c899421f3cb54762ded4679a4bc4b0c83f3659a6
  ***************************************************************************
*)

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

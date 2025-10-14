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
  Signature : e27815f9eb7764f0d2bb2de9278a55510fbfa909
  ***************************************************************************
*)

unit uUtils;

interface

function getCheminVersStockageDuProgramme: string;
function getCheminVersImages(NomFichierImage: string = ''): string;

implementation

uses
  system.ioutils, system.SysUtils;

function getCheminVersStockageDuProgramme: string;
begin
{$IFDEF DEBUG}
  result := tpath.GetDocumentsPath;
{$ELSE}
  result := tpath.GetCachePath;
{$ENDIF}
  result := tpath.combine(result, tpath.GetFileNameWithoutExtension
    (paramstr(0)));
{$IFDEF DEBUG}
  result := tpath.combine(result, 'DebugMode');
{$ENDIF}
  if not TDirectory.Exists(result) then
    TDirectory.CreateDirectory(result);
end;

function getCheminVersImages(NomFichierImage: string): string;
begin
  result := tpath.combine(getCheminVersStockageDuProgramme, 'Images');
  if not TDirectory.Exists(result) then
    TDirectory.CreateDirectory(result);
  if not NomFichierImage.IsEmpty then
    result := tpath.combine(result, NomFichierImage);
end;

end.

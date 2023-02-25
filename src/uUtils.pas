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

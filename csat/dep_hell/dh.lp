% Predicates
% ----------

% Domain
% program(Program)
% version(Library, versionNumber)

% Problem instance
% requiresAtLeast(Program, RequiredLibrary, minVersion)
% requiresAtMost(Program, RequiredLibrary, maxVersion)
% installed(Library, versionNumber)

% Goal
% wants(Program).

% Plan
% shouldDelete(Library, number).
% shouldInstall(Library, number).
#show shouldDelete/2.
#show shouldInstall/2.


% Model
% -----
% asegurar que requiresAtMost y AtLeast hablan de versiones que existen
version(Library, VersionNumber) :- requiresAtMost(_, Library, VersionNumber).
version(Library, VersionNumber) :- requiresAtLeast(_, Library, VersionNumber).
version(Library, VersionNumber) :- installed(Library, VersionNumber).

% asegurar que se busca un programa en el goal
program(Program) :- wants(Program).

% si se quiere instalar un programa que requiere desde una version de una libreria, sugerir instalar alguna version que sirva y no este instalada
{ shouldInstall(Library, VersionNumber) : version(Library, VersionNumber) , VersionNumber >= MinVersion , not installed(Library, VersionNumber) }  :- wants(Program), requiresAtLeast(Program, Library, MinVersion).

% si se quiere instalar un programa que soporta hasta una version, sugerir eliminar todas las versiones que esten instaladas y que no sean compatibles
{ shouldDelete(Library, VersionNumber) : version(Library, VersionNumber) , VersionNumber > MaxVersion , installed(Library, VersionNumber) } :- wants(Program), requiresAtMost(Program, Library, MaxVersion).

% no debe pasar que se sugiera instalar una version si existe un programa que requiera al menos una version superior a la sigerida
:- shouldInstall(Library, VersionNumber) , wants(Program) , requiresAtLeast(Program, Library, MinVersion) , VersionNumber < MinVersion.

% lo mismo para requires at most
:- shouldInstall(Library, VersionNumber) , wants(Program) , requiresAtMost(Program, Library, MaxVersion) , VersionNumber > MaxVersion.

% asegurar que se usen las librerias mas nuevas posibles:
% el modelo óptimo será el modelo donde se sugiera instalar la librería no instalada de mayor VersionNumber, y donde se maximice tambien
% la libreria instalada de mayor VersionNumber
#maximize{VersionNumberShouldInstall , VersionNumberInstalled : shouldInstall(Library, VersionNumberShouldInstall) , installed(Library, VersionNumberInstalled)}.
% el modelo optimo sera el que sugiere eliminar las librerias mas antiguas
#minimize{VersionNumberShouldDelete : shouldDelete(Library, VersionNumberShouldDelete)}.

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

% { a(Program) : program(Program) , wants(Program) } = 1.
a(Program) :- program(Program).

% un programa es compatible con la version de una libreria si es que el programa requiere al menos una version del programa y la version es mayor o igual al minimo requerido
% isCompatible(Program, Library, VersionNumber) :- program(Program) , version(Library, VersionNumber) , requiresAtLeast(Program, Library, MinVersion) , VersionNumber >= MinVersion.

% lo mismo pero para cuando se especifica requires at most
% isCompatible(Program, Library, VersionNumber) :- program(Program) , version(Library, VersionNumber) , requiresAtMost(Program, Library, MaxVersion) , VersionNumber <= MaxVersion.

% sacar del modelo casos donde existe un tope de version compatible y ademas un minimo
% :- isCompatible(Program, Library, VersionNumber) , requiresAtLeast(Program, Library, MinVersion) , VersionNumber < MinVersion.
% :- isCompatible(Program, Library, VersionNumber) , requiresAtMost(Program, Library, MaxVersion) , VersionNumber > MaxVersion.

% si se quiere instalar un programa que requiere desde una version de una libreria, sugerir instalar alguna version que sirva y no este instalada
{ shouldInstall(Library, VersionNumber) : version(Library, VersionNumber) , VersionNumber >= MinVersion , not installed(Library, VersionNumber) }  :- wants(Program), requiresAtLeast(Program, Library, MinVersion).

% si se quiere instalar un programa que soporta hasta una version, sugerir eliminar todas las versiones que esten instaladas y que no sean compatibles
{ shouldDelete(Library, VersionNumber) : version(Library, VersionNumber) , VersionNumber > MaxVersion , installed(Library, VersionNumber) } :- wants(Program), requiresAtMost(Program, Library, MaxVersion).

% no debe pasar que se sugiera instalar una version si existe un programa que requiera al menos una version superior a la sigerida
:- shouldInstall(Library, VersionNumber) , wants(Program) , requiresAtLeast(Program, Library, MinVersion) , VersionNumber < MinVersion.

% lo mismo para requires at most
:- shouldInstall(Library, VersionNumber) , wants(Program) , requiresAtMost(Program, Library, MaxVersion) , VersionNumber > MaxVersion.

% TODO: Define the model

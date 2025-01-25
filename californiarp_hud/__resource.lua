resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

author 'vZLanaRhoadesXv'
description 'Clean & Simple HUD'
version '1.0.0'

ui_page 'html/ui.html'

files {
    'html/ui.html',
    'html/style.css',
    'html/script.js',
    'html/icons/player.png', -- Player-Icon
    'html/icons/money.png', -- Geld-Icon
    'html/icons/eat.png', -- Essen-Icon
    'html/icons/drink.png', -- Trinken-Icon
    'html/icons/jobs/police.png', -- Police-Icon für Polizei
    'html/icons/jobs/mechanic.png', -- Mechanic-Icon für Mechaniker
	'html/icons/jobs/unemployed.png', -- Unemployed-Icon für Arbeitslose
	'html/icons/jobs/fire.png', -- Feuer Icon für Feuerwehr
	'html/icons/jobs/ambulance.png', -- EMS Icon für Krankenhaus
	'html/icons/jobs/fisher.png', -- Fisher Icon für Angler
	'html/icons/jobs/hunter.png', -- Hunter Icon für Jäger
	'html/icons/jobs/realestate.png', -- Realestate Icon für Immobilienmakler
	'html/icons/jobs/miner.png', -- Miner Icon für Minenarbeiter
	'html/icons/jobs/taxi.png', -- Taxi Icon für Taxi Fahrer
	'html/icons/jobs/trash.png', -- Trash Icon für Müllwagenfahrer
	'html/icons/jobs/reporter.png', -- Reporter Icon für News Reporter Job
	'html/icons/jobs/friseur.png', -- Friseur Icon für Friseur Job
	'html/icons/jobs/gardener.png', -- Gardener Icon für Gärtner Job
	'html/icons/jobs/cardealer.png', -- Cardealer Icon für Autohausverkäufer
    'new-postals.json' -- JSON-Datei hinzufügen
}

client_scripts {
    'client/client.lua'
}



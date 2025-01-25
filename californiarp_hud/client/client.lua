ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(100)
    end
end)

local hunger = 100
local thirst = 100
local lastHUDState = {}
local lastTalkingStatus = false

-- Funktion: HUD nur aktualisieren, wenn sich etwas ändert
function updateHUDIfChanged(newState)
    local hasChanged = false

    for key, value in pairs(newState) do
        if lastHUDState[key] ~= value then
            hasChanged = true
            break
        end
    end

    if hasChanged then
        SendNUIMessage(newState)
        lastHUDState = newState
    end
end

-- Hunger und Durst aktualisieren
RegisterNetEvent('esx_status:onTick')
AddEventHandler('esx_status:onTick', function(status)
    for i = 1, #status do
        if status[i].name == 'hunger' then
            hunger = status[i].percent
        elseif status[i].name == 'thirst' then
            thirst = status[i].percent
        end
    end
end)

-- Event-Handler für das Laden des Charakters (Multichar-System)
AddEventHandler('esx:playerLoaded', function(playerData)
    print("Player loaded:", playerData)
    -- Daten werden in der Schleife verarbeitet
end)

-- HUD regelmäßig aktualisieren
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)

        local playerData = ESX.GetPlayerData()
        if playerData and playerData.accounts then
            local cash = 0
            for i = 1, #playerData.accounts do
                if playerData.accounts[i].name == "money" then
                    cash = playerData.accounts[i].money
                    break
                end
            end

            local job = playerData.job and playerData.job.label or "Unemployed"
            local jobIcon = playerData.job and playerData.job.name or "default"
            local id = GetPlayerServerId(PlayerId())

            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            local streetName, crossingRoad = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
            local streetLabel = GetStreetNameFromHashKey(streetName)

            local postalCode = getNearestPostal(coords)

            local hudState = {
                action = 'updateHUD',
                id = id,
                cash = cash,
                job = job,
                jobIcon = jobIcon,
                hunger = hunger,
                thirst = thirst,
                street = streetLabel,
                postal = postalCode
            }

            updateHUDIfChanged(hudState)
        else
            Citizen.Wait(1000)
        end
    end
end)

-- Senden von Informationen zum Gesprächsstatus
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        local isTalking = NetworkIsPlayerTalking(PlayerId())

        if isTalking ~= lastTalkingStatus then
            SendNUIMessage({
                action = 'updateTalkingStatus',
                isTalking = isTalking
            })
            lastTalkingStatus = isTalking
        end
    end
end)

-- PLZ integration
local postalData = {}

-- JSON-Datei laden
Citizen.CreateThread(function()
    local file = LoadResourceFile(GetCurrentResourceName(), "new-postals.json")
    postalData = json.decode(file)
end)

-- Funktion, um die nächste Postleitzahl zu finden
function getNearestPostal(coords)
    local nearestPostal = nil
    local nearestDistance = math.huge

    for _, postal in ipairs(postalData) do
        local distance = #(vector2(coords.x, coords.y) - vector2(postal.x, postal.y))
        if distance < nearestDistance then
            nearestDistance = distance
            nearestPostal = postal.code
        end
    end

    return nearestPostal
end

local postals = {}

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        local jsonData = LoadResourceFile(GetCurrentResourceName(), 'config/new-postals.json')
        if jsonData then
            postals = json.decode(jsonData)
        end
    end
end)


-- Postal command

RegisterCommand('postal', function(source, args, rawCommand)
    -- Überprüfen, ob eine PLZ eingegeben wurde
    if #args < 1 then
        TriggerEvent('chat:addMessage', {
            args = { '[System]', 'Bitte gib eine gültige PLZ ein!' }
        })
        return
    end

    local inputPostal = args[1] -- Die eingegebene PLZ
    local waypointSet = false

    -- Durchsuche die Postleitzahlen-Daten
    for _, postal in ipairs(postalData) do
        if tostring(postal.code) == tostring(inputPostal) then
            -- Wenn die PLZ gefunden wurde, Wegpunkt setzen
            SetNewWaypoint(postal.x, postal.y)
            TriggerEvent('chat:addMessage', {
                args = { '[System]', 'Wegpunkt zur PLZ ' .. inputPostal .. ' wurde gesetzt!' }
            })
            waypointSet = true
            break
        end
    end

    -- Falls keine Übereinstimmung gefunden wurde
    if not waypointSet then
        TriggerEvent('chat:addMessage', {
            args = { '[System]', 'PLZ ' .. inputPostal .. ' nicht gefunden!' }
        })
    end
end, false)


-- Vorschlag für den /postal Command hinzufügen
Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/postal', 'Setze einen Wegpunkt zu einer Postleitzahl.', {
        { name = 'PLZ', help = 'Die Postleitzahl, zu der du den Wegpunkt setzen möchtest' }
    })
end)



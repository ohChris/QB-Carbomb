QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

QBCore.Functions.CreateUseableItem("ied", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)

    TriggerClientEvent('RNG_CarBomb:CheckIfRequirementsAreMet', source)
end)

RegisterServerEvent('RNG_CarBomb:RemoveBombFromInv')
AddEventHandler('RNG_CarBomb:RemoveBombFromInv', function()
    local Player = QBCore.Functions.GetPlayer(source)

    Player.Functions.AddItem('ied', 1)
end)

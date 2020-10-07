QBCore = nil

Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        Citizen.Wait(200)
    end
end)

local timer = 0
local armedVeh
local ped = GetPlayerPed(-1)

RegisterNetEvent('RNG_CarBomb:CheckIfRequirementsAreMet')
AddEventHandler('RNG_CarBomb:CheckIfRequirementsAreMet', function()
    local ped = GetPlayerPed(-1)
    local coords = GetEntityCoords(ped)
    local veh = GetClosestVehicle(coords.x, coords.y, coords.z, 3.000, 0, 70)
    local vCoords = GetEntityCoords(veh)
    local dist = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, vCoords.x, vCoords.y, vCoords.z, false)
    local animDict = "anim@amb@business@weed@weed_inspecting_lo_med_hi@"
    local anim = "weed_spraybottle_crouch_base_inspector"

    if not IsPedInAnyVehicle(ped, false) then
        if veh and (dist < 3.0) then
            TriggerServerEvent('RNG_CarBomb:RemoveBombFromInv')
            loadAnimDict(animDict)
            Citizen.Wait(1000)
            TaskPlayAnim(ped, animDict, anim, 3.0, 1.0, -1, 0, 1, 0, 0, 0)
            QBCore.Functions.Progressbar("arm_car", "Arming car..", Config.TimeTakenToArm * 1000, false, true, {}, {}, {}, {}, function() -- Done
                Citizen.Wait(Config.TimeTakenToArm * 1000)
                ClearPedTasksImmediately(ped)
            end)

            if Config.DetonationType == 0 then
                QBCore.Functions.Notify("You have armed the car! The vehicle will explode in 10 seconds")
                RunTimer(veh)
            elseif Config.DetonationType == 1 then
                QBCore.Functions.Notify("The vehicle will explode once it reaches 60mph!")
                armedVeh = veh
            elseif Config.DetonationType == 2 then
                QBCore.Functions.Notify("You have armed the car! [G] to detonate")
                armedVeh = veh
            elseif Config.DetonationType == 3 then
                QBCore.Functions.Notify("You have armed the car! The vehicle will detonate once someone opens the door and timer hits 0")
                armedVeh = veh 
            elseif Config.DetonationType == 4 then
                QBCore.Functions.Notify("You have armed the car! The vehicle will detonate once someone opens the door")
                armedVeh = veh
            end 
            
            while armedVeh do
                Citizen.Wait(0)
                if Config.DetonationType == 1 and armedVeh then
                    local speed = GetEntitySpeed(armedVeh)
                    local SpeedKMH = speed * 3.6
                    local SpeedMPH = speed * 2.236936
                    
                    if Config.Speed == 'MPH' then
                        if SpeedMPH >= Config.maxSpeed then
                            DetonateVehicle(armedVeh)
                        end
                    elseif Config.Speed == 'KPH' then
                        if SpeedKMH >= Config.maxSpeed then
                            DetonateVehicle(armedVeh)
                        end 
                    end        
                elseif Config.DetonationType == 2 and armedVeh then
                    if IsControlJustReleased(0, Config.TriggerKey) then
                        DetonateVehicle(armedVeh)
                    end          
                elseif Config.DetonationType == 3 and armedVeh then
                    if not IsVehicleSeatFree(armedVeh, -1)  then
                        RunTimer(armedVeh)
                    elseif not IsVehicleSeatFree(armedVeh, 0) then   
                        RunTimer(armedVeh)
                    end
                elseif Config.DetonationType == 4 and armedVeh then
                    if not IsVehicleSeatFree(armedVeh, -1) then  
                        DetonateVehicle(armedVeh)
                    end          
                end    
            end
        else
            QBCore.Functions.Notify("No vehicles nearby!")
        end 
    else
        QBCore.Functions.Notify("You cannot arm the bomb while inside a vehicle!")
    end
end)

function RunTimer(veh)
    timer = Config.TimeUntilDetonation
    while timer > 0 do
        timer = timer - 1
        Citizen.Wait(1000)
        if timer == 0 then
            DetonateVehicle(veh)
        end
    end
end

function DetonateVehicle(veh)
    local vCoords = GetEntityCoords(veh)
    if DoesEntityExist(veh) then
        armedVeh = nil
        AddExplosion(vCoords.x, vCoords.y, vCoords.z, 5, 50.0, true, false, true)
    end
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(20)
    end
end

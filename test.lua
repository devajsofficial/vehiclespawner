spawnovan = nil

Citizen.CreateThread(function()
    while true do
        local kordinate = GetEntityCoords(PlayerPedId())
        for i=1, #Auta do  
            if #(kordinate - Auta[i].Lokacija) < DrawDistance then                                    
                if Auta[i].spawned == nil then
                    SpawnLocalCar(i) 
                end
            else
                DeleteEntity(Auta[i].spawnovan)
                Auta[i].spawnovan = nil                                
            end
            Wait(500)
        end
    end
end)

Citizen.CreateThread(function() 
    while true do
        for i=1, #Auta do
            if Auta[i].spawnovan ~= nil and Auta[i].okrecese then
                SetEntityHeading(Auta[i].spawnovan, GetEntityHeading(Auta[i].spawnovan) - 0.3)
            end
        end
        Wait(5)
    end
end)

function SpawnLocalCar(i)
    Citizen.CreateThread(function()
        local hash = GetHashKey(Auta[i].model)
        RequestModel(hash)
        local PokusajPonovo = 0
        while not HasModelLoaded(hash) do
            PokusajPonovo = PokusajPonovo + 1
            if PokusajPonovo > 2000 then return end
            Wait(0)
        end
        local autic = CreateVehicle(hash, Auta[i].Lokacija.x, Auta[i].Lokacija.y, Auta[i].Lokacija.z-1,Auta[i].heading, false, false)
        SetModelAsNoLongerNeeded(hash)
        SetVehicleEngineOn(autic, false)
        SetVehicleBrakeLights(autic, false)
        SetVehicleLights(autic, 0)
        SetVehicleLightsMode(autic, 0)
        SetVehicleInteriorlight(autic, false)
        SetVehicleOnGroundProperly(autic)
        FreezeEntityPosition(autic, true)
        SetVehicleCanBreak(autic, true)
        SetVehicleFullbeam(autic, false)
        if Zakljucano then
            SetVehicleDoorsLocked(autic, 2)
        end
        SetVehicleNumberPlateText(autic, Auta[i].tablice)
        Auta[i].spawnovan = autic
    end)
end

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then
        for i=1, #Auta do
            if Auta[i].spawnovan ~= nil then
                DeleteEntity(Auta[i].spawnovan)
            end
        end
    end
end)


spawned = nil

Citizen.CreateThread(function()
    while true do
        local dCoords = GetEntityCoords(PlayerPedId())
        for i=1, #Auta do  
            if #(dCoords - Auta[i].Lokacija) < DrawDistance then                                    
                if Auta[i].spawned == nil then
                    SpawnLocalCar(i) 
                end
            else
                DeleteEntity(Auta[i].spawned)
                Auta[i].spawned = nil                                
            end
            Wait(500)
        end
    end
end)

Citizen.CreateThread(function() 
    while true do
        for i=1, #Auta do
            if Auta[i].spawned ~= nil and Auta[i].okrecese then
                SetEntityHeading(Auta[i].spawned, GetEntityHeading(Auta[i].spawned) - 0.3)
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
        local vehicleeee = CreateVehicle(hash, Auta[i].Lokacija.x, Auta[i].Lokacija.y, Auta[i].Lokacija.z-1,Auta[i].heading, false, false)
        SetModelAsNoLongerNeeded(hash)
        SetVehicleEngineOn(vehicleeee, false)
        SetVehicleBrakeLights(vehicleeee, false)
        SetVehicleLights(vehicleeee, 0)
        SetVehicleLightsMode(vehicleeee, 0)
        SetVehicleInteriorlight(vehicleeee, false)
        SetVehicleOnGroundProperly(vehicleeee)
        FreezeEntityPosition(vehicleeee, true)
        SetVehicleCanBreak(vehicleeee, true)
        SetVehicleFullbeam(vehicleeee, false)
        if Zakljucano then
            SetVehicleDoorsLocked(vehicleeee, 2)
        end
        SetVehicleNumberPlateText(vehicleeee, Auta[i].tablice)
        Auta[i].spawned = vehicleeee
    end)
end

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then
        for i=1, #Auta do
            if Auta[i].spawned ~= nil then
                DeleteEntity(Auta[i].spawned)
            end
        end
    end
end)


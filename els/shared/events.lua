local lookup = {
    ["SINCOELS:changeStage"] = "SINCOELS:1",
    ["SINCOELS:toggleSiren"] = "SINCOELS:2",
    ["SINCOELS:toggleBullhorn"] = "SINCOELS:3",
    ["SINCOELS:patternChange"] = "SINCOELS:4",
    ["SINCOELS:vehicleRemoved"] = "SINCOELS:5",
    ["SINCOELS:indicatorChange"] = "SINCOELS:6"
}

local origRegisterNetEvent = RegisterNetEvent
RegisterNetEvent = function(name, callback)
    origRegisterNetEvent(lookup[name], callback)
end

if IsDuplicityVersion() then
    local origTriggerClientEvent = TriggerClientEvent
    TriggerClientEvent = function(name, target, ...)
        origTriggerClientEvent(lookup[name], target, ...)
    end

    TriggerClientScopeEvent = function(name, target, ...)
        exports["sinco-core"]:TriggerClientScopeEvent(lookup[name], target, ...)
    end
else
    local origTriggerServerEvent = TriggerServerEvent
    TriggerServerEvent = function(name, ...)
        origTriggerServerEvent(lookup[name], ...)
    end
end
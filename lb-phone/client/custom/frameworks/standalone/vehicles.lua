if Config.Framework ~= "standalone" then
    return
end

---Apply vehicle mods
---@param vehicle number
---@param vehicleData table
function ApplyVehicleMods(vehicle, vehicleData)
    -- Mods are applied inside sinco-core when the valet vehicle is spawned.
end

---Create a vehicle and apply vehicle mods
---@param vehicleData table
---@param coords vector3
---@return number? vehicle
function CreateFrameworkVehicle(vehicleData, coords)
    if GetResourceState("sinco-core") ~= "started" then
        return
    end

    return exports["sinco-core"]:spawnPhoneValetVehicle(vehicleData, coords)
end

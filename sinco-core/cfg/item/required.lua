local items = {}
local a = module("cfg/weapons")

SINCO.defInventoryItem("repairkit", "DIY Repair Kit", "Used to repair vehicles.", nil, 0.5)
SINCO.defInventoryItem("Headbag", "Head Bag", "Used to cover someone's head.", nil, 0.5)
SINCO.defInventoryItem("Shaver", "Shaver", "Used to shave someone's head.", nil, 0.5)
SINCO.defInventoryItem("handcuffkeys", "Handcuff Keys", "Used to uncuff someone.", nil, 0.5)
SINCO.defInventoryItem("handcuff", "Handcuffs", "Used to cuff someone.", nil, 1.0)
SINCO.defInventoryItem("boltcutters", "Bolt Cutters", "Used to rob houses.", nil, 5)
SINCO.defInventoryItem("binoculars", "Binoculars", "Used by vigilantes to tag bounty targets.", nil, 1.0)
SINCO.defInventoryItem("binos", "Binoculars", "Used by vigilantes to tag bounty targets.", nil, 1.0)
SINCO.defInventoryItem("vigilante_armour_plate", "Vigilante Armour Plate", "Armour plate for on-duty vigilantes.", nil, 5.0)
SINCO.defInventoryItem("jammer", "Vigilante Jammer (1 hour)", "Hides you from vigilante bounty pings.", nil, 1.0)
SINCO.defInventoryItem("Lockpick", "Lockpick", "Used to lockpick vehicles.", nil, 0.5)
SINCO.defInventoryItem("medkit", "Medkit", "Used to revive players.", nil, 5)
SINCO.defInventoryItem("armourplate", "Armour Plate", "", nil, 5)

local get_wname = function(weapon_id)
  for k,v in pairs(a.weapons) do
    if k == weapon_id then
      return v.name
    end
  end
end

--- weapon body
local wbody_name = function(args)
  return get_wname(args[2])
end

local wbody_desc = function(args)
  return ""
end

local wbody_choices = function(args)
  local choices = {}
  local fullidname = joinStrings(args,"|")

  choices["Equip"] = {function(player,choice)
    local user_id = SINCO.getUserId(player)
    if user_id then
      if SINCO.tryGetInventoryItem(user_id, fullidname, 1, true) then
        local weapons = {}
        weapons[args[2]] = {ammo = 0}
        for k,v in pairs(a.weapons) do
          if k == args[2] then
            if v.policeWeapon then
              if SINCO.hasPermission(user_id, 'police.armoury') then
                SINCOclient.giveWeapons(player, {weapons, false,globalpasskey})
              else
                SINCO.notify(player, '~r~You cannot equip this weapon.')
              end
            else
              SINCOclient.giveWeapons(player, {weapons, false,globalpasskey})
            end
          end
        end
      end
    end
  end}

  choices["Trash"] = {function(player,choice)
    local user_id = SINCO.getUserId(player)
    if user_id then
      if SINCO.getInventoryItemAmount(user_id, fullidname) > 1 then 
        SINCO.prompt(player,string.format("Amount to trash (max %s)",SINCO.getInventoryItemAmount(user_id,fullidname)),"",function(player,amount)
          local amount = parseInt(amount)
          local maxAmount = SINCO.getInventoryItemAmount(user_id, fullidname)
          if amount and amount > 0 and amount <= maxAmount then
            if SINCO.tryGetInventoryItem(user_id,fullidname,amount,false) then
              TriggerEvent('SINCO:RefreshInventory', player)
              SINCO.createDropBag(player, fullidname, amount)
              SINCO.notify(player, "Dropped ~r~"..SINCO.getItemName(fullidname).." ~s~"..amount)
              SINCOclient.playAnim(player,{true,{{"pickup_object","pickup_low",1}},false})
            else
              SINCO.notify(player, "~r~Invalid value.")
            end
          else
            SINCO.notify(player, "~r~Invalid value.")
          end
        end)
      else
        if SINCO.tryGetInventoryItem(user_id,fullidname,1,false) then
          TriggerEvent('SINCO:RefreshInventory', player)
          SINCO.createDropBag(player, fullidname, 1)
          SINCO.notify(player, "Dropped ~r~"..SINCO.getItemName(fullidname).." ~s~1")
          SINCOclient.playAnim(player,{true,{{"pickup_object","pickup_low",1}},false})
        else
          SINCO.notify(player, "~r~Invalid value.")
        end
      end
    end
  end}

  return choices
end

local wbody_weight = function(args)
  for k,v in pairs(a.weapons) do
    for c,d in pairs(args) do
      if k == d then
        if v.class == "Melee" then
          return 1.00
        elseif v.class == "Pistol" then
          return 5.00
        elseif v.class == "SMG" or v.class == "Shotgun" then
          return 7.50
        elseif v.class == "AR" then
          return 10.00
        elseif v.class == "Mosin" then
          return 7.50
        elseif v.class == "Heavy" or v.class == "LMG" then
          return 15.00
        elseif v.class == "Super" then
          return 20.00
        else
          return 1.00
        end
      end
    end
  end
end

SINCO.defInventoryItem("wbody", wbody_name, wbody_desc, wbody_choices, wbody_weight)

--- weapon ammo
local wammo_name = function(args)
  --print('helloo', json.encode(args))
  return args[1]
end

local wammo_desc = function(args)
  return ""
end

local wammo_choices = function(args)
  local choices = {}
  local fullidname = joinStrings(args,"|")
  local ammotype = nil;
  ammotype = args[1]

  choices["Load"] = {function(player,choice)
    local user_id = SINCO.getUserId(player)
    if user_id then
      local amount = SINCO.getInventoryItemAmount(user_id, fullidname)
      if string.find(fullidname, "Police") and not SINCO.hasPermission(user_id, 'police.armoury') then
        SINCO.notify(player, '~r~You cannot load this ammo.')
        local bulletAmount = SINCO.getInventoryItemAmount(user_id, fullidname)
        SINCO.tryGetInventoryItem(user_id, fullidname, bulletAmount, false)
        return
      end
      SINCO.prompt(player, "Amount to load ? (max "..amount..")", "", function(player,ramount)
        ramount = parseInt(ramount)
        if ramount <= 0 then
          SINCO.notify(player, '~r~Invalid amount!')
          return
        end
        SINCOclient.getWeapons(player, {}, function(uweapons) -- gets current weapons
          for k,v in pairs(a.weapons) do -- goes through new weapons cfg
            for c,d in pairs(uweapons) do -- goes through current weapons
              if k == c then  -- if weapon in new cfg is the same as in current weapons
                if fullidname == v.ammo then -- check if ammo being loaded is the same as the ammo for that gun
                  local currentAmmo = d.ammo or 0
                  local maxAmmo = 250
                  
                  -- Check if weapon is already at max capacity
                  if currentAmmo >= maxAmmo then
                    SINCO.notify(player, '~r~Weapon ammo is already full!')
                    return
                  end
                  
                  -- Calculate how much can actually be added
                  local ammoToAdd = math.min(ramount, maxAmmo - currentAmmo)
                  
                  -- Only consume the amount that can be added
                  if SINCO.tryGetInventoryItem(user_id, fullidname, ammoToAdd, true) then -- take ammo from inv
                    local weapons = {}
                    weapons[k] = {ammo = ammoToAdd}
                    SINCOclient.giveWeapons(player, {weapons,false,globalpasskey})
                    if ammoToAdd < ramount then
                      SINCO.notify(player, '~y~Only loaded '..ammoToAdd..' ammo (weapon was at '..currentAmmo..'/250)')
                    end
                    TriggerEvent('SINCO:RefreshInventory', player)
                    return
                  end
                end
              end
            end
          end
        end)
      end)
    end
  end}
  choices["LoadAll"] = {function(player,choice)
    local user_id = SINCO.getUserId(player)
    if user_id then
      ramount = parseInt(SINCO.getInventoryItemAmount(user_id, fullidname))
      if ramount > 250 then ramount = 250 end
      if string.find(fullidname, "Police") and not SINCO.hasPermission(user_id, 'police.armoury') then
        SINCO.notify(player, '~r~You cannot load this ammo.')
        local bulletAmount = SINCO.getInventoryItemAmount(user_id, fullidname)
        SINCO.tryGetInventoryItem(user_id, fullidname, bulletAmount, false)
        return
      end
      SINCOclient.getWeapons(player, {}, function(uweapons) -- gets current weapons
        for k,v in pairs(a.weapons) do -- goes through new weapons cfg
          for c,d in pairs(uweapons) do -- goes through current weapons
            if k == c then  -- if weapon in new cfg is the same as in current weapons
              if fullidname == v.ammo then -- check if ammo being loaded is the same as the ammo for that gun
                local currentAmmo = d.ammo or 0
                local maxAmmo = 250
                
                -- Check if weapon is already at max capacity
                if currentAmmo >= maxAmmo then
                  SINCO.notify(player, '~r~Weapon ammo is already full!')
                  return
                end
                
                -- Calculate how much can actually be added
                local ammoToAdd = math.min(ramount, maxAmmo - currentAmmo)
                
                -- Only consume the amount that can be added
                if SINCO.tryGetInventoryItem(user_id, fullidname, ammoToAdd, true) then -- take ammo from inv
                  local weapons = {}
                  weapons[k] = {ammo = ammoToAdd}
                  SINCOclient.giveWeapons(player, {weapons,false,globalpasskey})
                  if ammoToAdd < ramount then
                    SINCO.notify(player, '~y~Only loaded '..ammoToAdd..' ammo (weapon was at '..currentAmmo..'/250)')
                  end
                  TriggerEvent('SINCO:RefreshInventory', player)
                  return
                end
              end
            end
          end
        end
      end)
    end
  end}
  choices["GiveAll"] = {
    function(idname, player, choice)
        local user_id = SINCO.getUserId(player)

        if user_id == nil then
            return
        end

        local itemAmount = SINCO.getInventoryItemAmount(user_id, idname)

        if itemAmount <= 0 then
            SINCO.notify(player, '~r~You don\'t have any of that item to give!')
            return
        end

        SINCOclient.getNearestPlayers(player, {10}, function(nplayers)
            local numPlayers = 0
            local nplayerIds = {}

            for k, _ in pairs(nplayers) do
                numPlayers = numPlayers + 1
                table.insert(nplayerIds, k)
            end

            if numPlayers == 1 then
                local nplayerId = nplayerIds[1]
                local nuser_id = SINCO.getUserId(nplayerId)

                if nuser_id ~= nil then
                    local inventoryWeight = SINCO.getInventoryWeight(nuser_id)
                    local itemWeight = SINCO.getItemWeight(idname)
                    local maxWeight = SINCO.getInventoryMaxWeight(nuser_id)
                    local availableSpace = math.floor((maxWeight - inventoryWeight) / itemWeight)
                    local amountToGive = math.min(itemAmount, availableSpace)

                    if amountToGive > 0 then
                        if SINCO.tryGetInventoryItem(user_id, idname, amountToGive, true) then
                            SINCO.giveInventoryItem(nuser_id, idname, amountToGive, true)
                            TriggerEvent('SINCO:RefreshInventory', player)
                            TriggerEvent('SINCO:RefreshInventory', nplayerId)
                            SINCOclient.playAnim(player, {true, {{"mp_common", "givetake1_a", 1}}, false})
                            SINCOclient.playAnim(nplayerId, {true, {{"mp_common", "givetake2_a", 1}}, false})
                        else
                            SINCO.notify(player, '~r~Invalid value.')
                        end
                    end
                else
                    SINCO.notify(player, '~r~Invalid Temp ID for Player ' .. nplayerId)
                end
            elseif numPlayers > 1 then
                SINCOclient.NearbyDrawRect(player,{},function(nplayer)
                    nplayer = tonumber(nplayer)
                    if nplayer and nplayers[nplayer] then
                        local selectedPlayerId = nplayer
                        local selectedPlayer = nplayers[selectedPlayerId]
                        local nuser_id = SINCO.getUserId(selectedPlayerId)

                        if nuser_id ~= nil then
                            local inventoryWeight = SINCO.getInventoryWeight(nuser_id)
                            local itemWeight = SINCO.getItemWeight(idname)
                            local maxWeight = SINCO.getInventoryMaxWeight(nuser_id)
                            local availableSpace = math.floor((maxWeight - inventoryWeight) / itemWeight)
                            local amountToGive = math.min(itemAmount, availableSpace)

                            if amountToGive > 0 then
                                if SINCO.tryGetInventoryItem(user_id, idname, amountToGive, true) then
                                    SINCO.giveInventoryItem(nuser_id, idname, amountToGive, true)
                                    TriggerEvent('SINCO:RefreshInventory', player)
                                    TriggerEvent('SINCO:RefreshInventory', selectedPlayerId)
                                    SINCOclient.playAnim(player, {true, {{"mp_common", "givetake1_a", 1}}, false})
                                    SINCOclient.playAnim(selectedPlayerId, {true, {{"mp_common", "givetake2_a", 1}}, false})
                                else
                                    SINCO.notify(player, '~r~Invalid value.')
                                end
                            end
                        else
                            SINCO.notify(player, '~r~Invalid Temp ID for Player ' .. selectedPlayerId)
                        end
                    else
                        SINCO.notify(player, '~r~Invalid selection or player.')
                    end
                end)
            else
                SINCO.notify(player, '~r~Give selection cancelled.')
            end
        end)
    end
}
  return choices
end

local wammo_weight = function(args)
  return 0.01
end

for i,v in pairs(SINCOAmmoTypes) do
  SINCO.defInventoryItem(i, wammo_name, wammo_desc, wammo_choices, wammo_weight)
end

SINCO.defInventoryItem("wammo", wammo_name, wammo_desc, wammo_choices, wammo_weight)

return items


local items = {}

local cocaine_sniff = {}
cocaine_sniff["Take"] = {function(player,choice)
  local user_id = SINCO.getUserId(player)
  if user_id then
    if SINCO.tryGetInventoryItem(user_id,"Cocaine",1) then
      SINCO.notify(player, "~g~Snorting Cocaine.")
      TriggerEvent('SINCO:RefreshInventory', player)
      TriggerClientEvent('SINCO:cocaineEffect', player)
    end
  end
end}

local heroin_take = {}
heroin_take["Take"] = {function(player,choice)
  local user_id = SINCO.getUserId(player)
  if user_id then
    if SINCO.tryGetInventoryItem(user_id,"Heroin",1) then
      SINCO.notify(player, "~g~Injecting Heroin.")
      TriggerEvent('SINCO:RefreshInventory', player)
      TriggerClientEvent('SINCO:heroinEffect', player)
    end
  end
end}


local lsd_take = {}
lsd_take["Take"] = {function(player,choice)
  local user_id = SINCO.getUserId(player)
  if user_id then
    if SINCO.tryGetInventoryItem(user_id,"LSD",1) then
      SINCO.notify(player, "~g~Taking LSD.")
      TriggerEvent('SINCO:RefreshInventory', player)
      TriggerClientEvent('SINCO:doAcid', player)
    end
  end
end}

local morphine_choices = {}
morphine_choices["Take"] = {function(player,choice)
  local user_id = SINCO.getUserId(player)
  if user_id then
    if SINCO.tryGetInventoryItem(user_id,"Morphine",1) then
      TriggerEvent('SINCO:RefreshInventory', player)
      TriggerClientEvent('SINCO:applyMorphine', player)
    end
  end
end}

local taco_choices = {}
taco_choices["Take"] = {function(player,choice)
  local user_id = SINCO.getUserId(player)
  if user_id then
    if SINCO.tryGetInventoryItem(user_id,"Taco",1) then
      TriggerEvent('SINCO:RefreshInventory', player)
      TriggerClientEvent('SINCO:eatTaco', player)
    end
  end
end}

local redbull_choices = {}
redbull_choices["Drink"] = {function(player,choice)
  local user_id = SINCO.getUserId(player)
  if user_id then
    if SINCO.tryGetInventoryItem(user_id,"Redbull",1) then
      SINCO.notify(player, "~g~Drinking Redbull. You feel energized!")
      TriggerEvent('SINCO:RefreshInventory', player)
      TriggerClientEvent('SINCO:redbullEffect', player)
    end
  end
end}

-- Drugs
items["Cocaine"] = {"Cocaine","Some Cocaine.",function(args) return cocaine_sniff end,4}
items["Heroin"] = {"Heroin","Some Heroin.",function(args) return heroin_take end,4}
items["LSD"] = {"LSD","Some LSD.",function(args) return lsd_take end,4}

-- Edibles
items["Morphine"] = {"Morphine","Some Morphine.",function(args) return morphine_choices end,1}
items["Taco"] = {"Taco","A Taco.",function(args) return taco_choices end,1}

-- Energy Drinks
items["Redbull"] = {"Redbull","An energy drink that increases your speed limit to 300 for 1 minute.",function(args) return redbull_choices end,3.0}

return items

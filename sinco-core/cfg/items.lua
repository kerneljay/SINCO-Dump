local cfg = {}

cfg.items = {
  -- Copper
  ["Copper Ore"] = {"Copper Ore", "", nil, 1}, 
  ["Copper"] = {"Copper", "", nil, 4},
  -- Limestone
  ["Limestone Ore"] = {"Limestone Ore", "", nil, 1}, 
  ["Limestone"] = {"Limestone", "", nil, 4},
  -- Weed
  ["Weed leaf"] = {"Weed leaf", "", nil, 1}, 
  ["Weed"] = {"Weed", "", nil, 4},
  -- Gold
  ["Gold Ore"] = {"Gold Ore", "", nil, 1}, 
  ["Gold"] = {"Gold", "", nil, 4},
  -- Cocaine
  ["Coca leaf"] = {"Coca leaf", "", nil, 1}, 
  ["Cocaine"] = {"Cocaine", "", nil, 4},
  -- Heroin
  ["Opium Poppy"] = {"Opium Poppy", "", nil, 1}, 
  ["Heroin"] = {"Heroin", "", nil, 4},
  -- Meth
  ["Ephedra"] = {"Ephedra", "", nil, 1}, 
  ["Meth"] = {"Meth", "", nil, 4},
  -- Diamond
  ["Uncut Diamond"] = {"Uncut Diamond", "", nil, 1}, 
  ["Diamond"] = {"Diamond", "", nil, 4},
  -- LSD
  ["Frogs legs"] = {"Frogs legs", "", nil, 1},
  ["Lysergic Acid Amide"] = {"Lysergic Acid Amide", "", nil, 1}, 
  ["LSD"] = {"LSD", "", nil, 4},
  -- House Robberies
  ["boltcutters"] = {"Bolt Cutters", "", nil, 5},
  ["binoculars"] = {"Binoculars", "Used by vigilantes to tag bounty targets.", nil, 1.0},
  ["binos"] = {"Binoculars", "Used by vigilantes to tag bounty targets.", nil, 1.0},
  ["vigilante_armour_plate"] = {"Vigilante Armour Plate", "Armour plate for on-duty vigilantes.", nil, 5.0},
  ["jammer"] = {"Vigilante Jammer (1 hour)", "Hides you from vigilante bounty pings.", nil, 1.0},
  -- Bags
  ["greenhikingbackpack"] = {"Green Hiking Backpack", "", nil, 5.00},
  ["tanhikingbackpack"] = {"Tan Hiking Backpack", "", nil, 5.00}, 
  ["guccibag"] = {"Gucci Bag", "Just A Louis Vuitton Bag", nil, 5.00},
  ["offwhitebag"] = {"Off White Bag", "", nil, 5.00},
  ["nikebag"] = {"Nike Bag", "", nil, 5.00},
  ["huntingbackpack"] = {"Hunting Backpack", "", nil, 5.00},
  ["primarkbag"] = {"Primark Bag", "", nil, 5.00},
  ["rebelbackpack"] = {"Rebel Backpack", "", nil, 5.00},
    -- Misc
  ["burnerphone"] = {"Burner Phone", "", nil, 1.00},
  ["civradios"] = {"Civilian Radio", "", nil, 0.10},
  ["medkit"] = {"Medkit", "", nil, 5},
  ["redmoney"] = {"Dirty Cash", "", nil, 0.0},
  -- Fish Items
  ["Cod"] = {"Cod", "A common fish found in the ocean", nil, 1.0},
  ["Salmon"] = {"Salmon", "A tasty fish with orange flesh", nil, 2.5},
  ["Tuna"] = {"Tuna", "A large predatory fish", nil, 5.0},
  ["Mackerel"] = {"Mackerel", "A small common fish", nil, 0.8},
  ["Bass"] = {"Bass", "A medium-sized fish", nil, 1.5},
  ["Trout"] = {"Trout", "A freshwater fish", nil, 1.2},
  ["Swordfish"] = {"Swordfish", "A rare and valuable fish", nil, 8.0},
  ["Shark"] = {"Shark", "An extremely rare and dangerous catch", nil, 15.0},
}

local function load_item_pack(name)
  local items = module("cfg/item/"..name)
  if items then
    for k,v in pairs(items) do
      cfg.items[k] = v
    end
  else
    print("[SINCO] item pack ["..name.."] not found")
  end
end

-- PACKS
load_item_pack("required")
load_item_pack("drugs")

return cfg

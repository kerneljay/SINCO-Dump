resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"
this_is_a_map "yes"

files {
  -- Configs
  "configs/*.lua",
  "data/[Veh]/inventory.lua",
  "data/[Veh]/cfg_inventory.lua",
  "data/[Veh]/garages.lua",
  "data/[Veh]/cfg_garages.lua",
  "data/[Veh]/cfg_vehiclemaxspeeds.lua",

  -- Weapon Files
  "**/weaponcomponents.meta",
  "**/weaponcomponents_*.meta",
  "**/weaponarchetypes.meta",
  "**/weaponanimations.meta",
  "**/pedpersonality.meta",
  "**/weapons.meta",

  -- Clothing Files
  "stream/**/mp_m_freemode_01_mp_m_clothing.meta",
  "stream/**/mp_f_freemode_01_mp_f_clothing.meta",

  -- Vehicle Files
  "**/handling.meta",
  "**/vehicles.meta",
  "**/carvariations.meta",
  "**/carcols*.meta",

  -- Audio
  "dlc_hitmarkers/*.awc",

  -- Maps
  "stream/**/*.ytyp",
}

-- Weapon Files (components MUST load before weapons.meta)
data_file "WEAPONCOMPONENTSINFO_FILE" "**/weaponcomponents_1.meta"
data_file "WEAPONCOMPONENTSINFO_FILE" "**/weaponcomponents_2.meta"
data_file "WEAPONCOMPONENTSINFO_FILE" "**/weaponcomponents.meta"
data_file "WEAPON_METADATA_FILE" "**/weaponarchetypes.meta"
data_file "WEAPON_ANIMATIONS_FILE" "**/weaponanimations.meta"
data_file "PED_PERSONALITY_FILE" "**/pedpersonality.meta"
data_file "WEAPONINFO_FILE" "**/weapons.meta"

-- Clothing Files
data_file "SHOP_PED_APPAREL_META_FILE" "stream/**/mp_m_freemode_01_mp_m_clothing.meta"
data_file "SHOP_PED_APPAREL_META_FILE" "stream/**/mp_f_freemode_01_mp_f_clothing.meta"

-- Vehicle Files
data_file "HANDLING_FILE" "**/handling.meta"
data_file "VEHICLE_METADATA_FILE" "**/vehicles.meta"
data_file "VEHICLE_VARIATION_FILE" "**/carvariations.meta"
data_file "CARCOLS_FILE" "**/carcols*.meta"

-- Audio
data_file "AUDIO_WAVEPACK" "dlc_hitmarkers"

-- Maps
data_file "DLC_ITYP_REQUEST" 'stream/**/*.ytyp'

-- SINCO anti-cheat configuration

SINCO = {}

SINCO.Version = "1.0.0"

SINCO.ServerConfig = {
    Name = "SINCO",
    Port = "30120",
    Linux = false
}

-- Staff with this SINCO permission are trusted (no AC punishment).
SINCO.TrustStaffPermission = "admin.tickets"
SINCO.TrustStaffAlways = false

SINCO.ACE = {
    Enable = false,
    Admin = "SINCO.Admin",
    Whitelist = "SINCO.Whitelist",
    Unban = "SINCO.Unban"
}

SINCO.ChatSettings = {
    Enable = true,
    PrivateWarn = true
}

SINCO.ScreenShot = {
    Enable = false,
    Format = "PNG",
    Quality = 1
}

-- SINCO already owns connecting/bans. No extra connect cards.
SINCO.Connection = {
    AntiBlackListName = false,
    AntiVPN = false,
    HideIP = true,
    UseDeferrals = false,
    ShowConnectUI = false
}

SINCO.ServerRuntime = {
    EntityCreatedMonitor = true,
    EntityCreatedDelayMs = 750
}

SINCO.Detection = {
    RequirePlayerSpawned = true,
    RequireFrameworkLoaded = false,
    ReadyMaxWaitMs = 120000,
    MinimumClientReadyMs = 8000,
    ResourceRestartAssumeSpawnedMs = 8000,

    SpawnGraceMs = 20000,
    PostSpawnSettleMs = 18000,
    PostReadyGraceMs = 20000,
    FrameworkLoadGraceMs = 12000,
    RespawnGraceMs = 15000,
    PedChangeGraceMs = 12000,
    CameraGraceMs = 3500,
    GodmodeAfterReadyMs = 12000,

    EvidenceThreshold = 3,
    EvidenceWindowMs = 15000,
    GodmodeSamples = 6,
    ClientReportCooldownMs = 10000,
    ServerReportWindowMs = 10000,
    ServerReportLimit = 6
}

SINCO.Message = {
    Kick = "You've been kicked by SINCO Anti-Cheat.",
    Ban = "You've been banned by SINCO Anti-Cheat. Appeal at discord.gg/sinco",
}

-- Players only see the number. Staff logs still include the name.
SINCO.ReasonNames = {
    [1] = "Health Hack",
    [2] = "Armor Hack",
    [3] = "Spectate",
    [4] = "Godmode",
    [5] = "Invisibility",
    [6] = "Tiny Ped",
    [7] = "Ped Changer",
    [8] = "Free Cam",
    [9] = "Teleport",
    [10] = "Noclip",
    [11] = "Blacklisted Weapon",
    [12] = "Weapon Damage",
    [13] = "Infinite Stamina",
    [14] = "Night Vision",
    [15] = "Thermal Vision",
    [16] = "Blacklisted Task",
    [17] = "Blacklisted Animation",
    [18] = "Plate Changer",
    [19] = "Blacklisted Plate",
    [20] = "Rainbow Vehicle",
    [21] = "Speed Changer",
    [22] = "Pickup Collect",
    [23] = "Suicide",
    [24] = "Super Jump",
    [25] = "Inject / Resource",
    [26] = "Give Weapon",
    [27] = "Remove Weapon",
    [28] = "Spam Trigger",
    [29] = "Blacklisted Command",
    [30] = "Blacklisted Word",
    [31] = "Spam Chat",
    [32] = "Blacklisted Event",
    [33] = "Explosion",
    [34] = "Explosion Spam",
    [35] = "Play Sound",
    [36] = "Tazer Spam",
    [37] = "Clear Ped Tasks",
    [38] = "Bring All",
    [39] = "Blacklisted Entity",
    [40] = "Entity Spam",
    [41] = "Unauthorized Event",
    [42] = "Blocked Name",
}

SINCO.ReasonIds = {
    ["Anti Health Hack"] = 1,
    ["Anti Armor Hack"] = 2,
    ["Anti Spectate"] = 3,
    ["Anti Godmode"] = 4,
    ["Anti Invisible"] = 5,
    ["Anti Tiny Ped"] = 6,
    ["Anti Ped Changer"] = 7,
    ["Anti Free Cam"] = 8,
    ["Anti Teleport"] = 9,
    ["Anti Noclip"] = 10,
    ["Anti Black List Weapon"] = 11,
    ["Anti Weapon Damage Changer"] = 12,
    ["Anti Infinite Stamina"] = 13,
    ["Anti Night Vision"] = 14,
    ["Anti Thermal Vision"] = 15,
    ["Anti Black List Tasks"] = 16,
    ["Anti Black List Animation"] = 17,
    ["Anti Plate Changer"] = 18,
    ["Anti Black List Plate"] = 19,
    ["Anti Rainbow"] = 20,
    ["Anti Speed Changer"] = 21,
    ["Anti Collected Pickup"] = 22,
    ["Anti Suicide"] = 23,
    ["Anti Superjump"] = 24,
    ["Anti Inject"] = 25,
    ["Anti Add Weapon"] = 26,
    ["Anti Remove Weapon"] = 27,
    ["Anti Remove All Weapon"] = 27,
    ["Anti Spam Trigger"] = 28,
    ["Anti Black List Commands"] = 29,
    ["Anti Bad Word"] = 30,
    ["Anti Spam Chat"] = 31,
    ["Anti Black List Trigger"] = 32,
    ["Anti Explosion"] = 33,
    ["Anti Spam Explosion"] = 34,
    ["Anti Play Sound"] = 35,
    ["Anti Spam Tazer"] = 36,
    ["Anti Clear Ped Tasks"] = 37,
    ["Anti Bring All Players"] = 38,
    ["Anti Spawn Ped"] = 39,
    ["Anti Spawn Vehicle"] = 39,
    ["Anti Spawn Object"] = 39,
    ["Anti Spam Ped"] = 40,
    ["Anti Spam Vehicle"] = 40,
    ["Anti Spam Object"] = 40,
    ["Unauthorized Event"] = 41,
    ["Blocked Name"] = 42,
}

SINCO.AdminMenu = {
    Enable = false,
    Key = "F9",
    MenuPunishment = "BAN"
}

-- Do not enable. Health probes/restores stand players up from coma.
SINCO.AntiHealthHack = false
SINCO.MaxHealth = 200
SINCO.HealthPunishment = "BAN"

SINCO.AntiArmorHack = false
SINCO.MaxArmor = 100
SINCO.ArmorPunishment = "BAN"

SINCO.AntiBlacklistTasks = false
SINCO.TasksPunishment = "BAN"

SINCO.AntiBlacklistAnims = false
SINCO.AnimsPunishment = "BAN"

SINCO.AntiInfinityAmmo = false

SINCO.AntiSpectate = false
SINCO.SpactatePunishment = "BAN"
SINCO.SpectatePunishment = SINCO.SpactatePunishment

SINCO.AntiBlackListWeapon = false
SINCO.AntiAddWeapon = false
SINCO.AntiRemoveWeapon = false
SINCO.WeaponPunishment = "BAN"

SINCO.AntiGodMode = false
SINCO.GodPunishment = "WARN"

SINCO.AntiInvisible = false
SINCO.InvisiblePunishment = "KICK"

SINCO.AntiChangeSpeed = false
SINCO.SpeedPunishment = "KICK"

SINCO.AntiFreeCam = false
SINCO.CamPunishment = "BAN"

-- Plate/colour changes happen in LS Customs on this server.
SINCO.AntiRainbowVehicle = false
SINCO.RainbowPunishment = "BAN"

SINCO.AntiPlateChanger = false
SINCO.AntiBlackListPlate = true
SINCO.PlatePunishment = "BAN"

SINCO.AntiNightVision = false
SINCO.AntiThermalVision = true
SINCO.VisionPunishment = "BAN"

SINCO.AntiSuperJump = false
SINCO.JumpPunishment = "BAN"

SINCO.AntiTeleport = false
SINCO.MaxFootDistance = 250
SINCO.MaxVehicleDistance = 800
SINCO.TeleportPunishment = "WARN"

SINCO.AntiNoclip = false
SINCO.NoclipPunishment = "KICK"

SINCO.AntiPedChanger = false
SINCO.PedChangePunishment = "BAN"

SINCO.AntiInfiniteStamina = false
SINCO.InfinitePunishment = "WARN"

SINCO.AntiTinyPed = false
SINCO.PedFlagPunishment = "BAN"

SINCO.AntiSuicide = false
SINCO.SuicidePunishment = "WARN"

SINCO.AntiPickupCollect = false
SINCO.PickupPunishment = "BAN"

SINCO.AntiSpamChat = false
SINCO.MaxMessage = 10
SINCO.CoolDownSec = 3
SINCO.ChatPunishment = "KICK"

SINCO.AntiBlackListCommands = false
SINCO.CMDPunishment = "BAN"

SINCO.AntiWeaponDamageChanger = false
SINCO.DamagePunishment = "BAN"

SINCO.AntiBlackListWord = false
SINCO.WordPunishment = "KICK"

SINCO.AntiBringAll = false
SINCO.BringAllPunishment = "BAN"

SINCO.AntiBlackListTrigger = false
SINCO.AntiSpamTrigger = true
SINCO.TriggerPunishment = "BAN"

SINCO.AntiClearPedTasks = false
SINCO.MaxClearPedTasks = 5
SINCO.CPTPunishment = "BAN"

SINCO.AntiTazePlayers = false
SINCO.MaxTazeSpam = 8
SINCO.TazePunishment = "KICK"

SINCO.AntiInject = false
SINCO.InjectPunishment = "BAN"

SINCO.AntiExplosionSpam = false
SINCO.MaxExplosion = 1
SINCO.ExplosionSpamPunishment = "BAN"
SINCO.BlockScriptExplosions = false
SINCO.ExplosionAllowRadius = 40.0

SINCO.AntiBlackListObject = true
SINCO.AntiBlackListPed = true
SINCO.AntiBlackListBuilding = true
SINCO.AntiBlackListVehicle = true
SINCO.EntityPunishment = "BAN"

SINCO.AntiSpamVehicle = true
SINCO.MaxVehicle = 3

SINCO.BlockUnauthorizedVehicles = true
-- Cancel cheat cars in entityCreating so they never sync onto other players.
SINCO.VehicleAllowRadius = 150.0
SINCO.UnauthorizedVehiclePunish = 4

SINCO.AntiSpamPed = true
SINCO.MaxPed = 4

SINCO.AntiSpamObject = true
SINCO.MaxObject = 15
-- Cancel cheat props dropped onto other players (cages, ramps on a victim).
SINCO.BlockUnauthorizedObjects = false
SINCO.ObjectAllowRadius = 45.0
SINCO.ObjectOnPlayerRadius = 10.0
SINCO.UnauthorizedObjectPunish = 2


SINCO.AntiChangePerm = false
SINCO.PermPunishment = "BAN"

SINCO.AntiPlaySound = true
SINCO.SoundPunishment = "KICK"

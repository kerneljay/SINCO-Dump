local cfg = {}

cfg.crimeAmounts = {
    storeRobbery = 200000,
    smallBankRobbery = 500000,
    jeweleryHeist = 1000000,
    bigBankHeist = 2500000,
    atmRobbery = 50000,
    clothingRobbery = 50000,
    illegalTrucking = 5000,
    illegalPiloting = 5000,
    lockPicking = 50000,
    boltCutting = 150000,
    murder = 50000,
    murderEmergencyService = 150000,
    vigilanteAttackEmergencyService = 100000,
}

cfg.cityPosition = vector3(-225.30703735352, -916.74755859375, 31.216938018799)
cfg.cityRadius = 750.0

cfg.targetSuspectedRadius = 400.0
cfg.targetSuspectedInaccuracy = 300.0

cfg.minTargetThreshold = 500000
cfg.minRefreshTimeMsec = 300000

cfg.jailTimeIncrement = 150
cfg.moneyPerEachJailIncrement = 250000
cfg.maxJailTimeSecs = 1800
cfg.policeBountyCommission = 0.25

cfg.amountToChatAnnounce = 5000000
cfg.maxNumOtherPlayersToShareWith = 3
cfg.automaticKickTimerMsec = 5400000
cfg.inactiveBountyBucketTimeMsec = 300000
cfg.inactiveGreenzoneTimeMsec = 180000

cfg.bases = {
    {
        position = vector3(-443.0783996582, 6007.0288085938, 31.742444992065),
        radius = 30.0,
        gunstoreLocation = vector3(-440.0634765625, 5991.97265625, 31.711624145508),
        groupSelectorLocation = vector3(-438.8489074707, 6002.2446289062, 31.716241836548),
        marketLocation = vector3(-437.71588134766, 5988.396484375, 31.716173171997),
    },
}

cfg.pardonMaximumAmount = 500000
cfg.maxTargetsPerPlayer = 3
cfg.maxVigilantesPerBounty = 3
cfg.jailCountdownMsec = 30000

cfg.levels = {
    { minRequired = 0,    gunPayout = 0,    circleScale = 1.0, payoutPercent = 30, weaponGroups = {"vigilanteglock"}, armourPercent = 50 },
    { minRequired = 25,   gunPayout = 0,    circleScale = 1.0, payoutPercent = 40, weaponGroups = {"vigilanteglock", "vigilantesting"}, armourPercent = 50 },
    { minRequired = 50,   gunPayout = 0,    circleScale = 1.0, payoutPercent = 40, weaponGroups = {"vigilanteglock", "vigilantesting"}, armourPercent = 50 },
    { minRequired = 100,  gunPayout = 0.01, circleScale = 1.0, payoutPercent = 40, weaponGroups = {"vigilanteglock", "vigilantesting", "vigilantespar16"}, armourPercent = 75 },
    { minRequired = 150,  gunPayout = 0.01, circleScale = 1.0, payoutPercent = 50, weaponGroups = {"vigilanteglock", "vigilantesting", "vigilantespar16"}, armourPercent = 75 },
    { minRequired = 200,  gunPayout = 0.01, circleScale = 1.0, payoutPercent = 50, weaponGroups = {"vigilanteglock", "vigilantesting", "vigilantespar16"}, armourPercent = 75 },
    { minRequired = 250,  gunPayout = 0.01, circleScale = 0.9, payoutPercent = 50, weaponGroups = {"vigilanteglock", "vigilantesting", "vigilantespar16"}, armourPercent = 75 },
    { minRequired = 300,  gunPayout = 0.02, circleScale = 0.9, payoutPercent = 50, weaponGroups = {"vigilanteglock", "vigilantesting", "vigilantespar16"}, armourPercent = 75 },
    { minRequired = 400,  gunPayout = 0.02, circleScale = 0.9, payoutPercent = 50, weaponGroups = {"vigilanteglock", "vigilantesting", "vigilantespar16"}, armourPercent = 100 },
    { minRequired = 500,  gunPayout = 0.02, circleScale = 0.9, payoutPercent = 60, weaponGroups = {"vigilanteglock", "vigilantesting", "vigilantespar16"}, armourPercent = 100 },
    { minRequired = 600,  gunPayout = 0.02, circleScale = 0.8, payoutPercent = 60, weaponGroups = {"vigilanteglock", "vigilantesting", "vigilantespar16"}, armourPercent = 100 },
    { minRequired = 750,  gunPayout = 0.03, circleScale = 0.8, payoutPercent = 65, weaponGroups = {"vigilanteglock", "vigilantesting", "vigilantespar16"}, armourPercent = 100 },
    { minRequired = 800,  gunPayout = 0.03, circleScale = 0.7, payoutPercent = 65, weaponGroups = {"vigilanteglock", "vigilantesting", "vigilantespar16"}, armourPercent = 100 },
    { minRequired = 900,  gunPayout = 0.03, circleScale = 0.7, payoutPercent = 65, weaponGroups = {"vigilanteglock", "vigilantesting", "vigilantespar16"}, armourPercent = 100 },
    { minRequired = 1000, gunPayout = 0.04, circleScale = 0.7, payoutPercent = 65, weaponGroups = {"vigilanteglock", "vigilantesting", "vigilantespar16", "vigilantemosin"}, armourPercent = 100 },
    { minRequired = 1500, gunPayout = 0.04, circleScale = 0.7, payoutPercent = 75, weaponGroups = {"vigilanteglock", "vigilantesting", "vigilantespar16", "vigilantemosin"}, armourPercent = 100 },
    { minRequired = 2000, gunPayout = 0.04, circleScale = 0.7, payoutPercent = 80, weaponGroups = {"vigilanteglock", "vigilantesting", "vigilantespar16", "vigilantemosin"}, armourPercent = 100 },
    { minRequired = 2500, gunPayout = 0.04, circleScale = 0.6, payoutPercent = 80, weaponGroups = {"vigilanteglock", "vigilantesting", "vigilantespar16", "vigilantemosin"}, armourPercent = 100 },
    { minRequired = 3000, gunPayout = 0.04, circleScale = 0.5, payoutPercent = 80, weaponGroups = {"vigilanteglock", "vigilantesting", "vigilantespar16", "vigilantemosin"}, armourPercent = 100 },
    { minRequired = 4000, gunPayout = 0.05, circleScale = 0.5, payoutPercent = 90, weaponGroups = {"vigilanteglock", "vigilantesting", "vigilantespar16", "vigilantemosin"}, armourPercent = 100 },
}

cfg.weaponGroups = {
    vigilanteglock = { "WEAPON_VIGILANTE45ACP" },
    vigilantesting = { "WEAPON_VIGILANTESTINGER" },
    vigilantespar16 = { "WEAPON_VIGILANTESPAR16" },
    vigilantemosin = { "WEAPON_VIGILANTEMOSIN" },
}

cfg.weaponClassToGroup = {
    ["Pistol"] = "vigilanteglock",
    ["SMG"] = "vigilantesting",
    ["Shotgun"] = "vigilantesting",
    ["AR"] = "vigilantespar16",
    ["Heavy"] = "vigilantemosin",
}

cfg.nonLethalAmmo = {
    ["Rubber Bullets"] = true,
    ["plastic"] = true,
}

cfg.marketItems = {
    { item = "Headbag", name = "Head Bag", price = 5000, desc = "Cover a nearby player's head." },
    { item = "handcuffkeys", name = "Handcuff Keys", price = 1000, desc = "Uncuff a nearby player." },
    { item = "binoculars", name = "Binoculars", price = 5000, desc = "Tag bounty targets from range." },
    { item = "handcuff", name = "Handcuffs", price = 5000, desc = "Cuff a nearby player from the radial." },
    { item = "civradios", name = "Civilian Radio", price = 10000, desc = "Talk on civilian radio channels." },
    { item = "vigilante_armour_plate", name = "Vigilante Armour Plate", price = 25000, desc = "Apply armour while on duty." },
    { item = "Morphine", name = "Morphine", price = 50000, desc = "Recover a small amount of health." },
    { item = "repairkit", name = "DIY Repair Kit", price = 100000, desc = "Repair a nearby vehicle." },
    { item = "Shaver", name = "Electric Shaver", price = 250000, desc = "Shave a nearby player's head." },
}

cfg.statsBoardModel = `v_ilev_mm_screen2`
cfg.statsBoardLocations = {
    vector4(-441.5, 6005.0, 31.742444992065, 45.0),
}

cfg.licensePrice = 2500000
cfg.knockoutDurationMsec = 60000
cfg.tagLongIdsDurationMsec = 15000

return cfg

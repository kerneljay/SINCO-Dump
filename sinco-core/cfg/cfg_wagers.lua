cfg = {}

cfg.settings = {
    wagerStartLoc = vector3(-2148.5908203125, 5129.4731445312, 2.799998998642),
    wagerBetAmount = 100000,
    wagerMinBet = 100000,
    wagerMaxBet = 100000000,
    categoryIndex = 1,
    maxTeamPlayers = 4,
    ["categories"] = {
        "Pistols",
        "Shotguns",
        "SMGs",
        "Assault Rifles",
        "Snipers",
    },
    weaponInCategoryIndex = 1,
    ["weapons_in_category"] = {
        ["Pistols"] = {
            ["WEAPON_M1911CMG"] = "",
            ["WEAPON_ROOKCMG"] = "",
        },
        ["Shotguns"] = {
            ["WEAPON_OLYMPIACMG"] = "",
            ["WEAPON_SPAZ"] = "",
            ["WEAPON_WINCHESTER12CMG"] = "",
        },
        ["SMGs"] = {
            ["WEAPON_UMP45CMG"] = "",
            ["WEAPON_UZICMG"] = "",
        },
        ["Assault Rifles"] = {
            ["WEAPON_AKMCMG"] = "",
            ["WEAPON_MXM"] = "",
            ["WEAPON_AK74KASHNARCMG"] = "",
        },
        ["Snipers"] = {
            ["WEAPON_MOSINCMG"] = "",
            ["WEAPON_SVDCMG"] = "",
            ["WEAPON_MK14CMG"] = "",
        },
    },
    armour_index = 1,
    ["armour_values"] = {
        "0%",
        "25%",
        "50%",
        "75%",
        "100%",
    },
    roundSeconds = 180,
    best_ofIndex = 1,
    ["best_of"] = {
        "1",
        "3",
        "5",
        "11",
        "21",
    },
    warmupBucket = 450,
    warmupWeapon = "WEAPON_MOSINCMG",
    warmupSpawns = {
        vector3(3537.0327148438, 3752.7180175781, 29.922552108765),
        vector3(3478.7780761719, 3753.4174804688, 32.679676055908),
        vector3(3531.5654296875, 3647.763671875, 36.984058380127),
        vector3(3609.9208984375, 3709.6599121094, 35.154830932617),
        vector3(3462.6850585938, 3742.1586914062, 36.642673492432),
        vector3(3466.9233398438, 3696.5141601562, 33.026454925537),
        vector3(3579.4992675781, 3690.8852539062, 40.808330535889),
    },
    locationIndex = 1,
    ["locations"] = {
        ["rooftop"] = "Roof Top",
        ["oil_rig"] = "Oil Rig",
        ["heroin"] = "Heroin",
        ["large_arms"] = "Large Arms",
        ["ramps"] = "Ramps",
        ["rebel"] = "Rebel",
        ["blocks"] = "Blocks",
        ["Craft"] = "Craft",
        ["lsd_north"] = "LSD North",
        ["small_arena_1"] = "Small Arena 1",
        ["large_arena_3"] = "Large Arena 3",
        ["dust"] = "Dust",
        ["large_helipad"] = "Large Helipad",
        ["neon_pvp_arena_1"] = "Neon PVP Arena 1",
        ["neon_pvp_arena_2"] = "Neon PvP Arena 2",
        ["ramps_2x_1v1"] = "Ramps 2x 1v1",
    },
    ["location_images"] = {
        ["blocks"] = "wagers/maps/blocks.png",
        ["rooftop"] = "wagers/maps/rooftop.png",
        ["oil_rig"] = "wagers/maps/oil_rig.png",
        ["heroin"] = "wagers/maps/heroin.png",
        ["large_arms"] = "wagers/maps/large_arms.png",
        ["ramps"] = "wagers/maps/ramps.png",
        ["rebel"] = "wagers/maps/rebel.png",
        ["Craft"] = "wagers/maps/craft.png",
        ["lsd_north"] = "wagers/maps/lsd_north.png",
        ["small_arena_1"] = "wagers/maps/small_arena_1.png",
        ["large_arena_3"] = "wagers/maps/large_arena_3.png",
        ["dust"] = "wagers/maps/dust.png",
        ["large_helipad"] = "wagers/maps/large_helipad.png",
        ["neon_pvp_arena_1"] = "wagers/maps/neon_pvp_arena_1.png",
        ["neon_pvp_arena_2"] = "wagers/maps/neon_pvp_arena_2.png",
        ["ramps_2x_1v1"] = "wagers/maps/ramps_2x_1v1.png",
    },
    ["location_coords"] = {
        ["hijacked"] = {
            A = {
                vector3(-5297.6689453125,-577.87677001953,7.6418790817261),
                vector3(-5274.5834960938,-569.7763671875,7.6419062614441)
            },
            B = {
                vector3(-5309.3720703125,-545.24749755859,9.1057329177856),
                vector3(-5286.81640625,-537.56903076172,9.1058320999146)
            },
            radius = 100.0
        },
        ["rooftop"] = {
            A = {
                vector3(-54.40, 178.01, 141.18),
                vector3(-55.25, 179.37, 141.18),
                vector3(-53.92, 179.28, 141.18),
                vector3(-55.79, 177.95, 141.18),
                vector3(-54.85, 178.65, 141.18)
            },
            B = {
                vector3(-36.19, 151.97, 141.18),
                vector3(-35.06, 150.22, 141.18),
                vector3(-36.77, 150.74, 141.18),
                vector3(-34.77, 152.17, 141.18),
                vector3(-35.60, 151.07, 141.18)
            },
            radius = 40.0
        },
        ["oil_rig"] = {
            A = {
                vector3(-1689.9057617188,8885.61328125,26.360071182251),
                vector3(-1692.0286865234,8884.3779296875,26.360071182251)
            },
            B = {
                vector3(-1716.4625244141,8877.775390625,18.859910964966),
                vector3(-1717.3388671875,8875.8916015625,18.874937057495)
            },
            radius = 80.0
        },
        ["blocks"] = {
            A = {
                vector3(-2372.64453125,-1150.2813720703,328.66073608398),
                vector3(-2372.4111328125,-1158.3150634766,328.66073608398)
            },
            B = {
                vector3(-2348.1433105469,-1158.1885986328,328.66137695312),
                vector3(-2348.8051757812,-1150.3233642578,328.66137695312)
            },
            radius = 150.0
        },
        ["heroin"] = {
            A = {
                vector3(3536.02, 3774.14, 29.92),
                vector3(3535.05, 3774.35, 29.92),
                vector3(3533.69, 3774.69, 29.92),
                vector3(3532.41, 3774.79, 29.93),
                vector3(3530.90, 3774.89, 29.93)
            },
            B = {
                vector3(3515.63, 3664.81, 33.89),
                vector3(3516.98, 3664.53, 33.89),
                vector3(3518.11, 3664.21, 33.89),
                vector3(3519.80, 3663.57, 33.89),
                vector3(3521.61, 3662.72, 33.89)
            },
            radius = 120.0
        },
        ["large_arms"] = {
            A = {
                vector3(-1154.70, 4913.39, 220.44),
                vector3(-1157.59, 4913.36, 220.72),
                vector3(-1157.85, 4914.98, 221.05),
                vector3(-1155.26, 4914.98, 220.80),
                vector3(-1156.20, 4914.11, 220.72)
            },
            B = {
                vector3(-1051.71, 4917.99, 210.22),
                vector3(-1052.04, 4920.04, 210.22),
                vector3(-1049.93, 4918.21, 209.81),
                vector3(-1050.21, 4920.14, 209.77),
                vector3(-1050.93, 4919.03, 210.00)
            },
            radius = 150.0
        },
        ["ramps"] = {
            A = {
                vector3(-934.11, -782.16, 15.92),
                vector3(-932.59, -780.21, 15.92),
                vector3(-932.39, -781.99, 15.92),
                vector3(-934.51, -780.46, 15.92),
                vector3(-933.35, -781.19, 15.92)
            },
            B = {
                vector3(-948.29, -800.83, 15.92),
                vector3(-949.92, -802.92, 15.92),
                vector3(-950.20, -800.96, 15.92),
                vector3(-947.95, -802.77, 15.92),
                vector3(-949.05, -801.81, 15.92)
            },
            radius = 30.0
        },
        ["rebel"] = {
            A = {
                vector3(1527.96, 6316.04, 24.08),
                vector3(1528.75, 6317.32, 24.09),
                vector3(1529.59, 6318.63, 24.11),
                vector3(1530.42, 6319.57, 24.13),
                vector3(1531.24, 6320.77, 24.15)
            },
            B = {
                vector3(1434.18, 6334.82, 23.99),
                vector3(1434.17, 6333.35, 23.99),
                vector3(1434.28, 6331.39, 23.99),
                vector3(1433.10, 6332.24, 23.99),
                vector3(1432.78, 6334.12, 23.99)
            },
            radius = 65.0
        },
        ["Craft"] = {
            A = {
                vector3(-1965.3878173828,-1502.7412109375,321.06048583984),
                vector3(-1973.2282714844,-1493.7016601562,321.06042480469),
                vector3(-1972.0325927734,-1513.1165771484,321.06143188477)
            },
            B = {
                vector3(-1936.5330810547,-1504.4241943359,321.06045532227),
                vector3(-1929.9633789062,-1513.3592529297,321.06042480469),
                vector3(-1929.2927246094,-1494.0041503906,321.06039428711)
            },
            radius = 50.0
        },
        ["lsd_north"] = {
            A = {
                vector3(1379.98, 4371.18, 43.75),
                vector3(1379.67, 4372.51, 43.85),
                vector3(1379.37, 4373.80, 43.82),
                vector3(1379.04, 4375.23, 43.99),
                vector3(1378.65, 4376.91, 44.07)
            },
            B = {
                vector3(1296.99, 4331.05, 38.49),
                vector3(1297.56, 4329.99, 38.46),
                vector3(1298.23, 4328.92, 38.43),
                vector3(1298.71, 4328.05, 38.43),
                vector3(1299.18, 4327.11, 38.43)
            },
            radius = 130.0
        },
        ["small_arena_1"] = {
            A = {
                vector3(4043.33, 1342.61, 679.64),
                vector3(4040.80, 1310.71, 679.64),
                vector3(4038.56, 1293.88, 679.97),
                vector3(4034.19, 1280.19, 680.06)
            },
            B = {
                vector3(3985.36, 1339.12, 679.64),
                vector3(3986.71, 1318.82, 679.64),
                vector3(3984.46, 1294.59, 679.64),
                vector3(3984.35, 1278.63, 679.64)
            },
            radius = 80.0
        },
        ["large_arena_3"] = {
            A = {
                vector3(3988.32, -25.03, 195.99),
                vector3(3989.43, -8.21, 195.99),
                vector3(3988.74, 2.27, 195.99),
                vector3(3988.41, 13.21, 195.99),
                vector3(3988.13, 20.26, 195.99)
            },
            B = {
                vector3(4115.20, -24.69, 195.99),
                vector3(4115.20, -10.87, 195.99),
                vector3(4114.44, 0.21, 195.99),
                vector3(4113.90, 8.17, 195.99),
                vector3(4117.02, 14.27, 195.99)
            },
            radius = 110.0
        },
        ["dust"] = {
            A = {
                vector3(-3182.31, -365.00, 556.53),
                vector3(-3179.36, -365.11, 556.53)
            },
            B = {
                vector3(-3178.76, -332.21, 556.53),
                vector3(-3181.57, -332.30, 556.53)
            },
            radius = 40.0
        },
        ["large_helipad"] = {
            A = {
                vector3(1866.46, -3185.24, 397.72),
                vector3(1859.52, -3190.30, 397.72),
                vector3(1854.01, -3194.28, 397.72),
                vector3(1805.85, -3195.63, 397.72),
                vector3(1795.89, -3186.90, 397.72)
            },
            B = {
                vector3(1807.57, -3096.70, 397.72),
                vector3(1794.16, -3105.32, 397.72),
                vector3(1869.93, -3109.69, 397.72),
                vector3(1865.17, -3105.94, 397.72),
                vector3(1857.96, -3098.82, 397.72)
            },
            radius = 100.0
        },
        ["neon_pvp_arena_1"] = {
            A = {
                vector3(-2484.50, -1827.47, 100.37),
                vector3(-2487.69, -1806.77, 100.37),
                vector3(-2486.90, -1791.86, 100.37),
                vector3(-2486.48, -1784.79, 100.36),
                vector3(-2486.01, -1776.56, 100.37)
            },
            B = {
                vector3(-2396.72, -1841.93, 100.37),
                vector3(-2395.95, -1832.21, 100.37),
                vector3(-2395.91, -1818.30, 100.37),
                vector3(-2396.16, -1805.99, 100.37),
                vector3(-2396.51, -1789.76, 100.37)
            },
            radius = 150.0
        },
        ["neon_pvp_arena_2"] = {
            A = {
                vector3(-3167.21, -494.62, 318.88),
                vector3(-3166.82, -477.52, 318.88),
                vector3(-3166.13, -455.86, 318.88)
            },
            B = {
                vector3(-3240.50, -457.40, 318.88),
                vector3(-3241.81, -475.15, 318.88),
                vector3(-3243.78, -498.90, 318.88)
            },
            radius = 150.0
        },
        ["ramps_2x_1v1"] = {
            A = {
                vector3(-2595.27, -2209.93, 1271.66),
                vector3(-2573.21, -2209.36, 1271.66)
            },
            B = {
                vector3(-2594.92, -2186.62, 1271.64),
                vector3(-2573.95, -2185.81, 1271.64)
            },
            radius = 150.0
        },
    }
}

return cfg

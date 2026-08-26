local cfg = {}

cfg.options = {
    -- due to shitty lua indexing:- 1 == disabled, 2 == enabled
    enabled = 1,
    centerDotEnabled = 1,
    visibility = 1,
    showDefaultCrosshair = 0,
    disableDefaultCrosshair = 0,
    showRedDot = 1,

    -- crosshair configuration
    length = {
        index = 1,
        value = 0.002
    },
    thickness = {
        index = 1,
        value = 0.001
    },
    gap = {
        index = 1,
        value = 0.0
    },
    colour = {
        red = 255,
        green = 255,
        blue = 255,
    }

}

cfg.menu = {
    length = {
        labels = {}
    },
    thickness = {
        labels = {}
    },
    gap = {
        labels = {}
    }
}

local function populateArrays()
    for i = 1, 20 do
        table.insert(cfg.menu.length.labels, i, i)
        table.insert(cfg.menu.thickness.labels, i, i)
        table.insert(cfg.menu.gap.labels, i, i)
    end
end

function loadCrosshairKvp()
    populateArrays()
    local isEnabled = GetResourceKvpInt("sinco_crosshair_enabled")
    if isEnabled == 0 then
        cfg.options.enabled = 0
    else
        cfg.options.enabled = isEnabled
    end

    local useCenterDot = GetResourceKvpInt("sinco_crosshair_center_dot_enabled")
    if useCenterDot == 0 then
        cfg.options.centerDotEnabled = 1
    else
        cfg.options.centerDotEnabled = useCenterDot
    end

    local crosshairVisibility = GetResourceKvpInt("sinco_crosshair_visibility")
    if crosshairVisibility == 0 then
        cfg.options.visibility = 1
    else
        cfg.options.visibility = crosshairVisibility
    end

    local crosshairLength = GetResourceKvpInt("sinco_crosshair_length")
    if crosshairLength == 0 then
        cfg.options.length.index = 1
        cfg.options.length.value = 0.002
    else
        cfg.options.length.index = crosshairLength
        cfg.options.length.value = 0.001 + (cfg.options.length.index * 0.001)
    end

    local crosshairThickness = GetResourceKvpInt("sinco_crosshair_thickness")
    if crosshairThickness == 0 then
        cfg.options.thickness.index = 1
        cfg.options.thickness.value = 0.001
    else
        cfg.options.thickness.index = crosshairThickness
        cfg.options.thickness.value = 0.002 * cfg.options.thickness.index
    end

    local crosshairGap = GetResourceKvpInt("sinco_crosshair_gap")
    if crosshairGap == 0 then
        cfg.options.gap.index = 1
        cfg.options.gap.value = 0.0
    else
        cfg.options.gap.index = crosshairGap
        cfg.options.gap.value = ((cfg.options.gap.index * 0.0005) - 0.0005)
    end

    local red = GetResourceKvpInt("sinco_crosshair_red")
    if red == 0 then
        cfg.options.colour.red = 150
    else
        cfg.options.colour.red = red
    end

    local green = GetResourceKvpInt("sinco_crosshair_green")
    if green == 0 then
        cfg.options.colour.green = 150
    else
        cfg.options.colour.green = green
    end

    local blue = GetResourceKvpInt("sinco_crosshair_blue")
    if blue == 0 then
        cfg.options.colour.blue = 150
    else
        cfg.options.colour.blue = blue
    end

    local showDefaultCrosshair = GetResourceKvpInt("sinco_show_default_crosshair")
    if showDefaultCrosshair == 0 then
        cfg.options.showDefaultCrosshair = 0
    else
        cfg.options.showDefaultCrosshair = showDefaultCrosshair
    end

    local showRedDot = GetResourceKvpInt("sinco_show_red_dot")
    if showRedDot == 0 then
        cfg.options.showRedDot = 0
    else
        cfg.options.showRedDot = showRedDot
    end

    local disableDefaultCrosshair = GetResourceKvpInt("sinco_disable_default_crosshair")
    if disableDefaultCrosshair == 0 then
        cfg.options.disableDefaultCrosshair = 0
    else
        cfg.options.disableDefaultCrosshair = disableDefaultCrosshair
    end

end

function saveCrosshair()
    SetResourceKvpInt('sinco_crosshair_enabled', cfg.options.enabled)
    SetResourceKvpInt('sinco_crosshair_center_dot_enabled', cfg.options.centerDotEnabled)
    SetResourceKvpInt('sinco_crosshair_visibility', cfg.options.visibility)
    SetResourceKvpInt('sinco_crosshair_length', cfg.options.length.index)
    SetResourceKvpInt('sinco_crosshair_thickness', cfg.options.thickness.index)
    SetResourceKvpInt('sinco_crosshair_gap', cfg.options.gap.index)
    SetResourceKvpInt('sinco_crosshair_red', cfg.options.colour.red)
    SetResourceKvpInt('sinco_crosshair_blue', cfg.options.colour.blue)
    SetResourceKvpInt('sinco_crosshair_green', cfg.options.colour.green)
    SetResourceKvpInt('sinco_show_default_crosshair', cfg.options.showDefaultCrosshair)
    SetResourceKvpInt('sinco_show_red_dot', cfg.options.showRedDot)
    SetResourceKvpInt('sinco_disable_default_crosshair', cfg.options.disableDefaultCrosshair)
end





return cfg

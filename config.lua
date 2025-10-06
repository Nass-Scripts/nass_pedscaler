Config = {}
Config.locale = Locales["en"]

Config.commands = {
    openMenu = {
        enabled = true,
        command = "scale"
    },
    resetScale = {
        enabled = true,
        command = "resetscale"
    }
}

Config.permissions = {
    enabled = false,
    defaultPermissions = {
        openSelf = true,
        openOther = false,
        resetSelf = true,
        resetOther = false,
    },
    acePermissions = {
        ["nass_fighting.scaler"] = {
            openSelf = true,
            openOther = true,
            resetSelf = true,
            resetOther = true,
        }
    }
}

Config.scaling = {
    min = 0.1,
    max = 2.0,
    scaleSpeed = { --Not fully implemented yet, need to add some extra math for a more realisitc scaling effect
        enabled = false, --Make larget peds move faster and smaller peds move slower
        inverse = true, --FLip it around, so smaller peds move faster and larger peds move slower
    },
}
return {
    {
        name           = "Knight",
        icon           = love.graphics.newImage("assets/images/pawn_ui/knight.png"),
        assemblageName = "Knight",
        description    = "Here to save the day!",
        price          = KNOBS.knight.price,
    },
    {
        name           = "Archer",
        icon           = love.graphics.newImage("assets/images/pawn_ui/archer.png"),
        assemblageName = "Archer",
        description    = "Here to save the day!",
        price          = KNOBS.archer.price,
    },
    {
        name           = "Mage",
        icon           = love.graphics.newImage("assets/images/pawn_ui/monk.png"),
        assemblageName = "Mage",
        description    = "Here to save the day!",
        price          = 3,
    },
    {
        name           = "Heavy",
        icon           = love.graphics.newImage("assets/images/pawn_ui/heavy.png"),
        assemblageName = "Heavy",
        description    = "Here to save the day!",
        price          = 6,
    },

    -- ──────────────────────────────────────────────────────────────────────
    -- ╭─────────────────────────────────────────────────────────╮
    -- │ Hostile only:                                           │
    -- ╰─────────────────────────────────────────────────────────╯
    {
        name           = "LilMeleeEnemy",
        assemblageName = "LilMeleeEnemy",
        description    = "Here to ruin your day!",
        price          = 1,
        hostileOnly    = true,
    },
    {
        name          = "RangedEnemy",
        assemblageName = "RangedEnemy",
        description    = "Here to ruin your day!",
        price          = 2,
        hostileOnly    = true,
    }
}

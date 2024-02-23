return {

    -- How much destroying each one is worth.
    enemyCoinReward = {
        tower = 2,
        meleeEnemy = 0.5,
        rangedEnemy = 0.5,
    },

    -- Various stats for the player's pawns.
    -- ──────────────────────────────────────────────────────────────────────
    -- Lower attack speed = faster
    -- `toggleRanges` console command to view the ranges of each pawn.
    --
    knight = {
        health = 10,
        damageAmount = 1,
        attackSpeed = 1,
        range = 120,
        price = 1
    },
    archer = {
        health = 7,
        damageAmount = 1,
        attackSpeed = 1.2,
        range = 420.69,
        price = 2
    },
    mage = {
        health = 22,
        damageAmount = 2.8,
        attackSpeed = 1,
        range = 370,
        price = 3
    },
    heavy = {
        health = 40,
        damageAmount = 2.5,
        attackSpeed = 1.87,
        range = 160,
        price = 6
    },
}


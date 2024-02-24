local SPEED_MULTIPLIER = 1.75

return {
    -- ──────────────────────────────────────────────────────────────────────
    -- ╭─────────────────────────────────────────────────────────╮
    -- │ Coin values:                                            │
    -- ╰─────────────────────────────────────────────────────────╯

    -- Passive generation rate (generate a coin every 'passiveRate' seconds):
    coinGenerationRate = 15,

    -- How many coins you get at the start of a new level:
    newLevelCoinReward = 2,

    -- How much each one is worth.
    enemyCoinReward = {
        tower = 2,
        meleeEnemy = 1.25,
        rangedEnemy = 1.25,
    },

    -- ──────────────────────────────────────────────────────────────────────
    -- ╭─────────────────────────────────────────────────────────╮
    -- │ Enemy tower stats:                                      │
    -- ╰─────────────────────────────────────────────────────────╯
    -- Lower spawn rate = faster (spawn every 'spawnRate' seconds).

    enemyTower = {
        health = 35,
        spawnRate = 5 / SPEED_MULTIPLIER,

        -- Every second the spawn rate will be multiplied by this.
        -- For example,
        -- 
        -- If this is 0.5
        --
        -- Every second the spawn rate will double every second.
        --
        -- If it was 0.8, it would increase by 20% every second.
        --
        -- Higher number = slower increase over time.
        spawnRateIncreaseIncrement = 0.5 / SPEED_MULTIPLIER,

        -- The minimum spawn rate.
        -- If this is 1, the minimum rate is 1 per second.
        -- if it's 2, the minimum rate is 1 per 2 seconds.
        -- Lower number = faster, higher number = slower.
        minimumSpawnRate = 1,
    },

    -- ──────────────────────────────────────────────────────────────────────
    -- ╭─────────────────────────────────────────────────────────╮
    -- │ Enemy pawn stats:                                       │
    -- ╰─────────────────────────────────────────────────────────╯
    -- Lower attack speed = faster (attack every 'attackSpeed' seconds).
    -- `toggleRanges` console command to view the ranges of each pawn.

    meleeEnemy = {
        health = 6,
        walkSpeed = 1200 * SPEED_MULTIPLIER,
        damageAmount = 1,
        attackSpeed = 1 / SPEED_MULTIPLIER,
        range = 120,
        price = 1
    },
    rangedEnemy = {
        health = 4,
        walkSpeed = 1000 * SPEED_MULTIPLIER,
        damageAmount = 1,
        attackSpeed = 1.2 / SPEED_MULTIPLIER,
        range = 420.69,
        price = 2
    },

    -- ──────────────────────────────────────────────────────────────────────
    -- ╭─────────────────────────────────────────────────────────╮
    -- │ Player pawn stats:                                      │
    -- ╰─────────────────────────────────────────────────────────╯
    -- Lower attack speed = faster
    -- `toggleRanges` console command to view the ranges of each pawn.

    knight = {
        health = 6,
        walkSpeed = 1200 * SPEED_MULTIPLIER,
        damageAmount = 1,
        attackSpeed = 1 / SPEED_MULTIPLIER,
        range = 120,
        price = 1
    },
    archer = {
        health = 5,
        walkSpeed = 1000 * SPEED_MULTIPLIER,
        damageAmount = 1,
        attackSpeed = 1.2 / SPEED_MULTIPLIER,
        range = 420.69,
        price = 2
    },
    mage = {
        health = 22,
        walkSpeed = 1200 * SPEED_MULTIPLIER,
        damageAmount = 2.8,
        attackSpeed = 1 / SPEED_MULTIPLIER,
        range = 370,
        price = 5
    },
    heavy = {
        health = 40,
        walkSpeed = 900 * SPEED_MULTIPLIER,
        damageAmount = 2.5,
        attackSpeed = 1.87 / SPEED_MULTIPLIER,
        range = 160,
        price = 10
    },
}

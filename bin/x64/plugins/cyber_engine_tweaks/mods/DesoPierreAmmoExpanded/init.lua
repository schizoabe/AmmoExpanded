---@diagnostic disable: undefined-global

local windowOpen = true

-- ── Round-type colors (shared across all calibers by semantic type) ───────────
local ROUND_COLORS = {
    FMJ  = { 0.85, 0.85, 0.85 },
    GEN  = { 0.85, 0.85, 0.85 },
    BUCK = { 0.85, 0.85, 0.85 },
    HP   = { 1.00, 0.45, 0.45 },
    AP   = { 0.45, 0.75, 1.00 },
    NL   = { 0.45, 1.00, 0.45 },
    EMP  = { 0.80, 0.45, 1.00 },
    INC  = { 1.00, 0.55, 0.15 },
    HE   = { 1.00, 0.80, 0.20 },
    SLUG = { 0.95, 0.85, 0.50 },
    TECH  = { 1.00, 0.70, 0.30 },
    CHEM  = { 0.55, 0.90, 0.35 },
    SNAKE = { 0.55, 0.85, 0.25 },
}

-- ── Caliber variant tables (NEW AMMO V2 roster — 40 calibers) ─────────────────
-- Every caliber gets its OWN explicit variant list matching the consultant's
-- per-caliber spread (no more uniform 6-variant set) — "AP-default" calibers
-- (Vulcan/22x126 AC/23x152 Soviet) label their base round as armor-piercing
-- since that's their intended default per the spec, not plain FMJ. Buckshot
-- calibers label their base round "Buckshot" instead of "FMJ". Locked/no-variant
-- calibers (Comrade's Hammer, Erebus) get a single entry — the lock system
-- (DPAE_GetLockedVariantID, see below) additionally restricts CET's display to
-- just the permitted variant for specific WEAPONS on a shared caliber (e.g.
-- Hypercritical only ever shows HE even though Kolac on the same caliber sees all three).
local CALIBER_VARIANTS = {
    Cal243Win = {
        label    = ".243 Winchester",
        variants = {
            { id = "Ammo.Cal243Win", label = "FMJ", short = "FMJ" },
            { id = "Ammo.Cal243Win_AP", label = "Armor Pierce", short = "AP" },
            { id = "Ammo.Cal243Win_HP", label = "Hollow Point", short = "HP" },
            { id = "Ammo.Cal243Win_EMP", label = "EMP", short = "EMP" },
            { id = "Ammo.Cal243Win_INC", label = "Incendiary", short = "INC" },
            { id = "Ammo.Cal243Win_CHEM", label = "Chemical", short = "CHEM" },
            { id = "Ammo.Cal243Win_NL", label = "Non-Lethal", short = "NL" },
        },
    },
    Cal45Super = {
        label    = ".45 Super",
        variants = {
            { id = "Ammo.Cal45Super", label = "FMJ", short = "FMJ" },
            { id = "Ammo.Cal45Super_AP", label = "Armor Pierce", short = "AP" },
            { id = "Ammo.Cal45Super_HP", label = "Hollow Point", short = "HP" },
            { id = "Ammo.Cal45Super_Snakeshot", label = "Snakeshot", short = "SNAKE" },
            { id = "Ammo.Cal45Super_EMP", label = "EMP", short = "EMP" },
            { id = "Ammo.Cal45Super_INC", label = "Incendiary", short = "INC" },
            { id = "Ammo.Cal45Super_CHEM", label = "Chemical", short = "CHEM" },
            { id = "Ammo.Cal45Super_NL", label = "Non-Lethal", short = "NL" },
            { id = "Ammo.Cal45Super_HE", label = "High Explosive", short = "HE" },
        },
    },
    Cal45WinMag = {
        label    = ".45 Winchester Magnum",
        variants = {
            { id = "Ammo.Cal45WinMag", label = "FMJ", short = "FMJ" },
            { id = "Ammo.Cal45WinMag_AP", label = "Armor Pierce", short = "AP" },
            { id = "Ammo.Cal45WinMag_HP", label = "Hollow Point", short = "HP" },
            { id = "Ammo.Cal45WinMag_Snakeshot", label = "Snakeshot", short = "SNAKE" },
            { id = "Ammo.Cal45WinMag_EMP", label = "EMP", short = "EMP" },
            { id = "Ammo.Cal45WinMag_INC", label = "Incendiary", short = "INC" },
            { id = "Ammo.Cal45WinMag_CHEM", label = "Chemical", short = "CHEM" },
            { id = "Ammo.Cal45WinMag_NL", label = "Non-Lethal", short = "NL" },
        },
    },
    Cal454Casull = {
        label    = ".454 Casull",
        variants = {
            { id = "Ammo.Cal454Casull", label = "FMJ", short = "FMJ" },
            { id = "Ammo.Cal454Casull_AP", label = "Armor Pierce", short = "AP" },
            { id = "Ammo.Cal454Casull_HP", label = "Hollow Point", short = "HP" },
            { id = "Ammo.Cal454Casull_Snakeshot", label = "Snakeshot", short = "SNAKE" },
            { id = "Ammo.Cal454Casull_EMP", label = "EMP", short = "EMP" },
            { id = "Ammo.Cal454Casull_INC", label = "Incendiary", short = "INC" },
            { id = "Ammo.Cal454Casull_CHEM", label = "Chemical", short = "CHEM" },
            { id = "Ammo.Cal454Casull_NL", label = "Non-Lethal", short = "NL" },
        },
    },
    Cal50AE = {
        label    = ".50 AE",
        variants = {
            { id = "Ammo.Cal50AE", label = "FMJ", short = "FMJ" },
            { id = "Ammo.Cal50AE_AP", label = "Armor Pierce", short = "AP" },
            { id = "Ammo.Cal50AE_HP", label = "Hollow Point", short = "HP" },
            { id = "Ammo.Cal50AE_EMP", label = "EMP", short = "EMP" },
            { id = "Ammo.Cal50AE_INC", label = "Incendiary", short = "INC" },
            { id = "Ammo.Cal50AE_CHEM", label = "Chemical", short = "CHEM" },
            { id = "Ammo.Cal50AE_NL", label = "Non-Lethal", short = "NL" },
            { id = "Ammo.Cal50AE_HE", label = "High Explosive", short = "HE" },
        },
    },
    Cal50BeowulfOni = {
        label    = ".50 Beowulf Oni",
        variants = {
            { id = "Ammo.Cal50BeowulfOni", label = "FMJ", short = "FMJ" },
            { id = "Ammo.Cal50BeowulfOni_AP", label = "Armor Pierce", short = "AP" },
            { id = "Ammo.Cal50BeowulfOni_HP", label = "Hollow Point", short = "HP" },
            { id = "Ammo.Cal50BeowulfOni_EMP", label = "EMP", short = "EMP" },
            { id = "Ammo.Cal50BeowulfOni_INC", label = "Incendiary", short = "INC" },
            { id = "Ammo.Cal50BeowulfOni_CHEM", label = "Chemical", short = "CHEM" },
            { id = "Ammo.Cal50BeowulfOni_NL", label = "Non-Lethal", short = "NL" },
        },
    },
    Cal50BMG = {
        label    = ".50 BMG NUSA",
        variants = {
            { id = "Ammo.Cal50BMG", label = "FMJ", short = "FMJ" },
            { id = "Ammo.Cal50BMG_AP", label = "Armor Pierce", short = "AP" },
            { id = "Ammo.Cal50BMG_HP", label = "Hollow Point", short = "HP" },
            { id = "Ammo.Cal50BMG_EMP", label = "EMP", short = "EMP" },
            { id = "Ammo.Cal50BMG_INC", label = "Incendiary", short = "INC" },
            { id = "Ammo.Cal50BMG_CHEM", label = "Chemical", short = "CHEM" },
            { id = "Ammo.Cal50BMG_NL", label = "Non-Lethal", short = "NL" },
        },
    },
    Cal500Malour = {
        label    = ".500 Malour",
        variants = {
            { id = "Ammo.Cal500Malour", label = "FMJ", short = "FMJ" },
            { id = "Ammo.Cal500Malour_AP", label = "Armor Pierce", short = "AP" },
            { id = "Ammo.Cal500Malour_INC", label = "Incendiary", short = "INC" },
            { id = "Ammo.Cal500Malour_HE", label = "High Explosive", short = "HE" },
        },
    },
    Cal10GaugeBuck = {
        label    = "10 Gauge Buckshot",
        variants = {
            { id = "Ammo.Cal10GaugeBuck", label = "Buckshot", short = "BUCK" },
            { id = "Ammo.Cal10GaugeBuck_Slug", label = "Slug", short = "SLUG" },
            { id = "Ammo.Cal10GaugeBuck_INC", label = "Incendiary", short = "INC" },
            { id = "Ammo.Cal10GaugeBuck_HE", label = "High Explosive", short = "HE" },
        },
    },
    Cal10GaugeFlech = {
        label    = "10 Gauge Flechettes",
        variants = {
            { id = "Ammo.Cal10GaugeFlech", label = "Generic", short = "GEN" },
            { id = "Ammo.Cal10GaugeFlech_EMP", label = "EMP", short = "EMP" },
            { id = "Ammo.Cal10GaugeFlech_INC", label = "Incendiary", short = "INC" },
            { id = "Ammo.Cal10GaugeFlech_CHEM", label = "Chemical", short = "CHEM" },
        },
    },
    Cal10x40Rocket = {
        label    = "10x40mm Guided Rocket",
        variants = {
            { id = "Ammo.Cal10x40Rocket", label = "Generic", short = "GEN" },
            { id = "Ammo.Cal10x40Rocket_HE", label = "High Explosive", short = "HE" },
            { id = "Ammo.Cal10x40Rocket_INC", label = "Incendiary", short = "INC" },
            { id = "Ammo.Cal10x40Rocket_CHEM", label = "Chemical", short = "CHEM" },
        },
    },
    Cal10mmAuto = {
        label    = "10mm Auto",
        variants = {
            { id = "Ammo.Cal10mmAuto", label = "FMJ", short = "FMJ" },
            { id = "Ammo.Cal10mmAuto_AP", label = "Armor Pierce", short = "AP" },
            { id = "Ammo.Cal10mmAuto_HP", label = "Hollow Point", short = "HP" },
            { id = "Ammo.Cal10mmAuto_EMP", label = "EMP", short = "EMP" },
            { id = "Ammo.Cal10mmAuto_INC", label = "Incendiary", short = "INC" },
            { id = "Ammo.Cal10mmAuto_CHEM", label = "Chemical", short = "CHEM" },
            { id = "Ammo.Cal10mmAuto_NL", label = "Non-Lethal", short = "NL" },
        },
    },
    Cal10x20TF = {
        label    = "10x20mm Tungsten Flechettes",
        variants = {
            { id = "Ammo.Cal10x20TF", label = "Generic", short = "GEN" },
            { id = "Ammo.Cal10x20TF_EMP", label = "EMP", short = "EMP" },
            { id = "Ammo.Cal10x20TF_INC", label = "Incendiary", short = "INC" },
            { id = "Ammo.Cal10x20TF_CHEM", label = "Chemical", short = "CHEM" },
        },
    },
    Cal12Gauge = {
        label    = "12 Gauge Buckshot",
        variants = {
            { id = "Ammo.Cal12Gauge", label = "Buckshot", short = "BUCK" },
            { id = "Ammo.Cal12Gauge_Slug", label = "Slug", short = "SLUG" },
            { id = "Ammo.Cal12Gauge_INC", label = "Incendiary", short = "INC" },
        },
    },
    Cal12p3x41UdaR = {
        label    = "12.3x41mm UdaR",
        variants = {
            { id = "Ammo.Cal12p3x41UdaR", label = "FMJ", short = "FMJ" },
            { id = "Ammo.Cal12p3x41UdaR_AP", label = "Armor Pierce", short = "AP" },
            { id = "Ammo.Cal12p3x41UdaR_HP", label = "Hollow Point", short = "HP" },
            { id = "Ammo.Cal12p3x41UdaR_Snakeshot", label = "Snakeshot", short = "SNAKE" },
            { id = "Ammo.Cal12p3x41UdaR_INC", label = "Incendiary", short = "INC" },
            { id = "Ammo.Cal12p3x41UdaR_HE", label = "High Explosive", short = "HE" },
            { id = "Ammo.Cal12p3x41UdaR_CHEM", label = "Chemical", short = "CHEM" },
        },
    },
    Cal12p7x70Rocket = {
        label    = "12.7x70mm Guided Rocket",
        variants = {
            { id = "Ammo.Cal12p7x70Rocket", label = "Generic", short = "GEN" },
            { id = "Ammo.Cal12p7x70Rocket_HE", label = "High Explosive", short = "HE" },
            { id = "Ammo.Cal12p7x70Rocket_INC", label = "Incendiary", short = "INC" },
        },
    },
    Cal12x45Rocket = {
        label    = "12x45mm Guided Rocket",
        variants = {
            { id = "Ammo.Cal12x45Rocket", label = "Generic", short = "GEN" },
            { id = "Ammo.Cal12x45Rocket_HE", label = "High Explosive", short = "HE" },
            { id = "Ammo.Cal12x45Rocket_INC", label = "Incendiary", short = "INC" },
        },
    },
    Cal14x40TSlug = {
        label    = "14x40mm Tungsten Slug",
        variants = {
            { id = "Ammo.Cal14x40TSlug", label = "FMJ", short = "FMJ" },
            { id = "Ammo.Cal14x40TSlug_EMP", label = "EMP", short = "EMP" },
            { id = "Ammo.Cal14x40TSlug_INC", label = "Incendiary", short = "INC" },
            { id = "Ammo.Cal14x40TSlug_CHEM", label = "Chemical", short = "CHEM" },
            { id = "Ammo.Cal14x40TSlug_HE", label = "High Explosive", short = "HE" },
        },
    },
    Cal14x70TSlugHE = {
        label    = "14x70mm Tungsten Slug",
        variants = {
            { id = "Ammo.Cal14x70TSlugHE", label = "High Explosive", short = "HE" },
        },
    },
    Cal15x55Rocket = {
        label    = "15x55mm Guided Rocket",
        variants = {
            { id = "Ammo.Cal15x55Rocket", label = "Generic", short = "GEN" },
            { id = "Ammo.Cal15x55Rocket_HE", label = "High Explosive", short = "HE" },
            { id = "Ammo.Cal15x55Rocket_INC", label = "Incendiary", short = "INC" },
        },
    },
    Cal15x80TSpike = {
        label    = "15x80mm Tungsten Spike",
        variants = {
            { id = "Ammo.Cal15x80TSpike", label = "FMJ", short = "FMJ" },
            { id = "Ammo.Cal15x80TSpike_EMP", label = "EMP", short = "EMP" },
            { id = "Ammo.Cal15x80TSpike_INC", label = "Incendiary", short = "INC" },
            { id = "Ammo.Cal15x80TSpike_CHEM", label = "Chemical", short = "CHEM" },
        },
    },
    Cal18x70Rocket = {
        label    = "18x70mm Guided Rocket",
        variants = {
            { id = "Ammo.Cal18x70Rocket", label = "Generic", short = "GEN" },
            { id = "Ammo.Cal18x70Rocket_HE", label = "High Explosive", short = "HE" },
            { id = "Ammo.Cal18x70Rocket_INC", label = "Incendiary", short = "INC" },
        },
    },
    Cal20x102Vulcan = {
        label    = "20x102mm Vulcan",
        variants = {
            { id = "Ammo.Cal20x102Vulcan", label = "Standard (Armor-Piercing)", short = "AP" },
            { id = "Ammo.Cal20x102Vulcan_HE", label = "High Explosive", short = "HE" },
            { id = "Ammo.Cal20x102Vulcan_INC", label = "Incendiary", short = "INC" },
        },
    },
    Cal22x126AC = {
        label    = "22x126mm AC",
        variants = {
            { id = "Ammo.Cal22x126AC", label = "Standard (Armor-Piercing)", short = "AP" },
            { id = "Ammo.Cal22x126AC_HE", label = "High Explosive", short = "HE" },
            { id = "Ammo.Cal22x126AC_INC", label = "Incendiary", short = "INC" },
        },
    },
    Cal23x152Sov = {
        label    = "23x152mm Soviet",
        variants = {
            { id = "Ammo.Cal23x152Sov", label = "Standard (Armor-Piercing)", short = "AP" },
            { id = "Ammo.Cal23x152Sov_HE", label = "High Explosive", short = "HE" },
            { id = "Ammo.Cal23x152Sov_INC", label = "Incendiary", short = "INC" },
            { id = "Ammo.Cal23x152Sov_EMP", label = "EMP", short = "EMP" },
        },
    },
    Cal3x10FlechCluster = {
        label    = "3x10mm Flechette Cluster",
        variants = {
            { id = "Ammo.Cal3x10FlechCluster", label = "3x10mm Flechette Cluster", short = "TECH" },
        },
    },
    Cal4Gauge = {
        label    = "4 Gauge Buckshot",
        variants = {
            { id = "Ammo.Cal4Gauge", label = "Buckshot", short = "BUCK" },
            { id = "Ammo.Cal4Gauge_Slug", label = "Slug", short = "SLUG" },
            { id = "Ammo.Cal4Gauge_INC", label = "Incendiary", short = "INC" },
            { id = "Ammo.Cal4Gauge_HE", label = "High Explosive", short = "HE" },
            { id = "Ammo.Cal4Gauge_EMP", label = "EMP", short = "EMP" },
        },
    },
    Cal4p7x10TF = {
        label    = "4.7x10mm Tungsten Flechettes",
        variants = {
            { id = "Ammo.Cal4p7x10TF", label = "Generic", short = "GEN" },
            { id = "Ammo.Cal4p7x10TF_EMP", label = "EMP", short = "EMP" },
            { id = "Ammo.Cal4p7x10TF_INC", label = "Incendiary", short = "INC" },
            { id = "Ammo.Cal4p7x10TF_CHEM", label = "Chemical", short = "CHEM" },
        },
    },
    Cal5p45CT = {
        label    = "5.45mm CT",
        variants = {
            { id = "Ammo.Cal5p45CT", label = "FMJ", short = "FMJ" },
            { id = "Ammo.Cal5p45CT_AP", label = "Armor Pierce", short = "AP" },
            { id = "Ammo.Cal5p45CT_HP", label = "Hollow Point", short = "HP" },
            { id = "Ammo.Cal5p45CT_EMP", label = "EMP", short = "EMP" },
            { id = "Ammo.Cal5p45CT_INC", label = "Incendiary", short = "INC" },
            { id = "Ammo.Cal5p45CT_CHEM", label = "Chemical", short = "CHEM" },
            { id = "Ammo.Cal5p45CT_NL", label = "Non-Lethal", short = "NL" },
        },
    },
    Cal5p56x45NUSA = {
        label    = "5.56x45mm NUSA",
        variants = {
            { id = "Ammo.Cal5p56x45NUSA", label = "FMJ", short = "FMJ" },
            { id = "Ammo.Cal5p56x45NUSA_AP", label = "Armor Pierce", short = "AP" },
            { id = "Ammo.Cal5p56x45NUSA_HP", label = "Hollow Point", short = "HP" },
            { id = "Ammo.Cal5p56x45NUSA_EMP", label = "EMP", short = "EMP" },
            { id = "Ammo.Cal5p56x45NUSA_INC", label = "Incendiary", short = "INC" },
            { id = "Ammo.Cal5p56x45NUSA_CHEM", label = "Chemical", short = "CHEM" },
            { id = "Ammo.Cal5p56x45NUSA_NL", label = "Non-Lethal", short = "NL" },
        },
    },
    Cal5p56CT = {
        label    = "5.56mm CT",
        variants = {
            { id = "Ammo.Cal5p56CT", label = "FMJ", short = "FMJ" },
            { id = "Ammo.Cal5p56CT_AP", label = "Armor Pierce", short = "AP" },
            { id = "Ammo.Cal5p56CT_HP", label = "Hollow Point", short = "HP" },
            { id = "Ammo.Cal5p56CT_EMP", label = "EMP", short = "EMP" },
            { id = "Ammo.Cal5p56CT_INC", label = "Incendiary", short = "INC" },
            { id = "Ammo.Cal5p56CT_CHEM", label = "Chemical", short = "CHEM" },
            { id = "Ammo.Cal5p56CT_NL", label = "Non-Lethal", short = "NL" },
            { id = "Ammo.Cal5p56CT_HE", label = "High Explosive", short = "HE" },
        },
    },
    Cal5p7x28TF = {
        label    = "5.7x28mm Tungsten Flechettes",
        variants = {
            { id = "Ammo.Cal5p7x28TF", label = "Generic", short = "GEN" },
            { id = "Ammo.Cal5p7x28TF_EMP", label = "EMP", short = "EMP" },
            { id = "Ammo.Cal5p7x28TF_INC", label = "Incendiary", short = "INC" },
            { id = "Ammo.Cal5p7x28TF_CHEM", label = "Chemical", short = "CHEM" },
        },
    },
    Cal6p5x25Minirocket = {
        label    = "6.5x25mm Guided Minirocket",
        variants = {
            { id = "Ammo.Cal6p5x25Minirocket", label = "Generic", short = "GEN" },
            { id = "Ammo.Cal6p5x25Minirocket_EMP", label = "EMP", short = "EMP" },
            { id = "Ammo.Cal6p5x25Minirocket_INC", label = "Incendiary", short = "INC" },
            { id = "Ammo.Cal6p5x25Minirocket_CHEM", label = "Chemical", short = "CHEM" },
            { id = "Ammo.Cal6p5x25Minirocket_HE", label = "High Explosive", short = "HE" },
        },
    },
    Cal6p5Arasaka = {
        label    = "6.5mm Arasaka",
        variants = {
            { id = "Ammo.Cal6p5Arasaka", label = "FMJ", short = "FMJ" },
            { id = "Ammo.Cal6p5Arasaka_AP", label = "Armor Pierce", short = "AP" },
            { id = "Ammo.Cal6p5Arasaka_HP", label = "Hollow Point", short = "HP" },
            { id = "Ammo.Cal6p5Arasaka_EMP", label = "EMP", short = "EMP" },
            { id = "Ammo.Cal6p5Arasaka_INC", label = "Incendiary", short = "INC" },
            { id = "Ammo.Cal6p5Arasaka_CHEM", label = "Chemical", short = "CHEM" },
            { id = "Ammo.Cal6p5Arasaka_NL", label = "Non-Lethal", short = "NL" },
        },
    },
    Cal7p62x39Sov = {
        label    = "7.62x39mm Soviet",
        variants = {
            { id = "Ammo.Cal7p62x39Sov", label = "FMJ", short = "FMJ" },
            { id = "Ammo.Cal7p62x39Sov_AP", label = "Armor Pierce", short = "AP" },
            { id = "Ammo.Cal7p62x39Sov_HP", label = "Hollow Point", short = "HP" },
            { id = "Ammo.Cal7p62x39Sov_EMP", label = "EMP", short = "EMP" },
            { id = "Ammo.Cal7p62x39Sov_INC", label = "Incendiary", short = "INC" },
            { id = "Ammo.Cal7p62x39Sov_CHEM", label = "Chemical", short = "CHEM" },
            { id = "Ammo.Cal7p62x39Sov_NL", label = "Non-Lethal", short = "NL" },
        },
    },
    Cal8x30RailF = {
        label    = "8x30mm Rail Flechettes",
        variants = {
            { id = "Ammo.Cal8x30RailF", label = "Generic", short = "GEN" },
            { id = "Ammo.Cal8x30RailF_EMP", label = "EMP", short = "EMP" },
            { id = "Ammo.Cal8x30RailF_INC", label = "Incendiary", short = "INC" },
            { id = "Ammo.Cal8x30RailF_CHEM", label = "Chemical", short = "CHEM" },
        },
    },
    Cal8x30TShot = {
        label    = "8x30mm Tungsten Shot",
        variants = {
            { id = "Ammo.Cal8x30TShot", label = "FMJ", short = "FMJ" },
            { id = "Ammo.Cal8x30TShot_EMP", label = "EMP", short = "EMP" },
            { id = "Ammo.Cal8x30TShot_INC", label = "Incendiary", short = "INC" },
            { id = "Ammo.Cal8x30TShot_CHEM", label = "Chemical", short = "CHEM" },
        },
    },
    Cal9p5x35Minirocket = {
        label    = "9.5x35mm Guided Minirocket",
        variants = {
            { id = "Ammo.Cal9p5x35Minirocket", label = "Generic", short = "GEN" },
            { id = "Ammo.Cal9p5x35Minirocket_EMP", label = "EMP", short = "EMP" },
            { id = "Ammo.Cal9p5x35Minirocket_INC", label = "Incendiary", short = "INC" },
            { id = "Ammo.Cal9p5x35Minirocket_CHEM", label = "Chemical", short = "CHEM" },
            { id = "Ammo.Cal9p5x35Minirocket_HE", label = "High Explosive", short = "HE" },
        },
    },
    Cal9x19 = {
        label    = "9x19mm Parabellum",
        variants = {
            { id = "Ammo.Cal9x19", label = "FMJ", short = "FMJ" },
            { id = "Ammo.Cal9x19_AP", label = "Armor Pierce", short = "AP" },
            { id = "Ammo.Cal9x19_HP", label = "Hollow Point", short = "HP" },
            { id = "Ammo.Cal9x19_EMP", label = "EMP", short = "EMP" },
            { id = "Ammo.Cal9x19_INC", label = "Incendiary", short = "INC" },
            { id = "Ammo.Cal9x19_CHEM", label = "Chemical", short = "CHEM" },
            { id = "Ammo.Cal9x19_NL", label = "Non-Lethal", short = "NL" },
        },
    },
    Cal9x30TF = {
        label    = "9x30mm Tungsten Flechettes",
        variants = {
            { id = "Ammo.Cal9x30TF", label = "Generic", short = "GEN" },
            { id = "Ammo.Cal9x30TF_EMP", label = "EMP", short = "EMP" },
            { id = "Ammo.Cal9x30TF_INC", label = "Incendiary", short = "INC" },
            { id = "Ammo.Cal9x30TF_CHEM", label = "Chemical", short = "CHEM" },
        },
    },
}

-- ── Inventory query ───────────────────────────────────────────────────────────
local function getQty(ammoId)
    local p = Game.GetPlayer()
    if not p then return 0 end
    return Game.GetTransactionSystem():GetItemQuantity(
        p, ItemID.FromTDBID(TweakDBID.new(ammoId))
    )
end

local function startsWith(s, prefix)
    return s:sub(1, #prefix) == prefix
end

-- ── Live caliber state ───────────────────────────────────────────────────────
local currentCalKey  = ""
local currentCal     = nil   -- reference into CALIBER_VARIANTS, nil when no DPAE weapon
local localActiveID  = ""    -- which variant is selected (Lua-side mirror)

-- Per-caliber ammo memory, keyed by caliber key (e.g. "Cal9x19"). This table lives
-- in Lua/CET, which survives a normal save load — only a full game relaunch resets
-- it. Redscript keeps its own equivalent table on the PlayerPuppet entity for
-- same-session weapon re-equips, but that's a plain @addField and is NOT part of
-- the native save format, so it resets to empty on every load. This table is what
-- lets healAfterLoad() below notice the gap and re-issue the selection.
local REMEMBERED = {}

-- Fixed 2026-07-11 — dpae_caliber (redscript) updates synchronously the moment
-- a weapon is drawn, but dpae_active_ammo only resolves later, after DPAE's own
-- async zero-then-reselect delay finishes (needed when the freshly drawn weapon's
-- chamber wasn't empty). onDraw runs every frame regardless, so a frame could
-- catch the NEW caliber key here while GetActiveAmmoID() still reports the
-- PREVIOUS weapon's ammo — mirroring that straight into REMEMBERED[key] then
-- files an unrelated caliber's ammo ID under the new caliber's slot. Confirmed
-- live: swapping from Dying Night (Cal45Super_EMP active) to a freshly
-- ground-picked-up Lexington (Cal9x19) polluted REMEMBERED["Cal9x19"] with
-- "Ammo.Cal45Super_EMP" this way, which healAfterLoad below then dutifully
-- reselected once redscript's own resolve legitimately landed on "nothing to
-- select." Guard: an active-ammo TDBID only genuinely belongs to caliber `key`
-- if it's built from that caliber's own base TDBID ("Ammo." .. key), the way
-- DPAE_SelectAmmo always constructs every plain/suffixed/locked variant ID —
-- reject anything else instead of trusting it.
local function refreshCaliber(p)
    local key = p:DPAE_GetCaliberString()
    if key == currentCalKey then return end
    currentCalKey  = key
    currentCal     = CALIBER_VARIANTS[key]
    -- Redscript may have silently restored a remembered selection for this caliber
    -- on weapon draw — mirror whatever it actually picked (empty string if none).
    localActiveID  = p:DPAE_GetActiveAmmoID()
    if localActiveID ~= "" and startsWith(localActiveID, "Ammo." .. key) then
        REMEMBERED[key] = localActiveID
    end
end

-- Runs every frame the loader window is open. After a save load, redscript's own
-- active-ammo state is gone (reset to "none") even though the real ammo items are
-- still sitting in inventory from before the save. If Lua still remembers a
-- selection for the current caliber and the player still has stock, re-issue it.
-- Same caliber-prefix guard as refreshCaliber above, defense in depth in case
-- REMEMBERED ever ends up holding a mismatched entry from elsewhere.
local function healAfterLoad(p)
    if not currentCal then return end
    if p:DPAE_GetActiveAmmoID() ~= "" then return end
    local remembered = REMEMBERED[currentCalKey]
    if not remembered or remembered == "" then return end
    if not startsWith(remembered, "Ammo." .. currentCalKey) then return end
    if getQty(remembered) <= 0 then return end
    p:DPAE_SelectAmmo(TweakDBID.new(remembered))
    localActiveID = remembered
end

-- ── UI helpers ────────────────────────────────────────────────────────────────
local function colorFor(shortName)
    local c = ROUND_COLORS[shortName]
    if c then return c[1], c[2], c[3] end
    return 0.7, 0.7, 0.7
end

local function endsWith(s, suffix)
    return suffix == "" or s:sub(-#suffix) == suffix
end

-- Locked weapons (Comrade's Hammer-style single-caliber locks are already just a
-- single-entry CALIBER_VARIANTS list — this is for weapons SHARING a caliber with
-- other unrestricted guns, e.g. Hypercritical locked to HE on Cal22x126 AC while
-- Kolac on the same caliber sees the full spread) only ever get ONE selectable
-- entry: whichever variant DPAE_GetLockedVariantID() names. Suffix-derived label/
-- color rather than a table lookup, since the locked variant may not even be one
-- of the caliber's normally-displayed choices (e.g. Seraph's Cal45Super_HE, a
-- lock-only variant not shown to the other .45 Super guns).
local function describeLockedVariant(id, calLabel)
    if endsWith(id, "_HE") or endsWith(id, "HE") then
        return { id = id, label = "High Explosive", short = "HE" }
    end
    if endsWith(id, "_AP") then
        return { id = id, label = "Armor Pierce", short = "AP" }
    end
    if endsWith(id, "_Slug") then
        return { id = id, label = "Slug", short = "SLUG" }
    end
    return { id = id, label = calLabel, short = "FMJ" }
end

-- Shared by the picker UI and the cycle hotkey so both agree on exactly which
-- variants this specific weapon may select — locked weapons collapse to their
-- one permitted variant, otherwise the caliber's full list minus whatever
-- DPAE_GetRestrictedVariantSuffix says this weapon isn't permitted to fire
-- (e.g. Cal23x152Sov_HE -> Borzaya/O'Five, Cal4Gauge_EMP -> Mox). Without this shared
-- helper, the cycle hotkey (which used to read currentCal.variants directly)
-- could land on a restricted variant that DPAE_SelectAmmo's own redscript-side
-- enforcement then silently falls back away from, desyncing the UI's
-- "selected" label from the weapon's actual active ammo.
local function getEffectiveVariants(p, cal, calLabel)
    local lockedID = p:DPAE_GetLockedVariantID()
    if lockedID ~= "" then
        return { describeLockedVariant(lockedID, calLabel) }, lockedID
    end
    local restrictedSuffix = p:DPAE_GetRestrictedVariantSuffix()
    if restrictedSuffix == "" then
        return cal.variants, lockedID
    end
    local filtered = {}
    for _, v in ipairs(cal.variants) do
        if not endsWith(v.id, restrictedSuffix) then
            table.insert(filtered, v)
        end
    end
    return filtered, lockedID
end

-- Selects the next variant (in display order, wrapping around) that has stock,
-- skipping whichever is currently active. If nothing is active yet, picks the
-- first one with stock. No-op if nothing has any stock at all.
local function cycleToNextVariant(p, variants)
    if #variants == 0 then return end
    local startIdx = 0
    for i, v in ipairs(variants) do
        if v.id == localActiveID then startIdx = i; break end
    end
    for offset = 1, #variants do
        local idx = ((startIdx + offset - 1) % #variants) + 1
        local v = variants[idx]
        if getQty(v.id) > 0 then
            p:DPAE_SelectAmmo(TweakDBID.new(v.id))
            localActiveID = v.id
            REMEMBERED[currentCalKey] = v.id
            return
        end
    end
end

-- Reality-check: redscript can change the active variant on its own now
-- (depletion-to-empty, auto-swap to another variant on depletion, or
-- auto-select-largest on first equip) — always mirror whatever it actually
-- has active rather than only checking for the zero-count case. Pulled out
-- of drawPoolUI so the native HUD push (updateHUD below) can rely on
-- localActiveID being current even when the CET window is closed and
-- drawPoolUI never runs.
local function syncActiveID(p)
    local actualActiveID = p:DPAE_GetActiveAmmoID()
    if actualActiveID ~= localActiveID then
        localActiveID = actualActiveID
        if localActiveID ~= "" then
            REMEMBERED[currentCalKey] = localActiveID
        end
    end
end

-- ── Ammo pool selector UI ─────────────────────────────────────────────────────
-- One active variant at a time. Selecting zeroes the chamber/tube and pools that
-- many native-ammo tokens into inventory so vanilla reloads drain them normally.
-- Works the same for magazine-fed and tube-fed weapons.
local function drawPoolUI(p, calLabel, variants, isTube, isLocked)
    ImGui.TextColored(1.0, 0.9, 0.3, 1.0, isTube and "TUBE-FED WEAPON" or "MAGAZINE-FED WEAPON")
    ImGui.TextColored(0.65, 0.65, 0.65, 1.0,
        "Select one ammo type. Each shot consumes one round.")
    if isLocked then
        ImGui.TextColored(1.0, 0.7, 0.2, 1.0, "This weapon can only chamber one variant.")
    end
    ImGui.Separator()

    -- Active status line
    if localActiveID ~= "" then
        local left      = p:DPAE_GetActiveAmmoCount()
        local shortName = "?"
        for _, v in ipairs(variants) do
            if v.id == localActiveID then shortName = v.short; break end
        end
        local r, g, b = colorFor(shortName)
        ImGui.Text("Active: ")
        ImGui.SameLine()
        ImGui.TextColored(r, g, b, 1.0, shortName)
        ImGui.SameLine()
        ImGui.Text("(" .. left .. " remaining)")
        ImGui.SameLine()
        if not isLocked and ImGui.SmallButton("Clear") then
            p:DPAE_ClearAmmo()
            localActiveID = ""
            REMEMBERED[currentCalKey] = ""
        end
    else
        ImGui.TextColored(0.55, 0.55, 0.55, 1.0, "No active type — select below.")
    end

    ImGui.Separator()
    ImGui.Text(calLabel .. ":")
    ImGui.Spacing()

    for _, v in ipairs(variants) do
        local qty      = getQty(v.id)
        local r, g, b  = colorFor(v.short)
        local isActive = (localActiveID == v.id)

        ImGui.TextColored(r, g, b, 1.0, string.format("%-14s", v.label))
        ImGui.SameLine()
        ImGui.Text(string.format("x%d", qty))
        ImGui.SameLine()
        if isActive then
            ImGui.TextColored(0.40, 1.00, 0.40, 1.0, "[ACTIVE]")
        elseif qty > 0 then
            if ImGui.SmallButton("Select##" .. v.id) then
                p:DPAE_SelectAmmo(TweakDBID.new(v.id))
                localActiveID = v.id
                REMEMBERED[currentCalKey] = v.id
            end
        else
            ImGui.TextDisabled("--")
        end
    end
end

-- ── Native HUD widget bridge ─────────────────────────────────────────────────
-- Pushes the same label/short/color/qty data drawPoolUI already computes for
-- the CET picker into DPAE_AmmoHUDSystem (DPAE_AmmoHUD.reds) — a native,
-- always-visible inkwidget readout, independent of whether the CET debug
-- window is open. Report-only (no buttons there); CET picker stays fully
-- functional and is what still drives actual selection for now — this is
-- step one of "build the inkwidget on top first, remove CET once confirmed
-- working." Diffed against the last-pushed values so it's not calling into
-- redscript every single frame for no reason.
local lastHUDVariant = nil
local lastHUDQty      = nil

local function getAmmoHUDSystem()
    return Game.GetScriptableSystemsContainer():Get("DPAE_AmmoHUDSystem")
end

local function updateHUD(p)
    local sys = getAmmoHUDSystem()
    if not sys then return end

    -- MK.31 HMG (2026-07-21) — not DPAE-managed at all (no caliber, no pool,
    -- see WeaponCaliberTags.yaml's Cal50BMG section), so currentCal is always
    -- nil for it. Still worth reporting on the HUD, just as a fixed display
    -- instead of the normal variant/caliber pair.
    if p:DPAE_IsHMGEquipped() then
        if lastHUDVariant ~= "Belt-Fed" then
            lastHUDVariant = "Belt-Fed"
            lastHUDQty     = nil
            sys:UpdateDisplay(".50 BMG APHET-IL", "Belt-Fed", 0, 1.0, 0.75, 0.35)
        end
        return
    end

    if not currentCal or localActiveID == "" then
        if lastHUDVariant ~= nil then
            sys:HideDisplay()
            lastHUDVariant = nil
            lastHUDQty     = nil
        end
        return
    end

    local effectiveVariants = getEffectiveVariants(p, currentCal, currentCal.label)
    local variantLabel = "?"
    local shortName    = "?"
    for _, v in ipairs(effectiveVariants) do
        if v.id == localActiveID then
            variantLabel = v.label
            shortName    = v.short
            break
        end
    end
    local qty = p:DPAE_GetActiveAmmoCount()

    if variantLabel == lastHUDVariant and qty == lastHUDQty then return end
    lastHUDVariant = variantLabel
    lastHUDQty     = qty

    local r, g, b = colorFor(shortName)
    sys:UpdateDisplay(currentCal.label, variantLabel, qty, r, g, b)
end

-- ── CET event hooks ───────────────────────────────────────────────────────────
-- Pool model needs no reload hook: native reload only ever moves ammo from the
-- dummy token pool (inventory) into the chamber, never the other way, so there is
-- nothing to write off or correct — vanilla reload behavior is used as-is.

registerHotkey("DPAE_ToggleWindow", "DPAE: Toggle Ammo Loader", function()
    windowOpen = not windowOpen
end)

registerHotkey("DPAE_CycleAmmo", "DPAE: Cycle Ammo Variant", function()
    local p = Game.GetPlayer()
    if not p then return end
    if not currentCal then return end
    local effectiveVariants, lockedID = getEffectiveVariants(p, currentCal, currentCal.label)
    if lockedID ~= "" then return end -- nothing to cycle, only one option
    cycleToNextVariant(p, effectiveVariants)
end)

-- Native redscript drop (NPCAmmoDrops.reds's DPAE_DropCurrentWeapon, via
-- ItemActionsHelper.DropItem) instead of a raw Game.DropItem call from here —
-- a standalone QoL hotkey, drop the equipped weapon without opening the
-- inventory. Replaces relying on the separate "Drop Current Weapon (World
-- Drop) - CET" mod for the same purpose.
registerHotkey("DPAE_DropCurrentWeapon", "DPAE: Drop Current Weapon", function()
    local p = Game.GetPlayer()
    if not p then return end
    p:DPAE_DropCurrentWeapon()
end)

-- ── Main UI ───────────────────────────────────────────────────────────────────
registerForEvent('onDraw', function()
    local p = Game.GetPlayer()
    if not p then return end

    -- Runs every frame regardless of windowOpen — the native HUD (below) needs
    -- to stay current even while the CET debug window is closed.
    refreshCaliber(p)
    healAfterLoad(p)
    syncActiveID(p)
    updateHUD(p)

    if not windowOpen then return end

    local calLabel = currentCal and currentCal.label or "No DPAE weapon drawn"
    local isTube   = p:DPAE_IsTubeFed()
    local title    = "DPAE: Ammo Selector — " .. calLabel

    ImGui.SetNextWindowSize(480, 580)
    if not ImGui.Begin(title) then
        ImGui.End()
        return
    end

    if not currentCal then
        ImGui.TextColored(1.0, 0.4, 0.4, 1.0,
            "Draw a weapon with a DPAE_Cal* tag to enable the loader.")
        ImGui.End()
        return
    end

    -- ─────────────────────────────────────────────────────────────────────────
    local effectiveVariants, lockedID = getEffectiveVariants(p, currentCal, calLabel)
    drawPoolUI(p, calLabel, effectiveVariants, isTube, lockedID ~= "")
    -- ─────────────────────────────────────────────────────────────────────────

    ImGui.End()
end)

-- ── Settings menu (Native Settings UI) ──────────────────────────────────────────
-- Same pattern as the user's own "Hack The Planet For Real" mod
-- (HackthePlanetForRealConfig.reds + its init.lua) — a "/PierreMods" tab shared
-- across the user's published mods, one subcategory per mod. Gracefully no-ops
-- if Native Settings UI isn't installed (settings just stay at their redscript
-- defaults, same as vanilla behavior — nothing breaks, the menu simply isn't
-- offered). Add one entry to DPAE_settings + one addSwitch call + one Override
-- per future toggle.

local DPAE_settings = {
    AccurateDamageColors = false,
    TrueDamageConversion = true,
    ForceReloadOnAmmoSwitch = false,
}

local DPAE_SETTINGS_FILE = "settings-DesoPierreAmmoExpanded.json"

function DPAE_BuildSettingsMenu(nativeSettings)
    if not nativeSettings.pathExists("/PierreMods") then
        nativeSettings.addTab("/PierreMods", "Pierre Mods")
    end

    if nativeSettings.pathExists("/PierreMods/DesoPierreAmmoExpanded") then
        nativeSettings.removeSubcategory("/PierreMods/DesoPierreAmmoExpanded")
    end
    nativeSettings.addSubcategory("/PierreMods/DesoPierreAmmoExpanded", "Ammo Expanded")

    nativeSettings.addSwitch("/PierreMods/DesoPierreAmmoExpanded", "Accurate Damage Colors",
        "Show the real elemental color (Thermal/Electric/Chemical) on the initial hit's damage number when converted ammo is active, instead of vanilla always showing Physical for direct hits. Purely cosmetic — the actual damage dealt is correct either way; this only affects the on-screen number's color.",
        DPAE_settings.AccurateDamageColors, false, function(state)
            DPAE_settings.AccurateDamageColors = state
        end)

    nativeSettings.addSwitch("/PierreMods/DesoPierreAmmoExpanded", "True Damage Conversion",
        "On: elemental ammo (Incendiary/EMP/Chemical) genuinely shifts damage out of Physical into Thermal/Electric/Chemical, same as vanilla Pyro's own conversion. Off: elemental damage is simply added on top of full, unreduced Physical damage instead — a simpler bonus-only behavior.",
        DPAE_settings.TrueDamageConversion, true, function(state)
            DPAE_settings.TrueDamageConversion = state
        end)

    nativeSettings.addSwitch("/PierreMods/DesoPierreAmmoExpanded", "Force Reload On Ammo Switch",
        "On: manually switching ammo variant mid-fight drains the physical chamber, requiring a real reload before the new variant actually fires — closes the free instant elemental swap a full magazine otherwise allows. Off (default): switching applies immediately with no reload cost. Weapons that can't reload at all (HMGs and a few iconic pistols/revolvers) are never affected by this, regardless of the setting.",
        DPAE_settings.ForceReloadOnAmmoSwitch, false, function(state)
            DPAE_settings.ForceReloadOnAmmoSwitch = state
        end)
end

function DPAE_SaveSettings()
    local validJson, contents = pcall(function() return json.encode(DPAE_settings) end)
    if validJson and contents ~= nil then
        local f = io.open(DPAE_SETTINGS_FILE, "w+")
        if f ~= nil then
            f:write(contents)
            f:close()
        end
    end
end

function DPAE_LoadSettings()
    local file = io.open(DPAE_SETTINGS_FILE, "r")
    if file ~= nil then
        local contents = file:read("*a")
        local validJson, savedState = pcall(function() return json.decode(contents) end)
        if validJson then
            file:close()
            for key, _ in pairs(DPAE_settings) do
                if savedState[key] ~= nil then
                    DPAE_settings[key] = savedState[key]
                end
            end
        end
    end
end

function DPAE_OverrideConfigFunctions()
    Override("DesoPierreAmmoExpandedSettings", "AccurateDamageColors;", function()
        return DPAE_settings.AccurateDamageColors
    end)
    Override("DesoPierreAmmoExpandedSettings", "TrueDamageConversion;", function()
        return DPAE_settings.TrueDamageConversion
    end)
    Override("DesoPierreAmmoExpandedSettings", "ForceReloadOnAmmoSwitch;", function()
        return DPAE_settings.ForceReloadOnAmmoSwitch
    end)
end

registerForEvent("onInit", function()
    local nativeSettings = GetMod("nativeSettings")
    if not nativeSettings then
        print("[DPAE] NativeSettings not loaded. Continuing with settings from config file.")
        return
    end
    DPAE_LoadSettings()
    DPAE_BuildSettingsMenu(nativeSettings)
    DPAE_OverrideConfigFunctions()
end)

registerForEvent("onShutdown", function()
    DPAE_SaveSettings()
end)

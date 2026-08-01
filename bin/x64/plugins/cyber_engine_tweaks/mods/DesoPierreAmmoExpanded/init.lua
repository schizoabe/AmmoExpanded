local ROUND_COLORS = {
    FMJ   = { 0.85, 0.85, 0.85 },
    GEN   = { 0.85, 0.85, 0.85 },
    BUCK  = { 0.85, 0.85, 0.85 },
    HP    = { 1.00, 0.45, 0.45 },
    AP    = { 0.45, 0.75, 1.00 },
    NL    = { 0.45, 1.00, 0.45 },
    EMP   = { 0.80, 0.45, 1.00 },
    INC   = { 1.00, 0.55, 0.15 },
    HE    = { 1.00, 0.80, 0.20 },
    SLUG  = { 0.95, 0.85, 0.50 },
    TECH  = { 1.00, 0.70, 0.30 },
    CHEM  = { 0.55, 0.90, 0.35 },
    SNAKE = { 0.55, 0.85, 0.25 },
    SIG   = { 1.00, 0.95, 0.55 },
}

local CALIBER_VARIANTS = {
    Cal243Win = {
        label    = ".243 Winchester",
        variants = {
            { id = "Ammo.Cal243Win",      label = "FMJ",            short = "FMJ" },
            { id = "Ammo.Cal243Win_AP",   label = "Armor Pierce",   short = "AP" },
            { id = "Ammo.Cal243Win_HP",   label = "Hollow Point",   short = "HP" },
            { id = "Ammo.Cal243Win_EMP",  label = "EMP",            short = "EMP" },
            { id = "Ammo.Cal243Win_INC",  label = "Incendiary",     short = "INC" },
            { id = "Ammo.Cal243Win_CHEM", label = "Chemical",       short = "CHEM" },
            { id = "Ammo.Cal243Win_NL",   label = "Non-Lethal",     short = "NL" },
            { id = "Ammo.Cal243Win_HE",   label = "High Explosive", short = "HE" },
        },
    },
    Cal45Super = {
        label    = ".45 Super",
        variants = {
            { id = "Ammo.Cal45Super",           label = "FMJ",            short = "FMJ" },
            { id = "Ammo.Cal45Super_AP",        label = "Armor Pierce",   short = "AP" },
            { id = "Ammo.Cal45Super_HP",        label = "Hollow Point",   short = "HP" },
            { id = "Ammo.Cal45Super_Snakeshot", label = "Snakeshot",      short = "SNAKE" },
            { id = "Ammo.Cal45Super_EMP",       label = "EMP",            short = "EMP" },
            { id = "Ammo.Cal45Super_INC",       label = "Incendiary",     short = "INC" },
            { id = "Ammo.Cal45Super_CHEM",      label = "Chemical",       short = "CHEM" },
            { id = "Ammo.Cal45Super_NL",        label = "Non-Lethal",     short = "NL" },
            { id = "Ammo.Cal45Super_HE",        label = "High Explosive", short = "HE" },
        },
    },
    Cal45WinMag = {
        label    = ".45 Winchester Magnum",
        variants = {
            { id = "Ammo.Cal45WinMag",           label = "FMJ",            short = "FMJ" },
            { id = "Ammo.Cal45WinMag_AP",        label = "Armor Pierce",   short = "AP" },
            { id = "Ammo.Cal45WinMag_HP",        label = "Hollow Point",   short = "HP" },
            { id = "Ammo.Cal45WinMag_Snakeshot", label = "Snakeshot",      short = "SNAKE" },
            { id = "Ammo.Cal45WinMag_EMP",       label = "EMP",            short = "EMP" },
            { id = "Ammo.Cal45WinMag_INC",       label = "Incendiary",     short = "INC" },
            { id = "Ammo.Cal45WinMag_CHEM",      label = "Chemical",       short = "CHEM" },
            { id = "Ammo.Cal45WinMag_NL",        label = "Non-Lethal",     short = "NL" },
            { id = "Ammo.Cal45WinMag_HE",        label = "High Explosive", short = "HE" },
        },
    },
    Cal454Casull = {
        label    = ".454 Casull",
        variants = {
            { id = "Ammo.Cal454Casull",           label = "FMJ",            short = "FMJ" },
            { id = "Ammo.Cal454Casull_AP",        label = "Armor Pierce",   short = "AP" },
            { id = "Ammo.Cal454Casull_HP",        label = "Hollow Point",   short = "HP" },
            { id = "Ammo.Cal454Casull_Snakeshot", label = "Snakeshot",      short = "SNAKE" },
            { id = "Ammo.Cal454Casull_EMP",       label = "EMP",            short = "EMP" },
            { id = "Ammo.Cal454Casull_INC",       label = "Incendiary",     short = "INC" },
            { id = "Ammo.Cal454Casull_CHEM",      label = "Chemical",       short = "CHEM" },
            { id = "Ammo.Cal454Casull_NL",        label = "Non-Lethal",     short = "NL" },
            { id = "Ammo.Cal454Casull_HE",        label = "High Explosive", short = "HE" },
        },
    },
    Cal50AE = {
        label    = ".50 AE",
        variants = {
            { id = "Ammo.Cal50AE",      label = "FMJ",            short = "FMJ" },
            { id = "Ammo.Cal50AE_AP",   label = "Armor Pierce",   short = "AP" },
            { id = "Ammo.Cal50AE_HP",   label = "Hollow Point",   short = "HP" },
            { id = "Ammo.Cal50AE_EMP",  label = "EMP",            short = "EMP" },
            { id = "Ammo.Cal50AE_INC",  label = "Incendiary",     short = "INC" },
            { id = "Ammo.Cal50AE_CHEM", label = "Chemical",       short = "CHEM" },
            { id = "Ammo.Cal50AE_NL",   label = "Non-Lethal",     short = "NL" },
            { id = "Ammo.Cal50AE_HE",   label = "High Explosive", short = "HE" },
        },
    },
    Cal50BeowulfOni = {
        label    = ".50 Beowulf Oni",
        variants = {
            { id = "Ammo.Cal50BeowulfOni",      label = "FMJ",            short = "FMJ" },
            { id = "Ammo.Cal50BeowulfOni_AP",   label = "Armor Pierce",   short = "AP" },
            { id = "Ammo.Cal50BeowulfOni_HP",   label = "Hollow Point",   short = "HP" },
            { id = "Ammo.Cal50BeowulfOni_EMP",  label = "EMP",            short = "EMP" },
            { id = "Ammo.Cal50BeowulfOni_INC",  label = "Incendiary",     short = "INC" },
            { id = "Ammo.Cal50BeowulfOni_CHEM", label = "Chemical",       short = "CHEM" },
            { id = "Ammo.Cal50BeowulfOni_NL",   label = "Non-Lethal",     short = "NL" },
            { id = "Ammo.Cal50BeowulfOni_HE",   label = "High Explosive", short = "HE" },
        },
    },
    Cal50BMG = {
        label    = ".50 BMG NUSA",
        variants = {
            { id = "Ammo.Cal50BMG",      label = "FMJ",            short = "FMJ" },
            { id = "Ammo.Cal50BMG_AP",   label = "Armor Pierce",   short = "AP" },
            { id = "Ammo.Cal50BMG_HP",   label = "Hollow Point",   short = "HP" },
            { id = "Ammo.Cal50BMG_EMP",  label = "EMP",            short = "EMP" },
            { id = "Ammo.Cal50BMG_INC",  label = "Incendiary",     short = "INC" },
            { id = "Ammo.Cal50BMG_CHEM", label = "Chemical",       short = "CHEM" },
            { id = "Ammo.Cal50BMG_NL",   label = "Non-Lethal",     short = "NL" },
            { id = "Ammo.Cal50BMG_HE",   label = "High Explosive", short = "HE" },
        },
    },
    Cal500Malour = {
        label    = ".500 Malour",
        variants = {
            { id = "Ammo.Cal500Malour",     label = "FMJ",            short = "FMJ" },
            { id = "Ammo.Cal500Malour_AP",  label = "Armor Pierce",   short = "AP" },
            { id = "Ammo.Cal500Malour_INC", label = "Incendiary",     short = "INC" },
            { id = "Ammo.Cal500Malour_HE",  label = "High Explosive", short = "HE" },
        },
    },
    Cal10GaugeBuck = {
        label    = "10 Gauge Buckshot",
        variants = {
            { id = "Ammo.Cal10GaugeBuck",             label = "Buckshot",        short = "BUCK" },
            { id = "Ammo.Cal10GaugeBuck_Slug",        label = "Slug",            short = "SLUG" },
            { id = "Ammo.Cal10GaugeBuck_INC",         label = "Incendiary",      short = "INC" },
            { id = "Ammo.Cal10GaugeBuck_HE",          label = "High Explosive",  short = "HE" },
            { id = "Ammo.Cal10GaugeBuck_Dezerter_HE", label = "Signature Round", short = "SIG" },
        },
    },
    Cal10GaugeFlech = {
        label    = "10 Gauge Flechettes",
        variants = {
            { id = "Ammo.Cal10GaugeFlech",      label = "Generic",    short = "GEN" },
            { id = "Ammo.Cal10GaugeFlech_EMP",  label = "EMP",        short = "EMP" },
            { id = "Ammo.Cal10GaugeFlech_INC",  label = "Incendiary", short = "INC" },
            { id = "Ammo.Cal10GaugeFlech_CHEM", label = "Chemical",   short = "CHEM" },
        },
    },
    Cal10x40Rocket = {
        label    = "10x40mm Guided Rocket",
        variants = {
            { id = "Ammo.Cal10x40Rocket",              label = "Generic",         short = "GEN" },
            { id = "Ammo.Cal10x40Rocket_HE",           label = "High Explosive",  short = "HE" },
            { id = "Ammo.Cal10x40Rocket_INC",          label = "Incendiary",      short = "INC" },
            { id = "Ammo.Cal10x40Rocket_CHEM",         label = "Chemical",        short = "CHEM" },
            { id = "Ammo.Cal10x40Rocket_EMP",          label = "EMP",             short = "EMP" },
            { id = "Ammo.Cal10x40Rocket_Divided_CHEM", label = "Signature Round", short = "SIG" },
        },
    },
    Cal10mmAuto = {
        label    = "10mm Auto",
        variants = {
            { id = "Ammo.Cal10mmAuto",      label = "FMJ",            short = "FMJ" },
            { id = "Ammo.Cal10mmAuto_AP",   label = "Armor Pierce",   short = "AP" },
            { id = "Ammo.Cal10mmAuto_HP",   label = "Hollow Point",   short = "HP" },
            { id = "Ammo.Cal10mmAuto_EMP",  label = "EMP",            short = "EMP" },
            { id = "Ammo.Cal10mmAuto_INC",  label = "Incendiary",     short = "INC" },
            { id = "Ammo.Cal10mmAuto_CHEM", label = "Chemical",       short = "CHEM" },
            { id = "Ammo.Cal10mmAuto_NL",   label = "Non-Lethal",     short = "NL" },
            { id = "Ammo.Cal10mmAuto_HE",   label = "High Explosive", short = "HE" },
        },
    },
    Cal10x20TF = {
        label    = "10x20mm Tungsten Flechettes",
        variants = {
            { id = "Ammo.Cal10x20TF",      label = "Generic",    short = "GEN" },
            { id = "Ammo.Cal10x20TF_EMP",  label = "EMP",        short = "EMP" },
            { id = "Ammo.Cal10x20TF_INC",  label = "Incendiary", short = "INC" },
            { id = "Ammo.Cal10x20TF_CHEM", label = "Chemical",   short = "CHEM" },
        },
    },
    Cal12Gauge = {
        label    = "12 Gauge Buckshot",
        variants = {
            { id = "Ammo.Cal12Gauge",      label = "Buckshot",       short = "BUCK" },
            { id = "Ammo.Cal12Gauge_Slug", label = "Slug",           short = "SLUG" },
            { id = "Ammo.Cal12Gauge_INC",  label = "Incendiary",     short = "INC" },
            { id = "Ammo.Cal12Gauge_HE",   label = "High Explosive", short = "HE" },
        },
    },
    Cal12p3x41UdaR = {
        label    = "12.3x41mm UdaR",
        variants = {
            { id = "Ammo.Cal12p3x41UdaR",           label = "FMJ",            short = "FMJ" },
            { id = "Ammo.Cal12p3x41UdaR_AP",        label = "Armor Pierce",   short = "AP" },
            { id = "Ammo.Cal12p3x41UdaR_HP",        label = "Hollow Point",   short = "HP" },
            { id = "Ammo.Cal12p3x41UdaR_Snakeshot", label = "Snakeshot",      short = "SNAKE" },
            { id = "Ammo.Cal12p3x41UdaR_INC",       label = "Incendiary",     short = "INC" },
            { id = "Ammo.Cal12p3x41UdaR_HE",        label = "High Explosive", short = "HE" },
            { id = "Ammo.Cal12p3x41UdaR_CHEM",      label = "Chemical",       short = "CHEM" },
        },
    },
    Cal12p7x70Rocket = {
        label    = "12.7x70mm Guided Rocket",
        variants = {
            { id = "Ammo.Cal12p7x70Rocket",      label = "Generic",        short = "GEN" },
            { id = "Ammo.Cal12p7x70Rocket_HE",   label = "High Explosive", short = "HE" },
            { id = "Ammo.Cal12p7x70Rocket_INC",  label = "Incendiary",     short = "INC" },
            { id = "Ammo.Cal12p7x70Rocket_CHEM", label = "Chemical",       short = "CHEM" },
            { id = "Ammo.Cal12p7x70Rocket_EMP",  label = "EMP",            short = "EMP" },
        },
    },
    Cal12x45Rocket = {
        label    = "12x45mm Guided Rocket",
        variants = {
            { id = "Ammo.Cal12x45Rocket",               label = "Generic",         short = "GEN" },
            { id = "Ammo.Cal12x45Rocket_HE",            label = "High Explosive",  short = "HE" },
            { id = "Ammo.Cal12x45Rocket_INC",           label = "Incendiary",      short = "INC" },
            { id = "Ammo.Cal12x45Rocket_CHEM",          label = "Chemical",        short = "CHEM" },
            { id = "Ammo.Cal12x45Rocket_EMP",           label = "EMP",             short = "EMP" },
            { id = "Ammo.Cal12x45Rocket_Hercules_CHEM", label = "Signature Round", short = "SIG" },
        },
    },
    Cal14x40TSlug = {
        label    = "14x40mm Tungsten Slug",
        variants = {
            { id = "Ammo.Cal14x40TSlug",      label = "FMJ",            short = "FMJ" },
            { id = "Ammo.Cal14x40TSlug_EMP",  label = "EMP",            short = "EMP" },
            { id = "Ammo.Cal14x40TSlug_INC",  label = "Incendiary",     short = "INC" },
            { id = "Ammo.Cal14x40TSlug_CHEM", label = "Chemical",       short = "CHEM" },
            { id = "Ammo.Cal14x40TSlug_HE",   label = "High Explosive", short = "HE" },
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
            { id = "Ammo.Cal15x55Rocket",      label = "Generic",        short = "GEN" },
            { id = "Ammo.Cal15x55Rocket_HE",   label = "High Explosive", short = "HE" },
            { id = "Ammo.Cal15x55Rocket_INC",  label = "Incendiary",     short = "INC" },
            { id = "Ammo.Cal15x55Rocket_CHEM", label = "Chemical",       short = "CHEM" },
            { id = "Ammo.Cal15x55Rocket_EMP",  label = "EMP",            short = "EMP" },
        },
    },
    Cal15x80TSpike = {
        label    = "15x80mm Tungsten Spike",
        variants = {
            { id = "Ammo.Cal15x80TSpike",      label = "FMJ",        short = "FMJ" },
            { id = "Ammo.Cal15x80TSpike_EMP",  label = "EMP",        short = "EMP" },
            { id = "Ammo.Cal15x80TSpike_INC",  label = "Incendiary", short = "INC" },
            { id = "Ammo.Cal15x80TSpike_CHEM", label = "Chemical",   short = "CHEM" },
        },
    },
    Cal18x70Rocket = {
        label    = "18x70mm Guided Rocket",
        variants = {
            { id = "Ammo.Cal18x70Rocket",      label = "Generic",        short = "GEN" },
            { id = "Ammo.Cal18x70Rocket_HE",   label = "High Explosive", short = "HE" },
            { id = "Ammo.Cal18x70Rocket_INC",  label = "Incendiary",     short = "INC" },
            { id = "Ammo.Cal18x70Rocket_CHEM", label = "Chemical",       short = "CHEM" },
            { id = "Ammo.Cal18x70Rocket_EMP",  label = "EMP",            short = "EMP" },
        },
    },
    Cal20x102Vulcan = {
        label    = "20x102mm Vulcan",
        variants = {
            { id = "Ammo.Cal20x102Vulcan",      label = "Standard (Armor-Piercing)", short = "AP" },
            { id = "Ammo.Cal20x102Vulcan_HE",   label = "High Explosive",            short = "HE" },
            { id = "Ammo.Cal20x102Vulcan_INC",  label = "Incendiary",                short = "INC" },
            { id = "Ammo.Cal20x102Vulcan_CHEM", label = "Chemical",                  short = "CHEM" },
            { id = "Ammo.Cal20x102Vulcan_EMP",  label = "EMP",                       short = "EMP" },
        },
    },
    Cal22x126AC = {
        label    = "22x126mm AC",
        variants = {
            { id = "Ammo.Cal22x126AC",      label = "Standard (Armor-Piercing)", short = "AP" },
            { id = "Ammo.Cal22x126AC_HE",   label = "High Explosive",            short = "HE" },
            { id = "Ammo.Cal22x126AC_INC",  label = "Incendiary",                short = "INC" },
            { id = "Ammo.Cal22x126AC_CHEM", label = "Chemical",                  short = "CHEM" },
            { id = "Ammo.Cal22x126AC_EMP",  label = "EMP",                       short = "EMP" },
        },
    },
    Cal23x152Sov = {
        label    = "23x152mm Soviet",
        variants = {
            { id = "Ammo.Cal23x152Sov",            label = "Standard (Armor-Piercing)", short = "AP" },
            { id = "Ammo.Cal23x152Sov_HE",         label = "High Explosive",            short = "HE" },
            { id = "Ammo.Cal23x152Sov_INC",        label = "Incendiary",                short = "INC" },
            { id = "Ammo.Cal23x152Sov_EMP",        label = "EMP",                       short = "EMP" },
            { id = "Ammo.Cal23x152Sov_CHEM",       label = "Chemical",                  short = "CHEM" },
            { id = "Ammo.Cal23x152Sov_Sparky_EMP", label = "Signature Round",           short = "SIG" },
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
            { id = "Ammo.Cal4Gauge",      label = "Buckshot",       short = "BUCK" },
            { id = "Ammo.Cal4Gauge_Slug", label = "Slug",           short = "SLUG" },
            { id = "Ammo.Cal4Gauge_INC",  label = "Incendiary",     short = "INC" },
            { id = "Ammo.Cal4Gauge_HE",   label = "High Explosive", short = "HE" },
            { id = "Ammo.Cal4Gauge_EMP",  label = "EMP",            short = "EMP" },
        },
    },
    Cal4p7x10TF = {
        label    = "4.7x10mm Tungsten Flechettes",
        variants = {
            { id = "Ammo.Cal4p7x10TF",      label = "Generic",    short = "GEN" },
            { id = "Ammo.Cal4p7x10TF_EMP",  label = "EMP",        short = "EMP" },
            { id = "Ammo.Cal4p7x10TF_INC",  label = "Incendiary", short = "INC" },
            { id = "Ammo.Cal4p7x10TF_CHEM", label = "Chemical",   short = "CHEM" },
        },
    },
    Cal5p45CT = {
        label    = "5.45mm CT",
        variants = {
            { id = "Ammo.Cal5p45CT",      label = "FMJ",            short = "FMJ" },
            { id = "Ammo.Cal5p45CT_AP",   label = "Armor Pierce",   short = "AP" },
            { id = "Ammo.Cal5p45CT_HP",   label = "Hollow Point",   short = "HP" },
            { id = "Ammo.Cal5p45CT_EMP",  label = "EMP",            short = "EMP" },
            { id = "Ammo.Cal5p45CT_INC",  label = "Incendiary",     short = "INC" },
            { id = "Ammo.Cal5p45CT_CHEM", label = "Chemical",       short = "CHEM" },
            { id = "Ammo.Cal5p45CT_NL",   label = "Non-Lethal",     short = "NL" },
            { id = "Ammo.Cal5p45CT_HE",   label = "High Explosive", short = "HE" },
        },
    },
    Cal5p56x45NUSA = {
        label    = "5.56x45mm NUSA",
        variants = {
            { id = "Ammo.Cal5p56x45NUSA",      label = "FMJ",            short = "FMJ" },
            { id = "Ammo.Cal5p56x45NUSA_AP",   label = "Armor Pierce",   short = "AP" },
            { id = "Ammo.Cal5p56x45NUSA_HP",   label = "Hollow Point",   short = "HP" },
            { id = "Ammo.Cal5p56x45NUSA_EMP",  label = "EMP",            short = "EMP" },
            { id = "Ammo.Cal5p56x45NUSA_INC",  label = "Incendiary",     short = "INC" },
            { id = "Ammo.Cal5p56x45NUSA_CHEM", label = "Chemical",       short = "CHEM" },
            { id = "Ammo.Cal5p56x45NUSA_NL",   label = "Non-Lethal",     short = "NL" },
            { id = "Ammo.Cal5p56x45NUSA_HE",   label = "High Explosive", short = "HE" },
        },
    },
    Cal5p56CT = {
        label    = "5.56mm CT",
        variants = {
            { id = "Ammo.Cal5p56CT",      label = "FMJ",            short = "FMJ" },
            { id = "Ammo.Cal5p56CT_AP",   label = "Armor Pierce",   short = "AP" },
            { id = "Ammo.Cal5p56CT_HP",   label = "Hollow Point",   short = "HP" },
            { id = "Ammo.Cal5p56CT_EMP",  label = "EMP",            short = "EMP" },
            { id = "Ammo.Cal5p56CT_INC",  label = "Incendiary",     short = "INC" },
            { id = "Ammo.Cal5p56CT_CHEM", label = "Chemical",       short = "CHEM" },
            { id = "Ammo.Cal5p56CT_NL",   label = "Non-Lethal",     short = "NL" },
            { id = "Ammo.Cal5p56CT_HE",   label = "High Explosive", short = "HE" },
        },
    },
    Cal5p7x28TF = {
        label    = "5.7x28mm Tungsten Flechettes",
        variants = {
            { id = "Ammo.Cal5p7x28TF",      label = "Generic",    short = "GEN" },
            { id = "Ammo.Cal5p7x28TF_EMP",  label = "EMP",        short = "EMP" },
            { id = "Ammo.Cal5p7x28TF_INC",  label = "Incendiary", short = "INC" },
            { id = "Ammo.Cal5p7x28TF_CHEM", label = "Chemical",   short = "CHEM" },
        },
    },
    Cal6p5x25Minirocket = {
        label    = "6.5x25mm Guided Minirocket",
        variants = {
            { id = "Ammo.Cal6p5x25Minirocket",      label = "Generic",        short = "GEN" },
            { id = "Ammo.Cal6p5x25Minirocket_EMP",  label = "EMP",            short = "EMP" },
            { id = "Ammo.Cal6p5x25Minirocket_INC",  label = "Incendiary",     short = "INC" },
            { id = "Ammo.Cal6p5x25Minirocket_CHEM", label = "Chemical",       short = "CHEM" },
            { id = "Ammo.Cal6p5x25Minirocket_HE",   label = "High Explosive", short = "HE" },
        },
    },
    Cal6p5Arasaka = {
        label    = "6.5mm Arasaka",
        variants = {
            { id = "Ammo.Cal6p5Arasaka",      label = "FMJ",            short = "FMJ" },
            { id = "Ammo.Cal6p5Arasaka_AP",   label = "Armor Pierce",   short = "AP" },
            { id = "Ammo.Cal6p5Arasaka_HP",   label = "Hollow Point",   short = "HP" },
            { id = "Ammo.Cal6p5Arasaka_EMP",  label = "EMP",            short = "EMP" },
            { id = "Ammo.Cal6p5Arasaka_INC",  label = "Incendiary",     short = "INC" },
            { id = "Ammo.Cal6p5Arasaka_CHEM", label = "Chemical",       short = "CHEM" },
            { id = "Ammo.Cal6p5Arasaka_NL",   label = "Non-Lethal",     short = "NL" },
            { id = "Ammo.Cal6p5Arasaka_HE",   label = "High Explosive", short = "HE" },
        },
    },
    Cal7p62x39Sov = {
        label    = "7.62x39mm Soviet",
        variants = {
            { id = "Ammo.Cal7p62x39Sov",      label = "FMJ",            short = "FMJ" },
            { id = "Ammo.Cal7p62x39Sov_AP",   label = "Armor Pierce",   short = "AP" },
            { id = "Ammo.Cal7p62x39Sov_HP",   label = "Hollow Point",   short = "HP" },
            { id = "Ammo.Cal7p62x39Sov_HE",   label = "High Explosive", short = "HE" },
            { id = "Ammo.Cal7p62x39Sov_EMP",  label = "EMP",            short = "EMP" },
            { id = "Ammo.Cal7p62x39Sov_INC",  label = "Incendiary",     short = "INC" },
            { id = "Ammo.Cal7p62x39Sov_CHEM", label = "Chemical",       short = "CHEM" },
            { id = "Ammo.Cal7p62x39Sov_NL",   label = "Non-Lethal",     short = "NL" },
        },
    },
    Cal8x30RailF = {
        label    = "8x30mm Rail Flechettes",
        variants = {
            { id = "Ammo.Cal8x30RailF",      label = "Generic",    short = "GEN" },
            { id = "Ammo.Cal8x30RailF_EMP",  label = "EMP",        short = "EMP" },
            { id = "Ammo.Cal8x30RailF_INC",  label = "Incendiary", short = "INC" },
            { id = "Ammo.Cal8x30RailF_CHEM", label = "Chemical",   short = "CHEM" },
        },
    },
    Cal8x30TShot = {
        label    = "8x30mm Tungsten Shot",
        variants = {
            { id = "Ammo.Cal8x30TShot",      label = "FMJ",        short = "FMJ" },
            { id = "Ammo.Cal8x30TShot_EMP",  label = "EMP",        short = "EMP" },
            { id = "Ammo.Cal8x30TShot_INC",  label = "Incendiary", short = "INC" },
            { id = "Ammo.Cal8x30TShot_CHEM", label = "Chemical",   short = "CHEM" },
        },
    },
    Cal9p5x35Minirocket = {
        label    = "9.5x35mm Guided Minirocket",
        variants = {
            { id = "Ammo.Cal9p5x35Minirocket",              label = "Generic",         short = "GEN" },
            { id = "Ammo.Cal9p5x35Minirocket_EMP",          label = "EMP",             short = "EMP" },
            { id = "Ammo.Cal9p5x35Minirocket_INC",          label = "Incendiary",      short = "INC" },
            { id = "Ammo.Cal9p5x35Minirocket_CHEM",         label = "Chemical",        short = "CHEM" },
            { id = "Ammo.Cal9p5x35Minirocket_HE",           label = "High Explosive",  short = "HE" },
            { id = "Ammo.Cal9p5x35Minirocket_Yinglong_EMP", label = "Signature Round", short = "SIG" },
        },
    },
    Cal9x19 = {
        label    = "9x19mm Parabellum",
        variants = {
            { id = "Ammo.Cal9x19",      label = "FMJ",            short = "FMJ" },
            { id = "Ammo.Cal9x19_AP",   label = "Armor Pierce",   short = "AP" },
            { id = "Ammo.Cal9x19_HP",   label = "Hollow Point",   short = "HP" },
            { id = "Ammo.Cal9x19_EMP",  label = "EMP",            short = "EMP" },
            { id = "Ammo.Cal9x19_INC",  label = "Incendiary",     short = "INC" },
            { id = "Ammo.Cal9x19_CHEM", label = "Chemical",       short = "CHEM" },
            { id = "Ammo.Cal9x19_NL",   label = "Non-Lethal",     short = "NL" },
            { id = "Ammo.Cal9x19_HE",   label = "High Explosive", short = "HE" },
        },
    },
    Cal9x30TF = {
        label    = "9x30mm Tungsten Flechettes",
        variants = {
            { id = "Ammo.Cal9x30TF",      label = "Generic",    short = "GEN" },
            { id = "Ammo.Cal9x30TF_EMP",  label = "EMP",        short = "EMP" },
            { id = "Ammo.Cal9x30TF_INC",  label = "Incendiary", short = "INC" },
            { id = "Ammo.Cal9x30TF_CHEM", label = "Chemical",   short = "CHEM" },
        },
    },
}

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

local currentCalKey = ""
local currentCal    = nil
local localActiveID = ""

local REMEMBERED    = {}

local function refreshCaliber(p)
    local key = p:DPAE_GetCaliberString()
    if key == currentCalKey then return end
    currentCalKey = key
    currentCal    = CALIBER_VARIANTS[key]
    localActiveID = p:DPAE_GetActiveAmmoID()
    if localActiveID ~= "" and startsWith(localActiveID, "Ammo." .. key) then
        REMEMBERED[key] = localActiveID
    end
end

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

local function colorFor(shortName)
    local c = ROUND_COLORS[shortName]
    if c then return c[1], c[2], c[3] end
    return 0.7, 0.7, 0.7
end

local function endsWith(s, suffix)
    return suffix == "" or s:sub(- #suffix) == suffix
end

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

local function getEffectiveVariants(p, cal, calLabel)
    local lockedID = p:DPAE_GetLockedVariantID()
    if lockedID ~= "" then
        return { describeLockedVariant(lockedID, calLabel) }, lockedID
    end
    local restrictedSuffixes = p:DPAE_GetRestrictedVariantSuffixes()
    if restrictedSuffixes == "" then
        return cal.variants, lockedID
    end
    local restrictedSet = {}
    for suffix in restrictedSuffixes:gmatch("[^,]+") do
        restrictedSet[suffix] = true
    end
    local filtered = {}
    for _, v in ipairs(cal.variants) do
        local isRestricted = false
        for suffix in pairs(restrictedSet) do
            if endsWith(v.id, suffix) then
                isRestricted = true
                break
            end
        end
        if not isRestricted then
            table.insert(filtered, v)
        end
    end
    return filtered, lockedID
end

local function cycleToNextVariant(p, variants)
    if #variants == 0 then return end
    local startIdx = 0
    for i, v in ipairs(variants) do
        if v.id == localActiveID then
            startIdx = i; break
        end
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

local function syncActiveID(p)
    local actualActiveID = p:DPAE_GetActiveAmmoID()
    if actualActiveID ~= localActiveID then
        localActiveID = actualActiveID
        if localActiveID ~= "" then
            REMEMBERED[currentCalKey] = localActiveID
        end
    end
end

local lastHUDVariant = nil
local lastHUDQty     = nil

local function getAmmoHUDSystem()
    return Game.GetScriptableSystemsContainer():Get("DPAE_AmmoHUDSystem")
end

local function updateHUD(p)
    local sys = getAmmoHUDSystem()
    if not sys then return end

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
    local variantLabel      = "?"
    local shortName         = "?"
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

    local r, g, b  = colorFor(shortName)
    sys:UpdateDisplay(currentCal.label, variantLabel, qty, r, g, b)
end


local function pollInputRequests(p)
    local sys = getAmmoHUDSystem()
    if not sys then return end

    if sys:ConsumeCycleAmmoRequest() then
        if currentCal then
            local effectiveVariants, lockedID = getEffectiveVariants(p, currentCal, currentCal.label)
            if lockedID == "" then
                cycleToNextVariant(p, effectiveVariants)
            end
        end
    end
end

registerForEvent('onDraw', function()
    local p = Game.GetPlayer()
    if not p then return end

    refreshCaliber(p)
    healAfterLoad(p)
    syncActiveID(p)
    updateHUD(p)
    pollInputRequests(p)
end)

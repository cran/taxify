## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = FALSE
)

## ----eval=FALSE---------------------------------------------------------------
# # Rubus fruticosus agg. gets the aggregate's trait where the source has it,
# # otherwise the nominal Rubus fruticosus value.
# taxify("Rubus fruticosus agg.") |>
#   add_trait("plant_height")

## ----list-enrichments---------------------------------------------------------
# library(taxify)
# 
# list_enrichments()
# #>              name version   nrow static                              trait_cols ...
# #> 1 iucn  ...  166000   TRUE                   conservation_status ...
# #> 2               griis  ...   23000  FALSE                      invasive_status ...
# #> 3                wcvp  ...  340000  FALSE                        native_status ...
# #> ...

## ----list-traits--------------------------------------------------------------
# list_traits()
# #>          trait              label        kind   unit n_sources    sources
# #> 1    woodiness          Woodiness categorical   <NA>         2 zanne, gift
# #> 2 plant_height       Plant height     numeric      m         2  diaz, gift
# #> 3    seed_mass          Seed mass     numeric     mg         2  diaz, gift
# #> 4          sla Specific leaf area     numeric mm2/mg         2  leda, gift

## ----add-trait-coalesce-------------------------------------------------------
# taxify("Abies alba") |>
#   add_trait("seed_mass")
# #> # accepted_name  ... seed_mass seed_mass_unit seed_mass_sources seed_mass_n
# #> # Abies alba     ...   67.9748             mg        diaz,gift            2

## ----add-trait-wide-----------------------------------------------------------
# taxify("Abies alba") |>
#   add_trait("woodiness", mode = "wide")
# #> # accepted_name  ... woodiness_zanne woodiness_gift
# #> # Abies alba     ...           woody          woody

## ----trait-info---------------------------------------------------------------
# trait_info("seed_mass")
# #> Seed mass (numeric, mg)  |  default priority: diaz > gift
# #>   source  enrichment       column                   note caution
# #> 1   diaz diaz_traits seed_mass_mg            Milligrams.      NA
# #> 2   gift        gift gift_seed_mass_mean GIFT grams -> mg.    NA

## ----pre-download-------------------------------------------------------------
# # Download a single enrichment
# taxify_download_enrichment("iucn")
# 
# # Download several at once
# taxify_download_enrichment(c("zanne", "eive", "leda"))
# 
# # Download all of them
# taxify_download_enrichment(c(
#   "iucn", "griis", "wcvp", "eive",
#   "elton_traits", "avonet", "pantheria", "amphibio",
#   "common_names", "zanne", "diaz_traits", "leda",
#   "fungal_traits", "funguild", "algae_traits",
#   "fishmorph", "fishbase", "repttraits", "anage", "glonaf",
#   "leptraits", "animaltraits", "arthropod_traits", "alien_first_records",
#   "baseflor", "ecoflora", "floraweb"
# ))

## ----woodiness----------------------------------------------------------------
# plants <- taxify(c(
#   "Quercus robur", "Betula pendula", "Arrhenatherum elatius",
#   "Festuca rubra", "Salix caprea", "Cornus sanguinea"
# ))
# 
# plants |> add_zanne()
# #>               input_name       accepted_name woodiness
# #> 1          Quercus robur       Quercus robur     woody
# #> 2        Betula pendula      Betula pendula     woody
# #> 3 Arrhenatherum elatius Arrhenatherum elatius herbaceous
# #> 4         Festuca rubra        Festuca rubra herbaceous
# #> 5         Salix caprea        Salix caprea     woody
# #> 6    Cornus sanguinea     Cornus sanguinea     woody

## ----eive---------------------------------------------------------------------
# grasses <- taxify(c(
#   "Arrhenatherum elatius", "Bromus erectus", "Festuca rubra",
#   "Dactylis glomerata", "Lolium perenne", "Poa pratensis"
# ))
# 
# grasses |> add_eive()
# #>          input_name eive_light eive_temperature eive_moisture eive_reaction eive_nutrients
# #> 1 Arrhenatherum ...       7.2              5.8           4.3           7.1            6.5
# #> 2    Bromus erectus       7.6              5.5           3.1           7.8            3.2
# #> ...

## ----diaz-traits--------------------------------------------------------------
# trees <- taxify(c(
#   "Quercus robur", "Fagus sylvatica", "Picea abies",
#   "Pinus sylvestris", "Acer pseudoplatanus"
# ))
# 
# trees |> add_diaz_traits()
# #>          input_name seed_mass_mg plant_height_m
# #> 1     Quercus robur      3200.0           25.0
# #> 2  Fagus sylvatica      2200.0           30.0
# #> 3      Picea abies        7.9           40.0
# #> 4 Pinus sylvestris        6.5           25.0
# #> 5 Acer pseudoplatanus   120.0           25.0

## ----leda---------------------------------------------------------------------
# meadow_spp <- taxify(c(
#   "Arrhenatherum elatius", "Trifolium pratense",
#   "Leucanthemum vulgare", "Plantago lanceolata",
#   "Achillea millefolium", "Centaurea jacea"
# ))
# 
# meadow_spp |> add_leda()
# #>          input_name raunkiaer_life_form dispersal_type sla_mm2_mg canopy_height_m ...
# #> 1 Arrhenatherum ...  hemicryptophyte     anemochory       25.1            0.90  ...
# #> 2 Trifolium pratense hemicryptophyte     zoochory         22.3            0.30  ...
# #> ...

## ----regional-plants, eval=FALSE----------------------------------------------
# taxify(c("Bellis perennis", "Achillea millefolium", "Calluna vulgaris")) |>
#   add_ecoflora() |>
#   add_floraweb()

## ----fungalroot---------------------------------------------------------------
# taxify(c("Quercus robur", "Pinus sylvestris", "Trifolium pratense",
#          "Vaccinium myrtillus", "Brassica oleracea")) |>
#   add_fungalroot()
# #>          input_name     genus mycorrhizal_type mycorrhizal_status mycorrhizal_records
# #> 1       Quercus robur   Quercus              EcM        mycorrhizal                 163
# #> 2    Pinus sylvestris     Pinus              EcM        mycorrhizal                 500
# #> 3  Trifolium pratense Trifolium               AM        mycorrhizal                 193
# #> 4 Vaccinium myrtillus Vaccinium              ErM        mycorrhizal                 227
# #> 5   Brassica oleracea  Brassica               NM    non-mycorrhizal                  59

## ----gift, eval=FALSE---------------------------------------------------------
# taxify(c("Abies alba", "Quercus robur")) |>
#   add_gift()

## ----gift-select, eval=FALSE--------------------------------------------------
# gift_traits()                                   # available trait columns
# 
# taxify(c("Abies alba", "Quercus robur")) |>
#   add_gift(cols = c("plant_height_max", "sla_mean", "woodiness_1"))

## ----conservation-status------------------------------------------------------
# species <- taxify(c(
#   "Panthera tigris", "Ailuropoda melanoleuca",
#   "Gorilla gorilla", "Vulpes vulpes",
#   "Passer domesticus", "Quercus robur"
# ))
# 
# species |> add_iucn()
# #>            input_name conservation_status
# #> 1     Panthera tigris                  EN
# #> 2 Ailuropoda melanoleuca               VU
# #> 3      Gorilla gorilla                  CR
# #> 4        Vulpes vulpes                  LC
# #> 5   Passer domesticus                  LC
# #> 6       Quercus robur                  LC

## ----avonet-------------------------------------------------------------------
# birds <- taxify(c(
#   "Parus major", "Cyanistes caeruleus", "Erithacus rubecula",
#   "Turdus merula", "Falco peregrinus", "Aquila chrysaetos"
# ))
# 
# birds |> add_avonet()
# #>        input_name beak_length wing_length avonet_body_mass_g migration trophic_niche ...
# #> 1     Parus major        11.2        75.1               18.5 sedentary  Invertivore  ...
# #> 2 Cyanistes caeruleus    9.8        67.2               11.0 sedentary  Invertivore  ...
# #> 3 Erithacus rubecula    11.5        72.3               17.1   partial  Invertivore  ...
# #> 4    Turdus merula      20.8       130.5               95.0   partial    Omnivore   ...
# #> 5 Falco peregrinus      15.2       312.0              750.0      full  Vertivore    ...
# #> 6 Aquila chrysaetos     37.5       607.0             4000.0   partial  Vertivore    ...

## ----elton-traits-------------------------------------------------------------
# birds <- taxify(c(
#   "Parus major", "Dendrocopos major", "Alcedo atthis",
#   "Tyto alba", "Apus apus"
# ))
# 
# birds |> add_elton_traits()
# #>       input_name diet_inv diet_fruit diet_seed foraging_canopy foraging_aerial nocturnal ...
# #> 1    Parus major       60         10        20              50               0         0 ...
# #> 2 Dendrocopos major    75          5        10              80               0         0 ...
# #> 3   Alcedo atthis       0          0         0               0               0         0 ...
# #> 4       Tyto alba       10          0         0               0               0         1 ...
# #> 5       Apus apus      100          0         0               0             100         0 ...

## ----pantheria----------------------------------------------------------------
# mammals <- taxify(c(
#   "Vulpes vulpes", "Canis lupus", "Ursus arctos",
#   "Mustela nivalis", "Lutra lutra", "Lynx lynx"
# ))
# 
# mammals |> add_pantheria()
# #>      input_name pantheria_body_mass_g longevity_mo litter_size home_range_km2 ...
# #> 1  Vulpes vulpes               5480.0          144         5.0           8.55 ...
# #> 2   Canis lupus              31757.0          192         5.4         242.00 ...
# #> 3  Ursus arctos             139000.0          396         2.0         488.00 ...
# #> 4 Mustela nivalis               67.0           72         5.5           0.03 ...
# #> 5   Lutra lutra               8000.0          180         2.3          15.00 ...
# #> 6     Lynx lynx              20500.0          252         2.6         168.00 ...

## ----amphibio-----------------------------------------------------------------
# amphibians <- taxify(c(
#   "Bufo bufo", "Rana temporaria", "Salamandra salamandra",
#   "Triturus cristatus", "Hyla arborea", "Bombina variegata"
# ))
# 
# amphibians |> add_amphibio()
# #>           input_name body_size_mm arboreal aquatic direct_development nocturnal_amphibio ...
# #> 1          Bufo bufo        150.0        0       0                  0                  1 ...
# #> 2    Rana temporaria        110.0        0       1                  0                  0 ...
# #> 3 Salamandra salamandra    200.0        0       0                  0                  1 ...
# #> 4  Triturus cristatus      160.0        0       1                  0                  1 ...
# #> 5       Hyla arborea         50.0        1       0                  0                  1 ...
# #> 6  Bombina variegata         50.0        0       1                  0                  0 ...

## ----fungal-traits------------------------------------------------------------
# fungi <- taxify(c(
#   "Amanita muscaria", "Boletus edulis", "Trametes versicolor",
#   "Agaricus bisporus", "Cantharellus cibarius"
# ))
# 
# fungi |> add_fungal_traits()
# #>          input_name primary_lifestyle  growth_form fruitbody_type decay_substrate ...
# #> 1  Amanita muscaria   ectomycorrhizal     agaricoid      agaricoid            <NA> ...
# #> 2    Boletus edulis   ectomycorrhizal       boletoid       boletoid            <NA> ...
# #> 3 Trametes versicolor      saprotroph  polyporoid      polyporoid           wood  ...
# #> 4 Agaricus bisporus       saprotroph     agaricoid      agaricoid          litter ...
# #> 5 Cantharellus cibarius ectomycorrhizal cantharelloid cantharelloid          <NA> ...

## ----funguild-----------------------------------------------------------------
# fungi <- taxify(c(
#   "Amanita muscaria", "Boletus edulis", "Trametes versicolor",
#   "Agaricus bisporus", "Cantharellus cibarius"
# ))
# 
# fungi |> add_funguild()
# #>          input_name     trophic_mode                   guild funguild_growth_form confidence_ranking
# #> 1  Amanita muscaria       Symbiotroph       Ectomycorrhizal            Agaricoid            Highly Probable
# #> 2    Boletus edulis       Symbiotroph       Ectomycorrhizal             Boletoid            Highly Probable
# #> 3 Trametes versicolor      Saprotroph        Wood Saprotroph           Polyporoid            Highly Probable
# #> 4 Agaricus bisporus       Saprotroph      Litter Saprotroph            Agaricoid            Highly Probable
# #> 5 Cantharellus cibarius   Symbiotroph       Ectomycorrhizal        Cantharelloid            Highly Probable

## ----algae-traits-------------------------------------------------------------
# seaweeds <- taxify(c(
#   "Fucus vesiculosus", "Ulva lactuca", "Laminaria digitata",
#   "Chondrus crispus", "Sargassum muticum"
# ))
# 
# seaweeds |> add_algae_traits()
# #>          input_name algae_body_size_cm algae_growth_form algae_calcification algae_tidal_zone ...
# #> 1 Fucus vesiculosus               60.0          foliose               none         intertidal ...
# #> 2      Ulva lactuca               30.0          foliose               none         intertidal ...
# #> 3 Laminaria digitata             200.0          foliose               none         subtidal   ...
# #> 4    Chondrus crispus              15.0          foliose               none         intertidal ...
# #> 5  Sargassum muticum             300.0          foliose               none         subtidal   ...

## ----fish-traits--------------------------------------------------------------
# freshwater_fish <- taxify(c(
#   "Salmo trutta", "Esox lucius", "Cyprinus carpio",
#   "Perca fluviatilis", "Silurus glanis"
# ))
# 
# freshwater_fish |> add_fishmorph()
# #>        input_name fish_body_elongation fish_relative_eye_size fish_oral_gape_position fish_body_lateral_shape ...
# #> 1    Salmo trutta                 0.22          0.08                    0.42                    0.18 ...
# #> 2    Esox lucius                  0.18          0.06                    0.50                    0.15 ...
# #> 3  Cyprinus carpio                0.35          0.05                    0.38                    0.25 ...
# #> 4 Perca fluviatilis               0.30          0.07                    0.40                    0.22 ...
# #> 5   Silurus glanis                0.15          0.03                    0.48                    0.12 ...

## ----fishbase-----------------------------------------------------------------
# fish <- taxify(c(
#   "Gadus morhua", "Thunnus thynnus", "Hippocampus hippocampus",
#   "Squalus acanthias", "Salmo trutta"
# ))
# 
# fish |> add_fishbase()
# #>              input_name fb_body_length_cm fb_body_mass_g fb_trophic_level fb_depth_min_m fb_depth_max_m ...
# #> 1          Gadus morhua            132.0        55500.0              4.4            0.0          600.0 ...
# #> 2      Thunnus thynnus            458.0       684000.0              4.2            0.0         1000.0 ...
# #> 3 Hippocampus hippocampus          15.0             NA              3.1            1.0           60.0 ...
# #> 4    Squalus acanthias            160.0         11000.0              4.3           16.0          900.0 ...
# #> 5         Salmo trutta            140.0        50000.0              3.4            0.0          332.0 ...

## ----repttraits---------------------------------------------------------------
# reptiles <- taxify(c(
#   "Pogona vitticeps", "Python regius", "Chelonia mydas",
#   "Naja naja", "Crocodylus niloticus"
# ), backbone = "reptiledb")
# 
# reptiles |> add_repttraits()
# #>             input_name biogeographic_realm habitat_type elevation_max_m body_mass_g  svl_mm reproductive_mode ...
# #> 1     Pogona vitticeps     Australo-Pacific      Desert/...             612       575.4   250         oviparous ...
# #> 2        Python regius          Afrotropic         Forest            1200      1610.6  1125         oviparous ...
# #> 3       Chelonia mydas              Marine       Wetlands              NA    230000.0  1500         oviparous ...
# #> 4            Naja naja            Oriental         Forest            1009      1683.5  1570         oviparous ...
# #> 5 Crocodylus niloticus          Afrotropic       Wetlands              NA    750000.0    NA         oviparous ...

## ----anage--------------------------------------------------------------------
# vertebrates <- taxify(c(
#   "Vulpes vulpes", "Aquila chrysaetos", "Crocodylus niloticus",
#   "Bufo bufo", "Salmo salar"
# ), backbone = c("col", "gbif"))
# 
# vertebrates |> add_anage()
# #>              input_name max_longevity_yr anage_body_mass_g metabolic_rate_w ...
# #> 1         Vulpes vulpes             15.2            5480.0            10.41 ...
# #> 2   Aquila chrysaetos              46.0            4210.0             8.94 ...
# #> 3 Crocodylus niloticus             44.0          242500.0               NA ...
# #> 4            Bufo bufo             36.0              48.0               NA ...
# #> 5         Salmo salar              13.0            3400.0               NA ...

## ----animaltraits-------------------------------------------------------------
# arthropods <- taxify(c(
#   "Drosophila melanogaster", "Apis mellifera",
#   "Tenebrio molitor", "Gryllus campestris"
# ), backbone = c("col", "gbif"))
# 
# arthropods |> add_animaltraits()
# #>                input_name animaltraits_body_mass_kg animaltraits_metabolic_rate_w
# #> 1 Drosophila melanogaster              0.000001030                    0.000000218
# #> 2         Apis mellifera              0.000100000                    0.000012600
# #> 3       Tenebrio molitor              0.000140000                    0.000004850
# #> 4    Gryllus campestris              0.000800000                           NA

## ----leptraits----------------------------------------------------------------
# butterflies <- taxify(c(
#   "Vanessa cardui", "Pieris rapae", "Papilio machaon",
#   "Lycaena phlaeas", "Colias crocea"
# ), backbone = c("col", "gbif"))
# 
# butterflies |> add_leptraits()
# #>        input_name wingspan_mm voltinism diapause_stage canopy_affinity ...
# #> 1   Vanessa cardui        62.5       3.0             NA    Open canopy ...
# #> 2     Pieris rapae        47.5       4.0           pupa    Open canopy ...
# #> 3  Papilio machaon        75.0       2.0           pupa    Open canopy ...
# #> 4  Lycaena phlaeas        30.0       3.0          larva    Open canopy ...
# #> 5    Colias crocea        48.5       3.0          adult    Open canopy ...

## ----arthropod-traits---------------------------------------------------------
# insects <- taxify(c(
#   "Abax parallelepipedus", "Pterostichus melanarius",
#   "Chorthippus parallelus", "Araneus diadematus"
# ), backbone = c("col", "gbif"))
# 
# insects |> add_arthropod_traits()
# #>               input_name arthropod_body_size_mm arthropod_dispersal arthropod_voltinism arthropod_feeding_guild ...
# #> 1 Abax parallelepipedus                   18.5                0.01                 1.0               carnivore ...
# #> 2 Pterostichus melanarius                 15.0                0.32                 1.0               carnivore ...
# #> 3 Chorthippus parallelus                  17.0                0.10                 1.0               herbivore ...
# #> 4   Araneus diadematus                    13.0                0.45                 1.0               carnivore ...

## ----invasive-single----------------------------------------------------------
# plants <- taxify(c(
#   "Robinia pseudoacacia", "Ailanthus altissima",
#   "Impatiens glandulifera", "Quercus robur",
#   "Reynoutria japonica", "Solidago canadensis"
# ))
# 
# plants |> add_griis(country = "AT")
# #>            input_name invasive_status
# #> 1 Robinia pseudoacacia        invasive
# #> 2  Ailanthus altissima        invasive
# #> 3 Impatiens glandulifera      invasive
# #> 4        Quercus robur          native
# #> 5  Reynoutria japonica        invasive
# #> 6 Solidago canadensis        invasive

## ----invasive-multi-----------------------------------------------------------
# plants |> add_griis(country = c("AT", "DE", "GB"))
# #>            input_name invasive_status_AT invasive_status_DE invasive_status_GB
# #> 1 Robinia pseudoacacia         invasive           invasive           invasive
# #> 2  Ailanthus altissima         invasive           invasive         introduced
# #> 3 Impatiens glandulifera       invasive           invasive           invasive
# #> 4        Quercus robur           native             native             native
# #> 5  Reynoutria japonica         invasive           invasive           invasive
# #> 6 Solidago canadensis         invasive           invasive         introduced

## ----invasive-filter----------------------------------------------------------
# result <- plants |> add_griis(country = c("AT", "DE"))
# # Species invasive in Austria but not in Germany
# result[result$invasive_status_AT == "invasive" &
#        result$invasive_status_DE != "invasive", ]

## ----invasive-all-------------------------------------------------------------
# plants |> add_griis(country = "all")
# # Adds invasive_status_AD, invasive_status_AE, ..., invasive_status_ZW

## ----alien-fr-single----------------------------------------------------------
# aliens <- taxify(c(
#   "Robinia pseudoacacia", "Ailanthus altissima",
#   "Impatiens glandulifera", "Quercus robur",
#   "Ambrosia artemisiifolia", "Solidago canadensis"
# ))
# 
# aliens |> add_alien_first_records(country = "AT")
# #>              input_name alien_first_record alien_first_record_source alien_first_record_reference
# #> 1   Robinia pseudoacacia               1850                   NOBANIS                      NOBANIS
# #> 2    Ailanthus altissima               1870                   NOBANIS                      NOBANIS
# #> 3 Impatiens glandulifera               1900                   NOBANIS                      NOBANIS
# #> 4          Quercus robur                 NA                      <NA>                         <NA>
# #> 5 Ambrosia artemisiifolia              1863                   NOBANIS                      NOBANIS
# #> 6  Solidago canadensis                 1850                   NOBANIS                      NOBANIS

## ----alien-fr-multi-----------------------------------------------------------
# aliens |> add_alien_first_records(country = c("AT", "DE", "GB"))
# #>              input_name alien_first_record_AT alien_first_record_DE alien_first_record_GB ...
# #> 1   Robinia pseudoacacia                  1850                  1630                  1640 ...
# #> 2    Ailanthus altissima                  1870                  1780                  1751 ...
# #> 3 Impatiens glandulifera                  1900                  1839                  1855 ...

## ----alien-fr-long------------------------------------------------------------
# aliens |>
#   add_alien_first_records(country = c("AT", "DE", "GB")) |>
#   taxify_long()
# #>              input_name country_code alien_first_record alien_first_record_source ...
# #> 1   Robinia pseudoacacia           AT               1850                   NOBANIS ...
# #> 2    Ailanthus altissima           AT               1870                   NOBANIS ...
# #> ...
# #> 7   Robinia pseudoacacia           DE               1630              Long (2003) ...
# #> ...

## ----taxify-long-griis--------------------------------------------------------
# aliens |>
#   add_griis(country = c("AT", "DE")) |>
#   taxify_long()

## ----taxify-long-combined-----------------------------------------------------
# aliens |>
#   add_griis(country = c("AT", "DE")) |>
#   add_alien_first_records(country = c("AT", "DE", "CH")) |>
#   taxify_long()

## ----wcvp-single--------------------------------------------------------------
# trees <- taxify(c(
#   "Quercus robur", "Quercus suber", "Eucalyptus globulus",
#   "Nothofagus pumilio", "Sequoiadendron giganteum"
# ))
# 
# trees |> add_wcvp(region = "EUR")
# #>              input_name native_status
# #> 1          Quercus robur        native
# #> 2          Quercus suber        native
# #> 3    Eucalyptus globulus            NA
# #> 4    Nothofagus pumilio            NA
# #> 5 Sequoiadendron giganteum          NA

## ----wcvp-multi---------------------------------------------------------------
# trees |> add_wcvp(region = c("EUR", "AUS", "SAM"))
# #>              input_name native_status_EUR native_status_AUS native_status_SAM
# #> 1          Quercus robur           native                NA                NA
# #> 2          Quercus suber           native                NA                NA
# #> 3    Eucalyptus globulus               NA            native                NA
# #> 4    Nothofagus pumilio               NA                NA            native
# #> 5 Sequoiadendron giganteum              NA                NA                NA

## ----glonaf-------------------------------------------------------------------
# plants <- taxify(c(
#   "Robinia pseudoacacia", "Ailanthus altissima",
#   "Impatiens glandulifera", "Quercus robur"
# ))
# 
# plants |> add_glonaf(region = "EUR")
# #>              input_name naturalized
# #> 1   Robinia pseudoacacia           1
# #> 2    Ailanthus altissima           1
# #> 3 Impatiens glandulifera           1
# #> 4          Quercus robur          NA

## ----common-names-en----------------------------------------------------------
# species <- taxify(c(
#   "Quercus robur", "Parus major", "Vulpes vulpes",
#   "Bufo bufo", "Picea abies"
# ))
# 
# species |> add_common_names()
# #>     input_name common_name
# #> 1 Quercus robur   Pedunculate Oak
# #> 2   Parus major    Great Tit
# #> 3  Vulpes vulpes    Red Fox
# #> 4     Bufo bufo    Common Toad
# #> 5   Picea abies    Norway Spruce

## ----common-names-de----------------------------------------------------------
# species |> add_common_names(lang = "de")
# #>     input_name common_name
# #> 1 Quercus robur   Stieleiche
# #> 2   Parus major    Kohlmeise
# #> 3  Vulpes vulpes    Rotfuchs
# #> 4     Bufo bufo    Erdkroete
# #> 5   Picea abies    Gemeine Fichte

## ----stacking-plants----------------------------------------------------------
# library(taxify)
# 
# plant_result <- taxify(c(
#   "Quercus robur", "Fagus sylvatica", "Picea abies",
#   "Arrhenatherum elatius", "Festuca rubra", "Plantago lanceolata"
# )) |>
#   add_iucn() |>
#   add_zanne() |>
#   add_eive() |>
#   add_diaz_traits()

## ----stacking-birds-----------------------------------------------------------
# bird_result <- taxify(c(
#   "Parus major", "Cyanistes caeruleus", "Erithacus rubecula",
#   "Turdus merula", "Falco peregrinus"
# )) |>
#   add_iucn() |>
#   add_avonet() |>
#   add_elton_traits() |>
#   add_common_names()

## ----stacking-mammals---------------------------------------------------------
# mammal_result <- taxify(c(
#   "Vulpes vulpes", "Canis lupus", "Ursus arctos",
#   "Lutra lutra", "Lynx lynx"
# )) |>
#   add_iucn() |>
#   add_pantheria() |>
#   add_elton_traits() |>
#   add_common_names(lang = "de")

## ----stacking-fungi-----------------------------------------------------------
# fungal_result <- taxify(c(
#   "Amanita muscaria", "Boletus edulis", "Trametes versicolor"
# )) |>
#   add_iucn() |>
#   add_fungal_traits() |>
#   add_funguild()

## ----stacking-fish------------------------------------------------------------
# fish_result <- taxify(c(
#   "Salmo trutta", "Esox lucius", "Gadus morhua"
# )) |>
#   add_iucn() |>
#   add_fishmorph() |>
#   add_fishbase()

## ----coverage-example---------------------------------------------------------
# mixed <- taxify(c(
#   "Quercus robur",     # plant
#   "Parus major",       # bird
#   "Vulpes vulpes",     # mammal
#   "Bufo bufo",         # amphibian
#   "Amanita muscaria",  # fungus
#   "Salmo trutta"       # fish
# ))
# 
# mixed |>
#   add_zanne() |>
#   add_avonet() |>
#   add_pantheria() |>
#   add_amphibio() |>
#   add_fungal_traits() |>
#   add_fishbase()
# #>        input_name woodiness beak_length pantheria_body_mass_g body_size_mm primary_lifestyle fb_trophic_level ...
# #> 1   Quercus robur     woody          NA                    NA           NA              <NA>               NA ...
# #> 2     Parus major        NA        11.2                    NA           NA              <NA>               NA ...
# #> 3   Vulpes vulpes        NA          NA                5480.0           NA              <NA>               NA ...
# #> 4       Bufo bufo        NA          NA                    NA        150.0              <NA>               NA ...
# #> 5 Amanita muscaria       NA          NA                    NA           NA   ectomycorrhizal               NA ...
# #> 6    Salmo trutta        NA          NA                    NA           NA              <NA>              3.4 ...

## ----coverage-check-----------------------------------------------------------
# result <- taxify(species_list) |> add_zanne()
# # Fraction of matched species with woodiness data
# mean(!is.na(result$woodiness[!is.na(result$accepted_name)]))

## ----summary-enrichments------------------------------------------------------
# result <- taxify(c("Quercus robur", "Fagus sylvatica", "Pinus sylvestris")) |>
#   add_iucn() |>
#   add_zanne() |>
#   add_eive()
# 
# summary(result)
# #> -- taxify results --------------------------------------------------------
# #>   backbone: WFO v2024.12  |  3 names submitted
# #>
# #>   matched       3  (exact: 3, case-insensitive: 0, fuzzy: 0)
# #>   --------------------------------------------------------
# #>   taxon groups: plant: 3
# #>
# #>   enrichments:
# #>     iucn                 (IUCN Red List 2025.1)     -- 3 of 3 matched
# #>     zanne                (Zanne et al. 2014 1.0)    -- 3 of 3 matched
# #>     eive                 (EIVE 1.0 2023.1)          -- 3 of 3 matched

## ----guide-euro-plants--------------------------------------------------------
# result <- taxify(species_list, backbone = "wfo") |>
#   add_iucn() |>
#   add_zanne() |>
#   add_fungalroot() |>
#   add_eive() |>
#   add_diaz_traits() |>
#   add_leda() |>
#   add_wcvp(region = "EUR") |>
#   add_common_names()

## ----guide-global-plants------------------------------------------------------
# result <- taxify(species_list, backbone = "wfo") |>
#   add_iucn() |>
#   add_zanne() |>
#   add_fungalroot() |>
#   add_diaz_traits() |>
#   add_wcvp(region = c("NAM", "SAM", "AFR")) |>
#   add_common_names()

## ----guide-birds--------------------------------------------------------------
# result <- taxify(species_list, backbone = "col") |>
#   add_iucn() |>
#   add_avonet() |>
#   add_elton_traits() |>
#   add_common_names()

## ----guide-mammals------------------------------------------------------------
# result <- taxify(species_list, backbone = "col") |>
#   add_iucn() |>
#   add_pantheria() |>
#   add_elton_traits() |>
#   add_common_names()

## ----guide-amphibians---------------------------------------------------------
# result <- taxify(species_list, backbone = "col") |>
#   add_iucn() |>
#   add_amphibio() |>
#   add_common_names()

## ----guide-fish---------------------------------------------------------------
# result <- taxify(species_list, backbone = "worms") |>
#   add_iucn() |>
#   add_fishmorph() |>
#   add_fishbase() |>
#   add_common_names()

## ----guide-reptiles-----------------------------------------------------------
# result <- taxify(species_list, backbone = "reptiledb") |>
#   add_iucn() |>
#   add_repttraits() |>
#   add_common_names()

## ----guide-butterflies--------------------------------------------------------
# result <- taxify(species_list, backbone = "col") |>
#   add_iucn() |>
#   add_leptraits() |>
#   add_common_names()

## ----guide-arthropods---------------------------------------------------------
# result <- taxify(species_list, backbone = c("col", "gbif")) |>
#   add_iucn() |>
#   add_arthropod_traits() |>
#   add_animaltraits() |>
#   add_common_names()

## ----guide-fungi--------------------------------------------------------------
# result <- taxify(species_list, backbone = "col") |>
#   add_iucn() |>
#   add_fungal_traits() |>
#   add_funguild() |>
#   add_common_names()

## ----guide-algae--------------------------------------------------------------
# result <- taxify(species_list, backbone = "worms") |>
#   add_iucn() |>
#   add_algae_traits() |>
#   add_common_names()

## ----guide-mixed-all----------------------------------------------------------
# result <- taxify(species_list) |>
#   add_iucn() |>
#   add_zanne() |>
#   add_avonet() |>
#   add_pantheria() |>
#   add_amphibio() |>
#   add_elton_traits()

## ----guide-mixed-split--------------------------------------------------------
# result <- taxify(species_list)
# 
# plants  <- result[result$kingdom == "Plantae", ]
# birds   <- result[result$family %in% bird_families, ]
# mammals <- result[result$family %in% mammal_families, ]
# 
# plants  <- plants |> add_zanne() |> add_eive()
# birds   <- birds |> add_avonet() |> add_elton_traits()
# mammals <- mammals |> add_pantheria() |> add_elton_traits()

## ----add-data-csv-------------------------------------------------------------
# result <- taxify(c("Quercus robur", "Pinus sylvestris", "Fagus sylvatica"))
# 
# # From a CSV file (auto-detect species column)
# result |> add_data("my_traits.csv")

## ----add-data-df--------------------------------------------------------------
# # From a data.frame with explicit species column
# my_traits <- data.frame(
#   species = c("Quercus robur", "Pinus sylvestris", "Fagus sylvatica"),
#   bark_thickness_mm = c(25, 15, 8),
#   shade_tolerance = c(0.6, 0.3, 0.8)
# )
# result |> add_data(my_traits, species_col = "species")


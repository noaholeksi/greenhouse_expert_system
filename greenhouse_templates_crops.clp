(deftemplate crop
   (slot name)
   (slot min-temp)
   (slot max-temp)
   (slot min-humidity)
   (slot max-humidity)
   (slot soil-depth)
   (slot water-frequency)
   (slot days-to-maturity)
   (slot days-to-flowering)
   (slot nitrogen-demand) ;  low, medium or high
   (slot nitrogen-impact)  ; enriches, neutral or depletes
   (slot needs-pollination)  ; yes or no
   (slot spacing-cm) ; spacing between plants in cm
   (multislot companions) ;  list of compatible companion crops
)

(deftemplate section
   (slot id)
   (slot soil-depth)  
   (slot soil-nitrogen) ; low, medium or high
   (slot water-frequency (default 99)) ; 
   (multislot crops)  ; crop names or none
)


(deftemplate planting
   (slot id)
   (slot crop-name)
   (slot section-id)
   (slot planted-day) 
   (slot current-stage) ; growing, flowering or ready
   (slot harvested) ; yes or no 
   (slot pollinated)
)

(deftemplate greenhouse
   (slot temperature)
   (slot humidity)
)

(deftemplate companion-method
   (slot crop-a)
   (slot crop-b)
   (slot method)
)


(deftemplate id-counter
   (slot value)
)


(deftemplate current-day 
   (slot value)
)


(deffacts crops

  (crop (name spinach)
        (min-temp 10)   (max-temp 21)
        (min-humidity 40) (max-humidity 70)
        (soil-depth 30)
        (water-frequency 2)
        (days-to-maturity 45)
        (days-to-flowering 0)
        (nitrogen-demand high)
        (nitrogen-impact depletes)
        (needs-pollination no)
        (spacing-cm 15)
        (companions lettuce radishes peas onions carrots beets broccoli kale arugula eggplant))

  (crop (name lettuce)
        (min-temp 7)   (max-temp 24)
        (min-humidity 50) (max-humidity 70)
        (soil-depth 15)
        (water-frequency 2)
        (days-to-maturity 50)
        (days-to-flowering 0)
        (nitrogen-demand medium)
        (nitrogen-impact depletes)
        (needs-pollination no)
        (spacing-cm 20)
        (companions spinach radishes carrots onions beets peas broccoli arugula))

  (crop (name kale)
        (min-temp 4)   (max-temp 24)
        (min-humidity 40) (max-humidity 70)
        (soil-depth 30)
        (water-frequency 3)
        (days-to-maturity 60)
        (days-to-flowering 0)
        (nitrogen-demand high)
        (nitrogen-impact depletes)
        (needs-pollination no)
        (spacing-cm 45)
        (companions onions beets peas broccoli spinach))

  (crop (name cilantro)
        (min-temp 10)  (max-temp 27)
        (min-humidity 40) (max-humidity 60)
        (soil-depth 15)
        (water-frequency 2)
        (days-to-maturity 50)
        (days-to-flowering 0)
        (nitrogen-demand low)
        (nitrogen-impact neutral)
        (needs-pollination no)
        (spacing-cm 15)
        (companions tomatoes peppers carrots broccoli))

  (crop (name broccoli)
        (min-temp 7)   (max-temp 24)
        (min-humidity 45) (max-humidity 75)
        (soil-depth 30)
        (water-frequency 3)
        (days-to-maturity 90)
        (days-to-flowering 0)
        (nitrogen-demand high)
        (nitrogen-impact depletes)
        (needs-pollination no)
        (spacing-cm 45)
        (companions spinach lettuce onions beets kale cilantro chard peas))

  (crop (name arugula)
        (min-temp 4)   (max-temp 24)
        (min-humidity 40) (max-humidity 70)
        (soil-depth 15)
        (water-frequency 2)
        (days-to-maturity 40)
        (days-to-flowering 0)
        (nitrogen-demand medium)
        (nitrogen-impact depletes)
        (needs-pollination no)
        (spacing-cm 15)
        (companions radishes lettuce spinach onions tomatoes))

  (crop (name radishes)
        (min-temp 7)   (max-temp 24)
        (min-humidity 40) (max-humidity 70)
        (soil-depth 15)
        (water-frequency 2)
        (days-to-maturity 25)
        (days-to-flowering 0)
        (nitrogen-demand low)
        (nitrogen-impact neutral)
        (needs-pollination no)
        (spacing-cm 5)
        (companions spinach lettuce arugula carrots beets tomatoes peas zucchini))

  (crop (name tomatoes)
        (min-temp 18)  (max-temp 29)
        (min-humidity 50) (max-humidity 80)
        (soil-depth 45)
        (water-frequency 3)
        (days-to-maturity 70)
        (days-to-flowering 50)
        (nitrogen-demand medium)
        (nitrogen-impact depletes)
        (needs-pollination yes)
        (spacing-cm 60)
        (companions basil onions carrots peppers arugula cilantro radishes))

  (crop (name peppers)
        (min-temp 21)  (max-temp 32)
        (min-humidity 50) (max-humidity 70)
        (soil-depth 30)
        (water-frequency 3)
        (days-to-maturity 80)
        (days-to-flowering 65)
        (nitrogen-demand medium)
        (nitrogen-impact depletes)
        (needs-pollination yes)
        (spacing-cm 45)
        (companions tomatoes basil onions carrots cilantro eggplant))

  (crop (name basil)
        (min-temp 18)  (max-temp 30)
        (min-humidity 40) (max-humidity 60)
        (soil-depth 20)
        (water-frequency 2)
        (days-to-maturity 70)
        (days-to-flowering 0)
        (nitrogen-demand medium)
        (nitrogen-impact neutral)
        (needs-pollination no)
        (spacing-cm 30)
        (companions tomatoes peppers eggplant))

  (crop (name eggplant)
        (min-temp 21)  (max-temp 32)
        (min-humidity 50) (max-humidity 70)
        (soil-depth 30)
        (water-frequency 3)
        (days-to-maturity 75)
        (days-to-flowering 65)
        (nitrogen-demand medium)
        (nitrogen-impact depletes)
        (needs-pollination yes)
        (spacing-cm 45)
        (companions beans peppers basil spinach))

  (crop (name beans)
        (min-temp 16)  (max-temp 29)
        (min-humidity 40) (max-humidity 60)
        (soil-depth 20)
        (water-frequency 3)
        (days-to-maturity 55)
        (days-to-flowering 0)
        (nitrogen-demand low)
        (nitrogen-impact enriches)
        (needs-pollination no)
        (spacing-cm 10)
        (companions carrots eggplant beets peas zucchini radishes chard))

  (crop (name chard)
        (min-temp 10)  (max-temp 29)
        (min-humidity 40) (max-humidity 70)
        (soil-depth 20)
        (water-frequency 3)
        (days-to-maturity 55)
        (days-to-flowering 0)
        (nitrogen-demand medium)
        (nitrogen-impact depletes)
        (needs-pollination no)
        (spacing-cm 30)
        (companions onions beets carrots broccoli beans radishes))

  (crop (name zucchini)
        (min-temp 18)  (max-temp 32)
        (min-humidity 50) (max-humidity 70)
        (soil-depth 30)
        (water-frequency 3)
        (days-to-maturity 55)
        (days-to-flowering 40)
        (nitrogen-demand high)
        (nitrogen-impact depletes)
        (needs-pollination yes)
        (spacing-cm 90)
        (companions beans peas radishes onions carrots))

  (crop (name beets)
        (min-temp 7)   (max-temp 24)
        (min-humidity 40) (max-humidity 70)
        (soil-depth 30)
        (water-frequency 3)
        (days-to-maturity 60)
        (days-to-flowering 0)
        (nitrogen-demand low)
        (nitrogen-impact neutral)
        (needs-pollination no)
        (spacing-cm 10)
        (companions onions lettuce spinach kale carrots chard broccoli radishes beans))

  (crop (name carrots)
        (min-temp 7)   (max-temp 24)
        (min-humidity 40) (max-humidity 70)
        (soil-depth 30)
        (water-frequency 3)
        (days-to-maturity 75)
        (days-to-flowering 0)
        (nitrogen-demand low)
        (nitrogen-impact neutral)
        (needs-pollination no)
        (spacing-cm 5)
        (companions onions lettuce radishes tomatoes peas cilantro peppers beets chard zucchini))

  (crop (name onions)
        (min-temp 13)  (max-temp 24)
        (min-humidity 40) (max-humidity 60)
        (soil-depth 20)
        (water-frequency 4)
        (days-to-maturity 100)
        (days-to-flowering 0)
        (nitrogen-demand medium)
        (nitrogen-impact neutral)
        (needs-pollination no)
        (spacing-cm 10)
        (companions tomatoes carrots beets lettuce spinach kale peppers chard zucchini arugula broccoli))

  (crop (name peas)
        (min-temp 7)   (max-temp 24)
        (min-humidity 40) (max-humidity 70)
        (soil-depth 20)
        (water-frequency 3)
        (days-to-maturity 65)
        (days-to-flowering 0)
        (nitrogen-demand low)
        (nitrogen-impact enriches)
        (needs-pollination no)
        (spacing-cm 10)
        (companions carrots radishes spinach lettuce beans beets zucchini broccoli kale))

)

(deffacts companion-methods

  ;; --- SPINACH pairs ---
  (companion-method (crop-a spinach) (crop-b lettuce)
    (method "Interplant in same bed; both shallow-rooted cool-season crops share moisture needs and create dense canopy that suppresses weeds."))

  (companion-method (crop-a spinach) (crop-b radishes)
    (method "Plant radishes at row edges as a border; radishes deter leaf miners and their quick harvest opens space as spinach expands."))

  (companion-method (crop-a spinach) (crop-b peas)
    (method "Peas fix nitrogen enriching the soil for spinach; peas provide partial shade that slows spinach bolting in warm spells."))

  (companion-method (crop-a spinach) (crop-b onions)
    (method "Interplant in alternating short rows; onions repel aphids and leaf miners that commonly attack spinach."))

  (companion-method (crop-a spinach) (crop-b carrots)
    (method "Shallow spinach roots and deep carrot roots occupy different soil layers avoiding competition; spinach shades soil retaining moisture for carrots."))

  (companion-method (crop-a spinach) (crop-b beets)
    (method "Spinach fills the above-ground space between beet plants while beets develop their roots underground; complementary canopy heights maximize bed use."))

  (companion-method (crop-a spinach) (crop-b broccoli)
    (method "Spinach planted as a living ground cover under broccoli canopy; different canopy levels maximize light use and spinach retains soil moisture."))

  (companion-method (crop-a spinach) (crop-b kale)
    (method "Interplant as cool-season companions; taller kale provides slight wind protection for spinach and the two crops can be harvested successively."))

  (companion-method (crop-a spinach) (crop-b arugula)
    (method "Interplant cool-season greens for successive harvest; diversity of leaf types makes efficient use of bed space."))

  (companion-method (crop-a spinach) (crop-b eggplant)
    (method "Spinach planted as a living mulch under the eggplant canopy; retains soil moisture and suppresses weeds around eggplant root zone."))

  ;; --- LETTUCE pairs (new) ---
  (companion-method (crop-a lettuce) (crop-b arugula)
    (method "Interplant cool-season greens; succession plant for continuous harvest and the mixed canopy deters flea beetles more effectively than monoculture."))

  (companion-method (crop-a lettuce) (crop-b radishes)
    (method "Radishes act as a trap crop for leaf miners protecting lettuce; plant radishes as a border around lettuce beds."))

  (companion-method (crop-a lettuce) (crop-b carrots)
    (method "Lettuce shades soil around young carrot seedlings retaining moisture; different root depths prevent competition for nutrients."))

  (companion-method (crop-a lettuce) (crop-b onions)
    (method "Onions repel aphids near lettuce; shallow lettuce roots complement deeper onion bulbs allowing interplanting in the same row."))

  (companion-method (crop-a lettuce) (crop-b beets)
    (method "Lettuce fills above-ground space between beet rows; complementary root depths allow both crops to share a bed without competition."))

  (companion-method (crop-a lettuce) (crop-b peas)
    (method "Peas fix nitrogen for lettuce and provide light shade protecting lettuce from bolting in warm weather; plant peas on trellises above lettuce rows."))

  (companion-method (crop-a lettuce) (crop-b broccoli)
    (method "Lettuce used as a living ground cover under broccoli; maximizes bed space and shades soil to reduce moisture loss."))

  ;; --- KALE pairs (new) ---
  (companion-method (crop-a kale) (crop-b onions)
    (method "Plant onions as a border around kale rows; onion scent deters cabbage worms, aphids, and flea beetles that commonly attack kale."))

  (companion-method (crop-a kale) (crop-b beets)
    (method "Plant in alternating rows; beets have a different root depth than kale and may deter some brassica pests via aromatic compounds."))

  (companion-method (crop-a kale) (crop-b peas)
    (method "Peas fix nitrogen enriching the soil for heavy-feeding kale; plant in alternating rows with peas trellised so they do not shade kale."))

  (companion-method (crop-a kale) (crop-b broccoli)
    (method "Both brassicas with similar care schedules; plant in blocks and surround the entire block with onion borders for shared pest management."))

  ;; --- CILANTRO pairs (new) ---
  (companion-method (crop-a cilantro) (crop-b tomatoes)
    (method "Cilantro planted nearby attracts beneficial parasitic wasps and predatory insects that control tomato pests including aphids and tomato hornworm larvae."))

  (companion-method (crop-a cilantro) (crop-b peppers)
    (method "Cilantro flowers attract beneficial predatory insects that prey on aphids and spider mites commonly found on peppers."))

  (companion-method (crop-a cilantro) (crop-b carrots)
    (method "Both are in the Apiaceae family; cilantro attracts parasitic wasps that control carrot pests; plant cilantro at row ends or as a border."))

  (companion-method (crop-a cilantro) (crop-b broccoli)
    (method "Cilantro flowers attract beneficial insects including parasitic wasps that prey on brassica pests such as cabbage worms and aphids."))

  ;; --- BROCCOLI pairs (new) ---
  (companion-method (crop-a broccoli) (crop-b chard)
    (method "Plant in alternating rows; different canopy heights reduce light competition and crop diversity complicates pest establishment."))

  (companion-method (crop-a broccoli) (crop-b onions)
    (method "Onions planted at broccoli row edges repel aphids and cabbage loopers from broccoli; strong allium scent disrupts pest orientation."))

  (companion-method (crop-a broccoli) (crop-b beets)
    (method "Beets planted between broccoli rows have complementary root depths; beets reportedly deter some brassica pests via their scent."))

  (companion-method (crop-a broccoli) (crop-b peas)
    (method "Peas fix nitrogen enriching the soil for heavy-feeding broccoli; plant in alternating rows with peas trellised to avoid shading broccoli."))

  ;; --- ARUGULA pairs (new) ---
  (companion-method (crop-a arugula) (crop-b radishes)
    (method "Radishes act as a trap crop for flea beetles that would otherwise attack arugula; plant radishes as a sacrificial border around arugula."))

  (companion-method (crop-a arugula) (crop-b tomatoes)
    (method "Arugula planted as a living ground cover under tomatoes suppresses weeds and retains soil moisture; tomato canopy provides some afternoon shade."))

  (companion-method (crop-a arugula) (crop-b onions)
    (method "Onions repel flea beetles that attack arugula; plant onions as a border around the arugula bed or interplant in alternating short rows."))

  ;; --- RADISHES pairs (new) ---
  (companion-method (crop-a radishes) (crop-b carrots)
    (method "Plant radishes between carrot rows; radishes loosen compacted soil aiding carrot root development and mark rows while carrots are germinating; radishes are harvested before carrots need the full space."))

  (companion-method (crop-a radishes) (crop-b beets)
    (method "Plant in alternating rows; radishes loosen topsoil benefiting beet root expansion and both crops mature at different depths."))

  (companion-method (crop-a radishes) (crop-b tomatoes)
    (method "Radishes planted at tomato row edges act as a trap crop for flea beetles and cucumber beetles and may deter aphids near tomato stems."))

  (companion-method (crop-a radishes) (crop-b zucchini)
    (method "Plant radishes at the base of zucchini mounds; radishes deter cucumber beetles which are a major pest of zucchini and other cucurbits."))

  (companion-method (crop-a radishes) (crop-b peas)
    (method "Radishes planted at edges of pea rows deter aphids; radishes germinate and mature quickly before pea vines shade them out."))

  ;; --- TOMATOES pairs (new) ---
  (companion-method (crop-a tomatoes) (crop-b basil)
    (method "Plant basil at the base of tomato plants; basil repels aphids, whiteflies, and thrips via aromatic volatile oils and may improve overall tomato vigor."))

  (companion-method (crop-a tomatoes) (crop-b onions)
    (method "Plant onions at tomato row edges; allium compounds repel aphids and thrips that commonly colonize tomato foliage."))

  (companion-method (crop-a tomatoes) (crop-b carrots)
    (method "Carrots loosen compacted soil around the tomato root zone; tomato canopy provides afternoon shade that keeps carrots cooler and extends their season."))

  (companion-method (crop-a tomatoes) (crop-b peppers)
    (method "Both warm-season solanums with identical watering and fertilizing schedules; interplant in rows to maximize space efficiency in a warm bed."))

  ;; --- PEPPERS pairs (new) ---
  (companion-method (crop-a peppers) (crop-b basil)
    (method "Plant basil at the base of pepper plants; basil volatile oils repel aphids and spider mites which are common pepper pests."))

  (companion-method (crop-a peppers) (crop-b onions)
    (method "Plant onions as a border around peppers; allium scent deters aphids and thrips from settling on pepper foliage."))

  (companion-method (crop-a peppers) (crop-b carrots)
    (method "Carrots loosen soil near pepper roots; complementary root depths allow interplanting without competition; pepper canopy shades carrot crowns."))

  (companion-method (crop-a peppers) (crop-b eggplant)
    (method "Both warm-season solanums with similar water, heat, and nutrient requirements; interplant in shared beds for efficient use of warm garden space."))

  ;; --- BASIL pairs (new) ---
  (companion-method (crop-a basil) (crop-b eggplant)
    (method "Plant basil near eggplant; basil volatile oils repel flea beetles and aphids which are the most common and damaging pests of eggplant."))

  ;; --- EGGPLANT pairs (new) ---
  (companion-method (crop-a eggplant) (crop-b beans)
    (method "Beans fix atmospheric nitrogen enriching the soil for nitrogen-hungry eggplant; plant in alternating rows within the same warm bed."))

  ;; --- BEANS pairs (new) ---
  (companion-method (crop-a beans) (crop-b carrots)
    (method "Beans fix nitrogen that benefits carrots; plant in alternating short rows so bean foliage does not shade young carrot seedlings."))

  (companion-method (crop-a beans) (crop-b beets)
    (method "Beans fix nitrogen for beets; beets add minerals to the soil through their deep roots; interplant in alternating rows for mutual benefit."))

  (companion-method (crop-a beans) (crop-b peas)
    (method "Both nitrogen-fixing legumes; interplant in alternating rows to maximize nitrogen fixation across different soil zones; avoid overcrowding to ensure airflow."))

  (companion-method (crop-a beans) (crop-b zucchini)
    (method "Beans fix nitrogen for heavy-feeding zucchini; plant beans around the base of zucchini mounds in a variation of the three-sisters planting scheme."))

  (companion-method (crop-a beans) (crop-b radishes)
    (method "Plant radishes at the edges of bean rows; radishes deter bean beetles and the combination improves overall pest disruption in the bed."))

  (companion-method (crop-a beans) (crop-b chard)
    (method "Beans fix nitrogen enriching soil for chard; interplant in alternating rows so beans can be trellised without shading the chard bed."))

  ;; --- CHARD pairs (new) ---
  (companion-method (crop-a chard) (crop-b beets)
    (method "Both are chenopods with similar soil and moisture needs; interplant for complementary harvest timing and efficient use of bed space."))

  (companion-method (crop-a chard) (crop-b carrots)
    (method "Chard and carrots have complementary root depths preventing nutrient competition; interplant in the same bed for efficient use of vertical and horizontal space."))

  (companion-method (crop-a chard) (crop-b onions)
    (method "Plant onions as a border around chard rows; allium scent deters leaf miners which are the primary pest of chard foliage."))

  (companion-method (crop-a chard) (crop-b radishes)
    (method "Radishes planted between chard plants loosen the topsoil around chard root zone and their quick harvest frees space as chard matures."))

  ;; --- ZUCCHINI pairs (new) ---
  (companion-method (crop-a zucchini) (crop-b onions)
    (method "Plant onions around the base of zucchini mounds; allium scent deters squash bugs and aphids which are major zucchini pests."))

  (companion-method (crop-a zucchini) (crop-b peas)
    (method "Peas fix nitrogen enriching soil for heavy-feeding zucchini; plant peas on a short trellis at the north edge of zucchini mounds to avoid shading."))

  (companion-method (crop-a zucchini) (crop-b carrots)
    (method "Plant carrots between zucchini mounds; zucchini canopy provides shade that keeps carrots cooler and moist during summer heat."))

  ;; --- BEETS pairs (new) ---
  (companion-method (crop-a beets) (crop-b onions)
    (method "Plant onions as a border around beet beds; allium compounds deter beet leaf miners and aphids that attack beet foliage."))

  (companion-method (crop-a beets) (crop-b carrots)
    (method "Both root crops can be interplanted in alternating rows; different root morphology means they occupy slightly different soil zones reducing competition."))

  ;; --- CARROTS pairs (new) ---
  (companion-method (crop-a carrots) (crop-b onions)
    (method "Classic companion pair; onion scent repels carrot fly and carrot scent repels onion fly; interplant in alternating rows for mutual pest deterrence."))

  (companion-method (crop-a carrots) (crop-b peas)
    (method "Peas fix nitrogen enriching soil for carrots; plant carrots in rows with peas trellised above; pea canopy provides light afternoon shade beneficial to carrots."))

)
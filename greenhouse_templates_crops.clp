(defmodule CROP-INFO-BASIC
    (export deftemplate
        crop
        section
        planting
        companion-method)

    (export deffacts 
        crops 
        companion-methods)
)

(defmodule DISEASE
    (export deftemplate 
        symptom
        diagnosis)
)

(defmodule environment
    (export deftemplate
        greenhouse
        current-day
        id-counter)
)

(defmodule fuzzy-environment 
    (export deftemplate 
        temp-excess
        temp-deficit
        humidity-excess
        humidity-deficit
        care-urgency
        stress-level))



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
        (nitrogen-demand medium)
        (nitrogen-impact depletes)
        (needs-pollination no)
        (spacing-cm 30)
        (companions lettuce radishes peas onions carrots))

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
        (companions spinach lettuce carrots tomatoes peas zucchini))

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
        (companions basil onions carrots peppers radishes))

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
        (spacing-cm 30)
        (companions tomatoes basil onions carrots))

  (crop (name basil)
        (min-temp 18)  (max-temp 30)
        (min-humidity 40) (max-humidity 60)
        (soil-depth 20)
        (water-frequency 2)
        (days-to-maturity 70)
        (days-to-flowering 0)
        (nitrogen-demand low)
        (nitrogen-impact neutral)
        (needs-pollination no)
        (spacing-cm 15)
        (companions tomatoes peppers))

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
        (companions carrots peas zucchini radishes))

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
        (spacing-cm 45)
        (companions beans peas radishes onions carrots))

(crop (name lettuce)
        (min-temp 7)   (max-temp 24)
        (min-humidity 50) (max-humidity 70)
        (soil-depth 15)
        (water-frequency 2)
        (days-to-maturity 50)
        (days-to-flowering 0)
        (nitrogen-demand high)
        (nitrogen-impact depletes)
        (needs-pollination no)
        (spacing-cm 20)
        (companions spinach radishes carrots onions peas))

  (crop (name carrots)
        (min-temp 7)   (max-temp 24)
        (min-humidity 40) (max-humidity 70)
        (soil-depth 30)
        (water-frequency 3)
        (days-to-maturity 75)
        (days-to-flowering 0)
        (nitrogen-demand medium)
        (nitrogen-impact neutral)
        (needs-pollination no)
        (spacing-cm 5)
        (companions onions lettuce radishes tomatoes peas peppers zucchini))

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
        (companions tomatoes carrots lettuce spinach peppers zucchini))

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
        (companions carrots radishes spinach lettuce beans zucchini))

)

(deffacts companion-methods

(companion-method (crop-a spinach) (crop-b lettuce)
    (method "Plant in alternating rows ."))

(companion-method (crop-a spinach) (crop-b radishes)
    (method "Plant radishes at row edges as a border."))

(companion-method (crop-a spinach) (crop-b peas)
    (method "Interplant in alternating short rows"))

(companion-method (crop-a spinach) (crop-b onions)
    (method "Interplant in alternating short rows"))

(companion-method (crop-a spinach) (crop-b carrots)
    (method "Plant in rows, close together"))

(companion-method (crop-a lettuce) (crop-b radishes)
    (method "Plant radishes as a border around lettuce beds"))


(companion-method (crop-a lettuce) (crop-b carrots)
    (method "Alternate in the same rows"))

(companion-method (crop-a lettuce) (crop-b onions)
    (method "Alternate in the same rows"))

(companion-method (crop-a lettuce) (crop-b peas)
    (method "Plant in alternating rows."))

(companion-method (crop-a radishes) (crop-b carrots)
    (method "Plant radishes between carrot rows."))

(companion-method (crop-a radishes) (crop-b tomatoes)
    (method "Radishes planted at tomato row edges "))

(companion-method (crop-a radishes) (crop-b zucchini)
    (method "Plant radishes at the base of zucchini mounds"))

(companion-method (crop-a radishes) (crop-b peas)
    (method "Radishes planted at edges of pea rows"))

(companion-method (crop-a tomatoes) (crop-b basil)
    (method "Plant basil near tomato plantings"))

(companion-method (crop-a tomatoes) (crop-b onions)
    (method "Plant onions at tomato row edges"))

(companion-method (crop-a tomatoes) (crop-b carrots)
    (method "Plant in alternating rows "))

(companion-method (crop-a tomatoes) (crop-b peppers)
    (method "Plant in alternating rows "))

(companion-method (crop-a peppers) (crop-b basil)
    (method "Plant in alternating rows"))

(companion-method (crop-a peppers) (crop-b onions)
    (method "Plant onions as a border around peppers"))

(companion-method (crop-a peppers) (crop-b carrots)
    (method "Plant in alternating rows"))

(companion-method (crop-a beans) (crop-b carrots)
    (method "Plant in alternating rows"))

(companion-method (crop-a beans) (crop-b peas)
    (method "Plant in alternating rows"))

(companion-method (crop-a beans) (crop-b zucchini)
    (method "Plant beans around the base of zucchini mounds"))

(companion-method (crop-a beans) (crop-b radishes)
    (method "Plant radishes at the edges of bean rows"))

(companion-method (crop-a zucchini) (crop-b onions)
    (method "Plant onions around the base of zucchini mounds"))

(companion-method (crop-a zucchini) (crop-b peas)
    (method "Plant in alternating rows. Zucchini might block sun to peas."))

(companion-method (crop-a zucchini) (crop-b carrots)
    (method "Plant in alternating rows"))

(companion-method (crop-a carrots) (crop-b onions)
    (method "Plant in alternating rows"))

(companion-method (crop-a carrots) (crop-b peas)
    (method "Plant in alternating rows."))

)


; fuzzy stuff
(deftemplate temp-excess
  0 20 degrees
  ((low    (z 1 4))
   (mild   (pi 3 5))
   (severe (s 7 14))))

(deftemplate temp-deficit
  0 15 degrees
  ((low    (z 1 4))
   (mild   (pi 3 5))
   (severe (s 7 12))))

(deftemplate humidity-excess
  0 30 percent-pts
  ((low       (z 1 8))
   (elevated  (pi 5 11))
   (saturated (s 14 24))))

(deftemplate humidity-deficit
  0 40 percent-pts
  ((low     (z 1 11))
   (dry     (pi 5 14))
   (severe  (s 17 32))))

(deftemplate care-urgency
  0 10 urgency-level
  ((low    (z 1 4))
   (medium (pi 2 5))
   (high   (s 6 9))))


(deftemplate stress-level
  (slot type  (default none))   ; heat, cold ,humid-high, humid-low
  (slot level (default low)))   ; low, medium, high
;;

(deftemplate symptom
   (slot planting-id)
   (slot name)
   (slot cf))

(deftemplate diagnosis
   (slot planting-id)
   (slot name)
   (slot cf))

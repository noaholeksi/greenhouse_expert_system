
(defmodule CF-DISEASE-RULES
    (import DISEASE deftemplate
      symptom 
      diagnosis)

    (import CROP-INFO-BASIC deftemplate
      planting)

    (export defrule
      diagnose-powdery-mildew
      diagnose-bacterial-leaf-spot
      diagnose-early-blight
      diagnose-bacterial-wilt
      diagnose-bacterial-blight
      diagnose-mosaic-virus
      diagnose-white-rot
      diagnose-fungal-leaf-spot
      diagnose-fruit-rot
      diagnose-general-stress
)
)

(defmodule FUZZY-STRESS-RULES
      (import CROP-INFO-BASIC deftemplate
        crop planting)

  (import environment deftemplate
    greenhouse)

  (import fuzzy-environment deftemplate
    temp-excess temp-deficit
    humidity-excess humidity-deficit
    stress-level care-urgency)


      (export defrule
        compute-temp-excess
        compute-temp-deficit
        compute-humidity-excess
        compute-humidity-deficit
        fuzzy-severe-heat
        fuzzy-mild-heat
        fuzzy-low-heat
        fuzzy-severe-cold
        fuzzy-mild-cold
        fuzzy-low-cold
        fuzzy-saturated-humidity
        fuzzy-elevated-humidity
        fuzzy-low-humidity-excess
        fuzzy-severe-dry-conditions
        fuzzy-dry-conditions
        fuzzy-low-humidity-deficit
        report-care-urgency)
)

(defmodule BASE-Rules
     (import CROP-INFO-BASIC deftemplate
    crop section planting companion-method)

  (import environment deftemplate
    greenhouse current-day id-counter)
    (export defrule
      warn-soil-depth-insufficient
      suggest-companion-planting
      recommend-watering
      update-section-water-frequency-down
      reset-water-frequency-for-recalc
      recommend-fertilize-low-nitrogen
      update-stage-to-flowering
      remind-hand-pollination
      update-stage-to-ready
      urgent-harvest-warning
      process-harvest-update-soil
      no-compatible-crops-warning
      list-all-crop-ranges-when-incompatible
      recommend-compatible-crop-for-empty-section
      create-new-planting
      update-section-soil-depth
      update-section-soil-nitrogen
      debug-print-all-plantings
      process-harvest-request

    )
)



(defrule warn-soil-depth-insufficient
	(planting (crop-name ?crop) (section-id ?section) (harvested no))
	(section (id ?section) (soil-depth ?sDepth))
	(crop (name ?crop) (soil-depth ?cDepth))
	(test (< ?sDepth ?cDepth))
	=>
	(printout t "SOIL WARNING: " ?crop " in section " ?section " needs " 
        ?cDepth "cm depth but section only has " ?sDepth "cm" crlf)
	(printout t "	Recommended action: transplant to a deeper section" crlf))

;rule 8

(defrule suggest-companion-planting
	(planting (crop-name ?primary) (section-id ?section) (harvested no))
	(not (and (planting (crop-name ?other) (section-id ?section) (harvested no)) (test (neq ?other ?primary))))
	(crop (name ?primary) (companions $? ?companion $?))
	(test (neq ?companion none))
	(or (companion-method (crop-a ?primary) (crop-b ?companion) (method ?method))
		(companion-method (crop-b ?primary) (crop-a ?companion) (method ?method)))
	=>
	(printout t "Companion Suggestion: In section " ?section ", " ?primary " is alone" crlf)
	(printout t "	Consider planting " ?companion " as a companion" crlf)
	(printout t "	How to plant: " ?method crlf))

; rule 9
(defrule recommend-watering
    (section (id ?section) (water-frequency ?freq))
    (test (< ?freq 99))
    (current-day (value ?today))
    (test (= (mod ?today ?freq) 0))
	=>
    (printout t "WATER: Water section " ?section " today (every " ?freq " days)" crlf)
    (printout t "	Water thoroughly until soil feels evenly damp throughout" crlf))

(defrule update-section-water-frequency-down
    ?sect <- (section (id ?section) (water-frequency ?sFreq))
    (planting (crop-name ?crop) (section-id ?section) (harvested no))
    (crop (name ?crop) (water-frequency ?cFreq))
    (test (< ?cFreq ?sFreq))
	=>
    (modify ?sect (water-frequency ?cFreq)))

(defrule reset-water-frequency-for-recalc
    ?flag <- (recalc-water-freq ?section)
    ?sect <- (section (id ?section))
	=>
    (modify ?sect (water-frequency 99))

    (retract ?flag))


;rule 10

(defrule recommend-fertilize-low-nitrogen
	(section (id ?section) (soil-nitrogen low))
	(planting (crop-name ?crop) (section-id ?section) (harvested no))
	(crop (name ?crop) (nitrogen-demand ?demand))
	(test (or (eq ?demand medium) (eq ?demand high)))
	=>
	(printout t "RECOMMEND FERTILIZATION: section " ?section " has LOW soil nitrogen" crlf)
	(printout t "	" ?crop " has " ?demand " nitrogen demand" crlf)
	(printout t "	Recommended action: apply fertilizer then update soil-nitrogen" crlf))


;rule 11

(defrule update-stage-to-flowering
	?planting <- (planting (id ?pid) (crop-name ?crop) (section-id ?section)
	(planted-day ?planted) (current-stage growing)
    (harvested no))
	(crop (name ?crop) (days-to-flowering ?dtf))
	(test (> ?dtf 0))
	(current-day (value ?today))
	(test (>= (- ?today ?planted) ?dtf))
	=>
	(modify ?planting (current-stage flowering))
	(printout t "PLANT GROWTH UPDATE: " ?crop " in section " ?section " has entered the FLOWERING stage" crlf)
	(printout t "  Recommended action: check for flowers and hand pollinate" crlf))

; rule 12

(defrule remind-hand-pollination
	(planting (crop-name ?crop) (section-id ?section)
	(current-stage flowering) (pollinated no) (harvested no))
	(crop (name ?crop) (needs-pollination yes))

	=>
	(printout t "POLLINATION REMINDER: " ?crop " in section " ?section " is still waiting for hand pollination" crlf)
	(printout t "Shake flowering stems or brush pollen between flowers" crlf)
	(printout t "When done update: (modify planting pollinated yes)" crlf))

; rule 13

(defrule update-stage-to-ready
	?planting <- (planting (id ?pid) (crop-name ?crop) (section-id ?section)
		(planted-day ?planted) (current-stage ?stage) (harvested no))
	(test (neq ?stage ready))
	(crop (name ?crop) (days-to-maturity ?dtm))
	(test (> ?dtm 0))
	(current-day (value ?today))
	(test (>= (- ?today ?planted) ?dtm))
	=>
	(modify ?planting (current-stage ready))

	(printout t "HARVEST ALERT: " ?crop " in section " ?section " has reached maturity" crlf)
	(printout t "	Planting ID: " ?pid " --- Days since plated: " (- ?today ?planted) crlf)
	(printout t "	Inspect plant and harvest if ready" crlf))

; rule 14
(defrule urgent-harvest-warning
	(planting (crop-name ?crop) (section-id ?section) (planted-day ?planted) (harvested no))
	(crop (name ?crop) (days-to-maturity ?dtm))
	(test (> ?dtm 0))
	(current-day (value ?today))
	(test (>= (- ?today ?planted) (+ ?dtm 15)))

	=>
	(printout t "URGENT HARVEST ALERT: " ?crop " in section " ?section " is overdue by " (- (- ?today ?planted) ?dtm) " days" crlf)
	(printout t "Risk of loss of crop. Harvest immediately!!!" crlf))

; rule 15

(defrule process-harvest-update-soil
	?planting <- (planting (id ?pid) (crop-name ?crop) (section-id ?section) (harvested yes))
	(crop (name ?crop) (nitrogen-impact ?impact))
	?sect <- (section (id ?section) (soil-nitrogen ?currentN) (crops $?before ?crop $?after))
	=>
	(bind ?newN
		(if (and (eq ?impact depletes) (eq ?currentN high))   then medium
		(if (and (eq ?impact depletes) (eq ?currentN medium)) then low
		(if (and (eq ?impact enriches) (eq ?currentN low))    then medium
		(if (and (eq ?impact enriches) (eq ?currentN medium)) then high
		else ?currentN)))))wro

	(modify ?sect (soil-nitrogen ?newN) (crops (delete-member$ (create$ $?before ?crop $?after) ?crop)))
	(retract ?planting)
	(assert (recalc-water-freq ?section))

	(printout t "HARVEST PROCESSED: " ?crop " was removed from section " ?section crlf)
	(printout t "	Soil nitrogen level: " ?currentN " -> " ?newN crlf))

; rule 16

(defrule no-compatible-crops-warning
	(declare (salience 100))

	(exists (section (crops none)))
	(greenhouse (temperature ?temp) (humidity ?hum))

	(not (and (crop (min-temp ?minT) (max-temp ?maxT))
		(test (>= ?temp ?minT))
		(test (<= ?temp ?maxT))))
	=>
	(printout t "NO COMPATIBLE CROPS: greenhouse conditions are outside" crlf)
	(printout t "	all crop ranges. Current: " ?temp "C, " ?hum "% humidity" crlf)
	(printout t "	Adjust greenhouse conditions or review crop ranges below:" crlf))


; rule 17

(defrule list-all-crop-ranges-when-incompatible
	(declare (salience 99))
	(exists (section (crops none)))
	(greenhouse (temperature ?temp))
	(not (and (crop (min-temp ?minT) (max-temp ?maxT))
	(test (>= ?temp ?minT))
	(test (<= ?temp ?maxT))))
	(crop (name ?crop) (min-temp ?minT) (max-temp ?maxT) (min-humidity ?minH) (max-humidity ?maxH))
	=>
	(printout t "  "  ?crop ": temp " ?minT "-" ?maxT "C, humidity " ?minH "-" ?maxH "%" crlf))


; rule 19

(defrule recommend-compatible-crop-for-empty-section
	(section (id ?section) (crops none) (soil-depth ?sDepth) (soil-nitrogen ?n))
	(test (neq ?n low))
	(crop (name ?crop) (min-temp ?minT) (max-temp ?maxT) (soil-depth ?cDepth) (spacing-cm ?spacing))
	(greenhouse (temperature ?temp))
	(test (>= ?temp ?minT))
	(test (<= ?temp ?maxT))
	(test (>= ?sDepth ?cDepth))
	=>
	(printout t "Compatible crop for empty section " ?section ": " ?crop crlf)
	(printout t "	Temp Ok: " ?temp "C within " ?minT "-" ?maxT "C" crlf)
	(printout t "	Seed Spacing: " ?spacing "cm between plants" crlf))

; rule 20
(defrule create-new-planting
	?request <- (plant ?crop ?section)
	?counter  <- (id-counter (value ?current))
	(current-day (value ?today))
	(crop (name ?crop) (needs-pollination ?poll))
	?sect <- (section (id ?section) (crops $?existing))
=>
	(modify ?counter (value (+ ?current 1)))
	(bind ?pollInit (if (eq ?poll yes) then no else not-applicable))
	(assert (planting (id ?current) (crop-name ?crop) (section-id ?section) (planted-day ?today) 
    	(current-stage growing) (pollinated ?pollInit) (harvested no)))
	(modify ?sect (crops (create$ $?existing ?crop)))
	(retract ?request)
	(printout t "PLANTED: planting " ?current " -- " ?crop " in section " ?section " on day " ?today crlf))


; rule 22
(defrule update-section-soil-depth
	?request <- (update-soil-depth ?section ?newDepth)
	?sect <- (section (id ?section) (soil-depth ?oldDepth))
=>
	(modify ?sect (soil-depth ?newDepth))
	(retract ?request)
	(printout t "SECTION UPDATED: section " ?section
	" soil depth changed from " ?oldDepth "cm to " ?newDepth "cm" crlf))

; rule 23
(defrule update-section-soil-nitrogen
	?request <- (update-soil-nitrogen ?section ?newN)
	?sect <- (section (id ?section) (soil-nitrogen ?oldN))
=>
	(modify ?sect (soil-nitrogen ?newN))
	(retract ?request)
	(printout t "SECTION UPDATED: section " ?section " soil nitrogen changed from " ?oldN " to " ?newN "" crlf))

; rule 21

(defrule debug-print-all-plantings
	(debug-plantings)
	(planting (id ?pid) (crop-name ?crop) (section-id ?section) (current-stage ?stage) (harvested no))
=>
	(printout t "[DEBUG] planting " ?pid ": " ?crop " |  section: " ?section " | stage: " ?stage crlf))


(defrule process-harvest-request
    ?request <- (harvest ?pid)
    ?planting <- (planting (id ?pid) (harvested no))
    =>
    (retract ?request)
    (modify ?planting (harvested yes)))


; cf rule 1
(defrule diagnose-powdery-mildew
  (symptom (planting-id ?id) (name white-powder) (cf ?c1))
  (test (> ?c1 0.2))
  (planting (id ?id) (crop-name zucchini|peas|lettuce))
=>
  (bind ?new-cf (* ?c1 0.9))
  (assert (diagnosis (planting-id ?id) (name powdery-mildew) (cf ?new-cf))))

;cf rule 2
(defrule diagnose-bacterial-leaf-spot
  (symptom (planting-id ?id) (name leaf-spots) (cf ?c1))
  (symptom (planting-id ?id) (name fruit-spots) (cf ?c2))
  (test (and (> ?c1 0.2) (> ?c2 0.2)))
  (planting (id ?id) (crop-name tomatoes|peppers))
=>
  (bind ?min-cf (min ?c1 ?c2))
  (bind ?new-cf (* ?min-cf 0.9))
  (assert (diagnosis (planting-id ?id) (name bacterial-leaf-spot) (cf ?new-cf))))


;cf rule 3

(defrule diagnose-early-blight
  (symptom (planting-id ?id) (name leaf-spots) (cf ?c1))
  (symptom (planting-id ?id) (name leaf-yellowing) (cf ?c2))
  (test (and (> ?c1 0.2) (> ?c2 0.2)))
  (planting (id ?id) (crop-name tomatoes))
=>
  (bind ?min-cf (min ?c1 ?c2))
  (bind ?new-cf (* ?min-cf 0.85))
  (assert (diagnosis (planting-id ?id) (name early-blight) (cf ?new-cf))))

;cf rule 4
(defrule diagnose-bacterial-wilt
  (symptom (planting-id ?id) (name wilting) (cf ?c1))
  (symptom (planting-id ?id) (name rapid-collapse) (cf ?c2))
  (test (and (> ?c1 0.2) (> ?c2 0.2)))
  (planting (id ?id) (crop-name tomatoes|peppers))
=>
  (bind ?min-cf (min ?c1 ?c2))
  (bind ?new-cf (* ?min-cf 0.9))
  (assert (diagnosis (planting-id ?id) (name bacterial-wilt) (cf ?new-cf))))
;cf rule 5
(defrule diagnose-bacterial-blight
  (symptom (planting-id ?id) (name damaged-leaves) (cf ?c1))
  (symptom (planting-id ?id) (name damaged-pods) (cf ?c2))
  (test (and (> ?c1 0.2) (> ?c2 0.2)))
  (planting (id ?id) (crop-name beans|peas))
=>
  (bind ?min-cf (min ?c1 ?c2))
  (bind ?new-cf (* ?min-cf 0.85))
  (assert (diagnosis (planting-id ?id) (name bacterial-blight) (cf ?new-cf))))
;cf rule 6

(defrule diagnose-mosaic-virus
  (symptom (planting-id ?id) (name patchy-leaves) (cf ?c1))
  (symptom (planting-id ?id) (name misshapen-leaves) (cf ?c2))
  (test (and (> ?c1 0.2) (> ?c2 0.2)))
  (planting (id ?id) (crop-name zucchini|beans|lettuce|tomatoes))
=>
  (bind ?min-cf (min ?c1 ?c2))
  (bind ?new-cf (* ?min-cf 0.8))
  (assert (diagnosis (planting-id ?id) (name mosaic-virus) (cf ?new-cf))))
;cf rule 7

(defrule diagnose-white-rot
  (symptom (planting-id ?id) (name rotting-roots) (cf ?c1))
  (symptom (planting-id ?id) (name weak-plant) (cf ?c2))
  (test (and (> ?c1 0.2) (> ?c2 0.2)))
  (planting (id ?id) (crop-name onions))
=>
  (bind ?min-cf (min ?c1 ?c2))
  (bind ?new-cf (* ?min-cf 0.87))
  (assert (diagnosis (planting-id ?id) (name white-rot) (cf ?new-cf))))

;cf rule 8

(defrule diagnose-fungal-leaf-spot
  (symptom (planting-id ?id) (name leaf-spots) (cf ?c1))
  (symptom (planting-id ?id) (name spreading-lesions) (cf ?c2))
  (test (and (> ?c1 0.2) (> ?c2 0.2)))
  (planting (id ?id) (crop-name spinach|lettuce))
=>
  (bind ?min-cf (min ?c1 ?c2))
  (bind ?new-cf (* ?min-cf 0.8))
  (assert (diagnosis (planting-id ?id) (name fungal-leaf-spot) (cf ?new-cf))))
;cf rule 9

(defrule diagnose-fruit-rot
  (symptom (planting-id ?id) (name soft-spots) (cf ?c1))
  (test (> ?c1 0.2))
  (planting (id ?id) (crop-name tomatoes|peppers))
=>
  (bind ?new-cf (* ?c1 0.8))
  (assert (diagnosis (planting-id ?id) (name fruit-rot-disease) (cf ?new-cf))))
;cf rule 10

(defrule diagnose-general-stress
  (symptom (planting-id ?id) (name wilting) (cf ?c1))
  (symptom (planting-id ?id) (name leaf-yellowing) (cf ?c2))
  (test (and (> ?c1 0.2) (> ?c2 0.2)))
  (planting (id ?id))
=>
  (bind ?min-cf (min ?c1 ?c2))
  (bind ?new-cf (* ?min-cf 0.6))
  (assert (diagnosis (planting-id ?id) (name general-stress) (cf ?new-cf))))

;; fuzzy

(defrule compute-temp-excess
  (planting (id ?pid) (crop-name ?crop) (section-id ?section) (harvested no))
  (crop (name ?crop) (max-temp ?max))
  (greenhouse (temperature ?temp))
  (test (> ?temp ?max))
  =>
  (bind ?excess (- ?temp ?max))
  (assert (temp-excess (?excess 1.0)))
  (bind ?slevel
    (if (< ?excess 4) then low
    else (if (< ?excess 7) then medium
    else high)))
  (assert (stress-level (type heat) (level ?slevel)))
  (bind ?label
    (if (< ?excess 4) then "slightly too warm"
    else (if (< ?excess 7) then "too warm"
    else "much too warm")))
  (printout t "[HEAT STRESS] " ?crop " (section " ?section "): " ?label crlf))

(defrule compute-temp-deficit
  (planting (id ?pid) (crop-name ?crop) (section-id ?section) (harvested no))
  (crop (name ?crop) (min-temp ?min))
  (greenhouse (temperature ?temp))
  (test (< ?temp ?min))
  =>
  (bind ?deficit (- ?min ?temp))
  (assert (temp-deficit (?deficit 1.0)))
  (bind ?slevel
    (if (< ?deficit 4) then low
    else (if (< ?deficit 7) then medium
    else high)))
  (assert (stress-level (type cold) (level ?slevel)))
  (bind ?label
    (if (< ?deficit 4) then "slightly too cold"
    else (if (< ?deficit 7) then "too cold"
    else "much too cold")))
  (printout t "[COLD STRESS] " ?crop " (section " ?section "): " ?label crlf))

(defrule compute-humidity-excess
  (planting (id ?pid) (crop-name ?crop) (section-id ?section) (harvested no))
  (crop (name ?crop) (max-humidity ?maxH))
  (greenhouse (humidity ?hum))
  (test (> ?hum ?maxH))
  =>
  (bind ?excess (- ?hum ?maxH))
  (assert (humidity-excess (?excess 1.0)))
  (bind ?slevel
    (if (< ?excess 8) then low
    else (if (< ?excess 14) then medium
    else high)))
  (assert (stress-level (type humid-high) (level ?slevel)))
  (bind ?label
    (if (< ?excess 8) then "slightly too humid"
    else (if (< ?excess 14) then "too humid"
    else "much too humid")))
  (printout t "[HUMIDITY HIGH] " ?crop " (section " ?section "): " ?label crlf))

(defrule compute-humidity-deficit
  (planting (id ?pid) (crop-name ?crop) (section-id ?section) (harvested no))
  (crop (name ?crop) (min-humidity ?minH))
  (greenhouse (humidity ?hum))
  (test (< ?hum ?minH))
  =>
  (bind ?deficit (- ?minH ?hum))
  (assert (humidity-deficit (?deficit 1.0)))
  (bind ?slevel
    (if (< ?deficit 11) then low
    else (if (< ?deficit 17) then medium
    else high)))
  (assert (stress-level (type humid-low) (level ?slevel)))
  (bind ?label
    (if (< ?deficit 11) then "slightly too dry"
    else (if (< ?deficit 17) then "too dry"
    else "much too dry")))
  (printout t "[HUMIDITY LOW] " ?crop " (section " ?section "): " ?label crlf))
(defrule fuzzy-severe-heat
  (stress-level (type heat) (level high))
  =>
  (assert (care-urgency high)))

(defrule fuzzy-mild-heat
  (stress-level (type heat) (level medium))
  (not (stress-level (type heat) (level high)))
  =>
  (assert (care-urgency medium)))

(defrule fuzzy-low-heat
  (stress-level (type heat) (level low))
  (not (stress-level (type heat) (level medium)))
  (not (stress-level (type heat) (level high)))
  =>
  (assert (care-urgency low)))


(defrule fuzzy-severe-cold
  (stress-level (type cold) (level high))
  =>
  (assert (care-urgency high)))

(defrule fuzzy-mild-cold
  (stress-level (type cold) (level medium))
  (not (stress-level (type cold) (level high)))
  =>
  (assert (care-urgency medium)))

(defrule fuzzy-low-cold
  (stress-level (type cold) (level low))
  (not (stress-level (type cold) (level medium)))
  (not (stress-level (type cold) (level high)))
  =>
  (assert (care-urgency low)))

(defrule fuzzy-saturated-humidity
  (stress-level (type humid-high) (level high))
  =>
  (assert (care-urgency high)))

(defrule fuzzy-elevated-humidity
  (stress-level (type humid-high) (level medium))
  (not (stress-level (type humid-high) (level high)))
  =>
  (assert (care-urgency medium)))

(defrule fuzzy-low-humidity-excess
  (stress-level (type humid-high) (level low))
  (not (stress-level (type humid-high) (level medium)))
  (not (stress-level (type humid-high) (level high)))
  =>
  (assert (care-urgency low)))

(defrule fuzzy-severe-dry-conditions
  (stress-level (type humid-low) (level high))
  =>
  (assert (care-urgency high)))

(defrule fuzzy-dry-conditions
  (stress-level (type humid-low) (level medium))
  (not (stress-level (type humid-low) (level high)))
  =>
  (assert (care-urgency medium)))

(defrule fuzzy-low-humidity-deficit
  (stress-level (type humid-low) (level low))
  (not (stress-level (type humid-low) (level medium)))
  (not (stress-level (type humid-low) (level high)))
  =>
  (assert (care-urgency low)))

(defrule report-care-urgency
  (declare (salience -10))
  ?u <- (care-urgency ?)
  =>
  (bind ?score (moment-defuzzify ?u))

  (printout t crlf)
  (printout t "*********" crlf)
  (printout t "Fuzzy stress  greenhouse summary" crlf)
  (printout t "*********" crlf)

  (printout t "  Care Urgency Score: " ?score " / 10" crlf)

  (if (>= ?score 7.0) then
    (printout t "  >> Urgent: Alter environment, check for damage in plants and equipment" crlf)
    (printout t "     One or more plants are under severe stress." crlf)
  else (if (>= ?score 4.0) then
    (printout t "  >> Caution: ALter environment" crlf)
  else
    (printout t "  >> Ok: Continue monitoring" crlf)
    (printout t "     Planttress levels are low." crlf)))

  (printout t "*******" crlf)
  (printout t crlf))
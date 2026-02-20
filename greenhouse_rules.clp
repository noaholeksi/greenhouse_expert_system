; rule 1
(defrule warn-heat-stress
(planting (crop-name ?crop) (section-id ?section) (harvested no))
  	(crop (name ?crop) (max-temp ?max))
    (greenhouse (temperature ?temp))
    (test (> ?temp ?max))
	=> 
    (printout t "ENVIRONMENT WARNING: " ?crop " in section " ?section " is experiencing too hot" crlf)
    (printout t "	Current temperature: " ?temp "C -- Max safe: " ?max "C" crlf))

;rule 2
(defrule warn-cold-stress
    (planting (crop-name ?crop) (section-id ?section) (harvested no))
    (crop (name ?crop) (min-temp ?min))
    (greenhouse (temperature ?temp))
    (test (< ?temp ?min))
	=>
    (printout t "ENVIRONMENT WARNING: " ?crop " in section " ?section " is too cold" crlf)
    (printout t "	Current temp: " ?temp "C - Min safe: " ?min "C" crlf))

;rule 3
(defrule warn-humidity-too-high
    (planting (crop-name ?crop) (section-id ?section) (harvested no))
 	(crop (name ?crop) (max-humidity ?maxH))
    (greenhouse (humidity ?hum))
    (test (> ?hum ?maxH))
	=>
    (printout t "ENVIRONMENT WARNING: humidity " ?hum "% exceeds maximum for " 
        ?crop" in section " ?section " (max: " ?maxH "%)" crlf))

;rule4
(defrule warn-humidity-too-low
    (planting (crop-name ?crop) (section-id ?section) (harvested no))
    (crop (name ?crop) (min-humidity ?minH))
    (greenhouse (humidity ?hum))
    (test (< ?hum ?minH))
	=>
    (printout t "ENVIRONMENT WARNING: humidity " ?hum "% is below minimum for " 
		?crop " in section " ?section " (min: " ?minH "%)" crlf))

;rule 7 
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
		else ?currentN)))))

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







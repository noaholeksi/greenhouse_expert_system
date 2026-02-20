(deffacts greenhouse-state
	(greenhouse (temperature 23) (humidity 75))
)

(deffacts day-state
	(current-day (value 55))
)

(deffacts id-state
	(id-counter (value 5))
)

(deffacts section-states
	(section (id 1) (soil-depth 60) (soil-nitrogen medium) (crops tomato basil))
	(section (id 2) (soil-depth 40) (soil-nitrogen low) (crops lettuce))
	(section (id 3) (soil-depth 20) (soil-nitrogen medium) (crops spinach))
	(section (id 4) (soil-depth 50) (soil-nitrogen high) (crops none))
	(section (id 5) (soil-depth 35) (soil-nitrogen medium)  (crops none))
)

(deffacts active-plantings 
	(planting 
		(id 1)
		(crop-name tomato)
		(section-id 1)
		(planted-day 2)
		(current-stage growing)
		(pollinated no)
		(harvested no))

	(planting 
		(id 2)
		(crop-name basil)
		(section-id 1)
		(planted-day 2)
		(current-stage growing)
		(pollinated not-applicable)
		(harvested no))

	(planting 
		(id 3)
		(crop-name lettuce)
		(section-id 2)
		(planted-day 20)
		(current-stage growing)
		(pollinated not-applicable)
		(harvested no))

	(planting 
		(id 4)
		(crop-name spinach)
		(section-id 3)
		(planted-day 30)
		(current-stage growing)
		(pollinated not-applicable)
		(harvested no))
	)

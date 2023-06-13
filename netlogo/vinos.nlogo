; SPDX-FileCopyrightText: 2022-2023 Universität Hamburg
; SPDX-FileCopyrightText: 2022-2023 Helmholtz-Zentrum hereon GmbH
; SPDX-License-Identifier: Apache-2.0
;
; SPDX-FileContributor: Carsten Lemmen <carsten.lemmen@hereon.de>
; SPDX-FileContributor: Sascha Hokamp <sascha.hokamp@uni-hamburg.de>
; SPDX-FileContributor: Jieun Seo <jieun.seo@studium.uni-hamburg.de>
; test

extensions [
  gis
  csv
  profiler
  palette
  bitmap
]

__includes [
  "include/geodata.nls"
  "include/calendar.nls"
  "include/gear.nls"
  "include/plot.nls"
  "include/utilities.nls"
  "include/boat.nls"
  "include/view.nls"
  "include/prey.nls"
  "include/port.nls"
  "include/time-series.nls"
]

; breed [gears gear] ; defined in gear.nls
; breed [boats boat] ; defined in boat.nls
; breed [legends legend] ; defined in view.nls
; breed [preys prey] ; defined in prey.nls
; breed [ports port] ; defined in port.nls

breed [actions action]

actions-own [
  action-patch                       ; targeted patch id
  action-gain                        ; gain for the fishing trip of the boat
  action-gear
]

globals [
  navigable-depth                    ; minimum depth where a boat can navigate
  min-fresh-catch                    ; wether the boat decides to go back to harbor, maybe change name

  sum-ports-total-landings-kg        ; overall sum of total landings per period
  percentage-landings-kg             ; percentage of other landing over total landings per period
  sum-ports-crangon-landings-euro    ; overall sum of landings of crangon per period in EUR 2015
  sum-ports-platessa-landings-euro   ; overall sum of landings of platessa per period in EUR 2015
  sum-ports-solea-landings-euro      ; overall sum of landings of solea per period in EUR 2015
  sum-ports-crangon-landings-kg      ; overall sum of landings of crangon per period in kg
  sum-ports-platessa-landings-kg     ; overall sum of landings of platessa per period in kg
  sum-ports-solea-landings-kg        ; overall sum of landings of solea per period in kg
  sum-boats                          ; overall boats of all ports

  owf-dataset                        ; Off-shore wind farms

  year month day                     ; time frame
  day-of-year
  days-in-months

  home-ports                 ; agentset of breed ports
  ;favorite-landing-ports     ; agentset of breed ports

  view-legend-n
  view-legend-thresholds
  date-patch
]

patches-own [
  fish-biomass                    ; vektor of biomass of the fish species


  fishing-effort-hours                   ; fishing effort in hours
  crangon-summer                         ; data from TI
  crangon-winter
  platessa-summer
  platessa-winter
  solea-summer
  solea-winter

  fish-abundance

  pollution-exceedance
  depth
  owf-fraction
  accessible?             ; false if not accessible to fishery, i.e. close to port, too shallow, restricted area
  plaice-box?

  patch-prey-names
]

; ------------------------------------------------------------------------------------------
; The startup procedure is called when the model is opened by NetLogo.  This automates
; the execution of setup
to startup
   setup
end

to setup
  clear-all

  setup-calendar
  setup-globals
  setup-gears

  ;set harbor-stage (list "stay" "go")
  ;set weather-stage (list "good" "bad")

  setup-maps ; in "geodata.nls"

  calc-pollution
  calc-fish
  calc-accessibility

  setup-preys

  setup-ports
  calc-initial-values
  setup-boats ; in "boat.nls"

  set boat-property-chooser "distance-at-sea"
  setup-plots

  set view-legend-n 9
  update-view
  update-drawings
  setup-logo
  display

  reset-ticks
end

to setup-globals
  set min-fresh-catch 10
  set navigable-depth 2
  set view "bathymetry"
  set date-patch patch (max-pxcor - 8) (min-pycor + 2)
  ask date-patch [
    set plabel-color ifelse-value holiday? [red][white]
    set plabel datetime
  ]

end

to setup-logo
  let _logo  bitmap:import "../assets/logo-mussel.png"
  set _logo bitmap:scaled _logo ( 0.5 * bitmap:width _logo) (0.5 * bitmap:height _logo)
  ;bitmap:copy-to-drawing _logo  0.1 * max-pycor
  bitmap:copy-to-drawing _logo 0.01 * max-pxcor  2.65 * max-pycor
end

; This new go procedure used discrete event simulation within a 24 hour tick
; It is more efficient than the oritinal 72-h based go procedure but does not
; yet contain the priority calculation
to go

  advance-calendar
  ask date-patch [
    set plabel-color ifelse-value holiday? [red][white]
    set plabel datetime
  ]

  ;let _total-prey-landed sum ([port-prey-landed] of ports)
  ; Todo: adjust price, leave for next version
  ; preis = a - b * h
  ; set price price - sum_boats (catch) * price-sensitivity

  calc-fish
  let _active-boats n-of 10 boats

  ; Enable a simulation with only one active boat that can be closely
  ; followed.  This is off by default
  ifelse one? [
    set _active-boats min-n-of 1 boats [who]
    let _boat one-of _active-boats

    if subject != _boat [
      watch _boat
      inspect _boat
    ]
  ][]

  let _boats _active-boats with [boat-hour < 24]
  while [count _boats > 0] [
    ask _boats [
      ifelse (boat-trip-phase = 5) [ boat-land-port ][
        ifelse (boat-trip-phase = 4) [ boat-return-port ][
          ifelse (boat-trip-phase = 3) [  boat-make-haul ][
           ifelse (boat-trip-phase = 2) [ boat-choose-start ][
             ifelse (boat-trip-phase = 1) [ boat-leave-port ][
               boat-rest-port ; boat-trip-phase = 0
      ]]]]]
    ]
    set _boats _active-boats with [boat-hour < 24]
  ]
  ask boats [ set boat-hour boat-hour mod 24 ]

  update-plots

  ; export the data every week on a Sunday (weekday 0)
  if (time:get "dayofweek"  date) = 0 [export-patches]

  tick
end

to calc-initial-values
  set sum-boats sum [sum port-clusters] of ports
end


;---------------------------------


to-report viewed
  report view
end

to update-view

  if any? legends [ask legends [die]]
  if any? legend-entries [ask legend-entries [die]]
  let n view-legend-n
  let qv nobody
  ask patches [set pcolor grey - 2]
  ask patches with [ accessible? = True ][set pcolor grey]


  if view = "Crangon"  [
    set qv quantile-thresholds [crangon] of patches with [crangon > 0] n
    ask patches with [crangon >= 0][
      carefully [
        set pcolor palette:scale-scheme  "Sequential" "Reds" n (first quantile-scale qv  (list crangon)) 0 1
      ][]
    ]
    draw-legend (palette:scheme-colors "Sequential" "Reds" n)  (n-values (n + 1) [ i -> formatted-number (item i qv) 5])
  ]

  if view = "Solea"  [
    set qv quantile-thresholds [solea] of patches with [solea > 0] n
    ask patches with [solea > 0][
      carefully [
        set pcolor palette:scale-scheme  "Sequential" "Reds" n (first quantile-scale qv  (list solea)) 0 1
      ][]
    ]
    draw-legend (palette:scheme-colors "Sequential" "Reds" n)  (n-values (n + 1) [ i -> formatted-number (item i qv) 5])
   ]

  if view = "Pleuronectes"  [
    set qv quantile-thresholds [platessa] of patches with [platessa > 0] n
    set view-legend-thresholds qv
    ask patches with [platessa > 0][
      carefully [
        set pcolor palette:scale-scheme  "Sequential" "Reds" n (first quantile-scale qv  (list platessa)) 0 1
      ][]
    ]
    draw-legend (palette:scheme-colors "Sequential" "Reds" n)  (n-values (n + 1) [ i -> formatted-number (item i qv) 5])
  ]

  if view = "bathymetry"  [
    set qv quantile-thresholds [depth] of patches with [depth > 0 and depth < 80] n
    ask patches with [depth > 0][
      carefully [
        set pcolor palette:scale-scheme  "Sequential" "Blues" n (first quantile-scale qv  (list depth)) 0 1
      ][]
    ]
    draw-legend (palette:scheme-colors "Sequential" "Blues" n)  (n-values (n + 1) [ i -> formatted-number (item i qv) 3])
  ]

  if view = "effort (h)"  [
    set qv quantile-thresholds [fishing-effort-hours] of patches with [fishing-effort-hours > 0] n
    ask patches with [depth > 0][
      carefully [
        set pcolor palette:scale-scheme  "Sequential" "Oranges" n (first quantile-scale qv  (list fishing-effort-hours)) 0 1
      ][]
    ]
    if qv != nobody [draw-legend (palette:scheme-colors "Sequential" "Oranges" n)  (n-values (n + 1) [ i -> formatted-number (item i qv) 5])]
  ]

  if view = "pollution (random)" [ask patches [set pcolor scale-color red pollution-exceedance 0 2]]
  set n max [ fishing-effort-hours ] of patches
  if view = "accessible?" [ask patches [set pcolor scale-color blue boolean2int accessible? 1 0 ]]
  if view = "owf" [ask patches [set pcolor scale-color blue owf-fraction 2 0 ]]
  if view = "plaice-box?" [ask patches [set pcolor scale-color blue boolean2int (plaice-box? and accessible?) 1 0 ]]

  ;if qv != nobody [
    ;draw-legend (palette:scheme-colors "Sequential" "Blues" n)  (n-values (n + 1) [ i -> formatted-number (item i qv) 5])
  ;]

end


to update-view-legend

  ; Create a background for drawing the legend
  ask patches with [pxcor >= min-pxcor + 2 and pxcor <= min-pxcor + 20
       and pycor > max-pycor - 22 - 3 * view-legend-n and pycor < max-pycor - 20][set pcolor grey]

  let view-legend-colors palette:scheme-colors "Sequential" "Reds" view-legend-n

  if any? legends [ask legends [die]]
  foreach range view-legend-n [ i ->
    create-legends 1 [
         set shape "square"
         set size 3
         setxy min-pxcor + 4  max-pycor - 20 - 3 * view-legend-n + 1  + 3 * i
         set color item i view-legend-colors
    ]
    create-legends 1 [
         set shape "square"
         set size 0.1
         setxy min-pxcor + 4 + 13 max-pycor - 20 - 3 * view-legend-n + 1 + 3 * i - 1
         set label-color black ; item i view-legend-colors
         set label formatted-number (item i view-legend-thresholds) 5
    ]
  ]
end

; This is a dummy procedure and needs to be replace by actual pollution data.
to calc-pollution
  ask n-of 100 patches with [platessa > 0] [set pollution-exceedance random-float 2.0]
end

to train
  repeat 100 [
    ask boats [ learn ]
  ]
end

to learn
  let home-port-boat one-of link-neighbors
  let my-patch one-of patches with [accessible?]
  let my-costs boat-transportation-costs * distance my-patch
  ; the following is still wrong
  let my-revenue 0 ; catch-efficiency-boat * ([item 2 port-prices] of home-port-boat * [platessa-summer] of my-patch + [item 0 port-prices] of home-port-boat * [solea-summer] of my-patch + [item 1 port-prices] of home-port-boat * [crangon-summer] of my-patch)
  let my-gain my-revenue - my-costs
  let my-pathway one-of link-neighbors with [breed = actions and action-gain < my-gain]
  if my-pathway != nobody [ask my-pathway [
    set action-patch my-patch
    set action-gain my-gain
   ]
  ]
end

to-report grayscale [x]
  report (round (10 * (x mod 10))) / 10
end

; turtle procedure
;to move
;  ifelse (boat-time-at-sea > 300) [
;    pen-up
;    move-to [landing-patch] of one-of link-neighbors
;    set boat-time-at-sea 0
;    pen-down
;  ] [
;   let target-patch one-of neighbors with [ depth > navigable-depth]
;    ifelse target-patch = nobody [ die ][ face target-patch]
;   ]
;
;  set boat-time-at-sea boat-time-at-sea + 1
;  fd 1
;end

; Patch procedures crangon, solea, and platessa report the seasonally-weighted
; area concentration of the three species calculated from their winter and summer
; values and weighted by day of year
to-report crangon
  report summer-weight * crangon-summer + (1 - summer-weight) * crangon-winter
end
to-report solea
  report summer-weight * solea-summer +  (1 - summer-weight) * solea-winter
end
to-report platessa
  report summer-weight * platessa-summer +  (1 - summer-weight) * platessa-winter
end

to-report summer-weight
  let seasonal-mean-weight 0.5
  let seasonal-weight-range 1
  let day-variation-range 0

  ;; Define seasonal signal with 120 day shift
  ;; (i.e. maximum on 1 August, minium 1 Feb)
  report seasonal-mean-weight + sin ( ( day-of-year - 129 + random day-variation-range )
    * 360.0 / 365.25 ) * seasonal-weight-range / 2.0
end

to calc-fish
  ask patches [
    set prey-names (list "Solea" "Pleuronectes" "Crangon")
    set patch-prey-names (list "Solea" "Pleuronectes" "Crangon")
    set fish-biomass (list solea platessa crangon)
    ;set fish-abundance (list 100 200 300 400) ; default values needs to be adjusted when data available
  ]
end

to-report catch-species [haul-length]
  ; calculate the values for each patch and every target species
  ;(solea, platessa and crangon), i.e. biomass cath in KG
  ; @todo: negative values possible for fish-biomass

  let ispecieslist n-values (number-of-gears) [igear -> position ([gear-species] of item igear boat-gears) prey-names ]

  report n-values (number-of-gears) [ igear ->
     (item igear catch-efficiency-boat) * (item (item igear ispecieslist) fish-biomass)
      * (([gear-width] of item igear boat-gears) * haul-length) * (boolean2int (item (item igear ispecieslist) fish-biomass > 0) )
  ]

end

; This is a boat procedure
to-report should-go-fishing?
  ; if the weather is good and
  ; if this month's harvest is not sufficent
  ; a boat decides to go on a fishing trip.

  set port-prob-bad-weather random-float 1.00
  if random-float 1.00 < port-prob-bad-weather
    [ if boat-gains < 1.000 [
      report true]
  ]
end



; This is a boat procedure
; it describes a detailed single fishing trip starting and ending in the
; port.
;to go-on-fishing-trip
;
;  boat-leave-port
;
;  let s-patch patch-here
;  let l-patch patch-here
;
;  let navigable-patches boat-accessible-patches
;
;  let time-step 0.1 ; in hours  (let's say 6 min)
;  let time-left boat-max-duration
;  let haul-time 2   ; 2 hours for a typical haul time without change of direction
;  let distance-left boat-steaming-speed * time-left ; at typical speed of 19 km / h this is 1368 km
;  let new-catch n-values (length prey-names - 1) [i -> 0]
;  let distance-to-alternative-patch 40 ;
;
;  ; Sascha suggests to use favorite-port instead of home-port in the next 10 lines
;  let home-port one-of link-neighbors  ; home-port of boats
;  let boat-plaice-box? false
;  let need-to-go-to-port? false
;
;  ; Move the boat from home port to the starting patch and assume it steams there,
;  ; thereby adding to trip time/length and subtracting from time and
;  ; distance left
;  pen-up
;  move-to home-port
;  set boat-distance-at-sea gis-distance s-patch
;  ; Suggestion to calculate distance-left based on "gis-distance min dist [ s-patch of landing-ports ]"
;  ; Carsten cautions that then boats might converge in the center (Cuxhaven) due to edge effect.
;  set distance-left max  (list (distance-left - gis-distance s-patch) 0 )
;  set boat-time-at-sea gis-distance s-patch / boat-steaming-speed
;  set time-left  max (list (time-left - gis-distance s-patch / boat-steaming-speed) 0 )
;  move-to s-patch
;  pen-down
;
;  ; A boat deploys the gear with the highest priority
;  let haul-width [gear-width] of item (index-max-one-of boat-gear-priorities) boat-gears
;
;  while [not need-to-go-to-port?] [
;
;    let found? false
;    let counter 0
;
;    ; Look around for a patch that is accessible
;    while [not found?] [
;      set heading random 360
;      set counter counter + 1
;      let t-patch patch-ahead (boat-steaming-speed * time-step)
;      if (t-patch != nobody) [
;        if ([accessible?] of t-patch) [set found? true]
;        if (boat-plaice-box? and [plaice-box?] of t-patch) [set found? false]
;      ]
;      if counter > 20 [set found? true]
;    ]
;
;    let t-patch patch-ahead (boat-steaming-speed * time-step)
;    if (t-patch = nobody or [not accessible?] of t-patch) [
;      print "Cannot find navigable patches ahead, going home"
;      set need-to-go-to-port? true ; Is there the need to go to port? E.g. time is running out, catch is higher than capacity of the boat
;    ]
;    if (boat-plaice-box? and [plaice-box?] of t-patch)  [
;      print "Cannot find patches outside plaice box ahead, going home"
;      set need-to-go-to-port? true
;    ]
;
;    if (not need-to-go-to-port?) [
;      ; Deploy the gear for haul-time and go in a straight direction,
;      ; observing every time step a possible change in the patch the
;      ; boat is on
;      repeat (haul-time / time-step) [
;        set new-catch catch-species (time-step * fishing-speed)
;        ask patch-here [
;          set fishing-effort-hours fishing-effort-hours + time-step
;        ]
;        forward fishing-speed * time-step
;        set boat-trip-gear-catches n-values (number-of-gears) [i -> (item i boat-trip-gear-catches + item i new-catch)]
;
;      ]
;      set time-left max (list (time-left - haul-time) 0 )
;      set distance-left max (list (distance-left - boat-steaming-speed * haul-time) 0 )
;      set boat-time-at-sea boat-time-at-sea  + haul-time
;      set boat-distance-at-sea boat-distance-at-sea + haul-time * fishing-speed
;      ;print (sentence boat-distance-at-sea boat-time-at-sea fishing-speed)
;
;      ; If the catch is not worth keeping it, discard it entirely and
;      ; reset the time left. Fishers don't want to keep the bad haul, as this
;      ; would restrict their left time
;      ; @todo could this lead to infinite stay at sea?
;      if (item 1 new-catch < min-fresh-catch and time-left < 24)[
;        set time-left 24
;      ]
;      ; But if the catch is successful, then make
;      ; sure that the timeout is maximum 24 hours (to keep the fish fresh)
;      ; @todo this is not properly implemented yet
;      if (item 1 new-catch > min-fresh-catch and time-left > 24)[
;        set time-left 24
;      ]
;
;      ; Evaluate whether to go home based on different criteria, i.e.
;      ; capacity exceeded, too far from home port, or
;
;      if (item 1 boat-trip-gear-catches > boat-capacity) [
;        print (list "Boat" who "full. Needs to go back to port")
;        set need-to-go-to-port? true
;      ]
;      if (gis-distance l-patch > distance-left) [
;        print (list "Boat" who "went far enough, needs to go home to reach port")
;        set need-to-go-to-port? true
;      ]
;      if (time-left < gis-distance l-patch / boat-steaming-speed) [
;        print (list "Boat" who "is running out of time, needs to go home to reach port")
;        set need-to-go-to-port? true
;      ]
;
;      ; in case of a bad haul, select a different patch.
;      ; for now, we choose a  neighbor patch, later we have to implement
;      ; a procedure to find a patch approx 20 km away
;      ; @todo check units
;      ;if (false) [
;      if (item 1 new-catch < min-fresh-catch) [
;        let my-neighbors patches  with [accessible? and gis-distance l-patch < distance-left and gis-distance myself < distance-to-alternative-patch and gis-distance home-port > 5 ] ; @todo: currently set to 20, revise with respect to memorx
;        ifelse any? my-neighbors [
;          set s-patch one-of my-neighbors
;          print (list "Boat" who "start a new haul at a different patch with depth" ([depth] of s-patch))
;        ][
;          print (list "Boat" who "could not find any navigable water, going home")
;          set need-to-go-to-port? true
;        ]
;        move-to s-patch
;        set boat-distance-at-sea boat-distance-at-sea + gis-distance s-patch
;        set distance-left distance-left - gis-distance s-patch
;        set boat-time-at-sea boat-time-at-sea + gis-distance s-patch / boat-steaming-speed
;        set time-left time-left - gis-distance s-patch / boat-steaming-speed
;      ]
;
;      print (list "Boat" who "t=" boat-time-at-sea "t-=" time-left "dh=" (gis-distance l-patch) "d=" boat-distance-at-sea "d-=" distance-left "c1=" (item 1 boat-trip-gear-catches) )
;      ;print (list who ([depth] of patch-here))
;    ]
;  ]
;
;  print "Returning to harbor..."
;
;  pen-up
;
;
;  set boat-distance-at-sea boat-distance-at-sea + gis-distance l-patch
;  set boat-time-at-sea boat-time-at-sea + gis-distance l-patch / boat-steaming-speed
;  move-to l-patch
;  set boat-distance-at-sea boat-distance-at-sea + gis-distance home-port
;  set boat-time-at-sea boat-time-at-sea + gis-distance home-port / boat-steaming-speed
;  move-to home-port
;
;  ; At typical trip would be to travel 48 hours, 300 km travelled
;  ; This might have to be updated for higher speeds and longer trips if such gear
;  ; becomes available
;  if boat-distance-at-sea  >  1000 [
;    print (list "ERROR: Boat" who "t=" boat-time-at-sea "t-=" time-left "dh=" (gis-distance l-patch) "d=" boat-distance-at-sea "d-=" distance-left )
;    stop
;  ]
;
;  set size 1
;  ;calculate costs, revenue and profit
;
;  ; for all gears, we calculate the value
;
;
;  ; "Eins bleibt immer gleich: Pro Stunde rechnet man pro PS mit einem Konsum von 0,21 Liter bei einem
;  ; Diesel und 0,29 Liter bei Benzin als Treibstoff.” https://www.boatsandstories.com/verbrauch_1-3-2/
;  ; At 150 PS and 48 h trip covering 300 km, the efficiency is 150*48*0,21/300 = 5 l km-1
;  ; @todo we can adjust this to boat-engine power
;  ; we scale the fuel-efficiency (0 to 1) with boat-fuel-consumption
;  let boat-fuel-consumption 48 * boat-engine *  1.35962 * 0.21 / 300 ; is typically 5 l km-1
;
;  ; Diesel for shipping is usually 0.5 € l-1
;  ; In the end tranpsortatino costs should be 15% of crangon reenvu, up to 30% for platessa/sole
;  set boat-transportation-costs boat-fuel-consumption * oil-price * boat-distance-at-sea; typically 750 €
;
;  ; Typically there are 3 people aboard, i.e. 150 * 3 work hours per month.  Average wage is 5000+2*2000 per
;  ; gross salary per month, adding 40% costs gives 12600 EUR, i.e. 84 € h-1, there is slider wage
;  ; in the end operating costs should be around 50% of revenue
;  set boat-operating-costs wage * boat-time-at-sea ; is typically 4000 €
;
;
;  if (sum boat-trip-gear-catches > 0 ) [ set costs-boat n-values (number-of-gears) [ i ->
;    (boat-transportation-costs * item i boat-trip-gear-catches +  boat-operating-costs * item i boat-trip-gear-catches) / sum boat-trip-gear-catches]
;  ]
;
;  ; Find the position of the target gear-species in prey-names and return the index of the species,
;  ; save this in a temporary list of size number-of-gears, resulting in the gear-species index map ispecieslist
;  ; @todo move this to gear.nls as global
;  let ispecieslist n-values (number-of-gears) [igear -> position ([gear-species] of item igear boat-gears) prey-names ]
;
;  ; Calculate the boat revenue depending on the landed species and the port
;  set revenue-boat n-values (number-of-gears)[igear -> (item igear boat-trip-gear-catches * ([item (item igear ispecieslist) port-prices] of boat-home-port))]
;
;  ; A typical revenue should be around 7500 € considereing the relative relation to tranposrt/operating costs.
;  print (sentence "R:" boat-transportation-costs boat-operating-costs revenue-boat)
;
;
;
;  set boat-delta-gains n-values (number-of-gears) [i -> (item i boat-gains) - (item i revenue-boat - item i costs-boat)]
;  set boat-gains n-values (number-of-gears) [i ->  item i revenue-boat - item i costs-boat]
;  let delta-adjust sum map [ i -> abs i ] boat-delta-gains ; fix minus boat priority ; in cast that the boat-gains decreases a lot, big minus values of delta-priorities make boat-gear-priorities minus
;  ifelse delta-adjust != 0 [ ; if delta-adjust = 0, there is no change in fish catch between the previous and current trip
;  set boat-delta-priorities n-values (number-of-gears) [i -> adaptation * (item i boat-delta-gains) * (item i boat-gear-priorities) / delta-adjust]
;  ][
;    set boat-delta-priorities map [i -> 0] boat-delta-priorities
;  ]
;  set boat-gear-priorities n-values (number-of-gears) [i -> item i boat-gear-priorities - item i boat-delta-priorities]
;; Make sure that boat-gear-priorities always sum to 1
;  set boat-gear-priorities map [i -> i / sum boat-gear-priorities] boat-gear-priorities
;
;  ; Correct such that sum (boat-delta-priorities = 0) ; introduced by cl as fix for negative priorities
;  ;if sum boat-delta-priorities != 0 [
;  ;  set boat-delta-priorities n-values (number-of-gears) [i -> item i boat-delta-priorities / sum boat-delta-priorities ]
;  ;  set boat-delta-priorities n-values (number-of-gears) [i -> item i boat-delta-priorities - mean boat-delta-priorities ]
;  ;]
;
;  set boat-gear-priorities n-values (number-of-gears) [i -> item i boat-gear-priorities - item i boat-delta-priorities]
;  ; Make sure that boat-gear-priorities always sum to 1
;  if sum boat-gear-priorities != 0 [
;    set boat-gear-priorities n-values (number-of-gears) [i -> item i boat-gear-priorities / sum boat-gear-priorities ]
;  ]
;
;
;  ; old implemenation for species
;  ;set costs-boat n-values (number-of-species - 1) [ i -> (boat-transportation-costs * item i boat-trip-gear-catches +  boat-operating-costs * item i boat-trip-gear-catches) / sum boat-trip-gear-catches]
;  ;set revenue-boat n-values (number-of-species - 1)[i -> (item i boat-trip-gear-catches * price-species)] ; @todo needs to be solved, price is related to home-port
;  ;set boat-delta-gains n-values (number-of-species - 1) [i -> (item i boat-gains) - (item i revenue-boat - item i costs-boat)]
;  ;set boat-gains n-values (number-of-species - 1) [i ->  item i revenue-boat - item i costs-boat]
;  ;set delta-boat-gear-priorities n-values (number-of-species - 1) [i -> adaptation * (item i boat-delta-gains) / (item i boat-gear-priorities)]
;  ;set boat-gear-priorities n-values (number-of-species - 1) [i -> item i boat-gear-priorities - item i delta-boat-gear-priorities]
;  print (list "Boat" who " has cost of " (boat-transportation-costs + boat-operating-costs) )
;  print (list "Boat" who " has cost of " costs-boat )
;  print (list "Boat" who " has dpriorities of" boat-delta-priorities)
;  print (list "Boat" who " has priorities of" boat-gear-priorities)
;  print (list "Boat" who " has priority weighted average of" priority-weighted-average)
;
;  ; Now we can make a decision, once enough experience is gained.  This could be a
;  ; seasonal decision. Something that changes strategy.
;  if (boat-type = 3 and month = 10 and day = 1) []
;  if (boat-type = 2) [
;   ; can change gear if opportune
;   ; change typical trip length (less flexible, rather they would change the frequency)
;   ; change typical trip frequency (from total_fishing_hours)
;  ]
;  if (boat-type = 4) [
;    ; change gear a lot according with trip length  and frequency
;  ]
;  ; LPUE landing-per-unit-effort (i.e per time) t/h efficient ones
;  ; know the area, this is also a fleet management harvest controle
;
;  ; Fishing hour range: Every fisher has a minimum/maximum of how much she
;  ; expects to be active. If reached, they rest, if not reached they might
;  ; work harder.
;end


; This routine is to be called by CI
to create-effort-map

  ask patches [
    set fishing-effort-hours 0
  ]

  repeat 365 [ go ]

  ; data storage
  let prefix  (word "results/effort-" substring date-and-time 0 12)

  set view "effort (h)"
  update-view
  clear-drawing
  ask links [set hidden? true]
  ask boats [set hidden? true]

  export-view (word prefix ".png")

  ask links [set hidden? false]
  ask boats [set hidden? false]


  let dataset gis:patch-dataset fishing-effort-hours
  gis:store-dataset dataset prefix

end

to calc-accessibility

  ask patches [set plaice-box? false]
  load-plaice-box

  let depth-threshold -1

  ; By default, all patches are inaccessible
  ask patches [set accessible? false]

  let _sns load-dataset "SNS"
  ;ask patches gis:intersecting [set accessible? true]
  ;ask patches with [depth < depth-threshold] [set accessible? false]

  let _water-patches patches gis:intersecting  _sns

  ; Creep-fill from maximum depth, assumed in the North Sea
  let my-patches max-one-of _water-patches [depth]
  ask my-patches [set accessible? true]

  let new-patches nobody
  repeat max-pxcor * 2 [
    ask my-patches [
      set new-patches neighbors4 with [depth >= depth-threshold and not accessible?]
      ;set new-patches neighbors4 with [not accessible?]
      ask new-patches [set accessible? true]
    ]
    set my-patches _water-patches with [accessible? and (count neighbors4 with [accessible?]) < 4]
    ;print (sentence count patches with [accessible?] count my-patches)
  ]

  ask patches with [not accessible?] [set depth min (list -2 depth)]

  ;ask patches with [ all? neighbors [not accessible?] ] [set accessible? false]


  ; Also, fishing is not allowed nearby ports
  ; @todo find the correct legal distance from ports in grid space
  ; @todo ships still need to navigate through this channel?
  ;ask ports [
  ;  ask patches with [distance myself < 5]  [set accessible? false]
  ;]

  ; Boats are not allowed within OWF areas
  ask patches with [owf-fraction > 0.5] [set accessible? false]

  ; Fishery is restricted in MPAs from 1 May 2023.  This needs to be refined
  ; TBB and OTB are not allowed in Borkum riffgrund
  ; TBB and OTB ar not allowed in Sylt west
  ; Small TBB are allowed in Sylt East
  if year > 2023 or (year = 2023 and month > 4) [
    ask patches gis:intersecting load-dataset "Natura2000" [ set accessible? false ]
  ]

  ; @todo add nature protection, mining etc areas.

end

; The profile routine is called manually from the command line while we test
to profile
  setup
  profiler:start
  repeat 20 [ go ]
  profiler:stop
  ;csv:to-file "results/profiler_data.csv" profiler:data
  profiler:reset
end
@#$#@#$#@
GRAPHICS-WINDOW
262
59
1233
429
-1
-1
3.01
1
10
1
1
1
0
0
0
1
0
319
0
119
1
1
1
ticks
30.0

BUTTON
13
100
79
133
NIL
setup
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

CHOOSER
11
200
103
245
view
view
"Crangon" "Pleuronectes" "Solea" "pollution (random)" "bathymetry" "effort (h)" "accessible?" "owf" "plaice-box?"
4

BUTTON
83
101
152
134
go
go
T
1
T
OBSERVER
NIL
G
NIL
NIL
0

BUTTON
107
201
162
245
update
update-view
NIL
1
T
OBSERVER
NIL
U
NIL
NIL
1

SWITCH
1241
119
1376
152
show-ports?
show-ports?
0
1
-1000

SLIDER
14
359
252
392
adaptation
adaptation
0
1
0.58
0.001
1
NIL
HORIZONTAL

SLIDER
14
318
255
351
memory-size
memory-size
0
100
0.0
1
1
NIL
HORIZONTAL

SLIDER
13
401
254
434
operating-costs-of-boats
operating-costs-of-boats
0
1
0.227
0.001
1
NIL
HORIZONTAL

SLIDER
258
469
430
502
oil-price
oil-price
25
75
35.0
5
1
ct l-1
HORIZONTAL

TEXTBOX
15
10
1034
63
Viable North Sea (ViNoS) Agent-based Model of German Small-scale Fisheries
22
2.0
1

TEXTBOX
15
53
165
95
To operate the model, wait until the map is loaded and then click on \"go\".
11
0.0
1

TEXTBOX
14
153
177
195
Change the background information here and hit \"update\"
11
0.0
1

SLIDER
12
279
254
312
fraction-transportation-costs
fraction-transportation-costs
0
1
0.85
0.01
1
NIL
HORIZONTAL

PLOT
256
547
638
697
catch-by-gear
days
catch/kg
0.0
10.0
0.0
10.0
true
true
"plot-setup-catch-by-gear" "plot-update-catch-by-gear"
PENS

PLOT
647
547
925
697
gain-by-gear
days
gain/k€
0.0
10.0
0.0
10.0
true
false
"plot-setup-gain-by-gear" "plot-update-gain-by-gear"
PENS

PLOT
931
547
1197
696
priority-by-gear
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"plot-setup-priority-by-gear" "plot-update-priority-by-gear"
PENS

TEXTBOX
1244
58
1394
114
Select what to\nshow as \nbackground\ninformation
11
0.0
1

SWITCH
1242
196
1344
229
owf?
owf?
0
1
-1000

SWITCH
1241
238
1344
271
box?
box?
1
1
-1000

SWITCH
1240
279
1343
312
sar?
sar?
1
1
-1000

BUTTON
1238
317
1343
350
update
update-drawings
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
271
71
379
116
NIL
viewed
17
1
11

TEXTBOX
262
438
454
477
Diesel for ships is tax-exempt and \ncosts on average 0.5 € l-1
10
0.0
1

TEXTBOX
450
439
600
467
Staff costs are usually around 80 € h-1
11
0.0
1

SLIDER
448
469
620
502
wage
wage
50
120
85.0
5
1
€ h-1
HORIZONTAL

PLOT
15
547
231
697
boat-property
NIL
# boats
0.0
6.0
0.0
10.0
true
true
"plot-setup-boat-property" "plot-update-boat-property"
PENS

CHOOSER
15
497
161
542
boat-property-chooser
boat-property-chooser
"distance-at-sea" "capacity" "catch-efficiency" "engine" "length" "max-distance" "max-duration" "operating-costs" "steaming-speed" "time-at-sea" "time-at-sea-left" "transportation-costs" "trip-phase"
0

SWITCH
1241
156
1377
189
show-boats?
show-boats?
0
1
-1000

BUTTON
169
498
231
542
Update
plot-update-boat-property
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
1239
355
1344
388
clear
clear-drawing
NIL
1
T
OBSERVER
NIL
C
NIL
NIL
1

SWITCH
1241
397
1344
430
one?
one?
1
1
-1000

SLIDER
13
445
231
478
time-offset
time-offset
-200
200
0.0
1
1
months from now
HORIZONTAL

@#$#@#$#@
# Viable North Sea (ViNoS) Agent-based Model of German Small-scale Fisheries

Viable North Sea (ViNoS), an Agent-based model (ABM) of the German small-scale fisheries is a Social-Ecological Systems (SES) model focussing on the adaptive behaviour of fishers facing regulatory, economic, and resource changes.  Small-scale fisheries are an important part both of the cultural perception of the German North Sea coast and of its fishing industry. These fisheries are typically family-run operations that use smaller boats and traditional fishing methods to catch a variety of bottom-dwelling species, including plaice, sole, brown shrimp.

Fisheries in the North Sea face area competition with other uses of the sea -- long practiced ones like shipping, gas exploration and sand extractions, and currently increasing ones like marine protection and offshore wind farming (OWF).  German authorities have just released a new maritime spatial plan implementing the need for 30% of protection areas demanded by the United Nations High Seas Treaty and aiming at up to 70 GW of offshore wind power generation by 2045.   Fisheries in the North Sea also have to adjust to the northward migration of their established resources following the climate heating of the water.  And they have to re-evaluate their economic balance by figuring in the foreseeable rise in oil price and the need for re-investing into their aged fleet.

## Purpose, scope and audience
The purpose of this ABM is to provide an interactive simulation environment that describes spatial, temporal and structural adaptations of the fleet.  It adaptively describes

 * where to fish  and how far to go out to sea
 * how often to go out
 * what gear to use and what species to target

Its scope is the German North sea small-scale fisheries.  This encompasses some 300 vessels based in German ports along the North Sea coast and fishing in the German Bight, including but not restricted to Germany's exclusive economic zone (EEZ). The target species is currently restricted to the most important ones: plaice, sole and brown shrimp, but is in principle extensible to further target species like Norwegian lobster or whiting.

The intended audience of the ABM are marine researchers and government agencies concerned with spatial planning, environmental status assessment, and climate change mitigation.  It can also assist in a stakeholder dialogue with tourism and fishers to contextualize the complexity of the interactions between fisheries economics, changing resources and regulatory restrictions.  It is intended to be used for scenario development for future sustainable fisheries at the German North Sea coast.

## Agents and implementation features

Agents are boats,  the gear they use, the strategies they employ, and their prey.  All agents are encapsulated in object-oriented design as `breeds`.  The agents' methods implement the interaction rules between agents and between agents and their environment.  Key interactions are the movement rules of boats across the seascape, the harvesting of resources, and the cost-benefit analysis of a successful catch and its associated costs.  Adaptation occurs at the level of preference changes for gear selection (and prey species), and the time and distance preferences for fishing trips.

A notable programming feature is the integration of the legend with the (map) `view`, a feature that is lacking from the default capabilities of NetLogo.  There have been discussions on how to implement a legend using the `plot` element[1], but so far this is the only NetLogo model known to the authors implementing a legend with the `view`.

## Model documentation and license

The model is documented  with the Overview, Design, and Details (ODD, [2]) standard protocol for ABMs, available in the repository as [doc/odd/paper.md](doc/odd/paper.md)
All data from third parties is licensed under various open source licenses.  The model, its results and own proprietary data was released under open source licenses, mostly Apache 2.0 and CC-BY-SA-4.0.  A comprehensive documentation of all is provided via REUSE [3].

### Acknowledgements

We acknowledge contributions from Nikolaus Probst, Seong Jieun, and Jürgen Scheffran for providing data, fruitful discussions and contributing to the ODD document. We thank all members of the MuSSeL consortium making this software relevant in a research context.  The development of the model was made possible by the grant 03F0862A  "Multiple Stressors on North Sea Life" [4] within the 3rd Küstenforschung Nord-Ostsee (KüNO) call of the Forschung für Nachhaltigkeit (FONA) program of the Germany Bundesministerium für Bildung und Forschung (BMBF).



### License

Copyright: 2022-2023 Helmholtz-Zentrum hereon GmbH, Universität Hamburg, Hochschule Bremerhaven
Authors: Carsten Lemmen, Sascha Hokamp, Serra Örey
License: Apache 2.0

![Hereon](../assets/logo-hereon.png)       ![UHH](../assets/logo-uhh.png)     ![HSB](../assets/logo-hsb.png)


## References


[1]: Arn, Luke C, Javier Sandoval. 2018. “Netlogo How to Add a Legend?” Stackoverflow. 2018. https://stackoverflow.com/questions/51328633/netlo go-how-to-add-a-legend.

[2]: Grimm, Volker, Steven F. Railsback, Christian E. Vincenot, Uta Berger, Cara Gallagher, Donald L. Deangelis, Bruce Edmonds, et al. 2020. “The ODD protocol for describing agent-based and other simulation models: A second update to improve clarity, replication, and structural realism.” JASSS 23 (2). https://doi.org/10.18564/jasss.4259.

[3]: “REUSE Software.” 2023. Free Software Foundation Europe e.V. 2023. https://reuse.software.

[4]: "Multiple Stressors on North Sea Life.  https://www.mussel-project.de





![Funded by BMBF](../assets/logo-bmbf-funded.png)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

boat top
true
0
Polygon -7500403 true true 150 1 137 18 123 46 110 87 102 150 106 208 114 258 123 286 175 287 183 258 193 209 198 150 191 87 178 46 163 17
Rectangle -16777216 false false 129 92 170 178
Rectangle -16777216 false false 120 63 180 93
Rectangle -7500403 true true 133 89 165 165
Polygon -11221820 true false 150 60 105 105 150 90 195 105
Polygon -16777216 false false 150 60 105 105 150 90 195 105
Rectangle -16777216 false false 135 178 165 262
Polygon -16777216 false false 134 262 144 286 158 286 166 262
Line -16777216 false 129 149 171 149
Line -16777216 false 166 262 188 252
Line -16777216 false 134 262 112 252
Line -16777216 false 150 2 149 62

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sailboat side
false
0
Line -16777216 false 0 240 120 210
Polygon -7500403 true true 0 239 270 254 270 269 240 284 225 299 60 299 15 254
Polygon -1 true false 15 240 30 195 75 120 105 90 105 225
Polygon -1 true false 135 75 165 180 150 240 255 240 285 225 255 150 210 105
Line -16777216 false 105 90 120 60
Line -16777216 false 120 45 120 240
Line -16777216 false 150 240 120 240
Line -16777216 false 135 75 120 60
Polygon -7500403 true true 120 60 75 45 120 30
Polygon -16777216 false false 105 90 75 120 30 195 15 240 105 225
Polygon -16777216 false false 135 75 165 180 150 240 255 240 285 225 255 150 210 105
Polygon -16777216 false false 0 239 60 299 225 299 240 284 270 269 270 254

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.3.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="effort-map" repetitions="1" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>create-effort-map</go>
    <timeLimit steps="1000"/>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="view">
      <value value="&quot;effort (h)&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ports?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Oil-Price">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="operating-costs-of-boats">
      <value value="0.203"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="memory-size">
      <value value="47"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Adaptation">
      <value value="0.489"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fraction-transportation-costs">
      <value value="0.198"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@

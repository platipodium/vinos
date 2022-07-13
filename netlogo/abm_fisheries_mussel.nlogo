; SPDX-FileCopyrightText: 2022 Universität Hamburg (UHH)
; SPDX-FileCopyrightText: 2022 Helmholtz-Zentrum hereon GmbH (hereon)
; SPDX-License-Identifier: Apache-2.0
; Author: Sascha Hokamp <sascha.hokamp@uni-hamburg.de>
; Author: Carsten Lemmen <carsten.lemmen@hereon.de>

extensions [
  gis
  csv
]

__includes [
  "import-asc.nls"
  "calendar.nls"
  "read-in-data.nls"
]

breed [boats boat]
breed [ports port]
breed [actions action]

actions-own [
  target                      ; targetted patch id
  actions-target-species      ; primarily targetted species (solea, platessa, crangon)
  revenue                     ; revenue for the fishing trip of the boat
  costs                       ; costs for the fishing trip of the boat
  gain                        ; gain for the fishing trip of the boat
  priority                    ; priority for the pathway
  marginal-priority           ; expected change of the priority for the pathway
]

ports-own [
;;,"fav_lan","t_intv_min","tot_euros","tot_kgs","LE_EURO_SOL","LE_EURO_CSH","LE_EURO_PLE","LE_KG_SOL","LE_KG_CSH","LE_KG_PLE","VE_REF","t_intv_day","t_intv_h","ISO3_Country_Code","full_name","Coordinates","Latitude","Longitude","EU_Fish_Port","Port"
  kind                     ; home-port (which includes also the landings as favorite port) or favorite-landing-port
  name                     ; Name of the Port 'full name' info from UN_LOCODE.csv
  country                  ; Name of the Country 'ISO3_Country_Code' info from UN_LOCODE.csv
  latitude                 ; Latitude of the Port 'Latitude'
  longitude                ; Longitude of the Port 'longitude'
  start-patch              ; starting patch for boats
  landing-patch            ; landing patch for boats
  fish-catch-kg            ; vektor of fish catches

  landings-euro            ; vector of landings with number-of-species in EURO 2015
  landings-kg              ; vector of landings with number-of-species in Kg
  price                    ; vector of prices with number-of-species in EURO 2015

  port-transportation-costs; average transportation costs as percentage of the total landings in EUR 2015
  port-operation-costs     ; average operating costs as percentage of the total landings in EUR 2015
  port-average-trip-length ; average trip length


  port-average-fishing-effort-in-days
  port-average-fishing-effort-in-hours   ; t_intv_h
  vessels-per-port         ; number of individual vessels per home port
  weather                  ; status of the weather "bad" -> stay in harbor, "good" -> maybe leave harbor
  prob-bad-weather         ; probability that the weather is too bad to leave harbor
]

boats-own [
  my-id                        ; id of the boat
  fish-catch-boat              ; for each boat a vector of fish catches (per patch or tick)
  harvest-boat                 ; for each boat a vector of total harvest of the fish species
  catch-efficiency-boat        ; how much fish is effectively catched
  vessel-size                  ; size of the vessel
  engine-power                  ; power of the engine

  revenue-boat             ; revenue for the fishing trip of the boat
  costs-boat               ; costs for the fishing trip of the boat
  delta-gain-boat          ; change in gain
  gain-boat                ; gain for the fishing trip of the boat
  delta-priority-boat      ; change in priority
  priority-boat            ; priority for the pathway

  fishing-speed            ; speed when fishing
  steaming-speed           ; speed when steaming

  solea-catch-kg          ; catch of solea in kg for a fishing trip
  solea-catch-euro        ; catch of solea in EUR 2015 for a fishing trip
  platessa-catch-kg       ; catch of platessa in kg for a fishing trip
  platessa-catch-euro     ; catch of platessa in EUR 2015 for a fishing trip
  crangon-catch-kg        ; catch of crangon in kg for a fishing trip
  crangon-catch-euro      ; catch of crangon in EUR 2015 for a fishing trip
  other-catch-kg          ; other catch in kg for a fishing trip
  other-catch-euro        ; other catch in EUR 2015 for a fishing trip

  transportation-costs    ; costs for one km of the fishing trip, not known, work with a parameter
                          ; comment: mainly driven by oil price, approx 10-20 percent of the revenue for crangon, up to 30 percent for solea and platessa according to press relesease March 2022 going up to 50 percent
  operating-costs         ; cost for opertating the vessel, not known, work with a parameter
                          ; comment: approximately 50 percent of the revenue
  wage                    ;  wage                               ; wage
  target-species          ; species primarily tragetted (solea, platessa, crangon)
  ;home-port-boat               ; Home Port (in the current state only German home ports are considered
  ;favorite-landing-port-of-boat   ; favorite-landing-port (in the current state there is the one favorite port, which is the landing port)
  pathways                ; possible pathways which boats learn

]

globals [
  number-of-species                  ; number-of-species plus one for other
  species-names                      ; names of the species
  navigable-depth                    ; minimum depth where a boat can navigate
  min-fresh-catch                    ; wether the boat decides to go back to harbor, maybe change name

  sum-ports-total-landings-kg        ; overall sum of total landings per period
  sum-ports-other-landings-kg        ; overall sum of other landings per period
  percentage-landings-kg             ; percentage of other landing over total landings per period
  sum-ports-crangon-landings-euro    ; overall sum of landings of crangon per period in EUR 2015
  sum-ports-platessa-landings-euro   ; overall sum of landings of platessa per period in EUR 2015
  sum-ports-solea-landings-euro      ; overall sum of landings of solea per period in EUR 2015
  sum-ports-crangon-landings-kg      ; overall sum of landings of crangon per period in kg
  sum-ports-platessa-landings-kg     ; overall sum of landings of platessa per period in kg
  sum-ports-solea-landings-kg        ; overall sum of landings of solea per period in kg
  sum-vessels                        ; overall vessels of all ports

  owf-dataset                        ; Off-shore wind farms

  year month day                     ; time frame
  day-of-year day-of-week
  days-in-months

  home-ports                 ; agentset of breed ports
  favorite-landing-ports     ; agentset of breed ports
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

]

; The startup procedure is called when the model is opened by NetLogo.  This automates
; the execution of setup
to startup
   setup
end

to go

  every 1 [update] ; update the view every 1 second in case it changed
  advance-calendar
  ask ports [ifelse ports? [set label ""][set label name]]
  ;ask boats [ move]
  calc-fish
  tick
end

to calc-initial-values
  set sum-vessels sum [vessels-per-port] of ports
end

to-report sum-of-landings [species unit port-type]
  let index position species species-names
  ifelse unit = "euro" [
    report sum [item index landings-euro] of ports with [kind = port-type]
  ][
    report sum [item index landings-kg] of ports with [kind = port-type]
  ]
end

to setup
  clear-all
  reset-calendar


  set min-fresh-catch 10
  set number-of-species 4
  set species-names (list "solea" "crangon" "platessa" "other") ; order of the species in the excel file
  ;set harbor-stage (list "stay" "go")
  ;set weather-stage (list "good" "bad")

  import-asc

  set navigable-depth 5
  calc-pollution
  calc-fish
  calc-accessibility


  set view "bathymetry"
  update
  display
  setup-ports
  calc-initial-values
  setup-boats

  ask ports [set hidden? true]

  reset-ticks
end

;---------------------------------

to setup-ports
  read-landings "home"
  read-landings "favorite"

  ; separate the ports into two sets
  set home-ports ports with [ kind = "home"]
  set favorite-landing-ports ports with [kind = "favorite" ]

end

to setup-boats

  set-default-shape ports "flag"

  ask home-ports [
     hatch-boats vessels-per-port
     [
      create-link-with myself
      move-to [start-patch] of one-of link-neighbors
      set  fish-catch-boat         n-values number-of-species [?1 -> 0 ]    ; vector, 4 entries for solea, plaice, crangon and other species
      set  catch-efficiency-boat   n-values number-of-species [?1 -> 0.25 ]
      set  revenue-boat            n-values number-of-species  [?1 -> 0 ]   ; revenue for the fishing trip of the boat
      set  costs-boat              n-values number-of-species  [?1 -> 0 ]    ; costs for the fishing trip of the boat
      set  gain-boat               n-values number-of-species  [?1 -> 0 ]    ; gain for the fishing trip of the boat
      set  delta-priority-boat     n-values number-of-species  [?1 -> 0 ]    ; change of priority for the pathway
      set  priority-boat           n-values number-of-species  [?1 -> 0.25 ]    ; priority for the pathway
      set  transportation-costs  0                            ; start value, is calculated according to trip-length, fuel efficiency and oil-price
      set  operating-costs 0                                  ; start value, is calculated according to wage and time at sea
      set  wage  100                                          ; @todo default value
      set  fishing-speed 4                                   ; range 2 kn to 4 kn to get km multiply by 1.852
      set  steaming-speed 19                                  ; range 10  to 12
      set  engine-power 2000                                      ; kw
      set  vessel-size 100000                                  ; kg of storage
      set label ""                                             ; ????
    ]


  ]

   ;ask home-ports [
   ;  hatch-boats vessels-per-port [
   ; create-boats sum-vessels [
   ;   set shape "flag"
   ;   set size 10
   ;   set home-port-boat (one-of home-ports)
   ;   create-link-with home-port-boat
  ;    move-to [start-patch] of home-port-boat
    ;  set crangon-catch-kg 1 ; default value
   ;   set transportation-costs [port-transportation-costs] of home-port-boat / [port-average-trip-length] of home-port-boat
  ;    set operating-costs [port-operation-costs] of home-port-boat / 365
   ;   ifelse ([port-transportation-costs] of home-port-boat + [port-operation-costs] of home-port-boat) != 0 [

   ;     set catch-efficiency [total-landings-kg] of home-port-boat / ([port-transportation-costs] of home-port-boat + [port-operation-costs] of home-port-boat)
    ;  ][
   ;     set catch-efficiency [total-landings-kg] of home-port-boat / 1
   ;   ]
      ; create actions
      ; assemble these actions in a list
      ; save this as agent-set
    ;  hatch-actions memory-size [

    ;    create-link-with myself]
    ;  set pathways link-neighborstime-at-sea < trip-length / 2

    ;  set time-at-sea 0
    ;]
 ;  ]

end

to update
  if view = "crangon"  [ ask patches [ set pcolor scale-color orange crangon 0 1  ] ]
  if view = "solea"  [ ask patches [ set pcolor scale-color green solea 0 1  ] ]
  if view = "platessa"  [ ask patches [ set pcolor scale-color cyan platessa 0 1  ] ]
  if view = "pollution (random)" [ask patches [set pcolor scale-color red pollution-exceedance 0 2]]
  if view = "bathymetry" [ask patches [set pcolor scale-color blue depth 80 0 ]]
  if view = "effort (h)" [ask patches [set pcolor scale-color red fishing-effort-hours 50 0 ]]
  if view = "accessible?" [ask patches [set pcolor scale-color blue boolean2int accessible? 1 0 ]]
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
  let my-costs transportation-costs * distance my-patch
  let my-revenue catch-efficiency-boat * ([item 2 price] of home-port-boat * [platessa-summer] of my-patch + [item 0 price] of home-port-boat * [solea-summer] of my-patch + [item 1 price] of home-port-boat * [crangon-summer] of my-patch)
  let my-gain my-revenue - my-costs
  let my-pathway one-of link-neighbors with [breed = actions and gain < my-gain]
  if my-pathway != nobody [ask my-pathway [
    set target my-patch
    set gain my-gain
    set revenue my-revenue
    set costs my-costs
   ]
  ]
end

to-report grayscale [x]
  report (round (10 * (x mod 10))) / 10
end

; turtle procedure
;to move
;  ifelse (time-at-sea > 300) [
;    pen-up
;    move-to [landing-patch] of one-of link-neighbors
;    set time-at-sea 0
;    pen-down
;  ] [
;   let target-patch one-of neighbors with [ depth > navigable-depth]
;    ifelse target-patch = nobody [ die ][ face target-patch]
;   ]
;
;  set time-at-sea time-at-sea + 1
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
    * 360.0 / (365 + leap-year) ) * seasonal-weight-range / 2.0
end

to calc-fish
  ask patches [
    set fish-biomass (list solea-summer platessa-summer crangon-summer 0)
    ;set fish-abundance (list 100 200 300 400) ; default values needs to be adjusted when data available
  ]
end

to-report catch-species [haul-length]
  ; calculate the values for each patch and every target species
  ;(solea, platessa and crangon), i.e. biomass cath in KG
  ; @todo: negative values possible for fish-biomass

  let gear-width 0.017 ; unit km, this is only for crangon, is needed for other species

  let new-catch n-values (number-of-species - 1) [ i -> ( item i priority-boat ) * (item i catch-efficiency-boat) * (item i fish-biomass) * (gear-width * haul-length) * (boolean2int (item i fish-biomass > 0) )]
  set fish-catch-boat n-values (number-of-species - 1) [i -> (item i fish-catch-boat + item i new-catch)]

  set fish-biomass n-values (number-of-species - 1 ) [i -> (item i fish-biomass - item i new-catch)] ; patch procedure?
  ;print (list fish-catch-boat)
  ;print (list fish-biomass)
  report new-catch
end

; This is a boat procedure
to-report should-go-fishing?
  ; if the weather is good and
  ; if this month's harvest is not sufficent
  ; a boat decides to go on a fishing trip.

  set prob-bad-weather random-float 1.00
  if random-float 1.00 < prob-bad-weather
    [ if gain-boat < 1.000 [
      report true]
  ]
end

; This is a boat procedure
; it describes a detailed single fishing trip starting and ending in the
; port.  It is implemented first for crangon only but should be extensible
; to other species.
to go-on-fishing-trip

  let navigable-patches patches with [accessible?]
  let time-step 0.1 ; in hours  (let's say 6 min)
  let time-at-sea 0 ; continuously record the time spent
  let time-left 72  ; a maximum of three days
  let haul-time 2   ; 2 hours for a typical haul time without change of direction
  let distance-at-sea 0 ; continuously record the distance travelled
  let distance-left steaming-speed * time-left ; at typical speed of 19 km / h this is 1368 km
  let new-catch n-values (number-of-species - 1) [i -> 0]
  let distance-to-alternative-patch 40 ;

  let home-port one-of link-neighbors  ; home-port of boats
  let s-patch [start-patch] of home-port    ; starting patch of the boat
  let l-patch [landing-patch] of home-port  ; landing patch of the boat
  let need-to-go-to-port? false ;

  print (list "Boat" who "leaves from" s-patch "with depth" ([depth] of s-patch))

  ; Move the boat to the starting patch and assume it steams there,
  ; thereby adding to trip time/length and subtracting from time and
  ; distance left
  pen-up
  move-to home-port
  set distance-at-sea distance-at-sea + gis-distance s-patch
  set distance-left distance-left - gis-distance s-patch
  set time-at-sea time-at-sea + gis-distance s-patch / steaming-speed
  set time-left time-left - gis-distance s-patch / steaming-speed
  move-to s-patch
  pen-down

  while [not need-to-go-to-port?] [

    let found? false
    let counter 0

    while [not found?] [
      set heading random 360
      set counter counter + 1
      let t-patch patch-ahead (fishing-speed * time-step)
      if (t-patch != nobody) [
        if ([depth] of t-patch > 0) [set found? true]
      ]
      if counter > 20 [set found? true]
    ]

    let t-patch patch-ahead (fishing-speed * time-step)
    ifelse (t-patch = nobody or [not accessible?] of t-patch) [
      print "Cannot find navigable patches ahead, going home"
      set need-to-go-to-port? true ; Is there the need to go to port? E.g. time is running out, catch is higher than capacity of the vessel
    ][
      ;print (list "Deploying gear in direction" heading)
    ]

    ; Deploy the gear for haul-time and go in a straight direction,
    ; observing every time step a possible change in the patch the
    ; boat is on
    repeat (haul-time / time-step) [
      set new-catch catch-species (time-step * fishing-speed)
      ask patch-here [
        set fishing-effort-hours fishing-effort-hours + time-step
      ]
      forward fishing-speed * time-step
    ]
    set time-left time-left - haul-time
    set distance-left distance-left - steaming-speed * haul-time
    set time-at-sea time-at-sea  + haul-time
    set distance-at-sea distance-at-sea + time-at-sea * fishing-speed

    ; If the catch is not worth keeping it, discard it entirely and
    ; reset the time left.  But if the catch is successful, then make
    ; sure that the timeout is maximum 24 hours
    ; @todo this is not properly implemented yet
    if (item 1 new-catch < min-fresh-catch and time-left < 24)[
      set time-left 24
    ]
    if (item 1 new-catch > min-fresh-catch and time-left > 24)[
      set time-left 24
    ]

    ; Evaluate whether to go home based on different criteria, i.e.
    ; capacity exceeded, too far from home port, or

    if (item 1 fish-catch-boat > vessel-size) [
      print (list "Boat" who "full. Needs to go back to port")
      set need-to-go-to-port? true
    ]
    if (gis-distance l-patch > distance-left) [
      print (list "Boat" who "went far enough, needs to go home to reach port")
      set need-to-go-to-port? true
    ]
    if (time-left < gis-distance l-patch / steaming-speed) [
      print (list "Boat" who "is running out of time, needs to go home to reach port")
      set need-to-go-to-port? true
    ]

    ; in case of a bad haul, select a different patch.
    ; for now, we choose a  neighbor patch, later we have to implement
    ; a procedure to find a patch approx 20 km away
    ; @todo check units
    ;if (false) [
    if (item 1 new-catch < min-fresh-catch) [
      let my-neighbors patches  with [accessible? and gis-distance l-patch < distance-left and gis-distance myself < distance-to-alternative-patch and gis-distance home-port > 5 ] ; @todo: currently set to 20, revise with respect to memorx
      ifelse any? my-neighbors [
        set s-patch one-of my-neighbors
        print (list "Boat" who "start a new haul at a different patch with depth" ([depth] of s-patch))
      ][
        print (list "Boat" who "could not find any navigable water, going home")
        set need-to-go-to-port? true
      ]
      move-to s-patch
      set distance-at-sea distance-at-sea + gis-distance s-patch
      set distance-left distance-left - gis-distance s-patch
      set time-at-sea time-at-sea + gis-distance s-patch / steaming-speed
      set time-left time-left - gis-distance s-patch / steaming-speed
    ]

    print (list "Boat" who heading time-at-sea time-left (gis-distance l-patch) distance-at-sea distance-left (item 1 fish-catch-boat) )
    ;print (list who ([depth] of patch-here))
  ]

  print "Returning to harbor..."

  pen-up

  set distance-at-sea distance-at-sea + gis-distance l-patch
  set time-at-sea time-at-sea + gis-distance l-patch / steaming-speed
  move-to l-patch

  ; @todo temporarily give this a price, needs to be a global property later
  let price-species  3 ; EUR kg-1

  set size 1
  ;calculate costs, revenue and profit
  set transportation-costs fuel-efficiency * oil-price * distance-at-sea
  set operating-costs wage * time-at-sea
  ;set costs-boat n-values (number-of-species - 1) [ i -> (transportation-costs * item i fish-catch-boat +  operating-costs * item i fish-catch-boat) / sum fish-catch-boat]
  ;set revenue-boat n-values (number-of-species - 1)[i -> (item i fish-catch-boat * price-species)] ; @todo needs to be solved, price is related to home-port
  ;set delta-gain-boat n-values (number-of-species - 1) [i -> (item i gain-boat) - (item i revenue-boat - item i costs-boat)]
  ;set gain-boat n-values (number-of-species - 1) [i ->  item i revenue-boat - item i costs-boat]
  ;set delta-priority-boat n-values (number-of-species - 1) [i -> adaptation * (item i delta-gain-boat) / (item i priority-boat)]
  ;set priority-boat n-values (number-of-species - 1) [i -> item i priority-boat - item i delta-priority-boat]
  print (list "Boat" who " has cost of " (transportation-costs + operating-costs) )
end

to-report boolean2int [x]
  ifelse x [report 1][report 0]
end

to-report gis-distance [x]
  report 4.5 * distance x ; one patch equals given 0.05° and therefore we need to muliply by 4.5 km  = 2.43 nm .... @todo needs to be adjusted
end

to create-effort-map

  ask patches [
    set fishing-effort-hours 0
  ]
  let my-boats boats
  ;repeat 16 [
    ask my-boats [go-on-fishing-trip]
  ;]

  ; data storage

  let dataset gis:patch-dataset fishing-effort-hours
  gis:store-dataset dataset "effort"

end

to calc-accessibility
  ask patches [set accessible? true]

  ask patches with [depth < navigable-depth] [set accessible? false]
  ask ports [
    ask patches with [distance myself < 5]  [set accessible? false]
  ]
  ask patches with [owf-fraction > 0.5] [set accessible? false]

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
22
105
88
138
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
21
201
113
246
view
view
"crangon" "platessa" "solea" "pollution (random)" "bathymetry" "effort (h)" "accessible?"
4

BUTTON
93
106
156
139
NIL
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
119
202
182
246
NIL
update
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
20
288
123
321
ports?
ports?
0
1
-1000

SLIDER
21
368
193
401
adaptation
adaptation
0
1
0.489
0.001
1
NIL
HORIZONTAL

SLIDER
21
327
193
360
memory-size
memory-size
0
100
47.0
1
1
NIL
HORIZONTAL

MONITOR
1087
383
1221
420
Date
datetime
17
1
9

SLIDER
7
482
254
515
fuel-efficiency
fuel-efficiency
0
1
0.198
0.001
1
NIL
HORIZONTAL

SLIDER
8
447
208
480
operating-costs-of-boats
operating-costs-of-boats
0
1
0.203
0.001
1
NIL
HORIZONTAL

SLIDER
258
483
430
516
oil-price
oil-price
0
100
50.0
1
1
NIL
HORIZONTAL

TEXTBOX
27
15
822
49
Agent-based model of North Sea fisheries (MuSSeL)
28
0.0
1

TEXTBOX
24
58
174
100
To operate the model, wait until the map is loaded and then click on \"go\". 
11
0.0
1

TEXTBOX
24
154
187
196
Change the background information here and hit \"update\"
11
0.0
1

BUTTON
484
454
654
542
Test
;test-target\nclear-drawing\n\nlet my-boats n-of 10 boats\nwatch one-of my-boats\nask  my-boats [go-on-fishing-trip]
NIL
1
T
OBSERVER
NIL
T
NIL
NIL
0

SLIDER
7
515
217
548
fraction-transportation-costs
fraction-transportation-costs
0
1
0.198
0.01
1
NIL
HORIZONTAL

BUTTON
870
467
965
500
save-effort
let dataset gis:patch-dataset fishing-effort-hours\ngis:store-dataset dataset \"effort\"
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
752
475
816
508
Effort
;test-target\nclear-drawing\n\nask patches [\nset fishing-effort-hours 0\n]\nlet my-boats boats\nrepeat 16 [\nask my-boats [go-on-fishing-trip] \n]\nset view \"effort (h)\" \nupdate\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
## Data sources

### Species probability presences

The data was obtained from Nik Probst, based on Random Forest species distribution modeling for Merlangus, Platessa, Solea, Crangon and Sprattus. Please do not distribute this unpublished data.  

### Bathymetry

Bathymetry data was obtained 2022-01-07 from GEBCO Compilation Group (2021) GEBCO 2021 Grid (https://doi.org/10.5285/c6612cbe-50b3-0cff-e053-6c86abc09f8f).

You can go to https://download.gebco.net to download the data as NetCDF, GeoTIFF, PNG and Esri ASCII.  

### Offshore wind farms

EmodNet provides human activities at https://www.emodnet-humanactivities.eu/download-data.php. After providing your country and sector, the wind farm polygon areas are freely available. 

#### Todo
- exclude boats from entering areas
- classify areas to restrict during certain years

### Swept-area ratio

This is a todo item.  The first goal of ours simulation environment would be to explain the SAR map from our simulation

### Waves

This is a todo item. Likely not relevant for spatial pattern, as the storminess is a global phenomenon and not a local one.   

#### Image-based processing 

Portable Network Graphics (png) images were used with the following projection information: 

```
nrows=120
ncols=180
xmin=2
ymin=53
xmax=10
ymax=56
projection=+proj=longlat +datum=WGS84 +no_defs
```

From the NetCDF, the range was restricted to -82 .. 0 m, then exported to `.ps` and further processed via `.pnm` to yield a `.png`.  The resulting file was then resampled to 180 x 120 pixels.

#### Georeferenced processing

The ESRII ASCII file was directly used (see code in `import-asc.nls`)

### License 

Copyright: Universität Hamburg and Helmholtz-Zentrum Hereon, 
Authors: Carsten Lemmen, Sascha Hokamp
License: Apache 2.0

We use cartographic data provided by Openstreetmap @copyright OpenStreetmap Contributors.
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
NetLogo 6.2.2
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="effort-map" repetitions="16" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>create-effort-map</go>
    <timeLimit steps="1000"/>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="view">
      <value value="&quot;bathymetry&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ports?">
      <value value="true"/>
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

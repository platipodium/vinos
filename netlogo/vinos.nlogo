; SPDX-FileCopyrightText: 2022-2023 Universität Hamburg
; SPDX-FileCopyrightText: 2022-2024 Helmholtz-Zentrum hereon GmbH
; SPDX-License-Identifier: Apache-2.0
;
; SPDX-FileContributor: Carsten Lemmen <carsten.lemmen@hereon.de>
; SPDX-FileContributor: Sascha Hokamp <sascha.hokamp@uni-hamburg.de>
; SPDX-FileContributor: Jieun Seo <jieun.seo@studium.uni-hamburg.de>

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
  "include/scene.nls"
  "include/prey.nls"
  "include/port.nls"
  "include/action.nls"
  "include/time-series.nls"
  "include/python.nls"
  "include/ci.nls"
  "include/video.nls"
  "include/output.nls"
]

; The following breeds are defined in include files
; breed [gears gear] ; defined in gear.nls
; breed [boats boat] ; defined in boat.nls
; breed [legends legend] ; defined in view.nls
; breed [preys prey] ; defined in prey.nls
; breed [ports port] ; defined in port.nls
; breed [actions action] ; defined in action.nls

globals [
  navigable-depth                    ; minimum depth where a boat can navigate
  min-fresh-catch                    ; wether the boat decides togo back to harbor, maybe change name

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

  home-ports                         ; agentset of breed ports

  scene-legend-n
  scene-legend-thresholds
  date-patch
  temp
  patch-prey-names

  water-patches

  fleet-monthly-hours              ; model diagnostic of the 12 recently simulated months' seahours
  fleet-monthly-effort-hours       ; model diagnostic of the 12 recently simulated month's efforts
  fleet-monthly-effort-mwatthours  ; model diagnostic of the 12 recently simulated month's efforts
  fleet-monthly-landing            ; model diagnostic of the 12 recently simulated months' landings
  fleet-monthly-revenue            ; model diagnostic of the 12 recently simulated months' revenue
  fleet-monthly-fuel               ; model diagnostic of the 12 recently simulated months' fuel consumption

  fleet-landing-climatology        ; observational data from Temming et al. https://doi.org/10.3354/meps12325
]

patches-own [

  ; Prey biomasses
  patch-prey-biomasses   ; current biomasses of the prey species

  crangon-summer                    ; data from TI @todo convert to vector of prey species
  crangon-winter
  platessa-summer
  platessa-winter
  solea-summer
  solea-winter

  ; Environmental boundary data
  pollution-exceedance

  depth
  owf-fraction
  accessible?                     ; false if not accessible to fishery for steaming
  unrestricted?                   ; false if close to port, too shallow, restricted area
  plaice-box?
  patch-only-nephrops?            ; true if in nephrops reservation area

  ; Diagnostics
  prey-catches                      ; annual prey catches
  cluster-fishing-efforts           ; fishing effort by cluster in hours
  cluster-prey-catches              ; preys caught by cluster
  area                              ; area of the patch
  distance-to-coast                 ; distance to nearest land
  distance-to-port                  ; distance to nearest port
  traffic-suitability               ; relative suitability due to traffic

  temporary                         ; temporary variable storage

  ; Monthly diagnostic storage
  patch-monthly-effort-hours
  patch-monthly-effort-mwatthours
  patch-monthly-swept-area
]

; ------------------------------------------------------------------------------------------
; The startup procedure is called when the model is opened by NetLogo.  This automates
; the execution of setup.  We use a fixed random seed to enable replicable simulations
to startup
  license-message
  random-seed 123456789
  setup
end


to setup
  clear-all

  ; First setup up the calendar.  The routine setup-calendar checks for
  ; existing date, if there is none, it sets to wall time +/- offset
  ; specified in slider
  set date nobody
  setup-calendar

  setup-globals

  setup-preys
  setup-gears ; gears depend on preys

  setup-maps

  calc-pollution
  calc-fish

  setup-ports
  calc-initial-values
  calculate-distance-to-port

  setup-boats
  setup-monthly

  setup-plots

  set scene-legend-n 9
  update-scene
  update-drawings
  setup-logo
  display

  reset-ticks
end

; this procedures resets all sliders to a reasonable default value
to setup-defaults
  set memory-size 25
  set adaptation 0.6
  set time-offset -92 ; months from today
  set oil-price 62 ; ct l-1
  set wage 80 ; € h-1
end


to setup-globals
  set min-fresh-catch 10
  set navigable-depth 2
  set boat-property-chooser "distance-at-sea"
  set scene "Bathymetry"
  setup-date-patch

  set fleet-landing-climatology (list 1.5 1.3 5.5 11 9 9 9 10.5 14 15 11.5 3.5)
end

to setup-date-patch
  set date-patch patch (max-pxcor - 8) (min-pycor + 2)
  update-date-patch
end

to setup-logo
  let _logo  bitmap:import "../assets/logo-mussel.png"
  set _logo bitmap:scaled _logo ( 0.5 * bitmap:width _logo) (0.5 * bitmap:height _logo)
  bitmap:copy-to-drawing _logo 0.01 * max-pxcor  2.65 * max-pycor
end

;-----------------------
to update-date-patch
  ask date-patch [
    set plabel-color ifelse-value storm? [blue + 3][
      ifelse-value holiday? [red + 3][
        ifelse-value ramadan? [yellow][white]
      ]
    ]
    set plabel datetime-string
  ]
end

to go

  advance-calendar
  update-date-patch

  ; Every new year recompute exclusion area from OWF
  if (time:get "dayofyear" date = 1) [ calc-accessibility ]

  ;let _total-prey-landed sum ([port-prey-landed] of ports)
  ; Todo: adjust price, leave for next version
  ; preis = a - b * h
  ; set price price - sum_boats (catch) * price-sensitivity

  calc-fish
  ;let _active-boats n-of 10 boats
  let _active-boats boats

  ; Enable a simulation with only one active boat that can be closely
  ; followed.  This is off by default
  ifelse one? [
    set _active-boats min-n-of 1 (boats with [boat-logbook != 0 ]) [who]
    let _boat one-of _active-boats

    if subject != _boat [
      ;watch _boat
      ;inspect _boat
    ]
  ][
    if subject != nobody [
      stop-inspecting subject
      ; need to unwatch, too
    ]
  ]

  let _boats _active-boats with [boat-hour < 24]
  while [count _boats > 0] [
    let _boats-in-phase _boats with [boat-trip-phase = 5]
    if any? _boats-in-phase [
      ;print (word "  .. landing " count _boats-in-phase " boats ..")
      ask _boats-in-phase [boat-land-port]
    ]
    set _boats-in-phase _boats with [boat-trip-phase = 4]
    if any? _boats-in-phase [
      ;print (word "  .. sending home " count _boats-in-phase " boats ..")
      ask _boats-in-phase [boat-return-port]
    ]
    set _boats-in-phase _boats with [boat-trip-phase = 3]
    if any? _boats-in-phase [
      ;print (word "  .. actively fishing " count _boats-in-phase " boats ..")
      ask _boats-in-phase [boat-make-haul]
    ]
    set _boats-in-phase _boats with [boat-trip-phase = 2]
    if any? _boats-in-phase [
      ;print (word "  .. choosing new start " count _boats-in-phase " boats ..")
      ask _boats-in-phase [boat-choose-start]
    ]
    set _boats-in-phase _boats with [boat-trip-phase = 1]
    if any? _boats-in-phase [
      ;print (word "  .. leaving port " count _boats-in-phase " boats ..")
      ask _boats-in-phase [boat-leave-port]
    ]
    set _boats-in-phase _boats with [boat-trip-phase = 0]
    if any? _boats-in-phase [
      ;print (word "  .. resting " count _boats-in-phase " boats ..")
      ask _boats-in-phase [boat-rest-port]
    ]
    set _boats _active-boats with [boat-hour < 24]
  ]
  ask boats [ set boat-hour boat-hour - 24 ]

  update-plots
  update-scene
  ;update-drawings
  update-actions
  update-output   ; updates the output diagnostics, see output.nls
  update-logbooks

  export-data
  save-totals

  tick
end

to calc-initial-values
  set sum-boats sum [sum port-clusters] of ports
end


;---------------------------------


to-report displayed
  report scene
end

to update-scene


  if any? legends [ask legends [die]]
  if any? legend-entries [ask legend-entries [die]]
  let n scene-legend-n

  ask water-patches [set plabel ""]

  carefully [show-dataset scene][print (word "Warning, scene " scene " cannot be displayed")]

  display
  if show-values? [show-values]
end

to update-scene-legend

  ; Create a background for drawing the legend
  ask patches with [pxcor >= min-pxcor + 2 and pxcor <= min-pxcor + 20
       and pycor > max-pycor - 22 - 3 * scene-legend-n and pycor < max-pycor - 20][set pcolor grey]

  let scene-legend-colors palette:scheme-colors "Sequential" "Reds" scene-legend-n

  if any? legends [ask legends [die]]
  foreach range scene-legend-n [ i ->
    create-legends 1 [
         set shape "square"
         set size 3
         setxy min-pxcor + 4  max-pycor - 20 - 3 * scene-legend-n + 1  + 3 * i
         set color item i scene-legend-colors
    ]
    create-legends 1 [
         set shape "square"
         set size 0.1
         setxy min-pxcor + 4 + 13 max-pycor - 20 - 3 * scene-legend-n + 1 + 3 * i - 1
         set label-color black ; if you want to color it, use item i scene-legend-colors
         set label formatted-number (item i scene-legend-thresholds) 5
    ]
  ]
end

; This is a dummy procedure and needs to be replace by actual pollution data.
to calc-pollution
  ask n-of 100 patches with [platessa > 0] [set pollution-exceedance random-float 2.0]
end

to-report grayscale [x]
  report (round (10 * (x mod 10))) / 10
end

; Patch procedures crangon, solea, and platessa report the seasonally-weighted
; area concentration of the three species calculated from their winter and summer
; values and weighted by day of year
to-report crangon
  let _correction-factor 1800
  let _resupply 0.01 ; 100% replacement in 100 days

  ifelse (is-list? patch-prey-names and is-list? patch-prey-biomasses)  [
    let _prey-index position "Shrimp" patch-prey-names
    report _resupply * _correction-factor * (
      (summer-weight * crangon-summer + (1 - summer-weight) * crangon-winter )
    ) +  (1 - _resupply) * item _prey-index patch-prey-biomasses
  ][
    report _correction-factor * (
      (summer-weight * crangon-summer + (1 - summer-weight) * crangon-winter )
    )
  ]
end

to-report solea
  let _correction-factor 15
  let _resupply 0.2

  ifelse (is-list? patch-prey-names and is-list? patch-prey-biomasses)  [
    let _prey-index position "Sole" patch-prey-names
    report _resupply * _correction-factor * (
      (summer-weight * solea-summer + (1 - summer-weight) * solea-winter )
    ) + (1 - _resupply) * item _prey-index patch-prey-biomasses
  ][
    report _correction-factor * (
      (summer-weight * solea-summer + (1 - summer-weight) * solea-winter )
    )
  ]
end

to-report platessa
  let _correction-factor 5
  let _resupply 0.2

  ifelse (is-list? patch-prey-names and is-list? patch-prey-biomasses)  [
    let _prey-index position "Plaice" patch-prey-names
    report _resupply  * _correction-factor * (
      (summer-weight * platessa-summer + (1 - summer-weight) * platessa-winter )
    ) + (1 - _resupply) * item _prey-index patch-prey-biomasses
  ][
    report _correction-factor * (
      (summer-weight * platessa-summer + (1 - summer-weight) * platessa-winter )
    )
  ]
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
    set prey-names (list "Sole" "Plaice" "Shrimp")
    set patch-prey-names (list "Sole" "Plaice" "Shrimp")
    set patch-prey-biomasses (list solea platessa crangon)
  ]
end

;to-report catch-species [haul-length]
  ; calculate the values for each patch and every target species
  ;(solea, platessa and crangon), i.e. biomass cath in kg

;  let ispecieslist n-values (number-of-gears) [igear -> position ([gear-species] of item igear boat-gears) prey-names ]

;  report n-values (number-of-gears) [ igear ->
;     (item igear catch-efficiency-boat) * (item (item igear ispecieslist) prey-biomasses)
;      * (([gear-width] of item igear boat-gears) * haul-length) * (boolean2int (item (item igear ispecieslist) prey-biomasses > 0) )
;  ]

;end

; This is a boat procedure
to-report should-go-fishing?
  ; if the weather is good and
  ; if this month's harvest is not sufficent
  ; a boat decides to start a fishing trip.

  set port-prob-bad-weather random-float 1.00
  if random-float 1.00 < port-prob-bad-weather [
    if boat-gains < 1.000 [ report true ]
  ]
  report false
end


to calc-accessibility
  setup-water-patches

  ask patches [set plaice-box? false]
  let _dataset load-dataset "Plaicebox"
  ask patches gis:intersecting _dataset [ set plaice-box? true ]

  ; Boats are not allowed within OWF areas
  update-owf
  ask patches with [owf-fraction > 0.5] [set accessible? false]

  ; Fishery is restricted in MPAs from 1 May 2023.  This needs to be refined
  ; TBB and OTB are not allowed in Borkum riffgrund
  ; TBB and OTB ar not allowed in Sylt west
  ; Small TBB are allowed in Sylt East
  if year > 2023 or (year = 2023 and month > 4) [
    ask patches gis:intersecting load-dataset "Natura2000" [ set accessible? false ]
  ]

  ; Fishery is excluded from national park from 1 Jan 2039 (hypothetical)
  if year > 2038  [
    ask patches gis:intersecting load-dataset "NP-SH" [ set accessible? false ]
    ask patches gis:intersecting load-dataset "NP-NS" [ set accessible? false ]
  ]
end


to setup-water-patches
  let depth-threshold -1

  ; By default, all patches are inaccessible
  ask patches [set accessible? false]

  ; Provide the SNS shape
  let _sns load-dataset "SNS"
  set water-patches patches gis:intersecting  _sns

  ; Creep-fill from maximum depth, assumed in the North Sea
  let my-patches max-one-of water-patches [depth]
  ask my-patches [set accessible? true]

  let new-patches nobody
  repeat max-pxcor * 2 [
    ask my-patches [
      set new-patches neighbors4 with [depth >= depth-threshold and not accessible?]
      ask new-patches [set accessible? true]
    ]
    set my-patches water-patches with [accessible? and (count neighbors4 with [accessible?]) < 4]
  ]

  ask patches with [not accessible?] [set depth min (list -2 depth)]
  set water-patches patches with [accessible?]

  ; Define a sponge layer around edge where we prevent boats to go
  let _sponge 3
  ask patches with [pxcor > max-pxcor - _sponge or pxcor < min-pxcor + _sponge or
    pycor > max-pycor - _sponge or pycor < min-pycor + _sponge] [set accessible? false]
end

; This observer procedure saves tabular data as a fleet average. It should be
; called by go each time step
; @todo expand to other gears, as this one
to save-totals
  let _boats boats with [boat-total-time-at-sea > 0 and ([gear-species] of item boat-current-gear-index boat-gears) =  "Shrimp"]
  let _count count _boats
  let _filename (word "results/total_avg_shrimp_" (time:get "year" start-date)
      "-"  (time:get "month" start-date) "-" (time:get "day" start-date) ".csv")

  if ticks = 0 [
    carefully [file-delete _filename][]
    file-open _filename
    file-print (word "# tick,year,month,day,doy,at-sea,fuel,landings,count")
    file-print (word "#     ,    ,     ,   ,   , d    , l  ,   kg   , ")
    file-close
  ]

  if any? _boats [
    file-open _filename
    file-print csv:to-row (list ticks
      (time:get "year" date)   (time:get "month" date) (time:get "day" date) (time:get "dayofyear" date)
      (sum [boat-total-time-at-sea ] of _boats / 365.25)
      (sum [boat-total-fuel] of _boats  )
      (sum [boat-total-landings] of _boats  )
      ;(sum [boat-total-fuel-consumption / boat-total-landings] of _boats / _count ) ; Fuel intensity
      ;(sum [boat-total-landings / boat-total-days-at-sea] of _boats / _count) ; LPUE
      _count
    )
    file-close
   ]
end

; The profile routine is called manually from the command line while we test
to profile
  let _n 5
  let _filename "results/profiler_data.csv"
  print (sentence "Started profiling for" _n "steps ..")
  ;setup
  profiler:start
  repeat _n [ go ]
  ;setup
  profiler:stop
  csv:to-file _filename profiler:data
  profiler:reset
  print (sentence ".. . saved profileing data in" _filename)
end

to license-message
  print "Viable North Sea"
  print ""
  print "Copyright 2022-2024 Helmholtz-Zentrum hereon GmbH"
  print "Copyright 2022-2023 Universität Hamburg"
  print "Copyright 2022-2023 Hochschule Bremerhaven"
  print ""
  print "Licensed under the Apache License, Version 2.0 (the 'License');"
  print "you may not use this file except in compliance with the License."
  print "You may obtain a copy of the License at"
  print "    http://www.apache.org/licenses/LICENSE-2.0"
  print ""
  print "Unless required by applicable law or agreed to in writing, software"
  print "distributed under the License is distributed on an 'AS IS' BASIS,"
  print "WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied."
  print "See the License for the specific language governing permissions and"
  print "limitations under the License."
  print ""
end

to update-logbooks
  ask boats with [boat-is-learning? and count boat-actions = memory-size] [
    set boat-is-learning? false
    if is-turtle? boat-logbook [
      ask boat-logbook [
        set logbook-file-name (word "results/logbook_" [who] of myself ".txt")
        if file-exists? logbook-file-name [carefully [file-delete logbook-file-name][]]
      ]
      boat-logbook-header
    ]
  ]
end

; export the data occording to the global variable output-frequency
to export-data
  if output-frequency = "none" [ stop ]
  if output-frequency = "daily" [
    save-dynamic-datasets stop
  ]
  if output-frequency = "weekly" and (time:get "dayofweek"  date mod 7) = 0 [
    ; on Sundays
    save-dynamic-datasets stop
  ]
  if output-frequency = "monthly" and (time:get "day"  date) = 1 [
    ; on the first of the month
    save-dynamic-datasets stop
  ]
  if output-frequency = "yearly" and (time:get "dayofyear"  date) = 1 [
    ; on the first of the year
    save-dynamic-datasets stop
  ]
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
days
30.0

BUTTON
13
89
79
122
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
177
159
222
scene
scene
"Shrimp" "Plaice" "Sole" "Effort h" "Effort MWh" "SAR" "Bathymetry" "Accessibility" "OWF" "Plaicebox" "Area" "Shore proximity" "Port proximity" "Depth" "Tide" "Action" "Traffic" "Catch" "GFW effort" "EMODnet effort"
6

BUTTON
83
90
152
123
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
160
177
215
221
update
update-scene
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
1244
123
1364
156
show-ports?
show-ports?
1
1
-1000

SLIDER
12
350
251
383
adaptation
adaptation
0
1
0.784
0.001
1
NIL
HORIZONTAL

SLIDER
12
309
253
342
memory-size
memory-size
0
50
20.0
1
1
NIL
HORIZONTAL

SLIDER
11
421
183
454
oil-price
oil-price
25
75
50.0
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
223
95
To operate the model, wait until the map is loaded and then click on \"go\".
11
0.0
1

TEXTBOX
13
143
219
185
Change the information for the basemap here and hit `update`
11
0.0
1

PLOT
332
595
719
745
catch
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
725
500
1003
620
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
726
626
1003
746
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
1247
57
1362
113
Additional \nforeground\ninformation, \nhit `update`
11
0.0
1

SWITCH
1244
199
1364
232
owf?
owf?
1
1
-1000

SWITCH
1243
241
1365
274
box?
box?
1
1
-1000

SWITCH
1242
282
1365
315
sar?
sar?
1
1
-1000

BUTTON
1240
320
1366
353
update-background
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

TEXTBOX
15
390
207
429
Diesel for ships is tax-exempt and \ncosts on average 0.5 € l-1
10
0.0
1

TEXTBOX
12
462
162
490
Staff costs are usually around 80 € h-1
11
0.0
1

SLIDER
10
492
182
525
wage
wage
50
120
50.0
5
1
€ h-1
HORIZONTAL

PLOT
9
595
327
745
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
9
541
164
586
boat-property-chooser
boat-property-chooser
"distance-at-sea" "capacity" "catch-efficiency" "gear" "engine" "capital" "length" "max-distance" "max-duration" "operating-costs" "prey" "steaming-speed" "time-at-sea" "time-at-sea-left" "fuel-cost" "trip-phase" "type" "boat-total-landings" "boat-total-fuel-consumption" "boat-total-days-at-sea" "effort h"
0

SWITCH
1244
160
1365
193
show-boats?
show-boats?
1
1
-1000

BUTTON
167
542
239
586
update-plot
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
1241
358
1368
391
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
156
91
246
124
one?
one?
1
1
-1000

SLIDER
12
271
252
304
time-offset
time-offset
-200
200
-24.0
1
1
months from now
HORIZONTAL

TEXTBOX
600
655
674
695
CSH = shrimp\nPLE = plaice\nSOL = sole\nTBB = beam trawl\nOTB = otter trawl
6
0.0
1

PLOT
1147
661
1375
781
action
NIL
# action
0.0
10.0
0.0
10.0
true
true
"plot-setup-action-histogram" "plot-update-action-histogram"
PENS

CHOOSER
1147
611
1298
656
action-chooser
action-chooser
"gain" "catch" "gear" "depth" "coast" "age"
0

BUTTON
1301
610
1375
656
update
plot-update-action-histogram
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
11
226
159
259
show-values?
show-values?
1
1
-1000

CHOOSER
1144
435
1293
480
monthly-chooser
monthly-chooser
"Fleet land. t" "Fleet revenue k€" "Fleet effort h" "Fleet seadays" "Effort MWh" "Effort h"
2

PLOT
1146
485
1374
605
Monthly statistics
Month
NIL
1.0
12.0
0.0
10.0
false
false
"plot-setup-month-histogram" "plot-update-month-histogram"
PENS

BUTTON
1299
436
1373
480
update
plot-update-month-histogram
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

OUTPUT
247
501
718
580
10

TEXTBOX
247
463
397
491
Shrimper fleet aggregated data (per vessel and year)
10
0.0
1

CHOOSER
1000
434
1138
479
output-frequency
output-frequency
"none" "daily" "weekly" "monthly" "yearly"
2

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

We acknowledge contributions from W. Nikolaus Probst, Seong Jieun, Verena Mühlberger, Kai Wirtz and Jürgen Scheffran for providing data, fruitful discussions and contributing to the ODD document. We thank all members of the MuSSeL consortium making this software relevant in a research context.  The development of the model was made possible by the grants 03F0862A, 03F0862C, 03F0862D, 03F0862E  "Multiple Stressors on North Sea Life" [4] within the 3rd Küstenforschung Nord-Ostsee (KüNO) call of the Forschung für Nachhaltigkeit (FONA) program of the Germany Bundesministerium für Bildung und Forschung (BMBF).


### License

Authors Carsten Lemmen, Sascha Hokamp, Serra Örey
Copyright 2022-2024 Helmholtz-Zentrum hereon GmbH, Universität Hamburg, Hochschule Bremerhaven

Licensed under the **Apache License, Version 2.0** (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0.

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

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
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
VIEW
338
71
658
191
0
0
0
1
1
1
1
1
0
1
1
1
0
319
0
119

MONITOR
7
64
135
113
Home port
NIL
3
1

MONITOR
7
10
261
59
Vessel information
NIL
3
1

MONITOR
8
126
241
175
user-id
NIL
3
1

MONITOR
11
192
167
241
Location
NIL
3
1

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

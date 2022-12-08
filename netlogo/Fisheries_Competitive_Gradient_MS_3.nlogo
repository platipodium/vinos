; SPDX-FileCopyrightText: 
; SPDX-License-Identifier:  Unlicensed
; Author: Sascha Hokamp <sascha.hokamp@uni-hamburg.de>
; Author: Jürgen Scheffran


globals [ L g f a b q_x q_y C x r_x r_y fishes fishers growth harv_x harv_y tot_harv c_x c_y u w1 w2 w3 w4 w5 w6 sum_w_c V K C_max
          Price u_x u_y w1_x w2_x w3_x w4_x w5_x w6_x sum_w_c_x w1_y w2_y w3_y w4_y w5_y w6_y sum_w_c_y v_x v_y rv_x rv_y sum_rv  w w_x w_y]

to setup
ca
set L 1000        ; carrying capacity
set g 0.2         ; growth rate
set f      0.5    ; fraction of capital
; Fishes  x   y
set a  [  1   2   ]   ; initial price
set b  [0.005 0.01]   ; price elasticity
set x  [500   500 ]   ; initial stock
;Fishers    1       2       3       4       5      6
set q_x  [0.002  0.0032  0.0044  0.0056  0.0068  0.008] ; catch efficiency of x
set q_y  [0.012  0.0102  0.0084  0.0066  0.0048  0.003] ; catch efficiency of y
set C    [10       10     10       10     10      10  ] ; the costs/efforts
set r_x  [0.5     0.5     0.5      0.5    0.5     0.5 ] ; preference of x
set r_y  [0.5     0.5     0.5      0.5    0.5     0.5 ] ; preference of y
set K    [100    100      100     100    100      100 ] ; capital

set fishes     n-values 2 [?]
set growth     n-values 2 [?]
set tot_harv   n-values 2 [?]
set Price      n-values 2 [?]

set fishers    n-values 6 [?]
set harv_x     n-values 6 [?]
set harv_y     n-values 6 [?]
set c_x        n-values 6 [?] ; unit cost of catching x
set c_y        n-values 6 [?] ; unit cost of catching y
set u_x        n-values 6 [?] ; intermediate to calculate the marginal value
set u_y        n-values 6 [?]
set u          n-values 6 [?] ; Benefits of each fisher efforts
set w1_x       n-values 6 [?] ; intermediate to calculate the marginal value
set w2_x       n-values 6 [?]
set w3_x       n-values 6 [?]
set w4_x       n-values 6 [?]
set w5_x       n-values 6 [?]
set w6_x       n-values 6 [?]
set w_x        n-values 6 [?]
set sum_w_c_x  n-values 6 [?]
set w1_y       n-values 6 [?]
set w2_y       n-values 6 [?]
set w3_y       n-values 6 [?]
set w4_y       n-values 6 [?]
set w5_y       n-values 6 [?]
set w6_y       n-values 6 [?]
set w_y        n-values 6 [?]
set sum_w_c_y  n-values 6 [?]
set w1         n-values 6 [?] ; Mutual coupling between efforts and values of fishers
set w2         n-values 6 [?]
set w3         n-values 6 [?]
set w4         n-values 6 [?]
set w5         n-values 6 [?]
set w6         n-values 6 [?]
set w          n-values 6 [?]
set sum_w_c    n-values 6 [?]
set V          n-values 6 [?] ; Value or profits
set C_max      n-values 6 [?] ;
set v_x        n-values 6 [?] ; marginal value of x
set v_y        n-values 6 [?] ; marginal value of y
set rv_x       n-values 6 [?]
set rv_y       n-values 6 [?]
set sum_rv     n-values 6 [?]

calc_intermediate
calc_derivative
calc_value

foreach fishes [
  set growth   replace-item ? growth   (g * item ? x * (1 - (item ? x / L)))
  set tot_harv replace-item 0 tot_harv (sum harv_x)
  set tot_harv replace-item 1 tot_harv (sum harv_y)
  set Price replace-item ? Price (item ? a - (item ? b * item ? tot_harv))

]

reset-ticks
end

to go

 if ticks > run-length [stop]

foreach fishers [
  set C   replace-item ? C   (item ? C + (kappa * item ? C * (item ? C_max - item ? C) * (item ? u - item ? sum_w_c - item ? w)))
  set rv_x replace-item ? rv_x (item ? r_x * item ? v_x)
  set rv_y replace-item ? rv_y (item ? r_y * item ? v_y)
  set sum_rv replace-item ? sum_rv (item ? rv_x + item ? rv_y)
  set r_x replace-item ? r_x (item ? r_x + (alpha * item ? r_x * (item ? v_x - item ? sum_rv)))
  set r_y replace-item ? r_y (item ? r_y + (alpha * item ? r_y * (item ? v_y - item ? sum_rv)))
  set K replace-item ? K (item ? K + item ? V)
]

foreach fishes [
  set x        replace-item ? x        (item ? x + item ? growth - item ? tot_harv)
  set growth   replace-item ? growth   (g * item ? x * (1 - (item ? x / L)))
]

calc_intermediate
calc_derivative

foreach fishes [
  set tot_harv replace-item 0 tot_harv (sum harv_x)
  set tot_harv replace-item 1 tot_harv (sum harv_y)
  set Price replace-item ? Price (item ? a - (item ? b * item ? tot_harv))
]

calc_value
 tick
end

to calc_intermediate
foreach fishers [
  set c_x replace-item ? c_x ( 1 / (item ? q_x * item 0 x))
  set c_y replace-item ? c_y ( 1 / (item ? q_y * item 1 x))
  set harv_x replace-item ? harv_x (item ? r_x * item ? C / item ? c_x)
  set harv_y replace-item ? harv_y (item ? r_y * item ? C / item ? c_y)
  set u_x replace-item ? u_x (item 0 a / item ? c_x)
  set u_y replace-item ? u_y (item 1 a / item ? c_y)
  set u replace-item ? u ((item ? u_x * item ? r_x) + (item ? u_y * item ? r_y) - 1)
  ]
end

to calc_derivative
foreach fishers [
  set w1_x replace-item ? w1_x (item 0 b * item ? r_x / ( item ? c_x * item 0 c_x )  * item ? C)
  set w2_x replace-item ? w2_x (item 0 b * item ? r_x / ( item ? c_x * item 1 c_x )  * item ? C)
  set w3_x replace-item ? w3_x (item 0 b * item ? r_x / ( item ? c_x * item 2 c_x )  * item ? C)
  set w4_x replace-item ? w4_x (item 0 b * item ? r_x / ( item ? c_x * item 3 c_x )  * item ? C)
  set w5_x replace-item ? w5_x (item 0 b * item ? r_x / ( item ? c_x * item 4 c_x )  * item ? C)
  set w6_x replace-item ? w6_x (item 0 b * item ? r_x / ( item ? c_x * item 5 c_x )  * item ? C)
  set w_x  replace-item ? w_x  (item 0 b * item ? r_x / ( item ? c_x * item ? c_x )  * item ? C)
  set sum_w_c_x replace-item 0 sum_w_c_x (sum w1_x)
  set sum_w_c_x replace-item 1 sum_w_c_x (sum w2_x)
  set sum_w_c_x replace-item 2 sum_w_c_x (sum w3_x)
  set sum_w_c_x replace-item 3 sum_w_c_x (sum w4_x)
  set sum_w_c_x replace-item 4 sum_w_c_x (sum w5_x)
  set sum_w_c_x replace-item 5 sum_w_c_x (sum w6_x)

  set w1_y replace-item ? w1_y (item 1 b * item ? r_y / ( item ? c_y * item 0 c_y ) * item ? C)
  set w2_y replace-item ? w2_y (item 1 b * item ? r_y / ( item ? c_y * item 1 c_y ) * item ? C)
  set w3_y replace-item ? w3_y (item 1 b * item ? r_y / ( item ? c_y * item 2 c_y ) * item ? C)
  set w4_y replace-item ? w4_y (item 1 b * item ? r_y / ( item ? c_y * item 3 c_y ) * item ? C)
  set w5_y replace-item ? w5_y (item 1 b * item ? r_y / ( item ? c_y * item 4 c_y ) * item ? C)
  set w6_y replace-item ? w6_y (item 1 b * item ? r_y / ( item ? c_y * item 5 c_y ) * item ? C)
  set w_y  replace-item ? w_y  (item 1 b * item ? r_y / ( item ? c_y * item ? c_y ) * item ? C)
  set sum_w_c_y replace-item 0 sum_w_c_y (sum w1_y)
  set sum_w_c_y replace-item 1 sum_w_c_y (sum w2_y)
  set sum_w_c_y replace-item 2 sum_w_c_y (sum w3_y)
  set sum_w_c_y replace-item 3 sum_w_c_y (sum w4_y)
  set sum_w_c_y replace-item 4 sum_w_c_y (sum w5_y)
  set sum_w_c_y replace-item 5 sum_w_c_y (sum w6_y)

  set w1 replace-item ? w1 ((item ? w1_x * item 0 r_x) + (item ? w1_y * item 0 r_y))
  set w2 replace-item ? w2 ((item ? w2_x * item 1 r_x) + (item ? w2_y * item 1 r_y))
  set w3 replace-item ? w3 ((item ? w3_x * item 2 r_x) + (item ? w3_y * item 2 r_y))
  set w4 replace-item ? w4 ((item ? w4_x * item 3 r_x) + (item ? w4_y * item 3 r_y))
  set w5 replace-item ? w5 ((item ? w5_x * item 4 r_x) + (item ? w5_y * item 4 r_y))
  set w6 replace-item ? w6 ((item ? w6_x * item 5 r_x) + (item ? w6_y * item 5 r_y))
  set w  replace-item ? w  ((item ? w_x  * item ? r_x) + (item ? w_y  * item ? r_y))
  set sum_w_c replace-item 0 sum_w_c (sum w1)
  set sum_w_c replace-item 1 sum_w_c (sum w2)
  set sum_w_c replace-item 2 sum_w_c (sum w3)
  set sum_w_c replace-item 3 sum_w_c (sum w4)
  set sum_w_c replace-item 4 sum_w_c (sum w5)
  set sum_w_c replace-item 5 sum_w_c (sum w6)
]
end

to calc_value
foreach fishers [
  set V replace-item ? V ((item ? u - item ? sum_w_c) * item ? C)
  set C_max replace-item ? C_max ( f * item ? K)
  if item ? C_max < 0 [
  set C_max replace-item ? C_max   ( 0 )]
  set v_x replace-item ? v_x ((item ? u_x - item ? sum_w_c_x - item ? w_x) * item ? C)
  set v_y replace-item ? v_y ((item ? u_y - item ? sum_w_c_y - item ? w_y) * item ? C)
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
129
21
374
214
16
16
4.91
1
10
1
1
1
0
1
1
1
-16
16
-16
16
0
0
1
ticks
30.0

BUTTON
134
46
197
79
NIL
setup
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
223
47
296
81
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
172
102
242
136
go-once
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
132
175
296
208
run-length
run-length
0
100
30
1
1
NIL
HORIZONTAL

PLOT
562
11
951
312
Stock and Harvest
Year
Stock and Harvest
0.0
30.0
0.0
600.0
true
true
"" ""
PENS
"Stock x" 1.0 0 -16777216 true "" "plot item 0 x"
"Stock y" 1.0 0 -2674135 true "" "plot item 1 x"
"Harvest x" 1.0 0 -13345367 true "" "plot item 0 tot_harv"
"Harvest y" 1.0 0 -13840069 true "" "plot item 1 tot_harv"

PLOT
957
13
1365
314
Effort
Year
Effort
0.0
30.0
-5.0
30.0
true
true
"" ""
PENS
"1" 1.0 0 -7500403 true "" "plot item 0 C"
"2" 1.0 0 -955883 true "" "plot item 1 C"
"3" 1.0 0 -1184463 true "" "plot item 2 C"
"4" 1.0 0 -8630108 true "" "plot item 3 C"
"5" 1.0 0 -13791810 true "" "plot item 4 C"
"6" 1.0 0 -2064490 true "" "plot item 5 C"

PLOT
955
323
1368
655
Preference
Year
NIL
0.0
30.0
0.0
1.0
true
true
"" ""
PENS
"1" 1.0 0 -7500403 true "" "plot item 0 r_y"
"2" 1.0 0 -955883 true "" "plot item 1 r_y"
"3" 1.0 0 -1184463 true "" "plot item 2 r_y"
"4" 1.0 0 -8630108 true "" "plot item 3 r_y"
"5" 1.0 0 -13791810 true "" "plot item 4 r_y"
"6" 1.0 0 -2064490 true "" "plot item 5 r_y"

CHOOSER
40
229
178
274
Interaction
Interaction
"competition" "cooperation"
0

CHOOSER
254
231
392
276
Strategy
Strategy
"gradient" "optimizing"
0

PLOT
1381
13
1789
313
Profit
Year
Profit
0.0
30.0
-15.0
45.0
true
true
"" ""
PENS
"1" 1.0 0 -7500403 true "" "plot item 0 V"
"2" 1.0 0 -955883 true "" "plot item 1 V"
"3" 1.0 0 -1184463 true "" "plot item 2 V"
"4" 1.0 0 -8630108 true "" "plot item 3 V"
"5" 1.0 0 -13791810 true "" "plot item 4 V"
"6" 1.0 0 -2064490 true "" "plot item 5 V"

PLOT
1380
324
1793
659
Capital
Year
Capital
0.0
30.0
0.0
250.0
true
true
"" ""
PENS
"1" 1.0 0 -7500403 true "" "plot item 0 K"
"2" 1.0 0 -955883 true "" "plot item 1 K"
"3" 1.0 0 -1184463 true "" "plot item 2 K"
"4" 1.0 0 -8630108 true "" "plot item 3 K"
"5" 1.0 0 -13791810 true "" "plot item 4 K"
"6" 1.0 0 -2064490 true "" "plot item 5 K"

PLOT
559
325
946
657
Price
Year
Price
0.0
30.0
0.0
2.5
true
true
"" ""
PENS
"x" 1.0 0 -16777216 true "" "plot item 0 price"
"y" 1.0 0 -2674135 true "" "plot item 1 price"

SLIDER
135
293
307
326
alpha
alpha
0
0.1
0.05
0.01
1
NIL
HORIZONTAL

TEXTBOX
322
299
444
327
Adaptation rate to change the preference
11
0.0
1

SLIDER
138
347
310
380
kappa
kappa
0
0.01
0.002
0.001
1
NIL
HORIZONTAL

TEXTBOX
326
353
449
381
Adaptation rate to change the effort
11
0.0
1

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
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
NetLogo 5.3.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
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

---
title: "A shrimper's tale"
tags:
  - NetLogo
  - Agent-based Model
  - ABM
  - North Sea
  - Fisheries
  - MuSSeL project
  - VIABLE
  - ViNoS
  - Logbook
authors:
  - name: Carsten Lemmen
    orcid: 0000-0003-3483-6036
    affiliation: 1
    corresponding: true
  - name: Serra Örey
    orcid: 0000-0003-3483-6036
    affiliation: 3
affiliations:
  - name: Helmholtz-Zentrum Hereon, Institute of Coastal Systems - Modeling and Analysis, Germany, carsten.lemmen@hereon.de
    index: 1
  - name: Hochschule Bremerhaven, Research Cluster Life Sciences, Bremerhaven, Germany
    index: 3
date: 17 Nov 2023
year: 2023
SPDX-FileCopyrightText: 2023  Helmholtz-Zentrum hereon GmbH
SPDX-License-Identifier: CC-BY-4.0
SPDX-FileContributor: Carsten Lemmen
---

# A shrimp fisher's personal account

Edda Bakker is owner and captain of a small shrimper boat. Her boat "Linda" is anchored in the Northern German coastal town Norddeich (7.1583°E, 53.625°N). Linda was built in 1972, and with a length of 24 m is one of the larger coastal fishery shrimpers. She's equipped with a 215 kW engine, just below the critical limit of 221 kW that carries restrictions on where to fish. Usually, Linda -- painted in the Frisian colors green, white and red, makes about 8.5 knots (15.7 km/h) in open water, and about 5 knots when the two 10-m beams to the right and left trawl the seafloor for shrimp.

Edda's family operates three boats out of Norddeich: next to Linda, there's her brother Jost's boat Dorsch IV, and her mother Bentje's Dock III. Overall, eleven shrimpers operate out of the port of Norddeich. Actually, there is no captain Edda in Norddeich, nor is there a boat called "Linda", but she could be one of the virtual boats whose activities are simulated in our educational computer model "Viable North Sea". You can download this model and experience, even influence Edda's actions in this interactive model simulation. Here's the outcome, as a commented log book, of such a simulation.

## The departure

```{.txt}
2022-04-21 15:01 7.1583°E 53.625°N Leaving port Norddeich
2022-04-21 15:30 7.1125°E 53.6875°N Arrived in open water
2022-04-21 15:30 7.1125°E 53.6875°N Estimated gains at prior locations are [14 27 6] €
2022-04-21 15:30 7.1125°E 53.6875°N Remembered location at (patch 203 26) with expected gain 27 €
2022-04-21 15:30 7.1125°E 53.6875°N Corrected target patch to (patch 203 27)
2022-04-21 15:36 7.0875°E 53.6875°N Steamed here with speed 16 km h-1 to sail 2 km
2022-04-21 15:36 7.0875°E 53.6875°N No other boats here, will deploy gear here
2022-04-21 15:36 7.0875°E 53.6875°N Found suitable straight-line fishing path in direction 269°N
```

[A shrimper from the North Sea port Fedderwardersiel with beam trawl. Photo pixabay/Wolfgang Claussen](https://pixabay.com/get/g427e7d61142817d668ba8d8ef6e7f7538a552e46878a7b63e498bdba3930249a7693d5069b68ad82edf04b321c45b36b813282b7cfec9607dc7f780470ef8a5d6019f483d8e203a5f2487691a74d2b12_1280.jpg?attachment=)

As most days, on this 21st of April Linda leaves the port, arrives in open water and Edda calculates expected catches and gains near Linda's current location, based on prior fishing trips. She chooses one of those locations, steams there, lays out a straight line haul path with no other ship obstructing this path.

## A single haul

```{.txt}
2022-04-21 15:42 7.0734°E 53.6873°N Trawl net gained 2.9 kg
2022-04-21 15:48 7.0594°E 53.687°N Trawl net gained 2 kg
2022-04-21 15:54 7.0453°E 53.6868°N Trawl net gained 2 kg
2022-04-21 16:00 7.0313°E 53.6865°N Trawl net gained 1 kg
2022-04-21 16:06 7.0172°E 53.6863°N Trawl net gained 1 kg
2022-04-21 16:12 7.0032°E 53.686°N Trawl net gained 1.2 kg
2022-04-21 16:18 6.9891°E 53.6858°N Trawl net gained 1.2 kg
2022-04-21 16:24 6.975°E 53.6855°N Trawl net gained 1.7 kg
2022-04-21 16:30 6.961°E 53.6853°N Trawl net gained 1.7 kg
2022-04-21 16:36 6.9469°E 53.685°N Trawl net gained 1.8 kg
2022-04-21 16:36 6.9469°E 53.685°N Hauled 16.4 kg abord
2022-04-21 16:36 6.9469°E 53.685°N Need to return within next 24 hours to keep catch fresh
```

Once at a suitable location, the gear is lowered into the water and the trawl begins. Usually, a single haul lasts one hour, and every 6 minutes the weight change in the dragged net is recorded to monitor the catch. Today, the net is filling only slowly and after 1 hour 16.4 kg shrimp are hauled abord. Well, better than nothing: Edda makes a not to return within the next 24 hours to land the catch while it's still fresh.

## Zigzagging the sea

```{.txt}
2022-04-21 16:36 6.9469°E 53.685°N So far spent 2 h and 15 km at sea
2022-04-21 16:36 6.9469°E 53.685°N Estimate to have left 24 h and 605 km on this trip
2022-04-21 16:36 6.9469°E 53.685°N Home is 0.7 h or 11 km away
2022-04-21 16:36 6.9469°E 53.685°N Found suitable straight-line fishing path in direction 87°N
2022-04-21 16:42 6.9609°E 53.6858°N Trawl net gained 3 kg
2022-04-21 16:42 6.9609°E 53.6858°N Noting this trip's best location (patch 198 27) catching 3 kg
2022-04-21 16:48 6.975°E 53.6865°N Trawl net gained 1.8 kg
[...]
2022-04-21 17:36 7.087°E 53.6924°N Trawl net gained 1.9 kg
2022-04-21 17:36 7.087°E 53.6924°N Hauled 16.4 kg abord
```

The Linda zigzags back on a southerly course for the next haul. Edda monitors the fuel remaining, the freshness of the catch and the distance from her home port Norddeich; she also records the best locations during each haul.

```{.txt}
2022-04-21 17:36 7.087°E 53.6924°N Found suitable straight-line fishing path in direction 266°N
[...]
2022-04-21 18:36 6.9473°E 53.6826°N Hauled 15.5 kg abord
[...]
2022-04-21 18:36 6.9473°E 53.6826°N Found suitable straight-line fishing path in direction 86°N
[...]
2022-04-22 04:36 6.94°E 53.6789°N Hauled 18.8 kg abord
2022-04-22 05:36 7.0804°E 53.674°N Hauled 14.6 kg abord
2022-04-22 06:36 6.9398°E 53.6716°N Hauled 20.6 kg abord
2022-04-22 12:36 6.9544°E 53.7057°N Hauled 13.5 kg abord
2022-04-22 16:36 6.9717°E 53.7129°N Hauled 15.6 kg abord
2022-04-22 16:36 6.9717°E 53.7129°N So far spent 26 h and 141 km at sea
2022-04-22 16:36 6.9717°E 53.7129°N Home is 0.6 h or 10 km away
2022-04-22 16:36 6.9717°E 53.7129°N Need to return to safely get home with available fuel
```

Forth and back, forth and back. The Linda keeps zigzagging along a north-south path for 24 more hours, until it is time to head back to port.

```{.txt}
2022-04-22 17:14 7.1125°E 53.6875°N Arrived at port entry location
2022-04-22 17:43 7.1583°E 53.625°N Arrived in port Norddeich
2022-04-22 17:43 7.1583°E 53.625°N Landed  394.3 kg Shrimp
2022-04-22 17:43 7.1583°E 53.625°N Sold fish for 1971 €
2022-04-22 17:43 7.1583°E 53.625°N Consumed 1636 l diesel at 50 ct l-1,  costing 818 €
2022-04-22 17:43 7.1583°E 53.625°N Paid 1335 € for wages
2022-04-22 17:43 7.1583°E 53.625°N Made net gain -181 €
2022-04-22 17:43 7.1583°E 53.625°N Update existing least gain location with catch 3 => 3.9 kg
2022-04-22 17:43 7.1583°E 53.625°N Other boats here in Norddeich [Dock III Port IV Dorsch IV Ada III Garn VI Garn V Lena IV Olga V Saga III]
2022-04-22 19:43 7.1583°E 53.625°N Finished unloading, cleaning and refuelling Linda, now rest for 8 hours
```

After almost 27 hours, Linda is back in Norddeich. Although she has a capacity of over 2 tons, on this trip only 394 kg of shrimp were caught. Edda and her crew unload the cooked and frozen shrimp from this trip: At a current wholesale price of 5 EUR per kg, the sale of these yields 1971 EUR in revenue. Edda's cost calculation reveals that she paid 1636 EUR for fuel, and should pay 1335 in wages for her crew and herself. But the income does not cover these coast, so she'll deduct 181 EUR from her own payment; Edda hopes for a better catch on the next trip. But first, the Linda has to be cleaned, refuelled and the crew needs to rest.

## Ups and downs

```{.txt}
2021-10-02 11:15 7.1583°E 53.625°N Made net gain 8461 €
2021-10-04 12:04 7.1583°E 53.625°N Made net gain -1922 €
2021-10-06 06:50 7.1583°E 53.625°N Made net gain 302 €
2021-10-09 05:24 7.1583°E 53.625°N Made net gain -1128 €
2021-10-11 20:39 7.1583°E 53.625°N Made net gain -2130 €
2021-10-14 02:19 7.1583°E 53.625°N Made net gain -1163 €
2021-10-16 18:49 7.1583°E 53.625°N Made net gain -2848 €
2021-10-18 00:49 7.1583°E 53.625°N Made net gain -3317 €
2021-10-20 14:09 7.1583°E 53.625°N Made net gain 696 €
2021-10-23 18:47 7.1583°E 53.625°N Made net gain -3021 €
2021-10-25 15:25 7.1583°E 53.625°N Made net gain 584 €
2021-10-27 14:22 7.1583°E 53.625°N Made net gain 8351 €
```

October should be the best month to catch shrimp. Later in the year, Edda looks back at her calculations for October. Overall, she went out on 12 trips, and made a net gain of 1500 EUR, but only thanks to two exceptionally good trips on the second and the 27th, where she made a fortune. In between, there were severe losses, with really bad days where she lost over 3000 EUR on a single trip.

## Bad expectations

```{.txt}
2023-01-08 00:00 7.1583°E 53.625°N Won't go out this Saturday at all
2023-01-09 00:00 7.1583°E 53.625°N Won't go out this Sunday at all
2023-01-09 12:00 7.1583°E 53.625°N I feel it's not worth it, let's wait for 12 h
2023-01-10 00:00 7.1583°E 53.625°N I feel it's not worth it, let's wait for 12 h
2023-01-10 12:00 7.1583°E 53.625°N I feel it's not worth it, let's wait for 12 h
2023-01-11 00:00 7.1583°E 53.625°N I feel it's not worth it, let's wait for 12 h
2023-01-11 12:00 7.1583°E 53.625°N I feel it's not worth it, let's wait for 12 h
2023-01-12 00:00 7.1583°E 53.625°N I feel it's not worth it, let's wait for 12 h
2023-01-12 12:00 7.1583°E 53.625°N I feel it's not worth it, let's wait for 12 h
2023-01-13 00:00 7.1583°E 53.625°N I feel it's not worth it, let's wait for 12 h
2023-01-13 12:00 7.1583°E 53.625°N I feel it's not worth it, let's wait for 12 h
2023-01-14 00:00 7.1583°E 53.625°N I feel it's not worth it, let's wait for 12 h
2023-01-15 00:00 7.1583°E 53.625°N Won't go out this Saturday at all
2023-01-16 00:00 7.1583°E 53.625°N Won't go out this Sunday at all
2023-01-16 00:00 7.1583°E 53.625°N Need to wait for high water for 7.77 hours
2023-01-16 07:46 7.1583°E 53.625°N Leaving port Norddeich
2023-01-16 08:44 7.1583°E 53.625°N Arrived in port Norddeich
2023-01-16 08:44 7.1583°E 53.625°N Landed  0 kg Shrimp
```

As on so many occasions in wintertime, the expectation for catching shrimp is low. While it is best in October, January is a particularly difficult time. So many days, the Linda simply stays in the port; Edda does not feel that it would be worth to go out. On the 16th of January, Edda, however, makes another attempt. And catches nothing.

## Try yourself

How could a viable shrimp fishery for the North Sea look like? What happens if more areas are closed to fisheries and reserved for nature protection and offshore energy production? And how do fishermen and women at our coast adapt to rising diesel prices and a potential migration of their preferred target with Climate Heating? We developed the Viable North Sea model to tackle these questions.

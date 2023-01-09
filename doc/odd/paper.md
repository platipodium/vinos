---
title: 'ODD Protocol for the NetLogo Agent-based Model of North Sea Fisheries'
tags:
  - NetLogo
  - Agent-based Model
  - ABM
  - North Sea
  - Fisheries
  - MuSSeL project
  - ODD
authors:
  - name: Jieun Seo
    affiliation: 1
  - name: Carsten Lemmen
    orcid: 0000-0000-0000-0000
    affiliation: 2
    corresponding: true
affiliations:
 - name: Helmholtz-Zentrum Hereon, Germany
   index: 2
 - name: University of Hamburg, Germany
   index: 1
date: 2 January 2023
SPDX-FileCopyrightText: 2023 University of Hamburg
SPDX-FileCopyrightText: 2023 Helmholtz-Zentrum hereon GmbH
SPDX-License-Identifier: CC-BY-4.0
---

# ODD Protocol: Netlogo North Sea Fisheries

1. **Purpose (****still not clear, partly from the MuSSeL website, include environmental impacts or not?****)**

This model is designed to investigate how animal life at the seafloor in the Southern North Sea will be affected by interactions between geophysical drivers (warming, alteration of transports) and human activities (fisheries, offshore wind farms (OWF)). It also explores the adaptive behavior of the fishing industry coping with changing environments, area closures such as OWFs, and the distribution of target fish in pursuing economic profits.

1. **Entities, state variables and scales**

1. **Entities**

There are four types of entities in the model.

1. The boats, the main agents, that perform fishing activities such as organizing fishing trips, earning profits from the fish catch, and deciding the priorities of target fish: There are 214 boats that belong to a specific port.
2. The gears which are equipment for catching fish and affect the environment on the seafloor: There are three types of gear targeting a specific fish species in all the boats.
3. The fishing area in the Southern North Sea, where the boats go fishing, characterized by depth, distribution and abundance of target fish, closures such as OWFs and plaice-box, and accessibility.
4. The port where the assigned boats start a fishing trip and dock to unload and sell their catch of fish: There exist 54 ports in the model landscape.

1. **State variables (****include all the variables or only important ones?****)**

The entities are characterized by state variables (e.g., boat capacity, catch of fish, fishing speed, and steaming speed, location of ports etc.) as shown in Table 1-4.

| **State variables** | **Description** | **Unit** |
| --- | --- | --- |
| Boat-capacity |
 |
 |
| Boat-engine-power |
 |
 |
| Fishing-speed |
 |
 |
| Steaming-speed |
 |
 |
| Fish-catch-boat |
 |
 |
| Catch-efficiency-boat |
 |
 |
| Revenue-boat |
 |
 |
| Costs-boat |
 |
 |
| Gain-boat |
 |
 |
| Delta-gain-boat |
 |
 |
| Boat-priorities |
 |
 |
| Boat-delta-priorities |
 |
 |
| Transportation-costs |
 |
 |
| Operating-costs |
 |
 |
| Wage |
 |
 |
| Boat-gears |
 |
 |

Table 1 State variables of the boats

| **State variables** | **Description** | **Unit** |
| --- | --- | --- |
| Gear-name |
 |
 |
| Gear-species |
 |
 |
| Gear-width |
 |
 |
| Gear-drag |
 |
 |
| Gear-installation-cost |
 |
 |
| Gear-purchase-cost |
 |
 |

Table 2 State variables of the gears

| **State variables** | **Description** | **Unit** |
| --- | --- | --- |
| Fish-biomass |
 |
 |
| Fishing-effort-hours |
 |
 |
| Depth |
 |
 |
| Owf-fraction |
 |
 |
| Plaice-box? |
 |
 |
| Accessible? |
 |
 |

Table 3 State variables of the fishing area

| **State variables** | **Description** | **Unit** |
| --- | --- | --- |
| Kind |
 |
 |
| Name |
 |
 |
| Country |
 |
 |
| Latitude |
 |
 |
| Longitude |
 |
 |
| Start-patch |
 |
 |
| Landing-patch |
 |
 |
| Price |
 |
 |
| Vessels-per-port |
 |
 |
| Pro-bad-weather |
 |
 |

Table 4 State variables of the ports

1. **Scale and extent**

One tick represents 72 hours for one fishing trip and simulations run for years. During one trip, boats change direction to move forward every two hours and the routes of boats are updated every second. One grid cell represents 5.5 km by 5.5 km and the model landscape consists of 320 x 120 cells (check).

1. **Process overview and scheduling**

1. Boats start a fishing trip from a home port for the next 3 days (72 hours) and return to a landing port at a steaming speed of 19 km/h. While fishing, boats move at slower speeds of which average and standard deviation are 3 km/h and 0.5 km/h, respectively.
2. They randomly choose a direction to move forward by targeting a patch navigable and keep going in the same direction for 2 hours. The straight-line fishing trip for 2 hours is defined as a haul. If they fail to find a navigable patch after 20 attempts, they decide to go home.
3. While moving to the targeted patch, they catch fish, and the amount of fish caught is calculated for each gear every six minutes. The fish catch per gear is a product of fish stock (fish biomass) on the path, gear (haul) width, haul length, gear priority, and catch efficiency.
4. After each haul, the boats evaluate the performance of the haul. If the haul is good enough, they reset the time to 24 hours even though the time left is more than 24 hours. As for the bad haul, they reset the time to 24 hours with a remaining time of fewer than 24 hours and choose an alternative patch within a 40 km distance as a start point (check). Regardless of the haul performance, they return to a landing site once out of capacity or time.
5. During the trip, fish catch, time spent at sea, and trip distance are accumulated for each boat.
6. After returning to the landing port, boats calculate how much gain they earn from the fishing trip by subtracting costs from revenues for each fish species. The revenue is given by multiplying the fish catch with the fish price. The price for each fish species is calculated using landing data from the home port. The costs include transportation and operation costs. The former is a function of fuel efficiency, oil price, the trip distance at sea, and fish catch, while the latter is the result of the multiplication of wage, time at sea, and fish catch.
7. Based on the gains for each fish species, fishers (boats) assess which fish species is more profitable and increase the priority of more cost-effective fish species for the next time step. When modifying the priorities, an adaptation rate is considered, which is a rate for fishers to adapt to a changing environment, for instance, by retooling their equipment.
8. With the changed fish priorities, the boats start a new fishing trip.

1. **Design concepts**

1) Basic principles

2) Emergence

3) Adaptation

4) Objectives

6) Learning

7) Prediction

8) Sensing

9) Interaction

There are interactions between boats and the environment. However, no direct interaction within boats is involved in the model.

10) Stochasticity

11) Collectives

12) Observation

1. **Initilization**

1. **Inputs**

1. **Sub-models**


# Questions (those not yet moved to issues)

## Things to be cleaned or fixed

- Parts not used: learning before choosing direction, action breeds (clean?)
- Variables not used (clean?)
- Different gear order in a list of boat-gears for the boats. For example, (gear 0, gear 1, gear2) for boat 1 or (gear 1, gear 2, gear 0) for boat 2, etc.: fixed on the GitHub (27th 12)
- Still minus priorities: fixed GitHub (27th 12)
- Some variables (e.g., fish catch) need to be reset after one trip?

1. What do we expect from the model or purpose (unclear)?

1. Routes of boats: random direction + considering bad haul, boat capacity, and remaining time (related to when to return)
2. Increasing fish catch by changing boat (gear) priority over time
3. Increasing profits by changing boat (gear) priority over time
4. Interaction between geophysical drivers (climate change, environmental impacts) and human activities (fishery)? At the moment, not considered.

1. Next step (including questions about the existing plan)

- Do fish stocks remain the same not affected by fish catch and reproduction?
- Do we use different fish stocks depending on seasons, not only in summer?
- Add variabilities of boats (size or engine power, preferred-distance, catch-efficiency, …)?
- Prices of fish not affected by the market or total fish catch?
- Environmental impacts: seabed, climate change (temperature, salinity, etc.)
- Adaptation by agents

1. Oil prices increase: stay less at sea (reducing time available), increase minimum fish catch when deciding to return. The other way around for decrease in oil prices
2. Response to environmental impacts (e.g., changing fish stock due to climate change -\> fish catch -\> fish priorities)
3. Learning about profitable routes?

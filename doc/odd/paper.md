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
  - name: Carsten Lemmen
    orcid: 0000-0000-0000-0000
    affiliation: 2
    corresponding: true
    email: carsten.lemmen@hereon.de
  - name: Jieun Seo
    affiliation: 1
  - name: Sascha Hokamp
    affiliation: 1
  - name: Serra Örey
    affiliation: 3
affiliations:
 - name: Helmholtz-Zentrum Hereon, Germany
   index: 2
 - name: University of Hamburg, Germany
   index: 1
 - name: Hochschule Bremerhaven, Germany
   index: 3
date: 21 March 2023
SPDX-FileCopyrightText: 2023 University of Hamburg
SPDX-FileCopyrightText: 2023 Helmholtz-Zentrum hereon GmbH
SPDX-License-Identifier: CC-BY-4.0
---

# ODD Protocol: German North Sea Small-scale Fisheries

The Agent-based Model (ABM) of the German North Sea Small-scale Fisheries is a Social-Ecological Systems (SES) model focussing on the adaptive behaviour of fishers facing regulatory, economic, and resource changes.  The model description follows the ODD (Overview, Design concepts, Details) protocol for describing individual- and agent-based models (Grimm et al. 2006, 2010).  By following this  protocol, we aim to document the ABM such that it is replicable independently of the current implementation (in NetLogo, @Wilensky2010). 
 
## Purpose

Small-scale fisheries are an important part both of the cultural perception of the German North Sea coast and of its fishing industry. These fisheries are typically family-run operations that use smaller boats and traditional fishing methods to catch a variety of bottom-dwelling species, including plaice, sole, brown shrimp.

Fisheries in the North Sea face area competition with other uses of the sea -- long practiced ones like shipping, gas exploration and sand extractions, and currently increasing ones like marine protection and offshore wind farming (OWF).  German authorities have just released a new maritime spatial plan implementing the need for 30% of protection areas demanded by XXX and allowing up to 70 GW of offshore wind power generation.  

Fisheries in the North Sea also have to adjust to the northward migration of their established resources following the climate heating of the water.  And they have to re-evaluate their economic balance by figuring in the foreseeable rise in oil price and the need for re-investing into their aged fleet.

The **purpose** of this ABM is to provide an interactive simulation environment that describes spatial, temporal and structural adaptations of the fleet.  It adaptively describes
 
 * where to fish  and how far to go out to sea
 * how often to go out
 * what gear to use and what species to target

Its **scope** is the German North sea small-scale fisheries.  This encompasses some 300 vessels based in German ports along the North Sea coast and fishing in the German Bight, including but not restricted to Germany's exclusive economic zone (EEZ). The target species is currently restricted to the most important ones: plaice, sole and brown shrimp, but is in principle extensible to further target species like Norwegian lobster or whiting. 

The **intended audience** of the ABM are marine researchers and government agencies concerned with spatial planning, environmental status assessment, and climate change mitigation.  It can also assist in a stakeholder dialogue with tourism and fishers to contextualize the complexity of the interactions between fisheries economics, changing resources and regulatory restrictions.  It is intended to be used for scenario development for future sustainable fisheries at the German North Sea coast.

## Entities, state variables, and scales	

The primary agents in the ABM are the fishing vessels, denoted as *boats*.  They are linked to supplementary classes of agents that describe the *gears* used for fishing, the target species denoted as *preys* and the *ports* that are home to the boats. The agents interact with the *environment* that describes the *spatial domain* and resource and regulatory changes.

### The primary agent: boats

Boats are located at ports, according to the distribution of the German fleet in those ports.  In the German fleet there are four distinct clusters of small-scale fisheries vessels  that have typical vessel and crew size,  gear and fishing strategy (@Örey2023).  With those come physical  (speed, length, capacity, engine power) and economic properties (fixed and variable costs). 

Boats go on fishing trips and record the catch and the revenue. They internally record the economic balance of their activites and continuously adapt preferences, e.g., for choosing a specific gear.  

### Subsidiary agents: ports, preys, gears

Ports, preys, and gears are inactive agents that are introduced to structure the model in object-oriented design and encapsulated their state variables and methods.

Ports can be boats' home or favourite landing **ports**. Boats start their activity from a port and dock to unload at a port.  They can stay in a port when deciding not to fish.  Along the German coast, there are 54 ports, for which boat and landing statistics are available.   At the ports, the simulated landings are recorded.

The fishery target species are denoted **preys**.  Currently, the ABM describes three different species:

| **Prey instance** |  **Description** | **Picture** |
| Crangon | The brown shrimp *Crangon crangon* .. | ![../../figures/320px-Crangon_crangon.jpg] |
| Pleuronectes| The place *Pleuronectes platess* ...| ![../../figures/319px-Pleuronectes_platessa.jpg] |
| Solea| The sole *Solea solea* ...| ![../../figures/Solea_solea_1.jpg] |

The model is designed to accomodate further species relevant to the small-scale fishery such as whiting (*Merlangius merlangus*), sprat (*Sprattus sprattus*), or norwegian lobster (*Nephrops norvegicus*).

Boats and preys are connecte via the **gears** agent.  The gear prescribes the geometric area that can be fished, the speed at which fishing can occur, and the prey that is caught.  A gear can be installed, or changed, on a boat, subject to economic (invvestment cost) and physical (weight, size) constraints.  The gear also determines the impact of the fishing activity on the environment, i.e. how much prey is removed and how much of the sea floor is swept.

### Spatial units

The spatial domain is described by a grid, whose cells (in NetLogo: patches) carry spatial information on the environment and record spatial information.  The domain itself is the German Bight including Germany's EEZ.  It is represented geographically in the WGS84 datum, and bounded by the rectangle spanned by the coordinates (2° E; 53°N) and (10° E; 56 °N); the resolution is 0.025 x 0.025 degree (1.5 arc minutes, or approximately 1.7 x 2.9 km).  The resulting grid has a size of 320 columns x 120 rows.

The domain is divided into an active part (water) and an inactive part (land).  The demarcation between land and water is achieved by using the GEBCO bathymetry and assigning water to cells with positive depth.  Using a creep-fill algorithm and filtering Baltic waters east of 9.25° E, a continuous accessible domain is calculated.

Cells carry information on resources (fish stocks of the respective species), regulatory fishery closure areas (offshore wind and exclusion zones).  They record activity of the fishery occuring in the grid cell as area swept and as hours fished.

### Nonspatial environment

A calendar records time.  The temporal domain are multiple years and the temporal resolution is 1 day.  With the progress of the calendar, surrogate weather is introduced that may influence a boat's decision to go on a fishing trip.  Seasonal information is used to describe the annual variation of prey resources.  

## Process overview and scheduling


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

There are interactions between boats and the environment. Hcowever, no direct interaction within boats is involved in the model.

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

---
title: "Evasive and adaptive strategies of German brown shrimp fisheries to area closures for offshore wind and marine protection"
keywords: "NetLogo; Agent-based Model; ABM; North Sea; Fisheries; MuSSeL project; ODD; VIABLE; ViNoS"
journal: comses
csl-refs: true
type: protocol
classoption: moreauthors=true
status: accept
author:
  - name: Carsten Lemmen
    orcid: 0000-0003-3483-6036
    affil: 1
  #  - name: Sascha Hokamp
  #    affil: 2
  #    orcid: 0000-0002-2192-4013
  - name: Serra Örey
    affil: 3
    orcid: 0000-0003-3483-6036
#  - name: Jürgen Scheffran
#    affil: 2
#    orcid: 0000-0002-7171-3062
correspondence: C. Lemmen <carsten.lemmen@hereon.de>
affiliation:
  - address: Helmholtz-Zentrum Hereon, Institute of Coastal Systems - Analysis and Modeling, Max-Planck-Str. 1, 21502 Geesthacht, Germany
    num: 1
    email: carsten.lemmen@hereon.de
  - address: Universität Hamburg, Centre for Earth System Research and Sustainability (CEN), Bundesstrasse 53, 20146 Hamburg, Germany
    num: 2
  - address: Hochschule Bremerhaven, Research Cluster Life Sciences, An der Karlstadt 8, 27568 Bremerhaven, Germany
    num: 3
citation_author: Lemmen et al.
year: 2024
license: CC-BY-4.0
bibliography: Lemmen2024_etal_icesjmarinescience.bib
SPDX-FileCopyrightText: 2024 Helmholtz-Zentrum hereon GmbH
#SPDX-FileCopyrightText: 2023 Universität Hamburg
#SPDX-FileCopyrightText: 2023 Hochschule Bremerhaven
SPDX-License-Identifier: CC-BY-4.0
abstract: "The German North Sea shrimp fishery is a traditional sector of near-coastal and local fishery encompassing roughly 200 boats distributed in 20 ports along the German East Frisian and North Frisian coast.  Their fishing grounds traditionally overlap with the Wadden Sea World Heritage marine protected area (MPA) and - to a lesser extent - with areas that could be reserved for other uses in the recent and future Marine Spatial Plan.  The pressure to close these areas to fishery comes from both nature protectino, not the least the United Nations High Seas Treaty to protect 30% of the world's oceans, of which 1/3 should be no-use area, and from the national energy targets to provide up to 70 GW energy from OWF. We here explore different plausible scenarios of area closure for OWF and MPA to shrimp fishery, using the novel Viable North Sea (ViNoS) agent-based model.  We confirm previously formulated expectations of fishers that their mode of subsistence would be unsustainable given the many area closures, and we quantify foreseen economic losses.  At the same time, we are able to demonstrate the existence of adaptive strategies that could mitigate the impact of area closures lead to economically and ecologically viable shrimp fishery in the next two decades."
acknowledgement: "The authors thank W.N. Probst for providing species distribution data as a forcing to this model.  We thank Kai W. Wirtz, S. Hokamp, J. Scheffran for intensive discussions on the results of the model.  The development of the model was funded by the German Ministry of Education and Research through the KüNO project 'Multiple Stressors on North Sea Life' (MuSSeL) with grant number 03F0862A.  We are grateful for the open source community that facilitated this research, amongst them the developers of and contributors to NetLogo, Python, R, pandoc, LaTeX, and many others."
conflictsofinterests: "The authors declare that no conflict of interest has arisen from this work."
abbreviations:
  - short: ABM
    long: "Agent-based Model"
  - short: ODD
    long: "Overview, Design concepts, Details"
  - short: OWF
    long: "Offshore Wind Farm"
  - short: DES
    long: "Discrete Event Simulation"
  - short: EEZ
    long: "Exclusive Economic Zone"
  - short: FAO
    long: "United Nations Food and Agricultural Organization"
  - short: GEBCO
    long: "General Bathymetry Chart of the Oceans"
  - short: HCR
    long: "Harvest Control Rule"
  - short: MPA
    long: "Marine Protected Area"
  - short: MSC
    long: "Marine Stewardship Council"
  - short: MuSSeL
    long: "Multiple Stressors on North Sea Life"
  - short: TAC
    long: "Total Allowable Catch"
  - short: ViNoS
    long: "Viable North Sea"
  - short: VIABLE
    long: "Values and Investments from Agent-Based interaction and Learning in Environmental systems"
---

# Introduction

<!-- Cultural and economic value -->

The German North Sea shrimp fishery is a traditional sector of near-coastal and local fishery encompassing roughly 200 boats distributed in 20 ports along the German East Frisian and North Frisian coast. It's economic value is estimated at XXXX M€ annually, employing roughly XXXX people directly, and sustaining the livelihood of XXXX communities along the coast. Processing and distribution of shrimp employs another XXX people and ultimatle yupports up to XXXX people.

<!-- Characterization of shrimper -->

The shrimper vessels are typically small near-coastal vessels with a gross weight of XXX tons, length between XXXX m and holding capacity of XXX kg shrimp. They are typically staffed by one up to three persons, and go on fishing trips between a few hours and a few days. The gears typically used by shrimper vessels is bottom-touching trawling gear, using a pair of beam trawls (ICES classification TBB) of each 4-10 m length. From the 20 ports of landing, the product is shipped to one of three processing plants, then sent overseas for peeling; small quantities are sold locally from the harbour unpeeled. One company (De Beer) controls the processing, shipping, and redistribution to the wholesale market.

<!-- Environmental impact -->

The shrimp fishery has long been under scrutiny from nature protection aspects because of its disturbance effect on the sea floor. CITATIONS
No area of today's North Sea can be claimed to be free of such disturbance, and much of the ocean floor is disturbed several times per year. This has been known for long, in fact, when the Wadden Sea heritage area was established in 1991, the shrimp fishers were granted an exception for their use.

In the North Sea, the German small-scale fishing fleet's biggest group are the shrimp beam trawlers. This small-scale fishing fleet is typically run by owner-operated family enterprises that uses boats smaller than 24 meters [@Döring2020]. These vessels' target species are mainly demersal (living near the bottom), and include plaice, sole, and brown shrimp [@Letschert2023].

Fisheries in the North Sea face area competition with other uses of the sea -- long practiced ones like shipping, gas exploration and sand extraction, and currently increasing ones like marine protection areas and offshore wind farms (OWF, @stelzenmuller2022plate). German authorities released a new maritime spatial plan in 2023 for implementing the need for 30% of protection areas demanded by the United Nations High Seas Treaty and aiming at up to 70 GW of offshore wind power generation by 2045 [@WindSeeG2023].

The North Sea brown shrimp (_Crangon crangon_, Brown shrimp, Nordseekrabbe) has no catch restriction concerning a maximum allowable catch. Because of its very short life cycle, reliable stock estimates are not yet established. Since 2011 the fishery uses the harvest control rule (HCR) as a management measure. Beam trawlers between 12-24 m are the most important segment within both the Dutch and German coastal fleet. Currently, nets have a standard cod end and diamond mesh sizes of 20 mm. For the voluntery Marine Stewardship Certification (MSC) process sieb nets are required by the certified vessels to reduce bycatch and bigger mesh sizes are in discussion. There is no area restrictions apply to shrimp fishers in the German North Sea [@aviat2011north,@ICES2019wgcran].

Shrimp typically occur in high numbers at the edge of tidal channels, so also a the edge of navigational channels. Traffic on the North Sea has seen an increase by XXX % in the recent two decades, driving shrimp fishers away from shrimp-rich navigational channels.

<!-- @todo  in theory the german EEZ allready is protected by about 30% https://www.bfn.de/nationale-meeresschutzgebiete#anchor-6205, hmm, in EEZ 8000/28500 km2 protected, i.e. 28%, (only german) -->

In XXX, the United Nations High Seas Treaty was agreed upon, aiming at protecting 30% of the world's oceans, and declaring no-use zones in on third of those areas, effectively barring 10% of the world's oceans from any use. In 2023, this lead to new regulation in Germany regarding the protection levels of the already exsiting MPAs Borkum riffgrund and Sylter Außenriff. Within these, a partial closure to fishery activity - including shrimp fishing - was achieved. In addition, the XXXX commission discussed lifting the excpetion for Shrimp fishery within the Wadden Sea effective 2025. Though this plan was dismissed, it stirred unrest in the fishery community (XXXX). Less overlapping with the traditional shrimp fishery grounds are areas now (or in the future to be) reserved for offshore wind farming. The 70 GW energy production aim described in the National strategy XXX mostly claims offshore areas affecting other fisheries; only a small area south of Borkum Riffgrund is claimed for both OWF and brown shrimp fishery activity.

In this study we apply for the first time the novel Viable North Sea (ViNoS) agent-based model of German small-scale fisheries. We establish that it is able to represent past and current spatial distribution and economic balance of the German brown shrimp fishery, and generate scenarios for areas claimed for OWF or MPA. We investigate the reaction of artificial fishers in the model context to these area closures, and evaluat its economic impact. We also explore potential adaptations in the fishery's behavior that mitigates area closures and helps to ensure a sustainable future fishery under new area constraints.

# Material and Methods

Viable North Sea (ViNoS) is an Agent-based Model (ABM) of the German North Sea Small-scale Fisheries in a Social-Ecological Systems (SES) framework focussing on the adaptive behaviour of fishers facing regulatory, economic, and resource changes. The numerical model's Overview, Design concepts, and Details (ODD) have been published by @Lemmen2023; the ViNoS software itself is published as open source [@Lemmen2024].
The purpose of this ABM is to provide an interactive simulation environment that describes spatial, temporal and structural adaptations of the fleet. It adaptively describes (1) where to fish and how far to go out to sea; and (2) how often to go out.
Its scope s the German North sea small-scale fisheries. This encompasses some 300 vessels based in German ports along the North Sea coast and fishing in the German Bight, including but not restricted to Germany's exclusive economic zone (EEZ). The currently simulated target species are the three most important ones: plaice, sole and brown shrimp.

<div>
<!-- Original picture is 22,26 x 14,89 cm -->
![Primary and subsidiary agents of the ViNoS ABM.\label{fig:agents}](../../assets/agents.pdf){ width=75% height=30% }
</div>

## Agents in ViNoS

Boats are located at ports, according to the empirical distribution of the German fleet in those ports. In the German fleet there are four distinct clusters of small-scale fisheries vessels that have typical vessel and crew size, gear and fishing strategy [@Oerey2023]. With those come physical (speed, length, capacity, engine power) and economic properties (fixed and variable costs). Boats have a catch efficiency that tries to model the experience of the individual boat owners. Boats go on fishing trips and record the catch and the revenue. They internally record the economic balance of their activites and continuously adapt priorities, e.g., for choosing a specific gear, based on value gains.

Ports, preys, and gears are immobile agents that are introduced to structure the model in object-oriented design and encapsulated their state variables and methods.
Ports are the boats' favourite landing ports. Boats start their activity from a port and dock to unload at a port. They can stay in a port when deciding not to fish. Along the German North Sea coast, there are 54 ports for which boat and landing statistics are available. At the ports, the simulated landings are recorded.

Boats and preys are connected via the _gears_ agent: The gear prescribes the geometric area that can be fished, the speed at which fishing can occur, and the prey that is caught. A gear can be installed, or changed, on a boat, subject to economic (investment cost) and physical (weight, size) constraints. The gear also determines the impact of the fishing activity on the environment, i.e. how much prey is removed and how much of the sea floor is swept as the beam size of the gear changes depending on the target species.

The spatial domain is described by a grid, whose cells carry spatial information on the environment and record activity information. The domain itself is the German Bight including Germany's EEZ. It is represented geographically in the WGS84 datum and as equilateral cells in latitude and longitude, thus corresponding to the Concise Spatial QUery And REpresentation System (c-squares) on which much of the reported data is available. The model domain is bounded by the rectangle spanned by the coordinates (2° E; 53° N) and (10° E; 56° N); the resolution is 0.025 x 0.025 degree (1.5 arc minutes, or approximately 1.7 x 2.9 km). The resulting grid has a size of 320 columns x 120 rows.

The domain is divided into an active part (water) and an inactive part (land). The demarcation between land and water is achieved by using the General Bathymetry Chart of the Oceans (GEBCO) bathymetry bounded by European Environmental Agency's coastline dataset. Using a creep-fill algorithm a continuous accessible domain is ensured.
Cells carry information on shrimp resources, and regulatory fishery closure areas (offshore wind and trawling exclusion zones). They record activity of the fishery occuring in the grid cell as area swept and as hours fished.

The temporal domain is multiple years and the temporal resolution is 1 day. With the progress of the calendar, surrogate weather is introduced that may influence a boat's decision to go on a fishing trip. Seasonal information is used to describe the annual variation of prey resources.

<!-- @todo  Make landings a prognostic variable for ports -->

# Results

# Discussion

Some of the ecomonically important species in the North Sea show a northward habitat shift due to the climate change related warming of the water [@dulvy2008climate]; this suggests that also the fishing grounds may have to shift. Moreover, fishers have to re-evaluate their economic balance by figuring in the foreseeable rise in oil price, price fluctuations related to the oligopolic processing market, and the need for re-investing into their aging vessels [@Goti-Aralucea2021].

# Conclusion

<!-- @todo  Add the change of gear -->
<!-- @todo  Add SAR diagnostic -->
<!-- @todo  Add removal and recovery of prey -->

<!-- @todo Use the weather -->

## Process overview and scheduling

The global timestep of the model is one day. Within the 24-hour period, we use Discrete Event Simulation (DES) to trigger the action of boats within 6 phases:

| **Phase**     | **Location** | **Description**                            |
| ------------- | ------------ | ------------------------------------------ |
| Phase 0 rest  | port         | Boats are resting, not ready to go out     |
| Phase 1 ready | port-sea     | Boats are ready to go out and are deployed |
| Phase 2 steam | sea          | Boats steam in open water                  |
| Phase 3 fish  | sea          | Boats fish open water                      |
| Phase 4 steam | sea          | Boats need to return                       |
| Phase 5 land  | port         | Boats are offloading                       |

: The 6 phases used with Discrete Event Simulation in ViNoS.

Boats cycle through all phases consecutively, keeping a record of how much time they spend. Boats in **phase 0** keep the legal resting time of 11 hours, and rest during the weekend (from Saturday noon to Monday 4 am, as well as on holidays). After the resting period, they make a decision on whether to go out or not. This decision may depend on weather and seasonally expected catch. If the decision is positive, a boat enters phase 1. Boats in **phase 1** directly (straight line, without environmental sensing) steam from the port location to the port's closest open sea deployment location. Adding this phase makes it possible for the ports to be located on dry ground at the available grid resolution, as many ports are located upstream of the coastline demarcation. Having arrived at the deployment location, boats enter phase 2.

Boats in **phase 2** steam to a preferred location for the next fishing haul. This preferred location is individually chosen by proximity to prior successful hauls, but constrained by fuel limitation, maximum distance, cargo shipping activity, and presence of other fishing boats. Phase 2 may also be entered after an unsuccessful fishing haul. At the new location, a boat enters **phase 3** for fishing. Fishing is done in several hauls; a haul is directed across only accessible water, and at the end of a haul the ship turns around (with slight variation) and continues to the next haul.

To record the fishing activity on the cells, a haul is subdivided into time substeps of 6 minutes duration. The time spent in a cell and the area swept is recorded for the gear with the highest priority. The catch is calculated separately for each gear (and the gear-associated target species), taking into account the target species' biomass at the haul location, the gear width and haul distance and the boat's catch efficiency.
Hauls are repeated until one of the following constraints is met (always taking into account the time and fuel cost of the return trip):

1. The maximum preferred time at sea is exhausted;
2. the maximum time from the first successful catch (24 hours to keep fresh) is exhausted;
3. the fuel is exhausted;
4. the loading capacity is exhausted;
5. the catch is considered insufficient.

<div>
![Decision pathway for a simulated fishing trip.\label{fig:flowchart}](../../assets/abm_flowchart.pdf){ width=90% height=30% }
</div>

On an insufficient catch, the boat enters phase 2 to look for a different location. On a successful catch and after having spent the allocated time or fuel, the boat enters phase 4. Boats in **phase 4** need to return. They directly steam in a straight line to their deployment location and on to their port. At the port, they enter **phase 5** to unload their catch and clean the boat. Priorities for the different gears are updated based on the relative change of the deployed gears and catches.
Finally, boats re-enter phase 0 and restart the cycle. A summary view of the model scheduling is depicted in \autoref{fig:flowchart}.

## Design concepts

### Basic principles

<!-- German authorities have just released a new maritime spatial plan implementing the need for 30% of protection areas demanded by the United Nations High Seas Treaty and aiming at up to 70 GW of offshore wind power generation by 2045.  -->

The ABM is an adaptive model with the **objective** of increasing value gains (here: net profits), subject to environmental, economic, and individual constraints. The **adaptation** is currently restricted to changing gear with shifting priorities for allocating fishing effort, and described by the ABM framework VIABLE (Values and Investments from Agent-Based interaction and Learning in Environmental systems) [@BenDor2019;@Scheffran2000].

| **Symbol** | **Description**                                                                                                               |
| ---------- | ----------------------------------------------------------------------------------------------------------------------------- |
| $k$        | Action pathway, here: gear selected out of $m$ possibilities $k = 1\ldots m$.                                                 |
| $C$        | Cost of a haul, composed of time-dependent cost (e.g. wages) and distance costs (fuel), measured in €                         |
| $H$        | Fish catch, or harvest, during a haul measured in kg. Calculated from catch efficiency $e$, prey density $X$, and effort $E$. |
| $E$        | Effort of fishing activity measured in hours. Fishers typically fish 1500 to 2000 hours per year.                             |
| $X$        | Density of fish at fishing ground, expressed in kg m^-2^ trawled.                                                             |
| $e$        | Catch efficiency, expressed in units of m^2^ h^-1^.                                                                           |
| $p$        | Price of the fish, expresses in € kg^-1^.                                                                                     |
| $V$        | Value, here: net gain of haul, i.e. fish catch $H$ times price $p$ minus cost $C$, measured in €.                             |
| $r_k$      | Priority for action pathway $k$ with $0\leq r_k\leq 1$ and $\sum_1^m r_k = 1$.                                                |
| $v_k$      | Marginal change of value with priority $v_k=\partial{V}/\partial{r_k}$, expressed in €.                                       |
| $a$        | Adaptation rate (sensitivity) of a change in priority from a change in value.                                                 |

: Notation used in the VIABLE approach.

In the VIABLE approach, each boat carries a list of priorities for certain fishing actions that are subject to change based on the boat’s perception and evaluation of its activities. During each haul, the costs of that haul (wage and fuel) $C$ are subtracted from the benefits, i.e. the income from the catch (harvest) $H$ times the market price $p$ for each fish:

$$
V = p H - C.
$$

The fish catch $H$ from a haul is a function of fishing effort $E$ (in work hours), density of a particular fish species $X$ in the area of fishing and the catch efficiency $e$ for the respective gear type interacting with this particular fish:

$$
H = e X E.
$$

If for each boat there are several gear types (termed "action pathways" in the VIABLE approach) $k = 1 \ldots m$ available, according to the gradient decision rule each agent changes priority $r_k$ in proportion to the product of marginal value $v_k$ and priority $r_k$ for each gear type, multiplied by an adaptation rate $a$ determining how strong agents adapt action to value.
The marginal value van be the change in $V_k$ when choosing priority $k$ or in mathematical terms the partial derivative of the value function with respect to priority $v_k=\partial{V}/\partial{r_k}$, if that function is known.
Althogether, the temporal change of the priorities $r_k$ is given by

$$
\frac{dr_k}{dt} = a r_k \cdot \frac{v_k - \sum r_k v_k }{\sum v_k}
$$

Both sums are for normalisation purposes to make sure that all priorities add up to 1. The first sum means that pathways $k$ with marginal value above average $v_k$ increase and below average decrease, indicating a competition to select the "better" gear.

### Learning

To enable learning, boats implement a memory of best hauls, recording the amount caught and the cell location. This memory has size 20. After a training phase, boats may choose to steam preferentially to one of the best 10 past experienced locations to start fishing. Boats sense the resource availability of each cell, as well as global fuel prices and port-dependent market prices.

Ports and boats are initialized from empirical statistics available for the year 2015. The resources are initialized from a species distribution model (SDM) based on stock assessments and environmental data for the period 2015-2020. Time is initialized with current wall clock time.

| **Description**                                        | **Source**                                                                            |
| ------------------------------------------------------ | ------------------------------------------------------------------------------------- |
| Clustered vessel data                                  | Hochschule Bremerhaven                                                                |
| Species distribution of plaice, sole, and brown shrimp | Thünen Institute                                                                      |
| Species information                                    | Food and Agriculture Organization (FAO)                                               |
| Bathymetry                                             | General Bathymetry Chart of the Oceans (GEBCO)                                        |
| Offshore Wind Farms (OWF)                              | European Commission, European Marine Observation and Data Network (EMODnet)           |
| Exclusive economic zone (EEZ)                          | United Nations Convention on the Law of the Sea                                       |
| Subregional divisions                                  | International Council for the Exploration of the Seas (ICES) Spatial Facility         |
| Plaice box                                             | European Commision                                                                    |
| Geodetic information                                   | International Earth Rotation Service (IERS)                                           |
| National Park boundaries                               | Niedersächsischer Landesbetrieb für Wasserwirtschaft, Küsten- und Naturschutz (NLWKN) |

: Data and their sources for the ViNoS model.

# CRediT authorship contribution statement

C. Lemmen: Conceptualization, Methodology, Resources, Software, Formal analysis, Data curation, Project administration, Writing – original draft, Writing – review & editing.

# S. Hokamp: Conceptualization, Software, Methodology, Writing – review & editing.

S. Örey: Conceptualization, Data curation, Writing – review & editing.
J. Scheffran: Conceptualization, Formal analysis, Writing – review & editing
J. Seo: Writing – original draft.
V. Mühlberger: Data curation.

<!--
## Sub-models
1. **Sub-models**
-->

# References

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

<!-- Respondek 2014: The international North Sea brown shrimp fishery involves 600 vessels, mainly from Germany, Netherlands and Denmark, and gen- erates annual landings in the range of 30 000 t annually. Catch value varies with annual prices but can exceed 100 million E per year. However, in spite of the economic importance and the scale of this fishery there is currently no management regime in place, neither through quota restrictions, nor through effort management.

German fishery statistics only recorded the number of trips without any further detail for most of the past decades (Neudecker et al., 2011). However, it is known that there is a trend of increasing mean boat size and that the shrimp fishery has gone through some difficult years in the past, with variable shrimp and fuel prices both potentially influencing fishing behaviour.
-->

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

<!-- @todo  Make landings a prognostic variable for ports -->

## Scenario development

Scenarios were developed for area closures with spatial information derived from the Marine Spatial Plan for German national waters, released by BSH in January, 2022 (BSH2022); the realization of closure areas for OWF was derived from the status information available at XXXX. With the federal state regulated areas, the National Park boundaries were obtained from the respecitve state agencies LLUR, NLWKN.

Scenarios were developed for the year 2020 (historic, actual area), the year 2025 (closure of Amrumbank, closure of National Park), and the year 2035 (closure of Sylt Außenriff, Borkum Riffgrund and National Park).

| **Scenario** | **Year** | **Description**                            |
| ------------ | -------- | ------------------------------------------ |
| Historic     | 2020     | Historic fishing grounds, no new closures  |
| BAU25        | 2025     | Current regulation (Amrumbank closure)     |
| MPA25        | 2025     | Current regulation (Amrumbank, WS closure) |
| BAU35        | 2025     | Current regulation (Amrumbank closure)     |
| MPA35        | 2025     | Current regulation (all MPA closed)        |

Scenario development for 2025 was guided by expert assessment from Stelzenmueller2024.

## Experimental design

Experiments were drafted as NetLogo BehaviorSpace (Wilensky1999) descriptions. For a complete definition of all behaviours see the Supplementary Material provided. Common assumptions for all experiments were

1. The size of the shrimper fleet stays the same
2. The location of the home port of the fleet stays the same
3. The operating costs (fuel, wages) are balanced by market price
4. Investment costs are disregarded.

We evaluated the areal imprint of fishery by looking at fishing effort, represented both as effort h as well as power effort h. We also evaluated the simulated monthly landings of the fleet.

<!-- todo add anual landing variable -->

# Results

Fig 1 shows the fishing effort as observed by Global Fishery Watch (GFW) and as reported to EMODNEt. GFW effort is based on AIS data and therefore differs from the ICES-reported VMS-based data reported on EMODnet; also GFW effort is reporte in h a-1 spent fishing whereas VMS-data is weighted by vessel power and is reported in MWh a-1.

The comparison of effort for the year 2020 shows that ViNoS is able to reproduce the spatial fishing pattern in the German Bight. Differences in offshore areas are due to flatfish activities, and differences beyond the state regulated area to non-German fishers, who are excluded from the National Park area.

# Discussion

The economic viability of shrimp fishery has been questioned for several years. Low expection has lead to a historic low of the number of people employed. Low expectation created difficulties to take on mortgages to invest in the aging fleet. Labour is in shortage. And the resource is highly variable in space and time, making the catch unpredictable.

An explanation of why the fishery still exists then, lies in its deep cultural roots in coastal livelihoods. It creates identity (for few) and it shapes the perception of the coast for many.

Our scenarios show that OWF area closures do not impact the current fishery spatial pattern besides small shifts in fishing grounds. The largest change comes from the closure of MPA: Those more offshore (Amrumbank, Sylter Außenriff, Borkum Riffgrund) seem not to change fishery patterns at large: there is a spatial shift of fishery to areas outside the MPAs and along their fringes. A closure of the WSH, on the other hand, would be a major disruption of the current area exploited by shrimp fishers. On average, fishers have to travel about XXX km further on each trip, and the amount of shrimp caught in a single hauls is expected to decline by a factor XXX, leading to much longer fishfing trips to recover the same amount of catch.

Other factors have been proposed to lead to shifts in fishgin pattersn: Some of the ecomonically important species in the North Sea show a northward habitat shift due to the climate change related warming of the water [@dulvy2008climate]; this suggests that also the fishing grounds may have to shift. Most likely, however, this does not affect shrimp. Moreover, fishers have to re-evaluate their economic balance by figuring in the foreseeable rise in oil price, price fluctuations related to the oligopolic processing market, and the need for re-investing into their aging vessels [@Goti-Aralucea2021].

Outlook: other markets GB? othe rshelf seas?

# Conclusion

We demonstrated the capability of the novel Viable North Sea (ViNoS) agent-based model to represent present-day fishing effort of the German North Sea shrimp fishery. We defined future scenarios considering area closure to this fishery for energy production and marine protection. Within a range of plausible scenarios, we showed that this fishery can be sustained with little evasive behavior; only a scenario where the Wadden Sea heritage area was closed, posed such severy restrictions on the fishery that it would not be anymore economically sustainable.
To mitigate such a drastic reduction of fishing grounds, we explored ... and found that - at least in the model context, even a closure of the WSH area could be mitigated and a fisihery could be viable both economically and ecologically.

# CRediT authorship contribution statement

C. Lemmen: Conceptualization, Methodology, Resources, Software, Formal analysis, Data curation, Project administration, Writing – original draft, Writing – review & editing.
S. Örey: Conceptualization, Data curation, Writing – review & editing.

<!--
S. Hokamp: Conceptualization, Software, Methodology, Writing – review & editing.
J. Scheffran: Conceptualization, Formal analysis, Writing – review & editing
-->

# References

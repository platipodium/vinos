---
abbreviations:
  - long: Agent-based Model
    short: ABM
  - long: Overview, Design concepts, Details
    short: ODD
  - long: Offshore Wind Farm
    short: OWF
  - long: Discrete Event Simulation
    short: DES
  - long: Exclusive Economic Zone
    short: EEZ
  - long: United Nations Food and Agricultural Organization
    short: FAO
  - long: General Bathymetry Chart of the Oceans
    short: GEBCO
  - long: Harvest Control Rule
    short: HCR
  - long: Marine Stewardship Council
    short: MSC
  - long: Multiple Stressors on North Sea Life
    short: MuSSeL
  - long: Total Allowable Catch
    short: TAC
  - long: Viable North Sea
    short: ViNoS
  - long: Values and Investments from Agent-Based interaction and Learning
      in Environmental systems
    short: VIABLE
abstract: Viable North Sea (ViNoS) is an Agent-based Model of the German
  North Sea Small-scale Fisheries in a Social-Ecological Systems
  framework focussing on the adaptive behaviour of fishers facing
  regulatory, economic, and resource changes. Small-scale fisheries are
  an important part both of the cultural perception of the German North
  Sea coast and of its fishing industry. These fisheries are typically
  family-run operations that use smaller boats and traditional fishing
  methods to catch a variety of bottom-dwelling species, including
  plaice, sole, and brown shrimp. Fisheries in the North Sea face area
  competition with other uses of the sea -- long practiced ones like
  shipping, gas exploration and sand extractions, and currently
  increasing ones like marine protection and offshore wind farming.
  German authorities have just released a new maritime spatial plan
  implementing the need for 30% of protection areas demanded by the
  United Nations High Seas Treaty and aiming at up to 70 GW of offshore
  wind power generation by 2045. Fisheries in the North Sea also have to
  adjust to the northward migration of their established resources
  following the climate heating of the water. And they have to
  re-evaluate their economic balance by figuring in the foreseeable rise
  in oil price and the need for re-investing into their aged fleet.
acknowledgement: The authors thank W.N. Probst for providing species
  distribution data as a forcing to this model. We thank M. Ryan for
  helping with the shape files. The development of the model is funded
  by the German Ministry of Education and Research through the KüNO
  project 'Multiple Stressors on North Sea Life' (MuSSeL) with grant
  number 03F0862A. We are grateful for the open source community that
  facilitated this research, amongst them the developers of and
  contributors to NetLogo, Python, R, pandoc, LaTeX, and many others.
affiliation:
  - address: Helmholtz-Zentrum Hereon, Institute of Coastal Systems -
      Analysis and Modeling, Max-Planck-Str. 1, 21502 Geesthacht, Germany
    email: carsten.lemmen@hereon.de
    num: 1
  - address: Universität Hamburg, Centre for Earth System Research and
      Sustainability (CEN), Bundesstrasse 53, 20146 Hamburg, Germany
    num: 2
  - address: Hochschule Bremerhaven, Research Cluster Life Sciences, An
      der Karlstadt 8, 27568 Bremerhaven, Germany
    num: 3
author:
  - affil: 1
    name: Carsten Lemmen
    orcid: 0000-0003-3483-6036
  - affil: 2
    name: Sascha Hokamp
    orcid: 0000-0002-2192-4013
  - affil: 3
    name: Serra Örey
    orcid: 0000-0003-3483-6036
  - affil: 2
    name: Jürgen Scheffran
    orcid: 0000-0002-7171-3062
  - affil: 2
    name: Jieun Seo
  - affil: 2
    name: Verena Mühlberger
    orcid: 0009-0000-0785-6811
bibliography: paper.bib
citation_author: Lemmen et al.
classoption: moreauthors=true
conflictsofinterests: The authors declare that no conflict of interest
  has arisen from this work.
correspondence: C. Lemmen <carsten.lemmen@hereon.de>
csl-refs: true
journal: comses
keywords: NetLogo; Agent-based Model; ABM; North Sea; Fisheries; MuSSeL
  project; ODD; VIABLE; ViNoS
license: CC-BY-4.0
SPDX-FileCopyrightText: 2023 Hochschule Bremerhaven
SPDX-License-Identifier: CC-BY-4.0
title: "ODD Protocol for Viable North Sea (ViNoS): A NetLogo Agent-based
  Model of German Small-scale Fisheries"
type: article
year: 2023
---

# ODD Protocol: German North Sea Small-scale Fisheries

Viable North Sea (ViNoS) is an Agent-based Model (ABM) of the German
North Sea Small-scale Fisheries in a Social-Ecological Systems (SES)
framework focussing on the adaptive behaviour of fishers facing
regulatory, economic, and resource changes.This model description
follows the Overview, Design concepts, Details (ODD) protocol for
describing individual- and agent-based models (@Grimm2010, @Grimm2020).
By following this protocol, we aim to document the ABM such that it is
replicable independently of the current implementation in NetLogo
[@Wilensky1999].

## Purpose, scope and audience

In the North Sea, the German small-scale fishing fleet's biggest group
are the shrimp beam trawlers. This small-scale fishing fleet is
typically run by owner-operated family enterprises that uses boats
smaller than 24 meters [@Döring2020]. These vessels' target species are
mainly demersal (living near the bottom), and include plaice, sole, and
brown shrimp [@Letschert2023].

Fisheries in the North Sea face area competition with other uses of the
sea -- long practiced ones like shipping, gas exploration and sand
extraction, and currently increasing ones like marine protection areas
and offshore wind farms (OWF, @stelzenmuller2022plate). German
authorities released a new maritime spatial plan in 2023 for
implementing the need for 30% of protection areas demanded by the United
Nations High Seas Treaty and aiming at up to 70 GW of offshore wind
power generation by 2045 [@WindSeeG2023].

```{=html}
<!-- @todo  in theory the german EEZ allready is protected by about 30% https://www.bfn.de/nationale-meeresschutzgebiete#anchor-6205, hmm, in EEZ 8000/28500 km2 protected, i.e. 28%, (only german) -->
```

Some of the ecomonically important species in the North Sea show a
northward habitat shift due to the climate change related warming of the
water [@dulvy2008climate]; this suggests that also the fishing grounds
may have to shift. Moreover, fishers have to re-evaluate their economic
balance by figuring in the foreseeable rise in oil price, price
fluctuations related to the oligopolic processing market, and the need
for re-investing into their aging vessels [@Goti-Aralucea2021].

The **purpose** of this ABM is to provide an interactive simulation
environment that describes spatial, temporal and structural adaptations
of the fleet. It adaptively describes

- where to fish and how far to go out to sea
- how often to go out
- what gear to use and what species to target

Its **scope** is the German North sea small-scale fisheries. This
encompasses some 300 vessels based in German ports along the North Sea
coast and fishing in the German Bight, including but not restricted to
Germany's exclusive economic zone (EEZ). The currently simulated target
species are the three most important ones: plaice, sole and brown
shrimp, but the model is in principle extensible to further species like
Norwegian lobster, sprat or whiting.

The **intended audience** of the ABM are marine researchers and
government agencies concerned with spatial planning, environmental
status assessment, and climate change mitigation. It can also assist in
a stakeholder dialogue with tourism and fishers to contextualize the
complexity of the interactions between fisheries economics, changing
resources and regulatory restrictions. It is intended to be used for
communication of and scenario development for future sustainable
fisheries at the German North Sea coast.

## Entities, state variables, and scales

The fishery target species are denoted _preys_. Currently, the ABM
describes three different species (`\autoref{fig:agents}`{=tex}). The
primary agents in the ABM are the fishing vessels, denoted as _boats_.
They are linked to supplementary classes of agents that describe the
_gears_ used for fishing, the target species denoted as _preys_, and the
_ports_ where boats land their catch. The agents interact with the
_environment_ that describes the _spatial domain_ and resource and
regulatory changes.

<div>

```{=html}
<!-- Original picture is 22,26 x 14,89 cm -->
```

![Primary and subsidiary agents of the ViNoS
ABM.`\label{fig:agents}`{=tex}](../../assets/agents.pdf){width="75%"
height="30%"}

</div>

### The primary agent: boats

Boats are located at ports, according to the empirical distribution of
the German fleet in those ports. In the German fleet there are four
distinct clusters of small-scale fisheries vessels that have typical
vessel and crew size, gear and fishing strategy [@Oerey2023]. With those
come physical (speed, length, capacity, engine power) and economic
properties (fixed and variable costs). Boats have a catch efficiency
that tries to model the experience of the individual boat owners. Boats
go on fishing trips and record the catch and the revenue. They
internally record the economic balance of their activites and
continuously adapt priorities, e.g., for choosing a specific gear, based
on value gains.

```{=html}
<!-- @todo  we need to work on addinng area-flexbilty, max distance and other variables to memory -->
```

### Subsidiary agents: ports, preys, gears

Ports, preys, and gears are immobile agents that are introduced to
structure the model in object-oriented design and encapsulated their
state variables and methods. Ports are the boats' favourite landing
ports. Boats start their activity from a port and dock to unload at a
port. They can stay in a port when deciding not to fish. Along the
German North Sea coast, there are 54 ports for which boat and landing
statistics are available. At the ports, the simulated landings are
recorded.

```{=html}
<!-- @todo  Make landings a prognostic variable for ports -->
```

The North Sea brown shrimp (_Crangon crangon_, Brown shrimp,
Nordseekrabbe) has no catch restriction concerning a maximum allowable
catch. Because of its very short life cycle, reliable stock estimates
are not yet established. Since 2011 the fishery uses the harvest control
rule (HCR) as a management measure. Beam trawlers between 12-24 m are
the most important segment within both the Dutch and German coastal
fleet. Currently, nets have a standard cod end and diamond mesh sizes of
20 mm. For the voluntery Marine Stewardship Certification (MSC) process
sieb nets are required by the certified vessels to reduce bycatch and
bigger mesh sizes are in discussion. There is no area restrictions apply
to shrimp fishers in the German North Sea
[@aviat2011north,@ICES2019wgcran].

The second important group of target species in the German bight are the
flatfish. Two commercially important fish species are plaice
(_Pleuronectes platessa_, European plaice, Scholle) and sole (_Solea
solea_, European sole, Seezunge). Both species are regulated with total
allowable catch (TAC) measures. Additionally, several technical measures
apply to both of the fisheries including a mesh size regulations, a
minimum landing size, gear restrictions and a closed area along the
continental coast where beam trawlers with engine power higher than 221
kW are not allowed to fish (the so-called "plaice box",
@rijnsdorp2020different)

The model is designed to accommodate further species relevant in the
small-scale fishery such as whiting (_Merlangius merlangus_), sprat
(_Sprattus sprattus_), or Norwegian lobster (_Nephrops norvegicus_).
Each prey species is assigned a price obtained from historic prices of
the last decades.

Boats and preys are connected via the _gears_ agent: The gear prescribes
the geometric area that can be fished, the speed at which fishing can
occur, and the prey that is caught. A gear can be installed, or changed,
on a boat, subject to economic (investment cost) and physical (weight,
size) constraints. The gear also determines the impact of the fishing
activity on the environment, i.e. how much prey is removed and how much
of the sea floor is swept as the beam size of the gear changes depending
on the target species.

```{=html}
<!-- @todo  Add the change of gear -->
```

```{=html}
<!-- @todo  Add SAR diagnostic -->
```

```{=html}
<!-- @todo  Add removal and recovery of prey -->
```

### Spatial units

The spatial domain is described by a grid, whose cells (in NetLogo:
patches) carry spatial information on the environment and record
activity information. The domain itself is the German Bight including
Germany's EEZ. It is represented geographically in the WGS84 datum, and
bounded by the rectangle spanned by the coordinates (2° E; 53° N) and
(10° E; 56° N); the resolution is 0.025 x 0.025 degree (1.5 arc minutes,
or approximately 1.7 x 2.9 km). The resulting grid has a size of 320
columns x 120 rows.

The domain is divided into an active part (water) and an inactive part
(land). The demarcation between land and water is achieved by using the
General Bathymetry Chart of the Oceans (GEBCO) bathymetry bounded by
European Environmental Agency's coastline dataset. Using a creep-fill
algorithm a continuous accessible domain is ensured. Cells carry
information on resources (fish stocks of the respective species, at
climatological seasonal resolution), and regulatory fishery closure
areas (offshore wind and trawling exclusion zones). They record activity
of the fishery occuring in the grid cell as area swept and as hours
fished.

```{=html}
<!-- @todo add SAR -->
```

### Nonspatial environment

A calendar records time. The temporal domain is multiple years and the
temporal resolution is 1 day. With the progress of the calendar,
surrogate weather is introduced that may influence a boat's decision to
go on a fishing trip. Seasonal information is used to describe the
annual variation of prey resources.

```{=html}
<!-- @todo Use the weather -->
```

## Process overview and scheduling

The global timestep of the model is one day. Within the 24-hour period,
we use Discrete Event Simulation (DES) to trigger the action of boats
within 6 phases:

---

**Phase** **Location** **Description**

---

Phase 0 rest port Boats are resting, not ready to go out

Phase 1 ready port-sea Boats are ready to go out and are deployed

Phase 2 steam sea Boats steam in open water

Phase 3 fish sea Boats fish open water

Phase 4 steam sea Boats need to return

Phase 5 land port Boats are offloading

---

: The 6 phases used with Discrete Event Simulation in ViNoS.

Boats cycle through all phases consecutively, keeping a record of how
much time they spend. Boats in **phase 0** keep the legal resting time
of 11 hours, and rest during the weekend (from Saturday noon to Monday 4
am). After the resting period, they make a decision on whether to go out
or not. This decision may depend on weather and (in a later model
version) expected catch. If the decision is positive, a boat enters
phase 1. Boats in **phase 1** directly (straight line, without
environmental sensing) steam from the port location to the port's
closest open sea deployment location. Adding this phase makes it
possible for the ports to be located on dry ground at the available grid
resolution, as many ports are located upstream of the coastline
demarcation. Having arrived at the deployment location, boats enter
phase 2.

Boats in **phase 2** steam to a preferred location for the next fishing
haul. This preferred location is chosen randomly but subject to the fuel
constraints and maximum distance preference of each boat. At a later
implementation of the model, this location is also chosen taking into
account previous experience of successful fishing hauls. Phase 2 may
also be entered after an unsuccessful fishing haul. At the new location,
a boat enters **phase 3** for fishing. Fishing is done in several hauls;
a haul is directed towards only accessible water, and at the end of a
haul the ship turns around (with slight variation) and continues to the
next haul.

To record the fishing activity on the cells, a haul is subdivided into
time substeps of 6 minutes duration. The time spent in a cell and the
area swept is recorded for the gear with the highest priority. The catch
is calculated separately for each gear (and the gear-associated target
species), taking into account the target species' biomass at the haul
location, the gear width and haul distance and the boat's catch
efficiency. Hauls are repeated until one of the following constraints is
met (always taking into account the time and fuel cost of the return
trip):

1.  The maximum preferred time at sea is exhausted;
2.  the maximum time from the first successful catch (24 hours to keep
    fresh) is exhausted;
3.  the fuel is exhausted;
4.  the loading capacity is exhausted;
5.  the catch is considered insufficient.

<div>

![Decision pathway for a simulated fishing
trip.`\label{fig:flowchart}`{=tex}](../../assets/abm_flowchart.pdf){width="90%"
height="30%"}

</div>

On an insufficient catch, the boat enters phase 2 to look for a
different location. On a successful catch and after having spent the
allocated time or fuel, the boat enters phase 4. Boats in **phase 4**
need to return. They directly steam in a straight line to their
deployment location and on to their port. At the port, they enter
**phase 5** to unload their catch and clean the boat. Priorities for the
different gears are updated based on the relative change of the deployed
gears and catches. Finally, boats re-enter phase 0 and restart the
cycle. A summary view of the model scheduling is depicted in
`\autoref{fig:flowchart}`{=tex}.

## Design concepts

### Basic principles

```{=html}
<!-- German authorities have just released a new maritime spatial plan implementing the need for 30% of protection areas demanded by the United Nations High Seas Treaty and aiming at up to 70 GW of offshore wind power generation by 2045.  -->
```

The ABM is an adaptive model with the **objective** of increasing value
gains (here: net profits), subject to environmental, economic, and
individual constraints. The **adaptation** is currently restricted to
changing gear with shifting priorities for allocating fishing effort,
and described by the ABM framework VIABLE (Values and Investments from
Agent-Based interaction and Learning in Environmental systems)
[@BenDor2019; @Scheffran2000].

---

**Symbol** **Description**

---

$k$ Action pathway, here: gear selected out of $m$ possibilities
$k = 1\ldots m$.

$C$ Cost of a haul, composed of time-dependent cost (e.g. wages) and
distance costs (fuel), measured in €

$H$ Fish catch, or harvest, during a haul measured in kg. Calculated
from catch efficiency $e$, prey density $X$, and effort $E$.

$E$ Effort of fishing activity measured in hours. Fishers typically
fish 1500 to 2000 hours per year.

$X$ Density of fish at fishing ground, expressed in kg m^-2^ trawled.

$e$ Catch efficiency, expressed in units of m^2^ h^-1^.

$p$ Price of the fish, expresses in € kg^-1^.

$V$ Value, here: net gain of haul, i.e. fish catch $H$ times price
$p$ minus cost $C$, measured in €.

$r_k$ Priority for action pathway $k$ with $0\leq r_k\leq 1$ and
$\sum_1^m r_k = 1$.

$v_k$ Marginal change of value with priority
$v_k=\partial{V}/\partial{r_k}$, expressed in €.

$a$ Adaptation rate (sensitivity) of a change in priority from a
change in value.

---

: Notation used in the VIABLE approach.

In the VIABLE approach, each boat carries a list of priorities for
certain fishing actions that are subject to change based on the boat's
perception and evaluation of its activities. During each haul, the costs
of that haul (wage and fuel) $C$ are subtracted from the benefits,
i.e. the income from the catch (harvest) $H$ times the market price $p$
for each fish:

$$
V = p H - C.
$$

The fish catch $H$ from a haul is a function of fishing effort $E$ (in
work hours), density of a particular fish species $X$ in the area of
fishing and the catch efficiency $e$ for the respective gear type
interacting with this particular fish:

$$
H = e X E.
$$

If for each boat there are several gear types (termed "action pathways"
in the VIABLE approach) $k = 1 \ldots m$ available, according to the
gradient decision rule each agent changes priority $r_k$ in proportion
to the product of marginal value $v_k$ and priority $r_k$ for each gear
type, multiplied by an adaptation rate $a$ determining how strong agents
adapt action to value. The marginal value van be the change in $V_k$
when choosing priority $k$ or in mathematical terms the partial
derivative of the value function with respect to priority
$v_k=\partial{V}/\partial{r_k}$, if that function is known. Althogether,
the temporal change of the priorities $r_k$ is given by

$$
\frac{dr_k}{dt} = a r_k \cdot \frac{v_k - \sum r_k v_k }{\sum v_k}
$$

Both sums are for normalisation purposes to make sure that all
priorities add up to 1. The first sum means that pathways $k$ with
marginal value above average $v_k$ increase and below average decrease,
indicating a competition to select the "better" gear.

```{=html}
<!--
This equation is universal, also applies to fishery, requiring more details on value function. In this paper further details are not given, e.g. fishing efficiency which is a key variable and depends on gear type. This requires a full paper with more math. For more details see BenDor/Scheffran 2019, Chapter 8 or Scheffran 2000.
-->
```

### Emergence

The emergent property is the spatial pattern of fishing activities,
which is best recorded as maps of effort or maps of swept area ratio
(SAR). This property can be compared to existing data on effort or SAR,
and it gives information on the location of the largest potential
environmental impact of fisheries.

### Learning

To enable learning, boats implement a memory of best hauls, recording
the amount caught and the cell location. This memory has size 20. After
a training phase, boats may choose to steam preferentially to one of the
best 10 past experienced locations to start fishing. Learning is not
used in the current version of the model.

### Prediction

When deliberating to change to a gear with higher priority, boats have
to discount the installation cost of a new gear and compare this with
future expected gains. They can only switch gears if the predicted
future gain with the new gear minus the installation cost is higher than
the predicted future gain of the current gear.

### Sensing and Interaction

Boats sense the resource availability of each cell, as well as global
fuel prices and port-dependent market prices. There is no direct
**interaction** between boats. A feedback of the boats onto the cells by
depleting their prey resource is foreseen but currently not implemented.

### Stochasticity

Boats are distributed across harbors according to empirical data. Their
assignation to one of the four clusters is stochastic within the
empirical distribution. Physical data of the boats are stochastic within
the empirical limits of their cluster.

The direction of a haul is random across all accessible directions. The
weather is stochastic within the limits of a typical North sea storm
climatology.

## Initialization

Ports and boats are initialized from empirical statistics available for
the year 2015. The resources are initialized from a species distribution
model (SDM) based on stock assessments and environmental data for the
period 2015-2020. Time is initialized with current wall clock time.

## Input data

The model makes use of extensive external data sources to describe the
environment and to initialize the agents. All data are publicly
available and licensed for use. The data sources are

---

**Description** **Source**

---

Clustered vessel data Hochschule Bremerhaven

Species distribution of Thünen Institute
plaice, sole, and brown
shrimp

Species information Food and Agriculture Organization (FAO)

Bathymetry General Bathymetry Chart of the Oceans
(GEBCO)

Offshore Wind Farms (OWF) European Commission, European Marine
Observation and Data Network (EMODnet)

Exclusive economic zone United Nations Convention on the Law of the
(EEZ) Sea

Subregional divisions International Council for the Exploration
of the Seas (ICES) Spatial Facility

Plaice box European Commision

Geodetic information International Earth Rotation Service (IERS)

National Park boundaries Niedersächsischer Landesbetrieb für
Wasserwirtschaft, Küsten- und Naturschutz
(NLWKN)

---

: Data and their sources for the ViNoS model.

# CRediT authorship contribution statement

C. Lemmen: Conceptualization, Methodology, Resources, Software, Formal
analysis, Data curation, Project administration, Writing -- original
draft, Writing -- review & editing. S. Hokamp: Conceptualization,
Software, Methodology, Writing -- review & editing. S. Örey:
Conceptualization, Data curation, Writing -- review & editing. J.
Scheffran: Conceptualization, Formal analysis, Writing -- review &
editing J. Seo: Writing -- original draft. V. Mühlberger: Data curation.

```{=html}
<!--
## Sub-models
1. **Sub-models**
-->
```

# References
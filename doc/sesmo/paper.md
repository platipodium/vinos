---
title: 'The redistribution of German Small-scale Fisheries effort and impact due to regulatory area closures'
keyword:
  - North Sea
  - Fisheries; Area closure; MuSSeL project; VIABLE; ViNoS; Agent-based Model; ABM"
author:
  - Carsten Lemmen, Helmholtz-Zentrum Hereon, Max-Planck-Str. 1, 21502 Geesthacht, Germany
  - Serra Örey, Hochschule Bremerhaven, Research Cluster Life Sciences, Bremerhaven, Germany
  - Jürgen Scheffran, Universität Hamburg, Centre for Earth System Research and Sustainability (CEN), Germany
  - Sascha Hokamp, Universität Hamburg, Centre for Earth System Research and Sustainability (CEN), Germany
correspondence: C. Lemmen <carsten.lemmen@hereon.de>
citation_author: Lemmen et al.
date: submitted to SESMO, June 2022
license: CC-BY-4.0
bibliography: paper.bib
SPDX-FileCopyrightText: 2023 Helmholtz-Zentrum hereon GmbH
SPDX-FileCopyrightText: 2023 Universität Hamburg
SPDX-FileCopyrightText: 2023 Hochschule Bremerhaven
SPDX-License-Identifier: CC-BY-4.0
abstract: "Small-scale fishers in the German part of the North Sea are increasingly faced with area closures from regulation giving preference to nature protection and wind harvesting, demanded by EU policies for increased protection of our seas and for increased dependence on renewable energies: German authorities have just released a new maritime spatial plan implementing the need for 30% of protection areas demanded by the United Nations High Seas Treaty and aiming at up to 70 GW of offshore wind power generation by 2045.  The small-scale trawling fishery is, however, an important part both of the cultural perception of the German North Sea coast and of its fishing industry.  We here use the Viable North Sea (ViNoS)Agent-based Model (ABM) of the German North Sea Small-scale Fisheries to describe the  adaptive behaviour of fishers facing those regulatory changes in fishing ground availability.  We demonstrate how fishing effort may be redistributed away from the current effort, and how this changed effort creates more environmental impact from the concentrated trawling activity."
acknowledgements: "The authors thank W.N. Probst for providing species distribution data as a forcing to this model.  We thank M. Ryan for helping with the shape files. This research if funded by the German Ministry of Education and Research (BMBF) through the Küstenforschung Nord- und Ostseee (KüNO) project 'Multiple Stressors on North Sea Life' (MuSSeL) with grant number 03F0862A."
conflictsofinterests: "The authors declare that no conflict of interest has arisen from this work."
abbreviations:
  - short: ABM
    long: "Agent-based Model"
  - short: EEZ
    long: "Exclusive Economic Zone"
  - short: FAO
    long: "United Nations Food and Agricultural Organization"
  - short: OWF
    long: "Offshore Wind Farm"
  - short: ViNoS
    long: "Viable North Sea"
  - short: MuSSeL
    long: "Multiple Stressors on North Sea Life"
  - short: VIABLE
    long: "Values and Investments from Agent-Based interaction and Learning in Environmental systems"
---

# Introduction

Small-scale fishers in the German part of the North Sea are increasingly faced with area closures from regulation giving preference to nature protection and wind harvesting, demanded by EU policies for increased protection of our seas and for increased dependence on renewable energies: German authorities have just released a new maritime spatial plan implementing the need for 30% of protection areas demanded by the United Nations High Seas Treaty and aiming at up to 70 GW of offshore wind power generation by 2045. The small-scale trawling fishery is, however, an important part both of the cultural perception of the German North Sea coast and of its fishing industry. We demonstrate how fishing effort may be redistributed away from the current effort, and how this changed effort creates more environmental impact from the concentrated trawling activity.

# Methods

We use the Viable North Sea (ViNoS)Agent-based Model (ABM) of the German North Sea Small-scale Fisheries [@Lemmen2023a] to describe the adaptive behaviour of fishers facing regulatory, economic and resource changes.

## ViNoS Model

The Viable North Sea (ViNoS) Agent-Based model (ABM) is a socio-ecological systems (SES) modeling environment for interactive simulation of the German Small-scale Fisheries. It is built on the NetLogo [@Wilensky1999] platform and available as Open Source [@Lemmen2023a]. ViNoS describes describes spatial, temporal and structural adaptations of the fishing fleet. It adaptively describes (1) where to fish and how far to go out to sea; (2) how often to go out ; and (3) what gear to use and what species to target.

The model represents 300 fishing vessels based in German ports along the North Sea coast and fishing in the German Bight, including but not restricted to Germany's exclusive economic zone (EEZ). The target species considered are plaice, sole and brown shrimp using a variety of beam trawling gear and otter boards.

The ABM is an adaptive model with the **objective** of increasing profits, subject to environmental, economic, and individual constraints. The **adaptation** is currently restricted to
changing gear with shifting priorities for allocating fishing effort, and discribed by the VIABLE approach [@BenDor2019;@Scheffran2000].

In the VIABLE approach, each boat carries a list of priorities that are subject to change based on the boats perception and evaluation of its activities. During each haul, the costs of that haul (wage and fuel) are subtracted from the benefits (i.e. the price of the catch times the amount caught) in parallel for all gears available to a boat. The marginal value (gain or loss, in €, divided by XXXX) for each gear type and is multiplied by an adaptation rate determining the relative change in priorities.

More general, there are strategies $i \in 1..n$ with priorities $r_i$, values $V_i$ and adaptation rates $a_i$. The marginal benefit of a change in $V$ with respect to $r$ is $v_i=\partial{V_i}/\partial{r_i}$.

The temporal change of the priorities $r_i$ is given by

$$
\frac{dr_i}{dt} = a_i r_i \cdot \frac{v_i - \sum r_i v_i }{\sum v_i}
$$

The emergent property is the spatial pattern of fishing activities, which is best recorded as maps of effort or maps of swept area ratio (SAR). This property can be compared to existing data on effort or SAR, and it gives information on the location of the largest potential environmental impact of fisheries.

A full Overview, Design and Details (ODD) model documentation is available as @Lemmen2023b.

## Supporting data sets

The model makes use of extensive external data sources to describe the environment
All data are publicly available and licensed for use. The data sources are

| **Description**                                        | **Source**                                    |
| ------------------------------------------------------ | --------------------------------------------- |
| Clustered vessel data                                  | Hochschule Bremerhaven, CC-by-NC-ND-4.0       |
| Species distribution of plaice, sole, and brown shrimp | Thünen Institute, DL-DE-BY-2.0                |
| Species information                                    | FAO                                           |
| Bathymetry                                             | GEBCO                                         |
| Offshore Wind farms                                    | EMODNet                                       |
| EEZ                                                    | United Nations                                |
| ICES subregional divisions                             | ICES                                          |
| Plaice box                                             | European Commision                            |
| Geodetic information                                   | International Earth Rotation Service, CC0-1.0 |
| National Park boundaries                               |  NLWKN, DL-DE-BY-2.0                          |

# CRediT authorship contribution statement

C.Lemmen: Conceptualization, Methodology, Resources, Software, Formal analysis, Data curation, Project administration, Writing – original draft, Writing – review & editing.
S.Hokamp: Conceptualization, Software, Methodology, Formal analysis, Writing – review & editing.
S.Örey: Conceptualization, Data curation, Writing – review & editing.
J. Scheffran: Conceptualization, Formal analysis, Writing – review & editing

# References

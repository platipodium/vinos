---
title: "Viable North Sea (ViNoS): A NetLogo Agent-based Model of German Small-scale Fisheries"
tags:
  - NetLogo
  - Agent-based Model
  - ABM
  - North Sea
  - Fisheries
  - MuSSeL project
  - VIABLE
  - Plaice
  - Sole
  - Shrimp
authors:
  - name: Carsten Lemmen
    orcid: 0000-0003-3483-6036
    affiliation: 1
    corresponding: true
  - name: Sascha Hokamp
    affiliation: 2
    orcid: 0000-0002-2192-4013
  - name: Serra Örey
    orcid: 0000-0003-3483-6036
    affiliation: 3
  - name: Jürgen Scheffran
    affiliation: 2
    orcid: 0000-0002-7171-3062
affiliations:
  - name: Helmholtz-Zentrum Hereon, Institute of Coastal Systems - Modeling and Analysis, Germany, carsten.lemmen@hereon.de
    index: 1
  - name: Universität Hamburg, Centre for Earth System Research and Sustainability (CEN), Germany
    index: 2
  - name: Hochschule Bremerhaven, Research Cluster Life Sciences, Bremerhaven, Germany
    index: 3
date: 4 Oct 2023
year: 2023
bibliography: paper.bib
SPDX-FileCopyrightText: 2022-2023  Helmholtz-Zentrum hereon GmbH
SPDX-License-Identifier: CC-BY-4.0
SPDX-FileContributor: Carsten Lemmen
---

# Summary

Viable North Sea (ViNoS) is an Agent-based Model (ABM) of the German Small-scale Fisheries. As a Social-Ecological Systems model it focusses on the adaptive behaviour of fishers facing regulatory, economic, and resource changes. Small-scale fisheries are an important part both of the cultural perception of the German North Sea coast and of its fishing industry. These fisheries are typically family-run operations that use smaller boats and traditional fishing methods to catch a variety of bottom-dwelling species, including plaice, sole, and brown shrimp.

Fishers in the North Sea face area competition with other uses of the sea---long practiced ones like shipping, gas exploration and sand extraction, and currently increasing ones like marine protection and offshore wind farming: German authorities released a maritime spatial plan implementing (1) the need for 30% of protection areas demanded by the United Nations High Seas Treaty and(2) aiming at up to 70 GW of domestic offshore wind power generation by 2045. Fisheries in the North Sea also have to adjust to the northward migration of their established resources following the climate heating of the water. And they have to re-evaluate their economic balance by figuring in the foreseeable rise in oil price and the need for re-investing into their aged fleet.

# Statement of need

The purpose of this ABM is to provide an interactive simulation environment that describes spatial, temporal and structural adaptations of a fishery fleet. It adaptively describes

- where to fish and how far to go out to sea,
- how often to go out,
- what gear to use and what species to target.

Its scope are the German North Sea small-scale fisheries. These encompass some 300 vessels based and landing in German ports along the North Sea coast and fishing in the German Bight, including but not restricted to Germany's exclusive economic zone. The target species described by the model are currently limited to the most important ones in this sector: plaice, sole and brown shrimp; the model is extensible to further target species like Norwegian lobster, whiting, or sprat.

The intended audience of the ABM are marine researchers, educators and government agencies concerned with spatial planning, environmental status assessment, and climate change mitigation. The ABM can assist in a stakeholder dialogue with tourism and fishers to contextualize the complexity of the interactions between fisheries economics, changing resources and regulatory restrictions. It is intended to be used for scenario development for future sustainable fisheries.

# Key features of the ABM

As a NetLogo implementation, the model comprises a (frontend) user `interface`, its basic `info` documentation, and the (backend) `code` in a single integrated development environment (IDE) provided by NetLogo [@Wilensky1999, version 6 required], a Java-based portable ABM and system dynamics simulation platform.

The backend (`code`) features geospatial data access and integration of multiple georeferenced and tabular data sources, as well as integrating Web Mapping Services to describe the grid-based environmental context. This environmental context is dynamic in time, providing seasonal resource changes and dynamic area closures.

Agents are boats, the gear they use, the strategies they employ, and their prey. All agents are encapsulated in object-oriented design as NetLogo `breeds`. The agents' methods implement the decision rules of agents and the resulting interactions between them and with their gridded environment (`patches`). Key interactions are the movement rules of boats across the seascape, the harvesting of resources, and the cost-benefit analysis of a catch. Adaptation occurs at the level of changing priorities for fishing trips (i.e. gear selection and target species, time and distance preferences) towards increasing expected values of agents, according to the VIABLE model framework [@BenDor2019].

The user `interface` provides an interactive environment, perusing all NetLogo's graphical features. Informational elements include a (georeferenced) map `view`, and several histograms and temporal scatter panels. Interactive elements include `switches` for toggling information on and off, `choosers` to toggle which information to show, `buttons` to control the simulation and `sliders` to adjust boundary conditions, such as the oil price.

# Notable programming and software development features

A notable programming feature is the integration of the legend with the `view`, a feature that is lacking from the default capabilities of NetLogo. There have been discussions on how to implement a legend using the `plot` element and using the `bitmap` extension [@Stackoverflow2018], but so far this is the only NetLogo model known to the authors implementing a legend with the `view` using NetLogo's intrinsic capabilities.

To date, most NetLogo models have not exploited continuous integration (CI) and continous deployment (CD). With our implementation, we demonstrate how CI can be used for NetLogo by making use of NetLogo's `BehaviorSpace` tool that runs a suite of unit tests. We also use `BehaviorSpace` for the CD of generating the resulting maps of fishing effort under different scenarios.

# Model documentation and license

The model is documented in short form in the IDE's `info` section. A full documentation following the Overview, Design, and Details [ODD, @Grimm2020] standard protocol for ABMs is available in the repository as `doc/odd/paper.md`. Data from third parties is licensed under a multitude of open source licenses. The model, its results and own proprietary data are released under open source licenses, mostly Apache 2.0 and CC-by-SA-4.0. A comprehensive documentation of all licenses is provided via @FSF2023.

<!-- @todo Refer to the published ODD version (once this is published) -->

# Acknowledgements

We acknowledge contributions from W. Nikolaus Probst, Marie Ryan, Jieun Seo, Verena Mühlberger and Kai W. Wirtz for providing feedback, data, fruitful discussions and for contributing to the ODD document. We thank all members of the MuSSeL consortium making this software relevant in a research context. The development of the model was made possible by the grants 03F0862A, 03F0862C, 03F0862D, 03F0862E "Multiple Stressors on North Sea Life" (MuSSeL) within the 3rd Küstenforschung Nord-Ostsee (KüNO) call of the Forschung für Nachhaltigkeit program of the Germany Bundesministerium für Bildung und Forschung (BMBF). We are grateful for the open source community that facilitated this research, amongst them the developers of and contributors to NetLogo, Python, R, pandoc, and $\LaTeX$.

# References

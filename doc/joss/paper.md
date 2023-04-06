---
title: 'A NetLogo Agent-based Model of German North Sea Small-scale fisheries'
tags:
  - NetLogo
  - Agent-based Model
  - ABM
  - North Sea
  - Fisheries
  - MuSSeL project
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
affiliations:
 - name: Helmholtz-Zentrum Hereon, Germany
   index: 1
 - name: University of Hamburg, Germany
   index: 2
 - name: Hochschule Bremerhaven, Bremerhaven, Germany
   index: 3
date: 6 April 2023
bibliography: paper.bib
SPDX-FileCopyrightText: 2022-2023  Helmholtz-Zentrum hereon GmbH (hereon)
SPDX-License-Identifier: CC-BY-4.0
SPDX-FileContributor: Carsten Lemmen
---

# Summary

The Agent-based Model (ABM) of the German North Sea Small-scale Fisheries is a Social-Ecological Systems (SES) model focussing on the adaptive behaviour of fishers facing regulatory, economic, and resource changes.  
Small-scale fisheries are an important part both of the cultural perception of the German North Sea coast and of its fishing industry. These fisheries are typically family-run operations that use smaller boats and traditional fishing methods to catch a variety of bottom-dwelling species, including plaice, sole, brown shrimp.

Fisheries in the North Sea face area competition with other uses of the sea---long practiced ones like shipping, gas exploration and sand extractions, and currently increasing ones like marine protection and offshore wind farming (OWF).  German authorities have just released a new maritime spatial plan implementing the need for 30% of protection areas demanded by the United Nations High Seas Treaty and aiming at up to 70 GW of offshore wind power generation by 2045.  
Fisheries in the North Sea also have to adjust to the northward migration of their established resources following the climate heating of the water.  And they have to re-evaluate their economic balance by figuring in the foreseeable rise in oil price and the need for re-investing into their aged fleet.

# Statement of need

The purpose of this ABM is to provide an interactive simulation environment that describes spatial, temporal and structural adaptations of the fleet.  It adaptively describes
 
 * where to fish  and how far to go out to sea
 * how often to go out
 * what gear to use and what species to target

Its scope is the German North Sea small-scale fisheries.  This encompasses some 300 vessels based in German ports along the North Sea coast and fishing in the German Bight, including but not restricted to Germany's exclusive economic zone (EEZ). The target species described by the model are currently restricted to the most important ones: plaice, sole and brown shrimp, but is in principle extensible to further target species like Norwegian lobster or whiting. 

The intended audience of the ABM are marine researchers and government agencies concerned with spatial planning, environmental status assessment, and climate change mitigation.  It can also assist in a stakeholder dialogue with tourism and fishers to contextualize the complexity of the interactions between fisheries economics, changing resources and regulatory restrictions.  It is intended to be used for scenario development for future sustainable fisheries at the German North Sea coast.

# Key features of the ABM

As a NetLogo implementation, the model is embedded in an integrated development environment (IDE), which integrates a (frontend) user interface, its basic documentation, and the (backend) code in a single integrated development environment, that can be run in  NetLogo [@Wilensky1999; version 6 required], a Java-based portable ABM and system dynamics simulation platform.

The backend (code) features geospatial data access and integration of multiple georeferenced and tabular data sources, as well as integrating Web Mapping Services (WMS) to describe the grid-based environmental context. This environmental context is dynamic in time, providing seasonal resource changes and dynamic area closures.

Agents are boats,  the gear they use, the strategies they employ, and their prey.  All agents are encapsulated in object-oriented design as NetLogo breeds.  The agents' methods implement the interaction rules between agents and between agents and their environment.  Key interactions are the movement rules of boats across the seascape, the harvesting of resources, and the cost-benefit analysis of a successful catch and its associated costs.  Adaptation occurs at the level of preference changes for gear selection (and prey species), and the time and distance preferences for fishing trips.  

The user interface provides an interactive environment, perusing all NetLogo graphical features.  Informational elements include a (georeferenced) map view, and several histograms and temporal scatter panels.  Interactive elements include switches for toggling information on and off, choosers to toggle which information to show, buttons to control the simulation and sliders to adjust boundary conditions, such as the oil price.

# Notable programming and software development features

A notable programming feature is the integration of the legend with the `view`, a feature that is lacking from the default capabilities of NetLogo.  There have been discussions on how to implement a legend using the `plot` element and using the `bitmap` extension [@Stackoverflow2018], but so far this is the only NetLogo model known to the authors implementing a legend with the `view` using basic agents. 

Currently, most NetLogo models have not used continuous integration (CI) and continous deployment (CD).  With our implementation, we demonstrate how CI can be used for NetLogo by making use of NetLogo's `BehaviorSpace` tool that runs a suite of unit tests.  We also use  `BehaviorSpace` for the CD of generating the resulting maps of fishing effort under different scenarios.

# Model documentation and license

The model is documented in short form in the NetLogo's `Info` section in the IDE. A full documentation following the Overview, Design, and Details [@Grimm2020; ODD] standard protocol for ABM is available in the repository as `doc/odd/paper.md`. 

All data from third parties is licensed under various open source licenses.  The model, its results and own proprietary data is released under open source licenses, mostly Apache 2.0 and CC-BY-SA-4.0.  A comprehensive documentation of all is provided via @FSF2023. 

<!--

Figures can be included like this:
![Caption for example figure.\label{fig:example}](figure.png){ width=20% }
and referenced from text using \autoref{fig:example}.

--> 

# Acknowledgements

We acknowledge contributions from Wolfgang Probst, Marie Ryan, Jieun Seo, and Jürgen Scheffran for providing data, fruitful discussions and for contributing to the ODD document. We thank all members of the MuSSeL consortium making this software relevant in a research context.  The development of the model was made possible by the grant 03F0862A "Multiple Stressors on North Sea Life" within the 3rd Küstenforschung Nord-Ostsee (KüNO) call of the Forschung für Nachhaltigkeit program of the Germany Bundesministerium für Bildung und Forschung (BMBF).  

# References


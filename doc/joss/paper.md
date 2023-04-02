---
title: 'An Agent-Based Model for North Sea fisheries'
tags:
  - NetLogo
  - Agent-based Model
  - ABM
  - North Sea
  - Fisheries
  - MuSSeL project
authors:
  - name: Carsten Lemmen
    orcid: 0000-0000-0000-0000
    equal-contrib: true
    affiliation: "1" # (Multiple affiliations must be quoted)
    corresponding: true
  - name: Sascha Hokamp
    equal-contrib: true # (This is how you can denote equal contributions between multiple authors)
    affiliation: 2
  - name: Serra Örey
    affiliation: 3
affiliations:
 - name: Helmholtz-Zentrum Hereon, Germany
   index: 1
 - name: University of Hamburg, Germany
   index: 2
 - name: Independent Researcher, Country
   index: 3
date: 1 January 2023
bibliography: paper.bib
SPDX-FileCopyrightText: 2022 Helmholtz-Zentrum hereon GmbH (hereon)
SPDX-License-Identifier: CC-BY-4.0
SPDX-FileContributor: Carsten Lemmen
---

# Summary

The Agent-based Model (ABM) of the German North Sea Small-scale Fisheries is a Social-Ecological Systems (SES) model focussing on the adaptive behaviour of fishers facing regulatory, economic, and resource changes.  
Small-scale fisheries are an important part both of the cultural perception of the German North Sea coast and of its fishing industry. These fisheries are typically family-run operations that use smaller boats and traditional fishing methods to catch a variety of bottom-dwelling species, including plaice, sole, brown shrimp.

Fisheries in the North Sea face area competition with other uses of the sea -- long practiced ones like shipping, gas exploration and sand extractions, and currently increasing ones like marine protection and offshore wind farming (OWF).  German authorities have just released a new maritime spatial plan implementing the need for 30% of protection areas demanded by XXX and allowing up to 70 GW of offshore wind power generation.  

Fisheries in the North Sea also have to adjust to the northward migration of their established resources following the climate heating of the water.  And they have to re-evaluate their economic balance by figuring in the foreseeable rise in oil price and the need for re-investing into their aged fleet.

# Statement of need

The purpose of this ABM is to provide an interactive simulation environment that describes spatial, temporal and structural adaptations of the fleet.  It adaptively describes
 
 * where to fish  and how far to go out to sea
 * how often to go out
 * what gear to use and what species to target

Its scope is the German North sea small-scale fisheries.  This encompasses some 300 vessels based in German ports along the North Sea coast and fishing in the German Bight, including but not restricted to Germany's exclusive economic zone (EEZ). The target species is currently restricted to the most important ones: plaice, sole and brown shrimp, but is in principle extensible to further target species like Norwegian lobster or whiting. 

The intended audience of the ABM are marine researchers and government agencies concerned with spatial planning, environmental status assessment, and climate change mitigation.  It can also assist in a stakeholder dialogue with tourism and fishers to contextualize the complexity of the interactions between fisheries economics, changing resources and regulatory restrictions.  It is intended to be used for scenario development for future sustainable fisheries at the German North Sea coast.


# Mathematics

<!-- 
Single dollars ($) are required for inline mathematics e.g. $f(x) = e^{\pi/x}$

Double dollars make self-standing equations:

$$\Theta(x) = \left\{\begin{array}{l}
0\textrm{ if } x < 0\cr
1\textrm{ else}
\end{array}\right.$$

You can also use plain \LaTeX for equations
\begin{equation}\label{eq:fourier}
\hat f(\omega) = \int_{-\infty}^{\infty} f(x) e^{i\omega x} dx
\end{equation}
and refer to \autoref{eq:fourier} from text.


- `@author:2001`  ->  "Author et al. (2001)"
- `[@author:2001]` -> "(Author et al., 2001)"
- `[@author1:2001; @author2:2001]` -> "(Author1 et al., 2001; Author2 et al., 2002)"

Figures can be included like this:
![Caption for example figure.\label{fig:example}](figure.png){ width=20% }
and referenced from text using \autoref{fig:example}.


--> 

# Acknowledgements

We acknowledge contributions from Wolfgang Probst, Seong Jieun, and Jürgen Scheffran for providing data, fruitful discussions and contributing to the ODD document. We thank all members of the MuSSeL consortium making this software relevant in a research context.  The development of the model was made possible by the grant Multiple Stressors on North Sea Life within the 3rd Küstenforschung Nord-Ostsee (KüNO) call of the Forschung für Nachhaltigkeit program of the Germany Research and Education ministry (BMBF).  

# References


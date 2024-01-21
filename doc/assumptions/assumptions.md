---
title: "Assumptions provenance for the Viable North Sea (ViNoS) model"
tags:
  - Assumptions
  - TRACE
  - NetLogo
  - Agent-based Model
  - ABM
  - North Sea
  - Fisheries
  - MuSSeL project
  - VIABLE
  - ViNoS
authors:
  - name: Carsten Lemmen
    orcid: 0000-0003-3483-6036
    affiliation: 1
    corresponding: true
affiliations:
  - name: Helmholtz-Zentrum Hereon, Institute of Coastal Systems - Modeling and Analysis, Germany, carsten.lemmen@hereon.de
    index: 1
date: 5 Dec 2023
year: 2023
SPDX-FileCopyrightText: 2023  Helmholtz-Zentrum hereon GmbH
SPDX-License-Identifier: CC-BY-4.0
SPDX-FileContributor: Carsten Lemmen
---

# The Viable North Sea model

Viable North Sea (ViNoS) is an Agent-based Model (ABM) of the German Small-scale Fisheries. As a Social-Ecological Systems model it focusses on the adaptive behaviour of fishers facing regulatory, economic, and resource changes. Small-scale fisheries are an important part both of the cultural perception of the German North Sea coast and of its fishing industry.

This Assumptions Provenance document provides a detailed account of the many, and often hidden (Grimm, 2023) assumptions made when drafting a model. The categorization of assumptions follows an unpublished suggestion by Bruce Edmonds shown below:

| Provenance          | Description                                                                                                        |
| ------------------- | ------------------------------------------------------------------------------------------------------------------ |
| Theory              | An existing published theory (suitably formulated)                                                                 |
| Empirical Studies   | The conclusion of an empirical study suggests it                                                                   |
| Common Sense        | The assumption is obvious (e.g. drivers stick to the roads)                                                        |
| Expert Opinion      | A domain expert has suggested it                                                                                   |
| Stakeholder Account | An analysis of an account by a stakeholder                                                                         |
| Data                | The feature has been specified directly using data                                                                 |
| Guesswork           | The modeller has invented the feature (e.g. exact form of an equation)                                             |
| Past Modelling      | Past models have done it this way                                                                                  |
| Focus Hypotheses    | The assumption is the focus of the study for testing or exploration                                                |
| Stated Assumption   | A focus assumption explicitly labelled as such                                                                     |
| Proxy               | The element might stand in for something unknown or very complex (e.g. a random generator for a behavioral choice) |
| Convenience         | Something to make the model work (or work more efficiently)                                                        |
| Simplicity          | Something to make the modeling easier/simpler (often just an acceptable version of “Convenience”)                  |

# Assumption provenance

## Assumptions on entities

The major entities in ViNoS are boats, preys, and ports.

We assume that boat captains memorize a bounded set of prior fishing locations and the amount of the last catch at those locations. The size of the memory is a **_Guesswork_** assumption and ranges between 1 and 20; where the upper threshold is a **_Convenience_** assumption to control maximum memory usage. The size of the memory can be manipulated and its effects explored by the interactive model dashboard.

The memorized location is not exact but depends on the resolution of the model, it is typically a 1.4 sqkm square area (dependent on model resolution) that is remembered. This restriction is a **_Convenience_** assumption to be able to manage efficiently overlapping (esp: avoiding nearby duplicates) memory. Also, the direction of the fishing activity within this square area is not recorded for **_Simplicity_**.

The update of the memory follows the rule that new and better catches replace the memory of older and lesser catches. This is a **_Common sense_** assumption that fishers rather remember good catches than bad ones. Also, the catch at an already remembered location is updated with the most recent catch, also a **_Common Sense_** assumption.

### References

Volker Grimm (2023), Ecology needs to overcome siloed modelling, Trends in Ecology & Evolution, Volume 38, Issue 12, Pages 1122-1124, https://doi.org/10.1016/j.tree.2023.09.011.

Lemmen, C., Hokamp, S., Örey, S., & Scheffran, J. (2024). Viable North Sea (ViNoS): A NetLogo Agent-based Model of German Small-scale Fisheries. Journal of Open Source Software, under review. Available from: [https://joss.theoj.org/papers/84a737c77c6d676d0aefbcef8974b138](https://joss.theoj.org/papers/84a737c77c6d676d0aefbcef8974b138)

Lemmen, C., Hokamp, S., Örey, S., Scheffran, J., & Seo, J. (2023). ODD Protocol for Viable North Sea (ViNoS): A NetLogo Agent-based Model of German Small-scale Fisheries. CoMSES Computational Model Library. Available from: [https://www.comses.net/codebases/f654945f-8129-46a8-9c2d-f2a1b923f543/releases/](https://www.comses.net/codebases/f654945f-8129-46a8-9c2d-f2a1b923f543/releases/)

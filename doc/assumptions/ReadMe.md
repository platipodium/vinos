<!--
SPDX-FileCopyrightText: 2023-2024 Helmholtz-Zentrum hereon GmbH
SPDX-FileContributor: Carsten Lemmen
SPDX-License-Identifier: CC0-1.0
-->

This directory contains the sources for generating an assumptions documentation
based on ideas by Bruce Edmonds on documenting all the inherent assumptions in
a model

The manuscript is contained in the `assumptions.md` markdown document.
With the help of the `pandoc` document converter, PDF, Latex, Word and other formats can be built, facilitated by the `Makefile` generator.

Bruce suggests the folloing provenances for assumptions:

Modelling assumptions can come from many different sources, for example:
Theory – an existing published theory (suitably formulated)
Empirical Studies – the conclusion of an empirical study suggests it
Common Sense – the assumption is obvious (e.g. drivers stick to the roads)
Expert Opinion – a domain expert has suggested it
Stakeholder Account – an analysis of an account by a stakeholder
Data – the feature has been specified directly using data (e.g. a map)
Guesswork – the modeller has invented the feature (e.g. exact form of an equation)
Past modelling – past models have done it this way
Focus Hypotheses – the assumption is the focus of the study for testing or exploration
Stated assumption – a focus assumption explicitly labelled as such
Proxy – the element might stand in for something unknown or very complex (e.g. a random generator for a behavioural choice)
Convenience – something to make the model work (or work more efficiently)
Simplicity – something to make the modelling easier/simpler (often just an acceptable version of “Convenience”)

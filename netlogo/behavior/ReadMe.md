<!--
SPDX-FileContributor: Carsten Lemmen <carsten.lemmen@hereon.de>
SPDX-FileCopyrightText: 2024 Helmholtz-Zentrum hereon GmbH
SPDX-License-Identifier: CC0-1.0
-->

This folder contains NetLogo BehaviorSpace definition files for experiments
in XML format.

## Experiments

Variational experiments with wage and fuel costs

- no-fuel-cost.xml
- vary-diesel-wage.xml
- vary-diesel.xml
- vary-wage.xml

## Continuous Integration (CI)

default.xml
: Simple experiment setting one? = false and output-frequency to weekly, to be used as a quick test for functionality of the behavior space output

profile.xml
: Runs profiling

reproducibility.xml
: Runs reproducibility tests

unit-tests.xml
: Runs the unit tests for all NetLogo procedures

## Continuous Deployment (CD)

effort-map.xml
: Creates the primary product, an effort map

rtd-maps.xml
: Runs the simulation to produce ReadTheDocs maps

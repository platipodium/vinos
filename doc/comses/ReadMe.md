<!--
SPDX-FileCopyrightText: 2023-2024 Helmholtz-Zentrum hereon GmbH
SPDX-FileContributor: Carsten Lemmen <carsten.lemmen@hereon.de>
SPDX-License-Identifier: CC0-1.0
-->

This directory contains the sources for generating the Comses.net version of the model and ODD protocol

For submission of the ODD to Comses.net, please consider the following directory structure:

A codebase release should ideally include the source code, documentation, input data and dependencies necessary for someone else (including your future self) to understand, replicate, or reuse the model. Please note that we impose a specific directory structure to organize your uploaded files - you can view the active filesystem layout below. Source code is placed in project-root/code/, data files are placed in project-root/data/, and documentation files are placed in project-root/docs/, and simulation outputs are placed in project-root/results/. This means that if your source code has references to your uploaded data files you should consider using the relative path ../data/<datafile> to access those data files. This will make the lives of others wishing to review, download and run your model easier.

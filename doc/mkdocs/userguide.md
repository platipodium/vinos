<!--
SPDX-FileCopyrightText: 2023 Universität Hamburg
SPDX-FileCopyrightText: 2023 Helmholtz-Zentrum hereon GmbH
SPDX-License-Identifier: CC0-1.0
SPDX-FileContributor: Verena Mühlberger <verena.muehlberger@uni-hamburg.de>
SPDX-FileContributor: Carsten Lemmen <carsten.lemmen@hereon.de>
-->

# ViNoS user guide

## Setup

The model will automatically set up its graphical user interface (GUI) when opened. To **reset** the model after a run, pressing the `setup` bottom will

- clear all plots,
- reload all maps
- change the base map back to the default map, i.e. the
  German Bight's ocean floor bathymetry

The `setup` button will not reset sliders or switches to their
default values.

## Scene

The scene allows to track the boats on their fishing trips visually. After pressing the go button, the boats start to move around the scene. The movements are drawn on the scene and exported to the results folder connected to the model.

The results describe the fishing-effort-hours and are saved as ASCII raster files. The date and time are displayed in the scene's lower right corner. On days which are Sundays or holidays, the date-time will be in red, on all other days in white.

The legend in the upper left corner is updated depending on the information displayed. To change the information, one can choose from different base maps on the left-hand side of the scene. Additional information can be added by using the sliders on the right-hand side. It is important to remember that the absolute values of the different fish species are differing in magnitude.

The possible base maps are:
• Shrimp: Shrimp distirbution
• Plaice: Plaice distribution
• Sole: Sole distribution
• Bathymetry: ocean floor bathymetry
• Effort:
• Accessibility:
• OWF: offshore wind farm
• Area
• Swept area ratio
• Shore proximity
• Depth
• Tide
• Action
• Traffic
• Catch

## Sliders

Different sliders are surrounding the scene. Some have an effect on the displayed information in the scene, and others will change the variables the model is running on.
Slider changing the variables only affects the model and thus the model output when the setup button is called. This means that the variables can not be changed while running a specific simulation. These sliders include:
• fraction-transportation-costs
• memory size, adaptation rate
• operating-costs-of-boats
• the time-offset
• oil-price
• wage (for the fishers on the boat)
To create several model runs comparing the effect of these variables, the setup-bottom has to be called in between.
There are two slider which directly affects the displayed information:

    • one? (next to the go-bottom) allows to follow only one boat

This option can be turned on and off within one specific simulation. The plots will adapt to this and display the specific information of the boat which is followed. Within a simulation, the model will always return to the same boat when one? is switched on. To follow another boat, a new simulation has to be started. In the scene, the information is shown by a circle around the followed boat.

    • show-values? This slider works like the one?-slider. The information will immediately be added or removed when called.

The sliders on the right-hand side of the map allow for adding more information to the scene. To add or delete them to/from the scene, press the update button below.
• Boats? and ports?: Showing the boats and German ports allows for a more visual understanding of the model
• Owf?: adding the offshore-wind-farms (owf) displays areas which will impact fishing directly in the future
• Box?: draws the plaice box, which marks the area where it is forbidden to catch plaice
• Sar?: gives a more detailed picture of the ocean floor derived from a NOAA Synthetic Aperture Radar Scan

## Plots

Underneath the scene are the plots.
• Catch, shows the catch-by-gear
• gain-by-gear, shows the monetary gain by gear
• priority-by-gear, shows the change in the priority for a specific gear
• The boat-property plot can be changed. The displayed information can be updated by choosing from the list in the chooser above. After pressing update-plot next to the chooser, the new information will be displayed in the histogram.
• The action plot works similarly to the boat-property plot. The displayed information can be updated by choosing from the list in the chooser above. After pressing update-plot next to the chooser the new information will be displayed in the histogram.

# SPDX-FileCopyrightText: 2022-2024 Helmholtz-Zentrum hereon GmbH
# SPDX-License-Identifier: CC0-1.0
# SPDX-FileContributor: Carsten Lemmen <carsten.lemmen@hereon.de

.PHONY: all download unzip

all: download unzip

plan.zip: download

download:
	curl --output plan.zip https://data.bsh.de/SpatialData/Main/Raumordnungsplan_AWZ/Raumordnungsplan_AWZ.zip

unzip:  plan.zip
	unzip plan.zip

clean:
	@rm -f *zip
	@rm -f BirdMigration.* CablesAndPipelines.* ConnectingGate.* Defence.* DiversGaviaStellataGaviaArctica.* \
	  Fishery.* HarbourPorpoisesPhocoenaPhocoena.* NatureConservation.* OffshoreWindEnergy.* \
	  RawMaterialExtraction.* ScientificResearch.* Shipping.* TemporaryExclusionOfInstallationsAboveWaterSurface.*

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

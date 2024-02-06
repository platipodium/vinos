# SPDX-FileCopyrightText: 2023-2024 Helmholtz-Zentrum hereon GmbH
# SPDX-License-Identifier: CC0-1.0
# SPDX-FileContributor Carsten Lemmen <carsten.lemmen@hereon.de

default:

mp4:
	for Y in 2020 2030; do convert tide_*_${Y}*.png tide_${Y}.mp4; done

clean:
	@rm -f *.mp4 *.prj *.asc *.png

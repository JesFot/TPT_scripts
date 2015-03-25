--NOEL
-- Needed : base, source, name, description and colour
-- Temperature en °C, doit ajouter :temp
--
--
words
3
START
test
base:DEFAULT_PT_DMND
source:element
name:TEST
description:My test element
colour:0xFFFFFF:number
--menuVisible:1:number
menuSection:SC_SOLIDS
hotAir:0:number
weight:0:number
temperature:30:number:temp
END

--blabla

START
frgr
base:DEFAULT_PT_DMND
source:element
name:FRGR
description:Another element
colour:0x00000020:number
menuVisible:0:number
menuSection:SC_SOLIDS
END

START
stax
base:DEFAULT_PT_DUST
source:wiki
name:STAX
description:STAX. Enough Pressure Makes It Explode Into VIRS.
colour:0xFFFFFF:number
menuSection:SC_SOLIDS
--HotAir:-0.507:number
weight:0:number
temperature:30:number:temp
highTemperature:200:number:temp
highPressure:200:number
highTemperatureTransition:DEFAULT_PT_DMND:elements
highPressureTransition:DEFAULT_PT_VIRS:elements
hardness:0:number
END

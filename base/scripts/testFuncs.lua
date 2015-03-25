local this = {}
this.configFolder = "config/"
this.elementFile = this.configFolder.."elements.els"
this.utilFolder = ""
this.downloadedScripts = "scripts/downloaded/"
this.scriptsFolder = "scripts/"
this.pwd = "scripts/"
this.name = "testFuncs"
this.ext = ".lua"
this.logFile = this.utilFolder..this.name..".log"
addonReader = {}

addonReader.Commands = {
	testjsft = function(self, msg, args)
		JSFT.log("INFO", "Client perform referenced command testjsft with arguments "..string.tostr(args))
		self:addline("This is a simple test command.", 200, 200, 200, true)
	end
}

if fs.exists(this.scriptsFolder.."2 cracker64-TPTMulti.lua") or fs.exists(this.scriptsFolder.."TPTMulti_client.lua") then
	addonReader.dofileTPTMP = true
	this.myTPTMP = dofile(this.scriptsFolder.."2 cracker64-TPTMulti.lua") or dofile(this.scriptsFolder.."TPTMulti_client.lua")
elseif fs.exists(this.downloadedScripts.."2 cracker64-TPTMulti.lua") then
	addonReader.dofileTPTMP = true
	this.myTPTMP = dofile(this.downloadedScripts.."2 cracker64-TPTMulti.lua")
else
	addonReader.dofileTPTMP = false
end

local function step()
	-- body
end

function string.tostr(table)
	local str = ""
	for k,v in pairs(table) do
		str = str..v..", "
	end
	str = string.sub(str, 1, -3) or "\"null\""
	if str == "" then
		str = "\"null\""
	end
	return str
end

function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function string.ends(String,End)
   return End=='' or string.sub(String,-string.len(End))==End
end

function editProp(element, property, modifier)
	local prop = elements.property(element, property)
	if modifier ~= nil then
		elements.property(element, property, modifier)
	end
	return prop
end

function this.createElement(name, baseEl, data)
	local el = elements.allocate(string.upper(data.source), data.name)
	elements.element(el, elements.element(elements[baseEl]))
	elements.property(el, "Name", data.name)
	editProp(el, "Description", data.description)
	elements.property(el, "Colour", data.colour)
	elements.property(el, "MenuSection", elem[data.menuSection])
	for k,v in pairs(data) do
		if not (k=="source" or k=="name" or k=="description" or k=="colour" or k=="menuSection") then
			this.log("DEBUG", "Added suplementary property : "..k)
			editProp(el, string.upper(string.sub(k, 0, 1))..string.sub(k, 2, -1), v)
		end
	end
	this.log("INFO", "Created new element "..name..".")
end

local function createElements(nbEl, data, baseEls, names)
	local i=1
	while i<names.n+1 do
		if data[names[i]].source == nil or data[names[i]].source == "" then
			data[names[i]].source = "element"
		end
		this.createElement(names[i], baseEls[names[i]], data[names[i]])
		i = i+1
	end
	this.log("INFO", "Created "..nbEl.." elements.")
end

local logFileS = io.open(this.logFile, "a")
function this.initLog()
	logFileS:write("-----------------NEW LOG-----------------\n")
	logFileS:write("*******Loaded at "..os.date().."*******\n")
	logFileS:flush()
end
this.initLog()
function this.log(lvl, msg)
	local txt = "("..os.date()..")["..lvl.."] "..msg.."\n"
	logFileS:write(txt)
	logFileS:flush()
end
function this.clearLog()
	logFileS:close()
	local logFil = io.open(this.logFile, "w")
	logFil:write("")
	logFil:close()
	logFileS = io.open(this.logFile, "a")
	this.initLog()
end

local tmpEl = {}
local tmpElnb = {n=0}
local baseElem = {}
local indic = -200

local function decodeEl(increment, line)
	if line == "START" then
		indic = 0
	end
	if line == "END" then
		indic = -200
	end
	if indic == 1 then
		tmpEl[line] = {}
		tmpElnb.n = tmpElnb.n + 1
		tmpElnb[tmpElnb.n] = line
	end
	if indic >= 2 then
		local prop = {}
		for p in string.gmatch(line, '([^:]+)') do
			table.insert(prop, p)
		end
		if prop[3] == "number" then
			prop[2] = tonumber(prop[2])
			if prop[4] == "temp" then
				prop[2] = prop[2]+274
			end
		elseif prop[3] == "elements" then
			prop[2] = elements[prop[2]]
		end
		if prop[1] == "base" then
			baseElem[tmpElnb[tmpElnb.n]] = prop[2]
		else
			tmpEl[tmpElnb[tmpElnb.n]][prop[1]] = prop[2]
		end
	end
	indic = indic + 1
end

local elementsFile = io.open(this.elementFile, "r")

function this.scanElements()
	local i = 1
	local numberofEl = 1
	for line in elementsFile:lines() do
		if i <= 5 then
			if i == 0 and line == "NOEL" then
				this.log("INFO", "\"NOEL\"")
				break
			end
		end
		if i == 6 then
		end
		if i == 7 then
			numberofEl = tonumber(line)
			if numberofEl == 0 then
				this.log("WARN", "No elements to load ad there is no \"NOEL\".")
				break
			end
		end
		if i >= 8 then
			if not string.starts(line, "--") then
				decodeEl(i, line)
			end
		end
		i = i + 1
	end
	createElements(numberofEl, tmpEl, baseElem, tmpElnb)
end

this.scanElements()

JSFT = this
tpt.register_step(step)

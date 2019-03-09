local surface = surface

-- Fonts
surface.CreateFont("PureSkinMSTACKImageMsg", {font = "Trebuchet24", size = 21, weight = 1000})
surface.CreateFont("PureSkinMSTACKMsg", {font = "Trebuchet18", size = 15, weight = 900})
surface.CreateFont("PureSkinRole", {font = "Trebuchet24", size = 30, weight = 700})
surface.CreateFont("PureSkinBar", {font = "Trebuchet24", size = 21, weight = 1000})
surface.CreateFont("PureSkinWep", {font = "Trebuchet24", size = 21, weight = 1000})
surface.CreateFont("PureSkinWepNum", {font = "Trebuchet24", size = 21, weight = 700})

-- base drawing functions
include("cl_drawing_functions.lua")

local base = "hud_base"

DEFINE_BASECLASS(base)

HUD.Base = base

local defaultColor = Color(49, 71, 94)
local defaultScale = 1.0

HUD.previewImage = Material("vgui/ttt/huds/pure_skin/preview.png")

local savingKeys

function HUD:GetSavingKeys()
	if not savingKeys then
		savingKeys = BaseClass.GetSavingKeys(self)
		savingKeys.basecolor = {
			typ = "color",
			desc = "BaseColor",
			OnChange = function(slf, col) 
				self:PerformLayout()
			end
		}
		savingKeys.scale = {
			typ = "scale",
			desc = "Reset Positions and set HUD Scale",
			OnChange = function(slf, val)
				local scaleMultiplier = val / self.scale
				self:ApplyScale(scaleMultiplier)
				self:SaveData()
			end	
		}
	end

	return table.Copy(savingKeys)
end

HUD.basecolor = defaultColor
HUD.scale = defaultScale

function HUD:Initialize()
	self:ForceElement("pure_skin_playerinfo")
	self:ForceElement("pure_skin_roundinfo")
	self:ForceElement("pure_skin_wswitch")
	self:ForceElement("pure_skin_drowning")
	self:ForceElement("pure_skin_mstack")
	self:ForceElement("pure_skin_items")
	self:ForceElement("pure_skin_miniscoreboard")
	self:ForceElement("pure_skin_punchometer")
	self:ForceElement("pure_skin_target")

	BaseClass.Initialize(self)
end

function HUD:Loaded()
	for _, elem in ipairs(self:GetElements()) do
		local el = hudelements.GetStored(elem)
		if el then
			local min_size = el.defaults.minsize
			el:SetMinSize(min_size.w * self.scale, min_size.h * self.scale)
			el:PerformLayout()
		end
	end
end

function HUD:ApplyScale(scale)
	for _, elem in ipairs(self:GetElements()) do
		local el = hudelements.GetStored(elem)
		if el then
			local size = el:GetSize()
			local min_size = el:GetMinSize()
			el:SetMinSize(min_size.w * scale, min_size.h * scale)
			el:SetSize(size.w * scale, size.h * scale)
			el:PerformLayout()      --code from here will be replaced by a Reset call
			el:RecalculateBasePos()
			el:PerformLayout()
		end
	end
end

function HUD:Reset()
	self.basecolor = defaultColor
	BaseClass.Reset(self)

	self:ApplyScale(self.scale)
end

-- Voice overriding
include("cl_voice.lua")

-- Popup overriding
include("cl_popup.lua")

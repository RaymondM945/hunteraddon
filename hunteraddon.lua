local enableaddon = true
local useArcaneShot = true
local MeleeMode = false
local isFollowing, followName = false, nil
local box = CreateFrame("Frame", "MyBlackBox", UIParent)
box:SetSize(25, 25)
box:SetPoint("CENTER")

box.texture = box:CreateTexture(nil, "BACKGROUND")
box.texture:SetAllPoints()
box.texture:SetColorTexture(0, 0, 0, 1)

local checkbox = CreateFrame("CheckButton", "MyAddonCheckbox", UIParent, "UICheckButtonTemplate")
checkbox:SetSize(24, 24)
checkbox:SetPoint("TOP", 0, -25)
checkbox.text = checkbox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
checkbox.text:SetPoint("LEFT", checkbox, "RIGHT", 4, 0)
checkbox.text:SetText("Enable Addon")
checkbox:SetChecked(enableaddon)
checkbox:SetScript("OnClick", function(self)
	if self:GetChecked() then
		print("Checkbox checked")
		enableaddon = true
	else
		print("Checkbox unchecked")
		enableaddon = false
	end
end)

local checkbox2 = CreateFrame("CheckButton", "MyAddonCheckbox2", UIParent, "UICheckButtonTemplate")
checkbox2:SetSize(24, 24)
checkbox2:SetPoint("TOP", checkbox, "BOTTOM", 0, -10) -- Position below the first checkbox
checkbox2.text = checkbox2:CreateFontString(nil, "OVERLAY", "GameFontNormal")
checkbox2.text:SetPoint("LEFT", checkbox2, "RIGHT", 4, 0)
checkbox2.text:SetText("Use Arcane Shot")
checkbox2:SetChecked(useArcaneShot)
checkbox2:SetScript("OnClick", function(self)
	if self:GetChecked() then
		useArcaneShot = true
	else
		useArcaneShot = false
	end
end)

local checkbox3 = CreateFrame("CheckButton", "MyAddonCheckbox3", UIParent, "UICheckButtonTemplate")
checkbox3:SetSize(24, 24)
checkbox3:SetPoint("TOP", checkbox2, "BOTTOM", 0, -10) -- stack under checkbox2
checkbox3.text = checkbox3:CreateFontString(nil, "OVERLAY", "GameFontNormal")
checkbox3.text:SetPoint("LEFT", checkbox3, "RIGHT", 4, 0)
checkbox3.text:SetText("Melee Mode") -- name it whatever you want
checkbox3:SetChecked(MeleeMode)

checkbox3:SetScript("OnClick", function(self)
	MeleeMode = self:GetChecked()
	print("Melee Mode: " .. tostring(MeleeMode))
end)

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("AUTOFOLLOW_BEGIN")
f:RegisterEvent("AUTOFOLLOW_END")
f:SetScript("OnEvent", function(self, event, arg1)
	if event == "ADDON_LOADED" and arg1 == "MyAddon" then
	elseif event == "AUTOFOLLOW_BEGIN" then
		isFollowing, followName = true, arg1
		print("Following:", followName)
	elseif event == "AUTOFOLLOW_END" then
		isFollowing, followName = false, nil
		print("Follow ended")
	end
end)

local loopFrame = CreateFrame("Frame")

loopFrame:SetScript("OnUpdate", function(self, elapsed)
	box.texture:SetColorTexture(0, 0, 0, 1)

	if enableaddon then
		if IsInGroup() then
			if UnitAffectingCombat("party1") then
				box.texture:SetColorTexture(1, 1, 0, 1)

				if UnitExists("party1target") and UnitIsVisible("party1target") and not UnitIsDead("party1target") then
					local currentHP = UnitHealth("party1target")
					local maxHP = UnitHealthMax("party1target")

					local hpPercent = (currentHP / maxHP) * 100

					local feign = AuraUtil.FindAuraByName("Feign Death", "player", "HELPFUL")

					if hpPercent < 95 and not feign then
						if MeleeMode then
							local usable4, noMana4 = IsUsableSpell("Raptor Strike")
							local channelspell = UnitChannelInfo("player")

							if channelspell then
							else
								if not UnitIsUnit("target", "party1target") then
									box.texture:SetColorTexture(1, 1, 1, 1)
								elseif not isFollowing then
									box.texture:SetColorTexture(0, 1, 0, 1)
								elseif not name4 and usable4 then
									box.texture:SetColorTexture(0, 0, 1, 1)
								elseif not IsCurrentSpell("Attack") then
									box.texture:SetColorTexture(1, 0, 0, 1)
								else
									box.texture:SetColorTexture(1, 1, 0, 1)
								end
							end
						else
							local serpentStingName = GetSpellInfo(1978)
							local huntersMarkName = GetSpellInfo(1130)
							local name, _, _, _, _, _, sourceUnit =
								AuraUtil.FindAuraByName(serpentStingName, "party1target", "HARMFUL")
							local name2, _, _, _, _, _, sourceUnit2 =
								AuraUtil.FindAuraByName(huntersMarkName, "party1target", "HARMFUL")

							local usable, noMana = IsUsableSpell(serpentStingName)
							local usable2, noMana2 = IsUsableSpell(huntersMarkName)
							local usable3, noMana3 = IsUsableSpell("Arcane Shot")
							local channelspell = UnitChannelInfo("player")

							if channelspell then
							else
								if not UnitIsUnit("target", "party1target") then
									box.texture:SetColorTexture(1, 1, 1, 1)
								elseif not IsAutoRepeatSpell("Auto Shot") then
									box.texture:SetColorTexture(1, 0, 0, 1)
								elseif not name2 and usable2 then
									box.texture:SetColorTexture(0, 0, 1, 1)
								elseif not name and usable then
									box.texture:SetColorTexture(0, 1, 0, 1)
								elseif not name3 and usable3 and useArcaneShot then
									box.texture:SetColorTexture(0.5, 0, 1, 1)
								else
									box.texture:SetColorTexture(1, 1, 0, 1)
								end
							end
						end
					end
				else
				end
			else
				box.texture:SetColorTexture(0, 0, 0, 1)
			end
		end
	end
end)

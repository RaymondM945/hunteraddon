local enableaddon = true
local useArcaneShot = true
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
		print("Track Feign Death enabled")
		useArcaneShot = true
	else
		print("Track Feign Death disabled")
		useArcaneShot = false
	end
end)

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addonName)
	if addonName == "MyAddon" then
	end
end)

local loopFrame = CreateFrame("Frame")

loopFrame:SetScript("OnUpdate", function(self, elapsed)
	box.texture:SetColorTexture(0, 0, 0, 1)

	if enableaddon then
		if UnitExists("pet") and UnitExists("pettarget") and not UnitIsUnit("target", "pettarget") then
			print("Your pet is attacking a different target.")
		end
		if IsInGroup() then
			if UnitAffectingCombat("party1") then
				box.texture:SetColorTexture(1, 1, 0, 1)

				if UnitExists("party1target") and UnitIsVisible("party1target") and not UnitIsDead("party1target") then
					local currentHP = UnitHealth("party1target")
					local maxHP = UnitHealthMax("party1target")

					local hpPercent = (currentHP / maxHP) * 100

					local feign = AuraUtil.FindAuraByName("Feign Death", "player", "HELPFUL")

					if hpPercent < 95 and not feign then
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
							print("You are currently channeling " .. channelspell .. ".")
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
				else
				end
			else
				box.texture:SetColorTexture(0, 0, 0, 1)
			end
		end
	end
end)

-- if UnitExists("party1target") and UnitIsVisible("party1target") then
-- 	if not UnitIsUnit("target", "party1target") then
-- 		print("You are NOT targeting the same target as party1.")
-- 		box.texture:SetColorTexture(1, 1, 1, 1)
-- 	else
-- 		if UnitExists("target") and not UnitIsDead("target") then
-- 			local currentHP = UnitHealth("target")
-- 			local maxHP = UnitHealthMax("target")

-- 			local hpPercent = (currentHP / maxHP) * 100

-- 			if hpPercent < 95 then
-- 				local serpentStingName = GetSpellInfo(1978)
-- 				local huntersMarkName = GetSpellInfo(1130)
-- 				local name, _, _, _, _, _, sourceUnit = AuraUtil.FindAuraByName(serpentStingName, "target", "HARMFUL")
-- 				local name2, _, _, _, _, _, sourceUnit2 = AuraUtil.FindAuraByName(huntersMarkName, "target", "HARMFUL")

-- 				local usable, noMana = IsUsableSpell(serpentStingName)
-- 				local usable2, noMana2 = IsUsableSpell(huntersMarkName)
-- 				local channelspell = UnitChannelInfo("player")

-- 				if channelspell then
-- 					print("You are currently channeling " .. channelspell .. ".")
-- 				else
-- 					if UnitExists("pet") and UnitExists("pettarget") and not UnitIsUnit("target", "pettarget") then
-- 						print("Your pet is attacking a different target.")
-- 						box.texture:SetColorTexture(0, 1, 1, 1)
-- 					elseif not name and usable then
-- 						print("You can cast " .. serpentStingName .. " on your target.")
-- 						box.texture:SetColorTexture(0, 1, 0, 1)
-- 					elseif not name2 and usable2 then
-- 						print("You can cast " .. huntersMarkName .. " on your target.")
-- 						box.texture:SetColorTexture(0, 0, 1, 1)
-- 					elseif not IsAutoRepeatSpell("Shoot") then
-- 						box.texture:SetColorTexture(1, 0, 0, 1)
-- 					else
-- 						box.texture:SetColorTexture(1, 1, 0, 1)
-- 					end
-- 				end
-- 			end
-- 		end
-- 	end
-- else
-- 	print("Party member's target is not visible or does not exist.")
-- end

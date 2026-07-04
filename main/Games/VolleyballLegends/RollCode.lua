--Spins
do
	local header = Window:CollapsingHeader({
		Title = "🔁 Spins (Inf. Spins & Rollback)",
	})

	local TeleportService = game:GetService("TeleportService")

	local PlaceId = game.PlaceId
	local JobId = game.JobId

	local function rollback()
		local args = {
			"Q",
			true,
			"Q\255",
		}
		game:GetService("ReplicatedStorage")
			:WaitForChild("Packages")
			:WaitForChild("_Index")
			:WaitForChild("sleitnick_knit@1.7.0")
			:WaitForChild("knit")
			:WaitForChild("Services")
			:WaitForChild("SettingsService")
			:WaitForChild("RF")
			:WaitForChild("UpdateKeybind")
			:InvokeServer(unpack(args))
	end

	local function unRollback()
		local args = {
			nil,
			true,
			"Q\255",
		}
		game:GetService("ReplicatedStorage")
			:WaitForChild("Packages")
			:WaitForChild("_Index")
			:WaitForChild("sleitnick_knit@1.7.0")
			:WaitForChild("knit")
			:WaitForChild("Services")
			:WaitForChild("SettingsService")
			:WaitForChild("RF")
			:WaitForChild("UpdateKeybind")
			:InvokeServer(unpack(args))
	end

	local function rejoin()
		if #Players:GetPlayers() <= 1 then
			Players.LocalPlayer:Kick("\nRejoining...")
			wait()
			TeleportService:Teleport(PlaceId, Players.LocalPlayer)
		else
			--[[
			while true do
				TeleportService:Teleport(PlaceId, Players.LocalPlayer)
				task.wait(5)
			end
			]]
			TeleportService:TeleportToPlaceInstance(PlaceId, JobId, Players.LocalPlayer)
		end
	end

	local function rollbackAndRejoin()
		rollback()
		task.wait(0.5 + LocalPlayer:GetNetworkPing())
		rejoin()
	end

	local spinRemote = game:GetService("ReplicatedStorage")
		:WaitForChild("Packages")
		:WaitForChild("_Index")
		:WaitForChild("sleitnick_knit@1.7.0")
		:WaitForChild("knit")
		:WaitForChild("Services")
		:WaitForChild("StyleService")
		:WaitForChild("RF")
		:WaitForChild("Roll")
	local slotRemote = game:GetService("ReplicatedStorage")
		:WaitForChild("Packages")
		:WaitForChild("_Index")
		:WaitForChild("sleitnick_knit@1.7.0")
		:WaitForChild("knit")
		:WaitForChild("Services")
		:WaitForChild("StyleService")
		:WaitForChild("RF")
		:WaitForChild("SelectSlot")
	local flagRemote = game:GetService("ReplicatedStorage")
		:WaitForChild("Packages")
		:WaitForChild("_Index")
		:WaitForChild("sleitnick_knit@1.7.0")
		:WaitForChild("knit")
		:WaitForChild("Services")
		:WaitForChild("GameService")
		:WaitForChild("RF")
		:WaitForChild("SetFlag")

	local spinRemoteAbility = game:GetService("ReplicatedStorage")
		:WaitForChild("Packages")
		:WaitForChild("_Index")
		:WaitForChild("sleitnick_knit@1.7.0")
		:WaitForChild("knit")
		:WaitForChild("Services")
		:WaitForChild("AbilityService")
		:WaitForChild("RF")
		:WaitForChild("Roll")
	local slotRemoteAbility = game:GetService("ReplicatedStorage")
		:WaitForChild("Packages")
		:WaitForChild("_Index")
		:WaitForChild("sleitnick_knit@1.7.0")
		:WaitForChild("knit")
		:WaitForChild("Services")
		:WaitForChild("AbilityService")
		:WaitForChild("RF")
		:WaitForChild("SelectSlot")

	local manualSpinType = "Regular"
	local manualSlot = 1

	local function spinStyle()
		flagRemote:InvokeServer("Style1")

		if manualSpinType == "Lucky" then
			if StyleController.LuckySpins:get() <= 0 then
				return false, "Not enough lucky spins."
			end
		end

		local success = slotRemote:InvokeServer(manualSlot)
		if not success then
			return false, "Slot failed to select."
			-->> slot unexistent
		end

		local success, result = spinRemote:InvokeServer(manualSpinType == "Lucky")
		if not success or not result then
			return false, "Not enough spins."
		end

		-->> Success!!
		return true, "Success!! Obtained style: " .. styleFromId(result).DisplayName or result
	end

	local function spinAbility()
		flagRemote:InvokeServer("Ability1")

		if manualSpinType == "Lucky" then
			if AbilityController.LuckySpins:get() <= 0 then
				return false, "Not enough lucky spins."
			end
		end

		local success = slotRemoteAbility:InvokeServer(manualSlot)
		if not success then
			return false, "Slot failed to select."
			-->> slot unexistent
		end

		local success, result = spinRemoteAbility:InvokeServer(manualSpinType == "Lucky")
		if not success or not result then
			return false, "Not enough spins."
		end

		-->> Success!!
		return true, "Success!! Obtained style: " .. abilityFromId(result).DisplayName or result
	end

	local manualHeader = header:TreeNode({
		Title = "Manual",
	})

	manualHeader:Label({
		Text = "Rollback: Your data won't be saved, and when you rejoin you will get your stuff back",
	})

	manualHeader:Button({
		Text = "Rollback",
		Callback = rollback,
	})

	manualHeader:Button({
		Text = "Un-Rollback",
		Callback = unRollback,
	})

	manualHeader:Button({
		Text = "Rejoin",
		Callback = rejoin,
	})

	manualHeader:Button({
		Text = "Rollback & Rejoin",
		Callback = rollbackAndRejoin,
	})

	local asdfdgdfbdf = manualHeader:Combo({
		Label = "Slot",
		Items = { 1, 2, 3, 4, 5, 6 },
		Callback = function(_, item)
			manualSlot = item
		end,
	})
	ConfigHandler:AddElement("ManualSpinSlot", asdfdgdfbdf)

	local fdjnfdhjbndfbdf = manualHeader:Combo({
		Label = "Spin Type",
		Items = { "Lucky", "Regular" },
		Callback = function(_, item)
			manualSpinType = item
		end,
	})
	ConfigHandler:AddElement("AutoSpinType", fdjnfdhjbndfbdf)

	manualHeader:Button({
		Text = "Spin Style",
		Callback = function()
			local success, result = spinStyle()
			if not success then
				return
			end
		end,
	})

	manualHeader:Button({
		Text = "Spin Ability",
		Callback = function()
			local success, result = spinAbility()
			if not success then
				return
			end
		end,
	})

	-->> Auto Spin Style
	--
	do
		local SELECTED_STYLES = {}
		local SPIN_TYPE = "Lucky"
		local MAX_SPINS = 10
		local SELECTED_SLOT = 1
		local AUTO_SPIN = false
		local AUTO_SPIN_JAN = Janitor.new()

		local function disableAutoSpin()
			AUTO_SPIN_JAN:Cleanup()
			return true
		end

		local spinCount = 0

		-->> AUTO SPIN FUN
		local function autoSpinFunc()
			flagRemote:InvokeServer("Style1")

			if not AUTO_SPIN then
				return
			end

			if spinCount > MAX_SPINS then
				rollbackAndRejoin()
				return false, "Max spins reached."
				-->> Failed!!
			end

			if SPIN_TYPE == "Lucky" then
				if StyleController.LuckySpins:get() <= 0 then
					rollbackAndRejoin()
					return false, "Not enough lucky spins, Rejoining.."
				end
			end

			local success = slotRemote:InvokeServer(SELECTED_SLOT)
			if not success then
				return true, "Slot failed to select."
				-->> slot unexistent
			end

			if SELECTED_STYLES[LocalPlayer:GetAttribute("Style")] then
				return true, "Style already selected."
			end

			local success, result = spinRemote:InvokeServer(SPIN_TYPE == "Lucky")
			if not success or not result then
				rollbackAndRejoin()
				return false, "Not enough spins, Rejoining..."
			end

			result = result[#result]

			spinCount += 1
			if not SELECTED_STYLES[result] then
				HaikyuuRaper:Notify(
					"Auto Style",
					"Obtained style: " .. styleFromId(result).DisplayName or result,
					2,
					false
				)
				return autoSpinFunc()
			end

			-->> Success!!
			rejoin()
			return true, "Success!! Obtained style: " .. styleFromId(result).DisplayName or result
		end

		local function enableAutoSpin()
			if SPIN_TYPE == "Lucky" then
				if StyleController.LuckySpins:get() <= 0 then
					return false, "Not enough spins."
				end
			end

			local success = slotRemote:InvokeServer(SELECTED_SLOT)
			if not success then
				return false, "Invalid Slot."
			end

			if SELECTED_STYLES[LocalPlayer:GetAttribute("Style")] then
				return false, "Already have style."
			end

			local ended, result = autoSpinFunc()
			if ended then
				toggleAutoSpin(false)
			end

			return ended, result
			-->> Success!!
		end

		local autoStyleHeader = header:TreeNode({
			Title = "Auto Style (Inf Spins)",
			Collapsed = true,
		})

		local toggleCheckbox
		function toggleAutoSpin(enabled)
			if enabled == AUTO_SPIN then
				return
			end
			AUTO_SPIN = enabled

			local func = enabled and enableAutoSpin or disableAutoSpin
			local result, notif = func()

			toggleCheckbox:SetValue(AUTO_SPIN)
			if notif then
				HaikyuuRaper:Notify("Auto Style", notif, 3, true)
			end
		end

		toggleCheckbox = autoStyleHeader:Checkbox({
			Label = "Enabled",
			Value = AUTO_SPIN,
			Callback = function(_, v)
				toggleAutoSpin(v)
			end,
		})

		local combo = autoStyleHeader:Combo({
			Label = "Slot",
			Items = { 1, 2, 3, 4, 5, 6 },
			Callback = function(_, item)
				SELECTED_SLOT = item
			end,
		})
		ConfigHandler:AddElement("AutoSpinSlot", combo)

		ConfigHandler:AddElement(
			"AutoSpinMaxSpins",
			autoStyleHeader:SliderInt({
				Label = "Max Spins",
				Value = MAX_SPINS,
				Minimum = 1,
				Maximum = 20,
				Callback = function(_, v)
					MAX_SPINS = v
				end,
			})
		)

		local spinTypeCombo = autoStyleHeader:Combo({
			Label = "Spin Type",
			Items = { "Lucky", "Regular" },
			Callback = function(_, item)
				SPIN_TYPE = item
			end,
		})
		ConfigHandler:AddElement("AutoSpinType", spinTypeCombo)

		local styleHeader = autoStyleHeader:TreeNode({
			Title = "Target Styles",
			Collapsed = true,
		})

		local activeStyles = StyleModule:GetActive()

		for _, style in activeStyles do
			local id = style.Id
			local display = style.DisplayName or id

			local rarityColor = colorFromRarity(style.Rarity)

			local coloredDisplay = string.format(
				'<font color="rgb(%d,%d,%d)">%s</font>',
				math.floor(rarityColor.R * 255),
				math.floor(rarityColor.G * 255),
				math.floor(rarityColor.B * 255),
				display
			)

			local checkbox = styleHeader:Checkbox({
				Label = coloredDisplay,
				Value = SELECTED_STYLES[id],
				Callback = function(_, v)
					SELECTED_STYLES[id] = v
				end,
			})
			ConfigHandler:AddElement("AutoSpinStyle" .. id, checkbox)
		end

		ConfigHandler:AddElement("AutoSpinToggle", toggleCheckbox)
	end

	-- Auto Spin Ability
	--[[]
        do
            local SELECTED_STYLES = {}
            local SPIN_TYPE = "Lucky"
            local MAX_SPINS = 10
            local SELECTED_SLOT = 1
            local AUTO_SPIN = false
            local AUTO_SPIN_JAN = Janitor.new()
    
            local function disableAutoSpin()
                AUTO_SPIN_JAN:Cleanup()
                return true
            end
    
            local spinCount = 0
    
            -->> AUTO SPIN FUN
            local function autoSpinFunc()
                flagRemote:InvokeServer("Ability1")
            
                if not AUTO_SPIN then return end
    
                if spinCount > MAX_SPINS then
                    rollbackAndRejoin()
                    return false, "Max spins reached."
                    -->> Failed!!
                end
    
                if SPIN_TYPE == "Lucky" then
                    if AbilityController.LuckySpins:get() <= 0 then
                        rollbackAndRejoin()
                        return false, "Not enough lucky spins, Rejoining.."
                    end
                end
    
                local success = slotRemoteAbility:InvokeServer(SELECTED_SLOT)
                if not success then
                    return true, "Slot failed to select."
                    -->> slot unexistent
                end
    
                if SELECTED_STYLES[LocalPlayer:GetAttribute("Ability")] then
                    return true, "Style already selected."
                end
    
                local success, result = spinRemoteAbility:InvokeServer(SPIN_TYPE == "Lucky")
                if not success or not result then
                    rollbackAndRejoin()
                    return false, "Not enough spins, Rejoining..."
                end
    
                result = result[#result]
    
                spinCount += 1
                if not SELECTED_STYLES[result] then
                    HaikyuuRaper:Notify("Auto Style", "Obtained style: ".. abilityFromId(result).DisplayName or result, 2, false)
                    return autoSpinFunc()
                end
    
                -->> Success!!
                rejoin()
                return true, "Success!! Obtained style: ".. abilityFromId(result).DisplayName or result
            end
    
            local function enableAutoSpin()
                if SPIN_TYPE == "Lucky" then
                    if AbilityController.LuckySpins:get() <= 0 then
                        return false, "Not enough spins."
                    end
                end
    
                local success = slotRemoteAbility:InvokeServer(SELECTED_SLOT)
                if not success then
                    return false, "Invalid Slot."
                end
    
                if SELECTED_STYLES[LocalPlayer:GetAttribute("Ability")] then
                    return false, "Already have style."
                end
    
                local ended, result = autoSpinFunc()
                if ended then
                    toggleAutoSpin(false)
                end
    
                return ended, result
                -->> Success!!
            end
    
            local autoStyleHeader = header:TreeNode({
                Title = "Auto Ability (Inf Spins)",
                Collapsed = true,
            })
    
            local toggleCheckbox;
            function toggleAutoSpin(enabled)
                if enabled == AUTO_SPIN then return end
                AUTO_SPIN = enabled
    
                local func = enabled and enableAutoSpin or disableAutoSpin
                local result, notif = func()
    
                toggleCheckbox:SetValue(AUTO_SPIN)
                if notif then
                    HaikyuuRaper:Notify("Auto Ability", notif, 3, true)
                end
            end
    
            toggleCheckbox = autoStyleHeader:Checkbox({
                Label = "Enabled",
                Value = AUTO_SPIN,
                Callback = function(_, v)
                    toggleAutoSpin(v)
                end,
            })
    
            local combo = autoStyleHeader:Combo({
                Label = "Slot",
                Items = {1,2,3,4,5,6},
                Callback = function(_, item)
                    SELECTED_SLOT = item
                end,
            })
            ConfigHandler:AddElement("AutoSpinAbilitySlot", combo)
    
            ConfigHandler:AddElement("AutoSpinAbilityMaxSpins", autoStyleHeader:SliderInt({
                Label = "Max Spins",
                Value = MAX_SPINS,
                Minimum = 1,
                Maximum = 10,
                Callback = function(_, v)
                    MAX_SPINS = v
                end,
            }))
    
            local spinTypeCombo = autoStyleHeader:Combo({
                Label = "Spin Type",
                Items = {"Lucky", "Regular"},
                Callback = function(_, item)
                    SPIN_TYPE = item
                end,
            })
            ConfigHandler:AddElement("AutoSpinAbilityType", spinTypeCombo)
    
            local styleHeader = autoStyleHeader:TreeNode({
                Title = "Target Abilities",
                Collapsed = true,
            })
    
            local activeStyles = {}
            for _, v in AbilityPath:GetChildren() do
                table.insert(activeStyles, require(v))
            end
            
            for _, style in activeStyles do
                local id = style.Id
                local display = style.DisplayName or id
    
                local rarityColor = colorFromRarity(style.Rarity)
    
                local coloredDisplay = string.format('<font color="rgb(%d,%d,%d)">%s</font>', 
                    math.floor(rarityColor.R * 255), 
                    math.floor(rarityColor.G * 255), 
                    math.floor(rarityColor.B * 255), 
                    display)
    
                local checkbox = styleHeader:Checkbox({
                    Label = coloredDisplay,
                    Value = SELECTED_STYLES[id],
                    Callback = function(_, v)
                        SELECTED_STYLES[id] = v
                    end,
                })
                ConfigHandler:AddElement("AutoSpinAbility" .. id, checkbox)
            end
    
            ConfigHandler:AddElement("AutoSpinAbilityToggle", toggleCheckbox)
        end
        ]]
end

-- Autofarm
-->> Autofarm
do
	local AutoFarmTab = Window:CollapsingHeader({
		Title = "🌱 Auto Farm",
	})

	local AutoFarmConfig = {
		Enabled = false,
		Blatant = true,
		AccountFarmingMode = true,
	}

	local jan = Janitor.new()
	local inroundJan = Janitor.new()

	jan:Add(function()
		inroundJan:Cleanup()
	end)

	local joinRemote = ReplicatedStorage:WaitForChild("Packages")
		:WaitForChild("_Index")
		:WaitForChild("sleitnick_knit@1.7.0")
		:WaitForChild("knit")
		:WaitForChild("Services")
		:WaitForChild("GameService")
		:WaitForChild("RF")
		:WaitForChild("RequestJoin")

	local function getInRound()
		if LocalPlayer.Team then
			return true
		end
		for i = 1, 2 do
			for k = 1, 6 do
				local success = joinRemote:InvokeServer(i, k)
				if success then
					return true
				end
			end
		end
	end

	local spikeHitboxSize = ReplicatedStorage.Assets.Hitboxes.Spike.Part.Size
	local interactRemote = ReplicatedStorage:WaitForChild("Packages")
		:WaitForChild("_Index")
		:WaitForChild("sleitnick_knit@1.7.0")
		:WaitForChild("knit")
		:WaitForChild("Services")
		:WaitForChild("BallService")
		:WaitForChild("RF")
		:WaitForChild("Interact")

	local function toggle(enabled)
		if enabled == AutoFarmConfig.Enabled then
			return
		end
		AutoFarmConfig.Enabled = enabled

		if enabled then
			-->> Enable
			local IS_FROM_SERVE = false
			local ServeClock = os.clock()

			jan:Add(ReplicatedStorage:GetAttributeChangedSignal("ServedByPlayer"):Connect(function()
				local ServedByWho = ReplicatedStorage:GetAttribute("ServedByPlayer")
				if not ServedByWho then
					return
				end

				IS_FROM_SERVE = ServedByWho
				ServeClock = os.clock()

				while ReplicatedStorage:GetAttribute("LastHitter") ~= ServedByWho do
					ReplicatedStorage:GetAttributeChangedSignal("LastHitter"):Wait()
				end

				while ReplicatedStorage:GetAttribute("LastHitter") == ServedByWho do
					ReplicatedStorage:GetAttributeChangedSignal("LastHitter"):Wait()
				end

				IS_FROM_SERVE = false
			end))

			jan:Add(task.defer(function()
				while AutoFarmConfig.Enabled do
					-->> wait for round start
					if ReplicatedStorage:GetAttribute("RoundState") == 1 then
						ReplicatedStorage:GetAttributeChangedSignal("RoundState"):Wait()
					end

					if not getInRound() then
						continue
					end

					-->> choose team
					inroundJan:Add(
						LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function()
							if not LocalPlayer.Team then
								while ReplicatedStorage:GetAttribute("RoundState") ~= 1 do
									getInRound()
									if LocalPlayer.Team then
										return
									end
								end
							end
						end),
						nil,
						"TeamChangeConnection"
					)

					local blatantClock = os.clock()

					-->> autoplay
					inroundJan:Add(task.defer(function()
						while RunService.Heartbeat:Wait() do
							if not LocalPlayer.Team then
								continue
							end

							if LocalPlayer:GetAttribute("IsServing") then
								local args = {
									Vector3.new(0, 0, 0),
									1,
								}
								game:GetService("ReplicatedStorage")
									:WaitForChild("Packages")
									:WaitForChild("_Index")
									:WaitForChild("sleitnick_knit@1.7.0")
									:WaitForChild("knit")
									:WaitForChild("Services")
									:WaitForChild("GameService")
									:WaitForChild("RF")
									:WaitForChild("Serve")
									:InvokeServer(unpack(args))
								continue
							end

							if not BallTrajectory.LastTrajectory then
								continue
							end

							local character = LocalPlayer.Character
							if
								not character
								or not character:FindFirstChild("Humanoid")
								or not character:FindFirstChild("HumanoidRootPart")
							then
								continue
							end

							local humanoid = character:FindFirstChild("Humanoid")
							humanoid.AutoRotate = false

							local rootPart = character:FindFirstChild("HumanoidRootPart")

							local playerPosition = rootPart.Position

							local courtPosition = CourtPart.Position
							local courtSize = CourtPart.Size

							-- Determine which side of the court the player is on (using Z axis)
							local isPlayerOnPositiveZSide = tonumber(LocalPlayer.Team:GetAttribute("Index")) == 2

							-- Calculate center position of player's side of court
							local centerX = courtPosition.X
							local centerZ = courtPosition.Z
								+ (isPlayerOnPositiveZSide and courtSize.Z / 4 or -courtSize.Z / 4)
							local centerY = 6

							local centerPosition = Vector3.new(centerX, centerY, centerZ)
							humanoid.WalkToPoint = centerPosition * Vector3.new(1, 0, 1)
								+ rootPart.Position * Vector3.new(0, 1, 0)

							local ball = BallTrajectory.LastBall
							if not ball then
								continue
							end

							local playerPing = LocalPlayer:GetNetworkPing()
							local acceleration = ball.Acceleration
							local velocity = ball.Velocity
							local position = ball.Position

							local ballPosition = position
							local landingPosition = BallTrajectory.LastTrajectory
							local timeToLand = BallTrajectory.LastTime

							if ReplicatedStorage:GetAttribute("Gamemode") ~= "Training" then
								if
									ReplicatedStorage:GetAttribute("ServedByPlayer") ~= LocalPlayer.Name
									and ReplicatedStorage:GetAttribute("ServedByPlayer") ~= nil
									--[[
									and (
										not ReplicatedStorage:GetAttribute("LastHitType")
										or not ReplicatedStorage:GetAttribute("TeamHitStreak")
									)
									]]
								then
									continue
								end

								-- Check if landing position is on the same side as the player
								local isLandingOnPlayersSide = (
									isPlayerOnPositiveZSide and landingPosition.Z > courtPosition.Z
								)
									or (not isPlayerOnPositiveZSide and landingPosition.Z < courtPosition.Z)

								if not isLandingOnPlayersSide then
									continue
								end
							end

							local function bump()
								local ballToPlayerDist = (ballPosition - playerPosition).Magnitude
								local landingToPlayerDist = (landingPosition - playerPosition).Magnitude
								local setRange = 7 * (HITBOX_MULTIPLIER_ENABLED and HITBOX_MULTIPLIERS["Bump"] or 1)
								if
									(ballToPlayerDist <= setRange)
									or (
										timeToLand < 0.25 + 0.5 * LocalPlayer:GetNetworkPing()
										and landingToPlayerDist <= setRange
									)
								then
									-- Ball or landing position is close enough to set
									setthreadidentity(2)
									gameController:DoMove("Bump")
									setthreadidentity(8)
								end
							end

							-- Check if current ball position is on player's side
							local isBallOnPlayersSide = (isPlayerOnPositiveZSide and ballPosition.Z > courtPosition.Z)
								or (not isPlayerOnPositiveZSide and ballPosition.Z < courtPosition.Z)

							if AutoFarmConfig.Blatant then
								if isBallOnPlayersSide then
									if ReplicatedStorage:GetAttribute("LastHitter") == LocalPlayer.Name then
										rootPart.CFrame = CFrame.new(centerPosition)
											* CFrame.lookAt(
												centerPosition * Vector3.new(1, 0, 1),
												(
													CourtPart.CFrame.Position
													+ Vector3.new(
														0,
														0,
														isPlayerOnPositiveZSide and -CourtPart.Size.Z / 2
															or CourtPart.Size.Z / 2
													)
												) * Vector3.new(1, 0, 1)
											).Rotation
										continue
									end

									rootPart.CFrame = CFrame.new(ballPosition)
										* CFrame.lookAt(
											ballPosition * Vector3.new(1, 0, 1),
											(
												CourtPart.CFrame.Position
												+ Vector3.new(
													0,
													0,
													isPlayerOnPositiveZSide and -CourtPart.Size.Z / 2
														or CourtPart.Size.Z / 2
												)
											) * Vector3.new(1, 0, 1)
										).Rotation

									-- If we are the one who served, we can just wait for the ball to come
									if IS_FROM_SERVE == LocalPlayer.Name then
										if ball.Position.Y < 15 then
											continue
										end
									end

									if
										(IS_FROM_SERVE == LocalPlayer.Name or not IS_FROM_SERVE)
										and ball.Position.Y > 7
									then
										if os.clock() - blatantClock > 0.1 then
											blatantClock = os.clock()
											task.spawn(function()
												setthreadidentity(2)
												gameController:DoMove("Spike")
												setthreadidentity(8)
											end)
										end
									else
										task.spawn(function()
											setthreadidentity(2)
											gameController:DoMove("Bump")
											setthreadidentity(8)
										end)
									end
								else
									-- Teleport player to where the ball would be right after it passed the net
									do
										--warn("STEP 1 TYPE")

										-- Assume the net is at Z = 0 in court local space, adjust as needed
										local ballVel = velocity
										local ballPos = position
										local ballZ = ballPos.Z
										local ballVZ = ballVel.Z

										-- Find the Z position of the net in world space
										local netWorldZ = CourtPart.CFrame.Position.Z

										-- Only proceed if the ball is moving toward the player's side
										if
											(isPlayerOnPositiveZSide and ballVZ > 0)
											or (not isPlayerOnPositiveZSide and ballVZ < 0)
										then
											--warn("STEP 2 TYPE")
											-- Calculate time to reach the net plane (Z = netWorldZ)
											local t = (netWorldZ - ballZ) / ballVZ
											if t > 0 and t < timeToLand then
												--warn("STEP 3 TYPE")
												-- Predict ball position at that time (ignoring gravity for simplicity)
												local predictedPos = Vector3.new(
													position.X + velocity.X * t + 0.5 * acceleration.X * t * t,
													position.Y + velocity.Y * t + 0.5 * acceleration.Y * t * t,
													position.Z + velocity.Z * t + 0.5 * acceleration.Z * t * t
												)
												-- Place player slightly behind the net on their side
												local offset = isPlayerOnPositiveZSide and 4 or -4
												local playerTargetPos =
													Vector3.new(predictedPos.X, predictedPos.Y, netWorldZ + offset)
												rootPart.CFrame = CFrame.new(playerTargetPos)
													* CFrame.lookAt(
														playerTargetPos * Vector3.new(1, 0, 1),
														(
															CourtPart.CFrame.Position
															+ Vector3.new(
																0,
																0,
																isPlayerOnPositiveZSide and -CourtPart.Size.Z / 2
																	or CourtPart.Size.Z / 2
															)
														) * Vector3.new(1, 0, 1)
													).Rotation
											else
												-- Fallback: just go to landingPosition
												rootPart.CFrame = CFrame.new(landingPosition)
													* CFrame.lookAt(
														landingPosition * Vector3.new(1, 0, 1),
														(
															CourtPart.CFrame.Position
															+ Vector3.new(
																0,
																0,
																isPlayerOnPositiveZSide and -CourtPart.Size.Z / 2
																	or CourtPart.Size.Z / 2
															)
														) * Vector3.new(1, 0, 1)
													).Rotation
											end
										else
											rootPart.CFrame = CFrame.new(centerPosition + Vector3.new(0, 2, 0))
												* CFrame.lookAt(
													centerPosition * Vector3.new(1, 0, 1),
													(
														CourtPart.CFrame.Position
														+ Vector3.new(
															0,
															0,
															isPlayerOnPositiveZSide and -CourtPart.Size.Z / 2
																or CourtPart.Size.Z / 2
														)
													) * Vector3.new(1, 0, 1)
												).Rotation
										end
									end
								end
							else
								rootPart.CFrame = CFrame.new(rootPart.Position)
									* CFrame.lookAt(
										rootPart.Position * Vector3.new(1, 0, 1),
										(
											CourtPart.CFrame.Position
											+ Vector3.new(
												0,
												0,
												isPlayerOnPositiveZSide and -CourtPart.Size.Z / 2
													or CourtPart.Size.Z / 2
											)
										) * Vector3.new(1, 0, 1)
									).Rotation

								if ReplicatedStorage:GetAttribute("LastHitter") == LocalPlayer.Name then
									continue
								end

								humanoid.WalkToPoint = BallTrajectory.LastTrajectory * Vector3.new(1, 0, 1)
									+ rootPart.Position * Vector3.new(0, 1, 0)
								bump()
							end
						end
					end))

					-->> wait for round end

					while ReplicatedStorage:GetAttribute("RoundState") ~= 1 do
						ReplicatedStorage:GetAttributeChangedSignal("RoundState"):Wait()
					end

					inroundJan:Cleanup()
				end
			end))
		else
			-->> Disable
			jan:Cleanup()
		end
	end

	local old
	old = hookmetamethod(
		game,
		"__namecall",
		newcclosure(function(self, ...)
			local args = { ... }
			if not checkcaller() then
				if
					AutoFarmConfig.Enabled
					and AutoFarmConfig.Blatant
					and getnamecallmethod() == "InvokeServer"
					and typeof(self) == "Instance"
					and self.ClassName == "RemoteFunction"
					and self.Name == "Interact"
				then
					local t = args[1]
					if typeof(t) == "table" then
						local action = rawget(t, "Action")
						if action == "Spike" then
							rawset(t, "TiltVector", t.LookVector)
						end
					end
				end
			end
			return old(self, table.unpack(args))
		end)
	)

	local toggleCheckbox = AutoFarmTab:Checkbox({
		Label = "Enabled",
		Value = AutoFarmConfig.Enabled,
		Callback = function(_, v)
			toggle(v)
		end,
	})

	ConfigHandler:AddElement(
		"AutoFarmBlatant",
		AutoFarmTab:Checkbox({
			Label = "Blatant",
			Value = AutoFarmConfig.Blatant,
			Callback = function(_, v)
				AutoFarmConfig.Blatant = v
			end,
		})
	)

	ConfigHandler:AddElement("AutoFarmToggle", toggleCheckbox)
end

-- Skin Stuff
local StylePath = ReplicatedStorage:WaitForChild("Content"):WaitForChild("Style")
local AbilityPath = ReplicatedStorage:WaitForChild("Content"):WaitForChild("Ability")

local StyleModule = require(StylePath)
local StyleController = require(ReplicatedFirst:WaitForChild("Controllers"):WaitForChild("StyleController"))

local AbilityController = require(ReplicatedFirst:WaitForChild("Controllers"):WaitForChild("AbilityController"))
local AbilityModule = require(AbilityPath)

local function styleFromId(id)
	return require(StylePath:FindFirstChild(id))
end

local function abilityFromId(id)
	return require(AbilityPath:FindFirstChild(id))
end

local rarityModule = require(ReplicatedStorage.Content.Rarity)
local function colorFromRarity(rarity)
	return rarityModule.Data[rarity].Color
end

do
	local CosmeticsTab = Window:CollapsingHeader({
		Title = "✨ Cosmetics",
		Collapsed = true,
	})

	-- Custom Nametag Section
	do
		local ENABLED = false
		local CUSTOM_NAME = "OROSPU"
		local CUSTOM_COLOR = Color3.fromRGB(255, 0, 200) -- #1a00b3 (Sanu color)
		local janitor = Janitor.new()

		local function updateNametag()
			local character = LocalPlayer.Character
			if not character then
				return
			end

			local nametag = character:FindFirstChild("Nametag")
			if not nametag then
				return
			end

			local playerName = nametag:FindFirstChild("PlayerName")
			if playerName and playerName:IsA("TextLabel") then
				playerName.RichText = true
				if not ENABLED then
					playerName.Text = LocalPlayer.Name
					playerName.TextColor3 = Color3.fromRGB(255, 255, 255)
					return
				end
				playerName.Text = CUSTOM_NAME
				playerName.TextColor3 = CUSTOM_COLOR
			end
		end

		local function charUpdate()
			local nametag = LocalPlayer.Character:FindFirstChild("Nametag")
			if nametag then
				local playerName = nametag:FindFirstChild("PlayerName")
				if playerName then
					updateNametag()

					-- Monitor text changes to keep our custom name
					janitor:Add(playerName:GetPropertyChangedSignal("Text"):Connect(function()
						if playerName.Text ~= CUSTOM_NAME then
							playerName.Text = CUSTOM_NAME
						end
					end))

					-- Monitor color changes to keep our custom color
					janitor:Add(playerName:GetPropertyChangedSignal("TextColor3"):Connect(function()
						if playerName.TextColor3 ~= CUSTOM_COLOR then
							playerName.TextColor3 = CUSTOM_COLOR
						end
					end))
				end

				-- Monitor if nametag gets recreated
				janitor:Add(nametag.ChildAdded:Connect(function(child)
					if child.Name == "PlayerName" then
						task.wait()
						updateNametag()

						-- Monitor text changes to keep our custom name
						janitor:Add(child:GetPropertyChangedSignal("Text"):Connect(function()
							if child.Text ~= CUSTOM_NAME then
								child.Text = CUSTOM_NAME
							end
						end))

						-- Monitor color changes to keep our custom color
						janitor:Add(child:GetPropertyChangedSignal("TextColor3"):Connect(function()
							if child.TextColor3 ~= CUSTOM_COLOR then
								child.TextColor3 = CUSTOM_COLOR
							end
						end))
					end
				end))
			end

			-- Watch for nametag being added later
			janitor:Add(LocalPlayer.Character.ChildAdded:Connect(function(child)
				if child.Name == "Nametag" then
					task.wait()
					updateNametag()

					-- Watch for PlayerName being added to nametag
					janitor:Add(child.ChildAdded:Connect(function(nameChild)
						if nameChild.Name == "PlayerName" then
							task.wait()
							updateNametag()

							-- Monitor text changes to keep our custom name
							janitor:Add(nameChild:GetPropertyChangedSignal("Text"):Connect(function()
								if nameChild.Text ~= CUSTOM_NAME then
									nameChild.Text = CUSTOM_NAME
								end
							end))

							-- Monitor color changes to keep our custom color
							janitor:Add(nameChild:GetPropertyChangedSignal("TextColor3"):Connect(function()
								if nameChild.TextColor3 ~= CUSTOM_COLOR then
									nameChild.TextColor3 = CUSTOM_COLOR
								end
							end))
						end
					end))
				end
			end))
		end

		local function setEnabled(value)
			ENABLED = value

			janitor:Cleanup()
			updateNametag()

			if ENABLED then
				-- Monitor character changes
				janitor:Add(LocalPlayer.CharacterAdded:Connect(function(char)
					charUpdate()
				end))

				-- Check for existing character
				if LocalPlayer.Character then
					charUpdate()
				end
			end
		end

		hooks:Add(function()
			setEnabled(false)
			janitor:Cleanup()
		end)

		local CustomNametagNode = CosmeticsTab:TreeNode({
			Title = "Custom Nametag",
			Collapsed = false,
		})

		ConfigHandler:AddElement(
			"CustomNameEnabled",
			CustomNametagNode:Checkbox({
				Label = "Enable Custom Name",
				Value = ENABLED,
				Callback = function(_, value)
					setEnabled(value)
				end,
			})
		)

		ConfigHandler:AddElement(
			"CustomNameValue",
			CustomNametagNode:InputText({
				Label = "Custom Name",
				Value = CUSTOM_NAME,
				Callback = function(_, value)
					CUSTOM_NAME = value
					if ENABLED then
						updateNametag()
					end
				end,
			})
		)

		ConfigHandler:AddElement(
			"CustomNameColor",
			CustomNametagNode:SliderColor3({
				Value = CUSTOM_COLOR,
				Label = "Name Color",
				Callback = function(_, color)
					CUSTOM_COLOR = color
					if ENABLED then
						updateNametag()
					end
				end,
			})
		)
	end

	local function itemSelector(name, items, callback, node)
		local displayNamed = {}
		local itemList = {}
		for _, item in items do
			local thing = ReplicatedStorage.Content.Item:FindFirstChild(item)
			if thing then
				local itemInfo = require(thing)
				local display = itemInfo.DisplayName
				local rarityColor = colorFromRarity(itemInfo.Rarity)
				local coloredDisplay = string.format(
					'<font color="rgb(%d,%d,%d)">%s</font>',
					math.floor(rarityColor.R * 255),
					math.floor(rarityColor.G * 255),
					math.floor(rarityColor.B * 255),
					display
				)
				table.insert(itemList, coloredDisplay)
				displayNamed[coloredDisplay] = item
			end
		end
		local combo = node:Combo({
			Label = name,
			Items = itemList,
			Callback = function(_, item)
				callback(displayNamed[item])
			end,
		})
		ConfigHandler:AddElement(name .. "Combo", combo)
		return combo
	end
	-- Custom Ball Section

	if hookfunction and newcclosure and debug.getupvalue then
		local BALL_ENABLED = false
		local SELECTED_BALL = nil
		local BALL_ENABLED_FOR_OTHERS = false

		local ballNames = {}
		for _, ball in ReplicatedStorage.Assets.Ball:GetChildren() do
			table.insert(ballNames, ball.Name)
		end

		local CustomBallNode = CosmeticsTab:TreeNode({
			Title = "Custom Ball",
			Collapsed = false,
		})

		ConfigHandler:AddElement(
			"CustomBallEnabled",
			CustomBallNode:Checkbox({
				Label = "Enable Custom Ball",
				Value = BALL_ENABLED,
				Callback = function(_, value)
					BALL_ENABLED = value
				end,
			})
		)

		ConfigHandler:AddElement(
			"CustomBallForOthers",
			CustomBallNode:Checkbox({
				Label = "Apply To Others",
				Value = BALL_ENABLED_FOR_OTHERS,
				Callback = function(_, value)
					BALL_ENABLED_FOR_OTHERS = value
				end,
			})
		)

		itemSelector("Ball Skin", ballNames, function(ball)
			SELECTED_BALL = ball
		end, CustomBallNode)

		local networkModule = require(ReplicatedFirst.Controllers.BallController.Network)
		local callbackTable = debug.getupvalue(networkModule.BallStream.SetCallback, 1)

		if callbackTable[1] then
			local old
			old = hookfunction(
				callbackTable[1],
				newcclosure(function(...)
					local args = { ... }
					local ballData = args[1]

					if
						BALL_ENABLED
						and SELECTED_BALL
						and ballData.Skin
						and (
							ReplicatedStorage:GetAttribute("ServedByPlayer") == LocalPlayer.Name
							or BALL_ENABLED_FOR_OTHERS
						)
					then
						ballData.Skin = SELECTED_BALL
					end

					return old(...)
				end)
			)
		end

		hooks:Add(function()
			BALL_ENABLED = false
			BALL_ENABLED_FOR_OTHERS = false
			SELECTED_BALL = nil
		end)
	end

	-- Custom Score Section
	if getconnections and hookfunction and newcclosure then
		local ENABLED = false
		local ENABLED_FOR_OTHERS = false
		local SELECTED_EFFECT = nil

		local effectNames = {}
		for _, effect in ReplicatedStorage.Assets.ScoreEffect:GetChildren() do
			table.insert(effectNames, effect.Name)
		end

		local CustomScoreNode = CosmeticsTab:TreeNode({
			Title = "Custom Score Effect",
			Collapsed = false,
		})

		ConfigHandler:AddElement(
			"CustomScoreEnabled",
			CustomScoreNode:Checkbox({
				Label = "Enable",
				Value = ENABLED,
				Callback = function(_, value)
					ENABLED = value
				end,
			})
		)

		ConfigHandler:AddElement(
			"CustomScoreForOthers",
			CustomScoreNode:Checkbox({
				Label = "Apply To Others",
				Value = ENABLED_FOR_OTHERS,
				Callback = function(_, value)
					ENABLED_FOR_OTHERS = value
				end,
			})
		)

		itemSelector("Score Effect", effectNames, function(effect)
			SELECTED_EFFECT = effect
		end, CustomScoreNode)

		task.spawn(function()
			local found = false
			local clc = os.clock()
			while not found and os.clock() - clc < 2 do
				local protos = debug.getprotos(gameController.BindToEffects)

				for i, proto in protos do
					if iscclosure(proto) then
						continue
					end
					local constants = debug.getconstants(proto)
					if table.find(constants, "GroundHit1") then
						local miniFound = false
						while not miniFound and os.clock() - clc < 2 do
							local realProtos = debug.getproto(gameController.BindToEffects, i, true)
							if #realProtos > 0 then
								miniFound = true
								for _, realProto in realProtos do
									local old
									old = hookfunction(
										realProto,
										newcclosure(function(...)
											--print("IDFC IDFC")
											local args = { ... }
											--warn(HaikyuuRaper:Serialize(args))

											if ENABLED and not args[3] then
												if args[6] == LocalPlayer.Character or ENABLED_FOR_OTHERS then
													if SELECTED_EFFECT then
														args[5] = SELECTED_EFFECT
													end
												end
											end

											return old(unpack(args))
										end)
									)
								end
							else
								task.wait()
							end
						end
						found = true
						break
					end
				end

				if not found then
					task.wait()
				end
			end
		end)

		hooks:Add(function()
			ENABLED = false
			ENABLED_FOR_OTHERS = false
			SELECTED_EFFECT = nil
		end)
	end

	-- Custom Animations Section
	--[[
	if hookfunction and newcclosure then
		local CustomAnimations = {
			Enabled = false,
			Animations = {
				-- FORMAT: [AnimationName] = {Enabled: boolean, Selected: string | nil, Options: {}}
			},
			ChangeCount = 0,
		}

		local function somethingChanged()
			CustomAnimations.ChangeCount += 1
		end
		-- Initialize the animations & etc.
		local AllStyles = StylePath:GetChildren()
		for _, styleModule in AllStyles do
			local style = require(styleModule)
			local animations = style.Metadata and style.Metadata.Animations
			if not animations then
				continue
			end
			for Name, AnimationData in animations do
				if not CustomAnimations.Animations[Name] then
					CustomAnimations.Animations[Name] = {
						Enabled = true,
						Selected = nil,
						Options = {},
					}
				end

				local rarityColor = colorFromRarity(style.Rarity)
				local coloredDisplay = string.format(
					'<font color="rgb(%d,%d,%d)">%s</font>',
					math.floor(rarityColor.R * 255),
					math.floor(rarityColor.G * 255),
					math.floor(rarityColor.B * 255),
					style.DisplayName or styleModule.Name
				)

				CustomAnimations.Animations[Name].Options[coloredDisplay] = AnimationData
			end
		end

		-- Load the Interface
		local CustomAnimNode = CosmeticsTab:TreeNode({
			Title = "Custom Animations",
			Collapsed = false,
		})

		ConfigHandler:AddElement(
			"CustomAnimsEnabled",
			CustomAnimNode:Checkbox({
				Label = "Enabled",
				Value = CustomAnimations.Enabled,
				Callback = function(_, v)
					CustomAnimations.Enabled = v
					somethingChanged()
				end,
			})
		)

		for Name, AnimationData in CustomAnimations.Animations do
			local Row = CustomAnimNode:Row()

			ConfigHandler:AddElement(
				"CustomAnims" .. Name .. "Enabled",
				Row:Checkbox({
					Label = "",
					Value = AnimationData.Enabled,
					Callback = function(_, v)
						AnimationData.Enabled = v
						somethingChanged()
					end,
				})
			)

			local OptionNames = {}
			for i, v in AnimationData.Options do
				table.insert(OptionNames, i)
			end

			local Combo = Row:Combo({
				Label = Name,
				Items = OptionNames,
				Callback = function(_, item)
					AnimationData.Selected = AnimationData.Options[item]
					somethingChanged()
				end,
			})
			ConfigHandler:AddElement("CustomAnims" .. Name .. "Combo", Combo)
		end

		-- Actual Logic
		task.spawn(function()
			local AnimationController =
				require(ReplicatedFirst:WaitForChild("Controllers"):WaitForChild("AnimationController"))

			while not AnimationController.StyleAnimations do
				task.wait()
			end

			local old = nil
			old = hookfunction(
				AnimationController.StyleAnimations.get,
				newcclosure(function(...)
					local args = { ... }
					-- Modify the arguments as needed
					if CustomAnimations.Enabled and rawequal(args[1], AnimationController.StyleAnimations) then
						normalResult = (old(...)) or {}
						for Name, AnimationData in CustomAnimations.Animations do
							if AnimationData.Enabled and AnimationData.Selected then
								normalResult[Name] = AnimationData.Selected
							end
						end
						normalResult.Id = tostring(CustomAnimations.ChangeCount)
						warn(HaikyuuRaper:Serialize(normalResult, {
							Prettify = true,
						}))
						return normalResult
					end
					return old(...)
				end)
			)
		end)

		hooks:Add(function()
			CustomAnimations.Enabled = false
		end)
	end
	]]

	local EffectFolders = {
		Effects = ReplicatedStorage.Assets.Effects,
		ScoreEffects = ReplicatedStorage.Assets.ScoreEffect,
	}

	-- Tsh Spike Effect
	if hookfunction and newcclosure then
		local Enabled = false
	end

	-- Effect Re-Color
	--[[
	do
		local Enabled = false
		local ColorizeMode = false
		local Hue = 0

		local Objects = {}
		local DefaultColors = {}

		-- Utility: shift/set hue on Color3
		local function setHueColor3(c: Color3, targetHue: number): Color3
			local function clampColor3(c)
				local r = math.clamp(c.R, 0, 1)
				local g = math.clamp(c.G, 0, 1)
				local b = math.clamp(c.B, 0, 1)
				return Color3.new(r, g, b)
			end
			c = clampColor3(c)

			local _, s, v = c:ToHSV()
			if ColorizeMode then
				s = 1 -- max saturation
			end
			return Color3.fromHSV(targetHue, s, v)
		end

		-- Utility: shift/set hue on ColorSequence
		local function setHueColorSequence(seq: ColorSequence, targetHue: number): ColorSequence
			local newKeypoints = {}
			for _, keypoint in seq.Keypoints do
				local _, s, v = keypoint.Value:ToHSV()
				if ColorizeMode then
					s = 1
				end
				local newColor = Color3.fromHSV(targetHue, s, v)
				table.insert(newKeypoints, ColorSequenceKeypoint.new(keypoint.Time, newColor))
			end
			return ColorSequence.new(newKeypoints)
		end

		-- Apply hue to supported object types
		local function applyHue(obj, hueDegrees: number)
			local targetHue = (hueDegrees % 360) / 360

			if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
				obj.Color = setHueColorSequence(DefaultColors[obj], targetHue)
			elseif obj:IsA("BasePart") then
				obj.Color = setHueColor3(DefaultColors[obj], targetHue)
			elseif obj:IsA("Decal") or obj:IsA("Texture") then
				obj.Color3 = setHueColor3(DefaultColors[obj], targetHue)
			elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
				obj.ImageColor3 = setHueColor3(DefaultColors[obj], targetHue)
			elseif obj:IsA("Highlight") then
				local old = DefaultColors[obj]
				obj.FillColor = setHueColor3(old.FillColor, targetHue)
				obj.OutlineColor = setHueColor3(old.OutlineColor, targetHue)
			end
		end

		local function restore(obj)
			if not DefaultColors[obj] then
				return
			end

			if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
				obj.Color = DefaultColors[obj]
			elseif obj:IsA("BasePart") then
				obj.Color = DefaultColors[obj]
			elseif obj:IsA("Decal") or obj:IsA("Texture") then
				obj.Color3 = DefaultColors[obj]
			elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
				obj.ImageColor3 = DefaultColors[obj]
			elseif obj:IsA("Highlight") then
				obj.FillColor = DefaultColors[obj].FillColor
				obj.OutlineColor = DefaultColors[obj].OutlineColor
			end
		end

		-- Main update loop
		local function update()
			for _, obj in Objects do
				if Enabled then
					applyHue(obj, Hue)
				else
					restore(obj)
				end
			end
		end

		-- Register supported objects
		local function loadObject(v)
			local save

			if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
				save = v.Color
			elseif v:IsA("BasePart") then
				save = v.Color
			elseif v:IsA("Decal") or v:IsA("Texture") then
				save = v.Color3
			elseif v:IsA("ImageLabel") or v:IsA("ImageButton") then
				save = v.ImageColor3
			elseif v:IsA("Highlight") then
				save = { FillColor = v.FillColor, OutlineColor = v.OutlineColor }
			end

			if save then
				table.insert(Objects, v)
				DefaultColors[v] = save
				if Enabled then
					applyHue(v, Hue)
				end
			end
		end

		-- Initial load
		for _, EffectsFolder in EffectFolders do
			for _, v in EffectsFolder:GetDescendants() do
				loadObject(v)
			end

			hooks:Add(EffectsFolder.DescendantAdded:Connect(loadObject))
		end

		hooks:Add(function()
			Enabled = false
			update()
			Objects = nil
			DefaultColors = nil
		end)

		-- Interface
		local CustomEffectColorNode = CosmeticsTab:TreeNode({
			Title = "Effect Re-Color",
			Collapsed = false,
		})

		ConfigHandler:AddElement(
			"CustomEffectColorEnabled",
			CustomEffectColorNode:Checkbox({
				Label = "Enabled",
				Value = Enabled,
				Callback = function(_, v)
					Enabled = v
					update()
				end,
			})
		)

		ConfigHandler:AddElement(
			"CustomEffectColorColorizeEnabled",
			CustomEffectColorNode:Checkbox({
				Label = "Enabled",
				Value = ColorizeMode,
				Callback = function(_, v)
					ColorizeMode = v
					update()
				end,
			})
		)

		ConfigHandler:AddElement(
			"EffectReColorHueSlider",
			CustomEffectColorNode:SliderInt({
				Label = "Hue",
				Value = Hue,
				Minimum = 0,
				Maximum = 360,
				Callback = function(self, Value)
					Hue = math.round(Value)
					if Enabled then
						update()
					end
				end,
			})
		)
	end
	]]
end

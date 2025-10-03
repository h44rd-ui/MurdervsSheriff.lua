-- WindUI Script com Anti-AFK e Hitbox Expander
-- Créditos 

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local Windui = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Cria a janela principal
local Window = Windui:CreateWindow({
	Title = "KlyroX | Utilities",
	Icon = "activity",
	Author = "by Naosei",
	Folder = "KlyroX",
	Theme = "Dark",
	Size = UDim2.fromOffset(500, 100),
	Resizable = true,
	Transparent = true,
})

local Misc = Window:Tab({
	Title = "Main",
	Icon = "cpu",
	Locked = false,
})

-- =========================
-- ANTI-AFK
-- =========================
Misc:Section({ Title = "Anti-AFK" })

local antiAFKConnection
Misc:Toggle({
	Title = "Enable Anti-AFK",
	Desc = "Prevents you from being kicked for inactivity",
	Value = true,
	Callback = function(state)
		if state then
			if not antiAFKConnection then
				local vu = game:GetService("VirtualUser")
				antiAFKConnection = player.Idled:Connect(function()
					vu:ClickButton2(Vector2.new())
				end)
				Windui:Notify({
					Title = "Anti-AFK",
					Content = "Anti-AFK ativado com sucesso!",
					Duration = 3,
					Icon = "check",
				})
			end
		else
			if antiAFKConnection then
				antiAFKConnection:Disconnect()
				antiAFKConnection = nil
				Windui:Notify({
					Title = "Anti-AFK",
					Content = "Anti-AFK desativado.",
					Duration = 3,
					Icon = "square",
				})
			end
		end
	end,
})

-- =========================
-- HITBOX EXPANDER
-- =========================
Misc:Section({ Title = "Hitbox Expander" })

local hitboxSize = 50
getgenv().hitboxEnabled = false

Misc:Slider({
	Title = "Hitbox Size",
	Desc = "Adjust player hitbox size (1–100)",
	Value = { Min = 1, Max = 100, Default = hitboxSize },
	Callback = function(value)
		hitboxSize = tonumber(value)
	end,
})

Misc:Toggle({
	Title = "Enable Hitbox Expander",
	Desc = "Expands other players' hitboxes with a neon box",
	Value = false,
	Callback = function(state)
		getgenv().hitboxEnabled = state
		if state then
			Windui:Notify({
				Title = "Hitbox Expander",
				Content = "Hitbox Expander ativado!",
				Duration = 3,
				Icon = "scan",
			})
		else
			Windui:Notify({
				Title = "Hitbox Expander",
				Content = "Hitbox Expander desativado.",
				Duration = 3,
				Icon = "x",
			})
		end
	end,
})

-- Loop de atualização da hitbox
task.spawn(function()
	while true do
		task.wait(0.2)
		if getgenv().hitboxEnabled then
			for _, plr in pairs(Players:GetPlayers()) do
				if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
					local root = plr.Character.HumanoidRootPart
					local box = root:FindFirstChild("HitboxBox")

					if not box then
						box = Instance.new("BoxHandleAdornment")
						box.Name = "HitboxBox"
						box.Adornee = root
						box.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
						box.Color3 = Color3.fromRGB(255, 0, 0)
						box.Transparency = 0.5
						box.AlwaysOnTop = true
						box.ZIndex = 10
						box.Parent = root
					else
						box.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
					end
				end
			end
		else
			for _, plr in pairs(Players:GetPlayers()) do
				if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
					local box = plr.Character.HumanoidRootPart:FindFirstChild("HitboxBox")
					if box then
						box:Destroy()
					end
				end
			end
		end
	end
end)

-- Garantir que a GUI carregue corretamente
spawn(function()
	task.wait(0.1)
	Window:SelectTab(1)
end)

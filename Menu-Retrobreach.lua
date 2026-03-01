local ArrayField = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/ArrayField/main/Source.lua'))()

-- // Load External Scripts
-- Ensure these scripts use the _G variables defined in your callbacks
pcall(function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/ynxpi/Yormenu-Roblox/refs/heads/main/Code/ScpRetrobreach/Esp'))()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/ynxpi/Yormenu-Roblox/refs/heads/main/Code/ScpRetrobreach/FullBright'))()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/ynxpi/Yormenu-Roblox/refs/heads/main/Code/ScpRetrobreach/Aimbot'))()
end)

local Window = ArrayField:CreateWindow({
   Name = "Retro Breach", -- Fixed missing quote
   LoadingTitle = "Yor Menu",
   LoadingSubtitle = "by Ynx",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "RetroBreachData", 
      FileName = "yormenu"
   },
   KeySystem = false
})

-- // TABS
local CombatTab = Window:CreateTab("Combat", 4483362458)
local VisualTab = Window:CreateTab("Visual", 4483362458)

-- // COMBAT SECTION
local AimToggle = CombatTab:CreateToggle({
   Name = "Aim Assist (Hold Right Click)",
   CurrentValue = false,
   Flag = "AimToggle",
   Callback = function(Value)
      _G.AimAssistEnabled = Value
   end,
})

local AimStrength = CombatTab:CreateSlider({
   Name = "Aim Strength",
   Range = {1, 100},
   Increment = 1,
   CurrentValue = 50,
   Flag = "AimStrength",
   Callback = function(Value)
      _G.AimStrength = Value
   end,
})

local AimFOV = CombatTab:CreateSlider({
   Name = "Aim FOV Radius",
   Range = {50, 600},
   Increment = 5,
   CurrentValue = 150,
   Flag = "AimFOV",
   Callback = function(Value)
      _G.AimFOV = Value
   end,
})

-- // VISUAL SECTION
local ESPToggle = VisualTab:CreateToggle({
   Name = "Team ESP",
   CurrentValue = false,
   Flag = "TeamESP_Flag", 
   Callback = function(Value)
      _G.TeamESP_Enabled = Value
   end,
})

local FBToggle = VisualTab:CreateToggle({
   Name = "Full Bright",
   CurrentValue = false,
   Flag = "FullBright_Flag", 
   Callback = function(Value)
      -- Assuming your FullBright script uses _G.FullBrightEnabled
      _G.FullBrightEnabled = Value
      if _G.ToggleFullBright then -- If the script provided a function
          _G.ToggleFullBright(Value)
      end
   end,
})

ArrayField:Notify({
    Title = "Menu Loaded",
    Content = "Successfully initialized Retro Breach panel.",
    Duration = 5
})

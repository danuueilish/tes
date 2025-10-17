-- Debug Script: Cek isi dari Replion "ServerLuck"

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function printTable(t, indent)
    indent = indent or 0
    local prefix = string.rep("  ", indent)
    for k, v in pairs(t) do
        if type(v) == "table" then
            print(prefix .. tostring(k) .. " = {")
            printTable(v, indent + 1)
            print(prefix .. "}")
        else
            print(prefix .. tostring(k) .. " = " .. tostring(v))
        end
    end
end

local function findServerLuck()
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj.Name:lower():find("serverluck") then
            print("Found possible ServerLuck:", obj:GetFullName())
            local success, data = pcall(function()
                if obj:GetAttribute("ServerMultiplier") then
                    print("ServerMultiplier =", obj:GetAttribute("ServerMultiplier"))
                end
                for _, attr in ipairs(obj:GetAttributes()) do
                    print(attr, "=", obj:GetAttribute(attr))
                end
            end)
            if success then
                print("Attributes read successfully.")
            else
                print("Failed to read attributes:", data)
            end
        end
    end
end

print("=== Checking for ServerLuck Replion ===")
findServerLuck()
print("=== Done ===")

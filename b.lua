-- Versi lanjutan untuk lihat isi detail dari serverluck
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function printTable(obj, indent)
    indent = indent or 0
    local prefix = string.rep("  ", indent)
    for _, v in ipairs(obj:GetChildren()) do
        print(prefix .. v.Name .. " (" .. v.ClassName .. ")")
        pcall(function()
            if v.Value ~= nil then
                print(prefix .. "  Value =", v.Value)
            end
        end)
        printTable(v, indent + 1)
    end
end

for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
    if obj.Name:lower():find("serverluck") then
        print("=== Found serverluck at:", obj:GetFullName(), "===")
        printTable(obj)
        print("=== End ===")
    end
end

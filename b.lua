local player = game:GetService("Players").LocalPlayer
local function printDescendants(obj, indent)
    indent = indent or 0
    local prefix = string.rep("  ", indent)
    for _, v in ipairs(obj:GetChildren()) do
        if v:IsA("TextLabel") or v:IsA("TextButton") then
            local txt = v.Text or ""
            if txt and txt:lower():find("luck") then
                print(prefix .. v:GetFullName() .. " = " .. txt)
            end
        end
        printDescendants(v, indent + 1)
    end
end

print("=== Searching for 'Luck' labels in GUI ===")
for _, gui in ipairs(player.PlayerGui:GetChildren()) do
    printDescendants(gui)
end
print("=== Done ===")

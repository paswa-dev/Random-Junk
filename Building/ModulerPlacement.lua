local build = {
    modules = {},
    dump_area = workspace
}

--[[
BNode is Back Node
FNode is Front Node

.addPart(PVInstance)
PVInstance -> Part or Model (MUST CONTAIN 2 ATTACHMENTS, show above)
.connectTo(a, b)
a -> Existing Module
b -> Non-Existing Module
]]

local function VerifyAttachments(model)
    local Attachments = {}
    for _, element in next, model:GetDescendents() do
        if element:IsA("Attachment") and (element.Name == "BNode" or element.Name == "FNode") then
            Attachments[element.Name] = element
        end
    end
    return (#Attachments > 0) and Attachments or nil
end

local function GetBlacklist(node_list)
    return = {
        back = node_list.BNode:GetAttributes(),
        front = node_list.FNode:GetAttributes()
    }
end

local function BuildComponents(model, BData)
    local modelNodes = VerifyAttachments(model)
    if not modelNodes then return end
    local FrontNode = modelNodes.FNode
    local BackNode = BData.nodes.BNode
    local Clone = BData.model:Clone()
    local CF = FrontNode.WorldCFrame:ToWorldSpace(BackNode.CFrame)
    Clone:SetPivot(CF)
    Clone.Parent = build.dump_area
end

function build.addPart(model: PVIstance)
    local partData = {}
    partData.nodes = VerifyAttachments(model)
    if not partData.nodes then
        partData = nil
        return
    else 
        partData.model = model
        partData.blacklistModules = GetBlacklist(partData.nodes) 
        partData.bounding_size = model:GetExtentsSize()
    end
    build.modules[model.Name] = partData
    return build.modules[model.Name]
end

function build.place(module_name, cframe)
    local data = build.modules[module_name]
    if not data then return false end
    local Clone = data.model:Clone()
    local depthCFrame = cframe * CFrame.new(0, -bounding_size.Y, 0) 
    Clone:SetPivot(depthCFrame)
    Clone.Parent = build.dump_area
    return true
end

function build.connectTo(model, module_name) -- (Existing Module, Non-Existing Module)
    local AData = build.modules[model.Name]
    local BData = build.modules[module_name]
    if AData and BData then
        local A_Blacklist, B_Blacklist = AData.blacklistModules, BData.blacklistModules
        if table.find(A_Blacklist.front, module_name) or table.find(B_Blacklist.back, model.Name) then
            return
        else
            BuildComponents(model, BData)
        end
    end
end

return build
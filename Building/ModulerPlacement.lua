local build = {
    modules = {},
    dump_area = workspace
}

--[[
BNode is Back Node
FNode is Front Node

FNode or BNode must face in direction that next part will face. Not toward the next part!
So if BNode is facing

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

local function CalculateCF(node1, node2)
    return node1.WorldCFrame:ToWorldSpace(CFrame.new(node2.Position))
end

local function CreateConnection(model, BData, isBack: boolean?) -- Not super fancy stuff, just caclulates where to positon it
    local modelNodes = VerifyAttachments(model)
    if not modelNodes then return end
    local Node1 = modelNodes.FNode
    local Node2 = BData.nodes.BNode
    local Clone = BData.model:Clone()
    if isBack then
        Clone:SetPivot(CalculateCF(Node1.WorldCFrame, CFrame.new(Node2.Position)))
    else
        Clone:SetPivot(CalculateCF(Node1.WorldCFrame, CFrame.new(Node2.Position)))
    end
    Clone.Parent = build.dump_area
end


local function CheckBlacklist(A_Blacklist, B_Blacklist, a_name, b_name)
    if table.find(A_Blacklist, b_name) or table.find(B_Blacklist, a_name) then
        return false
    end
    return true
end

function build.addPart(model: PVIstance) -- Literally just adds the part
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
    return build.modules[model.Name] --// Pointer
end

function build.place(module_name, cframe) --// Literally just to place stuff
    local data = build.modules[module_name]
    if not data then return false end
    local Clone = data.model:Clone()
    local depthCFrame = cframe * CFrame.new(0, -bounding_size.Y, 0) 
    Clone:SetPivot(depthCFrame)
    Clone.Parent = build.dump_area
    return true
end

function build.connectTo(model, module_name, opposite) -- Select first model and add module onto it automatically. Wave collapse would be cool wih this
    local AData = build.modules[model.Name]
    local BData = build.modules[module_name]
    if AData and BData then
        local A_Blacklist, B_Blacklist = AData.blacklistModules, BData.blacklistModules
        if CheckBlacklist(
            opposite and A_Blacklist.back or A_Blacklist.front, 
            opposite and B_Blacklist.front or B_Blacklist.back,
            module_name,
            model.Name
        ) then
            if opposite then
                CreateConnection(model, BData, true)
            else
                CreateConnection(model, BData, false)
            end
        end
        
    end
end

return build
local build = {
    parts = {}
}

--[[
BNode is Back Node
FNode is Front Node
]]

local function VerifyAttachments(model)
    local Attachments = {}
    for _, element in next, model:GetDescendents() do
        if element:IsA("Attachment") and element.Name == "BNode" then
            Attachments[element.Name] = element
        end
    end
    return (#Attachments > 0) and Attachments or nil
end

function build.addPart(model: PVIstance)
    local partData = {}
end

function build.connectTo(a, b)

end

return build
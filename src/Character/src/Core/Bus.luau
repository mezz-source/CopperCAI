local Bus = {}
Bus.__index = Bus

function Bus.new()
    local self = setmetatable({}, Bus)
    self.eventHandlers = {}
    self.requestHandlers = {}
    return self
end

function Bus:RegisterEventHandler(eventName: string, handler: (...any) -> ())
    self.eventHandlers[eventName] = handler
end

function Bus:RegisterRequestHandler(requestName: string, handler: (...any) -> any)
    self.requestHandlers[requestName] = handler
end

function Bus:Send(eventName: string, ...)
    local handler = self.eventHandlers[eventName]
    if handler then
        handler(...)
    end
end

function Bus:Receive(requestName: string, ...): any?
    local handler = self.requestHandlers[requestName]
    if handler then
        return handler(...)
    end
    return nil
end


return Bus
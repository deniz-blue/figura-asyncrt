-- AsyncRT by deniz.blue

---@type [Future, function|nil, function|nil][]
local queue = {}

local function addToQueue(fut, res, rej)
    -- log("Added to queue", { fut,res,rej })
    table.insert(queue, {
        fut,
        res,
        rej,
    })
end

events.WORLD_TICK:register(function()
    for i = #queue, 1, -1 do
        local fut, res, rej = table.unpack(queue[i])
        local success, value = pcall(fut.getOrError, fut)

        if not success then
            if rej ~= nil then rej(error) end
            table.remove(queue, i)
        elseif fut:isDone() then
            if res ~= nil then res(value) end
            table.remove(queue, i)
        end
    end
end)

-- Extensions

local FutureMeta = figuraMetatables.Future.__index

-- TODO: export newFuture in NetworkingAPI
local function newFuture()
    local value = nil
    local isComplete = false
    local errorObj
    local isError = false

    ---@type Future
    local fut = {
        throwError = function()
            if errorObj then
                error(errorObj)
            end
        end,
        getValue = function()
            return value
        end,
        isDone = function()
            -- Bad Figura implementation...
            return isComplete or isError
        end,
    }

    function fut:getOrError()
        self:throwError()
        return self:getValue()
    end

    -- TODO: figure out why we cant do setmetatable or .__index here
    for k, v in pairs(FutureMeta) do
        if not fut[k] then
            fut[k] = v
        end
    end

    local function complete(v)
        value = v
        isComplete = true
    end

    local function err(e)
        errorObj = e
        isError = true
    end

    return fut, complete, err
end

function FutureMeta:hasError()
    local success = pcall(self.getOrError, self)
    return not success;
end

function FutureMeta:getError()
    local success, err = pcall(self.getOrError, self)
    if success then return nil end
    return err
end

function FutureMeta:onFinish(cb)
    addToQueue(self, cb, nil)
end

function FutureMeta:onFinishError(cb)
    addToQueue(self, nil, cb)
end

local InputStreamMeta = figuraMetatables.InputStream.__index

function InputStreamMeta:readAllAsync()
    local stream = self
    local data = {}

    local --[[@as Future.String]] fut, complete, err = newFuture();

    local function poll()
        stream:readAsync()
            :onFinish(function(chunk)
                if #chunk > 0 then
                    table.insert(data, chunk)
                    poll()
                else
                    complete(table.concat(data, ""))
                end
            end)
    end

    poll();

    return fut;
end

return {}

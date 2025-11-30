---@meta _
---@diagnostic disable: duplicate-set-field

------------------------------

---@class Future
local Future

---Gets if this Future has an error.
---@return boolean
function Future:hasError() end

---Gets the error of this future, if any.
---@return any
function Future:getError() end

---Register a callback to run when the future resolves
---@param cb fun(value: any)
---@return Future
function Future:onFinish(cb) end

---Register a callback to run if the future gets an error and cannot complete
---@param cb fun(err: any)
---@return Future
function Future:onFinishError(cb) end

------------------------------

---@class Future.String
local Future_String

---Register a callback to run when the future resolves
---@param cb fun(value: string)
---@return Future.String
function Future_String:onFinish(cb) end

---Register a callback to run if the future gets an error and cannot complete
---@param cb fun(err: any)
---@return Future.String
function Future_String:onFinishError(cb) end

------------------------------

---@class Future.HttpResponse
local Future_HttpResponse

---Register a callback to run when the future resolves
---@param cb fun(value: HttpResponse)
---@return Future.HttpResponse
function Future_HttpResponse:onFinish(cb) end

---Register a callback to run if the future gets an error and cannot complete
---@param cb fun(err: any)
---@return Future.HttpResponse
function Future_HttpResponse:onFinishError(cb) end

------------------------------

---@class InputStream
local InputStream

---Returns a Future.String that resolves to the entire contents of the stream
---@return Future.String
function InputStream:readAllAsync() end

------------------------------

---@class NetworkingAPI
local NetworkingAPI

---Creates a new future and functions to complete or error it
---@return Future fut
---@return fun(value: any) complete
---@return fun(error: any) err
function NetworkingAPI.newFuture() end

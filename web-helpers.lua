local math_random = math.random
if love and love.math and love.math.random then
	math_random = love.math.random
end
local json = require('dkjson')

local http = require("socket.http")
local ltn12 = require("ltn12")
local function simple_request( args )
	local url = tostring(args.gateway) .. "/" .. tostring(args.endpoint)
	
	local resp = {}
	local client, code, headers, status = http.request({
		url=url,
		sink=ltn12.sink.table(resp),
		method="GET",
		headers=args.headers,
	})
	return {
		code = code,
		headers = headers,
		status = status,
		resp = resp
	}
end

--[[
local croak_resp = simple_request({
	gateway = self.gateway,
	endpoint = self.endpoint,
	headers = self.headers
})

if croak_resp.resp == nil then
	assert(false, "Error during CROAK request: " .. tostring(croak_resp.status))
else
	-- stuff
end
]]
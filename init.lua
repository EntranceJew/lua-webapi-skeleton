--[[
	I include everything.
]]

local math_random = math.random
if love and love.math and love.math.random then
	math_random = love.math.random
end

function print_r ( t )  
	local print_r_cache={}
	local function sub_print_r(t,indent)
		if (print_r_cache[tostring(t)]) then
			print(indent.."*"..tostring(t))
		else
			print_r_cache[tostring(t)]=true
			if (type(t)=="table") then
				for pos,val in pairs(t) do
					if (type(val)=="table") then
						print(indent.."["..pos.."] => "..tostring(t).." {")
						sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
						print(indent..string.rep(" ",string.len(pos)+6).."}")
					elseif (type(val)=="string") then
						print(indent.."["..tostring(pos)..'] => "'..val..'"')
					else
						print(indent.."["..tostring(pos).."] => "..tostring(val))
					end
				end
			else
				print(indent..tostring(t))
			end
		end
	end
	if (type(t)=="table") then
		print(tostring(t).." {")
		sub_print_r(t,"  ")
		print("}")
	else
		sub_print_r(t,"  ")
	end
	print()
end


local path = ...

local libname = require(path .. ".libname.core")

local json = require(path .. ".vendor.dkjson")
---
-- A simple encoder to use.
-- @name libname._encoder
-- @param data A table to encode.
-- @return A string representation of encoded data.
libname._encoder = json.encode

---
-- A simple decoder to use.
-- @name libname._decoder
-- @param ...[1] A string to decode.
-- @return A table representing the decoded data.
-- @return Presence implies an error occured. Also the error message.
libname._decoder = function(...) 
	local t = {json.decode(...)}
	return t[1], t[3]
end

---
-- A simple internal request handler, meant to separate itself from _request.
-- @name libname._request_internal
-- @param url A url to request.
-- @param args A table of HTTP headers and methods.
-- @return A table representing a response containing the fields 'body', 'code', etc. Nil on error.
-- @return An error indicator. falsey if everything is okay.
-- @return An error message.
libname._request_internal = require(path .. ".vendor.webhelper")
-- if we want to substitute luajit-request, I suggest doing it like this
--local request = require(path .. '.vendor.luajit-request.luajit-request')
--libname._request_internal = request.send

---
-- Uses internal libname methods to form a request and decode a response.
-- @name libname._request_internal
-- @param url A url to request.
-- @param args A table of HTTP headers and methods.
-- @return A table of decoded data.
-- @return The response object.
libname._request = function(url, args)
	local response, reqerr, message = libname._request_internal(url, args)
	
	assert(not reqerr, "Error forming request: " .. tostring(message))
	
	local data, decerr = libname._decoder(response.body)
	
	assert(not decerr, "Error decoding data: " .. tostring(decerr))
	
	return data, response
end

-- set up global state stuff on the library here

-- import objects for the library here
libname.SimpleClass = require(path .. ".libname.core")

return libname
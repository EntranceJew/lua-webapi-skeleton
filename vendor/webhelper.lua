local http = require("socket.http")
local ltn12 = require("ltn12")
return function( url, args )
	local resp = {}
	args = args or {}
	
	-- set some defaults
	args.url = url
	args.sink = ltn12.sink.table(resp)
	if not args.method then
		args.method = 'GET'
	end

	local _, code, headers, status = http.request(args)

	return {
		body = table.concat(resp),
		headers = headers, -- ??? parse ???
		raw_cookies = {},
		set_cookies = {},
		status = code,
		raw_headers = headers,
	}, not _, code
end
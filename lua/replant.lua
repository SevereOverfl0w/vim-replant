if not table.pack then table.pack = function(...) return { n = select("#", ...), ... } end end
if not table.unpack then table.unpack = unpack end
local load = load if _VERSION:find("5.1") then load = function(x, n, _, env) local f, e = loadstring(x, n) if not f then return f, e end if env then setfenv(f, env) end return f end end
local _select, _unpack, _pack, _error = select, table.unpack, table.pack, error
local _libs = {}
local getIdx1, list1, _2e2e_1, put_21_1, type1, _3d_1, n1, concat1, keys1, _2b_1, error1, eq_3f_1, _2a_1, setIdx_21_1, _3c3d_1, _3e3d_1, setmetatable1, normalisedRationalComponents1, map1, pretty1, _2f3d_1, nvim_5f_call_5f_function_2a_1, format1, echo1, type_23_1, bufferEcho1, n_2a_1, next1, bufferEmit1, n_2f_1, n_3c_1, n_2d_1, n_3c3d_1, len_23_1, emit1, rational1, n_2b_1, pushCdr_21_1, _2f_1, _2d_1, nvim_5f_command1, constVal1, display1, unpack1, _3c_1, formatOutput_21_1, nsign1, nabs1, nnegate1, split1, n_5e_1, nrecip1, modf1, denominator1, numerator1, list_2d3e_struct2, _5e_1, number_3f_1, getmetatable1, setLocalOpt1, struct_2d3e_list_2a_1, sub1, second1, sqrt1, tostring1, cdr2, abs1, list_3f_1, cider_2d2d_abbreviateFileProtocol1, _enot1, nsqrt1, gcd1, _3e_1, neq_3f_1, nth1, nvim_5f_call_5f_function1, car2, _25_1, doAthing1, list_2d3e_struct1, doStuff1, nvim_5f_get_5f_current_5f_buf1, _2d3e_ratComponents1, _2a_rationalMt_2a_1, nvim_5f_buf_5f_add_5f_highlight1, struct_2d3e_list1, updateStruct1, car1, cdr1, apply1, table_3f_1, slice1, len1, match1, find1, self1, empty_3f_1, function_3f_1, struct1, merge1
local _ENV = setmetatable({}, {__index=ENV or (getfenv and getfenv()) or _G}) if setfenv then setfenv(0, _ENV) end
_3d_1 = function(v1, v2) return v1 == v2 end
_2f3d_1 = function(v1, v2) return v1 ~= v2 end
_3c_1 = function(v1, v2) return v1 < v2 end
_3c3d_1 = function(v1, v2) return v1 <= v2 end
_3e_1 = function(v1, v2) return v1 > v2 end
_3e3d_1 = function(v1, v2) return v1 >= v2 end
_2b_1 = function(...) local t = ... for i = 2, _select('#', ...) do t = t + _select(i, ...) end return t end
_2d_1 = function(...) local t = ... for i = 2, _select('#', ...) do t = t - _select(i, ...) end return t end
_2a_1 = function(...) local t = ... for i = 2, _select('#', ...) do t = t * _select(i, ...) end return t end
_2f_1 = function(...) local t = ... for i = 2, _select('#', ...) do t = t / _select(i, ...) end return t end
_25_1 = function(...) local t = ... for i = 2, _select('#', ...) do t = t % _select(i, ...) end return t end
_5e_1 = function(...) local t = ... for i = 2, _select('#', ...) do t = t ^ _select(i, ...) end return t end
_2e2e_1 = function(...) local n = _select('#', ...) local t = _select(n, ...) for i = n - 1, 1, -1 do t = _select(i, ...) .. t end return t end
len_23_1 = function(v1) return #v1 end
error1 = error
getmetatable1 = getmetatable
next1 = next
print1 = print
getIdx1 = function(v1, v2) return v1[v2] end
setIdx_21_1 = function(v1, v2, v3) v1[v2] = v3 end
setmetatable1 = setmetatable
tostring1 = tostring
type_23_1 = type
find1 = string.find
format1 = string.format
len1 = string.len
match1 = string.match
sub1 = string.sub
concat1 = table.concat
unpack1 = table.unpack
n1 = (function(x)
	if type_23_1(x) == "table" then
		return x["n"]
	else
		return #x
	end
end)
slice1 = (function(xs, start, finish)
	if not finish then
		finish = xs["n"]
		if not finish then
			finish = #xs
		end
	end
	local len, _ = (finish - start) + 1
	if len < 0 then
		len = 0
	end
	local out, i, j = ({["tag"]="list",["n"]=len}), 1, start
	while j <= finish do
		out[i] = xs[j]
		i, j = i + 1, j + 1
	end
	return out
end)
car1 = (function(xs)
	return xs[1]
end)
cdr1 = (function(xs)
	return slice1(xs, 2)
end)
list1 = (function(...)
	local xs = _pack(...) xs.tag = "list"
	return xs
end)
_enot1 = (function(expr)
	return not expr
end)
constVal1 = (function(val)
	if type_23_1(val) == "table" then
		local tag = val["tag"]
		if tag == "number" then
			return val["value"]
		elseif tag == "string" then
			return val["value"]
		else
			return val
		end
	else
		return val
	end
end)
apply1 = (function(f, ...)
	local _n = _select("#", ...) - 1
	local xss, xs
	if _n > 0 then
		xss = {tag="list", n=_n, _unpack(_pack(...), 1, _n)}
		xs = select(_n + 1, ...)
	else
		xss = {tag="list", n=0}
		xs = ...
	end
	local args = (function()
		local _offset, _result, _temp = 0, {tag="list",n=0}
		_temp = xss
		for _c = 1, _temp.n do _result[0 + _c + _offset] = _temp[_c] end
		_offset = _offset + _temp.n
		_temp = xs
		for _c = 1, _temp.n do _result[0 + _c + _offset] = _temp[_c] end
		_offset = _offset + _temp.n
		_result.n = _offset + 0
		return _result
	end)()
	return f(unpack1(args, 1, n1(args)))
end)
second1 = (function(...)
	local rest = _pack(...) rest.tag = "list"
	return rest[2]
end)
table_3f_1 = (function(x)
	return type_23_1(x) == "table"
end)
list_3f_1 = (function(x)
	return type1(x) == "list"
end)
empty_3f_1 = (function(x)
	local xt = type1(x)
	if xt == "list" then
		return x["n"] == 0
	elseif xt == "string" then
		return #x == 0
	else
		return false
	end
end)
number_3f_1 = (function(x)
	return type_23_1(x) == "number" or type_23_1(x) == "table" and x["tag"] == "number"
end)
boolean_3f_1 = (function(x)
	return type_23_1(x) == "boolean" or type_23_1(x) == "table" and x["tag"] == "boolean"
end)
function_3f_1 = (function(x)
	return type1(x) == "function" or type1(x) == "multimethod"
end)
key_3f_1 = (function(x)
	return type1(x) == "key"
end)
type1 = (function(val)
	local ty = type_23_1(val)
	if ty == "table" then
		return val["tag"] or "table"
	else
		return ty
	end
end)
neq_3f_1 = (function(x, y)
	return _enot1(eq_3f_1(x, y))
end)
map1 = (function(f, x)
	local out = ({tag = "list", n = 0})
	local temp = n1(x)
	local temp1 = 1
	while temp1 <= temp do
		out[temp1] = f(x[temp1])
		temp1 = temp1 + 1
	end
	out["n"] = n1(x)
	return out
end)
keys1 = (function(x)
	local out, n = ({tag = "list", n = 0}), 0
	local temp, _5f_ = next1(x)
	while temp ~= nil do
		n = 1 + n
		out[n] = temp
		temp, _5f_ = next1(x, temp)
	end
	out["n"] = n
	return out
end)
put_21_1 = (function(t, typs, l)
	local len = n1(typs)
	local temp = len - 1
	local temp1 = 1
	while temp1 <= temp do
		local x = typs[temp1]
		local y = t[x]
		if not y then
			y = ({})
			t[x] = y
		end
		t = y
		temp1 = temp1 + 1
	end
	t[typs[len]] = l
	return nil
end)
eq_3f_1 = setmetatable1(({["lookup"]=({}),["tag"]="multimethod"}), ({["__call"]=(function(tempThis, x, y)
	local tempMethod
	local temp = tempThis["lookup"]
	if temp then
		local temp1 = temp[type1(x)]
		if temp1 then
			tempMethod = temp1[type1(y)] or nil
		else
			tempMethod = nil
		end
	else
		tempMethod = nil
	end
	if not tempMethod then
		if tempThis["default"] then
			tempMethod = tempThis["default"]
		else
			error1("No matching method to call for (" .. concat1(list1("eq?", type1(x), type1(y)), " ") .. ")\n  " .. (function()
				if n1((keys1(tempThis["lookup"]))) >= 1 then
					return "There are methods to call for\n" .. concat1(map1((function(tempKey)
						return "  - " .. tempKey
					end), keys1(tempThis["lookup"])), "\n")
				else
					return "There are no methods to call."
				end
			end)())
		end
	end
	return tempMethod(x, y)
end),["name"]="eq?",["args"]=list1("x", "y")}))
put_21_1(eq_3f_1, list1("lookup", "list", "list"), (function(x, y)
	if n1(x) ~= n1(y) then
		return false
	else
		local equal = true
		local temp = n1(x)
		local temp1 = 1
		while temp1 <= temp do
			if neq_3f_1(x[temp1], y[temp1]) then
				equal = false
			end
			temp1 = temp1 + 1
		end
		return equal
	end
end))
put_21_1(eq_3f_1, list1("lookup", "table", "table"), (function(x, y)
	local equal = true
	local temp, v = next1(x)
	while temp ~= nil do
		if neq_3f_1(v, y[temp]) then
			equal = false
		end
		temp, v = next1(x, temp)
	end
	return equal
end))
put_21_1(eq_3f_1, list1("lookup", "symbol", "symbol"), (function(x, y)
	return x["contents"] == y["contents"]
end))
put_21_1(eq_3f_1, list1("lookup", "string", "symbol"), (function(x, y)
	return x == y["contents"]
end))
put_21_1(eq_3f_1, list1("lookup", "symbol", "string"), (function(x, y)
	return x["contents"] == y
end))
put_21_1(eq_3f_1, list1("lookup", "key", "string"), (function(x, y)
	return x["value"] == y
end))
put_21_1(eq_3f_1, list1("lookup", "string", "key"), (function(x, y)
	return x == y["value"]
end))
put_21_1(eq_3f_1, list1("lookup", "key", "key"), (function(x, y)
	return x["value"] == y["value"]
end))
put_21_1(eq_3f_1, list1("lookup", "number", "number"), (function(x, y)
	return constVal1(x) == constVal1(y)
end))
put_21_1(eq_3f_1, list1("lookup", "string", "string"), (function(x, y)
	return constVal1(x) == constVal1(y)
end))
eq_3f_1["default"] = (function(x, y)
	return false
end)
local original = getmetatable1(eq_3f_1)["__call"]
getmetatable1(eq_3f_1)["__call"] = (function(self, x, y)
	if x == y then
		return true
	else
		return original(self, x, y)
	end
end)
pretty1 = setmetatable1(({["lookup"]=({}),["tag"]="multimethod"}), ({["__call"]=(function(tempThis, x)
	local tempMethod
	local temp = tempThis["lookup"]
	if temp then
		tempMethod = temp[type1(x)] or nil
	else
		tempMethod = nil
	end
	if not tempMethod then
		if tempThis["default"] then
			tempMethod = tempThis["default"]
		else
			error1("No matching method to call for (" .. concat1(list1("pretty", type1(x)), " ") .. ")\n  " .. (function()
				if n1((keys1(tempThis["lookup"]))) >= 1 then
					return "There are methods to call for\n" .. concat1(map1((function(tempKey)
						return "  - " .. tempKey
					end), keys1(tempThis["lookup"])), "\n")
				else
					return "There are no methods to call."
				end
			end)())
		end
	end
	return tempMethod(x)
end),["name"]="pretty",["args"]=list1("x")}))
put_21_1(pretty1, list1("lookup", "list"), (function(xs)
	return "(" .. concat1(map1(pretty1, xs), " ") .. ")"
end))
put_21_1(pretty1, list1("lookup", "symbol"), (function(x)
	return x["contents"]
end))
put_21_1(pretty1, list1("lookup", "key"), (function(x)
	return ":" .. x["value"]
end))
put_21_1(pretty1, list1("lookup", "number"), (function(x)
	return tostring1(constVal1(x))
end))
put_21_1(pretty1, list1("lookup", "string"), (function(x)
	return format1("%q", constVal1(x))
end))
put_21_1(pretty1, list1("lookup", "table"), (function(x)
	local out = ({tag = "list", n = 0})
	local temp, v = next1(x)
	while temp ~= nil do
		local _offset, _result, _temp = 0, {tag="list",n=0}
		_result[1 + _offset] = pretty1(temp) .. " " .. pretty1(v)
		_temp = out
		for _c = 1, _temp.n do _result[1 + _c + _offset] = _temp[_c] end
		_offset = _offset + _temp.n
		_result.n = _offset + 1
		out = _result
		temp, v = next1(x, temp)
	end
	return "{" .. (concat1(out, " ") .. "}")
end))
put_21_1(pretty1, list1("lookup", "multimethod"), (function(x)
	return "«method: (" .. getmetatable1(x)["name"] .. " " .. concat1(getmetatable1(x)["args"], " ") .. ")»"
end))
pretty1["default"] = (function(x)
	if table_3f_1(x) then
		return (function(temp)
			if temp then
				return temp["table"] or nil
			else
				return nil
			end
		end)(pretty1["lookup"])(x)
	else
		return tostring1(x)
	end
end)
abs1 = math.abs
modf1 = math.modf
sqrt1 = math.sqrt
car2 = (function(x)
	local temp = type1(x)
	if temp ~= "list" then
		error1(format1("bad argument %s (expected %s, got %s)", "x", "list", temp), 2)
	end
	return car1(x)
end)
cdr2 = (function(x)
	local temp = type1(x)
	if temp ~= "list" then
		error1(format1("bad argument %s (expected %s, got %s)", "x", "list", temp), 2)
	end
	if empty_3f_1(x) then
		return ({tag = "list", n = 0})
	else
		return cdr1(x)
	end
end)
nth1 = (function(xs, idx)
	if idx >= 0 then
		return xs[idx]
	else
		return xs[xs["n"] + 1 + idx]
	end
end)
pushCdr_21_1 = (function(xs, val)
	local temp = type1(xs)
	if temp ~= "list" then
		error1(format1("bad argument %s (expected %s, got %s)", "xs", "list", temp), 2)
	end
	local len = n1(xs) + 1
	xs["n"] = len
	xs[len] = val
	return xs
end)
cadr1 = (function(xs)
	local temp = type1(xs)
	if temp ~= "list" then
		error1(format1("bad argument %s (expected %s, got %s)", "xs", "list", temp), 2)
	end
	return xs[2]
end)
split1 = (function(text, pattern, limit)
	local out, loop, start = ({tag = "list", n = 0}), true, 1
	while loop do
		local pos = list1(find1(text, pattern, start))
		local nstart, nend = car2(pos), cadr1(pos)
		if nstart == nil or limit and n1(out) >= limit then
			loop = false
			pushCdr_21_1(out, sub1(text, start, n1(text)))
			start = n1(text) + 1
		elseif nstart > #text then
			if start <= #text then
				pushCdr_21_1(out, sub1(text, start, #text))
			end
			loop = false
		elseif nend < nstart then
			pushCdr_21_1(out, sub1(text, start, nstart))
			start = nstart + 1
		else
			pushCdr_21_1(out, sub1(text, start, nstart - 1))
			start = nend + 1
		end
	end
	return out
end)
struct_2d3e_list1 = (function(tbl)
	return updateStruct1(tbl, "tag", "list", "n", #tbl)
end)
struct1 = (function(...)
	local entries = _pack(...) entries.tag = "list"
	if n1(entries) % 2 == 1 then
		error1("Expected an even number of arguments to struct", 2)
	end
	local out = ({})
	local temp = n1(entries)
	local temp1 = 1
	while temp1 <= temp do
		local key, val = entries[temp1], entries[1 + temp1]
		out[(function()
			if key_3f_1(key) then
				return key["value"]
			else
				return key
			end
		end)()] = val
		temp1 = temp1 + 2
	end
	return out
end)
merge1 = (function(...)
	local structs = _pack(...) structs.tag = "list"
	local out = ({})
	local temp = n1(structs)
	local temp1 = 1
	while temp1 <= temp do
		local st = structs[temp1]
		local temp2, v = next1(st)
		while temp2 ~= nil do
			out[temp2] = v
			temp2, v = next1(st, temp2)
		end
		temp1 = temp1 + 1
	end
	return out
end)
updateStruct1 = (function(st, ...)
	local keys = _pack(...) keys.tag = "list"
	return merge1(st, apply1(struct1, keys))
end)
display1 = (function(x)
	if type_23_1(x) == "string" then
		return x
	elseif type_23_1(x) == "table" and x["tag"] == "string" then
		return x["value"]
	else
		return pretty1(x)
	end
end)
formatOutput_21_1 = (function(out, buf)
	if out == nil then
		return buf
	elseif out == true then
		return print1(buf)
	elseif number_3f_1(out) then
		return error1(buf, out)
	elseif function_3f_1(out) then
		return out(buf)
	else
		return self1(out, "write", buf)
	end
end)
self1 = (function(x, key, ...)
	local args = _pack(...) args.tag = "list"
	return x[key](x, unpack1(args, 1, n1(args)))
end)
gcd1 = (function(x, y)
	local x1, y1 = abs1(x), abs1(y)
	while not (y1 == 0) do
		x1, y1 = y1, x1 % y1
	end
	return x1
end)
n_2b_1 = setmetatable1(({["lookup"]=({}),["tag"]="multimethod"}), ({["__call"]=(function(tempThis, x, y)
	local tempMethod
	local temp = tempThis["lookup"]
	if temp then
		local temp1 = temp[type1(x)]
		if temp1 then
			tempMethod = temp1[type1(y)] or nil
		else
			tempMethod = nil
		end
	else
		tempMethod = nil
	end
	if not tempMethod then
		if tempThis["default"] then
			tempMethod = tempThis["default"]
		else
			error1("No matching method to call for (" .. concat1(list1("n+", type1(x), type1(y)), " ") .. ")\n  " .. (function()
				if n1((keys1(tempThis["lookup"]))) >= 1 then
					return "There are methods to call for\n" .. concat1(map1((function(tempKey)
						return "  - " .. tempKey
					end), keys1(tempThis["lookup"])), "\n")
				else
					return "There are no methods to call."
				end
			end)())
		end
	end
	return tempMethod(x, y)
end),["name"]="n+",["args"]=list1("x", "y")}))
n_2d_1 = setmetatable1(({["lookup"]=({}),["tag"]="multimethod"}), ({["__call"]=(function(tempThis, x, y)
	local tempMethod
	local temp = tempThis["lookup"]
	if temp then
		local temp1 = temp[type1(x)]
		if temp1 then
			tempMethod = temp1[type1(y)] or nil
		else
			tempMethod = nil
		end
	else
		tempMethod = nil
	end
	if not tempMethod then
		if tempThis["default"] then
			tempMethod = tempThis["default"]
		else
			error1("No matching method to call for (" .. concat1(list1("n-", type1(x), type1(y)), " ") .. ")\n  " .. (function()
				if n1((keys1(tempThis["lookup"]))) >= 1 then
					return "There are methods to call for\n" .. concat1(map1((function(tempKey)
						return "  - " .. tempKey
					end), keys1(tempThis["lookup"])), "\n")
				else
					return "There are no methods to call."
				end
			end)())
		end
	end
	return tempMethod(x, y)
end),["name"]="n-",["args"]=list1("x", "y")}))
n_2a_1 = setmetatable1(({["lookup"]=({}),["tag"]="multimethod"}), ({["__call"]=(function(tempThis, x, y)
	local tempMethod
	local temp = tempThis["lookup"]
	if temp then
		local temp1 = temp[type1(x)]
		if temp1 then
			tempMethod = temp1[type1(y)] or nil
		else
			tempMethod = nil
		end
	else
		tempMethod = nil
	end
	if not tempMethod then
		if tempThis["default"] then
			tempMethod = tempThis["default"]
		else
			error1("No matching method to call for (" .. concat1(list1("n*", type1(x), type1(y)), " ") .. ")\n  " .. (function()
				if n1((keys1(tempThis["lookup"]))) >= 1 then
					return "There are methods to call for\n" .. concat1(map1((function(tempKey)
						return "  - " .. tempKey
					end), keys1(tempThis["lookup"])), "\n")
				else
					return "There are no methods to call."
				end
			end)())
		end
	end
	return tempMethod(x, y)
end),["name"]="n*",["args"]=list1("x", "y")}))
n_2f_1 = setmetatable1(({["lookup"]=({}),["tag"]="multimethod"}), ({["__call"]=(function(tempThis, x, y)
	local tempMethod
	local temp = tempThis["lookup"]
	if temp then
		local temp1 = temp[type1(x)]
		if temp1 then
			tempMethod = temp1[type1(y)] or nil
		else
			tempMethod = nil
		end
	else
		tempMethod = nil
	end
	if not tempMethod then
		if tempThis["default"] then
			tempMethod = tempThis["default"]
		else
			error1("No matching method to call for (" .. concat1(list1("n/", type1(x), type1(y)), " ") .. ")\n  " .. (function()
				if n1((keys1(tempThis["lookup"]))) >= 1 then
					return "There are methods to call for\n" .. concat1(map1((function(tempKey)
						return "  - " .. tempKey
					end), keys1(tempThis["lookup"])), "\n")
				else
					return "There are no methods to call."
				end
			end)())
		end
	end
	return tempMethod(x, y)
end),["name"]="n/",["args"]=list1("x", "y")}))
n_5e_1 = setmetatable1(({["lookup"]=({}),["tag"]="multimethod"}), ({["__call"]=(function(tempThis, x, y)
	local tempMethod
	local temp = tempThis["lookup"]
	if temp then
		local temp1 = temp[type1(x)]
		if temp1 then
			tempMethod = temp1[type1(y)] or nil
		else
			tempMethod = nil
		end
	else
		tempMethod = nil
	end
	if not tempMethod then
		if tempThis["default"] then
			tempMethod = tempThis["default"]
		else
			error1("No matching method to call for (" .. concat1(list1("n^", type1(x), type1(y)), " ") .. ")\n  " .. (function()
				if n1((keys1(tempThis["lookup"]))) >= 1 then
					return "There are methods to call for\n" .. concat1(map1((function(tempKey)
						return "  - " .. tempKey
					end), keys1(tempThis["lookup"])), "\n")
				else
					return "There are no methods to call."
				end
			end)())
		end
	end
	return tempMethod(x, y)
end),["name"]="n^",["args"]=list1("x", "y")}))
n_3c_1 = setmetatable1(({["lookup"]=({}),["tag"]="multimethod"}), ({["__call"]=(function(tempThis, x, y)
	local tempMethod
	local temp = tempThis["lookup"]
	if temp then
		local temp1 = temp[type1(x)]
		if temp1 then
			tempMethod = temp1[type1(y)] or nil
		else
			tempMethod = nil
		end
	else
		tempMethod = nil
	end
	if not tempMethod then
		if tempThis["default"] then
			tempMethod = tempThis["default"]
		else
			error1("No matching method to call for (" .. concat1(list1("n<", type1(x), type1(y)), " ") .. ")\n  " .. (function()
				if n1((keys1(tempThis["lookup"]))) >= 1 then
					return "There are methods to call for\n" .. concat1(map1((function(tempKey)
						return "  - " .. tempKey
					end), keys1(tempThis["lookup"])), "\n")
				else
					return "There are no methods to call."
				end
			end)())
		end
	end
	return tempMethod(x, y)
end),["name"]="n<",["args"]=list1("x", "y")}))
n_3c3d_1 = setmetatable1(({["lookup"]=({}),["tag"]="multimethod"}), ({["__call"]=(function(tempThis, x, y)
	local tempMethod
	local temp = tempThis["lookup"]
	if temp then
		local temp1 = temp[type1(x)]
		if temp1 then
			tempMethod = temp1[type1(y)] or nil
		else
			tempMethod = nil
		end
	else
		tempMethod = nil
	end
	if not tempMethod then
		if tempThis["default"] then
			tempMethod = tempThis["default"]
		else
			error1("No matching method to call for (" .. concat1(list1("n<=", type1(x), type1(y)), " ") .. ")\n  " .. (function()
				if n1((keys1(tempThis["lookup"]))) >= 1 then
					return "There are methods to call for\n" .. concat1(map1((function(tempKey)
						return "  - " .. tempKey
					end), keys1(tempThis["lookup"])), "\n")
				else
					return "There are no methods to call."
				end
			end)())
		end
	end
	return tempMethod(x, y)
end),["name"]="n<=",["args"]=list1("x", "y")}))
nsqrt1 = setmetatable1(({["lookup"]=({}),["tag"]="multimethod"}), ({["__call"]=(function(tempThis, x)
	local tempMethod
	local temp = tempThis["lookup"]
	if temp then
		tempMethod = temp[type1(x)] or nil
	else
		tempMethod = nil
	end
	if not tempMethod then
		if tempThis["default"] then
			tempMethod = tempThis["default"]
		else
			error1("No matching method to call for (" .. concat1(list1("nsqrt", type1(x)), " ") .. ")\n  " .. (function()
				if n1((keys1(tempThis["lookup"]))) >= 1 then
					return "There are methods to call for\n" .. concat1(map1((function(tempKey)
						return "  - " .. tempKey
					end), keys1(tempThis["lookup"])), "\n")
				else
					return "There are no methods to call."
				end
			end)())
		end
	end
	return tempMethod(x)
end),["name"]="nsqrt",["args"]=list1("x")}))
nrecip1 = setmetatable1(({["lookup"]=({}),["tag"]="multimethod"}), ({["__call"]=(function(tempThis, x)
	local tempMethod
	local temp = tempThis["lookup"]
	if temp then
		tempMethod = temp[type1(x)] or nil
	else
		tempMethod = nil
	end
	if not tempMethod then
		if tempThis["default"] then
			tempMethod = tempThis["default"]
		else
			error1("No matching method to call for (" .. concat1(list1("nrecip", type1(x)), " ") .. ")\n  " .. (function()
				if n1((keys1(tempThis["lookup"]))) >= 1 then
					return "There are methods to call for\n" .. concat1(map1((function(tempKey)
						return "  - " .. tempKey
					end), keys1(tempThis["lookup"])), "\n")
				else
					return "There are no methods to call."
				end
			end)())
		end
	end
	return tempMethod(x)
end),["name"]="nrecip",["args"]=list1("x")}))
nnegate1 = setmetatable1(({["lookup"]=({}),["tag"]="multimethod"}), ({["__call"]=(function(tempThis, x)
	local tempMethod
	local temp = tempThis["lookup"]
	if temp then
		tempMethod = temp[type1(x)] or nil
	else
		tempMethod = nil
	end
	if not tempMethod then
		if tempThis["default"] then
			tempMethod = tempThis["default"]
		else
			error1("No matching method to call for (" .. concat1(list1("nnegate", type1(x)), " ") .. ")\n  " .. (function()
				if n1((keys1(tempThis["lookup"]))) >= 1 then
					return "There are methods to call for\n" .. concat1(map1((function(tempKey)
						return "  - " .. tempKey
					end), keys1(tempThis["lookup"])), "\n")
				else
					return "There are no methods to call."
				end
			end)())
		end
	end
	return tempMethod(x)
end),["name"]="nnegate",["args"]=list1("x")}))
nsign1 = setmetatable1(({["lookup"]=({}),["tag"]="multimethod"}), ({["__call"]=(function(tempThis, x)
	local tempMethod
	local temp = tempThis["lookup"]
	if temp then
		tempMethod = temp[type1(x)] or nil
	else
		tempMethod = nil
	end
	if not tempMethod then
		if tempThis["default"] then
			tempMethod = tempThis["default"]
		else
			error1("No matching method to call for (" .. concat1(list1("nsign", type1(x)), " ") .. ")\n  " .. (function()
				if n1((keys1(tempThis["lookup"]))) >= 1 then
					return "There are methods to call for\n" .. concat1(map1((function(tempKey)
						return "  - " .. tempKey
					end), keys1(tempThis["lookup"])), "\n")
				else
					return "There are no methods to call."
				end
			end)())
		end
	end
	return tempMethod(x)
end),["name"]="nsign",["args"]=list1("x")}))
nabs1 = setmetatable1(({["lookup"]=({}),["tag"]="multimethod"}), ({["__call"]=(function(tempThis, x)
	local tempMethod
	local temp = tempThis["lookup"]
	if temp then
		tempMethod = temp[type1(x)] or nil
	else
		tempMethod = nil
	end
	if not tempMethod then
		if tempThis["default"] then
			tempMethod = tempThis["default"]
		else
			error1("No matching method to call for (" .. concat1(list1("nabs", type1(x)), " ") .. ")\n  " .. (function()
				if n1((keys1(tempThis["lookup"]))) >= 1 then
					return "There are methods to call for\n" .. concat1(map1((function(tempKey)
						return "  - " .. tempKey
					end), keys1(tempThis["lookup"])), "\n")
				else
					return "There are no methods to call."
				end
			end)())
		end
	end
	return tempMethod(x)
end),["name"]="nabs",["args"]=list1("x")}))
put_21_1(n_2b_1, list1("lookup", "number", "number"), (function(x, y)
	return x + y
end))
put_21_1(n_2d_1, list1("lookup", "number", "number"), (function(x, y)
	return x - y
end))
put_21_1(n_2a_1, list1("lookup", "number", "number"), (function(x, y)
	return x * y
end))
put_21_1(n_2f_1, list1("lookup", "number", "number"), (function(x, y)
	return x / y
end))
put_21_1(n_5e_1, list1("lookup", "number", "number"), (function(x, y)
	return x ^ y
end))
put_21_1(n_3c_1, list1("lookup", "number", "number"), (function(x, y)
	return x < y
end))
put_21_1(n_3c3d_1, list1("lookup", "number", "number"), (function(x, y)
	return x <= y
end))
put_21_1(nsqrt1, list1("lookup", "number"), (function(x)
	return sqrt1(x)
end))
put_21_1(nrecip1, list1("lookup", "number"), (function(x)
	return 1 / x
end))
put_21_1(nnegate1, list1("lookup", "number"), (function(x)
	return x * -1
end))
put_21_1(nabs1, list1("lookup", "number"), (function(x)
	return abs1(x)
end))
put_21_1(nsign1, list1("lookup", "number"), (function(x)
	if x == 0 then
		return 0
	elseif x ~= x then
		return nil
	elseif x > 0 then
		return 1
	else
		return -1
	end
end))
nnegate1["default"] = (function(x)
	return n_2a_1(-1, x)
end)
local new = (function(numerator, denominator)
	return ({["tag"]="rational",["numerator"]=numerator or nil,["denominator"]=denominator or nil})
end)
rational1 = (function(n, d)
	if not (number_3f_1(n) and 0 == second1(modf1(n))) then
		local temp = ({})
		formatOutput_21_1(1, "(rational " .. display1(n) .. " " .. display1(d) .. "): numerator must be an integer")
	end
	if not (number_3f_1(d) and 0 == second1(modf1(d))) then
		local temp = ({})
		formatOutput_21_1(1, "(rational " .. format1("%d", n) .. " " .. display1(d) .. "): denominator must be an integer")
	end
	if d == 0 then
		local temp = ({})
		formatOutput_21_1(1, "(rational " .. format1("%d", n) .. " " .. format1("%d", d) .. "): denominator is zero")
	end
	if d < 0 then
		d = -1 * d
		n = -1 * n
	end
	local x = gcd1(n, d)
	return setmetatable1(new(n / x, d / x), _2a_rationalMt_2a_1)
end)
numerator1 = (function(temp)
	return temp["numerator"]
end)
denominator1 = (function(temp)
	return temp["denominator"]
end)
_2d3e_ratComponents1 = (function(y)
	local i, f = modf1(y)
	local f_27_ = 10 ^ (n1(tostring1(f)) - 2)
	if 0 == f then
		return unpack1(list1(y, 1), 1, 2)
	else
		local n = y * f_27_
		local g = gcd1(n, f_27_)
		return unpack1(list1((n / g), (f_27_ / g)), 1, 2)
	end
end)
normalisedRationalComponents1 = (function(x)
	if number_3f_1(x) then
		return _2d3e_ratComponents1(x)
	else
		return unpack1(list1((numerator1(x)), (denominator1(x))), 1, 2)
	end
end)
put_21_1(n_2b_1, list1("lookup", "rational", "rational"), (function(x, y)
	local xn, xd = normalisedRationalComponents1(x)
	local yn, yd = normalisedRationalComponents1(y)
	return rational1(xn * yd + yn * xd, xd * yd)
end))
put_21_1(n_2d_1, list1("lookup", "rational", "rational"), (function(x, y)
	local xn, xd = normalisedRationalComponents1(x)
	local yn, yd = normalisedRationalComponents1(y)
	return rational1(xn * yd - yn * xd, xd * yd)
end))
put_21_1(n_2a_1, list1("lookup", "rational", "rational"), (function(x, y)
	local xn, xd = normalisedRationalComponents1(x)
	local yn, yd = normalisedRationalComponents1(y)
	return rational1(xn * yn, xd * yd)
end))
put_21_1(n_3c_1, list1("lookup", "rational", "rational"), (function(x, y)
	local xn, xd = normalisedRationalComponents1(x)
	local yn, yd = normalisedRationalComponents1(y)
	return xn * yd < yn * xd
end))
put_21_1(n_3c_1, list1("lookup", "rational", "number"), (function(temp)
	if temp then
		local temp1 = temp["rational"]
		if temp1 then
			return temp1["rational"] or nil
		else
			return nil
		end
	else
		return nil
	end
end)(n_3c_1["lookup"]))
put_21_1(n_3c_1, list1("lookup", "number", "rational"), (function(temp)
	if temp then
		local temp1 = temp["rational"]
		if temp1 then
			return temp1["rational"] or nil
		else
			return nil
		end
	else
		return nil
	end
end)(n_3c_1["lookup"]))
put_21_1(n_3c3d_1, list1("lookup", "rational", "rational"), (function(x, y)
	local xn, xd = normalisedRationalComponents1(x)
	local yn, yd = normalisedRationalComponents1(y)
	return xn * yd <= yn * xd
end))
put_21_1(n_3c3d_1, list1("lookup", "rational", "number"), (function(temp)
	if temp then
		local temp1 = temp["rational"]
		if temp1 then
			return temp1["rational"] or nil
		else
			return nil
		end
	else
		return nil
	end
end)(n_3c3d_1["lookup"]))
put_21_1(n_3c3d_1, list1("lookup", "number", "rational"), (function(temp)
	if temp then
		local temp1 = temp["rational"]
		if temp1 then
			return temp1["rational"] or nil
		else
			return nil
		end
	else
		return nil
	end
end)(n_3c3d_1["lookup"]))
put_21_1(n_5e_1, list1("lookup", "rational", "number"), (function(x, y)
	if 0 ~= second1(modf1(y)) then
		local temp = ({})
		formatOutput_21_1(1, "(^ " .. display1(x) .. " " .. display1(y) .. "): exponent must be an integral number.")
	end
	if y >= 0 then
		local xn, xd = normalisedRationalComponents1(x)
		return rational1(xn ^ y, xd ^ y)
	else
		return nrecip1(n_5e_1(x, nnegate1(y)))
	end
end))
put_21_1(nsqrt1, list1("lookup", "rational"), (function(x)
	local xn, xd = normalisedRationalComponents1(x)
	return rational1(sqrt1(xn), sqrt1(xd))
end))
_2a_rationalMt_2a_1 = ({["__add"]=n_2b_1,["__sub"]=n_2d_1,["__mul"]=n_2a_1,["__div"]=n_2f_1,["__pow"]=n_5e_1,["__lt"]=n_3c_1,["__lte"]=n_3c3d_1})
put_21_1(pretty1, list1("lookup", "rational"), (function(x)
	local xn, xd = normalisedRationalComponents1(x)
	local temp = ({})
	return formatOutput_21_1(nil, "" .. format1("%d", xn) .. "/" .. format1("%d", xd))
end))
put_21_1(eq_3f_1, list1("lookup", "rational", "rational"), (function(x, y)
	local xn, xd = normalisedRationalComponents1(x)
	local yn, yd = normalisedRationalComponents1(y)
	return xn == yn and xd == yd
end))
put_21_1(eq_3f_1, list1("lookup", "number", "rational"), (function(temp)
	if temp then
		local temp1 = temp["rational"]
		if temp1 then
			return temp1["rational"] or nil
		else
			return nil
		end
	else
		return nil
	end
end)(eq_3f_1["lookup"]))
put_21_1(eq_3f_1, list1("lookup", "rational", "number"), (function(temp)
	if temp then
		local temp1 = temp["rational"]
		if temp1 then
			return temp1["rational"] or nil
		else
			return nil
		end
	else
		return nil
	end
end)(eq_3f_1["lookup"]))
put_21_1(nrecip1, list1("lookup", "rational"), (function(x)
	return rational1(denominator1(x), numerator1(x))
end))
put_21_1(nnegate1, list1("lookup", "rational"), (function(x)
	return x * -1
end))
put_21_1(nabs1, list1("lookup", "rational"), (function(x)
	return rational1(nabs1(denominator1(x)), nabs1(numerator1(x)))
end))
put_21_1(nsign1, list1("lookup", "rational"), (function(x)
	return nsign1(denominator1(x)) * nsign1(numerator1(x))
end))
put_21_1(n_2f_1, list1("lookup", "rational", "rational"), (function(x, y)
	return n_2a_1(x, nrecip1(y))
end))
put_21_1(n_2b_1, list1("lookup", "rational", "number"), (function(temp)
	if temp then
		local temp1 = temp["rational"]
		if temp1 then
			return temp1["rational"] or nil
		else
			return nil
		end
	else
		return nil
	end
end)(n_2b_1["lookup"]))
put_21_1(n_2b_1, list1("lookup", "number", "rational"), (function(temp)
	if temp then
		local temp1 = temp["rational"]
		if temp1 then
			return temp1["rational"] or nil
		else
			return nil
		end
	else
		return nil
	end
end)(n_2b_1["lookup"]))
put_21_1(n_2a_1, list1("lookup", "rational", "number"), (function(temp)
	if temp then
		local temp1 = temp["rational"]
		if temp1 then
			return temp1["rational"] or nil
		else
			return nil
		end
	else
		return nil
	end
end)(n_2a_1["lookup"]))
put_21_1(n_2a_1, list1("lookup", "number", "rational"), (function(temp)
	if temp then
		local temp1 = temp["rational"]
		if temp1 then
			return temp1["rational"] or nil
		else
			return nil
		end
	else
		return nil
	end
end)(n_2a_1["lookup"]))
put_21_1(n_2d_1, list1("lookup", "rational", "number"), (function(temp)
	if temp then
		local temp1 = temp["rational"]
		if temp1 then
			return temp1["rational"] or nil
		else
			return nil
		end
	else
		return nil
	end
end)(n_2d_1["lookup"]))
put_21_1(n_2d_1, list1("lookup", "number", "rational"), (function(temp)
	if temp then
		local temp1 = temp["rational"]
		if temp1 then
			return temp1["rational"] or nil
		else
			return nil
		end
	else
		return nil
	end
end)(n_2d_1["lookup"]))
put_21_1(n_2f_1, list1("lookup", "rational", "number"), (function(temp)
	if temp then
		local temp1 = temp["rational"]
		if temp1 then
			return temp1["rational"] or nil
		else
			return nil
		end
	else
		return nil
	end
end)(n_2f_1["lookup"]))
put_21_1(n_2f_1, list1("lookup", "number", "rational"), (function(temp)
	if temp then
		local temp1 = temp["rational"]
		if temp1 then
			return temp1["rational"] or nil
		else
			return nil
		end
	else
		return nil
	end
end)(n_2f_1["lookup"]))
nvim_5f_command1 = vim.api.nvim_command
nvim_5f_call_5f_function1 = vim.api.nvim_call_function
nvim_5f_get_5f_current_5f_buf1 = vim.api.nvim_get_current_buf
nvim_5f_buf_5f_add_5f_highlight1 = vim.api.nvim_buf_add_highlight
list_2d3e_struct1 = (function(x)
	if list_3f_1(x) then
		x["n"] = nil
		x["tag"] = nil
	end
	return x
end)
nvim_5f_call_5f_function_2a_1 = (function(...)
	local args = _pack(...) args.tag = "list"
	return nvim_5f_call_5f_function1(car2(args), list_2d3e_struct1(cdr2(args)))
end)
echo1 = (function(msg)
	return nvim_5f_command1("echo \"" .. msg .. "\"")
end)
emit1 = (function(msg, hlGroup)
	nvim_5f_command1("echohl " .. hlGroup)
	echo1(msg)
	return nvim_5f_command1("echohl Normal")
end)
struct_2d3e_list_2a_1 = (function(s)
	return s and struct_2d3e_list1(s)
end)
cider_2d2d_abbreviateFileProtocol1 = (function(fileWithProtocol)
	local file = match1(fileWithProtocol, "^file:(.*)")
	if file then
		return nvim_5f_call_5f_function1("fnamemodify", file(":."))
	else
		return fileWithProtocol
	end
end)
setLocalOpt1 = (function(opt_2a_)
	return nvim_5f_command1("setlocal " .. (function()
		if list_3f_1(opt_2a_) and (n1(opt_2a_) >= 2 and (n1(opt_2a_) <= 2 and true)) then
			local opt, val = nth1(opt_2a_, 1), nth1(opt_2a_, 2)
			if boolean_3f_1(val) then
				return (function()
					if _enot1(val) then
						return "no"
					else
						return ""
					end
				end)() .. opt
			else
				return opt .. "=" .. val
			end
		else
			return error1("Pattern matching failure! Can not match the pattern `(?opt ?val)` against `" .. pretty1(opt_2a_) .. "`.")
		end
	end)())
end)
list_2d3e_struct2 = (function(x)
	if list_3f_1(x) then
		x["n"] = nil
		x["tag"] = nil
	end
	return x
end)
doStuff1 = (function(str)
	nvim_5f_command1("vsplit foobar")
	local temp, tempList = list1(list1("bufhidden", "hide"), list1("buflisted", false), list1("buftype", "nofile"), list1("foldcolumn", "0"), list1("foldenable", false), list1("number", false), list1("swapfile", false), list1("modifiable", true)), ({tag = "list", n = 0})
	local tempYield = (function(tempVal)
		if tempVal ~= nil then
			return pushCdr_21_1(tempList, tempVal)
		else
			return nil
		end
	end)
	local temp1 = n1(temp)
	local temp2 = 1
	while temp2 <= temp1 do
		tempYield(setLocalOpt1((temp[temp2])))
		temp2 = temp2 + 1
	end
	nvim_5f_call_5f_function_2a_1("setline", nvim_5f_call_5f_function_2a_1("line", "$"), list_2d3e_struct2(list1("# THE END")))
	nvim_5f_call_5f_function_2a_1("append", nvim_5f_call_5f_function_2a_1("line", "$"), list_2d3e_struct2(list1("# j/k")))
	nvim_5f_call_5f_function_2a_1("append", nvim_5f_call_5f_function_2a_1("line", "$"), list_2d3e_struct2(list1("# j/k2")))
	return setLocalOpt1(list1("modifiable", false))
end)
doAthing1 = (function()
	return list_2d3e_struct2(list1(1, 2, 3))
end)
bufferEcho1 = (function(msg)
	local line = nvim_5f_call_5f_function_2a_1("line", "$")
	return nvim_5f_call_5f_function_2a_1("append", nvim_5f_call_5f_function_2a_1("line", "$"), msg)
end)
bufferEmit1 = (function(msg, hlGroup)
	local line = nvim_5f_call_5f_function_2a_1("line", "$")
	nvim_5f_call_5f_function_2a_1("append", nvim_5f_call_5f_function_2a_1("line", "$"), msg)
	return nvim_5f_buf_5f_add_5f_highlight1(nvim_5f_get_5f_current_5f_buf1(), -1, hlGroup, line, 0, len1(msg))
end)
docBuffer1 = (function(info)
	local ns, name, added, depr, macro, special, file = info["ns"], info["name"], info["added"], info["deprecated"], info["macro"], info["special-form"], info["file"]
	local forms
	local str = info["forms-str"]
	if str then
		forms = split1(str, "\n")
	else
		forms = nil
	end
	local args
	local str = info["arglists-str"]
	if str then
		args = split1(str, "\n")
	else
		args = nil
	end
	local doc, url, class, member, javadoc, super, ifaces, spec = info["doc"] or "Not documented.", info["url"], info["class"], info["member"], info["javadoc"], info["super"], info["interfaces"], struct_2d3e_list_2a_1(info["spec"])
	local cljName
	if ns then
		cljName = ns .. "/" .. name
	else
		cljName = name
	end
	local javaName
	if member then
		javaName = concat1(class, "/", member)
	else
		javaName = class
	end
	local seeAlso = struct_2d3e_list_2a_1(info["see-also"])
	nvim_5f_command1("vsplit " .. ((function(temp)
		return temp or "niledout"
	end)((function()
		if class then
			return javaName
		else
			return cljName
		end
	end)()) .. ".replantdoc"))
	local temp, tempList = list1(list1("bufhidden", "hide"), list1("buflisted", false), list1("buftype", "nofile"), list1("foldcolumn", "0"), list1("foldenable", false), list1("number", false), list1("swapfile", false), list1("modifiable", true)), ({tag = "list", n = 0})
	local tempYield = (function(tempVal)
		if tempVal ~= nil then
			return pushCdr_21_1(tempList, tempVal)
		else
			return nil
		end
	end)
	local temp1 = n1(temp)
	local temp2 = 1
	while temp2 <= temp1 do
		tempYield(setLocalOpt1((temp[temp2])))
		temp2 = temp2 + 1
	end
	bufferEmit1((function()
		if class then
			return javaName
		else
			return cljName
		end
	end)(), "Error")
	if super then
		bufferEcho1("   Extends: " .. super)
	end
	if ifaces then
		bufferEcho1("Implements: ~{(car ifaces)}")
		local temp = cdr2(ifaces)
		local temp1 = n1(temp)
		local temp2 = 1
		while temp2 <= temp1 do
			bufferEcho1("            " .. (temp[temp2]))
			temp2 = temp2 + 1
		end
	end
	if super or ifaces then
		bufferEcho1("\n")
	end
	local forms1 = forms or args
	if forms1 then
		local temp = n1(forms1)
		local temp1 = 1
		while temp1 <= temp do
			bufferEmit1(" " .. (forms1[temp1]), "Error")
			temp1 = temp1 + 1
		end
	end
	if special then
		bufferEmit1("Special Form", "Error")
	end
	if macro then
		bufferEmit1("Macro", "Error")
	end
	if added then
		bufferEmit1("Added in " .. added, "Comment")
	end
	if depr then
		bufferEmit1("Deprecated in " .. depr, "Error")
	end
	bufferEcho1("  " .. doc)
	local url1 = url or javadoc
	if url1 then
		bufferEcho1("\nPlease see " .. url1)
	end
	if spec and spec[1] then
		bufferEcho1("\nSpec: ")
		local temp = n1(spec)
		local temp1 = 1
		while temp1 <= temp do
			bufferEcho1(spec[temp1] .. "\n")
			temp1 = temp1 + 1
		end
	end
	bufferEmit1((function()
		if class then
			return javaName
		else
			return cljName
		end
	end)() .. " is defined in " .. (cider_2d2d_abbreviateFileProtocol1(file)), "Comment")
	if seeAlso then
		bufferEcho1("\nAlso see: " .. concat1(seeAlso, " "))
	end
	return setLocalOpt1(list1("modifiable", false))
end)
doc1 = (function(info)
	local ns, name, added, depr, macro, special, file = info["ns"], info["name"], info["added"], info["deprecated"], info["macro"], info["special-form"], info["file"]
	local forms
	local str = info["forms-str"]
	if str then
		forms = split1(str, "\n")
	else
		forms = nil
	end
	local args
	local str = info["arglists-str"]
	if str then
		args = split1(str, "\n")
	else
		args = nil
	end
	local doc, url, class, member, javadoc, super, ifaces, spec = info["doc"] or "Not documented.", info["url"], info["class"], info["member"], info["javadoc"], info["super"], info["interfaces"], struct_2d3e_list_2a_1(info["spec"])
	local cljName
	if ns then
		cljName = ns .. "/" .. name
	else
		cljName = name
	end
	local javaName
	if member then
		javaName = concat1(class, "/", member)
	else
		javaName = class
	end
	local seeAlso = struct_2d3e_list_2a_1(info["see-also"])
	emit1((function()
		if class then
			return javaName
		else
			return cljName
		end
	end)(), "Error")
	if super then
		echo1("   Extends: " .. super)
	end
	if ifaces then
		echo1("Implements: ~{(car ifaces)}")
		local temp = cdr2(ifaces)
		local temp1 = n1(temp)
		local temp2 = 1
		while temp2 <= temp1 do
			echo1("            " .. (temp[temp2]))
			temp2 = temp2 + 1
		end
	end
	if super or ifaces then
		echo1("\n")
	end
	local forms1 = forms or args
	if forms1 then
		local temp = n1(forms1)
		local temp1 = 1
		while temp1 <= temp do
			emit1(" " .. (forms1[temp1]), "Error")
			temp1 = temp1 + 1
		end
	end
	if special then
		emit1("Special Form", "Error")
	end
	if macro then
		emit1("Macro", "Error")
	end
	if added then
		emit1("Added in " .. added, "Comment")
	end
	if depr then
		emit1("Deprecated in " .. depr, "Error")
	end
	echo1("  " .. doc)
	local url1 = url or javadoc
	if url1 then
		echo1("\nPlease see " .. url1)
	end
	if spec and spec[1] then
		echo1("\nSpec: ")
		local temp = n1(spec)
		local temp1 = 1
		while temp1 <= temp do
			echo1(spec[temp1] .. "\n")
			temp1 = temp1 + 1
		end
	end
	emit1((function()
		if class then
			return javaName
		else
			return cljName
		end
	end)() .. " is defined in " .. (cider_2d2d_abbreviateFileProtocol1(file)), "Comment")
	if seeAlso then
		return echo1("\nAlso see: " .. concat1(seeAlso, " "))
	else
		return nil
	end
end)
return ({["doc"]=doc1,["do_stuff"]=doStuff1,["do_athing"]=doAthing1,["buffer_emit"]=bufferEmit1,["buffer_doc"]=docBuffer1})

if not table.pack then table.pack = function(...) return { n = select("#", ...), ... } end end
if not table.unpack then table.unpack = unpack end
local load = load if _VERSION:find("5.1") then load = function(x, n, _, env) local f, e = loadstring(x, n) if not f then return f, e end if env then setfenv(f, env) end return f end end
local _select, _unpack, _pack, _error = select, table.unpack, table.pack, error
local _libs = {}
local _3d_1, _2f3d_1, _3c_1, _3c3d_1, _3e_1, _3e3d_1, _2b_1, _2d_1, _2a_1, _2f_1, mod1, expt1, _2e2e_1, len_23_1, error1, getmetatable1, next1, print1, getIdx1, setIdx_21_1, setmetatable1, tostring1, type_23_1, find1, format1, gsub1, len1, match1, sub1, concat1, unpack1, n1, slice1, car1, cdr1, list1, _enot1, constVal1, apply1, table_3f_1, list_3f_1, empty_3f_1, number_3f_1, boolean_3f_1, function_3f_1, key_3f_1, type1, map1, pretty1, abs1, modf1, car2, cdr2, nth1, pushCdr_21_1, cadr1, split1, struct_2d3e_list1, list_2d3e_struct1, struct1, merge1, updateStruct1, formatOutput_21_1, self1, gcd1, numerator1, denominator1, _2d3e_ratComponents1, normalisedRationalComponents1, nvim_5f_command1, nvim_5f_call_5f_function1, nvim_5f_get_5f_current_5f_buf1, nvim_5f_buf_5f_set_5f_var1, nvim_5f_buf_5f_add_5f_highlight1, list_2d3e_struct2, nvim_5f_call_5f_function_2a_1, echo1, emit1, struct_2d3e_list_2a_1, cider_2d2d_abbreviateFileProtocol1, infoFile_2d3e_vimFile1, setLocalOpt1, bufferEcho1, bufferEmit1, docBuffer1, doc1
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
mod1 = function(...) local t = ... for i = 2, _select('#', ...) do t = t % _select(i, ...) end return t end
expt1 = function(...) local t = ... for i = 2, _select('#', ...) do t = t ^ _select(i, ...) end return t end
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
gsub1 = string.gsub
len1 = string.len
match1 = string.match
sub1 = string.sub
concat1 = table.concat
unpack1 = table.unpack
n1 = function(x)
	if type_23_1(x) == "table" then
		return x["n"]
	else
		return #x
	end
end
slice1 = function(xs, start, finish)
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
	local out, i, j = {["tag"]="list", ["n"]=len}, 1, start
	while j <= finish do
		out[i] = xs[j]
		i, j = i + 1, j + 1
	end
	return out
end
car1 = function(xs)
	return xs[1]
end
cdr1 = function(xs)
	return slice1(xs, 2)
end
list1 = function(...)
	local xs = _pack(...) xs.tag = "list"
	return xs
end
_enot1 = function(expr)
	return not expr
end
constVal1 = function(val)
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
end
apply1 = function(f, ...)
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
		local _offset, _result, _temp = 0, {tag="list"}
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
end
table_3f_1 = function(x)
	return type_23_1(x) == "table"
end
list_3f_1 = function(x)
	return type1(x) == "list"
end
empty_3f_1 = function(x)
	local xt = type1(x)
	if xt == "list" then
		return x["n"] == 0
	elseif xt == "string" then
		return #x == 0
	else
		return false
	end
end
number_3f_1 = function(x)
	return type_23_1(x) == "number" or type_23_1(x) == "table" and x["tag"] == "number"
end
boolean_3f_1 = function(x)
	return type_23_1(x) == "boolean" or type_23_1(x) == "table" and x["tag"] == "boolean"
end
function_3f_1 = function(x)
	return type1(x) == "function" or type1(x) == "multimethod"
end
key_3f_1 = function(x)
	return type1(x) == "key"
end
type1 = function(val)
	local ty = type_23_1(val)
	if ty == "table" then
		return val["tag"] or "table"
	else
		return ty
	end
end
map1 = function(f, x)
	local out = {tag="list", n=0}
	local temp = n1(x)
	local temp1 = 1
	while temp1 <= temp do
		out[temp1] = f(x[temp1])
		temp1 = temp1 + 1
	end
	out["n"] = n1(x)
	return out
end
local this = {["lookup"]={["list"]=function(xs)
	return "(" .. concat1(map1(pretty1, xs), " ") .. ")"
end, ["symbol"]=function(x)
	return x["contents"]
end, ["key"]=function(x)
	return ":" .. x["value"]
end, ["number"]=function(x)
	return format1("%g", constVal1(x))
end, ["string"]=function(x)
	return format1("%q", constVal1(x))
end, ["table"]=function(x)
	local out = {tag="list", n=0}
	local temp, v = next1(x)
	while temp ~= nil do
		local _offset, _result, _temp = 0, {tag="list"}
		_result[1 + _offset] = pretty1(temp) .. " " .. pretty1(v)
		_temp = out
		for _c = 1, _temp.n do _result[1 + _c + _offset] = _temp[_c] end
		_offset = _offset + _temp.n
		_result.n = _offset + 1
		out = _result
		temp, v = next1(x, temp)
	end
	return "{" .. (concat1(out, " ") .. "}")
end, ["multimethod"]=function(x)
	return "«method: (" .. getmetatable1(x)["name"] .. " " .. concat1(getmetatable1(x)["args"], " ") .. ")»"
end, ["rational"]=function(x)
	local xn, xd = normalisedRationalComponents1(x)
	return formatOutput_21_1(nil, "" .. format1("%d", xn) .. "/" .. format1("%d", xd))
end}, ["tag"]="multimethod", ["default"]=function(x)
	if table_3f_1(x) then
		return pretty1["lookup"]["table"](x)
	else
		return tostring1(x)
	end
end}
pretty1 = setmetatable1(this, {["__call"]=(function()
	local myself = function(x)
		local method = this["lookup"][type1(x)] or this["default"]
		if not method then
			error1("No matching method to call for (" .. concat1(list1("pretty", type1(x)), " ") .. ")")
		end
		return method(x)
	end
	return function(this1, x)
		return myself(x)
	end
end)(), ["name"]="pretty", ["args"]=list1("x")})
abs1 = math.abs
modf1 = math.modf
car2 = function(x)
	local temp = type1(x)
	if temp ~= "list" then
		error1(format1("bad argument %s (expected %s, got %s)", "x", "list", temp), 2)
	end
	return car1(x)
end
cdr2 = function(x)
	local temp = type1(x)
	if temp ~= "list" then
		error1(format1("bad argument %s (expected %s, got %s)", "x", "list", temp), 2)
	end
	if empty_3f_1(x) then
		return {tag="list", n=0}
	else
		return cdr1(x)
	end
end
nth1 = function(xs, idx)
	if idx >= 0 then
		return xs[idx]
	else
		return xs[xs["n"] + 1 + idx]
	end
end
pushCdr_21_1 = function(xs, ...)
	local vals = _pack(...) vals.tag = "list"
	local temp = type1(xs)
	if temp ~= "list" then
		error1(format1("bad argument %s (expected %s, got %s)", "xs", "list", temp), 2)
	end
	local nxs = n1(xs)
	xs["n"] = (nxs + n1(vals))
	local temp = n1(vals)
	local temp1 = 1
	while temp1 <= temp do
		xs[nxs + temp1] = vals[temp1]
		temp1 = temp1 + 1
	end
	return xs
end
cadr1 = function(xs)
	local temp = type1(xs)
	if temp ~= "list" then
		error1(format1("bad argument %s (expected %s, got %s)", "xs", "list", temp), 2)
	end
	return xs[2]
end
split1 = function(text, pattern, limit)
	local out, loop, start = {tag="list", n=0}, true, 1
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
end
struct_2d3e_list1 = function(tbl)
	return updateStruct1(tbl, "tag", "list", "n", #tbl)
end
list_2d3e_struct1 = function(list)
	local temp = type1(list)
	if temp ~= "list" then
		error1(format1("bad argument %s (expected %s, got %s)", "list", "list", temp), 2)
	end
	local out = {}
	local temp = n1(list)
	local temp1 = 1
	while temp1 <= temp do
		out[temp1] = nth1(list, temp1)
		temp1 = temp1 + 1
	end
	return out
end
struct1 = function(...)
	local entries = _pack(...) entries.tag = "list"
	if n1(entries) % 2 == 1 then
		error1("Expected an even number of arguments to struct", 2)
	end
	local out = {}
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
end
merge1 = function(...)
	local structs = _pack(...) structs.tag = "list"
	local out = {}
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
end
updateStruct1 = function(st, ...)
	local keys = _pack(...) keys.tag = "list"
	return merge1(st, apply1(struct1, keys))
end
formatOutput_21_1 = function(out, buf)
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
end
self1 = function(x, key, ...)
	local args = _pack(...) args.tag = "list"
	return x[key](x, unpack1(args, 1, n1(args)))
end
gcd1 = function(x, y)
	local x1, y1 = abs1(x), abs1(y)
	while not (y1 == 0) do
		x1, y1 = y1, x1 % y1
	end
	return x1
end
numerator1 = function(rational)
	return rational["numerator"]
end
denominator1 = function(rational)
	return rational["denominator"]
end
_2d3e_ratComponents1 = function(y)
	local i, f = modf1(y)
	local f_27_ = 10 ^ (n1(tostring1(f)) - 2)
	if 0 == f then
		return unpack1(list1(y, 1), 1, 2)
	else
		local n = y * f_27_
		local g = gcd1(n, f_27_)
		return unpack1(list1((n / g), (f_27_ / g)), 1, 2)
	end
end
normalisedRationalComponents1 = function(x)
	if number_3f_1(x) then
		return _2d3e_ratComponents1(x)
	else
		return unpack1(list1((numerator1(x)), (denominator1(x))), 1, 2)
	end
end
nvim_5f_command1 = vim.api.nvim_command
nvim_5f_call_5f_function1 = vim.api.nvim_call_function
nvim_5f_get_5f_current_5f_buf1 = vim.api.nvim_get_current_buf
nvim_5f_buf_5f_set_5f_var1 = vim.api.nvim_buf_set_var
nvim_5f_buf_5f_add_5f_highlight1 = vim.api.nvim_buf_add_highlight
list_2d3e_struct2 = function(x)
	if list_3f_1(x) then
		x["n"] = nil
		x["tag"] = nil
	end
	return x
end
nvim_5f_call_5f_function_2a_1 = function(...)
	local args = _pack(...) args.tag = "list"
	return nvim_5f_call_5f_function1(car2(args), list_2d3e_struct2(cdr2(args)))
end
echo1 = function(msg)
	return nvim_5f_command1("echo \"" .. msg .. "\"")
end
emit1 = function(msg, hlGroup)
	nvim_5f_command1("echohl " .. hlGroup)
	echo1(msg)
	return nvim_5f_command1("echohl Normal")
end
struct_2d3e_list_2a_1 = function(s)
	return s and struct_2d3e_list1(s)
end
cider_2d2d_abbreviateFileProtocol1 = function(fileWithProtocol)
	local file = match1(fileWithProtocol, "^file:(.*)")
	if file then
		return nvim_5f_call_5f_function_2a_1("fnamemodify", file, ":.")
	else
		return fileWithProtocol
	end
end
infoFile_2d3e_vimFile1 = function(file)
	if nil == file then
		return 0
	elseif match1(file, "^file:(.*)") then
		return nvim_5f_call_5f_function_2a_1("fnamemodify", match1(file, "^file:(.*)"), ":.")
	elseif match1(file, "^jar:file:(.*)") then
		return gsub1(file, "^jar:file:(.*)!/(.*)", "zipfile:%1::%2")
	else
		return 0
	end
end
setLocalOpt1 = function(opt_2a_)
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
end
bufferEcho1 = function(msg)
	return nvim_5f_call_5f_function_2a_1("append", nvim_5f_call_5f_function_2a_1("line", "$") - 1, msg)
end
bufferEmit1 = function(msg, hlGroup)
	local line = nvim_5f_call_5f_function_2a_1("line", "$") - 1
	nvim_5f_call_5f_function_2a_1("append", line, msg)
	return nvim_5f_buf_5f_add_5f_highlight1(nvim_5f_get_5f_current_5f_buf1(), -1, hlGroup, line, 0, len1(msg))
end
docBuffer1 = function(info)
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
	nvim_5f_command1("split " .. ((function()
		local temp
		if class then
			temp = javaName
		else
			temp = cljName
		end
		return temp or "niledout"
	end)() .. ".replantdoc"))
	local temp, list = list1(list1("bufhidden", "hide"), list1("buflisted", false), list1("buftype", "nofile"), list1("foldcolumn", "0"), list1("foldenable", false), list1("number", false), list1("swapfile", false), list1("modifiable", true)), {tag="list", n=0}
	local yield = function(val)
		if val ~= nil then
			return pushCdr_21_1(list, val)
		else
			return nil
		end
	end
	local temp1 = n1(temp)
	local temp2 = 1
	while temp2 <= temp1 do
		yield(setLocalOpt1((temp[temp2])))
		temp2 = temp2 + 1
	end
	nvim_5f_command1("%delete _")
	nvim_5f_command1("resize 20")
	bufferEmit1((function()
		if class then
			return javaName
		else
			return cljName
		end
	end)(), (function()
		if macro then
			return "Macro"
		elseif special then
			return "Special"
		elseif args then
			return "Function"
		elseif class then
			return "StorageClass"
		elseif ns and name then
			return "Macro"
		else
			return "Error"
		end
	end)())
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
			bufferEcho1(" " .. (forms1[temp1]))
			temp1 = temp1 + 1
		end
	end
	if special then
		bufferEcho1("Special Form")
	end
	if macro then
		bufferEcho1("Macro")
	end
	if added then
		bufferEmit1("Added in " .. added, "Comment")
	end
	if depr then
		bufferEmit1("Deprecated in " .. depr, "Error")
	end
	bufferEcho1((list_2d3e_struct1(split1("  " .. doc, "\n"))))
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
	local amicrazy = infoFile_2d3e_vimFile1(file)
	nvim_5f_buf_5f_set_5f_var1(nvim_5f_get_5f_current_5f_buf1(), "replant_jump_file", amicrazy)
	nvim_5f_buf_5f_set_5f_var1(nvim_5f_get_5f_current_5f_buf1(), "replant_jump_line", info["line"])
	nvim_5f_buf_5f_set_5f_var1(nvim_5f_get_5f_current_5f_buf1(), "replant_jump_column", info["column"])
	if seeAlso then
		bufferEcho1(list_2d3e_struct1(list1("", "Also see: " .. concat1(seeAlso, " "))))
	end
	return setLocalOpt1(list1("modifiable", false))
end
doc1 = function(info)
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
end
return {["doc"]=doc1, ["buffer_emit"]=bufferEmit1, ["buffer_doc"]=docBuffer1, ["info-file->vim-file"]=infoFile_2d3e_vimFile1}

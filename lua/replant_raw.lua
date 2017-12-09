local X = {}

function literalize(str)
    return str:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", function(c) return "%" .. c end)
end

function X.find_relpath (classpath, abspath)
    for idx,val in ipairs(classpath) do
	relpath,matches = string.gsub(abspath, '^' .. literalize(val), "")

	if matches == 1 then
	    x,_ = relpath:gsub("^/", "")
	    return x
	end
    end
end

function X.path_to_ns(extensionless_path)
    return extensionless_path:gsub("[_/]", {["_"] = "-", ["/"] = "."})
end

return X

strman = {};

strman.Words = {["a"]=true, ["b"]=true, ["c"]=true, ["d"]=true, ["e"]=true, ["f"]=true, 
				["g"]=true, ["h"]=true, ["i"]=true, ["j"]=true, ["k"]=true, ["l"]=true, 
				["m"]=true, ["n"]=true, ["o"]=true, ["p"]=true, ["q"]=true, ["r"]=true,
				["s"]=true, ["t"]=true, ["u"]=true, ["v"]=true, ["w"]=true, ["x"]=true,
				["y"]=true, ["z"]=true,
				["A"]=true, ["B"]=true, ["C"]=true, ["D"]=true, ["E"]=true, ["F"]=true, 
				["G"]=true, ["H"]=true, ["I"]=true, ["J"]=true, ["K"]=true, ["L"]=true, 
				["M"]=true, ["N"]=true, ["O"]=true, ["P"]=true, ["Q"]=true, ["R"]=true,
				["S"]=true, ["T"]=true, ["U"]=true, ["V"]=true, ["W"]=true, ["X"]=true,
				["Y"]=true, ["Z"]=true};

strman.str2table = function (str)
     local t = {};
     local len  = string.len(str);
     local arr  = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc};
     local j = 0;
     for i=1,len do
     	if i > j then
	     	local c = string.byte(str, i);
	     	local offset = 1;
	        if c < 0xc0 then
	            offset = 1;
	        elseif c < 0xe0 then
	            offset = 2;
	        elseif c < 0xf0 then
	            offset = 3;
	        elseif c < 0xf8 then
	            offset = 4;
	        elseif c < 0xfc then
	            offset = 5;
	        end
			t[#t+1] = string.sub(str, i, i+offset-1);
			j = i+offset-1;
		end
     end
     return t;
end

strman.split = function (s, p)
    local t = strman.str2table(s);
    if '' == p then
    	return t;
    end
    local np = strman.str2table(p);
    local nt = {};
    local ts = '';

	ignore = 0;
    for i=1,#t do
    	if i > ignore then
    		local same = true;
	    	for j=1,#np do
	    		local index = i+j-1;
	    		if t[index] ~= np[j] then
	    			same = false;
	    		end
	    	end
	    	if same then
	    		nt[#nt+1] = ts;
	    		ts = '';
	    		ignore = i+#np-1;
	    	else
	    		ts = ts .. t[i];
	    	end
    	end
    end
    nt[#nt+1] = ts;
    return nt;
end

strman.chars = function (value)
	return strman.split(value, '');
end

strman.substr = function (value, start, length)
	local t = strman.str2table(value);
 	local ns = '';
 	local e = start + length - 1;
 	for i=1,#t do
 		if i < start then
 		elseif i > e then
 			return ns;
 		else
 			ns = ns .. t[i];
 		end
 	end
 	return ns;
end

strman.toUpperCase = function (value)
	return string.upper(value);
end

strman.startsWith = function (value, search)
	local len = #strman.str2table(search);
	return strman.substr(value, 1, len) == search;
end

strman.append = function ( ... )
	local arg = {...};
	local ns = '';
	for i=1,#arg do
		ns = ns .. arg[i];
	end
	return ns;
end

strman.ensureleft = function (value, substr)
	return strman.append(substr, value);
end

strman.inequal = function (stringA, stringB)
	return stringA ~= stringB;
end

strman.surround = function (value, left, right)
	return strman.append(left, value, right);
end

strman.truncate = function (value, length, substr)
	if nil == substr then
		substr = '';
	end
	local ns = strman.substr(value, 1, length);
	return strman.append(ns, substr);
end

strman.replace = function (value, stra, strb)
	local t = strman.split(value, stra);
	local ns = '';
	local len = #t-1;
	for i=1,len do
		ns = ns .. t[i] .. strb;
	end
	ns = ns .. t[#t];
	return ns;
end

strman.leftTrim = function (value)
	local t = strman.str2table(value);
	for i=1,#t do
		if ' ' ~= t[i] then
			return 	strman.substr(value, i, #t);
		end
	end
	return '';
end

strman.rightTrim = function (value)
	local t = strman.str2table(value);
	for i=#t,1,-1 do
		if ' ' ~= t[i] then
			return 	strman.substr(value, 1, i);
		end
	end
	return '';
end

strman.trim = function (value)
	return strman.leftTrim(strman.rightTrim(value))
end

strman.collapseWhitespace = function (value)
	local t = strman.str2table(value);
	local s = '';
	for i=1,#t do
		if ' ' ~= t[i] then
			s = s .. t[i];
		end
	end
	return s;
end

strman.indexOf = function (value, needle)
	local t = strman.str2table(value);
    local np = strman.str2table(needle);

    for i=1,#t do
    	local same = true;
    	for j=1,#np do
    		local index = i+j-1;
    		if t[index] ~= np[j] then
    			same = false;
    		end
    	end
    	if same then
    		return i;
    	end
    end
    return -1;
end

strman.isInteger = function (value)
	return tonumber(value) ~= nil;
end

strman.endsWith = function (value, search)
	local t = strman.str2table(value);
	local np = strman.str2table(search);
	for i=0,#np-1 do
		if np[#np-i] ~= t[#t-i] then
			return false;
		end
	end
	return true;
end

strman.ensureright = function (value, substr)
	return strman.append(value, substr);
end

strman.insert = function (value, substr, index)
	local t = strman.str2table(value);
	local ns = '';
	for i=1,#t do
		if i == index then
			ns = ns .. substr .. t[i];
		else
			ns = ns .. t[i];
		end
	end
	return ns;
end

strman.toLowerCase = function (value)
	return string.lower(value);
end

strman.equal = function (stringA, stringB)
	return stringA == stringB;
end

strman.compare = function (stringA, stringB)
	if stringA == stringB then
		return 0;
	end
	if stringA > stringB then
		return 1;
	end
	return -1;
end

strman.isLowerCase = function (value)
	return value == strman.toLowerCase(value);
end

strman.removeEmptyStrings = function ( ... )
	local t = {...};
	local s = '';
	for i=1,#t do
		if " " == t[i] or '' == t[i] or nil == t[i] then
		else
			s = s .. t[i];
		end
	end
	return s;
end

strman.param2table = function ( ... )
	return {...};
end

strman.lastIndexOf = function (value, needle)
	local t = strman.str2table(value);
    local np = strman.str2table(needle);

    for i=#t,1,-1 do
    	local same = true;
    	for j=1,#np do
    		local index = i-j+1;
    		if t[index] ~= np[#np-j+1] then
    			same = false;
    		end
    	end
    	if same then
    		return i-#np+1;
    	end
    end
    return -1;
end

strman.contains = function (value, needle)
	local index = strman.indexOf(value, needle);
	return index > -1;
end

strman.first = function (value, n)
	return strman.substr(value, 1, n);
end

strman.isString = function (value)
	if strman.isInteger(value) then
		return false;
	end

	return type(value) == "string";
end

strman.removeLeft = function (value, prefix)
	local t = strman.str2table(prefix);
	local vt = strman.str2table(value);
	return strman.substr(value, #t+1, #vt);
end

strman.at = function(value, index)
	local t = strman.str2table(value);
	return t[index];
end

strman.containsAll = function (value, needles)
	for i=1,#needles do
		if not strman.contains(value, needles[i]) then
			return false;
		end
	end
	return true;
end

strman.format = string.format;

strman.isUpperCase = function (value)
	return value == strman.toUpperCase(value);
end

strman.removeNoWords = function(value)
	local t = strman.str2table(value);
	local nt = {};
	for i=1,#t do
		if strman.Words[t[i]] == true then
			nt[#nt+1] = t[i];
		end
	end
	return table.concat(nt);
end

return strman;
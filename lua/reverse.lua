--[[
reverse_lookup_filter: 依地球拼音为候选项加上带调拼音的注释

本例说明了环境的用法。
--]]

-- 帮助函数（可跳过）
local function xform_py(inp)
   if inp == "" then return "" end
   -- inp = string.gsub(inp, "([aeiou])(ng?)([1234])", "%1%3%2")
   -- inp = string.gsub(inp, "([aeiou])(r)([1234])", "%1%3%2")
   -- inp = string.gsub(inp, "([aeo])([iuo])([1234])", "%1%3%2")
   -- inp = string.gsub(inp, "a1", "ā")
   -- inp = string.gsub(inp, "a2", "á")
   -- inp = string.gsub(inp, "a3", "ǎ")
   -- inp = string.gsub(inp, "a4", "à")
   -- inp = string.gsub(inp, "e1", "ē")
   -- inp = string.gsub(inp, "e2", "é")
   -- inp = string.gsub(inp, "e3", "ě")
   -- inp = string.gsub(inp, "e4", "è")
   -- inp = string.gsub(inp, "o1", "ō")
   -- inp = string.gsub(inp, "o2", "ó")
   -- inp = string.gsub(inp, "o3", "ǒ")
   -- inp = string.gsub(inp, "o4", "ò")
   -- inp = string.gsub(inp, "i1", "ī")
   -- inp = string.gsub(inp, "i2", "í")
   -- inp = string.gsub(inp, "i3", "ǐ")
   -- inp = string.gsub(inp, "i4", "ì")
   -- inp = string.gsub(inp, "u1", "ū")
   -- inp = string.gsub(inp, "u2", "ú")
   -- inp = string.gsub(inp, "u3", "ǔ")
   -- inp = string.gsub(inp, "u4", "ù")
   -- inp = string.gsub(inp, "v1", "ǖ")
   -- inp = string.gsub(inp, "v2", "ǘ")
   -- inp = string.gsub(inp, "v3", "ǚ")
   -- inp = string.gsub(inp, "v4", "ǜ")
   -- inp = string.gsub(inp, "([nljqxy])v", "%1ü")
   -- inp = string.gsub(inp, "eh[0-5]?", "ê")
   return inp
end

local function reverse_lookup_filter(input, pydb)
   for cand in input:iter() do
      local cur_comment = ""
      local offset_list = {}
      for i = 1, utf8.len(cand.text) do
        local offset = utf8.offset(cand.text, i)
        table.insert(offset_list, offset)
      end
      table.insert(offset_list, #cand.text + 1)
      local i = 1
      while i < #offset_list do
        local cur_offset_start = offset_list[i]
        local best_j = i + i
        local best_comment = ""
        for j = i + 1, #offset_list do
          local cur_offset_end = offset_list[j] - 1
          local cur_char = string.sub(cand.text, cur_offset_start, cur_offset_end)
          local cur_comment = xform_py(pydb:lookup(cur_char))
          if cur_comment ~= "" then
            best_j = j
            best_comment = cur_comment
          end
        end
        cur_comment = cur_comment .. best_comment
        i = best_j
        if best_j < #offset_list then
          cur_comment = cur_comment .. "|"
        end
      end
      cand:get_genuine().comment = cand.comment .. " " .. cur_comment
      yield(cand)
      --cand:get_genuine().comment = cand.comment .. " " .. xform_py(pydb:lookup(cand.text))
      --yield(cand)
   end
end


-- function dump(o)
--    if type(o) == 'table' then
--       local s = '{ '
--       for k,v in pairs(o) do
--          if type(k) ~= 'number' then k = '"'..k..'"' end
--          s = s .. '['..k..'] = ' .. dump(v) .. ','
--       end
--       return s .. '} '
--    else
--       return tostring(o)
--    end
-- end

-- function lookup_word(x)
--   if x == "大家" then
--     return "daai6gaa1"
--   end
--   if x == "大" then
--     return "daai6"
--   end
--   if x == "家" then
--     return "gaa1"
--   end
--   if x == "好" then
--     return "hou2"
--   end
--   return ""
-- end

-- cand = {}
-- cand.text = "大家好"

-- local cur_comment = ""
-- local offset_list = {}
-- for i = 1, utf8.len(cand.text) do
--   local offset = utf8.offset(cand.text, i)
--   table.insert(offset_list, offset)
-- end
-- table.insert(offset_list, #cand.text + 1)
-- local i = 1
-- while i < #offset_list do
--   local cur_offset_start = offset_list[i]
--   local best_j = i + i
--   local best_comment = ""
--   for j = i + 1, #offset_list do
--     local cur_offset_end = offset_list[j] - 1
--     local cur_char = string.sub(cand.text, cur_offset_start, cur_offset_end)
--     local cur_comment = lookup_word(cur_char)
--     if cur_comment ~= "" then
--       best_j = j
--       best_comment = cur_comment
--     end
--   end
--   print(best_comment)
--   cur_comment = cur_comment .. best_comment
--   i = best_j
--   if best_j < #offset_list then
--     cur_comment = cur_comment .. "|"
--   end
-- end

-- print(cur_comment)



-- local function reverse_lookup_filter(input, pydb)
--    for cand in input:iter() do
--       local cur_comment = xform_py(pydb:lookup(cand.text))
--       if cur_comment == "" then
--          local offset_list = {}
--          for i = 1, utf8.len(cand.text) do
--             local offset = utf8.offset(cand.text, i)
--             table.insert(offset_list, offset)
--          end
--          local prev_offset_start = 1
--          for i = 1, #offset_list do
--             local cur_offset_start = offset_list[i]
--             local cur_char = string.sub(cand.text, prev_offset_start, cur_offset_start - 1)
--             if i ~= 1 then
--                prev_offset_start = cur_offset_start
--                cur_comment = cur_comment .. "/" .. xform_py(pydb:lookup(cur_char))
--             end
--             -- cur_comment = cur_comment .. "/" .. xform_py(pydb:lookup(cur_char))
--          end
--          local cur_char = string.sub(cand.text, prev_offset_start)
--          cur_comment = cur_comment .. "/" .. xform_py(pydb:lookup(cur_char))
--       end
--       cand:get_genuine().comment = cand.comment .. " " .. cur_comment
--       yield(cand)
--       --cand:get_genuine().comment = cand.comment .. " " .. xform_py(pydb:lookup(cand.text))
--       --yield(cand)
--    end
-- end

-- local function reverse_lookup_filter(input, pydb)
--    for cand in input:iter() do
--       local cur_comment = xform_py(pydb:lookup(cand.text))
--       if cur_comment == ""
--       then
--          for _, c in utf8.codes(cand.text) do
--             local cur_char = utf8.char(c)
--             cur_comment = cur_comment .. "/" .. xform_py(pydb:lookup(cur_char))
--          end
--       end
--       cand:get_genuine().comment = cand.comment .. " " .. cur_comment
--       yield(cand)
--       --cand:get_genuine().comment = cand.comment .. " " .. xform_py(pydb:lookup(cand.text))
--       --yield(cand)
--    end
-- end

--[[
如下，filter 除 `input` 外，可以有第二个参数 `env`。
--]]
local function filter(input, env)
   --[[ 从 `env` 中拿到拼音的反查库 `pydb`。
        `env` 是一个表，默认的属性有（本例没有使用）：
          - engine: 输入法引擎对象
          - name_space: 当前组件的实例名
        `env` 还可以添加其他的属性，如本例的 `pydb`。
   --]]
   reverse_lookup_filter(input, env.pydb)
end

--[[
当需要在 `env` 中加入非默认的属性时，可以定义一个 init 函数对其初始化。
--]]
local function init(env)
   -- 当此组件被载入时，打开反查库，并存入 `pydb` 中
   env.pydb = ReverseDb("build/jyut6ping3_tradsimp_nospaces.reverse.bin")
end

--[[ 导出带环境初始化的组件。
需要两个属性：
 - init: 指向初始化函数
 - func: 指向实际函数
--]]
return { init = init, func = filter }
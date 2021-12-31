local Cache = require "Cache"

local class = require "class"

local type = type
local ipairs = ipairs
local select = select
local assert = assert

local Redisearch = class("Redisearch")

function Redisearch:ctor(opt)
  self.redis = Cache:new(opt)
end

function Redisearch:connect()
  return self.redis:connect()
end

---comment @查看全文索引的内部信息
---@param idxname string @全文索引名称
---@return table         @查询结果`table`
function Redisearch:info(idxname)
  idxname = assert(type(idxname) == 'string' and idxname ~= '' and idxname, "Invalid `FT.INFO` index name.")
  local ok, info = self.redis['FT.INFO'](self.redis, idxname)
  if not ok then
    return false, info
  end
  local response = {}
  for i = 1, #info, 2 do
    response[info[i]] = info[i+1]
  end
  return response
end

---comment @插入文档
---@param idxname string @全文索引名称
function Redisearch:add(idxname)

end

---comment @获取指定文档结构
---@param idxname string @全文索引名称
---@param docid   string @全文索引名称
---@return table         @查询结果`table`
function Redisearch:get(idxname, docid)
  idxname = assert(type(idxname) == 'string' and idxname ~= '' and idxname, "Invalid `FT.GET` index name.")
  docid = assert(type(docid) == 'string' and docid ~= '' and docid, "Invalid `FT.GET` doc id.")
  local ok, info = self.redis['FT.GET'](self.redis, idxname, docid)
  if not ok then
    return false, info
  end
  local response = {}
  for i = 1, #info, 2 do
    response[info[i]] = info[i+1]
  end
  return response
end

---comment @获取多个指定文档结构
---@param idxname string @全文索引名称
---@return table         @查询结果`table`
function Redisearch:mget(idxname, ...)
  idxname = assert(type(idxname) == 'string' and idxname ~= '' and idxname, "Invalid `FT.GET` index name.")
  assert(select("#", ...) > 0, "Invalid `FT.GET` Invalid number of `docid` parameters .")
  local ok, info = self.redis['FT.MGET'](self.redis, idxname, ...)
  if not ok then
    return false, info
  end
  local response = {}
  for _, name in ipairs({...}) do
    local item = {}
    for i = 1, #info do
      local list = info[i]
      for j = 1, #list, 2 do
        item[list[j]] = list[j + 1]
      end
    end
    response[name] = item
  end
  return response
end

---comment @创建索引
---@param opt table @配置表
function Redisearch:create_index(opt)
  -- if type(opt) ~= 'table' then
  --   opt = {}
  -- end
  -- local ok, info = self.redis['FT.CREATE'](self.redis, opt.name)
  -- if not ok then
  --   return false, info
  -- end
  -- return true
end

return Redisearch

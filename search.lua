-- local Cache = require "Cache"

-- local class = require "class"

-- local type = type
-- local ipairs = ipairs
-- local select = select
-- local assert = assert

-- local tunpack = table.unpack

-- local Redisearch = class("Redisearch")

-- function Redisearch:ctor(opt)
--   self.redis = Cache:new(opt)
-- end

-- ---comment @连接到服务
-- function Redisearch:connect()
--   return self.redis:connect()
-- end

-- ---comment @查看全文索引的内部信息
-- ---@param idxname string @全文索引名称
-- ---@return table         @查询结果`table`
-- function Redisearch:info(idxname)
--   idxname = assert(type(idxname) == 'string' and idxname ~= '' and idxname, "Invalid `FT.INFO` index name.")
--   local ok, info = self.redis['FT.INFO'](self.redis, idxname)
--   if not ok then
--     return false, info
--   end
--   local response = {}
--   for i = 1, #info, 2 do
--     local key, value = info[i], info[i+1]
--     if type(value) == 'table' then
--       if #value & 1 == 0 then
--         local item = {}
--         for idx = 1, #value, 2 do
--           item[value[idx]] = value[idx+1]
--         end
--         value = item
--       end
--     end
--     response[key] = value
--   end
--   return response
-- end

-- ---comment @全文检索
-- ---@param idxname string @全文索引名称
-- ---@param query   string @查询语句
-- ---@param option  table  @可选的参数
-- function Redisearch:search(idxname, query, option)
--   idxname = assert(type(idxname) == 'string' and idxname ~= '' and idxname, "Invalid `FT.SEARCH` index name.")
--   query = assert(type(query) == 'string' and query ~= '' and query, "Invalid `FT.SEARCH` query syntax.")
--   local options = {}
--   local ok, info = self.redis['FT.SEARCH'](self.redis, idxname, query, tunpack(options))
--   if not ok then
--     return false, info
--   end
--   return info
-- end

-- ---comment @获取指定文档结构
-- ---@param idxname string @全文索引名称
-- ---@param docid   string @全文索引名称
-- ---@return table         @查询结果`table`
-- function Redisearch:get(idxname, docid)
--   idxname = assert(type(idxname) == 'string' and idxname ~= '' and idxname, "Invalid `FT.GET` index name.")
--   docid = assert(type(docid) == 'string' and docid ~= '' and docid, "Invalid `FT.GET` doc id.")
--   local ok, info = self.redis['FT.GET'](self.redis, idxname, docid)
--   if not ok or not info then
--     return false, info or "Invalid `docid`"
--   end
--   local response = {}
--   for i = 1, #info, 2 do
--     response[info[i]] = info[i+1]
--   end
--   return response
-- end

-- ---comment @获取多个指定文档结构
-- ---@param idxname string @全文索引名称
-- ---@return table         @查询结果`table`
-- function Redisearch:mget(idxname, ...)
--   idxname = assert(type(idxname) == 'string' and idxname ~= '' and idxname, "Invalid `FT.MGET` index name.")
--   assert(select("#", ...) > 0, "Invalid `FT.MGET` Invalid number of `docid` parameters .")
--   local ok, info = self.redis['FT.MGET'](self.redis, idxname, ...)
--   if not ok then
--     return false, info
--   end
--   local response = {}
--   for _, name in ipairs({...}) do
--     local item = {}
--     for i = 1, #info do
--       local list = info[i]
--       for j = 1, #list, 2 do
--         item[list[j]] = list[j + 1]
--       end
--     end
--     response[name] = item
--   end
--   return response
-- end

-- ---comment @创建索引
-- ---@param idxname string @索引名称
-- ---@param opt     table  @配置表
-- function Redisearch:create_index(idxname, opt)
--   if type(opt) ~= 'table' then
--     opt = { ON = "HASH", LANGUAGE = ""}
--   end
--   idxname = assert(type(idxname) == 'string' and idxname ~= '' and idxname, "Invalid `FT.CREATE` index name.")
--   local ok, info = self.redis['FT.CREATE'](self.redis, opt.name, "SCHEMA")
--   if not ok then
--     return false, info
--   end
--   return true
-- end

-- ---comment @删除索引
-- ---@param idxname string @索引名称
-- function Redisearch:drop(idxname)
--   idxname = assert(type(idxname) == 'string' and idxname ~= '' and idxname, "Invalid `FT.MGET` index name.")
--   local ok, info = self.redis['FT.DROPINDEX'](self.redis, idxname)
--   if not ok then
--     return false, info
--   end
--   return true
-- end

-- return Redisearch

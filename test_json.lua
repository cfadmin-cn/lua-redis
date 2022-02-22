local LOG = require"logging"
local json = require "json"
local RDJSON = require "lua-redis.json"

local o = RDJSON:new{
  host = "localhost", port = 6666
}

o:connect()

-- 创建2个文档.
LOG:DEBUG(o:create("doc1", json.encode{ a = 1, b = 0.1, c = "Maria", d = {1, 2, 3}}))
LOG:DEBUG(o:create("doc2", json.encode{ a = 2, b = 0.2, c = "Vivian", d = {10, 20, 30}}))

-- 补充字段
LOG:DEBUG(o:set("doc1", "g", "100"))
LOG:DEBUG(o:set("doc2", "g", 200))

-- 弹出数组内容
LOG:DEBUG(o:arrpop("doc1", ".d"))
LOG:DEBUG(o:arrpop("doc2", ".d"))

-- 弹出数组内容
LOG:DEBUG(o:arrpop("doc1", ".d"))
LOG:DEBUG(o:arrpop("doc2", ".d"))

-- 获取字符串字段长度
LOG:DEBUG(o:strlen("doc1", ".c"))
LOG:DEBUG(o:strlen("doc2", ".c"))

-- 批量获取文档的指定字段内容
LOG:DEBUG(o:get("doc1", ".c"), o:get("doc2", ".c"))
LOG:DEBUG(o:mget("doc1", "doc2", ".c"))

-- 查询字段所属类型
LOG:DEBUG(o:type("doc1", "$.a"), o:type("doc1", "$.b"), o:type("doc1", "$.c"))
LOG:DEBUG(o:type("doc2", "$.a"), o:type("doc2", "$.b"), o:type("doc2", "$.c"))

-- 单个/批量追加匹配字段名的内容
LOG:DEBUG(o:strappend("doc1", "$..c", '"! nice to meet you."'))
LOG:DEBUG(o:strappend("doc2", "$..c", '"! nice to meet you."'))

-- 查询所有字段名
LOG:DEBUG(o:objkeys("doc1", "."))
LOG:DEBUG(o:objkeys("doc2", "."))

-- 查询对象长度
LOG:DEBUG(o:objlen("doc1", "."))
LOG:DEBUG(o:objlen("doc2", "."))

-- 删除文档
LOG:DEBUG(o:remove("doc1"))
LOG:DEBUG(o:remove("doc2"))
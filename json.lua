local Cache = require "Cache"

local class = require "class"

local type = type
local assert = assert

local RedisJSON = class("RedisJSON")

function RedisJSON:ctor(opt)
  self.redis = Cache:new(opt)
end

---comment @连接到服务
function RedisJSON:connect()
  return self.redis:connect()
end

---comment 创建文档
---@param name  string @文档名
---@param json  string @文档内容
---@return boolean @成功返回`true`, 失败返回原因.
function RedisJSON:create(name, json)
  assert(type(name) == 'string', "Invalid document name.")
  return self.redis['JSON.SET'](self.redis, name, '.', json or "{}")
end

---comment 删除文档
---@param name  string @文档名
---@return boolean     @成功返回`true`, 失败返回`false`与失败原因.
function RedisJSON:remove(name)
  assert(type(name) == 'string', "Invalid document name.")
  local ok, num = self.redis['del'](self.redis, name)
  return (ok and num == 1) and true or false
end

---comment 清空指定文档对象/数组
---@param name  string @文档名
---@param path  string @路径/字段名
function RedisJSON:clear(name, path)
  assert(type(name) == 'string', "Invalid document name.")
  assert(type(path) == 'string', "Invalid document path.")
  return self.redis['JSON.CLEAR'](self.redis, name, path)
end

---comment 检查字段类型
---@param name  string @文档名
---@param path  string @路径/字段名
---@return boolean     @成功返回`string`类型, 失败返回`false`与失败原因.
function RedisJSON:type(name, path)
  assert(type(name) == 'string', "Invalid document name.")
  local ok, info = self.redis['JSON.TYPE'](self.redis, name, path)
  if not ok then
    return false, info
  end
  return info or 'nil'
end

---comment 获取`string`字段的长度
---@param name  string @文档名
---@param path  string @路径/字段名
---@return boolean     @成功返回`string`类型长度, 失败返回`false`与失败原因.
function RedisJSON:strlen(name, path)
  assert(type(name) == 'string', "Invalid document name.")
  local ok, info = self.redis['JSON.STRLEN'](self.redis, name, path)
  if not ok then
    return false, info
  end
  if not info then
    return false, "Cant't find `" .. name .. '` and `' .. path .. '`'
  end
  return info
end

---comment 获取`string`字段的长度
---@param name  string @文档名
---@param path  string @路径/字段名
---@param value string @待追加内容
function RedisJSON:strappend(name, path, value)
  assert(type(name) == 'string', "Invalid document name.")
  assert(type(path) == 'string', "Invalid document path.")
  assert(type(value) == 'string', "Invalid document value.")
  return self.redis['JSON.STRAPPEND'](self.redis, name, path, value)
end

---comment 写入字段
---@param name  string @文档名
---@param path  string @路径/字段名
---@param value string @待写入内容
---@return boolean     @成功返回`true`, 失败返回原因.
function RedisJSON:set(name, path, value)
  assert(type(name) == 'string', "Invalid document name.")
  assert(type(path) == 'string', "Invalid document path.")
  return self.redis['JSON.SET'](self.redis, name, path, type(value) == 'number' and value or ('"' .. value .. '"'))
end

---comment 获取指定字段内容
---@param name  string @文档名
---@param path  string @路径/字段名
---@return boolean | string @失败返回`nil`, 成功返回`string`.
function RedisJSON:get(name, path, ...)
  assert(type(name) == 'string', "Invalid document name.")
  assert(type(path) == 'string', "Invalid document path.")
  local ok, info = self.redis['JSON.GET'](self.redis, name, path, ...)
  if not ok then
    return false, info
  end
  return info
end

---comment 获取多个文档指定字段内容
---@param name1 string @文档名1
---@param name2 string @文档名2
---@param ...   string @`1`或`N`个文档名, 最后一个参数始终是路径或字段名.
---@return boolean | table @失败返回`nil`, 成功返回`table`(数组).
function RedisJSON:mget(name1, name2, ...)
  assert(type(name1) == 'string', "Invalid document name.")
  local ok, info = self.redis['JSON.MGET'](self.redis, name1, name2, ...)
  if not ok then
    return false, info
  end
  return info
end

---comment 为`1`或`N`个字段做递增操作.
---@param name  string @文档名
---@param path  string @路径/字段名
---@param num   string @待写入内容
function RedisJSON:numincrby(name, path, num)
  assert(type(name) == 'string', "Invalid document name.")
  assert(type(path) == 'string', "Invalid document path.")
  local ok, info = self.redis['JSON.NUMINCRBY'](self.redis, name, path, num)
  if not ok then
    return false, info
  end
  return info
end

---comment 获取`path`下的所有字段名
---@param name  string @文档名
---@param path  string @路径/字段名
function RedisJSON:objkeys(name, path)
  assert(type(name) == 'string', "Invalid document name.")
  local ok, info = self.redis['JSON.OBJKEYS'](self.redis, name, path or '.')
  if not ok then
    return false, info
  end
  return info
end

---comment 计算`path`下的字段数量
---@param name  string @文档名
---@param path  string @路径/字段名
function RedisJSON:objlen(name, path)
  assert(type(name) == 'string', "Invalid document name.")
  local ok, info = self.redis['JSON.OBJLEN'](self.redis, name, path)
  if not ok then
    return false, info
  end
  return info
end

---comment 计算`path`下的数组长度
---@param name  string @文档名
---@param path  string @路径/字段名
function RedisJSON:arrlen(name, path)
  assert(type(name) == 'string', "Invalid document name.")
  assert(type(path) == 'string', "Invalid document path.")
  local ok, info = self.redis['JSON.ARRLEN'](self.redis, name, path)
  if not ok then
    return false, info
  end
  return info
end

---comment 弹出数组字段下的最后一个值
---@param name  string @文档名
---@param path  string @路径/字段名
function RedisJSON:arrpop(name, path, ...)
  assert(type(name) == 'string', "Invalid document name.")
  assert(type(path) == 'string', "Invalid document path.")
  local ok, info = self.redis['JSON.ARRPOP'](self.redis, name, path, ...)
  if not ok then
    return false, info
  end
  return info
end

---comment 删除数组指定下标之外的所有元素
---@param name  string  @文档名
---@param path  string  @路径/字段名
---@param start integer @起始下标(默认为`1`)
---@param stop  integer @结束下标(默认为`1`)
function RedisJSON:arrtrim(name, path, start, stop)
  assert(type(name) == 'string', "Invalid document name.")
  assert(type(path) == 'string', "Invalid document path.")
  local ok, info = self.redis['JSON.ARRTRIM'](self.redis, name, path, start or 0, stop or -1)
  if not ok then
    return false, info
  end
  return info
end

---comment 删除数组指定下标之外的所有元素
---@param name  string  @文档名
---@param path  string  @路径/字段名
---@param index integer @数组索引下标
function RedisJSON:arrinsert(name, path, index, ...)
  assert(type(name) == 'string', "Invalid document name.")
  assert(type(path) == 'string', "Invalid document path.")
  local ok, info = self.redis['JSON.ARRTRIM'](self.redis, name, path, ...)
  if not ok then
    return false, info
  end
  return info
end

return RedisJSON
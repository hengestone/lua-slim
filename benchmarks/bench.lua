require "socket"
require "haml"

local template = [=[
!!! html
%html
  %head
    %title Test
  %body
    %h1 simple markup
    %div#content
]=]

local start = socket.gettime()
for i = 1,1000 do
  local html = haml.render(template)
end
local done = socket.gettime()

print "Uncached:"
print(("%s seconds"):format(done - start))


local haml_parser      = require "haml.parser"
local haml_precompiler = require "haml.precompiler"
local haml_renderer    = require "haml.renderer"

local start = socket.gettime()

local phrases     = haml_parser.tokenize(template)
local precompiler = haml_precompiler.new({})
local compiled    = precompiler:precompile(phrases)
local renderer    = haml_renderer.new({}, {})

for i = 1,1000 do
  renderer:render(compiled)
end
local done = socket.gettime()

print "Cached:"
print(("%s seconds"):format(done - start))

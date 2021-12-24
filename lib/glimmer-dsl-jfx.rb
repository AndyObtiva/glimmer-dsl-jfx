# Copyright (c) 2021 Andy Maleh
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

$LOAD_PATH.unshift(File.expand_path('.', __dir__))

# External requires
# require 'logging'
require 'puts_debuggerer' if ENV['pd'].to_s.downcase == 'true'
require 'nested_inherited_jruby_include_package'
# require 'super_module'
require 'java'
require 'concurrent-ruby' # ensures glimmer relies on Concurrent data-structure classes (e.g. Concurrent::Array)
require 'glimmer'
require 'os'
require 'array_include_methods'
require 'facets/string/underscore'
require 'facets/string/camelcase'
require 'facets/hash/stringify_keys'

jfx_lib_directory = ENV['PATH_TO_FX']
jfx_jar_files = Dir.glob(File.join(jfx_lib_directory.to_s, '*.jar')).to_a
if jfx_jar_files.empty?
  raise 'The PATH_TO_FX environment variable is not set to a valid JavaFX SDK lib directory for your platform and CPU architeture. Make sure to download the right JavaFX SDK for your platform and CPU architecture from https://gluonhq.com/products/javafx/ and then set the PATH_TO_FX environment variable to the location of the lib directory in the extracted SDK directory.'
else
  jfx_jar_files.each { |jar_file| require jar_file }
  # Internal requires
  require 'glimmer/jfx'
  require 'glimmer/jfx/ext/glimmer'
  require 'glimmer/jfx/ext/glimmer/config'
  require 'glimmer/dsl/jfx/dsl'
end

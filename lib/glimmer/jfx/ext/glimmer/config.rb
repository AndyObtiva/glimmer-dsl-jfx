# Copyright (c) 2007-2021 Andy Maleh
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

require 'glimmer/config'

module Glimmer
  module Config
    DEFAULT_IMPORT_JAVA_PACKAGES = %w[
      javafx.scene.chart
      javafx.scene.control
      javafx.scene.control.cell
      javafx.scene.control.skin
      javafx.animation
      javafx.application
      javafx.concurrent
      javafx.css
      javafx.css.converter
      javafx.geometry
      javafx.print
      javafx.scene
      javafx.scene.canvas
      javafx.scene.effect
      javafx.scene.image
      javafx.scene.input
      javafx.scene.layout
      javafx.scene.paint
      javafx.scene.robot
      javafx.scene.shape
      javafx.scene.text
      javafx.scene.transform
      javafx.stage
      javafx.scene.media
      javafx.embed.swing
      javafx.scene.web
    ]
    
    class << self
      # Tells Glimmer to import Java packages into including class (default: true)
      def import_java_packages=(value)
        @@import_java_packages = value
      end
  
      # Returns whether Glimmer will import SWT packages into including class
      def import_java_packages
        @@import_java_packages = DEFAULT_IMPORT_JAVA_PACKAGES if !defined?(@@import_java_packages) || (defined?(@@import_java_packages) && @@import_java_packages == true)
        @@import_java_packages
      end
      
    end
    
  end
  
end

Glimmer::Config.excluded_keyword_checkers << lambda do |method_symbol, *args|
  method = method_symbol.to_s
  result = false
  return true if method == 'load_iseq'
  return true if method == 'post_initialize_child'
  return true if method == 'handle'
  return true if method.end_with?('=')
end

Glimmer::Config.loop_max_count = 300

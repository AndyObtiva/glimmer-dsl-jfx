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

require 'glimmer/jfx/packages'

module Glimmer
  module JFX
    # Proxy for JavaFX control objects
    #
    # Follows the Proxy Design Pattern
    class ControlProxy
      include Packages

      class << self
        include Packages
        
        def exist?(keyword)
          !!control_class(keyword)
        end
        
        def create(parent, keyword, *args, &block)
          control_proxy_class(keyword).new(parent, keyword, *args, &block)
        end
        
        def control_proxy_class(keyword)
          begin
            class_name = control_proxy_class_symbol(keyword)
            Glimmer::JFX::ControlProxy.const_get(class_name)
          rescue => e
            Glimmer::Config.logger.debug e.full_message
            Glimmer::JFX::ControlProxy
          end
        end
        
        def control_proxy_class_symbol(keyword)
          "#{keyword.camelcase(:upper)}Proxy".to_sym
        end
        
        def control_class_symbol(keyword)
          keyword.camelcase(:upper).to_sym
        end
        
        def keyword(control_proxy_class)
          control_proxy_class.to_s.underscore.sub(/_proxy$/, '')
        end
        
        def control_class_manual_entries
          # add mappings for any classes (minus the namespace) that conflict with standard Ruby classes
          {
            # example:
            # 'date_time' => Java::OrgEclipseSwtWidgets::DateTime
          }
        end
          
        def control_class(keyword)
          unless flyweight_control_class[keyword]
            begin
              control_class_name = control_class_symbol(keyword).to_s
              control_class = eval(control_class_name)
              unless control_class.ancestors.include?(Java::JavafxScene::Node)
                control_class = control_class_manual_entries[keyword]
                if control_class.nil?
                  Glimmer::Config.logger.debug {"Class #{control_class} matching #{keyword} is not a subclass of javafx.scene.Node"}
                  return nil
                end
              end
              flyweight_control_class[keyword] = control_class
            rescue SyntaxError, NameError => e
              Glimmer::Config.logger.debug {e.full_message}
              nil
            rescue => e
              Glimmer::Config.logger.debug {e.full_message}
              nil
            end
          end
          flyweight_control_class[keyword]
        end
        
        # Flyweight Design Pattern memoization cache. Can be cleared if memory is needed.
        def flyweight_control_class
          @flyweight_control_class ||= {}
        end
      end
      
      attr_reader :parent_proxy, :jfx, :args, :keyword, :block
      
      def initialize(parent, keyword, *args, &block)
        @parent_proxy = parent
        @keyword = keyword
        @args = args
        @block = block
        build
        post_add_content if @block.nil?
      end
      
      # Subclasses may override to perform post add_content work (normally must call super)
      def post_add_content
        @parent_proxy&.post_initialize_child(self)
      end
      
      # Subclasses may override to perform post initialization work on an added child (normally must also call super)
      def post_initialize_child(child)
        children.add(child.jfx) if respond_to?(:children) && child.is_a?(ControlProxy)
      end
      
      def respond_to?(method_name, *args, &block)
        respond_to_jfx?(method_name, *args, &block) ||
          super(method_name, true)
      end
      
      def respond_to_jfx?(method_name, *args, &block)
        @jfx.respond_to?(method_name, true) || @jfx.respond_to?("set_#{method_name}", true)
      end
      
      def send_to_jfx(method_name, *args, &block)
        @jfx.send(method_name, *normalize_args(args), &block)
      end
            
      def method_missing(method_name, *args, &block)
        if respond_to?("#{method_name}=", true) && !args.empty?
          send("#{method_name}=", *args)
        elsif @jfx.respond_to?("set_#{method_name}", true) && !args.empty?
          send_to_jfx("set_#{method_name}", *args, &block)
        elsif @jfx.respond_to?(method_name, true)
          send_to_jfx(method_name, *args, &block)
        else
          super
        end
      end
      
      def content(&block)
        Glimmer::DSL::Engine.add_content(self, Glimmer::DSL::JFX::ControlExpression.new, @keyword, &block)
      end
      
      private
      
      def build
        @jfx = ControlProxy.control_class(keyword).new(*normalize_args(args))
      end
      
      def normalize_args(args)
        args.map do |arg|
          arg.is_a?(ControlProxy) ? arg.jfx : arg
        end
      end
    end
  end
end

Dir[File.expand_path("./#{File.basename(__FILE__, '.rb')}/*.rb", __dir__)].each {|f| require f}

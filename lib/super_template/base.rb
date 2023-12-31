# frozen_string_literal: true

require_relative 'inflector'
require_relative 'compiler'

module SuperTemplate
  class Base

    def call
      self.class.compile unless self.class.compiled? || self.respond_to?(:render_template)
      render_template
    end

    module ClassMethods

      # Strips trailing whitespace from templates before compiling them.
      #
      # ```ruby
      # class MyTemplate < SuperTemplate::Base
      #   strip_trailing_whitespace
      # end
      # ```
      #
      # @param value [Boolean] Whether to strip newlines.
      def strip_trailing_whitespace(value = true)
        @__st_strip_trailing_whitespace = value
      end

      # Whether trailing whitespace will be stripped before compilation.
      #
      # @return [Boolean]
      def strip_trailing_whitespace?
        @__st_strip_trailing_whitespace
      end

      def source_location
        @source_location ||= Object.const_source_location(self.name)[0]
      end

      def compiled?
        @__st_compiled ||= false
      end

      def compile
        @__st_compiled ||= compiler.compile
      end

      def compiler
        @__st_compiler ||= SuperTemplate::Compiler.new(self)
      end

      # @param extension [Symbol] extension
      # @param source [String] template source
      def template(extension, source)
        caller = caller_locations(1..1)[0]
        @__st_inline_template = OpenStruct.new(
          source: source,
          type: extension,
          path: caller.absolute_path || caller.path,
          lineno: caller.lineno
        )
      end

      def inline_template
        @__st_inline_template
      end

      # Find sidecar files for the given extensions.
      #
      # The provided array of extensions is expected to contain
      # strings starting without the dot, example: `["erb", "haml"]`.
      #
      # For example, one might collect sidecar CSS files that need to be compiled.
      # @param extensions [Array<String>] Extensions of which to return matching sidecar files.
      def sidecar_files(extensions)
        return [] unless source_location

        extensions = extensions.join(",")

        # view files in a directory named like the component
        directory = File.dirname(source_location)
        filename = File.basename(source_location, ".rb")
        component_name = name.demodulize.underscore

        # Add support for nested components defined in the same file.
        #
        # for example
        #
        # class MyTemplate < SuperTemplate::Base
        #   class MyTemplate < SuperTemplate::Base
        #   end
        # end
        #
        # Without this, `MyOtherComponent` will not look for `my_component/my_other_component.html.erb`
        nested_component_files =
          if name.include?("::") && component_name != filename
            Dir["#{directory}/#{filename}/#{component_name}.*{#{extensions}}"]
          else
            []
          end

        # view files in the same directory as the component
        sidecar_files = Dir["#{directory}/#{component_name}.*{#{extensions}}"]

        sidecar_directory_files = Dir["#{directory}/#{component_name}/#{filename}.*{#{extensions}}"]

        (sidecar_files - [source_location] + sidecar_directory_files + nested_component_files).uniq
      end
    end

    def self.inherited(child)
      child.extend ClassMethods
      super
    end

    private
    def get_binding
      binding
    end
  end
end

# frozen_string_literal: true

module SuperTemplate
  module Generators
    module AbstractGenerator
      def copy_view_file
        template "component.#{options["format"]}.#{engine_name}", destination unless options["inline"]
      end

      private

      def destination
        File.join(destination_directory, "#{destination_file_name}.#{options["format"]}.#{engine_name}")
      end

      def destination_directory
        if sidecar?
          File.join(template_path, class_path, destination_file_name)
        else
          File.join(template_path, class_path)
        end
      end

      def destination_file_name
        "#{file_name}_template"
      end

      def file_name
        @_file_name ||= super.sub(/_template\z/i, "")
      end

      def template_path
        "app/templates"
      end

      def sidecar?
        options["sidecar"]
      end
    end
  end
end

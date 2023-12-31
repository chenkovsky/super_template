require_relative "../abstract_generator"
module SuperTemplate
  module Generators
    class TemplateGenerator < Rails::Generators::NamedBase

      include SuperTemplate::Generators::AbstractGenerator

      source_root File.expand_path("templates", __dir__)

      argument :attributes, type: :array, default: [], banner: "attribute"
      check_class_collision suffix: "Template"

      class_option :inline, type: :boolean, default: false
      class_option :parent, type: :string, desc: "The parent class for the generated template"
      class_option :format, type: :string, default: "sql"
      class_option :template_engine, type: :string, default: "erb"

      def create_sidecar_file
        unless options[:inline]
          create_file File.join(template_path, class_path, "#{file_name}_template.#{options[:format]}.#{options[:template_engine]}")
        end
      end

      def create_template_file
        template "template.rb.erb", File.join(template_path, class_path, "#{file_name}_template.rb")
      end

      private

      def template_engine
        options[:template_engine]
      end

      def parent_class
        return options[:parent] if options[:parent]
        default_parent_class
      end

      def initialize_signature
        return if attributes.blank?

        attributes.map { |attr| "#{attr.name}:" }.join(", ")
      end

      def initialize_body
        attributes.map { |attr| "@#{attr.name} = #{attr.name}" }.join("\n    ")
      end

      def initialize_call_method_for_inline?
        options["inline"]
      end

      def default_parent_class
        defined?(ApplicationTemplate) ? ApplicationTemplate : SuperTemplate::Base
      end
    end
  end
end

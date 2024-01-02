require "erb"
require "concurrent-ruby"
require_relative "errors"

module SuperTemplate
  class Compiler
    def initialize(template_class)
      @template_class = template_class
      @redefinition_lock = Mutex.new
    end

    def compile(raise_errors: false, force: false)
      return if template_class.compiled? && !force
      return if template_class == SuperTemplate::Base
      template_class.superclass.compile(raise_errors: raise_errors)

      redefinition_lock.synchronize do
        templates = []
        templates = find_sidecar_templates
        templates << template_class.inline_template if template_class.inline_template
        raise TemplateError, "There are #{templates.size} templates defined for #{self}" if templates.size >= 2
        unless templates.empty?
          compile_template(templates[0])
        end
      end
      return true
    end

    protected

    def find_sidecar_templates
      template_class.sidecar_files([:erb]).map do |path|
        pieces = File.basename(path).split(".")
        OpenStruct.new(
          source: File.read(path),
          type: pieces.last,
          path: path,
          lineno: 0
        )
      end
    end

    def compile_template(template)
      source = template.source
      source = source.rstrip! if template_class.strip_trailing_whitespace?
      erb = ERB.new(source)
      erb.filename = template.path
      erb.lineno = template.lineno
      erb.def_method(template_class, 'render_template()')
    end

    attr_reader :template_class, :redefinition_lock
  end
end

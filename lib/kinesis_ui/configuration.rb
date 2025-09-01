module KinesisUi
  class Configuration
    attr_accessor :theme, :css_framework, :default_classes, :components

    def initialize
      @theme = :default
      @css_framework = :tailwind
      @default_classes = {
        modal: {
          backdrop: "fixed inset-0 bg-gray-800/50 flex items-center justify-center z-50",
          container: "bg-white p-6 rounded-lg shadow-lg max-w-md w-full mx-4",
          title: "text-xl font-bold mb-4",
          content: "mb-4",
          footer: "flex justify-end space-x-2"
        },
        button: {
          base: "inline-flex items-center justify-center font-medium rounded-md transition-colors focus:outline-none focus:ring-2 focus:ring-offset-2",
          primary: "bg-blue-600 text-white hover:bg-blue-700 focus:ring-blue-500",
          secondary: "bg-gray-200 text-gray-900 hover:bg-gray-300 focus:ring-gray-500",
          danger: "bg-red-600 text-white hover:bg-red-700 focus:ring-red-500",
          success: "bg-green-600 text-white hover:bg-green-700 focus:ring-green-500",
          sizes: {
            small: "px-3 py-2 text-sm",
            medium: "px-4 py-2 text-sm",
            large: "px-6 py-3 text-base"
          }
        }
      }
      @components = {
        modal: {
          close_on_backdrop: true,
          close_on_escape: true,
          animation: true
        }
      }
    end

    def component_config(component_name)
      @components[component_name.to_sym] || {}
    end

    def classes_for(component, element = nil)
      if element
        @default_classes.dig(component.to_sym, element.to_sym) || ""
      else
        @default_classes[component.to_sym] || {}
      end
    end

    def merge_classes(*class_arrays)
      class_arrays.compact.join(" ").strip
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.reset_configuration!
    @configuration = Configuration.new
  end
end

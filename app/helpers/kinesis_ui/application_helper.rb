module KinesisUi
  module ApplicationHelper
    def kinesis_modal(title: nil, body: nil, trigger_text: "Abrir Modal", close_text: "Fechar", confirm_text: "Confirmar", confirm_action: false, **options, &block)
      render "kinesis_ui/components/modal", {
        title: title,
        body: body,
        trigger_text: trigger_text,
        close_text: close_text,
        confirm_text: confirm_text,
        confirm_action: confirm_action
      }.merge(options), &block
    end

    def kinesis_button(text, variant: :primary, size: :medium, **options, &block)
      classes = kinesis_button_classes(variant, size)
      options[:class] = [ options[:class], classes ].compact.join(" ")

      if block_given?
        content_tag(:button, options, &block)
      else
        content_tag(:button, text, options)
      end
    end

    private

    def kinesis_button_classes(variant, size)
      base_classes = "inline-flex items-center justify-center font-medium rounded-md transition-colors focus:outline-none focus:ring-2 focus:ring-offset-2"

      variant_classes = case variant.to_sym
      when :primary
        "bg-blue-600 text-white hover:bg-blue-700 focus:ring-blue-500"
      when :secondary
        "bg-gray-200 text-gray-900 hover:bg-gray-300 focus:ring-gray-500"
      when :danger
        "bg-red-600 text-white hover:bg-red-700 focus:ring-red-500"
      when :success
        "bg-green-600 text-white hover:bg-green-700 focus:ring-green-500"
      else
        "bg-blue-600 text-white hover:bg-blue-700 focus:ring-blue-500"
      end

      size_classes = case size.to_sym
      when :small
        "px-3 py-2 text-sm"
      when :medium
        "px-4 py-2 text-sm"
      when :large
        "px-6 py-3 text-base"
      else
        "px-4 py-2 text-sm"
      end

      [ base_classes, variant_classes, size_classes ].join(" ")
    end
  end
end

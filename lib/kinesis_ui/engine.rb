module KinesisUi
  class Engine < ::Rails::Engine
    isolate_namespace KinesisUi

    initializer "kinesis_ui.assets" do |app|
      app.config.assets.precompile += %w[kinesis_ui/application.css kinesis_ui/application.tailwind.css controllers/modal_controller.js]
      app.config.assets.paths << root.join("app/javascripts")
    end

    initializer "kinesis_ui.stimulus", after: "stimulus" do |app|
      app.config.stimulus.controllers_path << root.join("app/javascripts/controllers")
    end

    initializer "kinesis_ui.importmap", before: "importmap" do |app|
      app.config.importmap.paths << root.join("config/importmap.rb")
    end

    initializer "kinesis_ui.view_paths" do |app|
      app.config.paths["app/views"].unshift(root.join("app/views"))
    end

    initializer "kinesis_ui.helpers" do
      ActiveSupport.on_load(:action_controller_base) do
        helper KinesisUi::ApplicationHelper
      end

      ActiveSupport.on_load(:action_view) do
        include KinesisUi::ApplicationHelper
      end
    end
  end
end
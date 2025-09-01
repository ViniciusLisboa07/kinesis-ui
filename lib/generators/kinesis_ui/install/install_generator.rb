require "rails/generators/base"

module KinesisUi
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc "Install KinesisUi components and configuration"

      class_option :skip_helper, type: :boolean, default: false, desc: "Skip adding helper to ApplicationHelper"
      class_option :skip_initializer, type: :boolean, default: false, desc: "Skip creating initializer"
      class_option :skip_stimulus, type: :boolean, default: false, desc: "Skip Stimulus controller setup"
      class_option :skip_assets, type: :boolean, default: false, desc: "Skip asset configuration"

      def install_initializer
        return if options[:skip_initializer]

        say "Criando initializer KinesisUi...", :green
        create_file "config/initializers/kinesis_ui.rb", initializer_content
      end

      def add_helper_to_application
        return if options[:skip_helper]

        say "Adicionando helpers KinesisUi ao ApplicationHelper...", :green

        helper_file = "app/helpers/application_helper.rb"

        if File.exist?(Rails.root.join(helper_file))
          unless File.read(Rails.root.join(helper_file)).include?("KinesisUi::ApplicationHelper")
            insert_into_file helper_file, after: "module ApplicationHelper\n" do
              "  inclui KinesisUi::ApplicationHelper\n"
            end
          else
            say "Helper já incluído no ApplicationHelper", :yellow
          end
        else
          create_file helper_file, application_helper_content
        end
      end

      def setup_stimulus_controllers
        return if options[:skip_stimulus]

        if stimulus_available?
          say "Configurando controllers Stimulus...", :green
          setup_stimulus_files
        else
          say "Stimulus não detectado, pulando configuração de Stimulus", :yellow
          say "Você pode registrar controllers manualmente se estiver usando Stimulus", :blue
        end
      end

      def setup_assets
        return if options[:skip_assets]

        say "Configurando assets...", :green

        # Try to add CSS import to application.css
        setup_application_css

        # Tenta adicionar Tailwind CSS se existir
        setup_tailwind_css

        # Linka assets JS do engine no manifesto do host para precompile do Sprockets
        link_js_assets_in_manifest
      end

      def add_routes
        say "Adicionando rotas KinesisUi...", :green

        routes_content = File.read("config/routes.rb")
        unless routes_content.include?("KinesisUi::Engine")
          route 'mount KinesisUi::Engine => "/kinesis_ui"'
        else
          say "Rotas já configuradas", :yellow
        end
      end

      def show_post_install_message
        say "\n" + "=" * 50, :green
        say "Instalação do KinesisUi completa!", :green
        say "=" * 50, :green
        say "\nNext steps:", :yellow
        say "1. Reiniciar seu servidor Rails", :white
        say "2. Configure KinesisUi in config/initializers/kinesis_ui.rb", :white

        if stimulus_available?
          say "3. Controllers Stimulus configurados ✓", :green
        else
          say "3. Registrar controllers manualmente se necessário", :yellow
        end

        say "\nExemplos de uso:", :white
        say "   <%= kinesis_modal(title: 'My Modal', body: 'Content here') %>", :cyan
        say "   <%= render 'kinesis_ui/components/modal', title: 'My Modal' %>", :cyan

        if tailwind_available?
          say "\nTailwind CSS detectado ✓", :green
        else
          say "\nNota: Este gem é otimizado para Tailwind CSS", :yellow
        end

        say "\nPara mais informações, visite:", :blue
        say "https://github.com/ViniciusLisboa07/kinesis_ui", :blue
        say "=" * 50, :green
      end

      private

      def stimulus_available?
        File.exist?("app/javascript/controllers/application.js") ||
          File.exist?("app/assets/javascripts/controllers/application.js") ||
          File.exist?("config/importmap.rb")
      end

      def tailwind_available?
        File.exist?("app/assets/stylesheets/application.tailwind.css") ||
          File.exist?("tailwind.config.js") ||
          gemfile_includes?("tailwindcss-rails")
      end

      def gemfile_includes?(gem_name)
        File.read("Gemfile").include?(gem_name)
      rescue
        false
      end

      def setup_stimulus_files
        stimulus_manifest = find_stimulus_manifest_file

        if stimulus_manifest
          setup_stimulus_in_manifest(stimulus_manifest)
        else
          say "Could not find Stimulus manifest file", :yellow
          say "Please manually register controllers:", :blue
          say stimulus_manual_setup_instructions, :cyan
        end
      end

      def find_stimulus_manifest_file
        [
          "app/javascript/controllers/application.js",
          "app/assets/javascripts/controllers/application.js"
        ].find { |path| File.exist?(path) }
      end

      def setup_stimulus_in_manifest(manifest_file)
        manifest_content = File.read(manifest_file)

        unless manifest_content.include?("kinesis_ui_controllers")
          append_to_file manifest_file do
            "\n// KinesisUi Controllers\nimport \"./kinesis_ui_controllers\"\n"
          end

          create_file File.dirname(manifest_file) + "/kinesis_ui_controllers.js", stimulus_controllers_content
        else
          say "Stimulus controllers already configured", :yellow
        end
      end

      def setup_application_css
        application_css = "app/assets/stylesheets/application.css"

        if File.exist?(Rails.root.join(application_css))
          css_content = File.read(Rails.root.join(application_css))

          unless css_content.include?("kinesis_ui/application")
            if css_content.include?("*= require_tree .")
              insert_into_file application_css, before: " *= require_tree .\n" do
                " *= require kinesis_ui/application\n"
              end
            elsif css_content.include?(" */")
              insert_into_file application_css, before: " */" do
                " *\n *= require kinesis_ui/application\n"
              end
            else
              append_to_file application_css do
                "\n/* KinesisUi Styles */\n/*\n *= require kinesis_ui/application\n */\n"
              end
            end
          else
            say "CSS already configured in application.css", :yellow
          end
        else
          say "application.css not found", :yellow
        end
      end

      def setup_tailwind_css
        application_tailwind = "app/assets/stylesheets/application.tailwind.css"

        if File.exist?(Rails.root.join(application_tailwind))
          tailwind_content = File.read(Rails.root.join(application_tailwind))

          unless tailwind_content.include?("kinesis_ui/application.tailwind.css")
            append_to_file application_tailwind do
              "\n/* KinesisUi Components */\n@import 'kinesis_ui/application.tailwind.css';\n"
            end
          else
            say "Tailwind CSS already configured", :yellow
          end
        end
      end

      def link_js_assets_in_manifest
        manifest_file = "app/assets/config/manifest.js"

        return unless File.exist?(Rails.root.join(manifest_file))

        content = File.read(Rails.root.join(manifest_file))
        link_line = "//= link controllers/modal_controller.js\n"

        unless content.include?("controllers/modal_controller.js")
          say "Linking controllers/modal_controller.js in manifest.js", :green
          append_to_file manifest_file do
            "\n#{link_line}"
          end
        end
      end

      def initializer_content
        <<~RUBY
          # KinesisUi Configuration
          KinesisUi.configure do |config|
            # Set the default theme
            # config.theme = :default

            # Set the CSS framework (currently supports :tailwind)
            # config.css_framework = :tailwind

            # Customize default classes for components
            # config.default_classes[:modal][:backdrop] = "your-custom-classes"

            # Configure component behavior
            # config.components[:modal][:close_on_backdrop] = true
            # config.components[:modal][:close_on_escape] = true
            # config.components[:modal][:animation] = true
          end
        RUBY
      end

      def application_helper_content
        <<~RUBY
          module ApplicationHelper
            include KinesisUi::ApplicationHelper
          end
        RUBY
      end

      def stimulus_controllers_content
        <<~JAVASCRIPT
          // KinesisUi Stimulus Controllers
          import { application } from "./application"

          // Import KinesisUi controllers
          import ModalController from "kinesis_ui/modal_controller"

          // Register KinesisUi controllers
          application.register("modal", ModalController)

          export { application }
        JAVASCRIPT
      end

      def stimulus_manual_setup_instructions
        <<~INSTRUCTIONS

          Add this to your Stimulus application file:

          import ModalController from "kinesis_ui/modal_controller"
          application.register("modal", ModalController)

        INSTRUCTIONS
      end
    end
  end
end
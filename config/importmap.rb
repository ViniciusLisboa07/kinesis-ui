# Importmap pins for KinesisUi engine

# Pin Stimulus controllers provided by the engine under a namespaced specifier
# The asset logical path is resolved via the engine's assets path:
#   app.config.assets.paths << engine.root.join("app/javascripts")

pin "kinesis_ui/modal_controller", to: "controllers/modal_controller.js"

# If you add more controllers, consider pinning them here or using pin_all_from
# Example:
# pin_all_from "controllers", under: "kinesis_ui/controllers"



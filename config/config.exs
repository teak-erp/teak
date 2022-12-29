import Config

if Mix.env() == :test do
  config :teak, :document_customizations, [
    Teak.Test.Document.ResourceExtensionTest.Customizations
  ]
end

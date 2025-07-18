require 'hexapdf'

module Filler
  class FillBase
    def initialize(worker:, template_path:, output_path:, fields:)
      @worker = worker
      @template_path = template_path
      @output_path = output_path
      @fields = fields
    end

    def call
      doc = HexaPDF::Document.open(@template_path)
      canvas = doc.pages[0].canvas(type: :overlay)
      canvas.font("Helvetica", size: 12)
    
      @fields.each do |field|
        canvas.text(field[:value], at: field[:at])
      end

      doc.write(@output_path.to_s)
      @output_path
    end
  end
end 
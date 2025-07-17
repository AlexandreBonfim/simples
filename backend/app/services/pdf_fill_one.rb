require 'hexapdf'

class PdfFillOne
  def initialize(worker)
    @worker = worker
    @template_path = Rails.root.join("app/assets/template.pdf")
    @output_path = Rails.root.join("tmp", "acta_test.pdf")
  end

  def call
    doc = HexaPDF::Document.open(@template_path)
    canvas = doc.pages[0].canvas(type: :overlay)

    # Write the data into known coordinates (X, Y)
    # You will need to fine-tune these positions by testing
    canvas.font("Helvetica", size: 12)

    canvas.text(@worker[:full_name], at: [123, 660])       # El trabajador
    canvas.text(@worker[:doc_number], at: [100, 635])       # con D.N.I.
    canvas.text(format_date(@worker[:start_date]), at: [220, 260])  # en Málaga a

    doc.write(@output_path.to_s)
    @output_path
  end

  private

  def format_date(date)
    return "" if date.nil?
    date_obj = date.is_a?(Date) ? date : Date.strptime(date, "%d-%m-%Y")
    I18n.l(date_obj, format: "%d de %B", locale: :es)
  end
end

require 'hexapdf'

class PdfFillTwo
  def initialize(worker)
    @worker = worker
    @template_path = Rails.root.join("app/assets/template2.pdf")
    @output_path = Rails.root.join("tmp", "acta_test_2.pdf")
  end

  def call
    doc = HexaPDF::Document.open(@template_path)
    canvas = doc.pages[0].canvas(type: :overlay)

    # Write the data into known coordinates (X, Y)
    # You will need to fine-tune these positions by testing
    canvas.font("Helvetica", size: 12)

    canvas.text(@worker[:full_name], at: [145, 635])       # El trabajador
    canvas.text(@worker[:doc_number], at: [122, 615])       # con D.N.I.

    # Split date into day and month, and write them at their respective positions
    day, month = extract_day_and_month(@worker[:start_date])
    canvas.text(day, at: [295, 190])    # Estimated position for day (e.g., "02")
    canvas.text(month, at: [345, 190])  # Estimated position for month (e.g., "julio")

    doc.write(@output_path.to_s)
    @output_path
  end

  private

  def extract_day_and_month(date)
    return ["", ""] if date.nil?
    date_obj = date.is_a?(Date) ? date : Date.strptime(date, "%d-%m-%Y")
    day = date_obj.strftime("%d")
    month = I18n.l(date_obj, format: "%B", locale: :es)
    [day, month]
  end
end

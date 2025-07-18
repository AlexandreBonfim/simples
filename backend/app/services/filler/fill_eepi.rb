require 'hexapdf'

module Filler
  class FillEepi < FillBase
  def initialize(worker)
    super(
      worker: worker,
      template_path: Rails.root.join("app/assets/templates/eepi.pdf"),
      output_path: Rails.root.join("tmp", "eepi_#{worker[:doc_number]}.pdf"),
      fields: [
        { value: worker[:full_name], at: [145, 635] },
        { value: worker[:doc_number], at: [122, 615] },
        { value: extract_day(worker[:start_date]), at: [295, 190] },
        { value: extract_month(worker[:start_date]), at: [345, 190] }
      ]
    )
  end

  private

  def extract_day(date)
    return "" if date.nil?
    date_obj = date.is_a?(Date) ? date : Date.strptime(date, "%d-%m-%Y")
    date_obj.strftime("%d")
  end

  def extract_month(date)
    return "" if date.nil?
    date_obj = date.is_a?(Date) ? date : Date.strptime(date, "%d-%m-%Y")
    I18n.l(date_obj, format: "%B", locale: :es)
  end
  end
end
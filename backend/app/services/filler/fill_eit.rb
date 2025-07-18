require 'hexapdf'

module Filler
  class FillEit < FillBase
    def initialize(worker)
      super(
        worker: worker,
        template_path: Rails.root.join("app/assets/templates/eit.pdf"),
        output_path: Rails.root.join("tmp", "eit_#{worker[:doc_number]}.pdf"),
        fields: [
          { value: worker[:full_name], at: [123, 660] },
          { value: worker[:doc_number], at: [100, 635] },
          { value: format_date(worker[:start_date]), at: [220, 260] }
        ]
      )
    end

    private

    def format_date(date)
      return "" if date.nil?
      date_obj = date.is_a?(Date) ? date : Date.strptime(date, "%d-%m-%Y")
      I18n.l(date_obj, format: "%d de %B", locale: :es)
    end
  end
end
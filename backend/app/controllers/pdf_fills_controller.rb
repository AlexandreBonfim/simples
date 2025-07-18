class PdfFillsController < ApplicationController
  # POST /pdf_fills
  # Expected params: { type: "one"|"two"|"three", worker: { full_name: ..., doc_number: ..., start_date: ... } }
  def create
    type = params[:type]
    worker = params[:worker]&.permit(:full_name, :doc_number, :start_date)

    pdf_filler = case type
                 when "one"
                   PdfFillOne.new(worker)
                 when "two"
                   PdfFillTwo.new(worker)
                 when "three"
                   PdfFillThree.new(worker)
                 else
                   render json: { error: "Invalid type" }, status: :bad_request and return
                 end

    output_path = pdf_filler.call
    send_file output_path, filename: File.basename(output_path), type: 'application/pdf', disposition: 'attachment'
  end
end 
require 'pdf-reader'

class IdcParser
  attr_reader :file, :data

  def initialize(file_path)
    @file = file_path
    @data = {}
  end

  def call
    text = extract_text
    parse_fields(text)
    validate_required_fields!
    data
  end

  private

  def extract_text
    reader = PDF::Reader.new(file)
    reader.pages.map(&:text).join("\n")
  end

  def parse_fields(text)
    data[:full_name] = text[/NOMBRE Y APELLIDOS:\s*(.+)/, 1]&.strip
    data[:birth_date] = text[/NACIMIENTO:\s*(\d{2}-\d{2}-\d{4})/, 1]
    data[:doc_type] = text[/DOC\.IDENTIFICATIVO:\s*(\S+)/, 1]
    data[:doc_number] = text[/NUM:\s*(\S+)/, 1]
    data[:start_date] = text[/ALTA:\s*(\d{2}-\d{2}-\d{4})/, 1]
  end

  def validate_required_fields!
    %i[full_name start_date doc_number].each do |field|
      value = data[field]
      raise ArgumentError, "#{field} is required" if value.nil? || value.to_s.strip.empty?
    end
  end
end

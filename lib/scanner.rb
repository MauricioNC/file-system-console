require 'find'
require_relative '../config/logger_config.rb'
require_relative '../helpers/regex_module.rb'

class Scanner
  include RegexModule

  attr_accessor :path

  def initialize(path = nil)
    begin
      @path = path
    rescue => e
      $logger.error("Error en la funcion svae_in_excel: #{e.message}")
      puts "Error en la funcion initialize de la clase Scanner: #{e.message}"
    end
  end

  def scann(year = "2024")
    begin
      files = []
      Find.find(@path) do |path|
        if File.file?(path)
          if path =~ /.*\.pdf$/i
            file_name = File.basename(path)
            unless filter_by_year(file_name, year).empty?
              files.push({
                file_name: file_name,
                document_number: get_document_number(file_name),
                document_type: document_type(file_name),
                file_path: path,
                responsible: path.split('/')[3],
                creation_date: date(file_name)
              })
            end
          end
        end
      end
      files
    rescue => e
      $logger.error("Error en la funcion scann: #{e.message}")
      puts "Error en la funcion scann: #{e.message}"
    end
  end

  private

  def get_document_number(file_name)
    begin
      regex_validator = /(([A-Za-z]{2,3})[-_.]([A-Za-z]{2,3})[-._]?([A-Za-z]{2,3})?[-._](\d{2,5})[-._\s](\d{2,4}))/
      invalid_chars = ['-', '.', '_', ' ']
      doc_number = file_name.match(regex_validator)[0] if file_name.match?(regex_validator)

      unless doc_number.nil?
        last_char = doc_number[-1]
        doc_number.chomp!(last_char) if invalid_chars.include?(last_char)

        # Scanning only for the digits characters
        doc_number = doc_number.scan(/\d+/)
      end

      doc_number.nil? ? "" : doc_number[0].to_s
    rescue => e
      $logger.error("Error en la funcion get_document_number: #{e.message}")
      puts "Error en la funcion get_document_number: #{e.message}"
    end
  end
end

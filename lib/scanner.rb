require 'find'
require_relative '../config/logger_config.rb'
require_relative '../helpers/regex_module.rb'
require_relative '../helpers/file_validations.rb'

class Scanner
  include RegexModule

  attr_accessor :path

  def initialize(path = nil)
    begin
      @path = path
      @file_data = []
    rescue => e
      $logger.error("Error en la funcion svae_in_excel: #{e.message}")
      puts "Error en la funcion initialize de la clase Scanner: #{e.message}"
    end
  end

  def scann(year = "2024", reason = nil)
    return nil if reason.nil?

    begin
      Find.find(@path) do |path|
        if File.file?(path) && path =~ /.*\.pdf$/i
          file_name = File.basename(path)

          if reason == "save"
            self.get_files_to_save(file_name, year, path)
          elsif reason == "sync"
            self.get_files_to_sync(file_name, year, path)
          end
        end
      end

      @file_data
    rescue => e
      $logger.error("Error en la funcion scann: #{e.message}")
      puts "Error en la funcion scann: #{e.message}"
    end
  end

  def get_files_to_save(file_name, year, path)
    unless $file_names_data["#{year}"].include?(file_name)
      @file_data.push({
        file_name: file_name,
        document_number: get_document_number(file_name),
        document_type: document_type(file_name),
        file_path: path,
        responsible: path.split('/')[3],
        creation_date: date(file_name)
      }) if filter_by_year(file_name, year)
    end
  end

  def get_files_to_sync(file_name, year, path)
    @file_data.push({
      file_name: file_name,
      file_path: path,
    }) if filter_by_year(file_name, year)
  end

  private

  def get_document_number(file_name)
    begin
      doc_number =  if file_name.split("_")[1].nil?
                      nil
                    else
                      file_name.split("_")[1].split("-")[-2]
                    end

      doc_number.nil? ? "" : doc_number.to_s
    rescue => e
      $logger.error("Error en la funcion get_document_number: #{e.message}")
      puts "Error en la funcion get_document_number: #{e.message}"
    end
  end
end

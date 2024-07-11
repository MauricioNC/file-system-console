require 'rubyXL'
require 'rubyXL/convenience_methods'
require 'json'
require_relative '../config/logger_config.rb'

class Storage
  attr_reader :workbook, :excel_path, :worksheet

  def initialize excel_path, json_cache_path
    @workbook = RubyXL::Parser.parse(excel_path)
    @excel_path = excel_path
    @worksheet = @workbook[0]
    @json_cache_path = json_cache_path
  end

  def save_in_cache(file_name = "")
    begin
      $logger.info("Guardando registros en la caché...")
      json_file_content = File.read(@json_cache_path)
      json_cache = JSON.parse(json_file_content)
      json_cache["data"]["body"].push(file_name) unless file_name.empty?
      File.write(@json_cache_path, JSON.dump(json_cache))
      $logger.info("Proceso finalizado exitosamente....")
    rescue => e
      $logger.error("Error en la funcion save_in_cache: #{e.message}")
      puts "Error en la funcion save_in_cache: #{e.message}"
    end
  end

  def save_in_excel(file_hash)
    begin
      $logger.info("Guardando registros en excel...")
      current_row = first_empty_row_after_headers
      @worksheet.add_cell(current_row, 0, file_hash[:creation_date])
      @worksheet.add_cell(current_row, 1, file_hash[:document_number])
      hyperlinked_cell = @worksheet.add_cell(current_row, 2, 'Ver documento')
      hyperlinked_cell.add_hyperlink(file_hash[:file_path])
      hyperlinked_cell.change_font_color('0000FF')
      hyperlinked_cell.change_font_underline(true)
      @worksheet.add_cell(current_row, 3, file_hash[:file_name])
      @worksheet.add_cell(current_row, 4, file_hash[:responsible])
      @worksheet.add_cell(current_row, 5, file_hash[:document_type])

      @workbook.write(@excel_path)
      $total_scanned_files += 1
      $scanned_files.push({
        file_name: file_hash[:file_name],
        file_number: file_hash[:document_number],
        added_at_row: current_row,
        responsable: file_hash[:responsible],
        file_path: file_hash[:file_path]
      })
      $logger.info("Proceso finalizado exitosamente")
    rescue => e
      $logger.error("Error en la funcion svae_in_excel: #{e.message}")
      puts "Error en la funcion svae_in_excel: #{e.message}"
    end
  end

  private

  def first_empty_row_after_headers()
    @worksheet.each_with_index do |row, idx|
      next if idx == 0 # Saltar la fila de cabeceras
      return idx if row.nil? || row.cells.all? { |cell| cell.nil? || cell.value.to_s.strip.empty? }
    end
    @worksheet.sheet_data.size # Si no hay filas vacías encontradas, retorna el tamaño actual
  end
end

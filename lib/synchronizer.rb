require 'find'
require 'fileutils'
require_relative './scanner.rb'

class Synchronizer
  def initialize(root_path)
    @root_path = root_path
    @sub_path = "C:/Subdireccion"
  end

  def start
    print "Ingresa el año que deseas escanear: "
    year = gets.chomp

    puts "Sincronizando archivos..."

    root_files = get_root_files(year)
    sub_files = get_sub_files(year)

    return nil if root_files.count == sub_files.count

    # getting only the file names
    root_file_names = root_files.map { |file_item| file_item[:file_name] }
    sub_file_names = sub_files.map { |file_item| file_item[:file_name] }

    # returns an array with the file names that doesn't exist in the dest. path
    sync_files = root_file_names - sub_file_names

    synchronize_files(sync_files, root_files)
  end

  private

  def get_root_files(year)
    root_scanner = Scanner.new(@root_path)
    root_scanner.scann(year)
  end

  def synchronize_files(sync_files, root_files)
    sync_files = root_files.keep_if { |obj| sync_files.include?(obj[:file_name]) }

    begin
      sync_files.each do |file|
        dest_dir = File.dirname(file[:file_path])
        dest_dir["Mauricio"] = "Subdireccion"

        FileUtils.mkdir_p(dest_dir)
        FileUtils.cp(file[:file_path], File.join(dest_dir, file[:file_name]))
      end

      puts "Archivos sincronizados correctamente..."
      puts "Total de archivos sincronizados: #{sync_files.size}"
    rescue => e
      puts "Algo ha salido mal..."
      puts e.message
    end
  end

  def get_sub_files(year)
    sub_scanner = Scanner.new(@sub_path)
    sub_scanner.scann(year)
  end
end

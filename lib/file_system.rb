require_relative '../config/logger_config.rb'
require_relative './scanner.rb'
require_relative './storage.rb'

$excel_path = {
  2024 => "C:/Mauricio/Control de documentos escaneados 2024.xlsx",
  2023 => "C:/Mauricio/Control de documentos escaneados 2023.xlsx",
  2022 => "C:/Mauricio/Control de documentos escaneados 2022.xlsx",
}
PDFS_DIR = "C:/Mauricio"
JSON_CACHE_PATH = './file_names.json'

def file_exists?(file_name = "", year = "2024")
  json_file_content = File.read(JSON_CACHE_PATH)
  cache = JSON.parse(json_file_content)
  cache['data']['body']["#{year}"].any? { |obj| obj["file_name"] == file_name }
end

def scann_files(year = "2024")
  system('cls')
  puts "Escaneando dcumentos..."
  $logger.info("Escaneando documentos...")
  begin
    scanner = Scanner.new(PDFS_DIR)
    json_files = scanner.scann(year)
    storage = Storage.new($excel_path[year.to_i], JSON_CACHE_PATH)
    json_files.each do |file|
      unless file_exists?(file[:file_name], year)
        storage.save_in_cache(file[:file_name], file[:file_path], year)
        storage.save_in_excel(file)
      end
    end
    puts "Escaneo completado exitosamente"
    $logger.info("Escaneo completado exitosamente")
  rescue => e
    $logger.error("Error en la funcion scann_files: #{e.message}")
    puts "Error en la funcion scann_files: #{e.message}"
  end
end

def main_menu
  puts "1. Registrar nuevos documentos"
  puts "2. Sincronizar carpetas y archivos"
  puts "3. Sincronizar archivo excel de registros"
  puts "0. Salir del programa"
  puts "=========================================="
end

while true
  system('cls')
  main_menu()
  print "¿Que accion quieres ejecutar?: "
  opc = gets.chomp
  opc = opc.empty? == false && opc.match?(/^[0-9]*$/) ? opc.to_i : opc

  case opc
  when 0
    $logger.info("Finalizando la ejecucion del programa...")
    system('cls')
    puts "Finalizando la ejecucion del programa..."
    sleep 1

    break;
  when 1
    print "Ingresa el año que deseas escanear: "
    year = gets.chomp

    scann_files(year)
    puts "\nPulsa Enter para continuar..."
    gets
  when 2, 3
    system('cls')
    puts "Esta accion todavia no esta disponible"
    print "Pulsa Enter para continuar..."
    gets
  else
    system("cls")
    puts "Escoge solo una opcion que se encuentre dentro del menu"
    puts "\nPulsa Enter para continuar..."
    gets
  end
end

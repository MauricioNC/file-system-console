begin
  require_relative '../config/logger_config.rb'
  require_relative './scanner.rb'
  require_relative './storage.rb'
  require_relative './synchronizer.rb'
  require_relative '../helpers/file_validations.rb'
rescue LoadError => e
  puts "Algo ha salido mal. Error: #{e.message}"
end


$excel_path = {
  2024 => "C:/Mauricio/Control de documentos escaneados 2024.xlsx",
  2023 => "C:/Mauricio/Control de documentos escaneados 2023.xlsx",
  2022 => "C:/Mauricio/Control de documentos escaneados 2022.xlsx",
}
PDFS_DIR = "C:/Mauricio"
JSON_CACHE_PATH = './file_names.json'

def scann_files(year = "2024")
  system('cls')
  puts "Escaneando dcumentos..."
  $logger.info("Escaneando documentos...")
  begin
    scanner = Scanner.new(PDFS_DIR)
    json_files = scanner.scann(year)

    storage = Storage.new($excel_path[year.to_i], JSON_CACHE_PATH)
    $total_files = 0

    json_files.each do |file|
      unless FileValidations.file_exists?(file[:file_name], year)
        storage.save_in_cache(file[:file_name], file[:file_path], year)
        storage.save_in_excel(file)
        $total_files += 1
      end
    end
    puts "Escaneo completado exitosamente"
    puts "#{$total_files} archivos nuevos"
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
  when 2
    system('cls')
    sync = Synchronizer.new(PDFS_DIR)
    sync.start

    print "\nPulsa Enter para continuar..."
    gets
  when 3
    system('cls')
    puts "Esta acción no está disponible todavía"
    puts "\nPulsa Enter para continuar..."
    gets
  else
    system("cls")
    puts "Escoge solo una opcion que se encuentre dentro del menu"
    puts "\nPulsa Enter para continuar..."
    gets
  end
end

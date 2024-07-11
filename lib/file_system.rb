require_relative './scanner.rb'
require_relative './storage.rb'

EXCEL_PATH = "C:/Mauricio/Control de documentos escaneados 2024 - Mauricio.xlsx"
PDFS_DIR = "C:/Mauricio"
JSON_CACHE_PATH = './file_names.json'

$total_scanned_files = 0
$scanned_files = []

def file_exists?(file_name = "")
  json_file_content = File.read(JSON_CACHE_PATH)
  cache = JSON.parse(json_file_content)
  cache['data']['body'].include?(file_name)
end

def scann_files
  system('cls')
  puts "Escaneando dcumentos..."
  scanner = Scanner.new(PDFS_DIR)
  json_files = scanner.scann
  storage = Storage.new(EXCEL_PATH, JSON_CACHE_PATH)

  json_files.each do |file|
    begin
      unless file_exists?(file[:file_name])
        storage.save_in_cache(file[:file_name])
        storage.save_in_excel(file)
      end
    rescue => e
      puts e.message
    end
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
    system('cls')
    puts "Finalizando la ejecucion..."
    sleep 1

    break;
  when 1
    scann_files()

    puts "Escaneo completado exitosamente"
    puts "#{$total_scanned_files} archivos registrados"
    puts "Pulsa 1 para listar los nuevos documentos registrados"
    list_scanned_files = gets.chomp.to_i

    puts $scanned_files if list_scanned_files == 1
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

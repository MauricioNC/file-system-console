require 'json'

$excel_path = {
  2024 => "C:/Mauricio/Control de documentos escaneados 2024.xlsx",
  2023 => "C:/Mauricio/Control de documentos escaneados 2023.xlsx",
  2022 => "C:/Mauricio/Control de documentos escaneados 2022.xlsx",
}
PDFS_DIR = "C:/Mauricio"
JSON_FILE_NAMES = './file_names.json'

$file_names_data = {}

def set_cache
  json_file_content = File.read(JSON_FILE_NAMES)
  file_names_storage = [].push(JSON.parse(json_file_content))

  file_names_2022 = file_names_storage.map { |item| item['data']['body']["2022"].map { |prop| prop["file_name"] } }.flatten
  file_names_2023 = file_names_storage.map { |item| item['data']['body']["2023"].map { |prop| prop["file_name"] } }.flatten
  file_names_2024 = file_names_storage.map { |item| item['data']['body']["2024"].map { |prop| prop["file_name"] } }.flatten

  $file_names_data = {
    "2022" => file_names_2022,
    "2023" => file_names_2023,
    "2024" => file_names_2024
  }
end

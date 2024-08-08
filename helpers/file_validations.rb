begin
  require 'json'
rescue LoadError => e
  puts "Algo ha salido mal. Error: #{e.message}"
end

module FileValidations
  def self.file_exists?(file_name = "", year = "2024")
    json_file_content = File.read(JSON_CACHE_PATH)
    cache = JSON.parse(json_file_content)
    cache['data']['body']["#{year}"].any? { |obj| obj["file_name"] == file_name }
  end
end

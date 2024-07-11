require 'find'

class Scanner
  attr_accessor :path

  def initialize(path = nil)
    begin
      @path = path
    rescue => e
      puts e.message
    end
  end

  def scann()
    files = []

    Find.find(@path) do |path|
      if File.file?(path)
        if path =~ /.*\.pdf$/i
          file_name = File.basename(path)
          files.push({
            file_name: file_name,
            document_number: get_document_number(file_name),
            document_type: file_name.split(' ')[0].match?(/^(oficio|of|memorandum|memo)$/i) ? file_name.split(' ')[0] : 'NE',
            file_path: path,
            responsible: path.split('/')[3],
            creation_date: File.birthtime(path).strftime("%d-%m-%Y")
          })
        end
      end
    end

    files
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
      puts e.message
    end
  end
end

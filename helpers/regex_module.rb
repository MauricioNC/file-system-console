module RegexModule
  def date (file_name = "", year = "2024")
    return nil if file_name.empty? || file_name.nil?

    file_name.split("_")[-1]
  end

  def document_type (file_name = "")
    return nil if file_name.empty? || file_name.nil?

    document_type_match = file_name.match(/^(oficio circular|oficio_circular|of. circular|of_circular|of circular|oficio|of|memorandum|memo|mem).*$/i)

    document_type_match.nil? ? "" : document_type_match[1].upcase
  end

  def filter_by_year(file_name = "", year = "2024")
    return nil if file_name.empty? || file_name.nil?

    date = date(file_name, year)
    date.include?(year)
  end
end

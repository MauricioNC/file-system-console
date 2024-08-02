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

    year_matched = nil

    case year
    when "2024"
      year_matched = file_name.match(/([\d]{2}[\-\s_][\d]{2}[\-\s_](2024|24))/)
    when "2023"
      year_matched = file_name.match(/([\d]{2}[\-\s_][\d]{2}[\-\s_](2023|23))/)
    when "2022"
      year_matched = file_name.match(/([\d]{2}[\-\s_][\d]{2}[\-\s_](2022|22))/)
    end

    year_matched.nil? ? "" : year_matched[0]
  end
end

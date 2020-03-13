class TokenizePackageDescriptionService
  LABEL_SYMBOL_MAPPINGS = {
    "Date/Publication" => :published_at,
    "Description" => :description,
    "Title" => :title,
    "Author" => :authors,
    # NOTE: Not intending to deal with this as part of the technical test
    # "Authors@R" => :author_data_structure,
    "Maintainer" => :maintainer,
  }

  def self.call(text)
    text = split_and_remerge(text)
    text = replace_labels_with_symbols(text)
    text = convert_values_to_correct_data_format(text)
    text
  end

  private_class_method def self.split_and_remerge(text)
    splitted = text.split("\n")
    result = {}
    label = nil
    (0..splitted.size - 1).each do |i|
      # Assumption: There will be no spaces in the labels, only characters and forward-slashes
      if splitted[i][/^[\w\/]*: /]
        # If a label is present, add to result of remerge
        divider_index = splitted[i].index(": ")
        label = splitted[i][0..divider_index-1]
        values = splitted[i][divider_index+1..-1].strip
        result[label] = values
      else
        # merge with previous line
        result[label] += " #{splitted[i].strip}"
      end
    end
    result
  end

  private_class_method def self.replace_labels_with_symbols(hash)
    hash.map do |k,v|
      next unless LABEL_SYMBOL_MAPPINGS[k]
      [LABEL_SYMBOL_MAPPINGS[k], v]
    end.compact.to_h
  end

  private_class_method def self.convert_values_to_correct_data_format(hash)
    hash.map do |k,v|
      case k
      when :published_at
        [k, Time.parse(v)]
      when :authors
        # TODO: Cases to handle include:
        # 1. Titles, i.e. My Name, Ph.D., Another Name, MSC
        # 2. Common pool of labels, i.e. Someone Important [aut, cre], Another Person [aut]
        # 3. ... I'm sure there's more
        authors = v.split(", ").map do |s|
          first_square_bracket_index = s.index(" [")
          if first_square_bracket_index
            s[0..first_square_bracket_index].strip
          else
            s.strip
          end
        end
        [k, authors]
      when :maintainer
        # For now, use simplistic approach of splitting, then removing extra ">"
        # This avoids unnecessarily losing data for processing "<"
        name, email = v.split(" <")
        email = email[0..-2]
        [k, [name, email]]
      else
        [k,v]
      end
    end.compact.to_h
  end
end

class Hash
  def flatten_keys(prefix="")
    keys = []
    self.keys.each do |key|
      keys << if self[key].is_a? Hash
        current_prefix = prefix + "#{key}."
        self[key].flatten_keys(current_prefix)
      else
        "#{prefix}#{key}"
      end
    end
    prefix == "" ? keys.flatten : keys
  end

  def parse(only_leaves = false, &block)
    each do |k,v|
      if v.is_a? Hash
        yield(k,v) unless only_leaves
        v.parse(only_leaves,&block)
      else
        yield(k,v)
      end
    end
  end

  def parse_leaves(&block)
    parse(only_leaves = true, &block)
  end

  def update_leaves!(&block)
    each do |k,v|
      if v.is_a? Hash
        v.update_leaves!(&block)
      else
        self[k] = yield(k,v)
      end
    end
  end

  def at(path)
    array_path = path.to_s.split('.')
    current_key = array_path.shift
    if array_path.empty?
      self[current_key]
    else
      self[current_key].at(array_path.join('.'))
    end
  end

end

# hash = { a: 1, b: { d: 2, e: [3, 4] }, c: {f: 0, g: 3} }
# hash = {"date"=>{"abbr_day_names"=>["Dom", "Lun", "Mar", "Mer", "Gio", "Ven", "Sab"], "abbr_month_names"=>[nil, "Gen", "Feb", "Mar", "Apr", "Mag", "Giu", "Lug", "Ago", "Set", "Ott", "Nov", "Dic"], "day_names"=>["Domenica", "Lunedì", "Martedì", "Mercoledì", "Giovedì", "Venerdì", "Sabato"], "formats"=>{"default"=>"%d-%m-%Y", "long"=>"%d %B %Y", "short"=>"%d %b"}, "month_names"=>[nil, "Gennaio", "Febbraio", "Marzo", "Aprile", "Maggio", "Giugno", "Luglio", "Agosto", "Settembre", "Ottobre", "Novembre", "Dicembre"], "order"=>[:day, :month, :year]}, "datetime"=>{"distance_in_words"=>{"about_x_hours"=>{"one"=>"circa un'ora", "other"=>"circa %{count} ore"}, "about_x_months"=>{"one"=>"circa un mese", "other"=>"circa %{count} mesi"}, "about_x_years"=>{"one"=>"circa un anno", "other"=>"circa %{count} anni"}, "almost_x_years"=>{"one"=>"circa 1 anno", "other"=>"circa %{count} anni"}, "half_a_minute"=>"mezzo minuto", "less_than_x_minutes"=>{"one"=>"meno di un minuto", "other"=>"meno di %{count} minuti"}, "less_than_x_seconds"=>{"one"=>"meno di un secondo", "other"=>"meno di %{count} secondi"}, "over_x_years"=>{"one"=>"oltre un anno", "other"=>"oltre %{count} anni"}, "x_days"=>{"one"=>"1 giorno", "other"=>"%{count} giorni"}, "x_minutes"=>{"one"=>"1 minuto", "other"=>"%{count} minuti"}, "x_months"=>{"one"=>"1 mese", "other"=>"%{count} mesi"}, "x_seconds"=>{"one"=>"1 secondo", "other"=>"%{count} secondi"}}, "prompts"=>{"day"=>"Giorno", "hour"=>"Ora", "minute"=>"Minuto", "month"=>"Mese", "second"=>"Secondi", "year"=>"Anno"}}, "errors"=>{"format"=>"%{attribute} %{message}", "messages"=>{"accepted"=>"deve essere accettata", "blank"=>"non può essere lasciato in bianco", "confirmation"=>"non coincide con la conferma", "empty"=>"non può essere vuoto", "equal_to"=>"deve essere uguale a %{count}", "even"=>"deve essere pari", "exclusion"=>"è riservato", "greater_than"=>"deve essere superiore a %{count}", "greater_than_or_equal_to"=>"deve essere superiore o uguale a %{count}", "inclusion"=>"non è incluso nella lista", "invalid"=>"non è valido", "less_than"=>"deve essere meno di %{count}", "less_than_or_equal_to"=>"deve essere meno o uguale a %{count}", "not_a_number"=>"non è un numero", "not_an_integer"=>"non è un intero", "odd"=>"deve essere dispari", "record_invalid"=>"Validazione fallita: %{errors}", "taken"=>"è già in uso", "too_long"=>{"one"=>"è troppo lungo (il massimo è 1 carattere)", "other"=>"è troppo lungo (il massimo è %{count} caratteri)"}, "too_short"=>{"one"=>"è troppo corto (il minimo è 1 carattere)", "other"=>"è troppo corto (il minimo è %{count} caratteri)"}, "wrong_length"=>{"one"=>"è della lunghezza sbagliata (deve essere di 1 carattere)", "other"=>"è della lunghezza sbagliata (deve essere di %{count} caratteri)"}}, "template"=>{"body"=>"Per favore ricontrolla i seguenti campi:", "header"=>{"one"=>"Non posso salvare questo %{model}: 1 errore", "other"=>"Non posso salvare questo %{model}: %{count} errori."}}}, "helpers"=>{"select"=>{"prompt"=>"Per favore, seleziona", "prompt_allow_nil"=>"Per favore, seleziona o lascia in binaco"}, "submit"=>{"create"=>"Crea %{model}", "submit"=>"Invia %{model}", "update"=>"Aggiorna %{model}", "cancel"=>"Annulla %{model}", "reset"=>"Cancella %{model}", "add"=>"Aggiungi %{model}"}, "links"=>{"new"=>"Nuovo %{model}", "add"=>"Aggiungi %{model}", "edit"=>"Modifica %{model}", "reset"=>"Reset", "back"=>"Indietro", "cancel"=>"Annulla", "confirm"=>"Sei sicuro?", "destroy"=>"Elimina %{model}", "show"=>"Visualizza %{model}"}, "titles"=>{"index"=>"Lista %{model}", "edit"=>"Modifica %{model}", "new"=>"Nuovo %{model}", "show"=>"Riepilogo %{model}"}, "tooltips"=>{"edit"=>"Modifica %{model}", "save"=>"Salva %{model}", "new"=>"Crea %{model}", "destroy"=>"Elimina %{model}", "back"=>"Torna alla lista", "show"=>"Visualizza %{model}", "add"=>"Aggiungi %{model}"}}, "sign_out"=>"Esci", "sign_in"=>"Accedi", "number"=>{"currency"=>{"format"=>{"delimiter"=>",", "format"=>"%n %u", "precision"=>2, "separator"=>".", "significant"=>false, "strip_insignificant_zeros"=>false, "unit"=>"€"}}, "format"=>{"delimiter"=>",", "precision"=>2, "separator"=>".", "significant"=>false, "strip_insignificant_zeros"=>false}, "human"=>{"decimal_units"=>{"format"=>"%n %u", "units"=>{"billion"=>"Miliardi", "million"=>"Milioni", "quadrillion"=>"Biliardi", "thousand"=>"Mila", "trillion"=>"Bilioni", "unit"=>""}}, "format"=>{"delimiter"=>"", "precision"=>1, "significant"=>true, "strip_insignificant_zeros"=>true}, "storage_units"=>{"format"=>"%n %u", "units"=>{"byte"=>{"one"=>"Byte", "other"=>"Byte"}, "gb"=>"GB", "kb"=>"KB", "mb"=>"MB", "tb"=>"TB"}}}, "percentage"=>{"format"=>{"delimiter"=>""}}, "precision"=>{"format"=>{"delimiter"=>""}}}, "support"=>{"array"=>{"last_word_connector"=>" e ", "two_words_connector"=>" e ", "words_connector"=>", "}}, "time"=>{"am"=>"am", "formats"=>{"default"=>"%a %d %b %Y, %H:%M:%S %z", "long"=>"%d %B %Y %H:%M", "short"=>"%d %b %H:%M"}, "pm"=>"pm"}, "gender_suffix"=>{"M"=>"o", "F"=>"a"}, "activemodel"=>{"errors"=>{"format"=>"%{attribute} %{message}", "messages"=>{"accepted"=>"deve essere accettata", "blank"=>"non può essere lasciato in bianco", "confirmation"=>"non coincide con la conferma", "empty"=>"non può essere vuoto", "equal_to"=>"deve essere uguale a %{count}", "even"=>"deve essere pari", "exclusion"=>"è riservato", "greater_than"=>"deve essere superiore a %{count}", "greater_than_or_equal_to"=>"deve essere superiore o uguale a %{count}", "inclusion"=>"non è incluso nella lista", "invalid"=>"non è valido", "less_than"=>"deve essere meno di %{count}", "less_than_or_equal_to"=>"deve essere meno o uguale a %{count}", "not_a_number"=>"non è un numero", "not_an_integer"=>"non è un intero", "odd"=>"deve essere dispari", "record_invalid"=>"Validazione fallita: %{errors}", "taken"=>"è già in uso", "too_long"=>{"one"=>"è troppo lungo (il massimo è 1 carattere)", "other"=>"è troppo lungo (il massimo è %{count} caratteri)"}, "too_short"=>{"one"=>"è troppo corto (il minimo è 1 carattere)", "other"=>"è troppo corto (il minimo è %{count} caratteri)"}, "wrong_length"=>{"one"=>"è della lunghezza sbagliata (deve essere di 1 carattere)", "other"=>"è della lunghezza sbagliata (deve essere di %{count} caratteri)"}}, "template"=>{"body"=>"Per favore ricontrolla i seguenti campi:", "header"=>{"one"=>"Non posso salvare questo %{model}: 1 errore", "other"=>"Non posso salvare questo %{model}: %{count} errori."}}}}, "activerecord"=>{"errors"=>{"format"=>"%{attribute} %{message}", "messages"=>{"accepted"=>"deve essere accettata", "blank"=>"non può essere lasciato in bianco", "confirmation"=>"non coincide con la conferma", "empty"=>"non può essere vuoto", "equal_to"=>"deve essere uguale a %{count}", "even"=>"deve essere pari", "exclusion"=>"è riservato", "greater_than"=>"deve essere superiore a %{count}", "greater_than_or_equal_to"=>"deve essere superiore o uguale a %{count}", "inclusion"=>"non è incluso nella lista", "invalid"=>"non è valido", "less_than"=>"deve essere meno di %{count}", "less_than_or_equal_to"=>"deve essere meno o uguale a %{count}", "not_a_number"=>"non è un numero", "not_an_integer"=>"non è un intero", "odd"=>"deve essere dispari", "record_invalid"=>"Validazione fallita: %{errors}", "taken"=>"è già in uso", "too_long"=>{"one"=>"è troppo lungo (il massimo è 1 carattere)", "other"=>"è troppo lungo (il massimo è %{count} caratteri)"}, "too_short"=>{"one"=>"è troppo corto (il minimo è 1 carattere)", "other"=>"è troppo corto (il minimo è %{count} caratteri)"}, "wrong_length"=>{"one"=>"è della lunghezza sbagliata (deve essere di 1 carattere)", "other"=>"è della lunghezza sbagliata (deve essere di %{count} caratteri)"}}, "template"=>{"body"=>"Per favore ricontrolla i seguenti campi:", "header"=>{"one"=>"Non posso salvare questo %{model}: 1 errore", "other"=>"Non posso salvare questo %{model}: %{count} errori."}}}}}

# puts hash.at('date.day_names')

# hash.parse{|k,v| puts "#{k} => #{v}"}
# puts
# hash.parse_leaves{|k,v| puts "#{k} => #{v}"}
# puts
# hash.parse(true){|k,v| puts "#{k} => #{v}"}
# puts
# hash.update_leaves!{|k,v| nil }

# puts hash

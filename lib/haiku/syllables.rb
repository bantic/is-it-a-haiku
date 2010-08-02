class Syllables
  class LookUpError < IndexError; end
  
  class << self
    def count(text)
      words_from_text(text).inject(0) {|sum, word| sum += count_word(word) }
    end
    
    def words_from_text(text)
      words = []

      text.gsub!("’","'")
      text.gsub!("--"," -- ")
      
      text.scan(/\b([a-z0-9][a-z\-']*)\b/i).each do |match|
        words.push match[0]
      end
      words
    end
    
    def count_word(word)
      word.upcase!
      
      if syllables = dictionary.fetch(word)
        return syllables
      elsif word =~ /'/
        word = word.delete "'"
        syllables = count_word(word)
      else
        syllables = Guesser.guess_word(word)
      end
      
      raise LookUpError unless syllables
      syllables
    end
    
    def dictionary
      @@db ||= Dictionary.new
    end
  end
  
  class Guesser
    # special cases - 1 syllable less than expected
    SubSyl = [
      /[^aeiou]e$/, # give, love, bone, done, ride ...
      /[aeiou](?:([cfghklmnprsvwz])\1?|ck|sh|[rt]ch)e[ds]$/,
      # (passive) past participles and 3rd person sing present verbs:
      # bared, liked, called, tricked, bashed, matched

      /.e(?:ly|less(?:ly)?|ness?|ful(?:ly)?|ments?)$/,
      # nominal, adjectival and adverbial derivatives from -e$ roots:
      # absolutely, nicely, likeness, basement, hopeless
      # hopeful, tastefully, wasteful

      /ion/, # action, diction, fiction
      /[ct]ia[nl]/, # special(ly), initial, physician, christian
      /[^cx]iou/, # illustrious, NOT spacious, gracious, anxious, noxious
      /sia$/, # amnesia, polynesia
      /.gue$/ # dialogue, intrigue, colleague
    ]

    # special cases - 1 syllable more than expected
    AddSyl = [
      /i[aiou]/, # alias, science, phobia
      /[dls]ien/, # salient, gradient, transient
      /[aeiouym]ble$/, # -Vble, plus -mble
      /[aeiou]{3}/, # agreeable
      /^mc/, # mcwhatever
      /ism$/, # sexism, racism
      /(?:([^aeiouy])\1|ck|mp|ng)le$/, # bubble, cattle, cackle, sample, angle
      /dnt$/, # couldn/t
      /[aeiou]y[aeiou]/ # annoying, layer
    ]

    # special cases not actually used - these seem to me to be either very
    # marginal or actually break more stuff than they fix
    NotUsed = [
      /^coa[dglx]./, # +1 coagulate, coaxial, coalition, coalesce - marginal
      /[^gq]ua[^auieo]/, # +1 'du-al' - only for some speakers, and breaks
      /riet/, # variety, parietal, notoriety - marginal?
    ]
    
    def self.guess_word(word)
      return 1 if word.length == 1
      word = word.downcase.delete("'")

      syllables = word.scan(/[aeiouy]+/).length

      # special cases
      for pat in SubSyl
        syllables -= 1 if pat.match(word)
      end
      for pat in AddSyl
        syllables += 1 if pat.match(word)
      end
      
      syllables = 1 if syllables < 1 # no vowels?
      syllables
    end
  end
end
module Weather
  class KeywordBuilder
    def self.skin_keywords_for(weather)
      results = []

      temperature = weather[:temp_current].to_f
      if temperature > 80.0
        results |= %w(dry moisture hydrate)
      elsif temperature >= 45.0
        results |= %w(cleanser)
      else
        results |= %w(hyaluronic\ acid moisturizer)
      end

      humidity = weather[:humidity].to_f
      if humidity < 40.0
        results |= %w(dry moisture hydrate)
      elsif humidity <= 60.0
        results |= %w(dry moisture hydrate)
      else
        results |= %w(serum emollient)
      end

      wind = weather[:wind].split(" ")[0].to_f
      if wind < 12.0
        results |= %w()
      elsif wind <= 24.0
        results |= %w(moisturizer)
      else
        results |= %w(moisturizer)
      end

      return results.sample(2).sort
    end

    def self.hair_keywords_for(weather)
      results = []

      temperature = weather[:temp_current].to_f
      if temperature > 80.0
        results |= %w(dry moisture hydrate)
      elsif temperature >= 45.0
        results |= %w()
      else
        results |= %w(cold weather dry moisture)
      end

      humidity = weather[:humidity].to_f
      if humidity < 40.0
        results |= %w(moisture dry)
      elsif humidity <= 60.0
        results |= %w()
      else
        results |= %w(humidity frizz hold)
      end

      wind = weather[:wind].to_f
      if wind < 12.0
        results |= %w()
      elsif wind <= 24.0
        results |= %w(hold setting detangler)
      else
        results |= %w(setting hold)
      end

      return results.sample(2).sort
    end

  end
end

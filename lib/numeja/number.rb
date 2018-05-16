module Numeja
  # Number class
  # @class private
  # @since 0.0.2
  class Number < DelegateClass(Integer)
    def initialize(str)
      @str = str
      super(parse)
    end

    private

    def parse
      nomarized = nomarize(@str)
      units = parse_large_numbers(nomarized)
      @result = units.reduce(0) do |t, unit|
        large_prefix = JA_上数[unit[:digit]]
        if large_prefix.nil?
          integer_part, decimal_part = split_digit(unit[:unit])
          int = integer_part.nil? ? 0 : parse_integer_part(integer_part)
          decimal = decimal_part.nil? ? 0 : parse_decimal_part(decimal_part)
          t += int + decimal
        else
          integer = parse_integer_part(unit[:unit])
          t += integer * large_prefix
        end
        t
      end
    end

    # Return numerals parts
    #
    # @return [Array<String>]
    #
    # @api private
    # @since 0.0.1
    def split_digit(str)
      i = str.index(/.分|.割/)
      if i.nil?
        [str]
      elsif i.zero?
        [nil, str]
      else
        [str[0..i - 1], str[i..-1]]
      end
    end

    # Return nomarized Kansuuji
    #
    # @return [::String]
    #
    # @api private
    # @since 0.0.1
    def nomarize(str)
      str
        .tr('０-９', '0-9')
        .gsub(REGEXP_旧字, JA_大字)
        .gsub(REGEXP_数字, JA_数字)
    end

    # Return nomarized Kansuuji
    #
    # @return [::String]
    #
    # @api private
    # @since 0.0.1
    def parse_integer_part(input)
      total = 0
      tmp = 0
      return input.to_i if input =~ /^[0-9]+$/
      input.gsub(REGEXP_数字, JA_数字).each_char do |s|
        unit_prefix = JA_下数[s]
        unless unit_prefix.nil?
          if tmp > 0
            total += tmp * unit_prefix
            tmp = 0
          else
            total += unit_prefix
          end
        end
        tmp += s.to_i
      end
      total + tmp
    end

    # Return parsed decimal part
    #
    # @return [Integer, Float]
    #
    # @api private
    # @since 0.0.1
    def parse_decimal_part(str)
      map = if str.index('割')
              Numeja::JA_割合用小数
            else
              Numeja::JA_小数
            end
      keys = map.keys()
      keys.reduce(0) do |t, ja_digit|
        index = str.index(ja_digit)
        break t if index.nil?
        unit = str.slice!(0, index)
        str.slice!(0, 1)
        t += (unit.to_f * map[ja_digit])
        t
      end
    end

    # Return large number parts
    #
    # @return [::Hash]
    #
    # @api private
    # @since 0.0.1
    def parse_large_numbers(str)
      # (?<year>(.*)億)(?<oku>(.*)万)
      splited = Numeja::JA_上数.keys.reverse.map do |ja_digit|
        index = str.index(ja_digit)
        next if index.nil?
        unit = str.slice!(0, index)
        digit = str.slice!(0, 1)
        {
          digit: digit,
          unit: unit
        }
      end
      splited.push(
        digit: '',
        unit: str
      ).compact
    end
  end
end
require 'numeja/version'

module Numeja
  JA_大字 = {
    '零' => '〇',
    '壱' => '一',
    '壹' => '一',
    '弌' => '一',
    '弐' => '二',
    '貳' => '二',
    '參' => '三',
    '貮' => '二',
    '弎' => '三',
    '参' => '三',
    '肆' => '四',
    '伍' => '五',
    '陸' => '六',
    '柒' => '七',
    '漆' => '七',
    '捌' => '八',
    '玖' => '九',
    '拾' => '十',
    '廿' => '二十',
    '卄' => '二十',
    '卅' => '三十',
    '丗' => '三十',
    '卌' => '四十',
    '陌' => '百',
    '佰' => '百',
    '阡' => '千',
    '仟' => '千',
    '萬' => '万'
  }.freeze

  JA_数字 = {
    '〇' => 0,
    '一' => 1,
    '二' => 2,
    '三' => 3,
    '四' => 4,
    '五' => 5,
    '六' => 6,
    '七' => 7,
    '八' => 8,
    '九' => 9
  }.freeze

  JA_下数 = {
    '十' => 10**1,
    '百' => 10**2,
    '千' => 10**3
  }.freeze

  JA_上数 = {
    '万' => 10**4,
    '億' => 10**8,
    '兆' => 10**12,
    '京' => 10**16,
    #  '垓': 10 ** 20,
    #  '秭': 10 ** 24,
    #  '𥝱': 10 ** 24,
    #  '穰': 10 ** 28,
    #  '溝': 10 ** 32,
    #  '澗': 10 ** 36,
    #  '正': 10 ** 40,
    #  '載': 10 ** 44,
    #  '極': 10 ** 48,
    #  '恒河沙': 10 ** 52,
    #  '阿僧祇': 10 ** 56,
    #  '那由他': 10 ** 60,
    #  '不可思議': 10 ** 64,
    #  '無量大数': 10 ** 68
  }.freeze

  JA_小数 = {
    '分' => 10**-1,
    '厘' => 10**-2,
    '毛' => 10**-3,
    '糸' => 10**-4,
    '忽' => 10**-5,
    '微' => 10**-6,
    '繊' => 10**-7,
    '沙' => 10**-8,
    '塵' => 10**-9,
    '埃' => 10**-10
  }.freeze

  JA_割合用小数 = {
    '割' => 10**-1,
    '分' => 10**-2,
    '厘' => 10**-3,
    '毛' => 10**-4,
    '糸' => 10**-5,
    '忽' => 10**-6,
    '微' => 10**-7,
    '繊' => 10**-8,
    '沙' => 10**-9,
    '塵' => 10**-10
  }.freeze
  REGEXP_旧字 = Regexp.new(Numeja::JA_大字.keys.join('|').to_s, 'g').freeze
  REGEXP_数字 = Regexp.new(Numeja::JA_数字.keys.join('|').to_s, 'g').freeze

  class << self
    # Return a numeric of the parsed japanese numerals string
    #
    # @param input [String] Japanese numerals(KanSuuji)
    #
    # @return [Integer, Float] the parsed Japanese numerals
    #
    # @since 0.0.1
    #
    # @example
    #   require 'numeja'
    #
    #   Numeja.numerize('二千三百八十一億九千四百八十七万六千三百十一') =>  238_194_876_311
    #   Numeja.numerize('弐阡參佰捌拾壱億九千四百八十七万六千三百十一') =>  238_194_876_311
    #   Numeja.numerize('9876億5432万1千2百3十4') => 987_654_321_234)
    #   Numeja.numerize('９８７６億５４３２万１千２百３十４') => 987_654_321_234
    #   Numeja.numerize('玖阡捌陌漆拾陸億伍仟肆佰參十貳万壹千弐百卅４') => 987_654_321_234
    #   Numeja.numerize('５０５') => 505
    #   Numeja.numerize('九八七六五四三二一零') => 9_876_543_210
    #   Numeja.numerize('九分八厘七毛六糸五忽四微三繊二沙零塵一埃') => 0.9876543201)
    #   Numeja.numerize('九割八分七厘六毛五糸四忽三微二繊零沙一塵') => 0.9876543201)
    def numerize(str)
      nomarized = nomarize(str)
      units     = parse_large_numbers(nomarized)
      units.reduce(0) do |t, unit|
        large_prefix = JA_上数[unit[:digit]]
        if large_prefix.nil?
          integer_part, decimal_part = split_digit(unit[:unit])
          int                        = integer_part.nil? ? 0 : parse_integer_part(integer_part)
          decimal                    = decimal_part.nil? ? 0 : parse_decimal_part(decimal_part)
          t += int + decimal
        else
          integer = parse_integer_part(unit[:unit])
          t += integer * large_prefix
        end
        t
      end
    end

    private

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
      tmp   = 0
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
        unit  = str.slice!(0, index)
        digit = str.slice!(0, 1)
        {
          digit: digit,
          unit:  unit
        }
      end
      splited.push(
        digit: '',
        unit:  str
      ).compact
    end
  end
end

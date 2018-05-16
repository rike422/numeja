require 'numeja/version'
require 'delegate'
require 'numeja/number'

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
    #   Numeja.numerize('九分八厘七毛六糸五忽四微三繊二沙零塵一埃') => 0.9876543201
    #   Numeja.numerize('九割八分七厘六毛五糸四忽三微二繊零沙一塵') => 0.9876543201
    #   Numeja.numerize('二分の一') => 0.5
    #   Numeja.numerize('三分の一') => 0.33333333333...
    def numerize(str)
      if str.index('分の').nil?
        Numeja::Number.new(str)
      else
        denominator, molecule = str.split('分の').map { |s| Numeja::Number.new(s) }
        molecule.to_f / denominator.to_f
      end
    end
  end
end

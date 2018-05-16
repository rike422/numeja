require 'test_helper'

class TestNumeja < Test::Unit::TestCase
  test '#numerize' do
    assert_equal(Numeja.numerize('二千三百八十一億九千四百八十七万六千三百十一'), 238_194_876_311)
    assert_equal(Numeja.numerize('弐阡參佰捌拾壱億九千四百八十七万六千三百十一'), 238_194_876_311)
    assert_equal(Numeja.numerize('9876億5432万1千2百3十4'), 987_654_321_234)
    assert_equal(Numeja.numerize('９８７６億５４３２万１千２百３十４'), 987_654_321_234)
    assert_equal(Numeja.numerize('玖阡捌陌漆拾陸億伍仟肆佰參十貳万壹千弐百卅４'), 987_654_321_234)
    assert_equal(Numeja.numerize('５０５'), 505)
    assert_equal(Numeja.numerize('九八七六五四三二一零'), 9_876_543_210)
  end

  sub_test_case 'support decimal part' do
    test 'return float value' do
      assert_equal(Numeja.numerize('百十一一分一厘'), 111.11)
      assert_equal(Numeja.numerize('9分3厘六毛肆糸'), 0.9364)
      assert_equal(Numeja.numerize('三割五分四厘一毛'), 0.3541)
      assert_equal(Numeja.numerize('九分八厘七毛六糸五忽四微三繊二沙零塵一埃'), 0.9876543201)
      assert_equal(Numeja.numerize('九割八分七厘六毛五糸四忽三微二繊零沙一塵'), 0.9876543201)
      assert_equal(Numeja.numerize('二分の一'), 0.5)
      assert_equal(Numeja.numerize('三分の一'), 1.to_f / 3.to_f)
    end
  end
end

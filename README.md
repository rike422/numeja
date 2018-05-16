# Numeja  [![Gem Version](https://badge.fury.io/rb/numeja.svg)](https://badge.fury.io/rb/numeja) [![Build Status](https://travis-ci.org/rike422/numeja.svg?branch=master)](https://travis-ci.org/rike422/numeja)  [![Code Climate](https://codeclimate.com/github/rike422/numeja/badges/gpa.svg)](https://codeclimate.com/github/rike422/numeja) [![Coverage Status](https://coveralls.io/repos/github/rike422/numeja/badge.svg?branch=master)](https://coveralls.io/github/rike422/numeja?branch=master)
           
Parse numbers in japanese numerals from String

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'numeja'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ima

## Usage

```ruby
require 'numeja'

Numeja.numerize('二千三百八十一億九千四百八十七万六千三百十一') # =>  238_194_876_311
Numeja.numerize('弐阡參佰捌拾壱億九千四百八十七万六千三百十一') # =>  238_194_876_311
Numeja.numerize('9876億5432万1千2百3十4') # => 987_654_321_234)
Numeja.numerize('９８７６億５４３２万１千２百３十４') # => 987_654_321_234
Numeja.numerize('玖阡捌陌漆拾陸億伍仟肆佰參十貳万壹千弐百卅４') # => 987_654_321_234
Numeja.numerize('５０５') #  => 505
Numeja.numerize('九八七六五四三二一零') # => 9_876_543_210
Numeja.numerize('九分八厘七毛六糸五忽四微三繊二沙零塵一埃') # => 0.9876543201
Numeja.numerize('九割八分七厘六毛五糸四忽三微二繊零沙一塵') # => 0.9876543201

```

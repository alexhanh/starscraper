## Example
```ruby
pp Starscraper.profile('http://eu.battle.net/sc2/en/profile/1517403/1/boom/')

{"1v1_league"=>"Silver",
 "1v1_rank"=>28,
 "2v2_league"=>nil,
 "3v3_league"=>nil,
 "4v4_league"=>nil}
```

```ruby
pp Starscraper.profile('http://eu.battle.net/sc2/en/profile/doesnt_exist')

nil
```


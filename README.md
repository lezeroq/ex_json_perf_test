## Elixir json serializers performance test

Run
```sh
$ mix deps.get
$ mix deps.compile
$ iex -S mix
iex(1)> JT.run
Test Poison
# 'small.json'                        0.2Kb    1000000 times     11.386/13.187        100.0%    100.0%  (decode/encode seconds and %)
# 'big_list.json'                    33.9Kb       1000 times      2.667/3.034         100.0%    100.0%  (decode/encode seconds and %)
# 'big_dict.json'                    58.3Kb       1000 times      6.248/3.833         100.0%    100.0%  (decode/encode seconds and %)
# 'big.json'                        687.5Kb        100 times      1.989/1.224         100.0%    100.0%  (decode/encode seconds and %)
# 'long_strings.json'                89.1Kb       1000 times      2.661/4.327         100.0%    100.0%  (decode/encode seconds and %)

Test :jiffy
# 'small.json'                        0.2Kb    1000000 times      3.417/4.102          30.0%     31.1%  (decode/encode seconds and %)
# 'big_list.json'                    33.9Kb       1000 times      0.557/1.116          20.9%     36.8%  (decode/encode seconds and %)
# 'big_dict.json'                    58.3Kb       1000 times      3.722/1.945          59.6%     50.7%  (decode/encode seconds and %)
# 'big.json'                        687.5Kb        100 times      1.187/0.277          59.7%     22.7%  (decode/encode seconds and %)
# 'long_strings.json'                89.1Kb       1000 times      0.251/0.369           9.4%      8.5%  (decode/encode seconds and %)

Test JSON
# 'small.json'                        0.2Kb    1000000 times     16.564/20.448        145.5%    155.1%  (decode/encode seconds and %)
# 'big_list.json'                    33.9Kb       1000 times      5.665/3.886         212.4%    128.1%  (decode/encode seconds and %)
# 'big_dict.json'                    58.3Kb       1000 times     20.134/10.832        322.3%    282.6%  (decode/encode seconds and %)
# 'big.json'                        687.5Kb        100 times      8.432/3.870         423.9%    316.2%  (decode/encode seconds and %)
# 'long_strings.json'                89.1Kb       1000 times      3.930/4.956         147.7%    114.6%  (decode/encode seconds and %)

All tests are complete
```
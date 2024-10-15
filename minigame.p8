pico-8 cartridge // http://www.pico-8.com
version 42
__lua__

#include minigame.lua
__gfx__
00000000222222220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000211111120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000212222120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000212112120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000212112120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000212222120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000211111120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000222222220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eeeeeeeeeeeeeeee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ee0000eece0000ee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c000000ea000000e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a000000ee00a0c0e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e00a0c0ee000000e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e000000ee000000e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ee0000eeee0000ee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eeeeeeeeeeeeeeee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00cccc0000cccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0caaa7c00caaa7c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
caaaaa7ccaaaaa7c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
caaaaaaccaaaaaac0099999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ca5a5a5cc5a5a5ac0944444490000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
caaaaaaccaaaaaac0099999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0caaaac00caaaac00009999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00cccc0000cccc000000990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0002000000000000000000000000000001010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000001010001010001010000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000001010001010001010000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000001000000000000000001010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000001010000000000000000010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0100000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0101010101010101010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
151000000e0300e032356130e0350e0350e03516043100301003510035356130c0000e0300e030160430e0300e0300e032356130e0320e0320e03200000000000000000000000000000000000000000000000000
0d1000001c0341c0301c0351c0350c0000c0001d0301d0301d0341d0301d0301d0321d0341d0351d0351d0351f0341f0301f0351f0350c0000c0001d0301d0301d0341d0301d0301d0321d0341d0321d0321d032
15100000160430c0300c0350c035356130c0000e0300e030160430e0300e0300e032356130e0350e0350e03516043100301003510035356130c0000f0300f035160430e0300e0300e032356130e0320e0320e032
0d1000001c0341c0301c0351c0350c0000c0001d0301d0301d0341d0301d0301d0321d0341d0351d0351d0351f0341f0301f0351f0350c0001e0001e0301e0351d0341d0301d0301d0321d0341d0321d0321d032
051000002874428743007002a7002b7402b7432b7002b7002474424740247402474026741267422674226745287412874026740267402474024745217451f7401f7401f7401f7421f7421f7351f7352174524755
05100000007000070028740287432a7002b7412b7402b74024744247402474024743267402674026740267452874128740267402674024740247452d7452b7402b7402b7422b7422b7422b743000001f0001f000
15100000160430c0300c0350c035356130c0000e0300e030160430e0300e0300e032356130e0350e0350e03516043100301003510035356130c0000f0300f035160430e0300e0300e03235613100351003210033
0d1000001c0341c0301c0351c0350c0000c0001d0301d0301d0341d0301d0301d0321d0341d0351d0351d0351f0341f0301f0351f0350c0001e0001e0301e0351d0341d0301d0301d0321f0341f0352003220033
1510000016043110301103511035356130c0001303013030160431303013030130303561313035130351303516043100301003510035356130c00015030150301604315030150301503235613150321503215032
0d100000210342103021035210350c0000c0001c0301c0301a0341a0301a0301c0311c0341c0351a0351a0351f0341f0301f0351f0350c0000c00018030180301803418030180301803218034180321803218032
0510000024700187002b7402b7432d7402174528741287402b7412b7402b7402d7412d7402d7402b7402b74300700007002b740297402874029740260002874128740267402674224742247421f7451f7421f743
0510000024700247002474426740267402674028740287402b7412b7402b7401f7452b74529740287402674524730267302b7402d7402b74028740267302874228733247302673224722217221f732217551f755
0510000024744247402474326741267402674528740287432b7442b7402b7402d7412d7402d7402b7402b74300700007002b7402b7432d7402f74000000307403074030730307323072230722307123074532745
151000003561310040100351000016043110401104311000356131204012043130301604313030130351303535613130321303213032160431302213022130223561313012130121301500000000000000000000
151000001d0341d0321d0331d0001c0441c0421c0351c000150341504215043000001a0311a0321a0331803018032180321803218032180321803218032180321802218022180221802218012180121801218015
051000003573435730357332670034734347303473328700307343073030733217002d7312d7302d7352b7302b7302b7302b7302b7302b7322b7222b7222b7222b7222b7222b7222b7122b7122b7122b7122b715
15100000160430c0300c0350c035356130c0000e0300e030160430e0300e0300e032356130e0350e0350e03516043100301003510035356130c0000e0300e030160430e0300e0300e032356130e0320e0320e032
15100000160430e0300e0330e00035613100401003510000160431104011043110003561312040120431303016043130301303513035356131303213032130321604313022130221302235613130121301213015
__music__
01 10015355
00 02030553
00 10010454
00 02030555
00 10010454
00 06070555
00 08090a55
00 08090b55
00 08090c55
02 110e0f55


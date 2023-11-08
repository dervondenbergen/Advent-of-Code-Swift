/// Day 8: Seven Segment Search

import Foundation
import Helpers

"""
be
edb
cfbegad
cbdgef
fgaecd
cgeb
fdcge
agebfd
fecdb
fabcd
"""


/*
 be         -> 1
 edb        -> 7 => d ist oben
 cgeb       -> 4 => cg ist links oben und mitte
 cfbegad    -> 8
 fabcd      -> 2? -> 2 => a ist links unten
 fdcge      -> 3? -> 5 => e ist rechts unten und f ist unten und b ist rechts oben
 fecdb      -> 5? -> 3 => g ist links oben und c ist mitte
 cbdgef     -> 0? -> 9
 fgaecd     -> 6? -> 6
 agebfd     -> 9? -> 0
 */

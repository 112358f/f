module Repa.Gravity
      (applyGravity)
where

import Data.Bits
import Common.World

-- Black magic for gravity
-- Possible values:
--
--  L liquid      C0
--  L liq, focus  C1
--  ~ liq, space  40
--  ~ liqspace f  41
--
--  * non-focused 80
--  * focused     81
--  ~ non-focused 00
--  ~ focused     01
applyGravity :: WeightEnv -> MargPos
applyGravity wenv = case wenv of
  -- L L --> L L
  -- L ~     ~ L
  0x01C0C0C0 -> 2
  0x00C1C0C0 -> 3
  0x41C0C0C0 -> 2
  0x40C1C0C0 -> 3
  0x40C0C1C0 -> 1
  0x00C0C1C0 -> 1
  0x40C0C0C1 -> 0
  0x00C0C0C1 -> 0
  -- L L --> L L
  -- ~ L     L ~
  0xC001C0C0 -> 3
  0xC100C0C0 -> 2
  0xC041C0C0 -> 3
  0xC140C0C0 -> 2
  0xC040C1C0 -> 1
  0xC000C1C0 -> 1
  0xC040C0C1 -> 0
  0xC000C0C1 -> 0
  -- L ~ --> ~ L
  -- * *     * *
  0x808000C1 -> 1
  0x808001C0 -> 0
  0x808040C1 -> 1
  0x808041C0 -> 0
  0x80C000C1 -> 1
  0x80C001C0 -> 0
  0x80C040C1 -> 1
  0x80C041C0 -> 0
  0xC08000C1 -> 1
  0xC08001C0 -> 0
  0xC08040C1 -> 1
  0xC08041C0 -> 0
  0xC0C000C1 -> 1
  0xC0C001C0 -> 0
  0xC0C040C1 -> 1
  0xC0C041C0 -> 0
  -- ~ L --> L ~
  -- * *     * *
  0x8080C100 -> 0
  0x8080C001 -> 1
  0x8080C140 -> 0
  0x8080C041 -> 1
  0x80C0C100 -> 0
  0x80C0C001 -> 1
  0x80C0C140 -> 0
  0x80C0C041 -> 1
  0xC080C100 -> 0
  0xC080C001 -> 1
  0xC080C140 -> 0
  0xC080C041 -> 1
  0xC0C0C100 -> 0
  0xC0C0C001 -> 1
  0xC0C0C140 -> 0
  0xC0C0C041 -> 1
  -- ~ ~ --> ~ ~
  -- L ~     ~ L
  0x00C10000 -> 3
  0x01C00000 -> 2
  0x40C10000 -> 3
  0x41C00000 -> 2
  0x00C14000 -> 3
  0x01C04000 -> 2
  0x40C14000 -> 3
  0x41C04000 -> 2
  0x00C10040 -> 3
  0x01C00040 -> 2
  0x40C10040 -> 3
  0x41C00040 -> 2
  0x00C14040 -> 3
  0x01C04040 -> 2
  0x40C14040 -> 3
  0x41C04040 -> 2
  -- ~ ~ --> ~ ~
  -- ~ L     L ~
  0xC1000000 -> 2
  0xC0010000 -> 3
  0xC1400000 -> 2
  0xC0410000 -> 3
  0xC1004000 -> 2
  0xC0014000 -> 3
  0xC1404000 -> 2
  0xC0414000 -> 3
  0xC1000040 -> 2
  0xC0010040 -> 3
  0xC1400040 -> 2
  0xC0410040 -> 3
  0xC1004040 -> 2
  0xC0014040 -> 3
  0xC1404040 -> 2
  0xC0414040 -> 3
  _ -> case (wenv .&. 0x81818181) of
    -- * ~ --> ~ ~
    -- ~ ~     * ~
    0x00000081 -> 2
    0x00010080 -> 0
    -- * * --> * ~
    -- * ~     * *
    0x00808180 -> 3
    0x01808080 -> 1
    -- * * --> ~ ~
    -- ~ ~     * *
    0x00008081 -> 2
    0x00008180 -> 3
    0x00018080 -> 0
    0x01008080 -> 1
    -- ~ * --> ~ ~
    -- * ~     * *
    0x00808100 -> 3
    0x01808000 -> 1
    -- ~ * --> ~ ~
    -- ~ ~     ~ *
    0x00008100 -> 3
    0x01008000 -> 1
    -- * * --> ~ *
    -- ~ *     * *
    0x80008081 -> 2
    0x80018080 -> 0
    -- * ~ --> ~ ~
    -- ~ *     * *
    0x80000081 -> 2
    0x80010080 -> 0
    -- * ~ --> ~ ~
    -- * ~     * *
    0x00800081 -> 3
    0x01800080 -> 0
    -- ~ * --> ~ ~
    -- ~ *     * *
    0x80008100 -> 2
    0x80018000 -> 1

    x -> case x .&. 0x01010101 of
      0x01000000 -> 3
      0x00010000 -> 2
      0x00000100 -> 1
      0x00000001 -> 0


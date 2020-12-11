grep -iRl debug ./ > a && grep -iRl //debug ./ > b && diff a b && rm a b

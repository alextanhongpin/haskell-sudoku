main :: IO()
main = do
  let torus = linkTorus [1,2,3]
  print $ take 10 $ takeF torus

mkTorus :: (Torus, Int, Torus) -> Torus
mkTorus (prev, i, next) = Node { left = prev, right = next, value = i }

linkTorus :: [Int] -> Torus
linkTorus xs = let (first, last) = go last xs first
               in first
  where
      go :: Torus -> [Int] -> Torus -> (Torus, Torus)
      go prev [] next = (next, prev)
      go prev (x:xs) next = let this = mkTorus (prev, x, rest)
                                (rest, last) = go this xs next
                            in
                              (this, rest)

data Torus = Node { left :: Torus
                  , right :: Torus
                  , value :: Int
                  }
           | Empty deriving (Show)

takeF :: Torus -> [Int]
takeF Node { right = Empty } = []
takeF Node { right = right, value = value } = [value] ++ takeF right
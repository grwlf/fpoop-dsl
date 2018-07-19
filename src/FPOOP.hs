module FPOOP where

import Data.Map as Map

{-
    Public and private fields and methods

    class Foo {
      pribate:
        int zoo;
        void foo(int x) { zoo = x; } ;
      public:
        Foo() { foo(33); }
        void bar(int x) { foo(x); return this->zoo; }
    };

-}

type Object = Int
type Offset = Int
type Memory = Map (Object,Offset) Int

data Foo = Foo {
    this :: Object
  , bar :: Memory -> Foo -> Int -> (Memory,Int)
  }


mkFoo :: Memory -> (Memory,Foo)
mkFoo mem =
  let
    zoo_offset = 0

    foo :: Memory -> Object -> Int -> Memory
    foo m o x = Map.insert (o, zoo_offset) x m

    new :: Object
    new = 0 -- FIXME: (max mem) + 1
  in
  ( foo mem new 33
  , Foo new $ \m o zoo' ->
       let
         mem' = foo m (this o) zoo'
       in
       (mem', mem' Map.! (this o, zoo_offset) )
  )



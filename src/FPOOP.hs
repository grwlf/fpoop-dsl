{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE MultiParamTypeClasses #-}

module FPOOP where

import Data.Map as Map

{-
 ____       _            _         _____ _      _     _
|  _ \ _ __(_)_   ____ _| |_ ___  |  ___(_) ___| | __| |___
| |_) | '__| \ \ / / _` | __/ _ \ | |_  | |/ _ \ |/ _` / __|
|  __/| |  | |\ V / (_| | ||  __/ |  _| | |  __/ | (_| \__ \
|_|   |_|  |_| \_/ \__,_|\__\___| |_|   |_|\___|_|\__,_|___/


    class Foo {
      pribate:
        int _x;
        void g(int x) { _x = x; } ;
      public:
        Foo() { g(33); }
        void f(int x) { g(x); return this->_x; }
    };

-}

type Object = Int
type Offset = Int
type Memory = Map (Object,Offset) Int

data Foo = Foo {
    foo_this :: Object
  , foo_f :: Memory -> Object -> Int -> (Memory,Int)
  }


mkFoo :: Memory -> (Memory,Foo)
mkFoo mem0 =
  let
    x_offset = 0

    g :: Memory -> Object -> Int -> Memory
    g mem this x = Map.insert (this,x_offset) x mem

    new :: Object
    new = 0 -- FIXME: (max mem) + 1
  in
  ( g mem0 new 33
  , Foo new $ \mem this x ->
       let
         mem' = g mem this x
       in
       (mem', mem' Map.! (this, x_offset) )
  )


{-
__     ___      _               _                  _   _               _
\ \   / (_)_ __| |_ _   _  __ _| |  _ __ ___   ___| |_| |__   ___   __| |___
 \ \ / /| | '__| __| | | |/ _` | | | '_ ` _ \ / _ \ __| '_ \ / _ \ / _` / __|
  \ V / | | |  | |_| |_| | (_| | | | | | | | |  __/ |_| | | | (_) | (_| \__ \
   \_/  |_|_|   \__|\__,_|\__,_|_| |_| |_| |_|\___|\__|_| |_|\___/ \__,_|___/

    class Bar {
      public:
        virtual bar(int x) = 0;
    };

    class Baz : public Bar {
        int _x;
      public:
        virtual bar(int x) { _x = x; }
    };

    class Bax : public Bar {
        int _y;
      public:
        virtual bar(int x) { _y = x; }
    };

-}

{-
class Inherits a b where
  parent :: a -> b


data Bar = Bar {
    bar_this :: Object
    bar_child :: Object
  , bar_f :: Memory -> Bar -> Int -> (Memory,Int)
  }

data Baz = Baz {
    baz_this :: Object
  , baz_bar :: Bar
  , baz_f :: Memory -> Baz -> Int -> (Memory,Int)
  }

data Bax = Bax {
    bax_this :: Object
  , bax_bar :: Bar
  , bax_f :: Memory -> Baz -> Int -> (Memory,Int)
  }

instance Inherits Baz Bar where
  parent Baz{..} = baz_bar

mkBaz :: Memory -> (Memory,Baz)
mkBaz mem =
  let
    new :: Object
    new = 1 -- FIXME: (max mem) + 1


    baz_f :: Memory -> Baz -> Int -> Memory
    baz_f m baz
  in
  ( foo mem new 33
  , Foo new $ \m o zoo' ->
       let
         mem' = foo m (this o) zoo'
       in
       (mem', mem' Map.! (this o, zoo_offset) )
  )
-}

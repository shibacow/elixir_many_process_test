#!/bin/bash

mix escript.build
export ELIXIR_ERL_OPTIONS="+P 50000000" 
#iex --sname bar@localhost --cookie foo -S mix run -e "ManyProcessFactory.main" 

#./many_process --pnum=10000
iex --sname bar@localhost --cookie foo -S mix 

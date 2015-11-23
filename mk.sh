#!/bin/bash
export ELIXIR_ERL_OPTIONS="+P 100000"
#iex --sname bar@localhost --cookie foo -S mix run -e "ManyProcessFactory.main/1"  pname=1
mix escript.build
./many_process --pnum=100000

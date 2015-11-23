#!/bin/bash
export ELIXIR_ERL_OPTIONS="+P 1000000"
iex --sname bar@localhost --cookie foo -S mix run -e "ManyProcessFactory.main"


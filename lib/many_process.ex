defmodule ManyProcess do
	def start_link(id) do
		{:ok,spawn_link(fn -> loop(id,%{}) end)}
	end
	def loop(id,map) do
		receive do
			{:get,key,caller}->
				IO.puts "send id=#{id} key=#{key}"
				send caller,Map.get(map,key)
				loop(id,map)
			{:put,key,value}->
				loop(id,Map.put(map,key,value))
		end
	end
end

defmodule ManyProcessFactory do
	def generate(n) do
		#1..10|> ManyProcess.start_link
		Enum.map(1..n,fn(x) -> ManyProcess.start_link(x) end)
	end
	def main do
		pid = spawn_link(fn -> loop() end)
		outs = generate(600_000) |> Enum.map(fn({:ok,x})->
			send x,{:put,'a','b'} 
			{:ok,x}
		end)
		outs |> Enum.map(fn({:ok,x})->
			send x,{:get,'a',pid}
		end)
	end
	def loop() do
		receive do
			{_}->
				IO.puts "nothcing todo"
				loop()
		end
	end
end


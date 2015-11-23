defmodule ManyProcess do
	def start_link(id) do
		{:ok,spawn_link(fn -> loop(id,%{}) end)}
	end
	def loop(id,map) do
		receive do
			{:get,key,caller}->
				if rem(id,10000) == 0 do
					IO.puts "send id=#{id} key=#{key}"
				end
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
  defp parse_args(args) do
    {options, _, _} = OptionParser.parse(args,
																				 strict: [pnum: :integer]
    )
    options
  end
	def main(args) do
		opt=parse_args(args)
		pnum=opt[:pnum]
		plimit = :erlang.system_info(:process_limit)
		IO.puts "set pnum=#{pnum} process_limit=#{plimit}"
		pid = spawn_link(fn -> loop() end)
		outs = generate(pnum) |> Enum.map(fn({:ok,x})->
			send x,{:put,'a','b'} 
			{:ok,x}
		end)
		outs |> Enum.map(fn({:ok,x})->
			send x,{:get,'a',pid}
		end)
		:timer.sleep(:infinity)
	end
	def loop() do
		receive do
			{_}->
				IO.puts "nothcing todo"
				loop()
		after 
		10_000 -> 
			psize = Enum.count(:erlang.processes)
			IO.puts "process size = #{psize}"
			loop()
		end
	end
end


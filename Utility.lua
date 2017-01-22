require 'math'

local Utility = {}

-- Input: width, height, total_number n, container to store the numbers
function Utility.randomControl(w, h, n)
    local container = {}
	-- Take a grid, generate random number in each grid
    -- nsq = math.floor( math.sqrt(n) )
    count = 1
    for i=1,n do
    	for j=1,n do
    		if math.random() < 0.3 and count <= n then
		    	local x = math.random( (w / n) * (i - 1), (w / n) * i) 
		    	local y = math.random( (h / n) * (j - 1), (h / n) * j)
		    	container[count] = {x, y}
		    	count = count + 1
	    	end
    	end
    end

    return container
end

return Utility
--//Services//--
local Players = game:GetService("Players")
--//End of "Services"//--



--//Misc.//--

--//End of "Misc."//--



--//Arrays//--
local Service = {}
--//End of "Arrays"//--



--//Main Functions//--
local function PageItems(
	pages
) -- Stole from ROBLOX
	return coroutine.wrap(function()
		local pagenum = 1
		while true do
			for _, item in ipairs(pages:GetCurrentPage()) do
				coroutine.yield(item, pagenum)
			end
			if pages.IsFinished then
				break
			end
			pages:AdvanceToNextPageAsync()
			pagenum = pagenum + 1
		end
	end)
	
end

local function __Filter(
	Input, Filter
)
	Filter = table.clone(Filter)
	for Element, _ in pairs(Filter) do
		assert(Input[Element] ~= nil, "Tried Filtering a Non-Existing Element: " .. Element)
		if Input[Element] then
			Filter[Element] = Input[Element]
			
		end
		
	end
	return
		Filter
	
end
--//End of "Main Functions"//--



--//Main//--
function Service:GetFriends(
	Input, Filter
)
	local userId: number
	if type(Input) == "string" then
		userId = Players:GetUserIdFromNameAsync(Input)
		
	else
		userId = Input
		
	end
	local FriendPages = Players:GetFriendsAsync(userId)
	local PageItems = PageItems(FriendPages)
	
	local Constructed = {}
	
	--task.desynchronize()
	for item, pageNo in PageItems do
		local Filtered = __Filter(item, Filter)
		table.insert(Constructed, Filtered)
		
	end
	--task.synchronize()
	gcinfo() -- Collect All NonUsed Memories.
	
	return
		Constructed
end
--//End of "Main"//--



--//Connections//--
return 
	Service
--//End of "Connections"//--

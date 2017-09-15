-- polygon area

stage = display.getCurrentStage()
sWidth, sHeight = display.contentWidth, display.contentHeight

grid = display.newGroup()
lines = display.newGroup()
points = display.newGroup()

text = display.newText("Area: 0", sWidth/2, 50, native.systemFont, 72)

-- calculates the area of a polygon
-- will not calculate area for intersecting polygons (where vertices cross each other)
-- can accept a table of {x,y} or a display group
-- ref: http://www.mathopenref.com/coordpolygonarea2.html
function polygonArea( points )
	local count = #points
	if (points.numChildren) then
		count = points.numChildren
	end
	
	local area = 0 -- Accumulates area in the loop
	local j = count -- The last vertex is the 'previous' one to the first
	
	for i=1, count do
		area = area +  (points[j].x + points[i].x) * (points[j].y - points[i].y)
		j = i -- j is previous vertex to i
	end
	
	return math.abs(area/2)
end

function drawGrid()
	for i=0, 1000, 100 do
		local row = display.newLine(grid,0,i,sWidth,i)
		row.width = 10
		row:setColor(50,50,50)
		local col = display.newLine(grid,i,0,i,sHeight)
		col.width = 10
		col:setColor(50,50,50)
	end
end
drawGrid()

-- draw polygon with the form {x,y},{x,y},...}
function drawLines()
	p = points.numChildren
	
	for i=lines.numChildren, 1, -1 do
		lines[i]:removeSelf()
	end
	
	for i=1, points.numChildren do
		local line = display.newLine(lines, points[p].x, points[p].y, points[i].x, points[i].y)
		line.width = 10
		line:setColor(0,0,255)
		p = i
	end
	
	local area = polygonArea( points )
	text.text = "Area: "..(area/1000)
end

function tap(e)
	local point = display.newCircle(points,e.x,e.y,25)
	point:setFillColor(0,255,0)
	drawLines()
	
	function point:touch(e)
		if (e.phase == "began") then
			stage:setFocus(e.target)
		elseif (e.phase == "ended") then
			stage:setFocus(nil)
		end
		
		point.x, point.y = e.x, e.y
		drawLines()
		
		return true
	end
	point:addEventListener("touch",point)
	
	function point:tap(e)
		e.target:removeSelf()
		drawLines()
		return true
	end
	point:addEventListener("tap",point)
	
	return true
end
Runtime:addEventListener("tap",tap)

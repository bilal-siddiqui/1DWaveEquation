using Plots

function initialization()
end

function boundaryCondition()
end

function plotresults()
end

#UPWIND Method
function upwind(deltaT,deltaX)
	initialization()
	boundaryCondition()
	for i = 1 : gridPointsT - 1
		for j = 2 : gridPointsX
			u[i+1, j] = u[i,j] - ((deltaT * 0.5) / deltaX) * (u[i,j] - u[i,j-1])
		end
	end

	plotresults()
end

#LAX Method
function lax(gridPointsT,gridPointsX)
	initialization()
	boundaryCondition()
	for i = 1 : gridPointsT - 1
		for j = 2 : gridPointsX - 1
			u[i+1 , j] = 0.5 * (u[i,j+1] + u[i,j-1]) - (0.5 / 2) * ((u[i,j+1] - u[i,j-1]) *(deltaT / deltaX))
		end
	end
	plotresults()
end

#LAX-WENDROFF Method
function laxWendroff(gridPointsT,gridPointsX)
	initialization()
	boundaryCondition()
	for i = 1 : gridPointsT - 1 
		for j = 2 : gridPointsX - 1
			u[i+1,j] = u[i,j] - ((0.5 * deltaT) / (2 * deltaX)) * (u[i,j+1] - u[i,j-1]) + (((0.5^2) * (deltaT^2)) / (2*(deltaX^2))) * (u[i,j+1] - 2*u[i,j] + u[i,j-1])
		end
	end
	plotresults()
end

#Leap-Frog method

function leapfrog(gridPointsT,gridPointsX)
	initialization()
	boundaryCondition()
	for i = 1 : gridPointsX
		u[2,i] = u[1,i]
	end

	for i = 2 : gridPointsT - 1
		for j = 2 : gridPointsX - 1
			u[i+1,j] = u[i-1,j] - ((0.5 * deltaT) / deltaX) * (u[i,j+1] - u[i,j-1])
		end
	end
	plotresults()
end

#MACCORMACK METHOD
function maccormack(gridPointsT,gridPointsX)
	initialization()
	boundaryCondition()
	for i = 1 : gridPointsT - 1
		for j = 2 : gridPointsX - 1
			uj1n = u[i,j-1] - ((deltaT * 0.5) / deltaX) * (u[i,j] - u[i,j-1])
			uj2n = u[i,j] - ((deltaT * 0.5) / deltaX) * (u[i,j+1] - u[i,j])
			u[i+1,j] = 0.5 * (uj2n + u[i,j] - (deltaT * 0.5 / deltaX) * (uj2n - uj1n))
		end
	end
	plotresults()
end

function initialization()
	gridPointsT = Int32(((10 / deltaT) + 1))
	gridPointsX = Int32(((40 / deltaX) + 1))

	space = zeros(gridPointsX)

	for i = 2 : gridPointsX
	 	space[i] = space[i-1] + deltaX
	end

	tim = zeros(gridPointsT)

	for i = 2 : gridPointsT
		tim[i] = tim[i-1] + deltaT
	end

	u = zeros( gridPointsT, gridPointsX)
end

#Boundary Condition
function boundaryCondition()
	for i = 1 : gridPointsX
		u[1,i] = 0.5 * ( 1 + tanh(250 * (space[i] - 20)))
	end
end

function plotresults()
	plot(space[:] , u[Int32(round(gridPointsT / 2)) , :])
end

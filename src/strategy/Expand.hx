package strategy;

import com.tamina.planetwars.data.Galaxy;
import com.tamina.planetwars.data.PlanetPopulation;
import com.tamina.planetwars.data.Order;
import com.tamina.planetwars.data.Planet;
import com.tamina.planetwars.utils.GameUtil;

class Expand implements Strategy
{
	private var distance	: Float;
	private var marge 		: Float;
	private var level 		: Float;
	private var ia			: MyIA;

	public function new(ia : MyIA, distance: Float = 500, marge : Float = 100, level: Float = 30)
	{
		this.distance	= distance;
		this.marge		= marge;
		this.level		= level;
		this.ia			= ia;
	}

	public function getOrders(context: Galaxy, id: String) : Array<Order>
	{
		//directly copied from the example file then adjusted
		//send 'quant' people eveytime we go above 'level' on a planet
		//example values put as default because they work nicely

		var result = new Array<Order>();
		var myPlanets = GameUtil.getPlayerPlanets(id, context);	
		var otherPlanets = GameUtil.getEnemyPlanets(id, context);

#if MULTISTRAT
		if (myPlanets.length < 3)
			this.ia.strat = new StraightToCore(this.ia);
#end

		if (otherPlanets != null && otherPlanets.length > 0)
		for (myPlanet in myPlanets)
		{
			otherPlanets.sort(
				function(a : Planet, b : Planet) : Int 
				{ 
					return Std.int(	GameUtil.getDistanceBetweenPlanets(a, myPlanet) - 
						GameUtil.getDistanceBetweenPlanets(b, myPlanet)); 
				}
				);

			var planetsAround : Array<Planet> = [];
			var quant : Array<Int> = [];

			var acc : Int = 0;
			var sum = 0;

			while (planetsAround.length == 0)
			 {
			 	this.distance = GameUtil.getDistanceBetweenPlanets(myPlanet, otherPlanets[0]);
			 	planetsAround = getPlanetsAround(myPlanet, this.distance, this.marge, otherPlanets);
			 }


			for (planet in planetsAround)
			{
				sum += (planet.size);
				quant.push(0);
			}

			var modif = true;
			var listDone : Array<Planet> = [];
			var listToDo = planetsAround.copy();


			while (modif)
			{
				modif = false;
				if (myPlanet.population >= this.level)
				for (i in 0 ... planetsAround.length)
				{
					var evenpop = Math.floor(myPlanet.population/sum * (planetsAround[i].size));
					var maxpop = (PlanetPopulation.getMaxPopulation(planetsAround[i].size) < planetsAround[i].population + GameUtil.getTravelNumTurn(myPlanet, planetsAround[i]) * 5)?PlanetPopulation.getMaxPopulation(planetsAround[i].size):planetsAround[i].population + GameUtil.getTravelNumTurn(myPlanet, planetsAround[i]) * 5;

					if (maxpop < evenpop
						&&
						{
							for (j in listDone)
								if (planetsAround[i] == j)
									false;
							true;
						})
									
					{
						quant[i] = maxpop;
						listDone.push(planetsAround[i]);
						listToDo.remove(planetsAround[i]);
						modif = true;
					}
					else
					quant[i] = evenpop;
				}
			}

			for (i in 0 ... planetsAround.length)
				if(quant[i]!=0)
					result.push(new Order(myPlanet.id , planetsAround[i].id , quant[i]));
		
		}

		return result;
		
		}

		private function getPlanetsAround(source: Planet, distance: Float, marge: Float, candidats: Array<Planet>) : Array<Planet>
		{
			var result = new Array<Planet>();
			for (planet in candidats)
			{
				if (GameUtil.getDistanceBetweenPlanets(source, planet) >= (distance - marge) && GameUtil.getDistanceBetweenPlanets(source, planet) <= (distance + marge))
				result.push(planet);
			}
			return result;
		}
	}
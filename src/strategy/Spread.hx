package strategy;

import com.tamina.planetwars.data.IPlayer;
import com.tamina.planetwars.data.Galaxy;
import com.tamina.planetwars.data.Order;
import com.tamina.planetwars.data.Planet;
import com.tamina.planetwars.data.PlanetPopulation;
import com.tamina.planetwars.utils.GameUtil;
import com.tamina.planetwars.geom.Point;

class Spread implements Strategy
{
	public var ia : MyIA;

	public function new(ia : MyIA)
	{
		this.ia = ia;
	}

	public function getOrders(context:Galaxy, id:String) : Array<Order>
	{
		var orders = new Array<Order>();
		var myPlanets    = GameUtil.getPlayerPlanets(id, context);
		var myShips      = GameUtil.getPlayerShips(id, context);
		var enemyPlanets = GameUtil.getEnemyPlanets(id, context);
		var enemyShips   = GameUtil.getEnemyShips(id, context);

		var totalPopulation = 0;
		for(planet in myPlanets)
			totalPopulation += planet.population;

		for(source in myPlanets)
		{
			if(source.population == PlanetPopulation.getMaxPopulation(source.size))
			{
				// Sort planets by distance from source
				enemyPlanets.sort(function(a : Planet, b : Planet) : Int { return Std.int(GameUtil.getDistanceBetween(new Point(a.x, a.y), new Point(source.x, source.y)) - GameUtil.getDistanceBetween(new Point(b.x, b.y), new Point(source.x, source.y))); });

				for(target in enemyPlanets)
				{
					// Define distance and population by landing
					//var distance = GameUtil.getDistanceBetween(new Point(source.x, source.y), new Point(target.x, target.y));
					var populationByLanding = target.population + GameUtil.getTravelNumTurn(source, target) * 5;
					if(source.population > populationByLanding)
					{
						var order = newOrder(source, target, populationByLanding+1);
						if(order != null)
							orders.push(order);
					}
				}
			}
		}

		return orders;
	}

	public function newOrder(source : Planet, target : Planet, population : Int) : Order
	{
		if(source.population >= population)
			return new Order(source.id, target.id, population);
		return null;
	}
}
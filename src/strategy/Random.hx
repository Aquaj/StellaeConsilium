package strategy;

import com.tamina.planetwars.data.IPlayer;
import com.tamina.planetwars.data.Galaxy;
import com.tamina.planetwars.data.Order;
import com.tamina.planetwars.data.Planet;
import com.tamina.planetwars.data.PlanetPopulation;
import com.tamina.planetwars.utils.GameUtil;
import com.tamina.planetwars.geom.Point;

class Random implements Strategy
{
	public var ia : MyIA;

	public function new(ia : MyIA)
	{
		this.ia = ia;
	}

	public function getOrders(context:Galaxy, id:String) : Array<Order>
	{
		var orders 		 = new Array<Order>();
		var myPlanets    = GameUtil.getPlayerPlanets(id, context);
		var myShips      = GameUtil.getPlayerShips(id, context);
		var enemyPlanets = GameUtil.getEnemyPlanets(id, context);
		var enemyShips   = GameUtil.getEnemyShips(id, context);
		var toSend		 = new Array<Int>();

		for (i in 0...enemyPlanets.length)
			toSend.push(0);

		var totalPopulation = 0;
		for(planet in myPlanets)
			totalPopulation += planet.population;

		for(source in myPlanets)
		{
			for(i in 0...source.population-1)
				toSend[Std.random(enemyPlanets.length)] += 1;			
			for (i in 0...toSend.length)
				if (toSend[i] != 0)
					orders.push(new Order(source.id, enemyPlanets[i].id, toSend[i]));
		}

		return orders;
	}
}
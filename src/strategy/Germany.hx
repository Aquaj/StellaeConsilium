package strategy;

import com.tamina.planetwars.data.IPlayer;
import com.tamina.planetwars.data.Galaxy;
import com.tamina.planetwars.data.Order;
import com.tamina.planetwars.data.Planet;
import com.tamina.planetwars.utils.GameUtil;
import strategy.StrategyUtils;

class Germany implements Strategy
{
	private var level : Int;
	private var quant : Int;
	private var ennemy : IPlayer; 			//avoid problem of turns (see StrategyUtils.getEnnemyName)

	public function new(level : Int = 50, quant : Int = 40)
	{
		this.level = level;
		this.quant = quant;
	}

	public function getOrders(context : Galaxy, id:String) : Array<Order>
	{
		//directly copied from the example file then adjusted
		//send 'quant' people eveytime we go above 'level' on a planet
		//example values put as default because they work nicely

		var result = new Array<Order>();

		var myPlanets = GameUtil.getPlayerPlanets(id, context);	
		var otherPlanets = GameUtil.getEnemyPlanets(id, context);

		if (ennemy == null)					//allows a single initialization
			ennemy = StrategyUtils.getEnnemyName(otherPlanets);
		var ennemyPlanets = GameUtil.getPlayerPlanets(ennemy.id, context);

		if (otherPlanets != null && otherPlanets.length > 0)
		{
			for (myPlanet in myPlanets)
			{
				var target = StrategyUtils.getNearestPlanet(myPlanet, otherPlanets);

				if (myPlanet.population >= this.level)
					result.push(new Order(myPlanet.id, target.id, this.quant));
			}
		}
		return result;
	}
}
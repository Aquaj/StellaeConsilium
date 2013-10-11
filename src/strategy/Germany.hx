package strategy;

import com.tamina.planetwars.data.Galaxy;
import com.tamina.planetwars.data.Order;
import com.tamina.planetwars.data.Planet;
import com.tamina.planetwars.utils.GameUtil;

class Germany implements Strategy
{
	private var level : Int;
	private var quant : Int;
	private var ia : MyIA; 

	public function new(ia : MyIA, level : Int = 50, quant : Int = 40)
	{
		this.ia		= ia;
		this.level 	= level;
		this.quant 	= quant;
	}

	public function getOrders(context : Galaxy, id:String) : Array<Order>
	{
		//directly copied from the example file then adjusted
		//send 'quant' people eveytime we go above 'level' on a planet
		//example values put as default because they work nicely

		var result = new Array<Order>();

		var myPlanets = GameUtil.getPlayerPlanets(id, context);	
		var otherPlanets = GameUtil.getEnemyPlanets(id, context);

#if MULTISTRAT
		if (myPlanets.length >= 3)
			this.ia.strat = new Expand(this.ia);
#end

		if (otherPlanets != null && otherPlanets.length > 0)
		{
			for (myPlanet in myPlanets)
			{
				var target = GameUtil.getNearestPlanet(myPlanet, otherPlanets);

				if (myPlanet.population >= this.level)
					result.push(new Order(myPlanet.id, target.id, this.quant));
			}
		}
		return result;
	}
}
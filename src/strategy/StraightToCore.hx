package strategy;

import com.tamina.planetwars.data.IPlayer;
import com.tamina.planetwars.data.Galaxy;
import com.tamina.planetwars.data.Order;
import com.tamina.planetwars.data.Planet;
import com.tamina.planetwars.data.PlanetPopulation;
import com.tamina.planetwars.utils.GameUtil;
import haxe.*;

class StraightToCore implements Strategy
{
	//sends a percent (default 100) of resources form all
	//planets onto a single ennemy planet.

	private var ennemy:IPlayer; 			//avoid problem of turns (see StrategyUtils.getEnnemyName)
	private var percent:Int;					//how many of planets' pop. we send to conquest

	public function new(percentage: Int = 100)
	{
		this.percent = percentage;
	}

	public function getOrders(context:Galaxy, id:String) : Array<Order>
	{
		var result = new Array<Order>();

		var myPlanets = GameUtil.getPlayerPlanets(id, context );
		var otherPlanets = GameUtil.getEnemyPlanets(id, context);
		
		if (ennemy == null)					//allows a single initialization
			ennemy = StrategyUtils.getEnnemyName(otherPlanets);

		var ennemyPlanets = GameUtil.getPlayerPlanets(ennemy.id, context);

		if ( ennemyPlanets != null && ennemyPlanets.length > 0 )
		{
			for (myPlanet in myPlanets)	//sending the population
			{
				var pop = Math.ceil(myPlanet.population*percent / 100);
				result.push(new Order(myPlanet.id, ennemyPlanets[0].id, pop));
			}
		}
		return result;
	}
}
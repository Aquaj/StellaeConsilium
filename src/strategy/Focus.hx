package strategy;

import com.tamina.planetwars.data.IPlayer;
import com.tamina.planetwars.data.Galaxy;
import com.tamina.planetwars.data.Order;
import com.tamina.planetwars.data.Planet;
import com.tamina.planetwars.data.PlanetPopulation;
import com.tamina.planetwars.utils.GameUtil;
import com.tamina.planetwars.geom.Point;

class Focus implements Strategy
{
	public var ia 			: MyIA;
	private var PlanetsData	: Map < Planet, DataPlanet >;

	public function new(ia : MyIA)
	{
		this.ia = ia;
		this.PlanetsData = new Map();
	}

	public function getOrders(context:Galaxy, id:String) : Array<Order>
	{
		var myPlanets    = GameUtil.getPlayerPlanets(id, context);
		var enemyPlanets = GameUtil.getEnemyPlanets(id, context);
		var enemyShips   = GameUtil.getEnemyShips(id, context);
		var toSend		 = new Array<Int>();

		for(planet in myPlanets)
			if(!PlanetsData.exists(planet))
				PlanetsData.set( planet,  new DataPlanet(planet.population));

		for (myPlanet in myPlanets)
		{
			var plan = 0;
			for(enemyPlanet in enemyPlanets)
			{
				if(canConquer(myPlanet, enemyPlanet))
				{
					var popByLanding = enemyPlanet.population + GameUtil.getTravelNumTurn(myPlanet, enemyPlanet) * 5;
					PlanetsData.get(myPlanet).updateData(enemyPlanet, popByLanding+1, 0);
				}
			}
		}

		return createOrders(PlanetsData);
	}

	private function canConquer(source: Planet, target: Planet) : Bool
	{
		return (target.population+GameUtil.getTravelNumTurn(source, target)*5 < PlanetsData.get(source).getPopLeft()); 
	}

	private function createOrders(data : Map<Planet, DataPlanet>) : Array<Order>
	{
		var orders = new Array<Order>();
		var dataTuple;
		for (planet in data.keys())
		{
			dataTuple = data.get(planet);
			for (i in 0...data.get(planet).getTargets().length)
			if(dataTuple.getTurnsLeft()[i] == 0)
			{
				orders.push(new Order(
								planet.id,
								dataTuple.getTargets()[i].id,
								dataTuple.getPopReserved()[i]
							));
				dataTuple.remove(i);
			}
			dataTuple.decrease();
		}
		return orders;

	}

}

class DataPlanet
{
	private var targets		: Array<Planet>;
	private var popReserved	: Array<Int>;
	private var turnsLeft	: Array<Int>;
	private var popLeft		: Int;

	public function updateData(target : Planet, pop : Int, turns : Int) : Void
	{
		targets.push(target);
		popReserved.push(pop);
		turnsLeft.push(turns);
		popLeft -= pop;
	}

	public function new(pop : Int)
	{
		targets = new Array<Planet>();
		popReserved = new Array<Int>();
		turnsLeft = new Array<Int>();
		popLeft = pop;
	}

	public function getTargets()	: Array<Planet>	{	return targets;		}
	public function getPopReserved(): Array<Int>	{	return popReserved;	}
	public function getTurnsLeft() 	: Array<Int>	{	return turnsLeft;	}
	public function getPopLeft()	: Int			{	return popLeft;		}

	public function remove(order : Int) : Void
	{
		targets.splice(order , 1);
		popReserved.splice(order , 1);
		turnsLeft.splice(order , 1);
	}

	public function decrease()
	{
		for (i in turnsLeft) { i--; }
	}
}
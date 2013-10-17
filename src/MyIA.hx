package ;

import com.tamina.planetwars.data.Galaxy;
import com.tamina.planetwars.data.Order;

import com.tamina.planetwars.utils.GameUtil;

import strategy.Strategy;

import strategy.StraightToCore;
import strategy.Germany;
import strategy.Spread;
import strategy.Expand;
import strategy.Focus;
import strategy.Random;

/**
 * IA Base class that just allows the Strategy classes to be run.
 */

class MyIA extends WorkerIA
{
	private var strategies: Array<Strategy>;
	public var strat: Int;

	public static function main() : Void
	{
		WorkerIA.instance = new MyIA();
	}

	public function new()
	{
		this.strategies	= 	[	
								new StraightToCore(this),
								new Germany(this),
								new Spread(this),
								new Expand(this),
								new Random(this),
								new Focus(this)
						 	];
		super("Stellae#1", 0x0020FF);
		strat = 5;							//allows single instatiation of strategy
											//this avoids waste and allows strats to keep variables
	}
	
	override public function getOrders(context : Galaxy) : Array<Order>		//actually calls the strategy
	{
		return strategies[strat].getOrders(context, id);
	}
	
}
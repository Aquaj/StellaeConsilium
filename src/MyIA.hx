package ;

import com.tamina.planetwars.data.Galaxy;
import com.tamina.planetwars.data.Order;

import strategy.Strategy;

import strategy.StraightToCore;
import strategy.Germany;
import strategy.Spread;
import strategy.Expand;

/**
 * IA Base class that just allows the Strategy classes to be run.
 */

class MyIA extends WorkerIA
{
	public var strat:Strategy;

	private function strategy() : Strategy
	{
		return new Germany(this);	//points to strategy to use
	}

	public static function main() : Void
	{
		WorkerIA.instance = new MyIA();
	}

	public function new()
	{
		super("Stellea#1", 0x0020FF);
		strat = strategy();					//allows single instatiation of strategy
											//this avoids waste and allows strats to keep variables
	}
	
	override public function getOrders(context : Galaxy) : Array<Order>		//actually calls the strategy
	{
		return strat.getOrders(context, id);
	}
	
}
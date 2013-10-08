package strategy;

import com.tamina.planetwars.data.Galaxy;
import com.tamina.planetwars.data.Order;

interface Strategy
{
	public function getOrders(context:Galaxy, id:String) : Array<Order>;
}
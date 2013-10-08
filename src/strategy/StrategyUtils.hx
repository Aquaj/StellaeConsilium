package strategy;

import com.tamina.planetwars.data.IPlayer;
import com.tamina.planetwars.data.Galaxy;
import com.tamina.planetwars.data.Order;
import com.tamina.planetwars.data.Planet;
import com.tamina.planetwars.data.PlanetPopulation;
import com.tamina.planetwars.utils.GameUtil;
import com.tamina.planetwars.geom.Point;

class StrategyUtils
{

	public static function getNearestPlanet(source:Planet, candidats:Array<Planet>) : Planet
	{
		//directly from the example file
		//check for the nearest planet in a list of candidats (usually ennemies) 

		var result:Planet = candidats[ 0 ];
		var currentDist:Float = GameUtil.getDistanceBetween( new Point( source.x, source.y ), new Point( result.x, result.y ) );
		for ( i in 0...candidats.length )
		{
			var element:Planet = candidats[i];
			if ( currentDist > GameUtil.getDistanceBetween( new Point( source.x, source.y ), new Point( element.x, element.y ) ) )
			{
				currentDist = GameUtil.getDistanceBetween( new Point( source.x, source.y ), new Point( element.x, element.y ) );
				result = element;
			}
			
		}
		return result;
	}

	public static function getEnnemyName(candidats:Array<Planet>) : IPlayer
	{
		//checks who is the enemy with the lesser number of planets
		//and assumes it is the opposite AI
		//						( works only for the first few turns)
		var first:IPlayer = candidats[0].owner;
		var second:IPlayer = candidats[1].owner;
		
		return (first == candidats[candidats.length-1].owner) ? second : first;
	}
}
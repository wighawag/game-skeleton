package wighawag.game.cupofcoffee.model;
import wighawag.system.EntityComponent;
class SeparateAxisVelocityComponent implements EntityComponent{

    public var dx : Float;
	public var dy : Float;

    public function new() {
	    dx = 0;
	    dy = 0 ;
    }

    public function initialise():Void {
    }

}

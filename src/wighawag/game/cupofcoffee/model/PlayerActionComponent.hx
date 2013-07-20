package wighawag.game.cupofcoffee.model;
import wighawag.system.EntityComponent;
class PlayerActionComponent implements EntityComponent {

    public var jump : Bool;
	public var goDown : Bool;
	public var grab : Bool;

    public var fallingRight : Bool;
    public var fallingLeft : Bool;
    public var fallingFront : Bool;
    public var fallingBehind : Bool;

    public var rawX : Float;
    public var computedX : Float;

    public var rawY : Float;
    public var computedY : Float;

    public var rawZ : Float;
    public var computedZ : Float;

    public function new() {
    }

    public function initialise():Void{

    }

    public function reset() : Void{
	    goDown = false;
	    grab = false;
        jump = false;
        fallingRight = false;
        fallingLeft = false;
        fallingFront = false;
        fallingBehind = false;
    }
}

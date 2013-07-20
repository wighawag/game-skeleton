package wighawag.game.cupofcoffee.model;
import wighawag.game.cupofcoffee.model.PhysicsComponent;
import wighawag.core.EntityTypeParameters;
import haxe.Timer;
import flash.geom.Rectangle;
import wighawag.core.StateComponent;
import wighawag.core.PlacementComponent;

@accessClass("PhysicsComponent")
class PlayerPhysicsComponent implements PhysicsComponent {

    @owner
    private var playerAction : PlayerActionComponent;

    @owner
    private var placement : PlacementComponent;

    @owner
    private var state : StateComponent;

    @owner
    private var velocity : SeparateAxisVelocityComponent;

    @entityType
    private var parameters : EntityTypeParameters;


    public var gravity : Float;
    public var jumpInitialSpeed : Float;
    public var runForce : Float;
    public var maxYSpeed : Float;
    public var maxXSpeed : Float;
    public var flipForce : Float;
    public var frictionForce : Float;
    public var jumpSpeedCut : Float;

	public var ladderSpeed : Float = 200;
	public var releaseDelay : Float= 0.4;

	public var jumping : Bool;

	private var onGround = false;

	private var onLadder = false;
	private var ladderReleaseTIme : Float = 0;

    private var doubleJumpExecuted : Bool;

    private var lastDirection : Int;

    public function new() {
    }

    public function initialise():Void {
        parameters.onParamUpdated.add(onParametersUpdated);
        for(paramName in parameters.keys()){
            onParametersUpdated(paramName, parameters.get(paramName));
        }
    }

    // allow caching of params
    private function onParametersUpdated(name : String, value : Dynamic) : Void{
        switch(name){
            case "gravity": gravity = value;
            case "jumpInitialSpeed": jumpInitialSpeed = value;
            case "runForce": runForce = value;
            case "maxYSpeed": maxYSpeed = value;
            case "maxXSpeed": maxXSpeed = value;
            case "flipForce": flipForce = value;
            case "frictionForce": frictionForce = value;
            case "jumpSpeedCut": jumpSpeedCut = value;
        }

    }

    public function update(dt:Float):Void {
	    state.increaseElapsedTime(dt);

    }

}

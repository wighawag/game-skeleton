package wighawag.game.cupofcoffee.controller;

import wighawag.game.cupofcoffee.model.PlayerActionComponent;
import wighawag.controls.Keyboard;
import wighawag.system.Entity;
import wighawag.system.SystemComponent;
import wighawag.system.Updatable;
import wighawag.core.PlacementComponent;

@entities(['wighawag.game.cupofcoffee.model.PlayerActionComponent'])
class GameController implements SystemComponent implements Updatable{


    private var xAcc : Float;
    private var yAcc : Float;
    private var zAcc : Float;

    private var rawX : Float;
    private var rawY : Float;
    private var rawZ : Float;

    private var xRange : Float;
    private var xNeutral : Float;

    private var yRange : Float;
    private var yNeutral : Float;

    private var zRange : Float;
    private var zNeutral : Float;


    private var playerActionComponent : PlayerActionComponent;


    // Keyboard is currently state based we might want to use event only (this is how the remote controller would work anyway)
    public function new(keyboard : Keyboard) {

        xNeutral = 0;
        xRange = 0.4;

        yNeutral = -0.4;
        yRange = 0.4;

        zNeutral = -0.4;
        zRange = 0.4;
    }


    public function initialise():Void{

    }


    public function onEntityRegistered(entity : Entity) : Void{
        if (playerActionComponent != null){
            Report.anError("GameController", "the controller support only one player action component", "ignoring the new entity");
        }else{
            playerActionComponent = entity.get(PlayerActionComponent);
        }
    }

    public function onEntityUnregistered(entity : Entity) : Void{
        if(entity.get(PlayerActionComponent) == playerActionComponent){
            playerActionComponent = null;
        }
    }


    public function update(dt : Float) : Void
    {
        if(playerActionComponent == null){
            return;
        }
        playerActionComponent.reset();

//            if(keyboard.isKeyDown(Key.RIGHT)){
//                playerActionComponent.fallingRight = true;
//            }
//
//            if(keyboard.isKeyDown(Key.LEFT)){
//                playerActionComponent.fallingLeft = true;
//            }
//
//            if(keyboard.isKeyDown(Key.UP)){
//                playerActionComponent.fallingFront = true;
//            }
//
//            if(keyboard.isKeyDown(Key.DOWN)){
//                playerActionComponent.fallingBehind = true;
//            }



        playerActionComponent.computedX = xAcc;
        playerActionComponent.rawX = rawX;
        if (xAcc > 0){
            playerActionComponent.fallingRight = true;
        }else if(xAcc < 0){
            playerActionComponent.fallingLeft = true;
        }


        playerActionComponent.computedY = yAcc;
        playerActionComponent.rawY = rawY;
        if (yAcc > 0){
            playerActionComponent.fallingFront = true;
        }else if (yAcc < 0){
            playerActionComponent.fallingBehind = true;
        }

        playerActionComponent.computedZ = zAcc;
        playerActionComponent.rawZ = rawZ;
//            if (zAcc > 0){
//                playerActionComponent.fallingBehind = true;
//            }else if (zAcc < 0){
//                playerActionComponent.fallingFront = true;
//            }


        // TODO recompute the computed values
        rawX -= 0.1 * rawX/Math.abs(rawX);
        yAcc -= 0.1 * yAcc/Math.abs(yAcc);
        rawY -= 0.1 * rawY/Math.abs(rawY);
        zAcc -= 0.1 * zAcc/Math.abs(zAcc);
        rawZ -= 0.1 * rawZ/Math.abs(rawZ);

    }

}

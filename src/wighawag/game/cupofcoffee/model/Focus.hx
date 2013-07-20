package wighawag.game.cupofcoffee.model;

import flash.geom.Rectangle;
import wighawag.system.Updatable;
import wighawag.core.PlacementComponent;
import wighawag.system.Entity;
import wighawag.system.SystemComponent;

@entities(["wighawag.core.PlacementComponent", "wighawag.game.cupofcoffee.model.PlayerActionComponent"])
class Focus implements SystemComponent implements Updatable{

    private var target : PlacementComponent;

    public var area : Rectangle;
    private var worldBounds : Rectangle;

    public function new(worldBounds : Rectangle, screenWidth : Float, screenHeight : Float) {
        area = new Rectangle();
        this.worldBounds = worldBounds;
        setScreenSize(screenWidth, screenHeight);
    }

    public function initialise():Void {

    }

    public function onEntityRegistered(entity:Entity):Void {
        if(target != null){
            Report.anError("PlayerFollowingCamera", "the camera is already following another entity", "ignoring the new entity");
        }else{
            target = entity.get(PlacementComponent);
        }
    }

    public function onEntityUnregistered(entity:Entity):Void {
        var removedEntityPlacementComponent : PlacementComponent = entity.get(PlacementComponent);
        if(target == removedEntityPlacementComponent){
            target = null;
        }

    }

    public function setScreenSize(width : Float, height : Float) : Void{
        Report.anInfo("Focus","setScreenSize ", "(" + width + "," + height + ")");
        this.area.width = width;
        this.area.height = height;
    }

    public function update(dt:Float):Void {

        var currentScrollX : Float = 0;
        var currentScrollY : Float = 0;

        var scrollXComputed = false;
        var scrollYComputed = false;

        // TODO depend on Alignement chosen
        if (area.width > worldBounds.width ){
            currentScrollX = worldBounds.left;
            scrollXComputed = true;
        }
        // TODO depend on Alignement chosen
        if (area.height > worldBounds.height){
            currentScrollY = worldBounds.bottom - area.height;
            scrollYComputed = true;
        }

        if(target != null){
            if(!scrollXComputed){
                var focusX = (target.x + target.width /2);
                var leftX = focusX - area.width / 2;
                var rightX = focusX + area.width / 2;
                if(leftX < worldBounds.left){
                    currentScrollX = worldBounds.left;
                }else if (rightX > worldBounds.right){
                    currentScrollX = worldBounds.right - area.width;
                }else{
                    currentScrollX = leftX;
                }
            }


            if(!scrollYComputed){
                var focusY = (target.y + target.height /2);
                var topY = focusY - area.height / 2;
                var bottomY = focusY + area.height / 2;
                if (bottomY > worldBounds.bottom){
                    currentScrollY = worldBounds.bottom  - area.height;
                }else if(topY < worldBounds.top){
                    currentScrollY = worldBounds.top;
                }else{
                    currentScrollY = topY;
                }
            }

        }

        area.x = currentScrollX;
        area.y = currentScrollY;

    }


}

package wighawag.game.cupofcoffee.model;

import wighawag.core.PlacementComponent;
import wighawag.system.Entity;
import wighawag.system.Updatable;
import wighawag.system.SystemComponent;

@entities(["wighawag.core.PlacementComponent", "wighawag.game.cupofcoffee.model.PhysicsComponent"])
class PhysicsEngine implements SystemComponent implements Updatable{

    public function new() {
    }

    public function initialise():Void{

    }

    public function onEntityRegistered(entity:Entity):Void {
    }

    public function onEntityUnregistered(entity:Entity):Void {
    }

    public function update(dt:Float):Void {
        for (entity in registeredEntities){
            var physicsComponent : PhysicsComponent = entity.get(PhysicsComponent);
            physicsComponent.update(dt);
        }
    }


}

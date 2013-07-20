package wighawag.game.cupofcoffee.model;

import wighawag.asset.entity.EntityTypeLibrary;
import wighawag.core.StateComponent;
import wighawag.core.AssetComponent;
import wighawag.system.EntityType;
import wighawag.core.PlacementComponent;
import wighawag.system.Entity;
import wighawag.system.Updatable;
import wighawag.system.SystemComponent;

class EntityPopulator implements SystemComponent implements Updatable{

    private var entityTypeLibrary : EntityTypeLibrary;

    public function new(entityTypeLibrary : EntityTypeLibrary){
        this.entityTypeLibrary = entityTypeLibrary;
    }

    public function initialise():Void{
        // TODO deal with the required linkage of Component Class added through xml?
        // TODO could in the same time deal with mapping short name for entityTypes.xml
        // force compilation of :
        wighawag.core.EntityComponentProvider;
        wighawag.game.cupofcoffee.model.PlayerPhysicsComponent;
        wighawag.game.cupofcoffee.model.SeparateAxisVelocityComponent;

//        var entity = entityType.createEntity([
//        //TODO deal with width and heigh = 0 (use asset ?)?
//        new PlacementComponent(0, 0, 10, 10),
//        new StateComponent("walkleft")
//        ]);
//        model.addEntity(entity);

        var asteroidType = entityTypeLibrary.get("asteroid");
        var entity = asteroidType.createEntity([
            new PlacementComponent(20,20,48,48)
            //, new StateComponent("idle")
        ]);

        model.addEntity(entity);

    }



    public function onEntityRegistered(entity : Entity) : Void{

    }

    public function onEntityUnregistered(entity : Entity) : Void{

    }


    public function update(dt : Float) : Void
    {

    }


}

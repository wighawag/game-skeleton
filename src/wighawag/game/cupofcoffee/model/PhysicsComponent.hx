package wighawag.game.cupofcoffee.model;

import wighawag.system.EntityComponent;

@accessClass
interface PhysicsComponent extends EntityComponent{
    public function update(dt : Float) : Void;
}

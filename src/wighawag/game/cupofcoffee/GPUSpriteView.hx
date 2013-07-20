package wighawag.game.cupofcoffee;

import flash.geom.Rectangle;
import wighawag.core.AssetComponent;
import wighawag.core.PlacementComponent;
import wighawag.core.StateComponent;
import wighawag.asset.spritesheet.Sprite;
import wighawag.system.Entity;
import wighawag.view.TexturedQuadProgram;
class GPUSpriteView {

    public var entity : Entity;
    private var sprite : Sprite;
    private var state : StateComponent;
    public var placement : PlacementComponent;

    public function new(entity : Entity, sprite : Sprite) {
        this.entity= entity;
        this.sprite = sprite;
        state = entity.get(StateComponent);
        placement = entity.get(PlacementComponent);
    }

    public function render(program : TexturedQuadProgram) : Void{
        var frame = sprite.getFrame(state.state, 0);
        var subTexture = frame.texture;
        // TODO frameX... and move this to a util ("using" feature of haxe)
        program.draw(subTexture.bitmapAsset.id, subTexture.x, subTexture.y, subTexture.width, subTexture.height, placement.x, placement.y, placement.x + placement.width, placement.y + placement.height );
    }



}

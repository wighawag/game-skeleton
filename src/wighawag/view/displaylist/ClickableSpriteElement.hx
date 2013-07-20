package wighawag.view.displaylist;

import wighawag.asset.spritesheet.Sprite;

import msignal.Signal;

class ClickableSpriteElement extends SpriteElement, implements InteractiveElement{

    public var onClicked(default, null) : Signal1<InteractiveElement>;

    public function new(sprite : Sprite, animation : String) {
        super(sprite, animation);
        onClicked = new Signal1();
    }

    public function triggerClick():Void {
        onClicked.dispatch(this);
    }


}

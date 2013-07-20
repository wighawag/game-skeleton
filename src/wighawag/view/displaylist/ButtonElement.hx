package wighawag.view.displaylist;

import wighawag.asset.font.FontFace;
import wighawag.asset.NinePatch;
using wighawag.asset.NinePatchUtils;
import wighawag.view.displaylist.NinePatchElement;

//TODO implement onMouseover.... state change...
class ButtonElement extends NinePatchElement, implements InteractiveElement{

    public var onClicked(default, null) : Signal1<InteractiveElement>;

    public function new(ninePatch : NinePatch, text : String, fontFace : FontFace) {

        super(ninePatch, ninePatch.getWidthFromContentWidth(fontFace.widthOf(text)) , ninePatch.getHeightFromContentHeight(fontFace.heightOf(text)) );

        addChild(new TextElement(text, fontFace));
        onClicked = new Signal1();
    }


    public function triggerClick():Void {
        onClicked.dispatch(this);
    }


}

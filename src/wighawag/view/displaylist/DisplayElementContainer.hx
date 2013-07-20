package wighawag.view.displaylist;

interface DisplayElementContainer extends DisplayElement{
    public var children(default, null) : Array<DisplayElement>;

    public function addChild(element : DisplayElement) : Void;
    public function removeChild(element : DisplayElement) : Void;

}

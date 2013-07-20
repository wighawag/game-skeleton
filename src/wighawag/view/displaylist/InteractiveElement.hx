package wighawag.view.displaylist;

import msignal.Signal;

interface InteractiveElement {

    public var onClicked(default, null) : Signal1<InteractiveElement>;
    public function triggerClick() : Void;
    
}

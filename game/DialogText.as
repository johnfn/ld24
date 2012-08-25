package {
  public class DialogText extends Entity {
    var text:Text;
    var prev_mode:int;
    var dialogsLeft:Array;

    function DialogText(content:String, ...args) {
      text = new Text(50, 50, content, 200);

      prev_mode = Fathom.currentMode;
      Fathom.currentMode = C.MODE_TEXT;

      dialogsLeft = args;
    }

    override public function update(e:EntityList):void {
      if (Util.keyRecentlyDown(Util.Key.X)) {
        if (dialogsLeft.length == 0) {
          this.destroy();
        }
      }
    }

    override public function depth():int {
      return 300;
    }

    // Should be active in all modes.
    override public function modes():Array {
      return [C.MODE_TEXT, C.MODE_NORMAL, C.MODE_INVENTORY];
    }
  }
}

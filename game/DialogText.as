package {
  public class DialogText extends Entity {
    private var text:Text;
    private var prev_mode:int;
    private var dialogsLeft:Array;

    private static const BOX_WIDTH:int = 250;
    private static const BOX_HEIGHT:int = 50;

    [Embed(source = "../data/dialogbox.png")] static public var DialogClass:Class;

    function DialogText(content:String, ...args) {
      super(0, 0, 50, 50);
      fromExternalMC(DialogClass);
      addDropShadow();

      // Stick it right under the inventory box so they don't overlap.
      set(new Vec(250 - BOX_WIDTH/2, 250 - BOX_HEIGHT/2 + 25));

      text = new Text(x + 5, y + 8, content, BOX_WIDTH - 10);
      text.textColor = 0xffffff;
      addChild(text);

      prev_mode = Fathom.currentMode;
      Fathom.currentMode = C.MODE_TEXT;

      dialogsLeft = args;
    }

    override public function update(e:EntityList):void {
      if (Util.keyRecentlyDown(Util.Key.Z)) {
        if (dialogsLeft.length == 0) {
          this.destroy();

          Fathom.currentMode = prev_mode;
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

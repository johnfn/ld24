package {
  public class DialogText extends Entity {
    private var text:Text;
    private var prev_mode:int;
    private var dialogsLeft:Array;

    private var profPic:Entity;

    private static const BOX_WIDTH:int = 250;
    private static const BOX_HEIGHT:int = 50;

    [Embed(source = "../data/dialogbox.png")] static public var DialogClass:Class;
    [Embed(source = "../data/portraits.png")] static public var PortraitsClass:Class;

    function DialogText(...args) {
      super(0, 0, 50, 50);
      profPic = new Entity().fromExternalMC(PortraitsClass, false, [2, 0]);
      addChild(profPic);

      fromExternalMC(DialogClass);
      addDropShadow();

      // Stick it right under the inventory box so they don't overlap.
      set(new Vec(250 - BOX_WIDTH/2, 250 - BOX_HEIGHT/2 + 25));
      profPic.set(this.clone().add(new Vec(10, 20)));

      text = new Text(x + 45, y + 8, "", BOX_WIDTH - 40);
      text.textColor = 0xffffff;
      addChild(text);

      prev_mode = Fathom.currentMode;
      Fathom.currentMode = C.MODE_TEXT;

      dialogsLeft = args;

      text.addGroups("no-camera");
      profPic.addGroups("no-camera");

      nextDialog();
    }

    private function nextDialog():void {
      var nextText:String = dialogsLeft.shift();

      if (nextText.indexOf("YOU") != -1) {
        profPic.updateExternalMC(PortraitsClass, false, [2, 0]);
        nextText = nextText.split("YOU ").join("");
      }

      if (nextText.indexOf("PROF") != -1) {
        profPic.updateExternalMC(PortraitsClass, false, [0, 0]);
        nextText = nextText.split("PROF ").join("");
      }

      text.text = nextText;
    }

    override public function groups():Array {
      return super.groups().concat("no-camera");
    }

    override public function update(e:EntityList):void {
      if (Util.keyRecentlyDown(Util.Key.Z)) {
        if (dialogsLeft.length == 0) {
          this.destroy();

          trace("going back to", prev_mode);

          Fathom.currentMode = prev_mode;
        } else {
          nextDialog();
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

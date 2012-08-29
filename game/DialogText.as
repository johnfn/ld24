package {
  public class DialogText extends Entity {
    import flash.filters.DropShadowFilter;

    private var text:Text;
    private var dialogsLeft:Array;

    private var profPic:Entity;

    private static const BOX_WIDTH:int = 250;
    private static const BOX_HEIGHT:int = 50;

    [Embed(source = "../data/dialogbox.png")] static public var DialogClass:Class;
    [Embed(source = "../data/portraits.png")] static public var PortraitsClass:Class;

    function DialogText(args:Array) {
      args = args.slice(); //clone array so we dont destroy it.

      super(0, 0, 50, 50);
      fromExternalMC(DialogClass);

      profPic = new Entity().fromExternalMC(PortraitsClass, [2, 0]);

      visible = true;

      filters = [new DropShadowFilter()];

      // Stick it right under the inventory box so they don't overlap.
      setPos(new Vec(250 - BOX_WIDTH/2, 250 - BOX_HEIGHT/2 + 25));
      profPic.setPos(new Vec(10, 20));

      text = new Text(45, 8, "", BOX_WIDTH - 40);
      text.textColor = 0xffffff;
      Fathom.pushMode(C.MODE_TEXT);

      dialogsLeft = args;

      text.addGroups("no-camera");
      profPic.addGroups("no-camera");

      nextDialog();

      addChild(profPic);
      addChild(text);
    }

    private function nextDialog():void {
      var nextText:String = dialogsLeft.shift();

      if (nextText.indexOf("YOU") != -1) {
        profPic.updateExternalMC(PortraitsClass, [2, 0]);
        nextText = nextText.split("YOU ").join("");
      }

      if (nextText.indexOf("PROF") != -1) {
        profPic.updateExternalMC(PortraitsClass, [0, 0]);
        nextText = nextText.split("PROF ").join("");
      }

      if (nextText.indexOf("STARZ") != -1) {
        profPic.updateExternalMC(PortraitsClass, [1, 0]);
        nextText = nextText.split("STARZ ").join("");
      }

      if (nextText.indexOf("ZILLA") != -1) {
        profPic.updateExternalMC(PortraitsClass, [3, 0]);
        nextText = nextText.split("ZILLA ").join("");
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

          Fathom.popMode();
        } else {
          nextDialog();
        }
      }
    }

    override public function get depth():int {
      return 300;
    }

    // Should be active in all modes.
    override public function modes():Array {
      return [C.MODE_TEXT, C.MODE_NORMAL, C.MODE_INVENTORY];
    }
  }
}

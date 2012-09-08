package {
  public class HUD extends Entity {
    private var c:Character;

    private var xText:Text;
    private var xButton:Entity;

    private var zText:Text;
    private var zButton:Entity;

    private var arrowKeys:Text;

    function HUD(c:Character) {
    	super(0, 0, 25, 25);

        zButton = new Entity().loadSpritesheet(C.SpritesheetClass, C.dim, new Vec(5, 3));
        zButton.setPos(new Vec(20, 40));
        zButton.addGroups("no-camera", "non-blocking");

    	zText = new Text("Do stuff", C.fontName);
        zText.setPos(new Vec(50, 42))
        zText.width = 200;
    	zText.addGroups("no-camera", "non-blocking");
    	zText.color = 0xffffff;

    	this.c = c;

        xButton = new Entity().loadSpritesheet(C.SpritesheetClass, C.dim, new Vec(8, 3));
        xButton.setPos(new Vec(20, 10));
        xButton.addGroups("no-camera", "non-blocking");

        xText = new Text("Do stuff", C.fontName);
        xText.setPos(new Vec(50, 12));
        xText.width = 200;
        xText.addGroups("no-camera", "non-blocking");
        xText.color = 0xffffff;

        arrowKeys = new Text("Arrow keys to cycle back/forth.", C.fontName);
        arrowKeys.setPos(new Vec(0, 30));
        arrowKeys.width = 200;

        arrowKeys.addGroups("no-camera", "non-blocking");
        arrowKeys.color = 0xffffff;
        arrowKeys.visible = false;

        addChild(zText);
        addChild(zButton);
        addChild(xText);
        addChild(xButton);
        addChild(arrowKeys);
    }

    override public function update(e:EntitySet):void {
        var inv:Inventory = Fathom.entities.one("Inventory") as Inventory;

    	zText.text = c.getActionString();

        if (Fathom.currentMode == C.MODE_INVENTORY) {
            if (inv.currentCardSelected()) {
                zText.text = "Deselect this card.";
            } else {
                zText.text = "Select this card.";
            }
        }

        arrowKeys.visible = Fathom.currentMode == C.MODE_INVENTORY;

        if (Fathom.currentMode == C.MODE_INVENTORY) {
            xText.text = "Done."
        } else if (Fathom.currentMode == C.MODE_TEXT) {
            xText.text = "";
        } else {
            xText.text = c.xAction;
        }

        if (xText.text == "") {
            xText.visible = false;
            xButton.visible = false;
        } else {
            xText.visible = true;
            xButton.visible = true;
        }
    }

    override public function get depth():int {
        return 5000;
    }

    override public function groups():Array {
      return super.groups().concat("no-camera").concat("non-blocking");
    }

	override public function modes():Array {
		return [0, 1, 2];
	}
  }
}
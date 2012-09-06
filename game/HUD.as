package {
  public class HUD extends Entity {
    private var t:Text;
    private var c:Character;

    private var xButton:Entity;
    private var xText:Text;
    private var arrowKeys:Text;

    function HUD(c:Character) {
    	super(0, 0, 25, 25);
    	loadSpritesheet(C.SpritesheetClass, C.dim, new Vec(5, 3));

    	setPos(new Vec(20, 20));
    	t = new Text(20 + 28, 20, "Do stuff", 200);
    	t.addGroups("no-camera");
    	t.textColor = 0xffffff;

    	this.c = c;

        xButton = new Entity().loadSpritesheet(C.SpritesheetClass, C.dim, new Vec(8, 3));
        xButton.setPos(this.rect().add(new Vec(0, 30)));
        xButton.addGroups("no-camera");
        xButton.ignoreCollisions();

        xText = new Text(xButton.x + 28, xButton.y, "Do stuff", 200);
        xText.addGroups("no-camera");
        xText.textColor = 0xffffff;

        arrowKeys = new Text(xButton.x, xButton.y + 30, "Arrow keys to cycle back/forth.", 200);
        arrowKeys.addGroups("no-camera");
        arrowKeys.textColor = 0xffffff;

        arrowKeys.visible = false;
    }

    override public function update(e:EntitySet):void {
        var inv:Inventory = Fathom.entities.one("Inventory") as Inventory;

    	t.text = c.getActionString();

        if (Fathom.currentMode == C.MODE_INVENTORY) {
            if (inv.currentCardSelected()) {
                t.text = "Deselect this card.";
            } else {
                t.text = "Select this card.";
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

        xButton.raiseToTop();
        xText.raiseToTop();
        t.raiseToTop();
        arrowKeys.raiseToTop();

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

    override public function collides(e:Entity):Boolean {
    	return false;
    }

    override public function groups():Array {
      return super.groups().concat("no-camera");
    }

	override public function modes():Array {
		return [0, 1, 2];
	}
  }
}
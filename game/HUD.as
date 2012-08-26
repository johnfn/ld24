package {
  public class HUD extends Entity {
    private var t:Text;
    private var c:Character;

    private var xButton:Entity;
    private var xText:Text;

    function HUD(c:Character) {
    	super(0, 0, 150, 50);
    	fromExternalMC(C.SpritesheetClass, false, [5, 3]);

    	set(new Vec(20, 20));
    	t = new Text(20 + 28, 20, "Do stuff", 200);
    	t.addGroups("no-camera");
    	t.textColor = 0xffffff;
    	addChild(t);

    	this.c = c;

        xButton = new Entity().fromExternalMC(C.SpritesheetClass, false, [8, 3]);
        xButton.set(this.clone().add(new Vec(0, 30)));
        xButton.addGroups("no-camera");

        xText = new Text(xButton.x + 28, xButton.y, "Do stuff", 200);
        xText.addGroups("no-camera");
        xText.textColor = 0xffffff;
        addChild(xText);
    }

    override public function update(e:EntityList):void {
    	t.text = c.getActionString();

        xText.text = c.xAction;

        if (xText.text == "") {
            xText.visible = false;
            xButton.visible = false;
        } else {
            xText.visible = true;
            xButton.visible = true;
        }
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
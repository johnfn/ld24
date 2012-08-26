package {
  public class HUD extends Entity {
    private var t:Text;
    private var c:Character;

    function HUD(c:Character) {
    	super(0, 0, 150, 50);
    	fromExternalMC(C.SpritesheetClass, false, [5, 3]);

    	set(new Vec(20, 20));
    	t = new Text(20 + 28, 20, "Do stuff", 200);
    	t.addGroups("no-camera");
    	t.textColor = 0xffffff;
    	addChild(t);

    	this.c = c;
    }

    override public function update(e:EntityList):void {
    	t.text = c.getActionString();
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
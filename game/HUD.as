package {
  public class HUD extends Entity {
    [Embed(source = "../data/spritesheet.png")] static public var SpritesheetClass:Class;

    var t:Text;

    function HUD() {
    	super(0, 0, 150, 50);
    	fromExternalMC(SpritesheetClass, false, [5, 3]);

    	set(new Vec(20, 20));
    	t = new Text(20 + 28, 20, "Do stuff", 200);
    	t.addGroups("no-camera");
    	t.textColor = 0xffffff;
    	addChild(t);
    }

    override public function collides(e:Entity):Boolean {
    	return false;
    }

    override public function groups():Array {
      return super.groups().concat("no-camera");
    }
  }
}
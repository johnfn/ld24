package {
  public class HUD extends Entity {
    [Embed(source = "../data/spritesheet.png")] static public var SpritesheetClass:Class;

    private var t:Text;
    private var c:Character;

    function HUD(c:Character) {
    	super(0, 0, 150, 50);
    	fromExternalMC(SpritesheetClass, false, [5, 3]);

    	set(new Vec(20, 20));
    	t = new Text(20 + 28, 20, "Do stuff", 200);
    	t.addGroups("no-camera");
    	t.textColor = 0xffffff;
    	addChild(t);

    	this.c = c;
    }

    private function getActionString():String {
    	var evolutions:Array = c.getEvolutions();
    	var action:String = "Nothing";

    	if (evolutions.length == 1) {
    		if (evolutions.contains(Inventory.ICE)) {
    			action = "Freeze";
    		}

    		if (evolutions.contains(Inventory.AIR)) {
    			action = "Jump";
    		}

    		if (evolutions.contains(Inventory.BOLT)) {
    			action = "Energize";
    		}
    	}

    	if (evolutions.length == 2) {
    		if (evolutions.contains(Inventory.AIR) && evolutions.contains(Inventory.BOLT)) {
    			action = "Smash"
    		} else if (evolutions.contains(Inventory.AIR) && evolutions.contains(Inventory.ICE)) {
    			action = "Shoot Ice"
    		} else {
    			action = "Fly";
    		}
    	}

    	return action;
    }

    override public function update(e:EntityList):void {
    	t.text = getActionString();
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
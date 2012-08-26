package {
  public class Treasure extends Entity {
    private var type:int;
    private const SIZE:int = C.size;

    //TODO This is a hack.
    private var gone:Boolean = false;

    function Treasure(x:int=0, y:int=0, type:int=0) {
      super(x, y, SIZE, SIZE);
    }

    public override function collides(e:Entity):Boolean {
    	if (e.groups().contains("Character") && super.collides(e) && !gone) {
            var whichMap:Vec = Fathom.mapRef.getTopLeftCorner();

            trace(whichMap);

            var response:Array = ["Oh GOD HOW DID YOU FIND THIS."];
            var itemType:int = Inventory.ICE;

            if (whichMap.equals(new Vec(25, 0))) {
                response = C.firstAirEv;
                itemType = Inventory.AIR;
            }

    		this.destroy();

            (Fathom.entities.one("Inventory") as Inventory).addItem(itemType);

    		new Entity().fromExternalMC(C.SpritesheetClass, false, [3, 0]).ignoreCollisions().set(this);
            new DialogText(response);

    		// Make opened treasure chest.
            gone = true;
    		return false;
    	}

    	return false;
    }
  }
}

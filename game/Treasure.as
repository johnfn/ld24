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

            var response:String = "Oh GOD HOW DID YOU FIND THIS.";
            var itemType:int = Inventory.ICE;

            if (whichMap.equals(new Vec(0, 0))) {
                response = "Oh cool, an air ... evolution ... thing ..? I don't know how to use it."
                itemType = Inventory.AIR;
            }

    		this.destroy();

    		new DialogText(response);
            (Fathom.entities.one("Inventory") as Inventory).addItem(itemType);

    		new Entity().fromExternalMC(C.SpritesheetClass, false, [3, 0]).ignoreCollisions().set(this);

    		// Make opened treasure chest.
            gone = true;
    		return false;
    	}

    	return false;
    }
  }
}

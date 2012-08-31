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

            C.powerupSound.play();

            trace(whichMap);

            var response:Array = ["Oh GOD HOW DID YOU FIND THIS."];
            var itemType:int = Inventory.ICE;

            if (whichMap.equals(new Vec(25, 25))) {
                response = C.firstIceEv;
                itemType = Inventory.ICE;
            }

            if (whichMap.equals(new Vec(175, 25))) {
                response = C.firstBoltEv;
                itemType = Inventory.BOLT;
            }

            if (whichMap.equals(new Vec(0, 25))) {
                response = C.firstAirEv;
                itemType = Inventory.AIR;
            }

            if (whichMap.equals(new Vec(25, 0))) {
                new DialogText(C.nothingThere);
                setTile(3, 0);
                gone = true;

                // Exit early so we don't give him anything. trolololol
                return false;
            }

            if (whichMap.equals(new Vec(175, 0))) {
                response = C.secondAirEv;
                itemType = Inventory.AIR;
            }

            (Fathom.entities.one("Inventory") as Inventory).addItem(itemType);

            // Make opened treasure chest.
    		setTile(3, 0);
            new DialogText(response);

            gone = true;
    		return false;
    	}

    	return false;
    }
  }
}

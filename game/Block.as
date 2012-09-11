package {
  public class Block extends Entity {
    private var type:int;
    private const SIZE:int = C.size;
    private var isFrozen:Boolean = false;

    public var profsCompEnergized:Boolean = false;

    function Block(x:int=0, y:int=0, type:int=0) {
      super(x, y, SIZE, SIZE);
    }

    public function freezeOver():void {
    	if (!isFrozen && spriteY == 1) {
	    	setTile(spriteX, spriteY + 3);
	    	isFrozen = true;
	    }
    }

    public function frozen():Boolean {
      return isFrozen;
    }
  }
}

package {
  public class Bolt extends MovingEntity {
    private var type:int;
    private const SIZE:int = C.size;

    function Bolt(x:int=0, y:int=0, type:int=0) {
      super(x, y, SIZE, SIZE);
    }

    override public function collides(e:Entity):Boolean {
    	if (e.groups().contains("Character") || e.groups().contains("non-blocking")) {
    		return false;
    	}

    	if (super.collides(e)) {
    		this.destroy();
    		trace(e);
    		return true;
    	}

    	return false;
    }
  }
}

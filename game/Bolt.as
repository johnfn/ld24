package {
  public class Bolt extends MovingEntity {
    private var type:int;
    private const SIZE:int = C.size;

    private var grps:Array;

    function Bolt(x:int=0, y:int=0, type:int=0) {
      super(x, y, SIZE, SIZE);

      on("pre-update", Hooks.platformerLike(this));

      on("post-update", Hooks.resolveCollisions());

      grps = super.groups()
      grps.remove("persistent")
      grps = grps.concat("non-blocking");

    }

    override public function update(e:EntityList):void {
    	if (currentlyBlocking().length) {
    		this.destroy();
    	}

    	if (currentlyTouching("Terminal").length) {
    		var terms:EntityList = currentlyTouching("Terminal");

    		if (terms.length == 0) return;

    		for (var i:int = 0; i < terms.length; i++) {
    			terms[i].activate();
    			terms[i].useGate();
    		}

    		this.destroy();
    	}

      if (Hooks.hasLeftMap(this, Fathom.mapRef)) {
        this.destroy();
      }
    }

    override public function groups():Array {
      return grps;
    }
  }
}

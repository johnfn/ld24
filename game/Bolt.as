package {
  public class Bolt extends MovingEntity {
    private var type:int;
    private const SIZE:int = C.size;

    function Bolt(x:int=0, y:int=0, type:int=0) {
      super(x, y, SIZE, SIZE);

      on("pre-update", Hooks.platformerLike(this));

      on("post-update", Hooks.resolveCollisions());
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
    }

    override public function groups():Array {
      return super.groups().concat("non-blocking");
    }
  }
}

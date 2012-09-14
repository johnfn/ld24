package {
  public class Bolt extends MovingEntity {
    private var type:int;
    private const SIZE:int = C.size;

    private var grps:Set;

    function Bolt(x:int=0, y:int=0, type:int=0) {
      super(x, y, SIZE, SIZE);

      grps = super.groups()
      grps.remove("persistent")
      grps = grps.concat("non-blocking");
    }

    override public function update(e:EntitySet):void {
    	if (isBlocked()) {
    		//this.destroy();
    	}

      for each (var t:Terminal in touchingSet("Terminal")) {
        t.activate();
        t.useGate();

        this.destroy();
      }

      if (Hooks.hasLeftMap(this, Fathom.mapRef)) {
        this.destroy();
      }
    }

    override public function groups():Set {
      return grps;
    }
  }
}

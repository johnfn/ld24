package {
  public class Terminal extends Entity {
    private var type:int;
    private const SIZE:int = C.size;
    private var _isActivated:Boolean = false;
    private var totallyDead:Boolean = false;

    public function get isActivated():Boolean {
    	return _isActivated;
    }

    public function set isActivated(v:Boolean):void {
    	this._isActivated = v;
    }

    function Terminal(x:int=0, y:int=0, type:int=0) {
      super(x, y, SIZE, SIZE);
    }

    public function activate():void {
    	if (!isActivated && !totallyDead) {
	    	updateExternalMC(C.SpritesheetClass, false, [3, 2]);
	    	isActivated = true;
	    }
    }

    // TODO: Remove the gate.
    public function useGate():void {
    	updateExternalMC(C.SpritesheetClass, false, [3, 3]);
    	totallyDead = true;

    	trace("Opengate");
    }

    public override function groups():Array {
        return super.groups().concat("non-blocking");
    }
  }
}

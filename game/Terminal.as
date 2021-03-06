package {
  public class Terminal extends Entity {
    private var type:int;
    private const SIZE:int = C.size;
    private var _isActivated:Boolean = false;
    private var totallyDead:Boolean = false;
    private var crushed:Boolean = false;

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
	    	setTile(3, 2);
	    	isActivated = true;
	    }
    }

    public function crush():void {
        activate();
        useGate();

        crushed = true;
    }

    public function useGate():void {
    	setTile(3, 3);

        isActivated = false;
    	totallyDead = true;

        for each (var gate:Gate in Fathom.entities.get("Gate")) {
            gate.open();
        }
    }

    public function wasCrushed():Boolean {
        return crushed;
    }

    public function notDead():Boolean {
        return !totallyDead;
    }

    public override function groups():Set {
        return super.groups().concat("non-blocking");
    }
  }
}

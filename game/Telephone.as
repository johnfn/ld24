package {
  public class Telephone extends Entity {
    private var type:int;
    private const SIZE:int = C.size;

    function Telephone(x:int=0, y:int=0, type:int=0) {
      super(x, y, SIZE, SIZE);
    }

    override public function groups():Set {
      return super.groups().concat("non-blocking");
    }
  }
}

package {
  public class Professor extends Entity {
    private var type:int;
    private const SIZE:int = C.size;

    function Professor(x:int=0, y:int=0, type:int=0) {
      super(x, y, SIZE, SIZE);
    }

    public override function groups():Set {
        return super.groups().concat("non-blocking");
    }
  }
}

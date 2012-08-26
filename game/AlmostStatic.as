package {
  public class AlmostStatic extends Entity {
    private var type:int;
    private const SIZE:int = C.size;

    function AlmostStatic(x:int=0, y:int=0, type:int=0) {
      super(x, y, SIZE, SIZE);
    }
  }
}

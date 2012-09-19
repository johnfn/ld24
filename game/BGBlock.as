package {
  public class BGBlock extends Entity {
    function BGBlock(x:int=0, y:int=0, type:int=0) {
      super(x, y, C.size, C.size);
    }

    override public function groups():Set {
      return super.groups().concat("non-blocking");
    }
  }
}

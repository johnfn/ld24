package {
  public class C {
    public static var size:int = 25;
    public static var DEBUG:Boolean = true;

    // Graphics.
    [Embed(source = "../data/spritesheet.png")] static public var SpritesheetClass:Class;

    [Embed(source = "../data/Character.png")] static public var CharacterClass:Class;
    [Embed(source = "../data/ROAR.png")] static public var EndGameClass:Class;

    // Game modes.
    public static var MODE_NORMAL:int    = 0; // Should be the only unpaused mode.
    public static var MODE_INVENTORY:int = 1;
    public static var MODE_TEXT:int      = 2;

    /*public static var firstAirEv:Array = [   "YOU Oh cool, an air ... evolution ... thing ..?"
	    		                           , "YOU I heard about these on TV!"
				                           , "YOU But I don't know how to use them."
				                           , "YOU I'll hold onto it just in case."];*/

	public static var firstIceEv:Array =   [ "YOU Hmm, this card looks like ice."
    	    		                           , "YOU I wonder what it does?"
      				                           , "YOU Too bad the prof isn't nearby."
      				                           ];

  public static var eggy:Array = [ "ZILLA Wow, you found it!"
                                 , "ZILLA I am seriously impressed."
                                 , "ZILLA Allow me to revert back to my normal form as to avoid spoilers..."
                                 , "STARZ Screenshot this and show it to your friends!"
                                 ];

  public static var theTerminalWorks:Array = [ "YOU The Prof's computer is back in working order."
                                             , "YOU I wonder if he has anything embarrassing on here."
                                             , "YOU ..."
                                             , "YOU OH MY GOD!"
                                             , "YOU Internet Explorer?!"
                                             , "YOU ..."
                                             , "YOU In COMIC SANS???"
                                             , "PROF Hey! What are you doing with my terminal?!"
                                             , "YOU Whoops. Uh... How did you know I was out here?"
                                             , "PROF You were talking to yourself the whole time."
                                             , "YOU Derp."
                                             ];

  public static var firstBoltEv:Array = [  "YOU Hey, this card looks like electricity!"
                                         , "YOU Man, this would have been a MUCH better idea than crushing consoles with crates."
                                         , "YOU Wait a minute."
                                         , "YOU This was hidden behind a console machine I needed to turn on."
                                         , "YOU How did they get it back there in the first place??"
                                         , "YOU I"
                                         , "YOU N"
                                         , "YOU C"
                                         , "YOU E"
                                         , "YOU P"
                                         , "YOU T"
                                         , "YOU Wait this is stupid."]

    public static var firstAirEv:Array = [ "YOU Hey, an Air card!"
                                         , "YOU I think that's all the card types."
                                         , "YOU Guess I'm done with the game now."
                                         , "STARZ Nope."
                                         ];

    public static var firstTalkProf:Array =[ "YOU Hello!"
	    		                           , "PROF What can I do for you, my boy?"
				                           , "YOU Um."
				                           , "YOU It's a little embarrassing."
				                           , "PROF Go on."
				                           , "YOU Well you see."
				                           , "YOU I was exploring."
				                           , "YOU And I don't know how to jump."
				                           , "YOU So I kept falling down cliffs and now it looks like I'm stuck here unless you can help."
				                           , "PROF ..."
				                           , "PROF You're right."
				                           , "PROF That is literally the dumbest thing I've heard all day."
				                           , "PROF ..."
				                           , "PROF Here, let me help you out."
				                           , "STARZ Got the *jumper*!"
				                           , "PROF That'll allow you to jump with the X key."
				                           , "YOU What the heck is a X key?."
				                           , "PROF Never mind."
				                           , "PROF Come back if you need more help."
				                           ];

    public static var dismissiveProf:Array=[ "STARZ The professor looks over you."
                                           , "PROF You don't need more help."
                                           ];

    public static var wishICouldFixThatTerminal:Array=[
                                            "PROF They say if you combine all 3 card types, something incrdible happens!"
                                           , "PROF I wish that terminal outside worked, so I could look up a walkthrough..."
                                           , "YOU Huh?"
                                           , "PROF Oh!"
                                           , "PROF I didn't see you there."
                                           , "YOU ..?"
                                           , "PROF Well, get going then."
                                           ];

    public static var whosThat:Array=      [ "STARZ Ring ring ring..."
                                           , "PROF Who is this?"
                                           , "YOU Um."
                                           , "PROF Sorry, I don't take calls from telemarketers."
        				                           , "STARZ The person on the other side of the line hangs up."
                                           ];

    public static var consoleCrusher:Array=[ "YOU Oh my God!"
                                           , "YOU I crushed the console with that block!"
                                           , "YOU WHY AM I SO DUMB?!?"
                                           , "YOU Actually, that looked like it worked somehow."
                                           , "YOU Yay :D"
                                           ];

    public static var profConCrush:Array = [ "STARZ You've earned the achievement: CONSOLE M-M-MONSTERKILL"//CRUSH ALL THE CONSOLES!"
                                           , "STARZ Just kidding. There are no achievements in this game."
                                           , "YOU WHY DO I KEEP DOING THIS?"
                                           , "STARZ The console flickers to life!"
                                           , "YOU AND WHY DOES IT KEEP WORKING?!?"]

    public static var coolThingFromProf:Array=[ "PROF Hey, thanks for fixing my Terminal!"
                                           , "YOU Uh, 'Fixed', sure."
                                           , "PROF Because I'm feeling generous... "
                                           , "PROF I'll allow you to see a prototype of something I've been working on recently."
                                           , "STARZ Got the *2X EVOLVER*!!"
                                           , "YOU Yay :D"
                                           , "YOU What's it do?"
                                           , "PROF It lets you combine two cards, for super evolution potential!!!"
                                           , "YOU Sweet!"
                                           , "PROF But beware! There is a small but non-negligible change that you may evolve into Godzilla."
                                           , "YOU What?"
                                           , "PROF Don't worry about it."
                                           , "YOU HUH??"
                                           , "PROF I'm sure it'll never happen."
                                           ];

    public static var whatNow:Array=      [ "STARZ Ring ring ring..."
                                           , "PROF What now?"
                                           , "YOU Uh."
                                           , "PROF If you find a card, come talk to me."
                                           , "PROF Otherwise, I'm busy!"
        				                           , "STARZ Click."
                                           ];

    public static var newStuff:Array=      [ "PROF Hey, if you can fetch me an Air card, I might be able to make you something neat."
                                           ];

    public static var dontDoThat:Array=    [ "PROF Hey, what are you doing?!"
                                           , "YOU Um."
                                           , "YOU Combining ice and air?"
                                           , "PROF Yeah.. don't do that."
                                           ];

    public static var withOneAir:Array=    [ "PROF Hey, can I have your Air card?"
                                           , "YOU No way!"
                                           , "YOU It's my only one."
                                           , "YOU I like big jumps."
                                           , "YOU Maybe if I find another one."
                                           , "PROF All this I do for you... Fine, okay."
                                           ];

    public static var withTwoAirs:Array=   [ "PROF Ooh, you have two Airs now! Now you have to give me one!"
                                           , "YOU But I really like flying..."
                                           , "PROF Oh come on."
                                           , "YOU Fine."
                                           , "STARZ Lost 1 *Air* card."
                                           , "PROF And here you are."
                                           , "STARZ Got the *3X EVOLVER*!!!"
                                           , "YOU Awesome!"
                                           , "YOU Now I can finally see what all three cards combined are!"
                                           , "PROF It's just..."
                                           , "YOU Hm?"
                                           , "PROF The more cards you combine, the larger the chance you could evolve into Godzilla."
                                           , "YOU Come on. There's no way that could happen. This is Ludum Dare, not some Japanese horror."
                                           , "PROF What's Ludum Dare?"
                                           , "YOU Huh? Hoodlum what?"
                                           , "PROF Never mind. Give it a spin!"
                                           ];

    public static var firstEvolProf:Array=[ "PROF Ah, an evolution card."
    									  , "PROF Let me help you out with that."
    									  , "PROF When you're standing near me, press X."
    									  , "PROF That will open up the evolve screen."
    									  , "PROF You navigate it with the arrow keys, and select with Z."
    									  , "PROF You can choose a card to use to evolve yourself."
    									  , "PROF After you hit Z to quit, I'll do some mad science and you'll get the new ability!"
				                          , "YOU I have NO IDEA what you just said."
                                          ];
  }
}


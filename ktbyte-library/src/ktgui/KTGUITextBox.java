package ktgui;

import ktbyte.gui.KeyEventListener;

public class KTGUITextBox extends Controller {

	private final static int	BACKSPACE_ASCII_CODE	= 8;
	private final static int	ENTER_ASCII_CODE		= 10;
	private final static int	BASIC_ASCII_LOWER_LIMIT	= 32;
	private final static int	BASIC_ASCII_UPPER_LIMIT	= 126;

	//private PApplet				parent; // handled by super() 
	//private int					x, y, w, h; // handled by super() 
	private int					r1, r2, r3, r4;					// box rounding parameters
	private boolean				handleFocus				= true;
	private boolean				isFocused;
	private String				textInput;
	private int					textSize;
	private float				textHeight;
	private KeyEventListener	keyEventListener;
	private float				padding;

	public KTGUITextBox(KTGUI ktgui, int x, int y, int w, int h) {
		super(ktgui);
		this.posx = x;
		this.posy = y;
		this.w = w;
		this.h = h;
		this.textInput = "";
		this.textSize = 18;
	}

	/**
	 * Sets the rounding of the rectangle's border. The parameters should be entered in a clockwise order
	 * 
	 * @param r1
	 * 	Up
	 * @param r2
	 * 	Right
	 * @param r3
	 * 	Down
	 * @param r4
	 * 	Left
	 */
	public void setBorderRoundings(int r1, int r2, int r3, int r4) {
		this.r1 = r1;
		this.r2 = r2;
		this.r3 = r3;
		this.r4 = r4;
	}

	private void computeDefaultAttributes() {
		this.padding = 0.08f * h;
		pa.textSize(this.textSize);
		this.textHeight = pa.textAscent() + pa.textDescent();
		computeTextSize();
	}

	private void computeTextSize() {
		while (textHeight > h - padding * 2) {
			this.textSize--;
			pa.textSize(this.textSize);
			this.textHeight = pa.textAscent() + pa.textDescent();
		}
	}
}

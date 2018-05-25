package ktgui;

import java.util.ArrayList;
import java.util.HashMap;

import processing.event.MouseEvent;

public class KTGUIConsole extends Controller {
	private final static int		BOX_RONDING					= 7;
	private final static int		SCROLL_BAR_WIDTH			= 20;
	private final static float		INPUT_BOX_HEIGHT_PERCENTAGE	= 0.1f;

	private int						inputTextColor;
	private int						outputTextColor;
	private int						inputBoxHeight;
	private int						globalPadding;
	private int						lineScrollOffset;
	private boolean					isFocused;
	private int						textSize;
	private int						maxLinesToDisplay;
	private float					textHeight;
	private float					scrollBarMaxHeight;
	private ArrayList<Line>			lines;
	private HashMap<String, String>	dict;
	//	private ConsoleInputListener consoleInputListener;
	//	private String lastVariableName;
	//	private ArrowButton upBtn;
	//	private ArrowButton downBtn;
	private KTGUITextBox			inputBox;

	public KTGUIConsole(KTGUI ktgui, int x, int y, int width, int height) {
		super(ktgui);
		this.inputTextColor = pa.color(255);
		this.outputTextColor = pa.color(170);
		this.posx = x;
		this.posy = y;
		this.w = width;
		this.h = height;
		this.globalPadding = 10;
		this.inputBoxHeight = (int) (INPUT_BOX_HEIGHT_PERCENTAGE * h);
		this.lines = new ArrayList<>();
		this.dict = new HashMap<String, String>();
		inputBox = new KTGUITextBox(ktgui, "ConsoleTextBox", x, y + h - inputBoxHeight, w, inputBoxHeight);
		inputBox.setHandleFocus(true);
		inputBox.setBorderRoundings(0, 0, 7, 7);
//		inputBox.setKeyEventListener(new KeyEventListener() {
//	
//			@Override
//			public void onEnterKey() {
//				handleConsoleInput();
//			}
//		});
		computeDefaultAttributes();
	}
	
	private void computeDefaultAttributes() {
		if (h < 400) {
			this.textSize = 18;
		} else if (h < 900) {
			this.textSize = 22;
		} else {
			this.textSize = 24;
		}
		pa.textSize(this.textSize);
		this.textHeight = pa.textAscent() + pa.textDescent();
		this.maxLinesToDisplay = computeMaxLinesToDisplay();
		this.scrollBarMaxHeight = h - inputBoxHeight - SCROLL_BAR_WIDTH * 2;
	}

	private int computeMaxLinesToDisplay() {
		return (int) ((0.9 * h - globalPadding * 2) / (textHeight + 2));
	}
	
	public void processMousePressed() {
		if (isPointInside(pa.mouseX, pa.mouseY)) {
			isFocused = true;
			inputBox.setIsFocused(true);
		} else {
			isFocused = false;
			inputBox.setIsFocused(false);
		}
		//		if (upBtn.isPressed(pa.mouseX, pa.mouseY)) {
		//			if (-lineScrollOffset < lines.size() - maxLinesToDisplay) {
		//				lineScrollOffset--;
		//			}
		//		} else if (downBtn.isPressed(pa.mouseX, pa.mouseY)) {
		//			if (lineScrollOffset < 0) {
		//				lineScrollOffset++;
		//			}
		//		}
	}

	public void processMouseWheel(MouseEvent me) {
		mouseScrolled(me.getCount());
	}

	private void mouseScrolled(int mouseWheelDelta) {
		if (!this.isFocused) {
			return;
		}
		if (mouseWheelDelta < 0) {
			if (-lineScrollOffset < lines.size() - maxLinesToDisplay) {
				lineScrollOffset--;
			}
		} else if (mouseWheelDelta > 0) {
			if (lineScrollOffset < 0) {
				lineScrollOffset++;
			}
		}
	}

	private boolean isPointInside(int x, int y) {
		return x > posx && x < posx + w && y > posy && y < posy + h;
	}

	private class Line {
		public String	text;
		public int		textColor;

		Line() {
			this.text = "";
		}
	}
}

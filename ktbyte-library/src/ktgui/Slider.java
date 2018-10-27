package ktgui;

import processing.core.PApplet;

/************************************************************************************************
*
************************************************************************************************/
public class Slider extends Controller {

    public final static int HANDLE_TYPE_CENTERED = 1;
    public final static int HANDLE_TYPE_EXPANDED = 0;

    private int             handleType           = HANDLE_TYPE_EXPANDED;
    private float           handleSize           = KTGUI.DEFAULT_COMPONENT_WIDTH;
    private float           handlePos            = 0;
    private float           rangeStart           = 0;
    private float           rangeEnd             = 100;
    private float           value                = rangeStart;
    private float           valueStep            = 1;
    private float           roundingTemplate     = 10;
    private boolean         isValueVisible       = true;

    Slider(KTGUI ktgui, String title, int posx, int posy, int w, int h, int sr, int er) {
        super(ktgui, title, posx, posy, w, h);
        this.rangeStart = sr;
        this.rangeEnd = er;
        setHandleType(HANDLE_TYPE_EXPANDED);
        updateHandlePositionFromValue();
        updateHandlePositionFromMouse();
        updateValueFromHandlePosition();
    }

    @Override
    public void updateGraphics() {
        super.updateGraphics();
        if (handleType == HANDLE_TYPE_CENTERED) {
            drawCenteredHandle();
        } else if (handleType == HANDLE_TYPE_EXPANDED) {
            drawExpandedHandle();
        } else {
            drawExpandedHandle();
        }
    }

    private void drawExpandedHandle() {
        ///////////////////////////////////////////////////////////////////////
        pg.beginDraw(); // start drawing the slider
        ///////////////////////////////////////////////////////////////////////

        // add rectangle that shows the slider boundaries
        pg.fill(isHovered ? KTGUI.COLOR_BG_HOVERED : KTGUI.COLOR_BG_PASSIVE);
        pg.rectMode(CORNER);
        pg.rect(0, 0, this.w, this.h);

        ///////////////////////////////////////////////////////////////////////
        // add rectangle that fills the space between the start of the slider and
        // the center of its handle
        pg.fill(isHovered ? KTGUI.COLOR_FG_HOVERED : KTGUI.COLOR_FG_PASSIVE);
        if (w > h) {
            pg.rect(0, 0, handlePos, this.h);
        } else {
            pg.rect(0, this.h - handlePos, this.w, handlePos);
        }

        ///////////////////////////////////////////////////////////////////////
        // add text label that displays the current value of the slider
        if (isValueVisible) {
            pg.fill(0);
            pg.textAlign(LEFT, CENTER);
            if (w > h) {
                pg.text(PApplet.str(value), 10, h * 0.5f);
                pg.textAlign(LEFT, BOTTOM);
                pg.text(title, 10, -2);
            } else {
                pg.text(PApplet.str(value), 1, h * 0.5f);
            }
        }

        ///////////////////////////////////////////////////////////////////////
        pg.endDraw(); // stop drawing the slider
        ///////////////////////////////////////////////////////////////////////
    }

    private void drawCenteredHandle() {
        ///////////////////////////////////////////////////////////////////////
        pg.beginDraw(); // start drawing the slider
        ///////////////////////////////////////////////////////////////////////

        // add rectangle that is centered at the handle position
        pg.fill(isHovered ? KTGUI.COLOR_BG_HOVERED : KTGUI.COLOR_BG_PASSIVE);
        pg.rectMode(CORNER);
        pg.rect(0, 0, this.w, this.h);

        ///////////////////////////////////////////////////////////////////////
        // add rectangle that is centered about the current handle position
        pg.fill(isHovered ? KTGUI.COLOR_FG_HOVERED : KTGUI.COLOR_FG_PASSIVE);
        pg.rectMode(CENTER);
        int handleOffset = (int) (handleSize * 0.5f);
        if (w > h) {
            int correctedHandlePos = (int) PApplet.constrain(handlePos, handleOffset, this.w - handleOffset);
            pg.rect(correctedHandlePos, this.h * 0.5f, handleSize, this.h);
        } else {
            int correctedHandlePos = (int) PApplet.constrain(handlePos, handleOffset, this.h - handleOffset);
            pg.rect(this.w * 0.5f, this.h - correctedHandlePos, this.w, handleSize);
        }

        ///////////////////////////////////////////////////////////////////////
        // add text label that displays the current value of the slider
        if (isValueVisible) {
            pg.fill(0);
            pg.textAlign(LEFT, CENTER);
            if (w > h) {
                pg.text(PApplet.str(value), 10, h * 0.5f);
                pg.textAlign(LEFT, BOTTOM);
                pg.text(title, 10, -2);
            } else {
                pg.text(PApplet.str(value), 1, h * 0.5f);
            }
        }

        ///////////////////////////////////////////////////////////////////////
        pg.endDraw(); // stop drawing the slider
        ///////////////////////////////////////////////////////////////////////
    }

    public void addEventAdapter(KTGUIEventAdapter adapter) {
        adapters.add(adapter);
    }

    public float getValue() {
        return value;
    }

    public void setValue(float val) {
        if (val >= rangeStart && val <= rangeEnd) {
            value = val;
            updateHandlePositionFromValue();
        } else {
            System.out.println("You're trying to set the value of the slider "
                    + "to be outside its range.");
        }
    }

    public boolean getIsValueVisible() {
        return isValueVisible;
    }

    public void setIsValueVisible(boolean visible) {
        this.isValueVisible = visible;
    }

    public float getHandlePos() {
        return handlePos;
    }

    public void setHandlePos(float pos) {
        System.out.println("Trying to set handle pos to " + pos);
        if (w > h) {
            if (pos >= 0 && pos <= w) {
                handlePos = pos;
                updateValueFromHandlePosition();
            } else {
                System.out.println("You're trying to set the position of the slider "
                        + "to be outside its width.");
            }
        } else {
            if (pos >= 0 && pos <= h) {
                handlePos = pos;
                updateValueFromHandlePosition();
            } else {
                System.out.println("You're trying to set the position of the slider "
                        + "to be outside its height.");
            }
        }
        System.out.println("Handle position is: " + handlePos + ", value is:" + value);
    }

    public float getValueStep() {
        return valueStep;
    }

    public void setHandleValue(float valueStep) {
        if (valueStep > 0) {
            this.valueStep = valueStep;
        }
    }

    public void incrementValue() {
        float newVal = value + valueStep;
        setValue(newVal > rangeEnd ? rangeEnd : newVal);
    }

    public void decrementValue() {
        float newVal = value - valueStep;
        setValue(newVal < rangeStart ? rangeStart : newVal);
    }

    public void setHandleType(int handleType) {
        this.handleType = handleType;
        if (handleType == HANDLE_TYPE_EXPANDED) {
            handleSize = 0;
        } else if (handleType == HANDLE_TYPE_CENTERED) {
            handleSize = KTGUI.DEFAULT_COMPONENT_WIDTH;
        }
    }

    public float getHandleSize() {
        return handleSize;
    }

    public void setHandleSize(float hSize) {
        if (w > h) {
            this.handleSize = PApplet.constrain(hSize, KTGUI.DEFAULT_COMPONENT_WIDTH, this.w);
        } else {
            this.handleSize = PApplet.constrain(hSize, KTGUI.DEFAULT_COMPONENT_WIDTH, this.h);
        }
        updateValueFromHandlePosition();
    }

    public float getRangeStart() {
        return rangeStart;
    }

    public void setRangeStart(float rangeStart) {
        if (rangeStart < rangeEnd) {
            this.rangeStart = rangeStart;
            updateValueFromHandlePosition();
            KTGUI.debug("[" + title + "] range start set to " + rangeStart);
        } else {
            KTGUI.debug("[" + title + "] range start cannot be set greater than its range end.");
        }
    }

    public float getRangeEnd() {
        return rangeEnd;
    }

    public void setRangeEnd(float rangeEnd) {
        if (rangeEnd > rangeStart) {
            this.rangeEnd = rangeEnd;
            updateValueFromHandlePosition();
            KTGUI.debug("[" + title + "] range end set to " + rangeEnd);
        } else {
            KTGUI.debug("[" + title + "] range end cannot be set smaller than its range start.");
        }
    }

    public void setRounding(int n) {
        roundingTemplate = (float) Math.pow(10, n);
    }

    /**
     * This method is called when the user change the <b>value</b> of the slider 
     * without the mouse, using the setValue(int) method.
     */
    private void updateHandlePositionFromValue() {
        if (w > h) {
            handlePos = PApplet.map(value, rangeStart, rangeEnd,
                    handleSize * 0.5f, this.w - handleSize * 0.5f);
        } else {
            handlePos = PApplet.map(value, rangeStart, rangeEnd,
                    handleSize * 0.5f, this.h - handleSize * 0.5f);
        }
    }

    /**
     * This method is called when the user change the <b>position</b> of the slider 
     * with the mouse.
     */
    private void updateHandlePositionFromMouse() {
        if (w > h) {
            // handlePos = PApplet.constrain(pa.mouseX - getAbsolutePosX(), 0, this.w);
            handlePos = PApplet.constrain(pa.mouseX - getAbsolutePosX(),
                    handleSize * 0.5f, this.w - handleSize * 0.5f);
        } else {
            // handlePos = PApplet.constrain(this.h - (pa.mouseY - getAbsolutePosY()), 0, this.h);
            handlePos = PApplet.constrain(this.h - (pa.mouseY - getAbsolutePosY()),
                    handleSize * 0.5f, this.h - handleSize * 0.5f);
        }
    }

    /**
     *  This method is called to recalculate the slider's `value` within the given range 
     *  when the user change the <b>position</b> of the slider with the mouse.
     */
    private void updateValueFromHandlePosition() {
        if (w > h) {
            value = PApplet.map(handlePos, handleSize * 0.5f, this.w - handleSize * 0.5f, rangeStart, rangeEnd);
        } else {
            value = PApplet.map(handlePos, handleSize * 0.5f, this.h - handleSize * 0.5f, rangeStart, rangeEnd);
        }

        value = PApplet.constrain(value, rangeStart, rangeEnd);

        // based on
        // https://stackoverflow.com/questions/10430370/truncate-a-float-in-java-1-5-excluding-setroundingmode
        if (roundingTemplate > 0) {
            value = Math.round(value * roundingTemplate) / roundingTemplate;
        } else {
            value = (float) Math.floor(value);
        }
    }

    // process mouseMoved event received from PApplet
    public void processMouseMoved() {
        isHovered = isPointInside(pa.mouseX, pa.mouseY);

        // always notify the listeners
        for (KTGUIEventAdapter adapter : adapters) {
            adapter.onMouseMoved();
        }
    }

    // process mousePressed event received from PApplet
    public void processMousePressed() {
        isPressed = isHovered;

        if (isPressed) {
            updateHandlePositionFromMouse();
            updateValueFromHandlePosition();
        }

        // always notify the listeners
        for (KTGUIEventAdapter adapter : adapters) {
            adapter.onMousePressed();
        }
    }

    // process mouseReleased event received from PApplet
    public void processMouseReleased() {
        isPressed = false;
        isDragged = false;

        // always notify the listeners
        for (KTGUIEventAdapter adapter : adapters) {
            adapter.onMouseReleased();
        }
    }

    // process mouseDragged event received from PApplet
    public void processMouseDragged() {
        isDragged = isPressed;

        if (isPressed) {
            updateHandlePositionFromMouse();
            updateValueFromHandlePosition();
        }

        // always notify the listeners
        for (KTGUIEventAdapter adapter : adapters) {
            adapter.onMouseDragged();
        }
    }
}

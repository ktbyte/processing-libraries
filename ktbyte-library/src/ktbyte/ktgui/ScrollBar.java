package ktbyte.ktgui;

public class ScrollBar extends Controller {

    private ArrowButton backwardButton, forwardButton;
    private Slider      slider;

    ScrollBar(KTGUI ktgui, String title, int posx, int posy, int w, int h, int sr, int er) {
        super(ktgui, title, posx, posy, w, h);
        createButtons();
        createSlider(sr, er);
        setBorderRoundings(5, 5, 5, 5);
    }

    @Override
    public void updateGraphics() {
        super.updateGraphics();
    }

    /*   
     *  This method overrides the default Controller's implementation in order to 
     *  prevent interrupting the processing of the mousePressed event if controller 
     *  has the childs. (in default Controller's implementation this was done in order 
     *  to prevent 'duplicate' pressing/dragging).
     */
    //    @Override
    //    public void processMousePressed() {
    //        if (isActive) {
    //            // transfer mousePressed event to child controllers
    //            for (Controller child : controllers) {
    //                child.processMousePressed();
    //            }
    //
    //            // process mousePressed event by own means
    //            isPressed = isFocused = isHovered;
    //            if (isPressed) {
    //                for (KTGUIEventAdapter adapter : adapters) {
    //                    adapter.onMousePressed();
    //                }
    //            }
    //        }
    //    }

    @Override
    public void setBorderRoundings(int r1, int r2, int r3, int r4) {
        if (w > h) {
            backwardButton.setBorderRoundings(r1, 0, 0, r4);
            forwardButton.setBorderRoundings(0, r2, r3, 0);
        } else {
            forwardButton.setBorderRoundings(r1, r2, 0, 0);
            backwardButton.setBorderRoundings(0, 0, r3, r4);
        }
    }

    private void createButtons() {
        if (w > h) {
            backwardButton = new ArrowButton(ktgui, "bckwrdBtn:" + title, 0, 0, h, h, LEFT);
            forwardButton = new ArrowButton(ktgui, "frwrdBtn:" + title, w - h, 0, h, h, RIGHT);
        } else {
            forwardButton = new ArrowButton(ktgui, "frwrdBtn:" + title, 0, 0, w, w, UP);
            backwardButton = new ArrowButton(ktgui, "bckwrdBtn:" + title, 0, h - w, w, w, DOWN);
        }

        backwardButton.addEventAdapter(new KTGUIEventAdapter() {
            public void onMousePressed() {
                slider.decrementValue();
            }
        });
        forwardButton.addEventAdapter(new KTGUIEventAdapter() {
            public void onMousePressed() {
                slider.incrementValue();
            }
        });

        backwardButton.isDragable = false;
        forwardButton.isDragable = false;

        attachController(backwardButton);
        attachController(forwardButton);
    }

    private void createSlider(int sr, int er) {
        if (w > h) {
            slider = new Slider(ktgui, "hSlider:" + title, backwardButton.w, 0,
                    w - backwardButton.w - forwardButton.w, h, sr, er);
        } else {
            slider = new Slider(ktgui, "vSlider:" + title, 0, backwardButton.h,
                    w, h - backwardButton.h - forwardButton.h, sr, er);
        }
        slider.isDragable = false;
        slider.setValue(0);
        slider.setRounding(0);
        slider.setIsValueVisible(false);
        slider.addEventAdapter(new KTGUIEventAdapter() {
            public void onMouseDragged() {
                // !!! This line actually notifies the SCROLLBAR.mouseDragged 
                // !!! event listeners, not SLIDER.mouseDragged event listeners
                for (KTGUIEventAdapter adapter : adapters) {
                    adapter.onMouseDragged();
                }
            }
        });
        attachController(slider);
    }

    public float getValue() {
        return slider.getValue();
    }

    public void setValue(int val) {
        slider.setValue(val);
    }

    public float getHandlePos() {
        return slider.getHandlePos();
    }

    public void setHandlePos(int pos) {
        slider.setHandlePos(pos);
    }

    public void setHandleType(int handleType) {
        slider.setHandleType(handleType);
    }

    public void setHandleStep(float step) {
        slider.setHandleValue(step);
    }

    public float getHandleStep() {
        return slider.getValueStep();
    }

    public boolean getIsValueVisible() {
        return slider.getIsValueVisible();
    }

    public void setIsValueVisible(boolean visible) {
        slider.setIsValueVisible(visible);
    }

    public float getRangeStart() {
        return slider.getRangeStart();
    }

    public void setRangeStart(int rangeStart) {
        slider.setRangeStart(rangeStart);
    }

    public float getRangeEnd() {
        return slider.getRangeEnd();
    }

    public void setRangeEnd(int rangeEnd) {
        slider.setRangeEnd(rangeEnd);
    }

    public void setRounding(int n) {
        slider.setRounding(n);
    }
}

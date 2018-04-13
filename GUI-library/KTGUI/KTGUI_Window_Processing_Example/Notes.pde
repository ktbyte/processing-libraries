//
//  State                      - Represents an 'application' state. 
//  |                            This consists of one or more window objects and a variable context
//  |
//  |-Window                   - is a composite object
//    |
//    |-WindowCanvas           - is a PGraphics object that allows to clip (trim/cut) the 'extent' parts of those 
//    |                          window components that don't fit inside the window canvas
//    |
//    |--MenuBar               - is a horizontal list of clickable buttons 
//    |  |
//    |  |--Menu               - is a vertical list (a pop-up list) of clickable buttons 
//    |     |
//    |     |--MenuItem        - is a button        
//    |
//    |--TitleBar              - is a rectangular area that allows to change the position of the Window 
//    |  |
//    |  |--CloseButton
//    |  |
//    |  |--HideButton
//    |  |
//    |  |--ShowButton
//    |
//    |
//    |-WindowBorder           - is a rectangular shaped contour around the Window that allows to change the width 
//                             and height of the Window   
//   
//
//
//
// It would be very convenient to have the 'PopupMenu' class that shows the list of the items (Buttons)//
//
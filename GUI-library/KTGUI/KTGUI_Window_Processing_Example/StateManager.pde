/**********************************************************************************************************************
 *
 *********************************************************************************************************************/
class StateManager {
  List<State> states; // replace 'List' with 'Set' to prevent duplicates
  State activeState;

  //--------------------------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------------------------
  StateManager() {
    states = new ArrayList<State>();
  }

  //--------------------------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------------------------
  State createState(String name) {
    State state = new State(name);
    states.add(state);
    activeState = state;
    return state;
  }

  //--------------------------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------------------------
  void goToState(State state) {
    activeState = state;
  }

  //--------------------------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------------------------
  void goToState(int numState) {
    if (numState > 0 && numState < states.size()) {
      activeState = states.get(numState);
    }
    println("numState:" + numState);
    println("numState < states.size():" + (numState < states.size()));
    println("states.indexOf(activeState):" + states.indexOf(activeState));
    println();
  }

  //--------------------------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------------------------
  void goToNextState() {
    int indexOfCurrentState = states.indexOf(activeState);
    println("Before...");
    println("indexOfCurrentState:" + indexOfCurrentState);

    if (indexOfCurrentState < states.size() - 1) {
      activeState = states.get(indexOfCurrentState + 1);
    } else {
      activeState = states.get(0);
    }

    println("After...");
    indexOfCurrentState = states.indexOf(activeState);
    println("indexOfCurrentState:" + indexOfCurrentState);
    println();
  }

  //--------------------------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------------------------
  void printStates() {
    for (int i = 0; i < states.size(); i++) {
      println("[" + i + "] - " + states.get(i).name);
    }
  }

  //--------------------------------------------------------------------------------------------------
  //
  //--------------------------------------------------------------------------------------------------
  List<State> getStates() {
    return states;
  }
}

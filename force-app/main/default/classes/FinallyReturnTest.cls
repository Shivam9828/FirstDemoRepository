public class FinallyReturnTest {
    // Function returns from the finally block
    public String returnAString() {
      String returnVar;
      try {
        returnVar = null;
        returnVar.length(); // Will throw null pointer exception
      } catch(Exception ex) {
        // the exception will be caught
        System.debug('Exception caught is: '+ex);
        returnVar = 'I am set in the Catch block.';
        return returnVar;
      } finally {
        returnVar = 'I am set in the Finally block.';
        return returnVar;
      }
      returnVar = 'I am set in the main function';
      return returnVar; // Execution will never reach this statement
    }  
  }
public class demo1 {

   public boolean firstPanel{get;set;}
   public boolean secondPanel{get;set;}
   
    public demo1() {
     
     firstPanel = true;
     secondPanel = true;

    }


    public void firstButton()
    {
      firstPanel=false;
      secondPanel= true;
    
    }
    public void secondButton()
    {
      firstPanel=true;
      secondPanel=false;
    }

}
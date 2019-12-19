public class showAlertRandom {
    public boolean showAlert { get; set; }
    public Decimal numberValue { get; set; }
    public showAlertRandom() {
        doRandomAlert();
    }
    public void doRandomAlert() {
        numberValue = Math.random();
        showAlert = numberValue < 0.5;
    }
}
public class RandomNuberGeneration {

    
    public static string generateRandomNumber() {
        
        integer len = 8;
        final string chars = '0123456789';
        string randstr = '';
        while(randstr.length() < len){
            integer idx = Math.mod(Math.abs(crypto.getRandomInteger()), chars.length());
            randstr += chars.substring(idx,idx+1);
        }
        
            return randstr;
    }
}
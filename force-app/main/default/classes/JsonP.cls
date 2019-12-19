public class JsonP {

    public class Weather {
        public Integer id {get;set;}
        public String main {get;set;}
        public String description {get;set;}
        public String icon {get;set;}
    }

    public class Coord {
        public Double lon {get;set;}
        public Double lat {get;set;}
    }

    public class Wind {
        public Double speed {get;set;}
        public Double deg {get;set;}
    }

    public class Clouds {
        public Integer all {get;set;}
    }

    public class Data {
        public Coord coord {get;set;}
        public List<Weather> weather {get;set;}
        public String base {get;set;}
        public Main main {get;set;}
        public Wind wind {get;set;}
        public Clouds clouds {get;set;}
        public Integer dt {get;set;}
        public Sys sys {get;set;}
        public Integer id {get;set;}
        public String name {get;set;}
        public Integer cod {get;set;}
    }

    public class Sys {
        public Double message {get;set;}
        public String country {get;set;}
        public Integer sunrise {get;set;}
        public Integer sunset {get;set;}
    }

    public class Main {
        public Double temp {get;set;}
        public Double pressure {get;set;}
        public Integer humidity {get;set;}
        public Double temp_min {get;set;}
        public Double temp_max {get;set;}
        public Double sea_level {get;set;}
        public Double grnd_level {get;set;}
    }

    
    public static Data parse(String json) {
        return (Data) System.JSON.deserialize(json, Data.class);
    }
}
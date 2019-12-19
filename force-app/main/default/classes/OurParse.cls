public class OurParse {

    public class Data {
        public String status;
        public String message;
        public Integer totalPage;
        public Integer currentPage;
        public List<Zones> zones;
    }

    public class Zones {
        public String countryCode;
        public String countryName;
        public String regionName;
        public String cityName;
        public String zoneName;
        public String abbreviation;
        public Integer gmtOffset;
        public String dst;
        public Integer dstStart;
        public Integer timestamp;
        public String formatted;
    }

    
    public static Data parse(String json) {
        return (Data) System.JSON.deserialize(json, Data.class);
    }
}
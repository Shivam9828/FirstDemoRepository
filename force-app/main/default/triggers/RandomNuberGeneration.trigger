trigger RandomNuberGeneration on Account (before insert) {

    for (Account act : Trigger.new) {
        act.Test_Purpose__c=decimal.valueOf(RandomNuberGeneration.generateRandomNumber());
    }

}
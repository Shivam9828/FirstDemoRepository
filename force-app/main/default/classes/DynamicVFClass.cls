public with sharing class DynamicVFClass {
public DynamicVFClass(ApexPages.StandardController controller) {
}
public List<String> getFieldapis() {
map<String, Schema.SObjectType> m1 = Schema.getGlobalDescribe() ;
SObjectType objToken1 = m1.get('Opportunity');
DescribeSObjectResult objDef1= objToken1.getDescribe();
map<String, SObjectField> fieldmap = objDef1.fields.getmap();
List<String> lstobjectfields1= new List<String>();
List<String> fieldLabels1= new List<String>();
map<String,String> fieldLabelNamemap1= new map<String,String>();
for (String fName1:fieldmap.keySet())
{
if(fieldmap.get(fName1).getDescribe().getType()!=Schema.DisplayType.Time &&
fieldmap.get(fName1).getDescribe().getType()!=Schema.DisplayType.anytype&&
fieldmap.get(fName1).getDescribe().getType()!=Schema.DisplayType.base64 &&
fieldmap.get(fName1).getDescribe().getType()!=Schema.DisplayType.EncryptedString &&
fieldmap.get(fName1).getDescribe().getType()!=Schema.DisplayType.Id &&
fieldmap.get(fName1).getDescribe().getType()!=Schema.DisplayType.multiPicklist &&

fieldmap.get(fName1).getDescribe().getType()!=Schema.DisplayType.TextArea)
{
fieldLabels1.add(fieldmap.get(fName1).getDescribe().getLabel());
fieldLabelNamemap1.put(fieldmap.get(fName1).getDescribe().getLabel(), fName1);
}
}
for (String fLabel1:fieldLabels1){
if(flabel1 !='Created Date'&& flabel1!='Last Activity Date' && flabel1!='Last modified Date' && flabel1!='Deleted' && flabel1!='System modstamp'&& flabel1!='')
{
//lstobjectfields.add(new selectOption(fieldLabelNamemap.get(flabel),fLabel));
lstobjectfields1.add(fieldLabelNamemap1.get(flabel1));
}
}
system.debug('#### All Fields are ####'+lstobjectfields1);
return lstobjectfields1;
}
}
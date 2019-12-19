({
getAccountlst : function(component, event, helper) {
 
var action = component.get("c.getAccountlist");
 
action.setCallback(this, function(a) {
if (a.getState() === "SUCCESS") {
component.set("v.accountlist", a.getReturnValue());
} else if (a.getState() === "ERROR") {
$A.log("Errors", a.getError());
}
});
 
$A.enqueueAction(action);
}
})
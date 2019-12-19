({
    init : function(component, event, helper) {
        var fields=[];
        fields.push(component.get('v.myFieldText'));
        component.set('v.myField',fields);
    }
})
({
	doInit : function(component, event, helper) {
        var items = [];
        items.push({"label":"Dell", "value":"111"});
        items.push({"label":"Samsung", "value":"222"});
        items.push({"label":"HP", "value":"333"});
        items.push({"label":"Apple", "value":"444"});
        items.push({"label":"Lenovo", "value":"555"});
        items.push({"label":"Motorola", "value":"666"});
		items.push({"label":"Google", "value":"777"});
        items.push({"label":"Microsoft", "value":"888"});
        items.push({"label":"LG", "value":"999"});
        items.push({"label":"HTC", "value":"000"});
        component.set("v.itemOptions", items);
        component.set("v.selectedItemOptions", [{"label":"Apple", "value":"444"}, {"label":"Dell", "value":"111"}]);
	},
    evntCalled : function(component, event, helper) {
        /*console.log('====selectedItems===',event.getParam('selectedItems'));
        var selectedOptionValue = event.getParam('selectedItems');
        //component.set("v.selectedBrandOptions", selectedOptionValue);*/
    }
})
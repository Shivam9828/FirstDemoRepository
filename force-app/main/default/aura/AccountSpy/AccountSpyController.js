({
	handleMessage : function(component, event, helper) {
		const param = event.getParam('empData');
        document.querySelector('#output').innerHTML += 
            `<p class="slds-p-horizontal_medium">- Account "${param.sobject.Name}" with Id ${param.sobject.Id} is ${param.event.type}!!</p>`;
        console.log(`Account "${param.sobject.Name}" with Id ${param.sobject.Id} is ${param.event.type}!!`);
	}
})
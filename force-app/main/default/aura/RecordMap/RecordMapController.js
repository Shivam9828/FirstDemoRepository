({
    init: function (cmp, event, helper) {
        cmp.set('v.mapMarkers', [
            {
                location: {
                    Street: 'Vaishali Nagar',
                    City: 'Jaipur',
                    State: 'Rajasthan'
                },

                title: 'The Virtuowhiz House',
                description: 'Landmark, historic home & office of the United States president, with tours for visitors.'
            }
        ]);
        cmp.set('v.zoomLevel', 16);
    }
})
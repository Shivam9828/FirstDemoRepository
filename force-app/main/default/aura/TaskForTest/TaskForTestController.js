({
    handleClick : function(component, event, helper) {
        var arr = [ 2, 56, 78, 34, 65 ]; 
        
        // new mapped array 
        var new_arr = arr.map(function(num) {
            console.log(num);
            return num / 2; }); 
        
    }
})
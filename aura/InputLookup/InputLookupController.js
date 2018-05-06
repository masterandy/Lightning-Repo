({
    /*
    	Verify component has been loaded with the required params
    */
    setup : function(component, event, helper){
        
    },
    
    /*
    	When RequireJS is loaded, loads the typeahead component
    */
    initTypeahead : function(component, event, helper){
     	try{
			//first load the current value of the lookup field and then
			//creates the typeahead component
            helper.loadValue(component, true);
        }catch(ex){
            console.log(ex);
        }
    },
    /*
     * When the input field is manually changed, the corresponding value (id) is set to null
     */
    checkNullValue : function(component, event, helper){
        try{            
            $A.run(function(){
	            component.set('v.value', null);
            });
        }catch(ex){
            console.log(ex);
        }
	}
})
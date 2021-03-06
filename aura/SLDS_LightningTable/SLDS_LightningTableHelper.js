({
	fetchsObjectRecords : function(component,page) {
		var page = page || 1;
        var action = component.get("c.fetchRecords");
        var fields = component.get("v.fields");
        action.setParams({
            ObjectName : component.get("v.object"),
            fieldstoget : fields.join(),
            pageNumber : page,
            pageSize : component.get("v.pageSize")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                document.getElementById("data").innerHTML ='';
                component.set("v.latestRecords",response.getReturnValue());
                component.set("v.page",page);
                var retResponse = response.getReturnValue();
                component.set("v.total",retResponse.total);
                component.set("v.pages",Math.ceil(retResponse.total/component.get("v.pageSize")))
                var retRecords = retResponse.sObjectrecords;
                retRecords.forEach(function(s) {
                    var tableRow = document.createElement('tr');
                    fields.forEach(function(field){ 
                        var tableData = document.createElement('td');
                        var tableDataNode = document.createTextNode(s[field]);
                        tableData.appendChild(tableDataNode);
                        tableRow.appendChild(tableData);
                    });
                    document.getElementById("data").appendChild(tableRow);
                 });
             }else if (state === "ERROR") {
                console.log('Error');
            }
        });
        $A.enqueueAction(action);
	},
    completeStage : function(component, event, helper){
        console.log('---------------> completeStage 1 ');
        var action = component.get("c.uselessMethod");

        action.setCallback(this, function(response) {
            console.log('---------------> completeStage 2');
        });

        try{
            $A.enqueueAction(action);
        }
        catch(err3){
            console.log("---------------> completeStage EXCEPTION " + err3);
        }
    },
	
})
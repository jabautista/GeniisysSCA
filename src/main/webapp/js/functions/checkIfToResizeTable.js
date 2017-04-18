// check the no of rows inside the container
// if it exceeds 4, make the container scrollable
// parameters: 
// tableId: id of the container
// rowName: name of the row
function checkIfToResizeTable(tableId, rowName) {
    if ($$("div#"+tableId+" div[name='"+rowName+"']").size() >= 5) {
     	$(tableId).setStyle("height: 155px; overflow: auto; width: 100%;"); // rencela - previously width: 103%
    } else if ($$("div#"+tableId+" div[name='"+rowName+"']").size() == 0) {
     	$(tableId).setStyle("height: 31px;");
    } else {
    	var tableHeight = $$("div#"+tableId+" div[name='"+rowName+"']").size()*31; // mark jm 08.18.2010 modified by adding "div#"+tableId+" 
    	if(tableHeight == 0){
    		tableHeight = 31;
    	}    	
    	$(tableId).setStyle("height: " + tableHeight +"px; overflow: hidden;"); 
	}
}
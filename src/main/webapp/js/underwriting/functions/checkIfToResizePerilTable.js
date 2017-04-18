function checkIfToResizePerilTable(tableId, itemPerilDiv, rowName) {
	if ($$("div#"+itemPerilDiv+" div[name='"+rowName+"']").size() > 5) {
		$(itemPerilDiv).setStyle("height: 155px; overflow-y: auto; width: 100%; padding-right: 0px;"); 
     	$("itemPerilHeaderDiv").setStyle("padding-right: 15px;");
    } else if ($$("div#"+itemPerilDiv+" div[name='"+rowName+"']").size() == 0) {
    	$(itemPerilDiv).setStyle("height: 0px;");
     	$("itemPerilHeaderDiv").setStyle("padding-right: 0px;");
    } else {
    	var tableHeight = ($$("div#"+itemPerilDiv+" div[name='"+rowName+"']").size()*31+15);
    	$(itemPerilDiv).setStyle("height: " + tableHeight +"px; overflow: hidden;");
    	$("itemPerilHeaderDiv").setStyle("padding-right: 0px;");    	
	}
}
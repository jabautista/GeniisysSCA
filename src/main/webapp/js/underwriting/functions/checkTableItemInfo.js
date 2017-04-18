function checkTableItemInfo(tableName,tableRow,rowName){
	var exist = 0;
	$$("div#"+tableName+" div[name='"+rowName+"']").each(function (div) {
		div.removeClassName("selectedRow");
			exist = exist + 1;
	});
	if (exist > 5) {
		$(tableName).setStyle("height: 186px;");
		$(tableName).down("div",0).setStyle("padding-right: 20px;"); // mark jm 08.18.2010 changed margin-right to padding-right
     	$(tableRow).setStyle("height: 155px; overflow-y: auto;");     	
    } else if (exist == 0) {
     	$(tableRow).setStyle("height: 31px;");
     	$(tableName).down("div",0).setStyle("padding-right: 0px");
    } else {
    	var tableHeight = (exist*31)+31;
    	if(tableHeight == 0){
    		tableHeight = 31;
    	}
    	$(tableRow).setStyle("height: " + tableHeight +"px; overflow: hidden;"); 
    	$(tableName).setStyle("height: " + tableHeight +"px; overflow: hidden;");
    	$(tableName).down("div",0).setStyle("padding-right: 0px");
	}
	
	if (exist == 0){		
		Effect.Fade(tableName, {
			duration: .001
		});
	} else {
		Effect.Appear(tableName, {
			duration: .001
		});
	}
}
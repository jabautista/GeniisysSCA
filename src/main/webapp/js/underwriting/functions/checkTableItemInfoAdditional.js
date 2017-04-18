function checkTableItemInfoAdditional(tableName,tableRow,rowName,attr,pkValue,attr2,pkValue2,attr3,pkValue3){
	var exist = 0;
	$$("div#"+tableName+" div[name='"+rowName+"']").each(function (div) {
		div.removeClassName("selectedRow");
		if (div.getAttribute(attr) == pkValue && div.getAttribute(attr2) == pkValue2 && div.getAttribute(attr3) == pkValue3){
			exist = exist + 1;
			div.show();
		}else{
			div.hide();
		}
	});
	if (exist > 5) {
		$(tableName).setStyle("height: 186px;");
		$(tableName).down("div",0).setStyle("padding-right:17px");
     	$(tableRow).setStyle("height: 155px; overflow-y: auto;");
    } else if (exist == 0) {
     	$(tableRow).setStyle("height: 31px;");
     	$(tableName).down("div",0).setStyle("padding-right:0px");
    } else {
    	var tableHeight = (exist*31)+31;
    	if(tableHeight == 0){
    		tableHeight = 31;
    	}

    	$(tableRow).setStyle("height: " + tableHeight +"px; overflow: hidden;");
    	$(tableName).setStyle("height: " + tableHeight +"px; overflow: hidden;");
    	$(tableName).down("div",0).setStyle("padding-right:0px");
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
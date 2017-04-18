function checkPopupsTableWithTotalAmountbyObject(objArray, tableName, tableRow, rowName, amountName, totalAmtDiv, amountId){
	try{
		var holder = 0;
		var exist = 0;
		var objPre = new Object();
		var objSca = new Object();
		var totalAmount = "";
		var filteredArray = objArray.filter(getExistingRecords);
		
		for(var i=0, length=filteredArray.length; i < length; i++){
			var amount;
			var amt = nvl(filteredArray[i][amountName], "0");
			
			if((amt).indexOf(".") < 0){
				holder = (amt).replace(/,/g, "") + ".00";
			}else{			
				holder = (amt).replace(/,/g, "");
			}
			
			amount = holder.split(".");
			
			objPre[i] = parseInt(amount[0]);
			objSca[i] = parseInt(((parseInt(amount[0]) < 0) ? "-" : "") + amount[1]);
			exist += 1;
		}	
		
		totalAmount = addSeparatorToNumber(addObjectNumbers(objPre, objSca), ",");
		
		if (exist > 5) {
			$(tableName).setStyle("height: 217px;");
			$(tableName).down("div",0).setStyle("padding-right: 20px;");
	     	$(tableRow).setStyle("height: 155px; overflow-y: auto;");
	     	$(totalAmtDiv).setStyle("display: block; padding-right: 20px;");
	     	$(amountId).update(totalAmount);
	    } else if (exist == 0) {
	     	$(tableRow).setStyle("height: 31px;");
	     	$(tableName).down("div",0).setStyle("padding-right: 0px");
	     	$(totalAmtDiv).setStyle("display: none; padding-right: 0px;");
	     	$(amountId).update(totalAmount);
	    } else {
	    	var tableHeight = ((exist + 1) * 31) + 31;
	    	var tableRowHeight = (exist * 31);
	    	
	    	if(tableHeight == 0) {
	    		tableHeight = 31;
	    	}
	    	
	    	$(tableRow).setStyle("height: " + tableRowHeight +"px; overflow: hidden;");
	    	$(tableName).setStyle("height: " + tableHeight +"px; overflow: hidden;");
	    	$(tableName).down("div",0).setStyle("padding-right: 0px");
	    	$(totalAmtDiv).setStyle("display: block; padding-right: 0px;");
	    	$(amountId).update(totalAmount);
	    	$(amountId).setAttribute("title", $(amountId).innerHTML);
		}
		
		if (exist == 0) {
			Effect.Fade(tableName, {
				duration: .001
			});
		} else {
			Effect.Appear(tableName, {
				duration: .001
			});
		}
	}catch(e){
		showErrorMessage("checkPopupsTableWithTotalAmountbyObject", e);
		//showMessageBox("checkPopupsTableWithTotalAmountByObject : " + e.message);
	}		
}
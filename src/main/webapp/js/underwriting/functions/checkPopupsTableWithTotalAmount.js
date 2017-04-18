/*	Created by	: mark jm 10.08.2010
 * 	Description	: adjust table layout including total amount div in subpages/popups
 * 	Parameter	: tableName - name of the div where the table is located
 * 				: tableRow - name of the div that holds the record list
 * 				: rowName - name of the div that acts as row
 * 				: amountName - name of the label of amount
 * 				: amtIndex - index where the amount label is located
 */
function checkPopupsTableWithTotalAmount(tableName, tableRow, rowName, totalAmtDiv, amountName, amountIndex){
	var exist = 0;
	var objPrecision = new Object();
	var objScale = new Object();
	var totalAmount = "";
	
	$$("div#" + tableName + " div[name='" + rowName + "']").each(
		function(row){
			var amount;
			
			if(row.style.display != 'none'){
				exist = exist + 1;
				//totalAmount += new Number((row.down("label", amountIndex).innerHTML).replace(/,/g , ""));
				amount = ((row.down("label", amountIndex)).innerHTML).replace(/,/g, "").split(".");
				objPrecision[exist] = parseInt(nvl(amount[0], "0"));
				objScale[exist] = parseInt(nvl(((parseInt(amount[0]) < 0) ? "-" : "") + amount[1], "0"));				
			}
		}
	);
	
	totalAmount = addSeparatorToNumber(addObjectNumbers(objPrecision, objScale), ",");
	
	if (exist > 5) {
		$(tableName).setStyle("height: 217px;");
		$(tableName).down("div",0).setStyle("padding-right: 20px;");
     	$(tableRow).setStyle("height: 155px; overflow-y: auto;");
     	//$(totalAmtDiv).setStyle("padding-right: 20px;");
     	$(amountName).update(totalAmount);
    } else if (exist == 0) {
     	$(tableRow).setStyle("height: 31px;");
     	$(tableName).down("div",0).setStyle("padding-right: 0px");
     	//$(totalAmtDiv).setStyle("padding-right: 0px;");
     	$(amountName).update(totalAmount);
    } else {
    	var tableHeight = ((exist + 1) * 31) + 31;
    	var tableRowHeight = (exist * 31);
    	
    	if(tableHeight == 0) {
    		tableHeight = 31;
    	}
    	
    	$(tableRow).setStyle("height: " + tableRowHeight +"px; overflow: hidden;");
    	$(tableName).setStyle("height: " + tableHeight +"px; overflow: hidden;");
    	$(tableName).down("div",0).setStyle("padding-right: 0px");
    	//$(totalAmtDiv).setStyle("padding-right: 0px;");
    	$(amountName).update(totalAmount);
    	$(amountName).setAttribute("title", $(amountName).innerHTML);
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
	
}
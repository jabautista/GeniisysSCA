/*
 * Created by	: andrew robes
 * Date			: November 2, 2010
 * Description 	: Computes the total amount in table using the label innerHTML
 * Parameters	: tableId - id to table containing the records
 * 				  rowName - name of row
 * 				  labelIndex - index of label in the record
 * 				  attr - attribute in record to be compared against the pkValue
 * 				  pkValue - value which will be used in condition to limit the total
 * 				  totalDiv - div containing the total label
 */
function computeTotalAmountInTable2(tableId, rowName, labelIndex, attr, pkValue, totalDiv){
	try {
		var total = "0.00";
		var ctr = 0;
		$$("div#"+tableId+" div[name='"+rowName+"']").each(function(row){
			if (row.getAttribute(attr) == pkValue){
				ctr++;
				var val = (row.down("label",labelIndex).innerHTML.replace(/,/g, "") == "" ? "0.00" : row.down("label",labelIndex).innerHTML.replace(/,/g, ""));
				if (parseInt(ctr) == 1){
					total = val;
				}else{
					var wholeNumTotal = parseInt(total.substr(0,total.indexOf("."))) + parseInt(val.substr(0,val.indexOf(".")));
					var decNumTotal = parseFloat("0"+total.substr(total.indexOf(".")).toString()) + parseFloat("0"+val.substr(val.indexOf(".")).toString());
					decNumTotal = decNumTotal == 0 ? "0.00" :decNumTotal;
					var decimal = decNumTotal.toString().substr(decNumTotal.toString().indexOf(".").toString()).toString();
					wholeNumTotal = wholeNumTotal + parseInt(decNumTotal.toString().substr(0,decNumTotal.toString().indexOf(".").toString()).toString());
					total = wholeNumTotal + decimal.toString();
				}
			}	
		});	
	
		$(totalDiv).down("label",1).update(formatCurrency(total));
	} catch (e){
		showErrorMessage("computeTotalAmountInTable2", e);
	}
}
//jerome to compute total amount on table
function computeTotalAmountInTable(tableId,rowName,divRowNum,attr,pkValue,totalDiv){
	var total = "0.00";
	var ctr = 0;
	$$("div#"+tableId+" div[name='"+rowName+"']").each(function(row){
		if (row.getAttribute(attr) == pkValue){
			ctr++;
			var val = (row.down("input",divRowNum).value.replace(/,/g, "") == "" ? "0.00" :row.down("input",divRowNum).value.replace(/,/g, ""));
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
			//total = parseFloat(total) + parseFloat((row.down("input",divRowNum).value.replace(/,/g, "") == "" ? 0 :row.down("input",divRowNum).value.replace(/,/g, "")));
		}	
	});
	if (parseInt(ctr) <= 5){
		$(totalDiv).down("label",1).setStyle("padding-right:0px");
	}else{
		$(totalDiv).down("label",1).setStyle("padding-right:17px");
	}	
	if (parseInt(ctr) > 0){
		$(totalDiv).show();
	}else{
		$(totalDiv).hide();
	}
	$(totalDiv).down("label",1).update(formatCurrency(total).truncate(50, "..."));
}
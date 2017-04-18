function makeGIPIQuoteMortgageeRow(mortgageeObj){
	var row = new Element("div");
	row.setAttribute("id", "mortgageeRow" + mortgageeObj.itemNo);
	row.setAttribute("id", "mortgageeRow" + mortgageeObj.itemNo + mortgageeObj.mortgCd);
	row.setAttribute("name", "mortgageeRow");
	row.setAttribute("mortgCd", mortgageeObj.mortgCd);
	row.setAttribute("itemNo", mortgageeObj.itemNo);
	row.addClassName("tableRow");
	row.update(
		'<label style="width: 50%; padding-left: 20px;">'+mortgageeObj.mortgName+'</label>'+
		'<label style="width: 20%; text-align: right;" class="money" name="lblMoney">' + formatCurrency(mortgageeObj.amount) + '</label>'+
		'<label style="width: 20%; text-align: center;">'+mortgageeObj.itemNo+'</label>');
	
	loadRowMouseOverMouseOutObserver(row);
	
	row.observe("click", function(){
		row.toggleClassName("selectedRow");
		if(row.hasClassName("selectedRow")){
			($$("div#mortgageeInformationDiv div:not([id=" + row.id + "])")).invoke("removeClassName", "selectedRow");
			// (LIST).invoke("actionName","actionNameParameter");
			$("selMortgagee").disable();
			clearChangeAttribute("mortgageeInformationSectionDiv");
			var selMortgageeOpts = $("selMortgagee").options;
			for(var i=0; i<selMortgageeOpts.length; i++){
				var mortOpt = selMortgageeOpts[i];
				if(mortOpt.getAttribute("mortgCd") == mortgageeObj.mortgCd){
					$("selMortgagee").selectedIndex = i;
				}
			}
			
			$("txtMortgageeAmount").value = formatCurrency(mortgageeObj.amount);
			$("txtMortgageeItemNo").value = mortgageeObj.itemNo;
			
			$("selMortgagee").options[$("selMortgagee").selectedIndex].innerHTML = unescapeHTML2(mortgageeObj.mortgName);
			$("selMortgagee").options[$("selMortgagee").selectedIndex].value = mortgageeObj.mortgCd;
			$("selMortgagee").options[$("selMortgagee").selectedIndex].setAttribute("mortgCd", mortgageeObj.mortgCd);
			
			$("btnAddMortgagee").value = "Update";
			enableButton("btnDeleteMortgagee");
			
		}else{
			clearChangeAttribute("mortgageeInformationSectionDiv");
			$("selMortgagee").enable();
			$("btnAddMortgagee").value = "Add";
			disableButton("btnDeleteMortgagee");
			clearMortgageeForm();
		}
	});
	
	return row;
}
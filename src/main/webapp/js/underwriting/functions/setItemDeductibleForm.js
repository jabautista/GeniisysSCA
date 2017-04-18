function setItemDeductibleForm(obj, dedLevel){
	try{
		var itemNo = (1 < dedLevel ? $F("itemNo") : 0);
		if(dedLevel == 1){
			$("ceilingSw" + dedLevel).checked = obj != null ? (obj.ceilingSw == "Y" ? true : false) : false;
		}
		
		/*
		if(obj == null){
			$("inputDeductible" + dedLevel).selectedIndex = 0;
		}else{
			var deducts = $("inputDeductible" + dedLevel);
			for(var k=0, length=deducts.length; k < deducts; k++){
				if(deducts.options[k].value == obj.dedDeductibleCd){
					deducts.selectedIndex = k;				
				}
			}
		}
		*/
		$("txtDeductibleCd"+dedLevel).value			= (obj == null ? "" : obj.dedDeductibleCd);
		$("txtDeductibleDesc" + dedLevel).value		= (obj == null ? "" : unescapeHTML2(obj.deductibleTitle));
		$("inputDeductibleAmount" + dedLevel).value = (obj == null ? "" : formatCurrency(obj.deductibleAmount));
		$("deductibleRate" + dedLevel).value		= (obj == null ? "" : obj.deductibleRate == null ? "" : formatToNineDecimal(obj.deductibleRate));
		$("deductibleText" + dedLevel).value		= (obj == null ? "" : unescapeHTML2(obj.deductibleText));
		
		$("aggregateSw" + dedLevel).checked			= (obj == null ? false : nvl(obj.aggregateSw, "N") == "Y" ? true : false);		
		$("btnAddDeductible" + dedLevel).value		= (obj == null ? "Add" : "Update");
		//$("inputDeductDisplay"+dedLevel).value 		= (obj == null ? "" : obj.deductibleTitle);
		
		//$("inputDeductDisplay"+dedLevel).setAttribute("deductibleCd", (obj != null ? obj.deductibleCd : ""));
		
		if(obj == null){
			$("hrefDeductible" + dedLevel).show();
			disableButton("btnDeleteDeductible" + dedLevel);
		}else{
			$("hrefDeductible" + dedLevel).hide();
			enableButton("btnDeleteDeductible" + dedLevel);
		}
		
		//(obj == null ? $("inputDeductible" + dedLevel).enable() : $("inputDeductible" + dedLevel).disable());
		
		$("inputDeductibleAmount" + dedLevel).readonly 	= (obj == null ? false : true);
		$("deductibleRate" + dedLevel).readonly			= (obj == null ? false : true);
		$("deductibleText" + dedLevel).readonly			= (obj == null ? false : true);
		
		/*switch(dedLevel){
			//case "1" : hideToolbarButtonInTG(tbgPolicyDeductible); break;
			case "2" : hideToolbarButtonInTG(tbgItemDeductible); break;
			case "3" : hideToolbarButtonInTG(tbgPerilDeductible); break;
		}*/
		
		($$("div#deductibleDiv" + dedLevel + " [changed=changed]")).invoke("removeAttribute", "changed");
	}catch(e){
		showErrorMessage("setItemDeductibleForm", e);		
	}
}
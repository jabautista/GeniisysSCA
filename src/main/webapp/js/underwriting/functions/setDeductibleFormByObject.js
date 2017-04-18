/*	Created by	: mark jm 10.21.2010
 * 	Description	: another version of setDeductibleForm in underwriting.js
 * 				: this time, using an object instead of a row
 * 	Parameters	: obj - object that holds data
 * 				: dedLevel - deductible level
 */
function setDeductibleFormByObject(obj, dedLevel){
	try{
		var itemNo = (1 < dedLevel ? $F("itemNo") : 0);
		if(dedLevel == 1){
			$("ceilingSw" + dedLevel).checked = obj != null ? (obj.ceilingSw == "Y" ? true : false) : false;
		}
		
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
		
		$("inputDeductibleAmount" + dedLevel).value = (obj == null ? "" : formatCurrency(obj.deductibleAmount));
		$("deductibleRate" + dedLevel).value		= (obj == null ? "" : obj.deductibleRate == null ? "" : formatToNineDecimal(obj.deductibleRate));
		$("deductibleText" + dedLevel).value		= (obj == null ? "" : obj.deductibleText);
		$("aggregateSw" + dedLevel).checked			= (obj == null ? false : nvl(obj.aggregateSw, "Y") == "Y" ? true : false);		
		$("btnAddDeductible" + dedLevel).value		= (obj == null ? "Add" : "Update");
		$("inputDeductDisplay"+dedLevel).value 		= (obj == null ? "" : obj.deductibleTitle);
		
		$("inputDeductDisplay"+dedLevel).setAttribute("deductibleCd", (obj != null ? obj.deductibleCd : ""));
		
		(obj == null ? disableButton("btnDeleteDeductible" + dedLevel) : enableButton("btnDeleteDeductible" + dedLevel));
		(obj == null ? $("inputDeductible" + dedLevel).enable() : $("inputDeductible" + dedLevel).disable());
		
		$("inputDeductibleAmount" + dedLevel).readonly 	= (obj == null ? false : true);
		$("deductibleRate" + dedLevel).readonly			= (obj == null ? false : true);
		$("deductibleText" + dedLevel).readonly			= (obj == null ? false : true);
		
	}catch(e){
		showErrorMessage("setDeductibleFormByObject", e);
		//showMessageBox("setDeductibleFormByObject : " + e.message);
	}
}
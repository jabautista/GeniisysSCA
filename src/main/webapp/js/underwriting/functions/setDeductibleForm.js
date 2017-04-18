/*	Move by			: mark jm 09.16.2010
 * 	From			: /underwriting/subPages/deductible.jsp
 *  Modification	: Added dedLevel as parameter
 */
function setDeductibleForm(row, dedLevel)	{
	try {		
		//var itemNo = (1 < dedLevel ? $F("itemNo") : 0);
		if(1 == dedLevel){
			$("ceilingSw"+dedLevel).checked = (row == null ? false : row.down("input", 9).value == "Y" ? true : false);
		}
						
		/*
		if(3 == dedLevel) {
			if(row == null){
				$$("select[name='inputPeril']").each(function(inputPeril){
					inputPeril.enable();
				});
			} else {
				togglePerils();
					
				var peril = $("inputPeril"+itemNo);					
				for (var k=0; k < peril.length; k++)	{
					if (peril.options[k].value == row.down("input", 2).value)	{
						peril.selectedIndex = k;
					}
				}
				$("inputPeril"+itemNo).disable();
			}
		}
		 */
		
		/*if(row == null){
			$("inputDeductible"+dedLevel).selectedIndex = 0;
		} else {
			var deducts = $("inputDeductible"+dedLevel);
			for (var k=0; k<deducts.length; k++) {
				if (deducts.options[k].value == row.down("input", 4).value)	{
					deducts.selectedIndex = k;
				}
			}
		}*/
		$("txtDeductibleDesc"+dedLevel).value = (row == null ? "" : row.down("input", 3).value);
		$("txtDeductibleCd"+dedLevel).value = (row == null ? "" : row.down("input", 4).value);
		//$("inputDeductDisplay"+dedLevel).value = (row == null ? "" : row.down("input", 3).value);
		$("inputDeductibleAmount"+dedLevel).value = (row == null ? "" : formatCurrency(row.down("input", 5).value));
		$("deductibleRate"+dedLevel).value 		 = (row == null ? "" : (row.down("input", 6).value == "" ? "" : formatToNineDecimal(row.down("input", 6).value)));
		$("deductibleText"+dedLevel).value 		 = (row == null ? "" : row.down("input", 7).value.replace(/\\n/g, "\n"));		
		$("aggregateSw"+dedLevel).checked 		 = (row == null ? false : row.down("input", 8).value == "Y" ? true : false);
		$("btnAddDeductible"+dedLevel).value 	 = (row == null ? "Add" : "Update");
		
		(row == null ? disableButton("btnDeleteDeductible"+dedLevel) : enableButton("btnDeleteDeductible"+dedLevel));
		(row == null ? $("hrefDeductible"+dedLevel).show() : $("hrefDeductible"+dedLevel).hide()); 
		//(row == null ? $("inputDeductible"+dedLevel).enable() : $("inputDeductible"+dedLevel).disable());
		
		$("inputDeductibleAmount"+dedLevel).readonly = (row == null ? false : true);
		$("deductibleRate"+dedLevel).readonly = (row == null ? false : true);
		$("deductibleText"+dedLevel).readonly = (row == null ? false : true);
		if(row == null) {($$("div#dedMainContainerDiv" + dedLevel + " [changed=changed]")).invoke("removeAttribute", "changed");}
	} catch(e){
		showErrorMessage("setDeductibleForm", e);
		//showMessageBox("setDeductibleForm: " + e.message);
	}
}
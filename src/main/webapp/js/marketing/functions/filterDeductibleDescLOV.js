function filterDeductibleDescLOV(){
	var selectedItemNo = getSelectedRowId("itemRow");
	var selectedPeril =$("selDeductibleQuotePerils").options[$("selDeductibleQuotePerils").selectedIndex].value;
	
	$("selDeductibleDesc").childElements().each(function(o){
		o.show(); o.disabled = false;
	});
	
	$$("div[name= 'deductibleRow']").each(function(row){
		if(row.getAttribute("itemNo") == selectedItemNo && row.getAttribute("perilCd") == selectedPeril){ 
			for(var i=0; i<$("selDeductibleDesc").options.length; i++){
				if(row.getAttribute("deductibleCd") == $("selDeductibleDesc").options[i].value){
					$("selDeductibleDesc").options[i].hide();
					$("selDeductibleDesc").options[i].disabled = true;
					break;
				}
			}
		}
	});
}
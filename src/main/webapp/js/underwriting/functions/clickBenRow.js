function clickBenRow(objBen, newDiv) {
	try{		
		newDiv.observe("click", function() {
			var click = false;
			newDiv.toggleClassName("selectedRow");
			if(newDiv.hasClassName("selectedRow")) {
				$$("div[name='rowBen']").each(function(br) {
					if(newDiv.getAttribute("id") != br.getAttribute("id")) {
						br.removeClassName("selectedRow");
					}
				});
				//setBenForm(objBen);
				var objArr = objBeneficiaries.filter(function(obj){	
					return nvl(obj.recordStatus,0) != -1 && obj.itemNo == newDiv.getAttribute("item") && 
						obj.beneficiaryNo == newDiv.getAttribute("benNo");	});
				for(var i=0, length=objArr.length; i < length; i++){
					setBenForm(objArr[i]);
					break;
				}
			} else {
				setBenForm(null);
			}
		});		
	}catch(e){
		showErrorMessage("clickBenRow", e);
	}	
}
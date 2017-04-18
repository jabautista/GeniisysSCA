/**
 * HIDE OPTIONS THAT HAVE ALREADY BEEN SELECTED
 * #setLov
 */
function setQuoteDeductibleDescLov(){
	var deductibleLov = $("selDeductibleDesc");
	deductibleLov.update("<option></option>");
	var ded = null;
	
	for(var i=0; i<objGIISDeductibleDescLov.length; i++){
		ded = objGIISDeductibleDescLov[i];
		if(!isDeductibleAlreadyAdded(ded.dedDeductibleCd)){
			var dedOption = new Element("option");
			dedOption.innerHTML = ded.deductibleTitle;
			dedOption.setAttribute("value",ded.deductibleCd);
			dedOption.setAttribute("deductibleText", ded.deductibleText);
			dedOption.setAttribute("deductibleCd",ded.deductibleCd);
			dedOption.setAttribute("deductibleAmt",ded.deductibleAmt);
			dedOption.setAttribute("deductibleRate",ded.deductibleRate);
			dedOption.setAttribute("deductibleType",ded.deductibleType);
			dedOption.setAttribute("minimumAmount",ded.minimumAmount);
			dedOption.setAttribute("maximumAmount",ded.maximumAmount);
			dedOption.setAttribute("rangeSw",ded.rangeSw);
			try{
				deductibleLov.add(dedOption,null);
			}catch(e){
				deductibleLov.add(dedOption);
			};
		}
	}
}
/**
 * #mortgagee #setLov
 * @return
 */
function setMortgageeNameLov(){
	var selMortgagee = $("selMortgagee");
	selMortgagee.update("<option></option>");
	var mortgageeLov = null;
	var selectedItemNo = getSelectedRowId("itemRow");
	for(var i=0; i<objMortgageeLov.length; i++){
		mortgageeLov = objMortgageeLov[i];
		if(!isMortgageeAlreadyAdded(mortgageeLov)){
			var mortgageeOption = new Element("option");
			mortgageeOption.innerHTML = mortgageeLov.mortgName;
			mortgageeOption.setAttribute("value",mortgageeLov.mortgCd);
			mortgageeOption.setAttribute("mortgCd",mortgageeLov.mortgCd);
			mortgageeOption.setAttribute("mortgName",mortgageeLov.mortgName);
			try{
				selMortgagee.add(mortgageeOption,null);
			}catch(e){
				selMortgagee.add(mortgageeOption);
			};
		}
	}
}
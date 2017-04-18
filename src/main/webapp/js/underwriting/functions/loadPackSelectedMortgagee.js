/**
 * Determines if records exist in package mortgagee listing and loads it to screen
 * @author Veronica V. Raymundo
 * 
 */
function loadPackSelectedMortgagee(row){
	try{
		if(row.hasClassName("selectedRow")){
			var objFilteredArr = objMortgagees.filter(function(obj){
							  return nvl(obj.recordStatus,0) != -1 && 
							  obj.itemNo == row.getAttribute("item") && 
							  obj.mortgCd == row.getAttribute("mortgCd") &&
							  obj.parId == row.getAttribute("parId");});
			for(var i=0, length=objFilteredArr.length; i<length; i++){
				setMortgageeForm(objFilteredArr[i]);				
				break;
			}
		}else{
			setMortgageeForm(null);
		}
	}catch(e){
		showErrorMessage("loadPackSelectedMortgagee", e);
	}	
}
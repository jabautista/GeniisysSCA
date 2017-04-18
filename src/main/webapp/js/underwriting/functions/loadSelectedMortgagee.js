/*	Created by	: mark jm 12.21.2010
 * 	Description	: determines if records exist in mortgagee listing and loads it to screen
 * 	Parameter	: row - div that holds the record
 */
function loadSelectedMortgagee(row){
	try{
		if(row.hasClassName("selectedRow")){
			var objFilteredArr = objMortgagees.filter(function(obj){	return nvl(obj.recordStatus,0) != -1 && obj.itemNo == row.getAttribute("item") && obj.mortgCd == row.getAttribute("mortgCd");	});
			for(var i=0, length=objFilteredArr.length; i<length; i++){
				setMortgageeForm(objFilteredArr[i]);				
				break;
			}
		}else{
			setMortgageeForm(null);
		}
	}catch(e){
		showErrorMessage("loadSelectedMortgagee", e);
	}	
}
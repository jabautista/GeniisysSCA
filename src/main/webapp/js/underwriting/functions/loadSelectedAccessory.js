/*	Created by	: mark jm 12.21.2010
 * 	Description	: determines if records exist in accessory listing and loads it to screen
 * 	Parameter	: row - div that holds the record
 */
function loadSelectedAccessory(row){
	try{
		if(row.hasClassName("selectedRow")){
			var objFilteredArr = objGIPIWMcAcc.filter(function(obj){	return nvl(obj.recordStatus, 0) != -1 && obj.itemNo == row.getAttribute("item") && obj.accessoryCd == row.getAttribute("accCd");	});
			for(var i=0, length=objFilteredArr.length; i<length; i++){
				setAccessoryForm(objFilteredArr[i]);				
				break;
			}
		}else{
			setAccessoryForm(null);
		}
	}catch(e){
		showErrorMessage("loadSelectedAccessory", e);
	}	
}
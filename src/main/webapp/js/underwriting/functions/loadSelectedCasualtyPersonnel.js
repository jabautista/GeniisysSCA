/*	Created by	: mark jm 10.19.2010
 * 	Description	: determines if records exist in casualty personnel listing and loads it to screen
 * 	Parameter	: rowName - name of row used in table record listing
 * 				: row - div that holds the record
 * 				: id - row id
 */
function loadSelectedCasualtyPersonnel(rowName, row){
	/*
	for(var i=0, length=objEndtCAPersonnels.length; i < length; i++){
		//var personnelNo = id.substr(id.indexOf("_") + 1, id.length - id.indexOf("_"));					
		if(objEndtCAPersonnels[i].itemNo == row.getAttribute("itemNo") && 
				objEndtCAPersonnels[i].personnelNo == row.getAttribute("personnelNo")){
			setValues(rowName, objEndtCAPersonnels[i]);
		}
	}
	*/
	try{
		if(row.hasClassName("selectedRow")){
			var objArr = objGIPIWCasualtyPersonnel.filter(function(obj){	return nvl(obj.recordStatus,0) != -1 && obj.itemNo == row.getAttribute("item") && obj.personnelNo == row.getAttribute("personnelNo");	});
			for(var i=0, length=objArr.length; i < length; i++){
				setCasualtyPersonnelForm(objArr[i]);
				break;
			}
		}else{
			setCasualtyPersonnelForm(null);
		}
	}catch(e){
		showErrorMessage("loadCasualtyPersonnel", e);
	}
}
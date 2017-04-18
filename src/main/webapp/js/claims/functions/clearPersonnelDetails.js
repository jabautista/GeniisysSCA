/**
 * @author rey
 * @date 03-22-2012
 */
function clearPersonnelDetails(){
	try{
		$("txtPerNo").value = "";
		$("txtPersonnel").value = "";
		$("txtCaPosition").value = "";
		$("txtCoverage").value = "";
	}catch(e){
		showErrorMessage("clearPersonnelDetails",e);
	}
}
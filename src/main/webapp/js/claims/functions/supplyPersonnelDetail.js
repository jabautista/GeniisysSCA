/**
 * @author rey
 * @date 10-18-2011
 * @param obj
 */
function supplyPersonnelDetail(obj){
	try{
		$("txtPersonnel").value  		= obj == null ? null : unescapeHTML2(nvl(obj[personnelGrid.getColumnIndex('name')],""));
		$("txtCaPosition").value		= obj == null ? null : obj[personnelGrid.getColumnIndex('capacityCd')] == null ? "" : obj[personnelGrid.getColumnIndex('capacityCd')] + " - "+ unescapeHTML2(nvl(obj[personnelGrid.getColumnIndex('position')],""));
		$("txtCoverage").value			= obj == null ? null : formatCurrency(nvl(obj[personnelGrid.getColumnIndex('amountCovered')],""));
		$("rdoPersonnel").checked       = obj == null ? false : true;
		$("txtPerNo").value				= obj == null ? null : nvl(obj[personnelGrid.getColumnIndex('personnelNo')],"");
		}
	catch(e){
		showErrorMessage("supplyPersonnelDetail",e);
	}
}
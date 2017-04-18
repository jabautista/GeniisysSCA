/**
 * Moved to reuse
 * Clear status for distribution modules
 * @author niknok orio
 * @since 08.10.2011
 */
function clearDistStatus(objGIUWPolDist){
	try{
		var objArray = objGIUWPolDist;
		for(var a=0; a<objArray.length; a++){
			if (nvl(objArray[a].giuwWPerilds,null) != null){
				//Group
				for(var b=0; b<objArray[a].giuwWPerilds.length; b++){
					//Share
					clearObjectRecordStatus(objArray[a].giuwWPerilds[b].giuwWPerildsDtl);
				}
				clearObjectRecordStatus(objArray[a].giuwWPerilds);
			}
			
			if (nvl(objArray[a].giuwWpolicyds,null) != null){
				//Group
				for(var b=0; b<objArray[a].giuwWpolicyds.length; b++){
					//Share
					clearObjectRecordStatus(objArray[a].giuwWpolicyds[b].giuwWpolicydsDtl);
				}
				clearObjectRecordStatus(objArray[a].giuwWpolicyds);	
			}
		}
		nvl(objArray,null) != null ? clearObjectRecordStatus(objArray) :null;	
	}catch (e) {
		showErrorMessage("clearDistStatus", e);
	}
}
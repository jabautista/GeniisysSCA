/* Created by	: d alcantara
 * Description	: retrieves added and deleted principals as json objects	
 */
function getENItemJSON(pType) {
	var tempArray = new Array();
	try {
			if (pType == "P") {
				if(addedENPrincipals==null) {
					tempArray = ('[{"principalCd" : null, "principalName" : ""}]');
				} else {
					for(var i=0; i<addedENPrincipals.length; i++) {
						tempArray[i] = addedENPrincipals[i];
					}
				}
			} else {
				if(delENPrincipals==null) {
					tempArray = ('[{"principalCd" : null, "principalName" : ""}]');
				} else {
					for(var i=0; i<delENPrincipals.length; i++) {
						tempArray[i] = delENPrincipals[i];
					}
				}
			}
			return tempArray;
	} catch(e) {
		showErrorMessage("getENItemJSON", e);
		//showMessageBox("getENItemJSON: " + e.message);
	}
}
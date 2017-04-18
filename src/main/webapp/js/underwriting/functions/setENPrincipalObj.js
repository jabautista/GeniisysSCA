/* Created by	: d alcantara
 * Description	: sets the objects for the added and deleted principals
 * 				  used in additional engineering info		
 */
function setENPrincipalObj(obj, act) {
	// act = 0 -> delete; 1 -> add
	if(addedENPrincipals == null) {
		addedENPrincipals = new Array();
	} 
	if (delENPrincipals == null) {
		delENPrincipals = new Array();
	}
	try {
		if(act == 1) {
			for(var i=0; i<addedENPrincipals.length; i++) {
				if(addedENPrincipals[i].principalCd == obj.principalCd) {
					addedENPrincipals.splice(i,1);
				}
			}
			addedENPrincipals.push(obj);
		} else {
			for(var i=0; i<delENPrincipals.length; i++) {
				if(delENPrincipals[i].principalCd == obj.principalCd) {
					delENPrincipals.splice(i,1);
				}
			}
			for(var i=0; i<addedENPrincipals.length; i++) {
				if(addedENPrincipals[i].principalCd == obj.principalCd) {
					addedENPrincipals.splice(i,1);
				}
			}
			delENPrincipals.push(obj);
		}
	} catch(e) {
		showErrorMessage("setENPrincipalObj", e);
		//showMessageBox("set obj principals: " + e.message);
	}
}
/** Validates if user has access to Endt PAR and Endorsement Package PAR details
 *  Modules: GIPIS058 and GIPIS058A
 * @author Veronica V. Raymundo
 * @param objUser - user details in JSONObject 
 * 		  underwriter - underwriter of the selected PAR
 * @return
 */

function validateUserEntryForEndtPAR(objUser, underwriter){
	var isUserAllowed = false;
	
	if(nvl(objUser.allUserSw,'N')== 'Y' && (nvl(objUser.misSw,'N')== 'Y' || nvl(objUser.mgrSw,'N')== 'Y')){
		isUserAllowed = true;
	}else if(objUser.userId != underwriter){
		showMessageBox("Record created by another user cannot be accessed.", imgMessage.INFO);
		isUserAllowed = false;
		return false;
	}else if(objUser.userId == underwriter){
		isUserAllowed = true;
	}

	return isUserAllowed;
}
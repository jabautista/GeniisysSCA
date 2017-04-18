/** Validates if user has access to PAR and Package PAR details
 *  Modules: GIPIS001 and GIPIS001A
 * @author Veronica V. Raymundo
 * @param objUser - user details in JSONObject 
 * 		  underwriter - underwriter of the selected PAR
 * 		  directParOpenAccess - direct par open access switch
 * @return
 */

function validateUserEntryForPAR(objUser, underwriter, directParOpenAccess){
	var isUserAllowed = false;
	
	if(nvl(objUser.allUserSw,'N')== 'Y' && (nvl(objUser.misSw,'N')== 'Y' || nvl(objUser.mgrSw,'N')== 'Y') /*&& nvl(directParOpenAccess, 'N') == 'Y'*/){
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
function validateUserEntryForQuotation(objUser, quoteUser, directParOpenAccess){
	var isUserAllowed = false;
	
	if(nvl(objUser.allUserSw,'N')== 'Y' && (nvl(objUser.misSw,'N')== 'Y' || nvl(objUser.mgrSw,'N')== 'Y') && nvl(directParOpenAccess, 'N') == 'Y'){
		isUserAllowed = true;
	}else if(objUser.userId != quoteUser){
		showMessageBox("Record created by another user cannot be accessed.", imgMessage.INFO);
		isUserAllowed = false;
		return false;
	}else if(objUser.userId == quoteUser){
		isUserAllowed = true;
	}

	return isUserAllowed;
}
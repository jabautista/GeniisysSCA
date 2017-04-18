function validateUserEntryForQuotation2(userId, directParOpenAccess, quotationUser){
	if(userId == quotationUser){
		return true;
	}else if(userId != quotationUser && directParOpenAccess == 'Y'){
		return true;
	}else if(userId != quotationUser && directParOpenAccess == 'N'){
		showMessageBox("Record created by another user cannot be accessed.", imgMessage.INFO);
		return false;
	}
}
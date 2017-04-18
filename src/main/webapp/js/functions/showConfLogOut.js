function showConfLogOut(){
	showConfirmBox("<fmt:message key='h.logout.logout' bundle='${linkText}' />", 
				"Are you sure you want to logout?", "Yes", "No", 
					function(){
						changeTag = 0;
						changeTagFunc = "";
						continueLogout();
					},
					"");
}
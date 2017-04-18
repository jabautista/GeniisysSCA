// check if the user is his/her first time login
function checkIfNewUser() {		
	if ($F("lastLogin").blank()) {			
		Dialog.alert("<div style='margin-top: 10px;'>Welcome new user <b>${PARAMETERS['USER'].username}</b>! <br /><br />"
						+"You must set your new password now."+
				     "</div>", {
			title: "System Message",
			className: "alphacube", /*options: "",*/
			width: 300,
			okLabel: "Set Now",
			onOk: setNewUserPassword,
			buttonClass: "button"
	   	});

	   	newUserTag = 1;
	} else {
		checkPasswordExpiry();
	}
}
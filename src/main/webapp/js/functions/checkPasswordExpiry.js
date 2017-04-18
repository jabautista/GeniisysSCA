// check for password expiry - Whofeih
function checkPasswordExpiry(){
	try {
		if (parseInt(passwordExpiry) <= 5) {
			var day = passwordExpiry == "0" ? "today. " : "in " + passwordExpiry + " day(s). ";
			
			showConfirmBox("Password Expiration", "Your password will expire " + day + "Would you like to change your password now?", "Yes", "No",
						function(){
							setPassword("false", "true");
						},
						""
					);			
		}
	} catch (e){
		showErrorMessage("checkPasswordExpiry", e);
	}
}
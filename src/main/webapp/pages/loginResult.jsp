<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script>
	var message = "${message}";
	var result = message.split(":");
	if ("nopassworderror" == result[0]){
		showWaitingMessageBox('You must set your password now.', imgMessage.INFO, function(){setPassword("true");});
	} else if ("nolastloginerror" == result[0]) {
		showWaitingMessageBox('You must set your new password now.', imgMessage.INFO, setPassword);
	} else if ("passworderror" == result[0]) {
		showWaitingMessageBox(result[1]+'<br>You need to change your password now.', imgMessage.INFO, setPassword);
	} else if ("expiredpassword" == result[0]){
		showWaitingMessageBox('The user&#039;s account&#47;password has expired and the password needs to be changed.', imgMessage.INFO, setPassword);
	} else if ("SUCCESS" == result[0]){
		modules = '${modules}'.split(","); 
		checkProceed("success"); 
		passwordExpiry = '${passwordExpiry}'; 
		userId = "${PARAMETERS['USER'].userId}";
	} 

	if ("SUCCESS" != result[0]) {
		showMessage(result[0]); $("timesFailed").value = parseInt($F("timesFailed"))+1;
	}	
</script>

//nok
function getIcon(msgIcon){
	try{
		var icon = msgIcon;
		if (msgIcon=="I") icon = imgMessage.INFO;
		if (msgIcon=="E") icon = imgMessage.ERROR;
		if (msgIcon=="W") icon = imgMessage.WARNING;
		if (msgIcon=="S") icon = imgMessage.SUCCESS;
		return icon;
	}catch (e) {
		showErrorMessage("getIcon",e);
	}	
}
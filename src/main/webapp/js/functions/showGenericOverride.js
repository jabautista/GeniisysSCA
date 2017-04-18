/**
 * Shows the override request user login, search project for example usage
 * @author andrew robes
 * @date 04.13.2012
 * @param moduleId
 * @param functionCode
 * @param onOk - function that will be executed when Ok button is pressed
 * @param onCancel - function that will be executed when Cancel button is pressed
 * @param title - title of override overlay 
 */
function showGenericOverride(moduleId, functionCode, onOk, onCancel, title){	// added title : shan 06.24.2014
	Override.show({
		moduleId : moduleId,
		functionCode : functionCode,
	    title: title == null ? "Override User" : title,	// modified : shan 06.24.2014
	    draggable: true,
	    height: 160,
	    onOk: function(userId, result){
	    	onOk(this, userId, result);
	    	// NOTE : for ok button use this parameters for your function
		    	// this - the window overlay, so you can close the window whenever you want
		    	// userId - the userId of the override user, usually used in message
		    	// result - either "TRUE" or "FALSE"
	    },
	    onCancel : function () {
			if (nvl(onCancel,"") == "") {
				return false;
			} else {
				onCancel();
			}
	    },
	    onShow:	function(){$("txtOverrideUserName").focus();}
	});	
}
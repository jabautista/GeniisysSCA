function prepareParameters(){
	try {
		var setAddedModifiedPrincipal		= getAddedModifiedPrincipalJSONObject();
		var delPrincipal					= getDeletedPrincipalJSONObject();
	
		// Sets the parameters
		var objParameters = new Object();
		objParameters.addModifiedPrincipal	 = prepareJsonAsParameter(setAddedModifiedPrincipal); // mark jm 04.26.2011 @UCPBGEN added prepareJsonAsParameter;
		objParameters.deletedPrincipal	     = prepareJsonAsParameter(delPrincipal); // mark jm 04.26.2011 @UCPBGEN added prepareJsonAsParameter;

		return JSON.stringify(objParameters);
	} catch (e) {
		showErrorMessage("prepareParameters", e);
	}
}
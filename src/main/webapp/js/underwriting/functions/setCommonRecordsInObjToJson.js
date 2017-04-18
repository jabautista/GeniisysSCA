function setCommonRecordsInObjToJson(objParameters){
	try{
		objParameters.setItemRows 	= prepareJsonAsParameter(objParameters.setItemRows);
		objParameters.delItemRows 	= prepareJsonAsParameter(objParameters.delItemRows);		
		objParameters.setDeductRows	= prepareJsonAsParameter(objParameters.setDeductRows);
		objParameters.delDeductRows	= prepareJsonAsParameter(objParameters.delDeductRows);
		objParameters.setPerils 	= prepareJsonAsParameter(objParameters.setPerils);		
		objParameters.delPerils 	= prepareJsonAsParameter(objParameters.delPerils);	
		objParameters.setWCs 		= prepareJsonAsParameter(objParameters.setWCs);

		objParameters.vars			= prepareJsonAsParameter(objFormVariables);
		objParameters.pars			= prepareJsonAsParameter(objFormParameters);
		objParameters.misc			= objFormMiscVariables; //prepareJsonAsParameter(objFormMiscVariables);
		
		return objParameters;
	}catch(e){
		showErrorMessage("", e);
	}
}
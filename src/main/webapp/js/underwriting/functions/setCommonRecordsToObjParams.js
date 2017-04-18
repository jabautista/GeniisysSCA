function setCommonRecordsToObjParams(objParameters){
	try{
		objParameters.setItemRows 	= getAddedAndModifiedJSONObjects(objGIPIWItem);
		objParameters.delItemRows 	= getDeletedJSONObjects(objGIPIWItem);		
		objParameters.setDeductRows	= getAddedAndModifiedJSONObjects(objDeductibles);
		objParameters.delDeductRows	= getDeletedJSONObjects(objDeductibles);
		objParameters.setPerils 	= getAddedAndModifiedJSONObjects(objGIPIWItemPeril);		
		objParameters.delPerils 	= getDeletedJSONObjects(objGIPIWItemPeril);	
		objParameters.setWCs 		= getAddedAndModifiedJSONObjects(objGIPIWPolWC);
		
		return objParameters;
	}catch(e){
		showErrorMessage("setCommonRecordsToObjParams", e);
	}	
}
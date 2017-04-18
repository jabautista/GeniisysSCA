function prepareAccEndtGroupedObjParams(){
	var objParams = new Object();

	objParams.setGroupedItems		 = prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objGipiwGroupedItemsList));
	objParams.delGroupedItems		 = prepareJsonAsParameter(getDeletedJSONObjects(objGipiwGroupedItemsList));
	objParams.setCoverageItems		 = prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objGipiwCoverageItems));
	objParams.delCoverageItems		 = prepareJsonAsParameter(getDeletedJSONObjects(objGipiwCoverageItems));
	objParams.setBeneficiaryItems	 = prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objGipiwGroupedBenItems));
	objParams.delBeneficiaryItems	 = prepareJsonAsParameter(getDeletedJSONObjects(objGipiwGroupedBenItems));
	objParams.setBeneficiaryPerils	 = prepareJsonAsParameter(getAddedAndModifiedJSONObjects(objGipiwGroupedBenPerils));
	objParams.delBeneficiaryPerils	 = prepareJsonAsParameter(getDeletedJSONObjects(objGipiwGroupedBenPerils));

	objParams.groupedItemsForPopBen	 = prepareJsonAsParameter(getJSONObjectGrpItemsAH(objGipiwGroupedItemsList, 1));
	objParams.coverageItemsForPopBen = prepareJsonAsParameter(getJSONObjectGrpItemsAH(objGipiwCoverageItems, 1));
	objParams.groupedItemsForRetGrp  = prepareJsonAsParameter(getJSONObjectGrpItemsAH(objGipiwGroupedItemsList, 2));
	
	return objParams;
}
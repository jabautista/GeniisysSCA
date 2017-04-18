function fillInspItemInformation(inspNo, itemNo, itemObj){
	var selectedObj = new Object();
	for (var i = 0; i < itemObj.length; i++){
		itemInfoList = itemObj[i];
		if (itemInfoList.inspNo == inspNo &&
			itemInfoList.itemNo == itemNo){
			selectedObj = itemInfoList;
		}
	}

	fillItemInfoUsingObject(selectedObj);
}
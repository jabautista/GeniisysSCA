/*	Created by	: mark jm 10.01.2010
 * 	Description	: check which preparation for content will be used and return
 * 	Parameter	: subpageName - name of the subpage where the table listing is located
 * 				: obj - object to get data from
 */
function getSubpageContent(subpageName, obj){
	try{
		var content = "";
		
		switch(subpageName){
			case "itemDeductible" 		: content = prepareDeductibles(obj); break;
			case "groupedItems" 		: content = prepareGroupedItems(obj); break;
			case "casualtyPersonnel" 	: content = prepareCasualtyPersonnel(obj); break;
			case "peril" 				: content = preparePerils(obj); break;
			case "carriers" 			: content = prepareCarrier(obj); break;
			case "mortgagees" 			: content = prepareMortgagee(obj); break;
			case "accessories" 			: content = prepareAccessory(obj); break;
		}
		
		return content;
	}catch(e){
		showErrorMessage("getSubpageContent", e);
		//showMessageBox("getSubpageContent : " + e.message);
	}
}
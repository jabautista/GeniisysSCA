/**
 * To determine if the item no entered is endt or not
 * @author andrew
 * @date 02.25.2011 
 * @returns {Boolean}
 */
function isEndtItem(obj){
	try {
		var itemRow = "row"+$F("itemNo");
		if(/*$F("globalParType")*/objUWParList.parType == "E" && $(itemRow) == null){
			return true;
		} else {
			return false;
		}
	} catch (e){		
		showErrorMessage("isEndtItem", e);
	}
}
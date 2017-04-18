/**
 * Generate new divCtrId
 * 
 * @author Jerome Orio 09.28.2010
 * @version 1.0
 * @param object
 *            array
 * @return new divCtrId
 */
function generateDivCtrId(objArray) {
	var divCtrIds = "";
	for ( var a = 0; a < objArray.length; a++) {
		divCtrIds = divCtrIds + objArray[a].divCtrId + " ";
	}

	var itemNos = divCtrIds.trim().split(" ");
	for ( var index = 0, len = itemNos.length; index < len; index++) {
		for ( var elem = 0; elem < len; elem++) {
			var temp = 0;
			if (parseInt(itemNos[elem]) > parseInt(itemNos[elem + 1])) {
				temp = itemNos[elem];
				itemNos[elem] = itemNos[elem + 1];
				itemNos[elem + 1] = temp;
			}
		}
	}
	var seq = parseInt(itemNos.last()) + 1;
	return (isNaN(seq) ? 1 : seq);
}
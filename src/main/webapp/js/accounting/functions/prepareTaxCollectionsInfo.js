/**
 * function that will prepare Tax Collections Info
 * 
 * @author Alfie Niño Bioc 11.26.2010
 * @version 1.0
 * @param
 * @return
 */
function prepareTaxCollectionsInfo(obj){
	try {
		var taxInfo = '<label style="width: 90px; text-align:center; margin-left: 5px;" title="' + obj.transactionType + '">' + obj.transactionType + '</label>' +						
					  '<label style="width: 90px; text-align: center; margin-left: 8px;" title="' + obj.b160IssCd + '">' + obj.b160IssCd + '</label>'+
					  '<label style="width: 90px; text-align: center; margin-left: 8px;" title="' + obj.b160PremSeqNo + '">' + obj.b160PremSeqNo + '</label>' +
					  '<label style="width: 70px; text-align: center; margin-left: 8px;" title="' + obj.instNo + '">' + obj.instNo + '</label>' +
					  '<label style="width: 350px; text-align: left; margin-left: 8px;" title="' + obj.taxName + '">' + obj.taxName + '</label>' +
					  '<label style="width: 120px; text-align: right; margin-left: 6px;" title="' + obj.taxAmt + '" class="money" >' + formatCurrency(obj.taxAmt) + '</label>';
		return taxInfo;
	} catch (e) {
		showErrorMessage("prepareTaxCollectionsInfo", e);
		// showMessageBox("prepareTaxCollectionsInfo" + e.message);
	}
}
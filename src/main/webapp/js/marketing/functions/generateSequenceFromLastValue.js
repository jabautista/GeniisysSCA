/**
 * 
 * @param param
 * @param seqField
 * @return
 */
function generateSequenceFromLastValue(param, seqField){
	var itemNo = $$("div[name='" + param + "']").size();
	var ctr = 0;
	var lastSeqNo = 0;
	
	$$("div[name='" + param + "']").each(function(row){
		ctr++;
		if (ctr == itemNo){
			lastSeqNo = row.down("input", 0).value;
		}
	});
	$(seqField).value = parseInt(lastSeqNo) + 1;
}
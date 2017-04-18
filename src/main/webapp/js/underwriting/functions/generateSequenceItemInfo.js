//generate sequence
//parameter: row name
//parameter: new generated sequence holder
//parameter: attribute name you will use
//parameter: primary value you will use
//parameter: item field that will hold all the value in table
function generateSequenceItemInfo(param, seqField, attr, pkValue, itemSeqField) {
	var itemNoSize = $$("div[name='"+param+"']").size();
	var getItemNo = 0;
	if (itemNoSize > 0){
		$$("div[name='"+param+"']").each(function (a){
			if (a.getAttribute(attr) == pkValue) {
				getItemNo = getItemNo+ " " +a.down("input",2).value;
			}
		});	
	}
	$(itemSeqField).value = (getItemNo == "" ? "0 ": getItemNo);
	var newItemNo = sortNumbers($(itemSeqField).value).last();
	$(seqField).value = parseInt(newItemNo)+1;
}
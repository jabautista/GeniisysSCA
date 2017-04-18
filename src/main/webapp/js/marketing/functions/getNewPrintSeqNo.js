/*	Created by	: BJGA 12.23.2010
 * 	Description	: Generates & returns a new print Seq no 
 * 	Parameter	: 
 */
function getNewPrintSeqNo(){
	var highestPrintSeqNo = 0;
	$$("div#wcDiv div[name='row']").each(function(wc){
		var printSeqNo = (wc.down("input", 4).value == "") ? 0 : parseInt(wc.down("input", 4).value);
		if (printSeqNo > highestPrintSeqNo){
			highestPrintSeqNo = printSeqNo;
		}
	});
	return highestPrintSeqNo + 1;
}
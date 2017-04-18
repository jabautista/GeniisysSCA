/**
 * Generate new sequence in GIPIS143
 * @author Jerome Orio 01.25.2011
 * @version 1.0
 * @param 
 * @return
 */
function generateSequenceGIPIS143() {
	var currSeqNo = 0;
	currSeqNo = $$("div[name='rowBasic']").size() + $$("div[name='rowItem']").size() +$$("div[name='rowPeril']").size() + 1; 
	$("sequenceNoPeril").value = currSeqNo;
	$("sequenceNoItem").value = currSeqNo;
	$("sequenceNo").value = currSeqNo;
	$("hiddenSequence").value = currSeqNo;
}
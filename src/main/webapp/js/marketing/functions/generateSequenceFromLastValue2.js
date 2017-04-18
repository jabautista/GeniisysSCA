function generateSequenceFromLastValue2(){
	var itemNo;
	var param;
	var ctr = 0;
	var lastSeqNo = 0;
	var currSeqNo = 0;
	
	currSeqNo = $$("div[name='rowBasic']").size() + $$("div[name='rowItem']").size() +$$("div[name='rowPeril']").size() + 1; 
	$("sequenceNoPeril").value = currSeqNo;
	$("sequenceNoItem").value = currSeqNo;
	$("sequenceNo").value = currSeqNo;
	$("hiddenSequence").value = currSeqNo;
}
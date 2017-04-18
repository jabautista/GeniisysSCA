function usePayor() {
	var selectedId = $("selectedClientId").value;
	if (selectedId != "") {
		var clientCd = selectedId;
		// var name = $(selectedId+"name").innerHTML;
		var name = $(selectedId + "name").title; // andrew - 05.10.2011 - to
													// get the full payor name
		var address1 = $(selectedId + "address1").value;
		var address2 = $(selectedId + "address2").value;
		var address3 = $(selectedId + "address3").value;
		var tin = $(selectedId + "tin").value;

		$("payorName").value = name;
		$("payorNo").value = selectedId;
		$("address1").value = address1;
		$("address2").value = address2;
		$("address3").value = address3;
		$("payorTinNo").value = tin;

		/*
		 * adpascual - 03.20.2012- modified the following lines - isolate each
		 * addresses to 3 diff. fields instead of concatenating to 1 field
		 */
		$("payorAddress1").value = address1;
		$("payorAddress2").value = address2;
		$("payorAddress3").value = address3;

	}
	$("payorName").focus();
	changeTag = 1; //Deo [02.16.2017]: SR-5932
}
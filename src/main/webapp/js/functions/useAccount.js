function useAccount(){
	var selectedId = $('selectedClientId').value;
	if (selectedId != ""){
		$("acctOfCd").value = selectedId;
		var name = $(selectedId+'name').getAttribute("title").strip();
		$('inAccountOf').value = name;
		changeTag = 1;
	}
	$("inAccountOf").focus();
}
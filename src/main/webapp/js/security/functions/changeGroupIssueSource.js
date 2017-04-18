function changeGroupIssueSource() {
	var grpIssCd = $("userGroup").options[$("userGroup").selectedIndex].readAttribute("grpisscd");
	for (var i=0; i<$("grpIssHidden").length; i++) {
		if (grpIssCd == $("grpIssHidden").options[i].value) {
			$("grpIssCd").value = $("grpIssHidden").options[i].value;
			$("grpIssName").value = $("grpIssHidden").options[i].text;
		}
	}
	
}
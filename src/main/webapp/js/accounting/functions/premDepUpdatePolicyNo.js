// updates the policy no field
function premDepUpdatePolicyNo() {
	if (!$F("txtLineCd").blank() && !$F("txtSublineCd").blank()
			&& !$F("txtIssCd").blank() && !$F("txtIssueYy").blank()
			&& !$F("txtPolSeqNo").blank() && !$F("txtRenewNo").blank()) {
		$("txtPolicyNo").value = ($F("txtLineCd").blank() ? " "
				: $F("txtLineCd"))
				+ "-"
				+ ($F("txtSublineCd").blank() ? " " : $F("txtSublineCd"))
				+ "-"
				+ ($F("txtIssCd").blank() ? " " : $F("txtIssCd"))
				+ "-"
				+ ($F("txtIssueYy").blank() ? " " : parseInt($F("txtIssueYy"),
						10).toPaddedString(2))
				+ "-"
				+ ($F("txtPolSeqNo").blank() ? " " : parseInt(
						$F("txtPolSeqNo"), 10).toPaddedString(7))
				+ "-"
				+ ($F("txtRenewNo").blank() ? " " : parseInt($F("txtRenewNo"),
						10).toPaddedString(2));
	}
}
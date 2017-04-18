// updates the par no field
function premDepUpdateParNo() {
	if ($F("txtParLineCd").blank() && $F("txtParIssCd").blank()
			&& $F("txtParYy").blank() && $F("txtParSeqNo").blank()
			&& $F("txtQuoteSeqNo").blank()) {
		$("txtParNo").value = "";
	} else {
		$("txtParNo").value = ($F("txtParLineCd").blank() ? " "
				: $F("txtParLineCd"))
				+ "-"
				+ ($F("txtParIssCd").blank() ? " " : $F("txtParIssCd"))
				+ "-"
				+ ($F("txtParYy").blank() ? " " : $F("txtParYy"))
				+ "-"
				+ ($F("txtParSeqNo").blank() ? " " : parseInt(
						$F("txtParSeqNo"), 10).toPaddedString(6))
				+ "-"
				+ ($F("txtQuoteSeqNo").blank() ? " " : parseInt(
						$F("txtQuoteSeqNo"), 10).toPaddedString(2));
	}
}

/** end of GIACS026 functions * */
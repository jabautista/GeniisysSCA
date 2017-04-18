function populationThirdAverseDetails(obj){
	try{
		tpSelectedIndex	= obj == null ? null :tpSelectedIndex;
		$("payeeClassCd").value = obj == null ? null :unescapeHTML2(String(obj[mcTpDtlGrid.getColumnIndex('payeeClassCd')]));
		$("payeeClass").value = obj == null ? null :unescapeHTML2(obj[mcTpDtlGrid.getColumnIndex('classDesc')]);
		$("payeeNo").value = obj == null ? null :unescapeHTML2(String(obj[mcTpDtlGrid.getColumnIndex('payeeNo')]));
		$("payee").value = obj == null ? null :unescapeHTML2(obj[mcTpDtlGrid.getColumnIndex('payeeDesc')]);
		$("payeeAddress").value = obj == null ? null :unescapeHTML2(obj[mcTpDtlGrid.getColumnIndex('dspPayeeAdd')]);
		
		var tpType = obj == null? null : obj[mcTpDtlGrid.getColumnIndex('tpType')];
		if(obj == null){
			$("tpTypeOpt").options.selectedIndex = 0;
			$("btnAdd").value = "Add";
			disableButton("btnDelete");
		}else{
			$("btnAdd").value = "Update";
			enableButton("btnDelete");
			for ( var i = 0; i < $("tpTypeOpt").length; i++) {
				if ($("tpTypeOpt").options[i].value == tpType) {
					$("tpTypeOpt").options.selectedIndex = i;
				}
			}
		}
		if (tpType == "T" || tpType == "A") {
			// $("lowerSection").setStyle("display: ;");
			Effect.Appear("lowerSection", {
				duration: .2,
				afterFinish: function () {
					$("lowerSectionLabel").innerHTML = tpType == "T" || tpType == "B" ? "Third Party" : "Adverse Party";
				}
			});
			populateOtherDetails(obj);
			// detTpInsurerCd
		}else{
			fadeElement("lowerSection",.2,null);
			populateOtherDetails(null);
		}
	}catch(e){
		showErrorMessage("populationThirdAverseDetails",e);
	}
}
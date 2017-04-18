//kenneth SR 5147 11.13.2015
function getReasonLOV(isIconClicked) {
	try {
		var searchString = isIconClicked ? "%" : ($F("txtReasonCd").trim() == "" ? "%" : $F("txtReasonCd"));
		LOV.show({
			controller : "CLTransactionsLOVController",
			urlParameters : {
				action : "showReasonLOV",
				filterText : isIconClicked ? "%" : ($F("txtReasonCd").trim() == "" ? "%" : $F("txtReasonCd")), 
				/*findText : searchString + "%",*/ /*--edited by MarkS 7.26.2016 SR22736*/
				page : 1
			},
			title : "List of Reasons",
			width : 400,
			height : 390,
			columnModel : [ {
				id : "reasonCode",
				title : "Reason Code",
				width : '80px'
			}, {
				id : "reasonDesc",
				title : "Description",
				width : '285px'
			} ],
			draggable : true,
			autoSelectOneRecord : true,
			onSelect : function(row) {
				if (row != undefined) {
					$("txtReasonCd").value = unescapeHTML2(row.reasonCode);
					$("txtReasonDesc").value = unescapeHTML2(row.reasonDesc);
					$("txtReasonCd").setAttribute("lastValidValue", unescapeHTML2(row.reasonCode));
					$("txtReasonDesc").setAttribute("lastValidValue", unescapeHTML2(row.reasonDesc));
					$("txtReasonCd").focus();
				}
			},
			onCancel : function() {
				$("txtReasonCd").focus();
				$("txtReasonCd").value = $("txtReasonCd").readAttribute("lastValidValue");
				$("txtReasonDesc").value = $("txtReasonDesc").readAttribute("lastValidValue");
			},
			onUndefinedRow : function() {
				$("txtReasonCd").value = $("txtReasonCd").readAttribute("lastValidValue");
				$("txtReasonDesc").value = $("txtReasonDesc").readAttribute("lastValidValue");
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtReasonCd");
			}
		});
	} catch (e) {
		showErrorMessage("getReasonLOV", e);
	}
}
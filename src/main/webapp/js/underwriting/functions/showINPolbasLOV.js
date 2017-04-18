// Joms 10.16.12
function showINPolbasLOV() {
	try {
		LOV
				.show({
					controller : "UnderwritingLOVController",
					urlParameters : {
						action : "showINPolbasLOV",
						lineCd : $F("txtLineCd"),
						sublineCd : $F("txtSublineCd"),
						issCd : $F("txtIssCd"),
						issueYy : $F("txtIssueYy"),
						polSeqNo : $F("txtPolSeqNo"),
						renewNo : $F("txtRenewNo"),
						notIn : "",
						page : 1
					},
					title : "List for Update of Initial Acceptance",
					width : 650,
					height : 410,
					hideColumnChildTitle : true,
					filterVersion : "2",
					columnModel : [ {
						id : 'recordStatus',
						title : '',
						width : '0',
						visible : false,
						editor : 'checkbox'
					}, {
						id : 'divCtrId',
						width : '0',
						visible : false
					}, {
						id : "policyNo",
						title : "Policy No. ",
						titleAlign : 'center',
						width : '160px',
						children : [ {
							id : 'lineCd',
							title : 'Line Code',
							width : 30,
							filterOption : true,
							editable : false
						}, {
							id : 'sublineCd',
							title : 'Subline Code',
							width : 50,
							filterOption : true,
							editable : false
						}, {
							id : 'issCd',
							title : 'Policy Issue Code',
							width : 30,
							//filterOption : true,
							editable : false
						}, {
							id : 'issueYy',
							title : 'Issue Year',
							type : 'number',
							align : 'right',
							width : 30,
							filterOption : true,
							filterOptionType: 'integerNoNegative',
							renderer : function(value) {
								return formatNumberDigits(value, 2);
							},
							editable : false
						}, {
							id : 'polSeqNo',
							title : 'Policy Sequence No.',
							type : 'number',
							align : 'right',
							width : 60,
							filterOption : true,
							filterOptionType: 'integerNoNegative',
							renderer : function(value) {
								return formatNumberDigits(value, 7);
							},
							editable : false
						}, {
							id : 'renewNo',
							title : 'Renew No.',
							type : 'number',
							align : 'right',
							width : 28,
							filterOption : true,
							filterOptionType: 'integerNoNegative',
							renderer : function(value) {
								return formatNumberDigits(value, 2);
							},
							editable : false
						} ]
					}, {
						id : "endtNo",
						title : "Endorsement No.",
						width : '100px'
					}, {
						id : "assdName",
						title : "Assured Name",
						width : '290'
					}, ],
					draggable : true,
					onSelect : function(row) {
						$("txtPolicyNo").value = unescapeHTML2(row.policyNo);
						$("txtLineCd").value = unescapeHTML2(row.lineCd);
						$("txtPolicyId").value = row.policyId;
						$("txtEndorsementNo").value = unescapeHTML2(row.endtNo);
						$("txtAssuredNo").value = unescapeHTML2(row.assdName);
						$("txtAcceptanceNo").value = row.acceptNo;
						$("txtRefAcceptNo").value = unescapeHTML2(row.refAcceptNo);
						$("txtAcceptedBy").value = unescapeHTML2(row.acceptBy);
						$("txtAcceptDate").value = dateFormat(row.acceptDate, "mm-dd-yyyy");
						//$("txtCedingCompany").value = unescapeHTML2(row.riSname); replaced by: Nica 5.02.2013
						//$("txtReassured").value = unescapeHTML2(row.riSname2);
						$("txtCedingCompany").value = unescapeHTML2(row.riSname2);
						$("txtReassured").value = unescapeHTML2(row.riSname);
						$("txtRIPolicyNo").value = unescapeHTML2(row.riPolicyNo);
						$("txtRIBinderNo").value = unescapeHTML2(row.riBinderNo);
						$("txtRIEndtNo").value = unescapeHTML2(row.riEndtNo);
						$("txtDateOffered").value = dateFormat(row.offerDate, "mm-dd-yyyy");
						$("txtOfferedBy").value = unescapeHTML2(row.offeredBy);
						$("txtAmountOffered").value = formatCurrency(row.amountOffered);
						$("txtOrigTSIAmount").value = formatCurrency(row.origTSIAmt);
						$("txtOrigPremAmount").value = formatCurrency(row.origPremAmt);
						$("txtRemarks").value = unescapeHTML2(row.remarks);
						$("oldOrigTSIAmt").value = formatCurrency(row.origTSIAmt);
						$("oldOrigPremAmt").value = formatCurrency(row.origPremAmt);
						$("txtRIPolicyNo").readOnly = false;
						$("txtRIBinderNo").readOnly = false;
						$("txtRIEndtNo").readOnly = false;
						$("txtOrigTSIAmount").readOnly = false;
						$("txtOrigPremAmount").readOnly = false;
						$("txtOrigPremAmount").readOnly = false;
						$("txtRemarks").readOnly = false;
					}
				});
	} catch (e) {
		showErrorMessage("showINPolbasLOV", e);
	}
}
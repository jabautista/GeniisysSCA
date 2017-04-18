// bonok :: 02.25.2013 :: giuts003 Policy No LOV
function getPolicyGiuts003LOV() {
	try {
		//added validation if lineCd is null reymon 04302013
		if ($F("lineCd") == "" || $F("lineCd") == null){
			showMessageBox("Line code is required.", "E");
		}else{
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getPolicyGiuts003LOV",
					lineCd : $F("lineCd"),
					sublineCd : $F("sublineCd"),
					issCd : $F("issCd"),
					issueYy : $F("issueYy"),
					polSeqNo : $F("polSeqNo"),
					renewNo : $F("renewNo")
				},
				title : "Policy Listing",
				width : 709,
				height : 386,
				autoSelectOneRecord: false,//changed from true reymon 04302013
				columnModel : [ {
					id : "policyNo",
					title : "Policy No.",
					width : '165px',
				}, 
				{
					id : "endtNo",
					title : "Endt No.",
					width : '160px'
				},
				{
					id : "assdName",
					title : "Assured Name",
					width : '245px'
				},
				{
					id : "policyStatus",
					title : "Policy Status",
					width : '120px'
				}
				],
				draggable : true,
				onSelect : function(row) {
					if (row != undefined) {
						$("lineCd").value = row.lineCd;
						$("sublineCd").value = unescapeHTML2(row.sublineCd); //unescapeHTML2 added by jeffdojello 01.16.2014 SR-14773
						$("issCd").value = row.issCd;
						$("issueYy").value = row.issueYy;
						$("polSeqNo").value = formatNumberDigits(row.polSeqNo, 6);
						$("renewNo").value = formatNumberDigits(row.renewNo, 2);
						$("endtNo").value = row.endtNo;
						$("assdName").value = unescapeHTML2(row.assdName);
						$("acctEntDate").value = formatDateToDefaultMask(row.acctEntDate);
						$("effDate").value = formatDateToDefaultMask(row.effDate);
						$("expDate").value = formatDateToDefaultMask(row.expiryDate);
						$("spldUserId").value = unescapeHTML2(row.spldUserId);
						$("spldDate").value = row.spldDate == null ? null : dateFormat(row.spldDate, "dd-mmm-yyyy").toUpperCase();
						$("policyStatus").value = unescapeHTML2(row.policyStatus);
						$("spldApproval").value = unescapeHTML2(row.spldApproval);
						$("spoilCd").value = unescapeHTML2(row.spoilCd);
						$("spoilDesc").value = unescapeHTML2(row.spoilDesc);
						$("policyId").value = row.policyId;
						$("spldFlag").value = row.spldFlag;
						$("endtSeqNo").value = row.endtSeqNo;
						$("polFlag").value = row.polFlag;
						$("endtExpiryDate").value = row.endtExpiryDate;
						$("prorateFlag").value = row.prorateFlag;
						$("compSw").value = row.compSw;
						$("shortRtPercent").value = row.shortRtPercent;
					}
					toggleButtonsGiuts003();
				}
			});
		}
	} catch (e) {
		showErrorMessage("getPolicyGiuts003LOV", e);
	}
}
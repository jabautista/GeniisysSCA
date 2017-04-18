/**
 * Shows policy number list
 * 
 * @author andrew
 * @date 05.06.2011
 * 
 * Used by: Endt Par, Endt Pack Par
 */
function showPolicyNoLOV(policyNo) {
	try {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : policyNo.action,
				lineCd : policyNo.lineCd,
				sublineCd : policyNo.sublineCd,
				issCd : policyNo.issCd,
				issueYy : policyNo.issueYy,
				polSeqNo : policyNo.polSeqNo,
				renewNo : policyNo.renewNo,
				page : 1
			},
			title : "Policy List",
			width : 460,
			height : 350,
			columnModel : [ {
				id : "sublineCd",
				title : "Subline Code",
				width : '90px'
			}, {
				id : "issCd",
				title : "Issue Code",
				width : '80px'
			}, {
				id : "issueYy",
				title : "Issue Year",
				width : '80px',
				align : 'right',
				renderer : function(value) {
					return formatNumberDigits(value, 2);
				}
			}, {
				id : "polSeqNo",
				title : "Sequence No",
				width : '90px',
				align : 'right',
				renderer : function(value) {
					return formatNumberDigits(value, 7);
				}
			}, {
				id : "renewNo",
				title : "Renew No",
				width : '80px',
				align : 'right',
				renderer : function(value) {
					return formatNumberDigits(value, 2);
				}
			} ],
			draggable : true,
			onSelect : function(row) {
				loadSelected2(row);
			}
		});
	} catch (e) {
		showErrorMessage("showPolicyNoLOV", e);
	}
}
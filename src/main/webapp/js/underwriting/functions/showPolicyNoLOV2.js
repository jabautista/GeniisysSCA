/**
 * Shows Policy No. LOV for GIRIS053
 * 
 * @author Emsy Bolaños
 * @date 01.03.2012
 */
function showPolicyNoLOV2() {
	try {
		LOV
				.show({
					controller : "UnderwritingLOVController",
					urlParameters : {
						action : "getBinderPolicyNoLOV",
						moduleId : "GIRIS053",
						page : 1
					},
					title : "List of Policy No",
					width : 730,
					height : 411,
					filterVersion : "2",
					columnModel : [ {
						id : "policyNo",
						title : "Policy Number",
						width : '225px',
						filterOption : true
					}, {
						id : "assdName",
						title : "Assured Name",
						width : '350px',
						filterOption : true
					}, {
						id : 'endtNo',
						title : 'Endorsement No.',
						titleAlign : 'center',
						width : '117px'
					}, {
						id : 'policyId',
						title : '',
						width : '0px',
						visible : false
					}, {
						id : 'lineCd',
						title : 'Line Cd',
						width : '0px',
						visible : false,
						filterOption : true
					}, {
						id : 'sublineCd',
						title : 'Subline Cd',
						width : '0px',
						visible : false,
						filterOption : true
					}, {
						id : 'issCd',
						title : 'Issue Cd',
						width : '0px',
						visible : false,
						filterOption : true
					}, {
						id : 'issueYy',
						title : 'Issue YY',
						width : '0px',
						visible : false,
						filterOption : true
					}, {
						id : 'polSeqNo',
						title : 'Policy Seq. No.',
						width : '0px',
						visible : false,
						filterOption : true
					}

					],
					draggable : true,
					onSelect : function(row) {
						if (row != undefined) {
							$("polNo").value = unescapeHTML2(row.policyNo);
							$("assuredName").value = unescapeHTML2(row.assdName);	// added unescapeHTML2 : shan 07.30.2014
							$("endtNo").value = row.endtNo;
							changeTag = 1;
							binderTableGrid.url = contextPath
									+ "/GIRIFrpsRiController?action=showBinderListing&refresh=1&policyId="
									+ row.policyId;
							binderTableGrid._refreshList();
							$("policyId").value = row.policyId;
						}
					}
				});
	} catch (e) {
		showErrorMessage("showPolicyNoLOV2", e);
	}
}
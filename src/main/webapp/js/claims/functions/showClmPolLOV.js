/**
 * Shows Claim/Policy LOV  - displays Claim No. Policy No. and Assured name on overlay
 * @param p_module
 * @param Module Id - to consider module ID on access parameters
 * @author Aliza Garza 06.05.2013
 * */
function showClmPolLOV(moduleId) {
	try{
		LOV.show({
			controller : "ClaimsLOVController",
			urlParameters : {
				action       	: "getClmPolLOV",
				moduleId		: moduleId,
				clmLineCd    	: $F("txtNbtClmLineCd"),
				clmSublineCd    : $F("txtNbtClmSublineCd"),
				lineCd    		: $F("txtNbtLineCd"),
				sublineCd    	: $F("txtNbtSublineCd"),
				issCd	 		: $F("txtNbtClmIssCd"),
				polIssCd		: $F("txtNbtPolIssCd"),
				clmYy 			: $F("txtNbtClmYy"),
				issueYy 		: $F("txtNbtIssueYy"),
				clmSeqNo 		: $F("txtNbtClmSeqNo"),
				polSeqNo 		: $F("txtNbtPolSeqNo"),
				renewNo 		: $F("txtNbtRenewNo"),
			},
			title : "Claim Listing",
			width : 535,
			height : 390,
			hideColumnChildTitle : true,
			//filterVersion : "2",
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
				id : 'claimId',			
				width : '0',
				visible : false
			}, {
				id : 'claimStatus',			
				width : '0',
				visible : false
			},{
				id : 'claimNo',
				title : 'Claim No.',
				titleAlign : 'center',
				width : 205,
				children : [ {
					id : 'clmLineCd',
					title : 'Claim Line Code',
					width : 30,
					filterOption : true,
					editable : false
				}, {
					id : 'clmSublineCd',
					title : 'Claim Subline Code',
					width : 50,
					filterOption : true,
					editable : false
				}, {
					id : 'issCd',
					title : 'Claim Issue Code',
					width : 30,
					filterOption : true,
					editable : false
				}, {
					id : 'clmYy',
					title : 'Claim Year',
					type : 'number',
					align : 'right',
					width : 30,
					filterOption : true,
					renderer : function(value) {
						return formatNumberDigits(value, 2);
					},
					editable : false
				}, {
					id : 'clmSeqNo',
					title : 'Claim Sequence No.',
					type : 'number',
					align : 'right',
					width : 60,
					filterOption : true,
					renderer : function(value) {
						return formatNumberDigits(value, 7);
					},
					editable : false
				} ]
			}, {
				id : 'assuredName',
				title : 'Assured Name',
				titleAlign : 'left',
				width : '300px',
				filterOption : true,
				editable : false
			}, {
				id : 'lossCategory',
				title : 'Loss Category',
				titleAlign : 'left',
				width : '0px',
				editable : false,
				visible: false
			}, {
				id : 'lossDate',
				title : 'Loss Date',
				titleAlign : 'left',
				width : '0px',
				editable : false,
				visible: false
			}],
			draggable : true,
			autoSelectOneRecord: true,
			onSelect : function(row) {
				if (row != undefined) {
					//assigning of values
					$("txtNbtClmLineCd").value = row.clmLineCd;
					$("txtNbtClmSublineCd").value = row.clmSublineCd;
					$("txtNbtClmIssCd").value = row.issCd;
					$("txtNbtClmYy").value = formatNumberDigits(row.clmYy,2);
					$("txtNbtClmSeqNo").value = formatNumberDigits(row.clmSeqNo,7);
					$("txtNbtLineCd").value = row.lineCd;
					$("txtNbtSublineCd").value = row.sublineCd;
					$("txtNbtPolIssCd").value = row.polIssCd;
					$("txtNbtIssueYy").value = formatNumberDigits(row.issueYy,2);
					$("txtNbtPolSeqNo").value = formatNumberDigits(row.polSeqNo,7);
					$("txtNbtRenewNo").value = formatNumberDigits(row.renewNo,2);
					$("txtNbtAssuredName").value = unescapeHTML2(row.assuredName);
					$("txtLossCategory").value = unescapeHTML2(row.lossCategory);
					$("txtLossDate").value = unescapeHTML2(row.lossDate);
					$("txtClmStatus").value = row.claimStatus;
					$("claimId").value = row.claimId;
					objCLMGlobal.claimId = row.claimId;
					enableToolbarButton("btnToolbarEnterQuery");
					enableToolbarButton("btnToolbarExecuteQuery");
				}
			},
			onCancel : function(){
					$("txtNbtAssuredName").clear();
					$("txtLossCategory").clear();
					$("txtLossDate").clear();
					$("txtClmStatus").clear();
			},
			onUndefinedRow : function() {
				$("txtNbtClmLineCd").clear();
				$("txtNbtClmSublineCd").clear();
				$("txtNbtClmIssCd").clear();
				$("txtNbtClmYy").clear();
				$("txtNbtClmSeqNo").clear();
				$("txtNbtLineCd").clear();
				$("txtNbtSublineCd").clear();
				$("txtNbtPolIssCd").clear();
				$("txtNbtIssueYy").clear();
				$("txtNbtPolSeqNo").clear();
				$("txtNbtRenewNo").clear();
				$("txtLossCategory").clear();
				$("txtLossDate").clear();
				$("txtClmStatus").clear();
				customShowMessageBox("No record selected", "I",
						$("txtNbtClmLineCd").attr("id"));

			}
		});
		
		
		
	}catch(e){
		showErrorMessage("showClmPolLOV", e);
	}
	
}
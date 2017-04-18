/**
 * Show claim listing
 * 
 * @author Cherrie Love Perello
 * @date 12.19.2012
 * modified by adpascual 05.16.2013
 * modified to generalized or be used with other modules
 */
function showClmListLOV(pModuleId) {
	try{
		LOV.show({
			controller : "ClaimsLOVController",
			urlParameters : {
				action       	: "getClaimListLOV",
				moduleId		: pModuleId,
				clmLineCode    	: $F("txtNbtClmLineCd"),
				clmSublineCode  : $F("txtNbtClmSublineCd"),
				lineCode    	: $F("txtNbtLineCd"),
				sublineCode    	: $F("txtNbtSublineCd"),
				issCode	 		: $F("txtNbtClmIssCd"),
				polIssCode		: $F("txtNbtPolIssCd"),
				clmYr 			: $F("txtNbtClmYy"),
				issueYr 		: $F("txtNbtIssueYy"),
				clmSeqNum 		: $F("txtNbtClmSeqNo"),
				polSeqNum 		: $F("txtNbtPolSeqNo"),
				renewNum 		: $F("txtNbtRenewNo")
			},
			title : "Claim Listing",
			width : 750,
			height : 390,
			autoSelectOneRecord: true,
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
				id : 'claimId',			
				width : '0',
				visible : false
			}, {
				id : 'claimStatus',			
				width : '0',
				visible : false
			}, {
				id : 'lossCategory',
				width : '0',
				visible: false
			}, {
				id : 'lossDate',
				width : '0',
				visible: false
			},{
				id : 'claimNo',
				title : 'Claim No.',
				titleAlign : 'center',
				width : 200,
				sortable: true,
				children : [ {
					id : 'clmLineCd',
					title : 'Claim Line Code',
					width : 30,
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
					filterOptionType : 'number',
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
					filterOptionType : 'number',
					renderer : function(value) {
						return formatNumberDigits(value, 7);
					},
					editable : false
				} ]
			}, {
				id : 'policyNo',
				title : 'Policy No.',
				titleAlign : 'center',
				width : 220,
				sortable: true,
				children : [ {
					id : 'lineCd',
					title : 'Line Code',
					width : 30,
					editable : false
				}, {
					id : 'sublineCd',
					title : 'Subline Code',
					width : 50,
					filterOption : true,
					editable : false
				}, {
					id : 'polIssCd',
					title : 'Policy Issue Code',
					width : 30,
					filterOption : true,
					editable : false
				}, {
					id : 'issueYy',
					title : 'Issue Year',
					type : 'number',
					align : 'right',
					width : 30,
					filterOption : true,
					filterOptionType : 'number',
					renderer : function(value) {
						return formatNumberDigits(value, 2);
					},
					editable : false
				}, {
					id : 'polSeqNo',
					title : 'Policy Sequence No.',
					type : 'number',
					align : 'right',
					width : 50,
					filterOption : true,
					filterOptionType : 'number',
					renderer : function(value) {
						return formatNumberDigits(value, 7);
					},
					editable : false
				}, {
					id : 'renewNo',
					title : 'Renew No.',
					type : 'number',
					align : 'right',
					width : 30,
					filterOption : true,
					filterOptionType : 'number',
					renderer : function(value) {
						return formatNumberDigits(value, 2);
					},
					editable : false
				} ]
			}, {
				id : 'assuredName',
				title : 'Assured Name',
				titleAlign : 'left',
				width : 300,
				filterOption : true,
				editable : false,
				sortable: true
			}],
			draggable : true,
			onSelect : function(row) {
				if (row != undefined) {
					//assigning of values
					$("txtNbtClmLineCd").value = row.clmLineCd;
					$("txtNbtClmSublineCd").value = row.clmSublineCd;
					$("txtNbtClmIssCd").value = row.issCd;
					$("txtNbtClmYy").value = lpad(nvl(row.clmYy,""),2,0);
					$("txtNbtClmSeqNo").value = lpad(nvl(row.clmSeqNo,""), 7,0);
					$("txtNbtLineCd").value = row.lineCd;
					$("txtNbtSublineCd").value = row.sublineCd;
					$("txtNbtPolIssCd").value = row.polIssCd;
					$("txtNbtIssueYy").value = lpad(nvl(row.issueYy,""),2,0);
					$("txtNbtPolSeqNo").value = lpad(nvl(row.polSeqNo,""), 7,0);
					$("txtNbtRenewNo").value = lpad(nvl(row.renewNo,""),2,0);
					$("txtNbtAssuredName").value = unescapeHTML2(row.assuredName);
					$("txtLossCategory").value = unescapeHTML2(row.lossCategory);
					$("txtLossDate").value = unescapeHTML2(row.lossDate);
					$("txtClmStatus").value = row.claimStatus; 
					objCLMGlobal.claimId = row.claimId;
					objCLMGlobal.lineCd = row.lineCd;
					enableToolbarButton("btnToolbarExecuteQuery");
					$("txtNbtClmLineCd").readOnly = true;
					$("txtNbtClmSublineCd").readOnly = true;
					$("txtNbtClmIssCd").readOnly = true;
					$("txtNbtClmYy").readOnly = true;
					$("txtNbtClmSeqNo").readOnly = true;
					$("txtNbtLineCd").readOnly = true;
					$("txtNbtSublineCd").readOnly = true;
					$("txtNbtPolIssCd").readOnly = true;
					$("txtNbtIssueYy").readOnly = true;
					$("txtNbtPolSeqNo").readOnly = true;
					$("txtNbtRenewNo").readOnly = true;
					disableSearch("txtNbtClmLineCdIcon");
					disableSearch("txtNbtClmSublineCdIcon");
					disableSearch("txtNbtClmIssCdIcon");
					disableSearch("nbtSearchClmByClmIcon");
					disableSearch("txtNbtLineCdIcon");
					disableSearch("txtNbtSublineCdIcon");
					disableSearch("txtNbtPolIssCdIcon");
					disableSearch("nbtSearchClmByPolIcon");
				}
			},
			onCancel : function(){
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
				$("txtNbtAssuredName").clear();
				$("txtLossCategory").clear();
				$("txtLossDate").clear();
				$("txtClmStatus").clear();
				disableToolbarButton("btnToolbarEnterQuery");
				customShowMessageBox("No record selected", "I",
						$("txtNbtClmLineCd").attr("id"));

			}
		});
		
	}catch(e){
		showErrorMessage("showClmListLov", e);
	}
	
}
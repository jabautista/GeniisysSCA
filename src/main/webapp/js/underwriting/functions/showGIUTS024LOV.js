/**
 * Show policy listing for GIUTS024
 * 
 * @author robert
 * @date 01.05.2012
 */
function showGIUTS024LOV() {
	LOV.show({
		controller : "UnderwritingLOVController",
		urlParameters : {
			action : "getGIUTS024LOV",
			lineCd : $F("txtLineCd"),
			sublineCd : $F("txtSublineCd"),
			issCd : $F("txtIssCd"),
			issueYy : $F("txtIssueYy"),
			polSeqNo : $F("txtPolSeqNo"),
			renewNo : $F("txtRenewNo"),
			notIn : "",
			page : 1
		},
		title : "Policy Listing",
		width : 707,
		height : 411,
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
			id : 'policyId',
			width : '0',
			visible : false
		}, {
			id : 'policyNo',
			title : 'Policy No.',
			width : 290,
			children : [ {
				id : 'lineCd',
				title : 'Line Code',
				width : 40,
				filterOption : true,
				editable : false
			}, {
				id : 'sublineCd',
				title : 'Subline Code',
				width : 60,
				filterOption : true,
				editable : false
			}, {
				id : 'issCd',
				title : 'Issue Code',
				width : 40,
				filterOption : true,
				editable : false
			}, {
				id : 'issueYy',
				title : 'Issue Year',
				type : 'number',
				align : 'right',
				width : 40,
				filterOption : true,
				filterOptionType : 'number',
				renderer : function(value) {
					return formatNumberDigits(value, 2);
				},
				editable : false
			}, {
				id : 'polSeqNo',
				title : 'Pol Sequence No.',
				type : 'number',
				align : 'right',
				width : 70,
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
				width : 40,
				filterOption : true,
				filterOptionType : 'number',
				renderer : function(value) {
					return formatNumberDigits(value, 2);
				},
				editable : false
			} ]
		}, {
			id : 'assdName',
			title : 'Assured Name',
			titleAlign : 'left',
			width : '230px'
		}, {
			id : 'endtNo',
			title : 'Endt No.',
			titleAlign : 'center',
			width : '150px',
			children : [ {
				id : 'endtIssCd',
				title : 'Endt Issue Code',
				width : 40,
				editable : false
			}, {
				id : 'endtYy',
				title : 'Endt Year',
				type : 'number',
				align : 'right',
				width : 40,
				renderer : function(value) {
					return value == "" ? null : formatNumberDigits(value, 2);
				},
				editable : false
			}, {
				id : 'endtSeqNo',
				title : 'Endt Sequence No',
				type : 'number',
				align : 'right',
				width : 70,
				filterOption : true, //added by j.diago 09.17.2014
				filterOptionType : 'number', //added by j.diago 09.17.20
				renderer : function(value) {
					return value == "" ? null : formatNumberDigits(value, 6);
				},
				editable : false
			} ]
		} ],
		draggable : true,
		onSelect : function(row) {
			if (row != undefined) {
				objPolbasic.policyId = unescapeHTML2(row.policyId);
				objPolbasic.policyNo = unescapeHTML2(row.policyNo);
				objPolbasic.endtNo = unescapeHTML2(row.endtNo);
				objPolbasic.assdName = unescapeHTML2(row.assdName);
				objPolbasic.assdNo = unescapeHTML2(row.assdNo);
				objPolbasic.effDate = unescapeHTML2(row.effDate);
				objPolbasic.expiryDate = unescapeHTML2(row.expiryDate);
				objPolbasic.parId = unescapeHTML2(row.parId);
				objPolbasic.lineCd = unescapeHTML2(row.lineCd);
				objPolbasic.sublineCd = unescapeHTML2(row.sublineCd);
				objPolbasic.issCd = unescapeHTML2(row.issCd);
				objPolbasic.issueYy = unescapeHTML2(row.issueYy);
				objPolbasic.polSeqNo = unescapeHTML2(row.polSeqNo);
				objPolbasic.renewNo = unescapeHTML2(row.renewNo);
				showGenBinderNonAffEndtPage(objPolbasic.policyId);
			}
		}
	});
}
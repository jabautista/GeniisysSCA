/**
 * call LOV for Policy Nos.
 * GIPIS171
 * @author msison
 * 12.26.2012
 */
function showPolicyListingForGIPIS171() {
	LOV.show({
		controller: "UnderwritingLOVController",
		urlParameters: {action : "getGIPIS171LOV",
						lineCd : $F("txtPolLineCd"),
					 sublineCd : $F("txtPolSublineCd"),
						 issCd : $F("txtPolIssCd"),
					   issueYy : $F("txtPolIssueYy"),
					  polSeqNo : $F("txtPolSeqNo"),
					   renewNo : $F("txtPolRenewNo"),
					 parLineCd : $F("txtParLineCd"),
				   	  parIssCd : $F("txtParIssCd"),
					     parYy : $F("txtParYy"),
					  parSeqNo : $F("txtParSeqNo"),
				 parQuoteSeqNo : $F("txtParQuoteSeqNo"),
						  page : 1},
		title: "Policy Listing",
		width: 900,
		height: 390,
		hideColumnChildTitle: true,
		filterVersion: "2",
		columnModel: [ 
			{	
				id: 'policyId',
				width: '0',
				visible: false
			},
			{
				id: 'policyNo',
				title: 'Policy No.',
				width : 290,
				children : [
					{	
						id : 'lineCd',
						title: 'Line Code',
						width : 40,
						filterOption: false //changed to false by jeffdojello 04.30.2013 as per SR-12906 Description #1	
					},
					{
						id : 'sublineCd',
						title: 'Subline Code',
						width : 60,
						filterOption: true
					},
					{	
						id : 'issCd',
						title: 'Issue Code',
						width : 40,
						filterOption: true	
					},
					{	
						id : 'issueYy', 
						title: 'Issue Year',
						type: 'number',
						align: 'right',
						width : 40,
						filterOption: true,
						filterOptionType: 'integerNoNegative',
						renderer : function(value){
							return formatNumberDigits(value,2);
						}
					},
					{	
						id : 'polSeqNo',
						title: 'Pol Sequence No.',
						type: 'number',
						align: 'right',
						width : 70,
						filterOption: true,
						filterOptionType: 'integerNoNegative',
						renderer : function(value){
							return formatNumberDigits(value,7);
						}	
					},
					{	
						id : 'renewNo', 
						title: 'Renew No.',
						type: 'number',
						align: 'right',
						width : 40,
						filterOption: true,
						filterOptionType: 'integerNoNegative',
						renderer : function(value){
							return formatNumberDigits(value,2);
						}
					}
					]
			},
			{	
				id: 'endtNo',
				title: 'Endt No.',
				titleAlign: 'center',
				width: '150px',
				children : [
					{	
						id : 'endtIssCd',
						title: 'Endt Issue Code',
						width : 40	
					},
					{	
						id : 'endtYy', 
						title: 'Endt Year',
						type: 'number',
						align: 'right',
						width : 40,
						renderer : function(value){
							return value == "" ? null : formatNumberDigits(value,2);
						}
					},
					{	
						id : 'endtSeqNo', 
						title: 'Endt Sequence No',
						type: 'number',
						align: 'right',
						width : 70,
						renderer : function(value){
							return value == "" ? null : formatNumberDigits(value,6);
						}
					}
					]
			},
			{	
				id: 'assdName',
				title: 'Assured Name',
				titleAlign: 'left',
				width: '230px'
			},
			{	
				id: 'parNo',
				title: 'PAR No.',
				width: '180px',
				children : [
					{	
						id : 'parLineCd',
						title: 'PAR Line Cd',
						filterOption: false, //changed to false by jeffdojello 04.30.2013 as per SR-12906 Description #1
						width : 30
					},
					{
						id : 'parIssCd', 
						title: 'PAR Issue Cd',
						filterOption: true,
						width : 30
					},
					{
						id : 'parYy', 
						title: 'PAR Issue Year',
						filterOption: true,
						type: 'number',
						align: 'right',
						width : 30,
						filterOptionType: 'integerNoNegative',
						renderer : function(value){
							return formatNumberDigits(value,2);
						}
					},
					{	
						id : 'parSeqNo',
						title: 'PAR Sequence No.',
						type: 'number',
						align: 'right',
						width : 60,
						filterOption: true,
						filterOptionType: 'integerNoNegative',
						renderer : function(value){
							return formatNumberDigits(value,6);
						}
					},
					{
						id : 'parQuoteSeqNo',
						title: 'PAR Quote Sequence Number',
						filterOption: true,
						type: 'number',
						align: 'right',
						width : 30,
						filterOptionType: 'integerNoNegative',
						renderer : function(value){
							return formatNumberDigits(value,2);
							}
					}
					]
			}
			],
			draggable: true,
			onCancel: function() {
	  			objGipis171.setToLastValidValue;
			},
			onUndefinedRow: function() {
				showMessageBox("No record selected.", imgMessage.INFO);
				objGipis171.setToLastValidValue;
			},
			//autoSelectOneRecord: true,
			filterText : [/*$F("txtPolLineCd"),*/$F("txtPolIssCd"),$F("txtPolSublineCd"),/*$F("txtPolLineCd"),*/$F("txtParLineCd"),$F("txtParIssCd")],
			onSelect : function(row){
  			objGipis171.loadSelectedRecord(row);
  		}
	});
}
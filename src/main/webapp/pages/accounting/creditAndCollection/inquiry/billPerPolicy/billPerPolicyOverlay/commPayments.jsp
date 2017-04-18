<div id="tableCommPayments" style="padding: 5px; height: 260px;">
	<div id="tableCommPaymentsDiv" style="height: 100%;"></div>
</div>
<div style="width: 100%;" align="center">
	<input type="button" class="button" id="btnReturn" value="Return" tabindex="402" style="width: 100px;"/>
</div>
<script type="text/javascript">
	var jsonCommPayments = JSON.parse('${jsonCommPayments}');
	showCommPaymentsTable();
	
	$("btnReturn").observe("click", function(){
		overlayPayments.close();
		delete overlayPayments;
	});
	
	function showCommPaymentsTable(){
		try {
			commPaymentsTable = {
				//added parameters by robert SR 5254 01.26.2016
				url : contextPath+ "/GIACInquiryController?action=showCommPayments&refresh=1&lineCd="+$F("txtPolLineCd")+"&sublineCd="+$F("txtPolSublineCd")+"&issCd="+$F("txtPolIssCd")+"&issueYy="+$F("txtPolIssueYy")+"&polSeqNo="+$F("txtPolSeqNo")+"&renewNo="+$F("txtPolRenewNo")+"&intmNo="+$F("txtIntmNo") ,
				id: "commPayments",
				options : {
					hideColumnChildTitle : true,
					pager : {},
					onCellFocus : function(element, value, x, y, id) {
						tbgCommPaymentsTable.keys.releaseKeys();
					},
					onRemoveRowFocus : function(element, value, x, y, id) {
						tbgCommPaymentsTable.keys.releaseKeys();
					},
					onSort : function(){
						tbgCommPaymentsTable.keys.releaseKeys();
					},
					postPager : function() {
						tbgCommPaymentsTable.keys.releaseKeys();
					}
				},
				columnModel : [ 
					{
					    id: 'recordStatus',
					    width: '0',
					    visible: false
					},
					{
						id: 'divCtrId',
						width: '0',
						visible: false 
					},
					{
						id : "premSeqNo",
						title : "Bill No",	
						align : "left",
						titleAlign: "left",
						width: "120px",
						filterOption : true,
						filterOptionType: 'number',
						editable : false,
						renderer : function(value) {
					    	return lpad(value,12,0);
					    }
					},
					{
						id : "branchCd",
						title : "Branch",
						align : "left",
						titleAlign: "left",
						width : '50px',
						filterOption : true,
					},
					{
						id : "tranDate",
						title : "Tran Date",
						align : "left",
						titleAlign: "left",
						width : '130px',
						filterOptionType: 'formattedDate',
						filterOption : true,
					},
					{
						id : "refNo",
						title : "Reference No",
						align : "left",
						titleAlign: "left",
						width : '130px',
						filterOption : true,
					},
					{
						id : "commAmt",
						title : "Comm",
						align : "right",
						titleAlign: "right",
						width : '110px',
						filterOptionType: 'number',
						filterOption : true,
						renderer : function(value) {
					    	return formatCurrency(value);
					    }
					},
					{
						id : "wtaxAmt",
						title : "WHTax",
						align : "right",
						titleAlign: "right",
						width : '110px',
						filterOptionType: 'number',
						filterOption : true,
						renderer : function(value) {
					    	return formatCurrency(value);
					    }
					},
					{
						id : "inputVatAmt",
						title : "Input VAT",
						align : "right",
						titleAlign: "right",
						width : '110px',
						filterOptionType: 'number',
						filterOption : true,
						renderer : function(value) {
					    	return formatCurrency(value);
					    }
					},
					{
						id : "netComm",
						title : "Net Comm",
						align : "right",
						titleAlign: "right",
						width : '110px',
						filterOptionType: 'number',
						filterOption : true,
						renderer : function(value) {
					    	return formatCurrency(value);
					    }
					},
				],
				rows : jsonCommPayments.rows || []
			};
			tbgCommPaymentsTable = new MyTableGrid(commPaymentsTable);
			tbgCommPaymentsTable.pager = jsonCommPayments;
			tbgCommPaymentsTable.render('tableCommPaymentsDiv');
		} catch (e) {
			showErrorMessage("commPayments.jsp", e);
		}
	}
	
</script>
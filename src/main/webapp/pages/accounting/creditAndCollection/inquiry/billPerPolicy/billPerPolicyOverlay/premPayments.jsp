<div id="tablePremPayments" style="padding: 5px; height: 260px;">
	<div id="tablePremPaymentsDiv" style="height: 100%;"></div>
</div>
<div style="width: 100%;" align="center">
	<input type="button" class="button" id="btnReturn" value="Return" tabindex="402" style="width: 100px;"/>
</div>
<script type="text/javascript">
	var jsonPremPayments = JSON.parse('${jsonPremPayments}');
	showPremPaymentsTable();
	
	$("btnReturn").observe("click", function(){
		overlayPayments.close();
		delete overlayPayments;
	});
	
	function showPremPaymentsTable(){
		try {
			premPaymentsTable = {
				//added parameters by robert SR 5254 01.26.2016
				url : contextPath+ "/GIACInquiryController?action=showPremPayments&refresh=1&lineCd="+$F("txtPolLineCd")+"&sublineCd="+$F("txtPolSublineCd")+"&issCd="+$F("txtPolIssCd")+"&issueYy="+$F("txtPolIssueYy")+"&polSeqNo="+$F("txtPolSeqNo")+"&renewNo="+$F("txtPolRenewNo")+"&intmNo="+$F("txtIntmNo") ,
				id: "premPayments",
				options : {
					hideColumnChildTitle : true,
					pager : {},
					onCellFocus : function(element, value, x, y, id) {
						tbgPremPaymentsTable.keys.releaseKeys();
					},
					onRemoveRowFocus : function(element, value, x, y, id) {
						tbgPremPaymentsTable.keys.releaseKeys();
					},
					onSort : function(){
						tbgPremPaymentsTable.keys.releaseKeys();
					},
					postPager : function() {
						tbgPremPaymentsTable.keys.releaseKeys();
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
						id : "b140PremSeqNo",
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
						width : '60px',
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
						id : "collectionAmt",
						title : "Amount",
						align : "right",
						titleAlign: "right",
						width : '130px',
						filterOptionType: 'number',
						filterOption : true,
						renderer : function(value) {
					    	return formatCurrency(value);
					    }
					}
				],
				rows : jsonPremPayments.rows || []
			};
			tbgPremPaymentsTable = new MyTableGrid(premPaymentsTable);
			tbgPremPaymentsTable.pager = jsonPremPayments;
			tbgPremPaymentsTable.render('tablePremPaymentsDiv');
		} catch (e) {
			showErrorMessage("premPayments.jsp", e);
		}
	}
	
</script>
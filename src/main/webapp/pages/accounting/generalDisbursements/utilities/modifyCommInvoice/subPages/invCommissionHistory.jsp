<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="contentsDiv" style="width:830px;">
	<div class="sectionDiv" align="center" style="width: 99.5%; margin-top: 2px; padding-top:10px; height:275px;">
		<div id="invCommHistoryTableGridSectionDiv" name="invCommHistoryTableGridSectionDiv" style="padding:0 10px;">
			<div id="invCommHistoryTable" name="invCommHistoryTable" style="height:200px;"></div>
		</div>
		<div align="center" style="width: 99.5%; margin-top: 35px;">
			<input type="button" id="btnReturn" name="btnReturn"  style="width: 140px;" class="button hover" value="Return" />
		</div>
	</div>
</div>
<script>
try {
	var jsonInvCommHistoryList = JSON.parse('${jsonInvCommHistoryList}');
	
	invCommHistoryTableModel = {
		url : contextPath+ "/GIACDisbursementUtilitiesController?action=showInvCommHistoryListing&refresh=1&issCd="+
				$F("txtIssCd")+"&premSeqNo="+$F("txtPremSeqNo"),
		options : {
			width : '805px',
			height : '200px',
			pager : {}
		},
		columnModel : [ 
			{
			    id: 'recordStatus',
			    title: '',
			    width: '0',
			    visible: false
			},
			{
				id: 'divCtrId',
				width: '0',
				visible: false 
			},
			{
				id : "intmNo intmName commissionAmt wholdingTax",
				title : "Previous Commission",
				align: 'left',
				sortable: true,
				children: [
					{
						id : 'intmNo',
						title: 'Intm No',
		                width : 75,
		                editable: false,
		                sortable: false,
		                align: 'left'
					},
					{
						id : 'intmName',
						title: 'Intermediary',
		                width : 200,
		                editable: false,
		                sortable: false,
		                align: 'left'	
					},
					{
						id : 'commissionAmt',
						title: 'Comm',
		                width : 75,
		                editable: false,
		                sortable: false,
		                align: 'right',
		                type : 'number',					
						geniisysClass : 'money'	
					},
					{
						id : 'wholdingTax',
						title: 'WH Tax',
		                width : 75,
		                editable: false,
		                sortable: false,
		                align: 'right',
		                type : 'number',					
						geniisysClass : 'money'
					}
				          ]
			},
			{
				id : "intmNo2 intmName2 commissionAmt2 wholdingTax2",
				title : "New Commission",
				align: 'left',
				sortable: true,
				children: [
					{
						id : 'intmNo2',
						title: 'Intm No',
		                width : 75,
		                editable: false,
		                sortable: false,
		                align: 'left'
					},
					{
						id : 'intmName2',
						title: 'Intermediary',
		                width : 200,
		                editable: false,
		                sortable: false,
		                align: 'left'	
					},
					{
						id : 'commissionAmt2',
						title: 'Comm',
		                width : 75,
		                editable: false,
		                sortable: false,
		                align: 'right',
		                type : 'number',					
						geniisysClass : 'money'	
					},
					{
						id : 'wholdingTax2',
						title: 'WH Tax',
		                width : 75,
		                editable: false,
		                sortable: false,
		                align: 'right',
		                type : 'number',					
						geniisysClass : 'money'
					}
				          ]
			},
			{
				id : "tranFlag2 deleteSw2 postDate2 postedBy2 userId2",
				title : "",
				align: 'left',
				children: [
					{
						id : 'tranFlag2',
						title: 'T',
		                width : 20,
		                editable: false,
		                sortable: false,
		                align: 'left'
					},
					{
						id : 'deleteSw2',
						title: 'D',
		                width : 20,
		                editable: false,
		                sortable: false,
		                align: 'left'	
					},
					{
						id : 'postDate2',
						title: 'Post Date',
		                width : 200,
		                editable: false,
		                sortable: false,
		                align: 'left'	
					},
					{
						id : 'postedBy2',
						title: 'Posted By',
		                width : 100,
		                editable: false,
		                sortable: false,
		                align: 'left'
					},
					{
						id : 'userId2',
						title: 'User Id',
		                width : 100,
		                editable: false,
		                sortable: false,
		                align: 'left'
					}
				          ]
			}
		],
		rows : jsonInvCommHistoryList.rows
	};
	tbgInvCommHistory = new MyTableGrid(invCommHistoryTableModel);
	tbgInvCommHistory.pager = jsonInvCommHistoryList;
	tbgInvCommHistory.render('invCommHistoryTable');
} catch (e) {
	showErrorMessage("invCommHistoryTableModel", e);
}

$("btnReturn").observe("click",function(){
	overlayInvCommHistoryDtl.close();
});

</script>
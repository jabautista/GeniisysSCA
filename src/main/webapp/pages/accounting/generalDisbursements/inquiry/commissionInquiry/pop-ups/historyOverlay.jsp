<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="contentsDiv" style="padding: 10px 5px 5px 5px;">
		<div id="historyTableDiv" style="padding: 10px 10px 10px 10px; width: 850px;" class="sectionDiv">
			<div id="historyTable" style="height: 250px"></div>
		</div>
		<div class="buttonDiv"align="center" style="padding: 295px 0 0 0;">
			<input type="button" id="btnReturn" class="button" value="Return" style="width: 100px;"/>
		</div>
</div>
<script>
	initializeAll();
	var currencyCond = "F";
	if ($F("btnForenCurr") == "Foreign Currency Info") {
		currencyCond = "L";
	}
	try {
		var jsonHistory = JSON.parse('${jsonHistory}');
		historyTableModel = {
			url : contextPath+ "/GIACInquiryController?action=showGiacs221History&refresh=1&issCd=" + $F("txtBillIssCd") + "&premSeqNo=" + $F("txtPremSeqNo") + "&currencyCond=" + currencyCond,
			id : "giacs221History",
			options : {
				height : '250px',
				width : '850px',
				pager : {},
				onCellFocus : function(element, value, x, y, id) {
					tbgHistory.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					tbgHistory.keys.releaseKeys();
				},
				onSort : function(){
					tbgHistory.keys.releaseKeys();
				},
				postPager : function() {
					tbgHistory.keys.releaseKeys();
				}
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
			    	id:'dspIntmName commissionAmt wholdingTax',
			    	title: 'Previous Commission',
			    	width: 360,
			    	titleAlign: 'left',
			    	children: [
			    	   	    {	id: 'dspIntmName',
						    	width: 190,
						    	sortable: false,
						    	title: 'Intermediary'
						    },
						    {	id: 'commissionAmt',
						    	width: 90,
						    	sortable: false,
						    	title: 'Commission',
						    	align: 'right',
						    	titleAlign: 'right',
						    	geniisysClass: "money"
						    },
						    {	id: 'wholdingTax',
						    	width: 90,
						    	align: 'right',
						    	title: 'WHTax',
						    	sortable: false,
						    	titleAlign: 'right',
						    	geniisysClass: "money"
						    }
						]
			    },
			    {
			    	id: 'dspIntmName2 commissionAmt2 wholdingTax2 tranFlag2 deleteSw2 dspPostDate2 postedBy2 userId2',
			    	width: 640,
			    	title: 'New Commission',
			    	titleAlign: 'left',
			    	children: [
						    {	id: 'dspIntmName2',
						    	width: 190,
						    	sortable: false,
						    	title: 'Intermediary'
						    },
						    {	id: 'commissionAmt2',
						    	width: 90,
						    	sortable: false,
						    	title: 'Commission',
						    	align: 'right',
						    	titleAlign: 'right',
						    	geniisysClass: "money"
						    },
						    {	id: 'wholdingTax2',
						    	width: 90,
						    	align: 'right',
						    	title: 'WHTax',
						    	sortable: false,
						    	titleAlign: 'right',
						    	geniisysClass: "money"
						    },
						    {	id: 'tranFlag2',
						    	width: 20,
						    	title: 'T',
						    	sortable: false,
						    },
						    {	id: 'deleteSw2',
						    	width: 20,
						    	title: 'D',
						    	sortable: false,
						    },
						    {	id: 'dspPostDate2',
						    	width: 80,
						    	align: 'center',
						    	title: 'Post Date',
						    	sortable: false,
						    	titleAlign: 'center'
						    },
						    {	id: 'postedBy2',
						    	width: 80,
						    	align: 'center',
						    	title: 'Posted By',
						    	sortable: false,
						    	titleAlign: 'center'
						    },
						    {	id: 'userId2',
						    	width: 80,
						    	title: 'User ID',
						    	sortable: false
						    }
						]
			    },  
			],
			rows : jsonHistory.rows
		};
		tbgHistory = new MyTableGrid(historyTableModel);
		tbgHistory.pager = jsonHistory;
		tbgHistory.render('historyTable');
	} catch (e) {
		showErrorMessage("historyTableModel", e);
	}
	
	$("btnReturn").observe("click",function(){
		overlayHistoryInfo.close();
	});
</script>
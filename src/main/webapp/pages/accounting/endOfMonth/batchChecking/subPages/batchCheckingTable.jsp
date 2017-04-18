<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>
<div id="batchExtractTable" style="margin-top: 15px; margin-left: 10px; margin-bottom:10px; height: 300px;"></div>

<script type="text/javascript">
var column;
var tab = '${table}';
var dateTag = '${dateTag}';
	if (tab == "gross") {
		column = [
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
				id : "lineName",
				title : "Line",
				width : '150px',
				filterOption : true
			},
			{
				id : "glAcctSname",
				title : "Gl Acct Sname",
				width : '295px',
				filterOption : true
			},					
			{
				id : "premAmt",
				title : "UW Data",
				width : '140px',
				align : 'right',
				titleAlign : 'right',
				filterOption : true,
				filterOptionType: 'number',
				geniisysClass: 'money'
			},
			{
				id : "balance",
				title : "Acctg Entries",
				width : '140px',
				align : 'right',
				titleAlign : 'right',
				filterOption : true,
				filterOptionType: 'number',
				geniisysClass: 'money'
			},
			{
				id : "difference",
				title : "Difference",
				width : '140px',
				align : 'right',
				titleAlign : 'right',
				filterOption : true,
				filterOptionType: 'number',
				geniisysClass: 'money'
			}
		];
	}else if (tab == "facul") {
		column = [
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
						id : "lineName",
						title : "Line",
						width : '150px',
						filterOption : true
					},
					{
						id : "glAcctSname",
						title : "Gl Acct Sname",
						width : '295px',
						filterOption : true
					},					
					{
						id : "premAmt",
						title : "Premium Amt",
						width : '140px',
						align : 'right',
						titleAlign : 'right',
						filterOption : true,
						filterOptionType: 'number',
						geniisysClass: 'money'
					},
					{
						id : "balance",
						title : "Acctg Entry",
						width : '140px',
						align : 'right',
						titleAlign : 'right',
						filterOption : true,
						filterOptionType: 'number',
						geniisysClass: 'money'
					},
					{
						id : "difference",
						title : "Difference",
						width : '140px',
						align : 'right',
						titleAlign : 'right',
						filterOption : true,
						filterOptionType: 'number',
						geniisysClass: 'money'
					}
				];
	}else if (tab == "treaty") {
		column = [
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
						id : "lineName",
						title : "Line",
						width : '150px',
						filterOption : true
					},
					{
						id : "glAcctSname",
						title : "Gl Acct Sname",
						width : '295px',
						filterOption : true
					},					
					{
						id : "premAmt",
						title : "UW Records",
						width : '140px',
						align : 'right',
						titleAlign : 'right',
						filterOption : true,
						filterOptionType: 'number',
						geniisysClass: 'money'
					},
					{
						id : "balance",
						title : "Acctg Entries",
						width : '140px',
						align : 'right',
						titleAlign : 'right',
						filterOption : true,
						filterOptionType: 'number',
						geniisysClass: 'money'
					},
					{
						id : "difference",
						title : "Difference",
						width : '140px',
						align : 'right',
						titleAlign : 'right',
						filterOption : true,
						filterOptionType: 'number',
						geniisysClass: 'money'
					}
				];
	}else if(tab == "outstanding" || tab == "paid"){ //marco - 02.26.2015
		column = [
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
						id : "lineName",
						title : "Line Name",
						width : '150px',
						filterOption : true
					},
					{
						id : "glAcctSname",
						title : "Gl Account Name",
						width : '295px',
						filterOption : true
					},					
					{
						id : "brdrxAmt",
						title : "Bordereaux Amt.",
						width : '140px',
						align : 'right',
						titleAlign : 'right',
						filterOption : true,
						filterOptionType: 'number',
						geniisysClass: 'money'
					},
					{
						id : "balance",
						title : "Acctg Entries",
						width : '140px',
						align : 'right',
						titleAlign : 'right',
						filterOption : true,
						filterOptionType: 'number',
						geniisysClass: 'money'
					},
					{
						id : "difference",
						title : "Difference",
						width : '140px',
						align : 'right',
						titleAlign : 'right',
						filterOption : true,
						filterOptionType: 'number',
						geniisysClass: 'money'
					}
				];
	}
	
	
	var objBatchExt = new Object();
	var objCurrLineCd = null;
	var baseAmt = null;
	var objBatchExtMain = [];
	objBatchExt.objBatchExtListing = JSON.parse('${main}');
	objBatchExt.batchExtMainList = objBatchExt.objBatchExtListing.rows || [];
	var tbgMain = {
			url: contextPath+"/GIACBatchCheckController?action=getMainTable&refresh=1&table="+tab+"&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate")+"&dateTag="+dateTag,
		options: {
			width: '900px',
			height: '306px',
			id: 2,
			onCellFocus: function(element, value, x, y, id){
				enableButton("btnDetails");
				objCurrLineCd = batchExtractTableGrid.geniisysRows[y].lineCd;
				baseAmt = batchExtractTableGrid.geniisysRows[y].baseAmt;
				batchExtractTableGrid.keys.removeFocus(batchExtractTableGrid.keys._nCurrentFocus, true);
				batchExtractTableGrid.keys.releaseKeys();
			},
			onRemoveRowFocus: function(){
				disableButton("btnDetails");
				objCurrLineCd = null;
				baseAmt = null;
				batchExtractTableGrid.keys.removeFocus(batchExtractTableGrid.keys._nCurrentFocus, true);
				batchExtractTableGrid.keys.releaseKeys();
	        },
	        onSort: function(){
	        	batchExtractTableGrid.onRemoveRowFocus();
				//batchExtractTableGrid.keys.releaseKeys();
	        },
	        prePager: function(){
	        	batchExtractTableGrid.onRemoveRowFocus();
				//batchExtractTableGrid.keys.releaseKeys();
	        },
			onRefresh: function(){
				batchExtractTableGrid.onRemoveRowFocus();
				//batchExtractTableGrid.keys.releaseKeys();
			},
			/* onRowDoubleClick: function(y){							
				showBatchCheckingDetail();
				batchExtractTableGrid.keys.releaseKeys();
				batchExtractTableGrid.keys.removeFocus(batchExtractTableGrid.keys._nCurrentFocus, true);
			}, */
			toolbar: {
				elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
				onFilter: function(){
					batchExtractTableGrid.onRemoveRowFocus();
					//batchExtractTableGrid.keys.releaseKeys();
				}
			}
		},
		columnModel: column,
		rows: objBatchExt.batchExtMainList
	};
	batchExtractTableGrid = new MyTableGrid(tbgMain);
	batchExtractTableGrid.pager = objBatchExt.objBatchExtListing;
	batchExtractTableGrid.render("batchExtractTable");
	batchExtractTableGrid.afterRender = function(y) {
		batchExtractTableGrid.onRemoveRowFocus();
		if (batchExtractTableGrid.geniisysRows.length != 0) {
			//getTotalAmount();
			$("txtTotalPrem").value = formatCurrency(batchExtractTableGrid.geniisysRows[0].premAmtTotal);
			$("txtTotalBal").value = formatCurrency(batchExtractTableGrid.geniisysRows[0].balanceTotal);
			$("txtTotalDiff").value = formatCurrency(batchExtractTableGrid.geniisysRows[0].differenceTotal);
		}
	};
	
	function getTotalAmount() {
		new Ajax.Request(contextPath+"/GIACBatchCheckController",{
			parameters: {
				action: "getTotal",
				table: tab,
				fromDate: $F("txtFromDate"),
				toDate: $F("txtToDate"),
				dateTag: dateTag
			},
			method: "POST",
			onComplete : function (response){
				if(checkErrorOnResponse(response)){
					tempArray = [];
					tempArray = JSON.parse(response.responseText);
					for ( var b = 0; b < tempArray.rec.length; b++) {
						$("txtTotalPrem").value  = formatCurrency(parseFloat(nvl(tempArray.rec[b]['premAmtTotal'], "0")));
						$("txtTotalBal").value = formatCurrency(parseFloat(nvl(tempArray.rec[b]['balanceTotal'], "0")));
						$("txtTotalDiff").value  = formatCurrency(parseFloat(nvl(tempArray.rec[b]['differenceTotal'], "0")));
					}
				}
			}							 
		});	
	}
	
	function showBatchCheckingDetail() {
		try {
			overlayBatchCheckingDetail = Overlay.show(contextPath + "/GIACBatchCheckController", {
				urlContent : true,
				urlParameters : {
					action : "getDetail",
					table: tab,
					lineCd: objCurrLineCd,
					baseAmt: baseAmt
				},
				title : "Detail",
				height : '404px',
				width : '843px',
				draggable : true,
				showNotice: true
			});	
		} catch(e) {
			showErrorMessage(e);
		}
	}
	
	function checkDetails(){
		new Ajax.Request(contextPath+"/GIACBatchCheckController",{
			parameters: {
				action: "checkDetails",
				lineCd: objCurrLineCd,
				baseAmt: baseAmt,
				table: tab
			},
			method: "POST",
			onComplete : function (response){
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					showBatchCheckingDetail();
				}
			}							 
		});	
	}
	
	$("btnDetails").stopObserving("click");
	$("btnDetails").observe("click", function(){
		checkDetails();
	});
	
</script>
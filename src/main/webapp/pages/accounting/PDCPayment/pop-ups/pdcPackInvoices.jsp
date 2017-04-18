<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
    <%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div >
	<input type="hidden" id="packLineCd" value="${packLineCd}" />
	<input type="hidden" id="packSublineCd" value="${packSublineCd}" />
	<input type="hidden" id="packIssCd" value="${packIssCd}" />
	<input type="hidden" id="packIssueYy" value="${packIssueYy}" />
	<input type="hidden" id="packPolSeqNo" value="${packPolSeqNo}" />
	<input type="hidden" id="packRenewNo" value="${packRenewNo}" />
	<input type="hidden" id="packCheckDue" value="${packCheckDue}" />
	<div style="margin-top: 5px; width: 99.5%;" class="sectionDiv">
		<div id="billInvoiceListingDiv" style="height: 250px; width: 96%; margin: 10px; margin-top: 10px; margin-bottom: 5px;"></div>
	</div>
	<div id="divB"  class="buttonsDiv" style="margin-top: 10px; margin-bottom: 0px;">
		<input type="button" id="btnDcOk" class="button" value="Ok" style="width: 80px;" />
		<input type="button" id="btnDcCancel" class="button" value="Cancel" style="width: 80px;" />
	</div>
</div>
<script type="text/JavaScript">
	objAC.objInvoiceListingTableGrid = JSON.parse('${packInvoicesTG}');
	var curr = null;
	var objInvoiceRows = [];
	var objCheckedRows = [];
	
	var invoiceTableModel = {
		url: contextPath+"/GIACPdcPremCollnController?action=getPackInvoices&ajax=1&refresh=1&lineCd="+$F("packLineCd")+"&sublineCd="+$F("packSublineCd")+
			 "&issCd="+$F("packIssCd")+"&issueYy="+$F("packIssueYy")+"&polSeqNo="+$F("packPolSeqNo")+"&renewNo="+$F("packRenewNo")+"&checkDue=" +$F("packCheckDue"),
		options:{
			toolbar:{
				elements : [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
				onRefresh : function() {
					clearCheckedRows();
					tbgInvoice.keys.removeFocus(tbgInvoice.keys._nCurrentFocus, true);
					tbgInvoice.keys.releaseKeys();
				}
			},
			pager: {},
			validateChangesOnPrePager : false,
			onCellFocus : function(element, value, x, y, id) {
				curr = Number(y);
			},			
			onRemoveRowFocus : function(element, value, x, y, id){
				curr = null;
				tbgInvoice.keys.releaseKeys();
			},
			onSort : function(){
				tbgInvoice.keys.removeFocus(tbgInvoice.keys._nCurrentFocus, true);
				tbgInvoice.keys.releaseKeys();
			},
			onRefresh : function(){
				clearCheckedRows();
				tbgInvoice.keys.removeFocus(tbgInvoice.keys._nCurrentFocus, true);
				tbgInvoice.keys.releaseKeys();
			}
		},
		columnModel: [
			{	id: 'recordStatus',
			    title: '',
			    width: '0',
			    visible: false
			},
			{	id: 'divCtrId',
				width: '0',
				visible: false 
			},
			{
				id: 'processTag',
			    title : '',
			    altTitle: '',
	            width: '40px',
	            align: 'center',
			    sortable: false,
		   		editable: true,
			    hideSelectAllBox: true,
			    editor: new MyTableGrid.CellCheckbox({
			    	 getValueOf: function(value){
	            		if (value){
							return "Y";
	            		}else{
							return "N";	
	            		}	
	            	},
	            	onClick: function(value, checked){
	            		tbgInvoice.keys.releaseKeys();
	            		whenCheckBoxChanged(checked);
	            	}
	            })
			},
			{   id: 'lineCd',
	            title: 'Line',
	            width: '58px',
	            editable: false,
	            filterOption: true	            
			},
			{   id: 'sublineCd',
	            title: 'Subline',
	            width: '63px',
	            editable: false,
	            filterOption: true	            
			},
			{   id: 'issCd',
	            title: 'IssCd',
	            width: '58px',
	            editable: false,
	            filterOption: true	            
			},
			{   id: 'premSeqNo',
	            title: 'PremSeq',
	            width: '93px',
	            align: 'right',
	            editable: false,
	            filterOption: true	            
			},
			{   id: 'instNo',
	            title: 'Inst',
	            width: '58px',
	            align: 'right',
	            editable: false,
	            filterOption: true	            
			},
			{	id: 'collnAmt',
				title: 'Amount',
              	width: '115px' ,
              	align: 'right',
              	type: 'number',
              	editable: false,
              	filterOption: true,
				geniisysClass : 'money',
              	titleAlign: 'right',
              	filterOptionType: 'number'
          	}
		],
		rows: objAC.objInvoiceListingTableGrid.rows || []
	};
	
	tbgInvoice = new MyTableGrid(invoiceTableModel);
	tbgInvoice.pager = objAC.objInvoiceListingTableGrid;
	tbgInvoice.render('billInvoiceListingDiv');
	tbgInvoice.afterRender = function(){
		objInvoiceRows = tbgInvoice.geniisysRows;
		
		for(var i=0; i<objCheckedRows.length; i++){
			for(var j = 0; j < objInvoiceRows.length; j++){
				if(objCheckedRows[i].issCd == objInvoiceRows[j].issCd && 
				   objCheckedRows[i].premSeqNo == objInvoiceRows[j].premSeqNo && 
				   objCheckedRows[i].instNo == objInvoiceRows[j].instNo){
					$("mtgInput"+tbgInvoice._mtgId+"_"+tbgInvoice.getColumnIndex('processTag')+','+j).checked = true;
				}
			}
		}
	};
	
	function whenCheckBoxChanged(checked){
		if(checked){
			objInvoiceRows[curr].recordStatus = 1;
			objCheckedRows.push(objInvoiceRows[curr]);
		}else{
			for (var i=0; i<objCheckedRows.length; i++){
				if (objCheckedRows[i].issCd == objInvoiceRows[curr].issCd && 
					objCheckedRows[i].premSeqNo == objInvoiceRows[curr].premSeqNo && 
				    objCheckedRows[i].instNo == objInvoiceRows[curr].instNo) {
					objCheckedRows.splice(i, 1);
				}
			}
		}
	}
		
	function clearCheckedRows(){
		for (var i=0; i<objCheckedRows.length; i++){
			for ( var j = 0; j < objInvoiceRows.length; j++) {
				if (objCheckedRows[i].issCd == objInvoiceRows[j].issCd && 
					objCheckedRows[i].premSeqNo == objInvoiceRows[j].premSeqNo && 
					objCheckedRows[i].instNo == objInvoiceRows[j].instNo){
					$("mtgInput"+tbgInvoice._mtgId+"_"+tbgInvoice.getColumnIndex('processTag')+','+j).checked = false;
				}
			}
		}
		
		objCheckedRows = [];
	}
	
	function checkPackExists(polInv){
		var rows = postDatedCheckDetailsTableGrid.geniisysRows;
		for(var i=0; i<rows.length; i++){
			if(rows[i].issCd == polInv.issCd && rows[i].premSeqNo == polInv.premSeqNo && rows[i].instNo == polInv.instNo && nvl(rows[i].recordStatus, 0) != -1){
				return true;
			}
		}
		return false;
	}
	
	function computeTotalAmt(){	
		var total = 0;
		
		for (var i=0; i<postDatedCheckDetailsTableGrid.geniisysRows.length; i++){
			if(postDatedCheckDetailsTableGrid.geniisysRows[i].recordStatus != -1){
				var val = postDatedCheckDetailsTableGrid.geniisysRows[i].collnAmt;
				total += parseFloat(val.replace(/,/g, ''));
			}			
		}
		$("txtTotalCollectionAmt").value = formatCurrency(total);
	}
	
	function closePackInvoices(){
		tbgInvoice.keys.removeFocus(tbgInvoice.keys._nCurrentFocus, true);
		tbgInvoice.keys.releaseKeys();
		giacs090PackInvoicesOverlay.close();
		delete giacs090PackInvoicesOverlay;
	}
	
	$("btnDcOk").observe("click", function(){
		if(giacPdcPremCollns.rows == undefined){
			giacPdcPremCollns.rows = [];
		}
		
		for(var i=0; i<objCheckedRows.length; i++){
			if(!checkPackExists(objCheckedRows[i])){
				objCheckedRows[i].recordStatus = 1;
				objCheckedRows[i].pdcId = objCurrGIACApdcPaytDtl.pdcId == "" || objCurrGIACApdcPaytDtl.pdcId == null ? null : objCurrGIACApdcPaytDtl.pdcId;
				giacPdcPremCollns.rows.push(objCheckedRows[i]);
				postDatedCheckDetailsTableGrid.addBottomRow(objCheckedRows[i]);
			}
		}
		
		closePackInvoices();
		computeTotalAmt();
		objGIACApdcPayt.pdcPremChangeTag = 1;
		objGIACApdcPayt.enableDisablePostDatedCheckForm();	
	});
	
	$("btnDcCancel").observe("click", function(){
		closePackInvoices();
	});
	
</script>
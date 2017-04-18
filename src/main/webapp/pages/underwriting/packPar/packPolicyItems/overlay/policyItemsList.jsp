<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>

<div id="policyItemsListingMainDiv" name="policyItemsListingMainDiv" style="margin: 10px 0;">
	<div id="policyItemsTableGridDiv" align="center">
		<div id="policyItemsGridDiv" style="height: 330px;">
			<div id="policyItemsTableGrid" style="height: 306px; width: 600px;"></div>
		</div>
		<div align="center" style="margin-top: 15px;">
			<input type="button" id="btnReturn"    	  name="btnReturn"    		style="width: 90px;" class="button hover"   value="Return" />
		</div>
	</div>
</div>

<script type="text/javascript">

	var selectedRecord = null;

	try{
		var objPolItems = new Object();
		objPolItems.objPolItemsListTableGrid = JSON.parse('${polItemsTableGrid}'.replace(/\\/g, '\\\\'));
		objPolItems.objPolItemsList = objPolItems.objPolItemsListTableGrid.rows || [];

		var parameters = "&lineCd="+objUWGlobal.lineCd+"&issCd="+objGIPIWPolbas.issCd +"&sublineCd="+objGIPIWPolbas.sublineCd+
    					 "&issueYy=" +objGIPIWPolbas.issueYy+"&polSeqNo="+objGIPIWPolbas.polSeqNo+"&renewNo="+objGIPIWPolbas.renewNo+
    					 "&effDate="+objGIPIWPolbas.effDate+"&expiryDate="+objGIPIWPolbas.expiryDate;

    	var polItemsTableModel = {
			url: contextPath+"/GIPIWItemController?action=getPackPolicyItemsList&refresh=1"+parameters,
			options:{
				title: '',
				width: '600px',
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN]
				},
				onCellFocus: function(element, value, x, y, id){
					selectedRecord = polItemsTableGrid.geniisysRows[y];
				},
				onRemoveRowFocus : function(){
					selectedRecord = null;				  		
			  	},
				onRowDoubleClick: function(y){
					selectedRecord = polItemsTableGrid.geniisysRows[y];
					onSelectPolItemRecord(selectedRecord);
				}				
			},
			columnModel: [
				{   id: 'recordStatus',
				    title: '',
				    width: '0',
				    visible: false,
				    editor: 'checkbox' 			
				},
				{	id: 'divCtrId',
					width: '0',
					visible: false
				},
				{ 	id: 'itemNo',
					title : 'Item No.',
					width : '60px'
				},
				{ 	id: 'itemTitle',
					title : 'Item Title',
					width : '350px'
				},
				{	id: 'packLineCd',
					title: 'Line',
					width: '75px',
					filterOption: true
				},
				{	id: 'packSublineCd',
					title: 'Subline',
					width: '100px',
					filterOption: true
				}	
			],
			requiredColumns: 'itemNo itemTitle',
			rows: objPolItems.objPolItemsList
		};

		polItemsTableGrid = new MyTableGrid(polItemsTableModel);
		polItemsTableGrid.pager = objPolItems.objPolItemsListTableGrid;
		polItemsTableGrid.render('policyItemsTableGrid');

	}catch(e){
		showErrorMessage("Policy Items List", e);
	}

	$("btnReturn").observe("click", function(){
		fireEvent($("modal_dialog_polItems_close"), "click");
	});

	function onSelectPolItemRecord(obj){
		($$("div#itemTable div[name='row']")).invoke("removeClassName", "selectedRow");
		setMainItemForm(null);
		validateItemNo(obj.itemNo);
		fireEvent($("modal_dialog_polItems_close"), "click");
	}

</script>
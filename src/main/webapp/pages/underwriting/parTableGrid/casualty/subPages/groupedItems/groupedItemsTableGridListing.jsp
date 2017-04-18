<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="groupedItemsTable" name="groupedItemsTable" style="width : 100%;">
	<div id="groupedItemsTableGridSectionDiv" class="">
		<div id="groupedItemsTableGridDiv" style="padding: 10px;">
			<div id="groupedItemsTableGrid" style="height: 206px; width: 900px;"></div>
		</div>
		<div class="rightAligned" style="margin-bottom: 10px;">
			Total Amount Covered : 
			<input tabindex="4000" id="txtTotalAmountCoveredGroupedItems" name="txtTotalAmountCoveredGroupedItems" class="rightAligned" type="text" style="width: 150px; margin-right: 10px;" readonly="readonly" />			
		</div>
	</div>	
</div>
<script type="text/javascript">
try{
	var objGrpItems = JSON.parse('${tgGroupedItems}');
	
	var tbGrpItems = {
		url : contextPath + "/GIPIWGroupedItemsController?action=refreshGroupedItemsTable&parId=" + objUWParList.parId + "&itemNo=" + $F("itemNo"),
		options : {
			width : '900px',
			masterDetail : true,
			pager : {},
			onCellFocus : function(element, value, x, y, id){
				var objSelected = tbgGroupedItems.geniisysRows[y];
				
				tbgGroupedItems.keys.releaseKeys();
				setGroupedItemsFormTG(objSelected);
			},
			onRemoveRowFocus : function(){
				setGroupedItemsFormTG(null);
				tbgGroupedItems.keys.releaseKeys();
			},
			masterDetailValidation : function(){
				if(getAddedAndModifiedJSONObjects(objGIPIWGroupedItems).length > 0 || getDeletedJSONObjects(objGIPIWGroupedItems).length > 0){
					return true;
				}else{
					return false;
				}
			},
			masterDetailSaveFunc : function(){
				$("btnSave").click();
			},
			masterDetailNoFunc : function(){				
				objGIPIWGroupedItems = objItemTempStorage.objGIPIWGroupedItems.slice(0);
				setGroupedItemsFormTG(null);
			},
			toolbar : {
				elements : [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
			}
		},
		columnModel : [
			{
				id : 'recordStatus',
				width : '20px',
				editor : 'checkbox',
				visible : false
			},
			{
				id : 'divCtrId',
				width : '0px',
				visible : false
			},
			{
				id : 'parId',
				width : '0px',
				visible : false
			},
			{
				id : 'itemNo',
				width : '0px',
				visible : false
			},
			{
				id : 'groupedItemNo',
				width : '100px',
				title : 'Grouped Item No.',
				align : 'right',
				sortable : true,		
				renderer : function(value){
					return lpad(value.toString(), 9, "0");
           		}
			},
			{
				id : 'groupedItemTitle',
				width : '300px',
				title : 'Grouped Item Title',
				sortable : true,
				filterOption : true
			},
			{
				id : 'remarks',
				width : '300px',
				title : 'Remarks',
				sortable : true,
				filterOption : true,
				renderer: function(value) {		//added by Gzelle 02262015
					return unescapeHTML2(value);	
				}					
			},
			{
				id : 'amountCovered',
				width : '150px',
				title : 'Amount Covered',
				type : 'number',
				geniisysClass : 'money'
			}
		               ],
		rows : objGrpItems.rows,
		id : 6
	};
	
	tbgGroupedItems = new MyTableGrid(tbGrpItems);
	tbgGroupedItems.pager = objGrpItems;
	tbgGroupedItems._mtgId = 6;
	tbgGroupedItems.render('groupedItemsTableGrid');
	tbgGroupedItems.afterRender = function(){
		setGroupedItemsFormTG(null);
		tbgGroupedItems.keys.releaseKeys();
	};
}catch(e){
	showErrorMessage("Grouped Items Listing", e);
}
</script>
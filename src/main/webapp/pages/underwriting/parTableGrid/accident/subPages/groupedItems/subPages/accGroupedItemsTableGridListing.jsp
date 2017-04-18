<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="accGroupedItemsTable" name="accGroupedItemsTable" style="width : 100%;">
	<div id="accGroupedItemsTableGridSectionDiv" class="">
		<div id="accGroupedItemsTableGridDiv" style="padding: 10px;">
			<div id="accGroupedItemsTableGrid" style="height: 198px; width: 872px;"></div>
		</div>
	</div>	
</div>
<script type="text/javascript">
try{
	var objGrpItems = JSON.parse('${accGroupedItemsTableGrid}');
	var parId = (objUWGlobal.packParId != null ? objCurrPackPar.parId : objUWParList.parId);
	objGIPIWGroupedItems.selectedItem = null;
	objGIPIWGroupedItems.coverageUpdated = null;
	
	var tbGrpItems = {
		url : contextPath + "/GIPIWGroupedItemsController?action=refreshGroupedItemsTable&parId=" + parId + "&itemNo=" + $F("itemNo"),
		options : {
			width : '855px',
			masterDetail : true,
			pager : {},
			onCellFocus : function(element, value, x, y, id){
				var objSelected = tbgGroupedItems.geniisysRows[y];
				
				tbgGroupedItems.keys.releaseKeys();
				setACGroupedItemFormTG(objSelected);
				objGIPIWGroupedItems.selectedItem = objSelected;
				objGIPIWGroupedItems.selectedIndex = y;
				// retrieve child records				
				retrieveItmperlGrouped(objCurrItem.parId, $F("itemNo"), $F("groupedItemNo"), nvl($F("grpFromDate"),nvl($F("itemFromDate"), dateFormat($F("globalInceptDate"),'mm-dd-yyyy'))),nvl($F("grpToDate"),nvl($F("itemToDate"),dateFormat($F("globalExpiryDate"),'mm-dd-yyyy'))));
				retrieveGrpItemsBeneficiaries(objCurrItem.parId, $F("itemNo"), $F("groupedItemNo"));
				retrieveItmperlBeneficiaries(objSelected.parId, objSelected.itemNo, objSelected.groupedItemNo, 0);
			},
			onRemoveRowFocus : function(){
				setACGroupedItemFormTG(null);
				tbgGroupedItems.keys.releaseKeys();
				
				objGIPIWGroupedItems.selectedItem = null;
				objGIPIWGroupedItems.selectedIndex = null;
				// clear related table grid
				deleteParItemTG(tbgItmperlGrouped);
				deleteParItemTG(tbgGrpItemsBeneficiary);
				deleteParItemTG(tbgItmperlBeneficiary);
				
				// clear related table form fields
				setItmperlGroupedFormTG(null);				
				setGrpItemBeneficiaryFormTG(null);
				setItmperlBeneficiaryFormTG(null);
			},
			masterDetailValidation : function(){
				if(getAddedAndModifiedJSONObjects(objGIPIWGroupedItems).length > 0 || getDeletedJSONObjects(objGIPIWGroupedItems).length > 0){
					return true;
				}else{
					return false;
				}
			},
			masterDetailSaveFunc : function(){
				//$("btnSave").click();
			},
			masterDetailNoFunc : function(){				
				objGIPIWGroupedItems = objItemTempStorage.objGIPIWGroupedItems.slice(0);
				setACGroupedItemFormTG(null);
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
				width : '85px',
				title : 'Enrollee Code',
				align : 'right',
				sortable : true,		
				renderer : function(value){
					return lpad(value.toString(), 9, "0");
           		}
			},
			{
				id : 'groupedItemTitle',
				width : '110px',
				title : 'Enrollee Name',
				sortable : true,
				filterOption : true
			},
			{
				id : 'principalCd',
				width : '85px',
				title : 'Principal Code',
				sortable : true,
				renderer : function(value){
					return value == "" ? "" : lpad(value.toString(), 5, "0");
           		}
			},
			{
				id : 'packageCd',
				width : '100px',
				title : 'Plan',
				sortable : true
			},			
			{
				id : 'paytTermsDesc',
				width : '90px',
				title : 'Payment Mode',
				sortable : true,
				filterOption : true
			},
			{
				id : 'fromDate',
				width : '70px',
				title : 'Effectivity',
				renderer : function(value){
					var dateformatting = /^\d{1,2}(\-)\d{1,2}\1\d{4}$/; // format : mm-dd-yyyy
					 
					if((value != null && value != undefined && value != "") && !(dateformatting.test(value))){			 
						return dateFormat(value, "mm-dd-yyyy");
					}else{
						return value;
					}
				}
			},
			{
				id : 'toDate',
				width : '70px',
				title : 'Expiry',
				renderer : function(value){
					var dateformatting = /^\d{1,2}(\-)\d{1,2}\1\d{4}$/; // format : mm-dd-yyyy
					 
					if((value != null && value != undefined && value != "") && !(dateformatting.test(value))){			 
						return dateFormat(value, "mm-dd-yyyy");
					}else{
						return value;
					}
				}
			},
			{
				id : 'tsiAmt',
				width : '100px',
				title : 'TSI Amount',
				type : 'number',
				geniisysClass : 'money'
			},
			{
				id : 'premAmt',
				width : '100px',
				title : 'Prem Amount',
				type : 'number',
				geniisysClass : 'money'
			}
		               ],
		rows : objGrpItems.rows,
		id : 11
	};
	
	tbgGroupedItems = new MyTableGrid(tbGrpItems);
	tbgGroupedItems.pager = objGrpItems;
	tbgGroupedItems._mtgId = 11;
	tbgGroupedItems.render('accGroupedItemsTableGrid');
	tbgGroupedItems.afterRender = function(){
		//objGIPIWGroupedItems = objGrpItems.gipiWGroupedItems.slice(0);
		objGIPIWGroupedItems = tbgGroupedItems.pager.gipiWGroupedItems; // apollo cruz 04.20.2015 - to get gipiWGroupedItems even on refresh
		objGIPIWItmperlGrouped = objGrpItems.gipiWItmperlGrouped.slice(0);
		objGIPIWGrpItemsBeneficiary = objGrpItems.gipiWGrpItemsBeneficiary.slice(0);
		objGIPIWItmperlBeneficiary = objGrpItems.gipiWItmperlBeneficiary.slice(0);
		
		objItemTempStorage.objGIPIWGroupedItems = objGrpItems.gipiWGroupedItems.slice(0);
		objItemTempStorage.objGIPIWItmperlGrouped = objGrpItems.gipiWItmperlGrouped.slice(0);
		objItemTempStorage.objGIPIWGrpItemsBeneficiary = objGrpItems.gipiWGrpItemsBeneficiary.slice(0);
		objItemTempStorage.objGIPIWItmperlBeneficiary = objGrpItems.gipiWItmperlBeneficiary.slice(0);
		
		setACGroupedItemFormTG(null);
		tbgGroupedItems.keys.releaseKeys();
	};
}catch(e){
	showErrorMessage("Accident Grouped Items Listing", e);
}
</script>
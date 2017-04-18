<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="grpItemsBenPerilsTable" name="grpItemsBeneficiaryTable" style="width : 100%;">
	<div id="grpItemsBenPerilsTableGridSectionDiv" class="">
		<div id="grpItemsBenPerilsTableGridDiv" style="padding: 10px;">
			<div id="grpItemsBenPerilsTableGrid" style="height: 198px; width: 500px; margin: auto;"></div>
		</div>
	</div>	
</div>
<script type="text/javascript">
try{
	var objItmperlBens = JSON.parse('${itmperlBeneficiaries}');
	var parId = (objUWGlobal.packParId != null ? objCurrPackPar.parId : objUWParList.parId);
	
	var tbItmPerlBens = {
		url : contextPath + "/GIPIWItmperlBeneficiaryController?action=getItmperlBeneficiaryTableGrid&parId=" + parId + 
				"&itemNo=" + $F("itemNo") + "&groupedItemNo=" + $F("groupedItemNo") + "&beneficiaryNo=" + $F("bBeneficiaryNo")+ "&refresh=1",
		options : {
			width : '495px',
			masterDetail : true,
			pager : {},
			onCellFocus : function(element, value, x, y, id){
				var objSelected = tbgItmperlBeneficiary.geniisysRows[y];
				
				tbgItmperlBeneficiary.keys.releaseKeys();
				setItmperlBeneficiaryFormTG(objSelected);
			},
			onRemoveRowFocus : function(){
				setItmperlBeneficiaryFormTG(null);
				tbgItmperlBeneficiary.keys.releaseKeys();
			},
			masterDetailValidation : function(){
				if(getAddedAndModifiedJSONObjects(objGIPIWItmperlBeneficiary).length > 0 || getDeletedJSONObjects(objGIPIWItmperlBeneficiary).length > 0){
					return true;
				}else{
					return false;
				}
			},
			masterDetailSaveFunc : function(){
				//$("btnSave").click();
			},
			masterDetailNoFunc : function(){
				objGIPIWItmperlBeneficiary = objItmperlBens.gipiWItmperlBeneficiary.slice(0);
				setItmperlBeneficiaryFormTG(null);
			},
			toolbar : {
				elements : [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN]
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
				width : '0px',
				visible : false
			},
			{
				id : 'beneficiaryNo',
				width : '0px',
				visible : false
			},
			{
				id : 'perilName',
				width : '300px',
				title : 'Peril Name',
				sortable : true,
				filterOption : true
			},
			{
				id : 'tsiAmt',
				width : '150px',
				title : 'TSI Amount',
				geniisysClass : 'money',
				align : 'right',
				sortable : true
			}
		               ],
		rows : objItmperlBens.rows,
		id : 14
	};
	
	tbgItmperlBeneficiary = new MyTableGrid(tbItmPerlBens);
	tbgItmperlBeneficiary.pager = objItmperlBens;
	tbgItmperlBeneficiary._mtgId = 14;
	tbgItmperlBeneficiary.render('grpItemsBenPerilsTableGrid');
	tbgItmperlBeneficiary.afterRender = function(){
		//objGIPIWItmperlBeneficiary = objItmperlBens.gipiWItmperlBeneficiary.slice(0);	
		//objItemTempStorage.objGIPIWItmperlBeneficiary = objItmperlBens.gipiWItmperlBeneficiary.slice(0);
		
		setItmperlBeneficiaryFormTG(null);
		tbgItmperlBeneficiary.keys.releaseKeys();
	};
}catch(e){
	showErrorMessage("Accident Grouped Items Beneficiary Peril Listing", e);
}
</script>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="beneficiaryTable" name="beneficiaryTable" style="width : 100%;">
	<div id="beneficiaryTableGridSectionDiv" class="">
		<div id="beneficiaryTableGridDiv" style="padding: 10px;">
			<div id="beneficiaryTableGrid" style="height: 198px; width: 900px;"></div>
		</div>
	</div>	
</div>
<script type="text/javascript">
try{
	var objBens = JSON.parse('${tgBeneficiaries}');
	var parId = (objUWGlobal.packParId != null ? objCurrPackPar.parId : objUWParList.parId);
	
	var tbBens = {
		url : contextPath + "/GIPIWBeneficiaryController?action=getGIPIWBeneficiaryTableGrid&parId=" + parId + "&itemNo=" + $F("itemNo") + "&refresh=1",
		options : {
			width : '900px',
			masterDetail : true,
			pager : {},
			onCellFocus : function(element, value, x, y, id){
				var objSelected = tbgBeneficiary.geniisysRows[y];
				
				tbgBeneficiary.keys.releaseKeys();
				setBenFormTG(objSelected);
			},
			onRemoveRowFocus : function(){
				setBenFormTG(null);
				tbgBeneficiary.keys.releaseKeys();
			},
			masterDetailValidation : function(){
				if(getAddedAndModifiedJSONObjects(objBeneficiaries).length > 0 || getDeletedJSONObjects(objBeneficiaries).length > 0){
					return true;
				}else{
					return false;
				}
			},
			masterDetailSaveFunc : function(){
				$("btnSave").click();
			},
			masterDetailNoFunc : function(){
				objBeneficiaries = objItemTempStorage.objGIPIWBeneficiary.slice(0);
				setBenFormTG(null);
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
				id : 'beneficiaryNo',
				width : '40px',
				title : 'No.',
				type : 'number',
				align : 'right',
				sortable : true,
				renderer : function(value){
					return lpad(value.toString(), 5, "0");
				}
			},
			{
				id : 'beneficiaryName',
				width : '200px',
				title : 'Name',
				sortable : true,
				filterOption : true
			},
			{
				id : 'beneficiaryAddr',
				width : '200px',
				title : 'Address',
				sortable : true,
				filterOption : true
			},
			{
				id : 'dateOfBirth',
				width : '70px',
				title : 'Birthday',
				sortable : true,
				renderer : function(value){
					var dateformatting = /^\d{1,2}(\-)\d{1,2}\1\d{4}$/; // format : mm-dd-yyyy
					 
					if(((value != null && value != undefined) && value != "") && !(dateformatting.test(value))){			 
						return dateFormat(value, "mm-dd-yyyy");
					}else{
						return value;
					}
				}
			},
			{
				id : 'age',
				width : '35px',
				title : 'Age',
				type : 'number',
				sortable : true
			},
			{
				id : 'relation',
				width : '100px',
				title : 'Relation',
				sortable : true
			},
			{
				id : 'remarks',
				width : '200px',
				title : 'Remarks',
				sortable : true,
				filterOption : true
			}
		               ],
		rows : objBens.rows,
		id : 6
	};
	
	tbgBeneficiary = new MyTableGrid(tbBens);
	tbgBeneficiary.pager = objBens;
	tbgBeneficiary._mtgId = 6;
	tbgBeneficiary.render('beneficiaryTableGrid');
	tbgBeneficiary.afterRender = function(){
		setBenFormTG(null);
		tbgBeneficiary.keys.releaseKeys();
	};
}catch(e){
	showErrorMessage("Beneficiary Listing", e);
}
</script>
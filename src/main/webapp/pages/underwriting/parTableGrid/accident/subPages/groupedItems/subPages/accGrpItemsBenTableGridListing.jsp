<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="grpItemsBeneficiaryTable" name="grpItemsBeneficiaryTable" style="width : 100%;">
	<div id="grpItemsBeneficiaryTableGridSectionDiv" class="">
		<div id="grpItemsBeneficiaryTableGridDiv" style="padding: 10px;">
			<div id="grpItemsBeneficiaryTableGrid" style="height: 198px; width: 860px;"></div>
		</div>
	</div>	
</div>

<script>
try{
	var objGroupedItemsBens = JSON.parse('${groupedItemsBenificiary}');
	var parId = (objUWGlobal.packParId != null ? objCurrPackPar.parId : objUWParList.parId);
	
	var tbBens = {
		url : contextPath + "/GIPIWGrpItemsBeneficiaryController?action=getGrpItemsBeneficiaryTableGrid&parId=" + parId + 
				"&itemNo=" + $F("itemNo") + "&groupedItemNo=" + $F("groupedItemNo") + "&beneficiaryNo=" + $F("bBeneficiaryNo") + "&refresh=1",
		options : {
			width : '855px',
			masterDetail : true,
			pager : {},
			onCellFocus : function(element, value, x, y, id){
				var objSelected = tbgGrpItemsBeneficiary.geniisysRows[y];
				
				tbgGrpItemsBeneficiary.keys.releaseKeys();
				setGrpItemBeneficiaryFormTG(objSelected);
				// retrieve child records
				retrieveItmperlBeneficiaries(objSelected.parId, objSelected.itemNo, objSelected.groupedItemNo, objSelected.beneficiaryNo);
			},
			onRemoveRowFocus : function(){
				setGrpItemBeneficiaryFormTG(null);
				tbgGrpItemsBeneficiary.keys.releaseKeys();
			},
			masterDetailValidation : function(){
				if(getAddedAndModifiedJSONObjects(objGIPIWGrpItemsBeneficiary).length > 0 || getDeletedJSONObjects(objGIPIWGrpItemsBeneficiary).length > 0){					
					return true;
				}else{
					return false;
				}
			},
			masterDetailSaveFunc : function(){
				//$("btnSave").click();
			},
			masterDetailNoFunc : function(){
				objGIPIWGrpItemsBeneficiary = objGroupedItemsBens.gipiWGrpItemBeneficiary.slice(0);
				setGrpItemBeneficiaryFormTG(null);
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
				width : '50px',
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
				title : 'Beneficiary Name',
				sortable : true,
				filterOption : true
			},
			{
				id : 'sex',
				width : '50px',
				title : 'Sex',
				sortable : true,
				renderer : function(value){
					var sex = "";
					
					switch(value){
						case "M" : sex = "Male"; break;
						case "F" : sex = "Female"; break;
						default	 : sex = ""; break;
					}
					
					return sex;
				}
			},
			{
				id : 'civilStatusDesc',
				width : '100px',
				title : 'Status',
				sortable : true
			},
			{
				id : 'age',
				width : '35px',
				title : 'Age',
				type : 'number',
				sortable : true
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
				id : 'beneficiaryAddr',
				width : '200px',
				title : 'Address',
				sortable : true,
				filterOption : true
			},
			{
				id : 'relation',
				width : '100px',
				title : 'Relation',
				sortable : true
			}
		               ],
		rows : objGroupedItemsBens.rows,
		id : 13
	};
	
	tbgGrpItemsBeneficiary = new MyTableGrid(tbBens);
	tbgGrpItemsBeneficiary.pager = objGroupedItemsBens;
	tbgGrpItemsBeneficiary._mtgId = 13;
	tbgGrpItemsBeneficiary.render('grpItemsBeneficiaryTableGrid');
	tbgGrpItemsBeneficiary.afterRender = function(){
		//objGIPIWGrpItemsBeneficiary = objGroupedItemsBens.gipiWGrpItemBeneficiary.slice(0);	
		//objItemTempStorage.objGIPIWGrpItemBeneficiary = objGroupedItemsBens.gipiWGrpItemBeneficiary.slice(0);
		
		setGrpItemBeneficiaryFormTG(null);
		tbgGrpItemsBeneficiary.keys.releaseKeys();
	};
}catch(e){
	showErrorMessage("Accident Grouped Items Beneficiary Listing", e);
}
</script>
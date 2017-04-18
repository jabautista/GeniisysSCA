<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<% 
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="casualtyPersonnelTable" name="casualtyPersonnelTable" style="width : 100%;">
	<div id="casualtyPersonnelTableGridSectionDiv" class="">
		<div id="casualtyPersonnelTableGridDiv" style="padding: 10px;">
			<div id="casualtyPersonnelTableGrid" style="height: 206px; width: 900px;"></div>
		</div>
		<div class="rightAligned" style="margin-bottom: 10px;">
			Total Amount Covered : 
			<input tabindex="5000" id="txtTotalAmountCoveredCasualtyPersonnel" name="txtTotalAmountCoveredCasualtyPersonnel" class="rightAligned" type="text" style="width: 150px; margin-right: 10px;" readonly="readonly" />			
		</div>
	</div>	
</div>

<script type="text/javascript">
try{
	var objCasPers = JSON.parse('${tgCasualtyPersonnel}');
	
	var tbCasPers = {
		url : contextPath + "/GIPIWCasualtyPersonnelController?action=refreshCasualtyPersonnelTable&parId=" + objUWParList.parId + "&itemNo=" + $F("itemNo"),
		options : {
			width : '900px',
			masterDetail : true,
			pager : {},
			onCellFocus : function(element, value, x, y, id){
				var objSelected = tbgCasualtyPersonnel.geniisysRows[y];
				
				tbgCasualtyPersonnel.keys.releaseKeys();
				setCasualtyPersonnelFormTG(objSelected);
			},
			onRemoveRowFocus : function(){
				setCasualtyPersonnelFormTG(null);
				tbgCasualtyPersonnel.keys.releaseKeys();
			},
			masterDetailValidation : function(){
				if(getAddedAndModifiedJSONObjects(objGIPIWCasualtyPersonnel).length > 0 || getDeletedJSONObjects(objGIPIWCasualtyPersonnel).length > 0){
					return true;
				}else{
					return false;
				}
			},
			masterDetailSaveFunc : function(){
				$("btnSave").click();
			},
			masterDetailNoFunc : function(){
				objGIPIWCasualtyPersonnel = objItemTempStorage.objGIPIWCasualtyPersonnel.slice(0);
				setCasualtyPersonnelFormTG(null);
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
				id : 'personnelNo',
				width : '100px',
				title : 'Personnel No.',
				align : 'right',
				sortable : true,		
				renderer : function(value){
					return lpad(value.toString(), 9, "0");
           		}
			},
			{
				id : 'personnelName',
				width : '200px',
				title : 'Name',
				sortable : true,
				filterOption : true
			},
			{
				id : 'capacityDesc',
				width : '150px',
				title : 'Capacity',
				sortable : true, //false, changed by robert to true 09232013
				filterOption : true
			},
			{
				id : 'remarks',
				width : '250px',
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
				title : 'Amount',
				type : 'number',
				geniisysClass : 'money'
			}
		               ],
		rows : objCasPers.rows,
		id : 7
	};
	
	tbgCasualtyPersonnel = new MyTableGrid(tbCasPers);
	tbgCasualtyPersonnel.pager = objCasPers;
	tbgCasualtyPersonnel._mtgId = 7;
	tbgCasualtyPersonnel.render('casualtyPersonnelTableGrid');
	tbgCasualtyPersonnel.afterRender = function(){
		tbgCasualtyPersonnel.keys.releaseKeys();
		setCasualtyPersonnelFormTG(null);
	};
	
}catch(e){
	showErrorMessage("Casualty Personnel Listing", e);
}
</script>

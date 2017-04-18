<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="cargoCarrierTable" name="cargoCarrierTable" style="width : 100%;">
	<div id="cargoCarrierTableGridSectionDiv" class="">
		<div id="cargoCarrierTableGridDiv" style="padding: 10px;">
			<div id="cargoCarrierTableGrid" style="height: 206px; width: 900px;"></div>
		</div>
		<div class="rightAligned" style="margin-bottom: 10px;">
			Total : 
			<input tabindex="2000" id="txtTotalLimitOfLiability" name="txtTotalLimitOfLiability" class="rightAligned" type="text" style="width: 150px; margin-right: 10px;" readonly="readonly" />			
		</div>
	</div>	
</div>
<script type="text/javascript">
try{
	var objCCarriers = JSON.parse('${tgCargoCarriers}');
	
	var tbCargoCarriers = {
		url : contextPath + "/GIPIWCargoCarrierController?action=refreshCargoCarrierTable&parId=" + objUWParList.parId + "&itemNo=" + $F("itemNo"),	
		options : {
			width : '900px',
			masterDetail : true,
			pager : {},
			onCellFocus : function(element, value, x, y, id){
				var objSelected = tbgCargoCarriers.geniisysRows[y];
				
				tbgCargoCarriers.keys.releaseKeys();
				setCargoCarrierFormTG(objSelected);
			},
			onRemoveRowFocus : function(){
				setCargoCarrierFormTG(null);
			},
			masterDetailValidation : function(){
				if(getAddedAndModifiedJSONObjects(objGIPIWCargoCarrier).length > 0 || getDeletedJSONObjects(objGIPIWCargoCarrier).length > 0){
					return true;
				}else{
					return false;
				}
			},
			masterDetailSaveFunc : function(){
				$("btnSave").click();
			},
			masterDetailNoFunc : function(){
				objGIPIWCargoCarrier = objItemTempStorage.objGIPIWCargoCarrier.slice(0);				
				setCargoCarrierFormTG(null);
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
				id : 'vesselCd',
				title : 'Vessel Cd',
				width : '100px'
			},
			{
				id : 'vesselName',
				title : 'Vessel Name',
				width : '300px'
			},
			{
				id : 'plateNo',
				title : 'Plate No.',
				width : '100px'
			},
			{
				id : 'motorNo',
				title : 'Motor No.',
				width : '100px'
			},
			{
				id : 'serialNo',
				title : 'Serial No.',
				width : '100px'
			},
			{
				id : 'vesselLimitOfLiab',
				title : 'Limit of Liability',
				width : '150px',
				align : 'right',
				geniisysClass : 'money'
			}
		               ],
		rows : objCCarriers.rows,
		id : 6
	};
	
	tbgCargoCarriers = new MyTableGrid(tbCargoCarriers);	
	tbgCargoCarriers.pager = objCCarriers;
	tbgCargoCarriers._mtgId = 6;
	tbgCargoCarriers.render('cargoCarrierTableGrid');
	tbgCargoCarriers.afterRender = function(){
		setCargoCarrierFormTG(null);
		tbgCargoCarriers.keys.releaseKeys();
	};	
}catch(e){
	showErrorMessage("Cargo Carrier Listing", e);
}
</script>
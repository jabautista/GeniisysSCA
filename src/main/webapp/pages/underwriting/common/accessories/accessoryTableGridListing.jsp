<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<div id="accessoryTable" name="accessoryTable" style="width : 100%;">
	<div id="accessoryTableGridSectionDiv" class="">
		<div id="accessoryTableGridDiv" style="padding: 10px;">
			<div id="accessoryTableGrid" style="height: 198px; width: 900px;"></div>
		</div>
		<div class="rightAligned" style="margin-bottom: 10px;">
			Total Amount: 
			<input tabindex="5000" id="txtTotalAmountAccessory" name="txtTotalAmountAccessory" class="rightAligned" type="text" style="width: 150px; margin-right: 10px;" readonly="readonly" />			
		</div>
	</div>	
</div>

<script type="text/javascript">
	try{
		var objAccs = JSON.parse('${tgAccessories}');
		var parId = (objUWGlobal.packParId != null ? objCurrPackPar.parId : objUWParList.parId);

		var tbAccessory = {
			url : contextPath + "/GIPIWMcAccController?action=refreshAccessoryTable&parId=" + parId + "&itemNo=" + $F("itemNo"),
			options : {
				width : '900px',
				masterDetail : true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					var objSelected = tbgAccessory.geniisysRows[y];
					
					tbgAccessory.keys.releaseKeys();
					setAccessoryFormTG(objSelected);
				},
				onRemoveRowFocus : function(){
					tbgAccessory.keys.releaseKeys();
					setAccessoryFormTG(null);
				},
				masterDetailValidation : function(){
					if(getAddedAndModifiedJSONObjects(objGIPIWMcAcc).length > 0 || getDeletedJSONObjects(objGIPIWMcAcc).length > 0){
						return true;
					}else{
						return false;
					}
				},
				masterDetailSaveFunc : function(){
					$("btnSave").click();
				},
				masterDetailNoFunc : function(){
					objGIPIWMcAcc = objItemTempStorage.objGIPIWMcAcc.slice(0);
					setAccessoryFormTG(null);
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
					id : 'accessoryCd',
					title : 'Accessory Code',
					align : 'right',
					width : '100px',
					sortable : true
               	},
               	{
					id : 'accessoryDesc',
					title : 'Description',
					width : '600px',
					sortable : true,
					filterOption : true
               	},
               	{
					id : 'accAmt',
					title : 'Amount',
					width : '150px',
					type : 'number',
					geniisysClass : 'money'
               	}	               
			],
			rows : objAccs.rows,
			id : 7
		};

		tbgAccessory = new MyTableGrid(tbAccessory);
		tbgAccessory.pager = objAccs;
		tbgAccessory._mtgId = 7;
		tbgAccessory.render('accessoryTableGrid');
		tbgAccessory.afterRender = function(){
			setAccessoryFormTG(null);
			tbgAccessory.keys.releaseKeys();
		};
		
	}catch(e){
		showErrorMessage("Accessory Listing", e);
	}
</script>
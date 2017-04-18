<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" %>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-Control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="itemInformation" name="itemInformation" style="width : 100%;">
	<div id="itemInfoTableGridSectionDiv" class="">
		<div id="itemInfoTableGridDiv" style="padding: 10px;">
			<div id="itemInfoTableGrid" style="height: 206px; width: 900px;"></div>
		</div>
	</div>
</div>

<script>
	try{	
		var objItemArray = JSON.parse('${itemTableGrid}');
		var parId = (objUWGlobal.packParId != null ? objCurrPackPar.parId : objUWParList.parId);
		
		function selectLineAction(){
			var lineCd = getLineCd();
			var lineAction = "";
			
			switch(lineCd){
				case "AC"	: lineAction = "getGIPIWItemTableGridAC"; break;
				case "AV"	: lineAction = "getGIPIWItemTableGridAV"; break;
				case "CA"	: lineAction = "getGIPIWItemTableGridCA"; break;
				case "EN"	: lineAction = "getGIPIWItemTableGridEN"; break;
				case "FI"	: lineAction = "getGIPIWItemTableGridFI"; break;
				case "MC"	: lineAction = "getGIPIWItemTableGridMC"; break;
				case "MH"	: lineAction = "getGIPIWItemTableGridMH"; break;
				case "MN"	: lineAction = "getGIPIWItemTableGridMN"; break;				
			}
			
			return lineAction;
		}
		
		var itemTable = {
			url : contextPath + "/GIPIWItemController?action=refreshItemTable&parId=" + parId + "&lineAction=" + selectLineAction(),
			options : {
				width : '900px',
				hideColumnChildTitle: true,
				masterDetail : true,
				pager : {},
				onSort : function(){				
					return false;
				},
				onCellFocus : function(element, value, x, y, id){	
					if(hasPendingChildRecords() && changeTag == 1){
						showConfirmBox4("Save", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
									function(){
										$("btnSave").click();
									}, 
									function(){
 										resetItemObjects();
										showItemAndRelatedDetails(y);
										changeTag = 0;	
									}, "");						
					}else{
						showItemAndRelatedDetails(y);
					}	
					objCurrItemPeril = null; // andrew - 02.08.2012
					validateZoneType();		//Gzelle 05252015 SR4347
					//checkGetDefCurr();	//Apollo Cruz 12.04.2014 - this function doesn't need to be executed upon selecting an item
				},
				onCellBlur : function(){
					//
				},
				onRemoveRowFocus : function(){
					objCurrItem = null;
					objCurrItemPeril = null; // andrew - 02.08.2012
					setParItemFormTG(null);
					setDefaultItemForm();
					clearItemRelatedTableGrid();
					clearItemRelatedDetails();
					tbgItemTable.keys.releaseKeys();
				},
				prePager : function(){
					/*					
					if(hasPendingChildRecords()){
						showConfirmBox4("Save", "There are pending (additional) records to be saved. Navigating to other items " + 
								"will delete these records. Do you want to save the changes you have made?", "Yes", "No", "Cancel",
									function(){
										$("btnSave").click();
									}, 
									function(){
										resetItemObjects();
										setParItemForm(null);
										setDefaultItemForm();
										objCurrItem = null;															
										tbgItemTable.refresh();																				
									}, "");
						return false;			
					}
					*/
				},				
				postPager : function (){
					objCurrItem = null;
					objCurrItemPeril = null; // andrew - 02.08.2012
					setParItemFormTG(null);					
					setDefaultItemForm();	
					clearItemRelatedTableGrid();
					clearItemRelatedDetails();
				},
				beforeSort: function(){ // Nica - 05.18.2012
					if(hasPendingChildRecords() || 
							(getAddedAndModifiedJSONObjects(objGIPIWItem).length > 0 || getDeletedJSONObjects(objGIPIWItem).length > 0)){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}
				},
				masterDetailValidation : function(){
					if(hasPendingChildRecords() || 
							(getAddedAndModifiedJSONObjects(objGIPIWItem).length > 0 || getDeletedJSONObjects(objGIPIWItem).length > 0)){
						return true;
					}else{
						return false;
					}
				},
				masterDetailSaveFunc : function(){					
					$("btnSave").click();
				},
				masterDetailNoFunc : function(){
					objCurrItem = null;					
					setParItemFormTG(null);					
					setDefaultItemForm();		
					clearItemRelatedTableGrid();
					clearItemRelatedDetails();
					changeTag = 0;
				},
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
				}			
			},
			columnModel : [
				{ 								// this column will only use for deletion
				    id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
				    title: 'D',
				    altTitle: 'Delete?',
				    width: '20px',				    
				    editor: 'checkbox',				    
				    visible : false			
				},
				{
					id : 'divCtrId',
					width : '0px',
					visible : false
				},				
				{
					id : "itemNo",
					title : "Item No.",
					width : '60px',
					type : 'number',
					filterOption : true,
					filterOptionType: 'integerNoNegative',
					renderer : function(value){
						return lpad(value.toString(), 9, "0");					
					}
				},
				{
					id : "itemTitle",
					title : "Item Title",
					width : '180px',
					filterOption : true,
					renderer : function(value){
						return unescapeHTML2(value);
					}
				},
				{
					id : 'itemDesc itemDesc2',
					title : 'Description',
					width : '360px',
					sortable : false,					
					children : [
						{
							id : 'itemDesc',							
							width : 180,							
							sortable : false,
							editable : false,							
							renderer : function(value){
								return unescapeHTML2(value);
							}
						},
						{
							id : 'itemDesc2',							
							width : 180,
							sortable : false,
							editable : false,							
							renderer : function(value){
								return unescapeHTML2(value);
							}
						}
					            ]					
				},				
				{
					id : "currencyDesc",
					title : "Currency",
					width : '120px',
					sortable : false				
				},
				{
					id : "currencyRt",
					title : "Rate",
					width : '100px',					
					type : 'number',							
					geniisysClass : 'rate'
				}/*,
				{
					id : "parId",					
					width : '0px',
					visible : false
				},
				{
					id : 'itemGrp',
					width : '0px',
					visible : false
				},
				{
					id : 'tsiAmt',
					width : '0px',
					visible : false
				},
				{
					id : 'premAmt',
					width : '0px',
					visible : false
				},
				{
					id : 'annPremAmt',
					width : '0px',
					visible : false
				},
				{
					id : 'annTsiAmt',
					width : '0px',
					visible : false
				},
				{
					id : 'recFlag',
					width : '0px',
					visible : false
				},
				{
					id : 'groupCd',
					width : '0px',
					visible : false
				},
				{
					id : 'currencyCd',
					width : '0px',
					visible : false
				},
				{
					id : 'coverageCd',
					width : '0px',
					visible : false
				},
				{
					id : 'surchargeSw',
					width : '0px',
					visible : false
				},
				{
					id : 'discountSw',
					width : '0px',
					visible : false
				},
				{
					id : 'packLineCd',
					width : '0px',
					visible : false
				},
				{
					id : 'packSublineCd',
					width : '0px',
					visible : false
				},
				{
					id : 'otherInfo',
					width : '0px',
					visible : false
				},
				{
					id : 'regionCd',
					width : '0px',
					visible : false
				},
				{
					id : 'fromDate',
					width : '0px',
					visible : false
				},
				{
					id : 'toDate',
					width : '0px',
					visible : false
				},
				{
					id : 'riskNo',
					width : '0px',
					visible : false
				},
				{
					id : 'riskItemNo',
					width : '0px',
					visible : false
				},
				{
					id : 'paytTerms',
					width : '0px',
					visible : false
				},
				{
					id : 'gipiWVehicle',
					width : '0px',
					visible : false
				},
				{
					id : 'gipiWFireItm',
					width : '0px',
					visible : false
				},
				{
					id : 'gipiWAccidentItem',
					width : '0px',
					visible : false
				},
				{
					id : 'gipiWCasualtyItem',
					width : '0px',
					visible : false
				},
				{
					id : 'gipiWAviationItem',
					width : '0px',
					visible : false
				},
				{
					id : 'gipiWItemVes',
					width : '0px',
					visible : false
				},
				{
					id : 'gipiWCargo',
					width : '0px',
					visible : false
				}*/
			],
			rows : objItemArray.rows
		};

		tbgItemTable = new MyTableGrid(itemTable);
		tbgItemTable.pager = objItemArray;
		tbgItemTable._mtgId = 2;
		tbgItemTable.render("itemInfoTableGrid");
		tbgItemTable.afterRender = function(){
			tbgItemTable.keys.releaseKeys();
			
			var lineCd = getLineCd();
					
			objGIPIWItem = objItemArray.gipiWItem.slice(0);
			objDeductibles = objItemArray.gipiWDeductibles.slice(0);
			objGIPIWItemPeril = objItemArray.gipiWItemPeril.slice(0);

			if(lineCd == "FI"){
				objMortgagees = objItemArray.gipiWMortgagee.slice(0);
				objItemTempStorage.objGIPIWMortgagee = objItemArray.gipiWMortgagee.slice(0);
			}else if(lineCd == "MC"){
				objMortgagees = objItemArray.gipiWMortgagee.slice(0);				
				objGIPIWMcAcc = objItemArray.gipiWMcAcc.slice(0);

				objItemTempStorage.objGIPIWMortgagee = objItemArray.gipiWMortgagee.slice(0);
				objItemTempStorage.objGIPIWMcAcc = objItemArray.gipiWMcAcc.slice(0);
			}else if(lineCd == "CA"){				
				objGIPIWGroupedItems = objItemArray.gipiWGroupedItems.slice(0);
				objGIPIWCasualtyPersonnel = objItemArray.gipiWCasualtyPersonnel.slice(0);
				
				objItemTempStorage.objGIPIWGroupedItems = objItemArray.gipiWGroupedItems.slice(0);
				objItemTempStorage.objGIPIWCasualtyPersonnel = objItemArray.gipiWCasualtyPersonnel.slice(0);
			}else if(lineCd == "MN"){				
				objGIPIWVesAir = objItemArray.gipiWVesAir.slice(0);
				objGIPIWVesAccumulation = objItemArray.gipiWVesAccumulation.slice(0);
				objGIPIWCargoCarrier = objItemArray.gipiWCargoCarrier.slice(0);
				
				objItemTempStorage.objGIPIWVesAir = objItemArray.gipiWVesAir.slice(0);
				objItemTempStorage.objGIPIWVesAccumulation = objItemArray.gipiWVesAccumulation.slice(0);
				objItemTempStorage.objGIPIWCargoCarrier = objItemArray.gipiWCargoCarrier.slice(0);
				
				if(objGIPIWVesAir.length < 1){
					showWaitingMessageBox("Please enter your carrier information for this PAR.", imgMessage.INFO, 
							function() {
								if(checkUserModule("GIPIS007")){ //added by steven 07.08.2014
									if(objUWGlobal.packParId != null) {
										showPackCarrierInformation(objUWGlobal.packParId, objLineCds.MN);
									} else {
										showCarrierInfoPage();
									}
								}else{
									showMessageBox(objCommonMessage.NO_MODULE_ACCESS,"I");
								}
							});
				}
			}else if(lineCd == "AC"){
				objGIPIWGroupedItems = objItemArray.gipiWGroupedItems.slice(0);
				objGIPIWItmperlGrouped = objItemArray.gipiWItmperlGrouped.slice(0);
				objBeneficiaries = objItemArray.gipiWBeneficiary.slice(0);
				objGIPIWGrpItemsBeneficiary = objItemArray.gipiWGrpItemsBeneficiary.slice(0);
				
				objItemTempStorage.objGIPIWGroupedItems = objItemArray.gipiWGroupedItems.slice(0);
				objItemTempStorage.objGIPIWItmperlGrouped = objItemArray.gipiWItmperlGrouped.slice(0);
				objItemTempStorage.objGIPIWBeneficiary = objItemArray.gipiWBeneficiary.slice(0);
				objItemTempStorage.objGIPIWGrpItemsBeneficiary = objItemArray.gipiWGrpItemsBeneficiary.slice(0);
			}

			objItemTempStorage.objGIPIWItem = objItemArray.gipiWItem.slice(0);
			objItemTempStorage.objGIPIWDeductibles = objItemArray.gipiWDeductibles.slice(0);
			objItemTempStorage.objGIPIWItemPeril = objItemArray.gipiWItemPeril.slice(0);			
			
			setParItemFormTG(null);		
			if((objUWParList.parType == "P") || ((objUWParList.parType == "E" && $F("recFlag") == "A"))) { //koks 19817 added condition
			checkGetDefCurr();	//Gzelle 10242014
			}
		};		
	}catch(e){
		showErrorMessage("Item Table Listing", e);
	}		
</script>
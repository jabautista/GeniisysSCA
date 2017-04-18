<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="fireItemInfoMainDiv" name="fireItemInfoMainDiv" style="margin-top: 1px;">
	<form id="fireItemInfoForm" name="fireItemInfoForm">
		<jsp:include page="/pages/claims/subPages/claimInformation.jsp"></jsp:include>
		<jsp:include page="/pages/claims/claimItemInfo/fire/subPages/fireAddtlInfo.jsp"></jsp:include>
		<jsp:include page="/pages/claims/claimItemInfo/peril/perilInfo.jsp"></jsp:include>
		<jsp:include page="/pages/claims/claimItemInfo/mortgagee/mortgageeInfo.jsp"></jsp:include>
		<jsp:include page="/pages/claims/claimItemInfo/peril/perilStatus.jsp"></jsp:include>
		<div class="buttonsDiv" >
			<input type="button" id="btnAttachViewPic"	name="btnAttachViewPic" class="button"	value="Attach/View Pictures" />
			<input type="button" id="btnCancel"	name="btnCancel" class="button"	value="Cancel" />
			<input type="button" id="btnSave" 	name="btnSave" 	 class="button"	value="Save" />			
		</div>
	</form>
</div>
<script type="text/javascript">
try{
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	
	objCLMItem.objItemTableGrid = JSON.parse('${giclFireDtl}'.replace(/\\/g, '\\\\'));
	objCLMItem.objGiclFireDtl = objCLMItem.objItemTableGrid.rows;
	objCLMItem.ora2010Sw = ('${ora2010Sw}');	//giis_parameters
	objCLMItem.vLocLoss = ('${vLocLoss}');  	//VALIDATE LOCATION OF LOSS from giis_parameters used in CHECK_BLOCK_DISTRICT_NO
	
	var tableModel = {
		url: contextPath+"/GICLFireDtlController?action=getFireDtl&claimId="+objCLMGlobal.claimId,
		options : {
			hideColumnChildTitle: true,
			newRowPosition: 'bottom',
			pager: { 
			},
			onCellFocus: function(element, value, x, y, id){
				if (y >= 0){
					if (checkClmItemChanges()){
						objCLMItem.selItemIndex = String(y);
						supplyClmFireItem(itemGrid.rows[y]);
					}
				}else{
					objCLMItem.selItemIndex = String(y);
					supplyClmFireItem(itemGrid.newRowsAdded[Math.abs(y)-1]);
				}	
				itemGrid.releaseKeys();
			},
			onCellBlur : function(element, value, x, y, id) {
				observeClmItemChangeTag();
				itemGrid.releaseKeys();
			},
			onRemoveRowFocus: function(element, value, x, y, id) {
				if (y >= 0){
					if (checkClmItemChanges()){
						supplyClmFireItem(null);
					}
				}else{
					supplyClmFireItem(null);
				}	
				itemGrid.releaseKeys();
			},
			toolbar: {
				onSave: function(){
					return saveClmItemPerLine();
				},
				postSave: function(){
					showClaimItemInfo();
				}
			}
		},
		columnModel : [
			{ 								// this column will only use for deletion
				id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
				title: '&#160;D',
			 	altTitle: 'Delete?',
			 	titleAlign: 'center',
		 		width: 19,
		 		sortable: false,
			 	editable: true, 			// if 'editable: false,' and 'sortable: false,' and editor is checkbox or instanceof CellCheckbox then hide the 'Select all' checkbox button in header
			  	//editableOnAdd: true,		// if 'editable: false,' you can use 'editableOnAdd: true,' to enable the checkbox on newly added row
			 	//defaultValue: true,		// if 'defaultValue' is not available, default is false for checkbox on adding new row
		 		editor: 'checkbox',
			 	hideSelectAllBox: true,
			 	visible: false 
			},
			{
				id: 'divCtrId',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'claimId',
			  	width: '0',
			  	visible: false,
			  	defaultValue: objCLMGlobal.claimId
		 	},
		 	{
				id: 'currencyCd',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'userId',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'lastUpdate',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'districtNo',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'eqZone',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'tarfCd',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'blockNo',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'blockId',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'frItemType',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'locRisk1',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'locRisk2',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'locRisk3',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'tariffZone',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'typhoonZone',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'constructionCd',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'constructionRemarks',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'front',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'right',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'left',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'rear',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'occupancyCd',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'occupancyRemarks',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'floodZone',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'assignee',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'cpiRecNo',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'cpiBranchCd',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'lossDate',
			  	width: '0',
			  	defaultValue: objCLMGlobal.strLossDate2,
			  	visible: false 
		 	},
		 	{
				id: 'riskCd',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'riskDesc',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'dspItemType',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'dspEqZone',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'dspTariffZone',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'dspTyphoon',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'dspConstruction',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'dspOccupancy',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'dspFloodZone',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'giclItemPerilExist',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'giclMortgageeExist',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'giclItemPerilMsg',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'msgAlert',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'itemNo',
				title: 'Item No',
		        width: '60',
		        type: 'number',
		        editable: false,
				renderer: function (value){
					return nvl(value,'') == '' ? '' :formatNumberDigits(value,9);
				},
		        filterOption: true,
		        filterOptionType: 'integer'
		 	},
		 	{
				id: 'itemTitle',
				title: 'Item Title',
			  	width: '141',
			  	filterOption: true
		 	},
		   	{
				id: 'itemDesc itemDesc2',
				title: 'Description',
				width : 280,
				children : [
		            {
		                id : 'itemDesc',
		                width : 140,
		                filterOption: true
		            },
		            {
		                id : 'itemDesc2', 
		                width : 140,
		                filterOption: true
		            }
				]
			},
		 	{
				id: 'dspCurrencyDesc',
				title: 'Currency',
			  	width: '110',
			  	filterOption: true
		 	},
		 	{
				id: 'currencyRate',
				title: 'Rate',
				titleAlign: 'right',
				align: 'right',
			  	width: '90',
			  	geniisysClass: 'rate',
	            deciRate: 9,
			  	filterOption: true
		 	}
		],
		resetChangeTag: true,
		requiredColumns: '',
		rows : objCLMItem.objGiclFireDtl,
		id: 1
	};   					
	
	itemGrid = new MyTableGrid(tableModel);
	itemGrid.pager = objCLMItem.objItemTableGrid;
	itemGrid.afterRender = function(){
		//objCLMItem.objGiclFireDtl.length > 0 ? fireEvent($("mtgC"+itemGrid._mtgId+"_41,0"), "click") :null;
		changeTag = 0;
		initializeChangeTagBehavior(function(){saveClaimsItemGrid(false);});
	};
	itemGrid._mtgId = 1;
	itemGrid.render('addtlInfoGrid');
	
	//for item no. focus event
	observeClmItemNoFocus();
	
	//for item no. blur event
	observeClmItemNoBlur();
	
	//for delete button observe
	observeClmDeleteItem();
	
	//for add button observe
	observeClmAddItem();
	
	//LOV for item no. - fire
	observeClmItemNoLOV();
	
	//for main button
	observeClmItemMainBtn();
	
	//initialize fire item information
	clearClmItemForm();
	
	window.scrollTo(0,0); 	
	hideNotice("");
	setModuleId("GICLS015");
	setDocumentTitle("Item Information - Fire");
	
	// added by Kris 08.06.2013
	function exitCancelFunc(){
		if (objCLMGlobal.callingForm == "GICLS001"){
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
		}else if(objGICLS051.previousModule == "GICLS051"){
			objGICLS051.previousModule = null;
			showGeneratePLAFLAPage(objGICLS051.currentView, objCLMGlobal.lineCd);
		}else{		
			showClaimListing();
		}		
	}	
	
	$("clmExit").stopObserving("click");	
	observeAccessibleModule(accessType.MENU, "GICLS002", "clmExit", exitCancelFunc);
}catch(e){
	showErrorMessage("Claims Fire Item Info" ,e);
}	
</script>
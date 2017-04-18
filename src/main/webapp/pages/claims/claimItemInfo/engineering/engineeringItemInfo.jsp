<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="engineeringItemInfoMainDiv" name="engineeringItemInfoMainDiv" style="margin-top: 1px;">
	<form id="engineeringItemInfoForm" name="engineeringItemInfoForm">
		<jsp:include page="/pages/claims/subPages/claimInformation.jsp"></jsp:include>
		<jsp:include page="/pages/claims/claimItemInfo/engineering/subPages/engineeringAddtlInfo.jsp"></jsp:include>
		<jsp:include page="/pages/claims/claimItemInfo/peril/perilInfo.jsp"></jsp:include>
		<jsp:include page="/pages/claims/claimItemInfo/peril/perilStatus.jsp"></jsp:include>
		<div class="buttonsDiv" >
			<input type="button" id="btnAttachViewPic"	name="btnAttachViewPic" class="button"	value="Attach/View Pictures" />
			<input type="button" id="btnCancel"	name="btnCancel" class="button"	value="Cancel" />
			<input type="button" id="btnSave" 	name="btnSave" 	 class="button"	value="Save" />			
		</div>
	</form>
</div>
<script type="text/javascript">
try {
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	/** Variables **/
	
	/*+ Block Records +*/
	/* var engineeringItemInfoMap 		= JSON.parse('${engineeringItemInfoMap}'.replace(/\\/g, '\\\\'));
	var claimId 					= engineeringItemInfoMap.claimId; */ //benjo 09.10.2015 comment out
	
	/** Table Grid **/
	
	objCLMItem.objItemTableGrid = JSON.parse('${giclEngineeringDtl}'.replace(/\\/g, '\\\\'));
	objCLMItem.objGiclEngineeringDtl = objCLMItem.objItemTableGrid.rows;
	
	var tableModel = {
		url: contextPath+"/GICLEngineeringDtlController?action=getEngineeringDtl&claimId="+objCLMGlobal.claimId,
		options : {
			hideColumnChildTitle: true,
			newRowPosition: 'bottom',
			pager: { 
			},
			onCellFocus: function(element, value, x, y, id){
				if (y >= 0){
					if (checkClmItemChanges()){
						objCLMItem.selItemIndex = String(y);
						supplyClmEngineeringItem(itemGrid.rows[y]);
					}
				}else{
					objCLMItem.selItemIndex = String(y);
					supplyClmEngineeringItem(itemGrid.newRowsAdded[Math.abs(y)-1]);
				}	
				itemGrid.keys.removeFocus(itemGrid.keys._nCurrentFocus, true);
				itemGrid.keys.releaseKeys();
				itemGrid.keys._nOldFocus = null;
				validateItemTableGrid();
			},
			onCellBlur : function(element, value, x, y, id) {
				observeClmItemChangeTag();
			},
			onRemoveRowFocus: function(element, value, x, y, id) {
				if (y >= 0){
					if (checkClmItemChanges()){
						supplyClmEngineeringItem(null);
					}
				}else{
					supplyClmEngineeringItem(null);
				}	
				validateItemTableGrid();
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
			  	width: '158',
			  	filterOption: true
		 	},
		 	{
				id: 'itemDesc itemDesc2',
				title: 'Description',
				width : 300,
				children : [
		            {
		                id : 'itemDesc',
		                width : 150,
		                filterOption: true
		            },
		            {
		                id : 'itemDesc2', 
		                width : 150,
		                filterOption: true
		            }
				]
			},
		 	{
				id: 'currDesc',
				title: 'Currency',
			  	width: '130',
			  	filterOption: true
		 	},
		 	{
				id: 'currencyRate',
				title: 'Rate',
				titleAlign: 'right',
				align: 'right',
			  	width: '95',
			  	geniisysClass: 'rate',
	            deciRate: 9,
			  	filterOption: true
		 	},
		 	{
				id: 'regionCd',
			  	width: '0',
			  	visible: false
		 	},
		 	{
				id: 'regionDesc',
			  	width: '0',
			  	visible: false
		 	},
		 	{
				id: 'provinceCd',
			  	width: '0',
			  	visible: false
		 	},
		 	{
				id: 'provinceDesc',
			  	width: '0',
			  	visible: false
		 	},
		 	{
				id: 'lossDate',
			  	width: '0',
			  	visible: false
		 	},
		 	{
				id: 'dspItemTitle',
			  	width: '0',
			  	visible: false
		 	},
		 	{
				id: 'giclItemPerilExist',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'giclItemPerilMsg',
			  	width: '0',
			  	visible: false 
		 	},
		 	{
				id: 'currencyCd',
			  	width: '0',
			  	visible: false 
		 	}
	 	],
		resetChangeTag: true,
		requiredColumns: '',
		rows : objCLMItem.objGiclEngineeringDtl
	};
	
	itemGrid = new MyTableGrid(tableModel);
	itemGrid.pager = objCLMItem.objItemTableGrid;
	itemGrid.afterRender = function(){
		validateItemTableGrid();
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
	setModuleId("GICLS021");
	setDocumentTitle("Claims - Item Information - Engineering");
} catch (e) {
	showErrorMessage("Claims Engineering Item Info", e);
} 
</script>
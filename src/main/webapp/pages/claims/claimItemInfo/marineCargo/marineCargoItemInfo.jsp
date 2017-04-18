<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="marineCargoItemInfoMainDiv" name="marineCargoItemInfoMainDiv" style="margin-top: 1px;">
	<form id="marineCargoItemInfoForm" name="marineCargoItemInfoForm">
		<jsp:include page="/pages/claims/subPages/claimInformation.jsp"></jsp:include>
		<jsp:include page="/pages/claims/claimItemInfo/marineCargo/subPages/marineCargoAddtlInfo.jsp"></jsp:include>
		<jsp:include page="/pages/claims/claimItemInfo/peril/perilInfo.jsp"></jsp:include>
		<jsp:include page="/pages/claims/claimItemInfo/peril/perilStatus.jsp"></jsp:include>
		<div class="buttonsDiv" >
			<input type="button" id="btnAttachViewPic"	name="btnAttachViewPic" class="button"	value="Attach/View Pictures" />
			<input type="button" id="btnCancel"	name="btnCancel" class="button"	value="Cancel" />
			<input type="button" id="btnSave" 	name="btnSave" 	 class="button"	value="Save" />			
		</div>
	</form>
</div>

<script>
	try{
		initializeAccordion();
		addStyleToInputs();
		initializeAll();
		initializeAllMoneyFields();
		
		objCLMItem.objItemTableGrid = JSON.parse('${giclCargoDtlGrid}'.replace(/\\/g, '\\\\'));
		objCLMItem.objGiclCargoDtl = objCLMItem.objItemTableGrid.rows;
		
		var tableModel = {
				url: contextPath+"/GICLCargoDtlController?action=getCargoDtl&claimId="+objCLMGlobal.claimId,
				options : {
					hideColumnChildTitle: true,
					onCellFocus: function(element, value, x, y, id){
						if (y >= 0){
							if (checkClmItemChanges()){
								objCLMItem.selItemIndex = String(y);
								populateMarineCargoFields(itemGrid.rows[y]);
							}
						}else{
							objCLMItem.selItemIndex = String(y);
							populateMarineCargoFields(itemGrid.newRowsAdded[Math.abs(y)-1]);
						}
						itemGrid.keys.removeFocus(itemGrid.keys._nCurrentFocus, true);
						itemGrid.keys.releaseKeys();
						itemGrid.keys._nOldFocus = null;
						validateItemTableGrid();
					},
					onCellBlur : function(element, value, x, y, id) {
						observeClmItemChangeTag();
					},onRemoveRowFocus: function(element, value, x, y, id){
						if (y >= 0){
							if (checkClmItemChanges()){
								populateMarineCargoFields(null);
							}
						}else{
							populateMarineCargoFields(null);
						}
						validateItemTableGrid();
					},toolbar: {
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
					  	visible: false 
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
				 	},{
						id: 'lastUpdate',
					  	width: '0',
					  	visible: false 
				 	},
				 	{
						id: 'lossDate',
					  	width: '0',
					  	visible: false 
				 	},{
						id: 'geogCd',
					  	width: '0',
					  	visible: false 
				 	},{
						id: 'cargoClassCd',
					  	width: '0',
					  	visible: false 
				 	},{
						id: 'voyageNo',
					  	width: '0',
					  	visible: false 
				 	},{
						id: 'blAwb',
					  	width: '0',
					  	visible: false 
				 	},{
						id: 'origin',
					  	width: '0',
					  	visible: false 
				 	},{
						id: 'destn',
					  	width: '0',
					  	visible: false 
				 	},{
						id: 'etd',
					  	width: '0',
					  	visible: false 
				 	},{
						id: 'eta',
					  	width: '0',
					  	visible: false 
				 	},{
						id: 'strEtd',
					  	width: '0',
					  	visible: false 
				 	},{
						id: 'strEta',
					  	width: '0',
					  	visible: false 
				 	},
				 	{
						id: 'cargoType',
					  	width: '0',
					  	visible: false 
				 	},{
						id: 'deductText',
					  	width: '0',
					  	visible: false 
				 	},{
						id: 'packMethod',
					  	width: '0',
					  	visible: false 
				 	},{
						id: 'transhipOrigin',
					  	width: '0',
					  	visible: false 
				 	},{
						id: 'transhipDestination',
					  	width: '0',
					  	visible: false 
				 	},{
						id: 'vesselName',
					  	width: '0',
					  	visible: false 
				 	},{
						id: 'vesselCd',
					  	width: '0',
					  	visible: false 
				 	},{
						id: 'geogDesc',
					  	width: '0',
					  	visible: false 
				 	},{
						id: 'cargoClassDesc',
					  	width: '0',
					  	visible: false 
				 	},{
						id: 'cargoTypeDesc',
					  	width: '0',
					  	visible: false 
				 	},{
						id: 'lcNo',
					  	width: '0',
					  	visible: false 
				 	},{
						id: 'itemNo',
						title: 'Item No',
				        width: '60',
				        type: 'number',
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
					  	width: '94',
					  	geniisysClass: 'rate',
			            deciRate: 9,
					  	filterOption: true
				 	},{
						id: 'giclItemPerilExist',
					  	width: '0',
					  	visible: false 
				 	},{
						id: 'giclMortgageeExist',
					  	width: '0',
					  	visible: false 
				 	},{
						id: 'giclItemPerilMsg',
					  	width: '0',
					  	visible: false 
				 	},{
						id: 'cpiRecNo',
					  	width: '0',
					  	visible: false 
				 	},
				 	{
						id: 'cpiBranchCd',
					  	width: '0',
					  	visible: false 
				 	}
				],
				resetChangeTag: true,
				requiredColumns: '',
				rows : objCLMItem.objGiclCargoDtl 			
			};
			itemGrid = new MyTableGrid(tableModel);
			itemGrid.pager = objCLMItem.objItemTableGrid;
			itemGrid.render('marineCargoItemInfogrid');	
		
		//for item no. focus event
		observeClmItemNoFocus();
		
		//for item no. blur event
		observeClmItemNoBlur();
		
		//LOV for item no. 
		observeClmItemNoLOV();
		
		//for add button observe
		observeClmAddItem();
		
		//for delete button observe
		observeClmDeleteItem();
		
		//for main button
		observeClmItemMainBtn();
		
		window.scrollTo(0,0); 	
		hideNotice("");
		setModuleId("GICLS019");
		setDocumentTitle("Item Information - Marine Cargo");
	}catch(e){
		showErrorMessage("marineCargoItemInfo.jsp", e);
	}
</script>
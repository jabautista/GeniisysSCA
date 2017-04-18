<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="accidentItemInfoMainDiv" name="accidentItemInfoMainDiv" style="margin-top: 1px;">
	<form id="accidentItemInfoForm" name="accidentItemInfoForm">
		<jsp:include page="/pages/claims/subPages/claimInformation.jsp"></jsp:include>
		<jsp:include page="/pages/claims/claimItemInfo/accident/subPages/accidentAddtlInfo.jsp"></jsp:include>
		<jsp:include page="/pages/claims/claimItemInfo/accident/subPages/beneficiaryDetails.jsp"></jsp:include>
		<jsp:include page="/pages/claims/claimItemInfo/accident/subPages/availments.jsp"></jsp:include>
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
		
		objCLMItem.objItemTableGrid = JSON.parse('${giclAccidentDtlGrid}'.replace(/\\/g, '\\\\'));
		objCLMItem.objGiclAccidentDtl  = objCLMItem.objItemTableGrid.rows;
		
		var tableModel = {
				url: contextPath+"/GICLAccidentDtlController?action=getAccidentItemDtl&claimId="+objCLMGlobal.claimId,
				options : {
					hideColumnChildTitle: true,
					onCellFocus: function(element, value, x, y, id){
						if (y >= 0){
							if (checkClmItemChanges()){
								objCLMItem.selItemIndex = String(y);
								populateAccidentFields(itemGrid.rows[y]);
							}
						}else{
							objCLMItem.selItemIndex = String(y);
							populateAccidentFields(itemGrid.newRowsAdded[Math.abs(y)-1]);
							if (objCLMItem.benCount == 1){
								fireEvent($("groBenInfo"), "click");
							}
						}
						itemGrid.keys.removeFocus(itemGrid.keys._nCurrentFocus, true);
						itemGrid.keys.releaseKeys();
						itemGrid.keys._nOldFocus = null;
					},
					onCellBlur : function(element, value, x, y, id) {
						observeClmItemChangeTag();  
					},
					onRemoveRowFocus: function(element, value, x, y, id){
						if (y >= 0){
							if (checkClmItemChanges()){
								populateAccidentFields(null);
							}
						}else{
							populateAccidentFields(null);
						}
						showHideItemNoDate();
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
						id: 'groupedItemNo',
					  	width: '0',
					  	visible: false 
					},
					{
						id: 'groupedItemTitle',
					  	width: '0',
					  	visible: false 
					},
					{
						id: 'currencyCd',
					  	width: '0',
					  	visible: false 
				 	},
				 	{
						id: 'positionCd',
					  	width: '0',
					  	visible: false 
					},
					{
						id: 'dspPosition',
					  	width: '0',
					  	visible: false 
				 	},
				 	{
						id: 'monthlySalary',
					  	width: '0',
					  	visible: false 
					},
					{
						id: 'dspControlType',
					  	width: '0',
					  	visible: false 
				 	},
					{
						id: 'controlCd',
					  	width: '0',
					  	visible: false 
				 	},
				 	{
						id: 'controlTypeCd',
					  	width: '0',
					  	visible: false 
				 	},
				 	{
						id: 'amountCoverage',
					  	width: '0',
					  	visible: false 
				 	},
				 	{
						id: 'levelCd',
					  	width: '0',
					  	visible: false 
				 	},
				 	{
						id: 'salaryGrade',
					  	width: '0',
					  	visible: false 
				 	},
				 	{
						id: 'dateOfBirth',
					  	width: '0',
					  	visible: false 
				 	},
				 	{
						id: 'civilStatus',
					  	width: '0',
					  	visible: false 
				 	},
				 	{
						id: 'dspCivilStat',
					  	width: '0',
					  	visible: false 
				 	},
				 	{
						id: 'sex',
					  	width: '0',
					  	visible: false 
				 	},
				 	{
						id: 'dspSex',
					  	width: '0',
					  	visible: false 
				 	},
				 	{
						id: 'age',
					  	width: '0',
					  	visible: false 
				 	},
				 	{
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
						width : 310,
						children : [
				            {
				                id : 'itemDesc',
				                width : 155,
				                filterOption: true
				            },
				            {
				                id : 'itemDesc2', 
				                width : 155,
				                filterOption: true
				            }
						]
					},
				 	{
						id: 'dspCurrency',
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
				],
				resetChangeTag: true,
				requiredColumns: '',
				rows : objCLMItem.objGiclAccidentDtl, 	
				id: 1
			};
			itemGrid = new MyTableGrid(tableModel);
			itemGrid.pager = objCLMItem.objItemTableGrid;
			itemGrid._mtgId = 1;
			itemGrid.render('accidentItemInfogrid');
	
		//for item no. focus event
		observeClmItemNoFocus();
		
		//for group item no. focus event
		observeClmGrpItemNoFocus();
				
		//for item no. blur event
		observeClmItemNoBlur();
		
		//for group item no. blur event
		observeClmGrpItemNoBlur();
		
		//LOV for item no. 
		observeClmItemNoLOV();
		
		//LOV for grouped item no. 
		observeClmGrpItemNoLOV();
		
		//for add button observe
		observeClmAddItem();
		
		//for delete button observe
		observeClmDeleteItem();
		
		//for main button
		observeClmItemMainBtn();
	
		//for attached media
		//observeClmItemAttachMedia(); // SR-21674 JET NOV-25-2016
		
		showHideItemNoDate(); 	
		
		window.scrollTo(0,0); 	
		hideNotice("");
		setModuleId("GICLS017");
		setDocumentTitle("Item Information - Personal Accident");
	}catch(e){
		showErrorMessage("accidentItemInfo", e);
	}

</script>

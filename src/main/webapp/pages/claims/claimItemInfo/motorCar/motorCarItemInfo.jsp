<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="motorcarItemInfoTempDiv"></div>
<div id="motorcarItemInfoMainDiv" name="motorcarItemInfoMainDiv" style="margin-top: 1px;">
	<form id="motorcarItemInfoForm" name="motorcarItemInfoForm">
		<jsp:include page="/pages/claims/subPages/claimInformation.jsp"></jsp:include>
		<jsp:include page="/pages/claims/claimItemInfo/motorCar/subPages/motorCarAddtlInfo.jsp"></jsp:include>
		<%-- <jsp:include page="/pages/claims/claimItemInfo/motorCar/subPages/motorCarDriverDetails.jsp"></jsp:include> Removed by J. Diago 10.11.2013 to be replaced with block style hide/show jsp --%>
		<jsp:include page="/pages/claims/claimItemInfo/motorCar/subPages/driverInfo.jsp"></jsp:include>
		<jsp:include page="/pages/claims/claimItemInfo/peril/perilInfo.jsp"></jsp:include>
		<jsp:include page="/pages/claims/claimItemInfo/mortgagee/mortgageeInfo.jsp"></jsp:include>
		<jsp:include page="/pages/claims/claimItemInfo/peril/perilStatus.jsp"></jsp:include>
		<div class="buttonsDiv" >
			<input type="button" id="btnMcEvaluation"	name="btnMcEvaluation" class="button"	value="MC Evaluation Report" />
			<input type="button" id="btnAttachViewPic"	name="btnAttachViewPic" class="button"	value="Attach/View Pictures" />
			<!-- <input type="button" id="btnThirdAverseParty"	name="btnThirdAverseParty" class="disabledButton"	value="Third/Adverse Party" disabled="disabled"/>  Removed by J. Diago 10.11.2013 QA SR 321-->
			<input type="button" id="btnThirdAverseParty"	name="btnThirdAverseParty" class="button" value="Third/Adverse Party"/> <!-- Added by J. Diago 10.11.2013 QA SR 321 -->
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
		
		objCLMItem.objItemTableGrid = JSON.parse('${giclMotorCarDtlGrid}'.replace(/\\/g, '\\\\'));
		objCLMItem.objGiclMotorCarDtl = objCLMItem.objItemTableGrid.rows;
		objCLMItem.ora2010Sw = ('${ora2010Sw}'); // Added by J. Diago 10.11.2013 QA SR 321
		
		function getGiclMcTpDtl(obj){
		    var contentHTML = '<div id="modal_content_mc_tp_dtl"></div>';
					  
			winWorkflow = Overlay.show(contentHTML, {
				id: 'modal_dialog_mcTpDtl',
				title: "Third Party/Adverse Party", //add title in overlay of Third/Adverse Party by MAC 07/18/2013.
				width: 780,
				height: 500,
				draggable: true
				//closable: true
			});
			new Ajax.Updater("modal_content_mc_tp_dtl", contextPath+"/GICLMotorCarDtlController?action=getGiclMcTpDtl&claimId="+objCLMGlobal.claimId+"&itemNo="+obj.itemNo+"&sublineCd="+objCLMGlobal.sublineCd, {
				evalScripts: true,
				asynchronous: false,
				onComplete: function (response) {			
					if (!checkErrorOnResponse(response)) {
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		}
		
		$("btnThirdAverseParty").observe("click", function(){
			if (nvl(objCLMItem.selItemIndex,null) == null){
				showMessageBox("Please select item first.", "I");
				return false;
			}
			
			getGiclMcTpDtl(objCLMItem.objGiclMotorCarDtl[objCLMItem.selItemIndex]);
		});
		
		var tableModel = {
			url: contextPath+"/GICLMotorCarDtlController?action=getMotorCarItemDtl&claimId="+objCLMGlobal.claimId,
			options : {
				hideColumnChildTitle: true,
				onCellFocus: function(element, value, x, y, id){
					if (y >= 0){
						if (checkClmItemChanges()){
							objCLMItem.selItemIndex = String(y);
							objCLMGlobal.currMcItem = y;
							populateMotorCarFields(itemGrid.rows[y]);
							enableButton("btnThirdAverseParty");							
							var obj = itemGrid.rows[y];
							enableButton("btnThirdAverseParty");
						}
					}else{
						objCLMItem.selItemIndex = String(y);
						objCLMGlobal.currMcItem = Math.abs(y)-1;
						populateMotorCarFields(itemGrid.newRowsAdded[Math.abs(y)-1]);						
					}
					if(objCLMGlobal.driverInfoPopulateSw == "Y"){
						enableButton("btnApplyChanges"); 	
					}
					//enableButton("btnApplyChanges"); // andrew 04.20.2012
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
							populateMotorCarFields(null);
						}
					}else{
						populateMotorCarFields(null);
					}
					objCLMGlobal.currMcItem = null;
					//disableButton("btnThirdAverseParty");
					if(objCLMGlobal.driverInfoPopulateSw == "Y"){
						disableButton("btnApplyChanges");	
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
					id: 'motorNo',
				  	width: '0',
				  	visible: false 
				},{
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
					id: 'modelYear',
				  	width: '0',
				  	visible: false 
			 	},
			 	{
					id: 'plateNo',
				  	width: '0',
				  	visible: false 
			 	},
			 	{
					id: 'drvrOccCd',
				  	width: '0',
				  	visible: false 
			 	},
			 	{
					id: 'drvrOccDesc',
				  	width: '0',
				  	visible: false 
			 	},
			 	{
					id: 'mvFileNo',
				  	width: '0',
				  	visible: false 
			 	},
			 	{
					id: 'drvrName',
				  	width: '0',
				  	visible: false 
			 	},
			 	{
					id: 'drvrSex',
				  	width: '0',
				  	visible: false 
			 	},
			 	{
					id: 'drvrAge',
				  	width: '0',
				  	visible: false 
			 	},
			 	{
					id: 'motcarCompCd',
				  	width: '0',
				  	visible: false 
			 	},
			 	{
					id: 'makeCd',
				  	width: '0',
				  	visible: false 
			 	},
			 	{
					id: 'color',
				  	width: '0',
				  	visible: false 
			 	},
			 	{
					id: 'sublineTypeCd',
				  	width: '0',
				  	visible: false 
			 	},
			 	{
					id: 'basicColorCd',
				  	width: '0',
				  	visible: false 
			 	},
			 	{
					id: 'colorCd',
				  	width: '0',
				  	visible: false 
			 	},
			 	{
					id: 'serialNo',
				  	width: '0',
				  	visible: false 
			 	},
			 	{
					id: 'lossDate',
				  	width: '0',
				  	visible: false 
			 	},{
					id: 'currencyCd',
				  	width: '0',
				  	visible: false 
			 	},
			 	{
					id: 'motType',
				  	width: '0',
				  	visible: false 
			 	},
			 	{
					id: 'seriesCd',
				  	width: '0',
				  	visible: false 
			 	},
			 	{
					id: 'currencyRate',
				  	width: '0',
				  	visible: false 
			 	},
			 	{
					id: 'noOfPass',
				  	width: '0',
				  	visible: false 
			 	},
			 	{
					id: 'towing',
				  	width: '0',
				  	visible: false 
			 	},
			 	{
					id: 'drvrAdd',
				  	width: '0',
				  	visible: false 
			 	},
			 	{
					id: 'otherInfo',
				  	width: '0',
				  	visible: false 
			 	},
			 	{
					id: 'drvngExp',
				  	width: '0',
				  	visible: false 
			 	},
			 	{
					id: 'nationalityCd',
				  	width: '0',
				  	visible: false 
			 	},
			 	{
					id: 'nationalityDesc',
				  	width: '0',
				  	visible: false 
			 	},
			 	{
					id: 'relation',
				  	width: '0',
				  	visible: false 
			 	},
			 	{
					id: 'assignee',
				  	width: '0',
				  	visible: false 
			 	},
			 	{
					id: 'engineSeries',
				  	width: '0',
				  	visible: false 
			 	},
			 	{
					id: 'motTypeDesc',
				  	width: '0',
				  	visible: false 
			 	},
			 	{
					id: 'basicColor',
				  	width: '0',
				  	visible: false 
			 	},
			 	{
					id: 'makeDesc',
				  	width: '0',
				  	visible: false 
			 	},
			 	{
					id: 'motcarCompDesc',
				  	width: '0',
				  	visible: false 
			 	},
			 	{
					id: 'sublineTypeDesc',
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
					width : 270,
					children : [
			            {
			                id : 'itemDesc',
			                width : 135,
			                filterOption: true
			            },
			            {
			                id : 'itemDesc2', 
			                width : 135,
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
				  	width: '92',
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
			rows : objCLMItem.objGiclMotorCarDtl 			
		};
		itemGrid = new MyTableGrid(tableModel);
		itemGrid.pager = objCLMItem.objItemTableGrid;
		itemGrid.render('motorCarItemInfogrid');	
		
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
		
		$("btnMcEvaluation").observe("click", function(){
			
			/* niel SR-5954 03/15/2017 */
			if (checkUserModule("GICLS070") == false) {
				showMessageBox("You have no access for this module.", "I");
				return false;
			}
			/* end */
			
			if(changeTag == 1){
				showMessageBox(objCommonMessage.SAVE_CHANGES,"I");
			} else {
				/* objCLMGlobal.callingForm = "GICLS070"; 
				updateMainContentsDiv("/GICLMcEvaluationController?action=showMcEvaluationReport",
				"Getting MC Evaluation Report, please wait...");
				$("mainNav").hide(); */
							
				if (nvl(objCLMItem.selItemIndex,null) == null){
					showMessageBox("Please select item first.", "I");
					return false;
				}
					
				showMcEvaluationReport("itemInfo");
			}
		});
		
		window.scrollTo(0,0); 	
		hideNotice("");
		setModuleId("GICLS014");
		setDocumentTitle("Item Information - Motor Car");
	}catch (e){
		showErrorMessage("motorCarItemInfo.jsp",e );
	}
</script>
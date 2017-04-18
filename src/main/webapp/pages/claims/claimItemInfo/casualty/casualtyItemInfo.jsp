<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="casualtyItemInfoMainDiv" name="casualtyItemInfoMainDiv" style="margin-top: 1px;"> 
	<form id="casualtyItemInfoForm" name="casualtyItemInfoForm">
		<jsp:include page="/pages/claims/subPages/claimInformation.jsp"></jsp:include>
		<jsp:include page="/pages/claims/claimItemInfo/casualty/subPages/subCasualtyItemInfo.jsp"></jsp:include>
		<jsp:include page="/pages/claims/claimItemInfo/casualty/subPages/subPersonnelInfo.jsp"></jsp:include>
		<jsp:include page="/pages/claims/claimItemInfo/peril/perilInfo.jsp"></jsp:include>
		<%-- <jsp:include page="/pages/claims/claimItemInfo/mortgagee/mortgageeInfo.jsp"></jsp:include>  --%>
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
	disableButton("btnDeleteItem");
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	//initializeChangeTagBehavior(saveClmItemPerLine);
	//initializeChangeTagBehavior(savePackageQuotation);
	
	objCLMItem.objectItemTableGrid = JSON.parse('${casualtyItemInfo}'.replace(/\\/g,'\\\\'));
	objCLMItem.objGiclCasualtyDtl = objCLMItem.objectItemTableGrid.rows;
	objCLMItem.ora2010SwCA = ('${ora2010Sw}');	
	objCLMItem.vLocLossCA = ('${vLocLoss}'); 
	
	var tableModel = {
		url: contextPath+"/GICLCasualtyDtlController?action=getCasualtyDtl&ajax=0&claimId="+objCLMGlobal.claimId,
		options: {
			hideColumnChildTitle: true,
			newRowPosition: 'bottom',
			pager: { 
			},
			onCellFocus: function(element, value, x, y, id){
				if (y >= 0){
					if (checkClmItemChanges()){
						objCLMItem.selItemIndex = String(y);
						supplyClmCasualtyItem(itemGrid.rows[y]);
						$("txtAmtCov").readOnly = true;
						validateItemTableGrid();
					}
				}else{
					objCLMItem.selItemIndex = String(y);
					supplyClmCasualtyItem(itemGrid.newRowsAdded[Math.abs(y)-1]);	
					$("txtAmtCov").readOnly = true;
					validateItemTableGrid();
				}	
				itemGrid.keys.removeFocus(itemGrid.keys._nCurrentFocus, true);
				itemGrid.keys.releaseKeys();
				itemGrid.keys._nOldFocus = null;
			},
			onCellBlur : function(element, value, x, y, id) {
				observeClmItemChangeTag();
			},
			onRemoveRowFocus: function(element, value, x, y, id) {
				 if (y >= 0){
					if (checkClmItemChanges()){
						supplyClmCasualtyItem(null);
						//$("groupNoDate").show();
						validateItemTableGrid();
					}
				}else{
					supplyClmCasualtyItem(null);
					//$("groupNoDate").show();
					validateItemTableGrid();
				}	 
			},
			 toolbar: {
				 onSave: function(){
					return saveClmItemPerLine();
				},
				postSave: function(){
					showClaimItemInfo();
				} 
			}, 
			onComplete: function(response){
				obj = JSON.parse(response.responseText.replace(/\\/g,'\\\\'));
				supplyClmCasualtyItem(obj);
			}
		},
			columnModel:[
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
				{   id: 'recordStatus',							    
				    width: '0',
				    visible: false,
				    editor: 'checkbox' 			
				},
				{	id: 'divCtrId',
					width: '0',
					visible: false
				},
				{
					id: 'itemNo',
					title: 'Item No',
					align: 'right',
					titleAlign: 'right',
					width: '70px',
					renderer: function (value){
						return nvl(value,'') == '' ? '' :formatNumberDigits(value,9);
					}
				},
				{
					id: 'itemTitle',
					title: 'Item Title',
					width: '150px'
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
					id: 'currencyDesc',
					width: '0',
					visible: false
				},
				{
					id: 'propertyNoType',
					width: '0',
					visible: false
				},
				{
					id: 'propertyNo',
					width: '0',
					visible: false
				},
				{
					id: 'currencyRate',
					width: '0',
					visible: false
				},
				{
					id: 'location',
					width: '0',
					visible: false
				},
				{
					id: 'sectionOrHazardCd',
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
					id: 'sectionOrHazardInfo',
					width: '0',
					visible: false
				},
				{
					id: 'conveyanceInfo',
					width: '0',
					visible: false
				},
				{
					id: 'interestOnPremises',
					width: '0',
					visible: false
				},
				{
					id: 'amountCoverage',
					width: '0',
					visible: false
				},
				{
					id: 'limitOfLiability',
					width: '0',
					visible: false
				},
				{
					id: 'capacityCd',
					width: '0',
					visible: false
				},
				{
					id: 'position',
					width: '0',
					visible: false
				},
				{
					id: 'positionDesc',
					width: '0',
					visible: false
				},
				{
					id: 'personnelName',
					width: '0',
					visible: false
				},
				{
					id: 'itemDesc itemDesc2',
					title: 'Description',
					width : 294,
					children : [
			            {
			                id : 'itemDesc',
			                width : 147,
			                filterOption: true
			            },
			            {
			                id : 'itemDesc2', 
			                width : 147,
			                filterOption: true
			            }
					]
				},
				{
					id:'currencyDesc',
					title:'Currency',
					width: '100px',
					align: 'right'
				},
				{
					id: 'giclItemPerilMsg',
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
					id:'currencyRate',
					title: 'Rate',
					width: '100px',
					align: 'right',
					titleAlign: 'right',
					renderer: function(value){
						return formatToNineDecimal(value);
					}
				},
				{
					id: 'itm',
					width: '0',
					visible: false
				}
             ],
             resetChangeTag: true,
     		 requiredColumns: '',
     		 rows: objCLMItem.objGiclCasualtyDtl
	};
		itemGrid = new MyTableGrid(tableModel);
		itemGrid.pager = objCLMItem.objectItemTableGrid;
		itemGrid.afterRender = function(){
			//objCLMItem.objGiclCasualtyDtl.length > 0 ? casualtyEvent($("mtgC"+itemGrid._mtgId+"_41,0"), "click") :null;
			changeTag = 0;
			initializeChangeTagBehavior(function(){saveClaimsItemGrid(true);});
		};	
		
		itemGrid._mtgId = 1;
		itemGrid.render('addtlCaInfoGrid');
		
		
		
		
		//for item no. focus event
		observeClmItemNoFocus();		
		
		//for item no. blur event
		observeClmItemNoBlur();		
		
		//for delete button observe
		observeClmDeleteItem();
		
		//for add button observe
		observeClmAddItem(); 
		
		//LOV for item no. - casualty
		$("itemNoDate").observe("click", function(){
			$("txtAmtCov").readOnly = false;
			if (objCLMItem.selected != {} || objCLMItem.selected != null) if (unescapeHTML2(objCLMItem.selected[itemGrid.getColumnIndex('giclItemPerilExist')]) == "Y") return;
			showClmItemNoLOV(itemGrid.createNotInParam("itemNo"), "getClmCaItemLOV");
		});
		
		$("groupNoDate").observe("click", function(){
			//$("txtGrpCd").readOnly = false;
			//if (objCLMItem.selected != {} || objCLMItem.selected != null) if (unescapeHTML2(objCLMItem.selected[itemGrid.getColumnIndex('giclItemPerilExist')]) == "Y") return;
			//showClmItemNoLOV(itemGrid.createNotInParam("itemNo"), "getClmCaItemLOV");
			if($F("txtItemNo") == ""){
				showMessageBox("Item No. is required.","I");
				return false;
			}
			showGroupLOV();
		});
		
		$("txtGrpCd").observe("focus",function(){
			if($F("txtItemNo") == ""){
				showMessageBox("Item No. is required.","I");
			}
		});
		
		$("txtGrpCd").observe("change",function(){
			if(this.value == ""){
				$("txtAmtCov").value = "";
				$("txtDspGrpDesc").value = "";
			}else{
				validateGroupItemNo();
			}
		});
		//validateItemTableGrid();
		
		//for main button
		observeClmItemMainBtn();
		
		window.scrollTo(0,0); 	
		hideNotice("");
		setModuleId("GICLS016");
		setDocumentTitle("Item Information - Casualty");
}
catch(e){
	showErrorMessage("casualtyItemInfo.jsp" ,e);
	
}
</script>
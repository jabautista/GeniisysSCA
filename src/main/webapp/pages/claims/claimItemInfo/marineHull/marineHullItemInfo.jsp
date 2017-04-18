<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="marineHullItemInfoMainDiv" name="marineHullItemInfoMainDiv" style="margin-top: 1px;"> 
	<form id="marienHullItemInfoForm" name="marienHullItemInfoForm">
		<jsp:include page="/pages/claims/subPages/claimInformation.jsp"></jsp:include>
		<jsp:include page="/pages/claims/claimItemInfo/marineHull/subPages/subMarineHullItemInfo.jsp"></jsp:include>
		<!--<jsp:include page="/pages/claims/claimItemInfo/casualty/subPages/subPersonnelInfo.jsp"></jsp:include> -->
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
	disableButton("btnDeleteItem");
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	
	//initializeChangeTagBehavior(savePackageQuotation);
	
	objCLMItem.objectItemTableGrid = JSON.parse('${marineHullItemInfo}'.replace(/\\/g,'\\\\'));
	objCLMItem.objGiclMarineHullDtl = objCLMItem.objectItemTableGrid.rows;
	objCLMItem.ora2010Sw = ('${ora2010Sw}');	
	objCLMItem.vLocLoss = ('${vLocLoss}'); 
	var tableModel = {
		url: contextPath+"/GICLMarineHullDtlController?action=getMarineHullDtl&ajax=0&claimId="+objCLMGlobal.claimId,
		options: {
			hideColumnChildTitle: true,
			newRowPosition: 'bottom',
			pager: { 
			},
			onCellFocus: function(element, value, x, y, id){
				if (y >= 0){
					if (checkClmItemChanges()){
						objCLMItem.selItemIndex = String(y);
						supplyClmMarineHullItem(itemGrid.rows[y]);
					}
				}else{
					objCLMItem.selItemIndex = String(y);
					supplyClmMarineHullItem(itemGrid.newRowsAdded[Math.abs(y)-1]);
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
						supplyClmMarineHullItem(null);
						validateItemTableGrid();
					}
				}else{
					supplyClmMarineHullItem(null);
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
				supplyClmMarineHullItem(obj);
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
				 	editable: true, 	
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
					width: '70px',
					align: 'right',
					titleAlign: 'right',
					renderer: function (value){
						return nvl(value,'') == '' ? '' :formatNumberDigits(value,9);
					}
				},
				{
					id: 'itemTitle',
					title: 'Item Title',
					width: '151px'
				},
				{
					id: 'itemDesc itemDesc2',
					title: 'Description',
					width : 176,
					children : [
			            {
			                id : 'itemDesc',
			                width : 138,
			                filterOption: true
			            },
			            {
			                id : 'itemDesc2', 
			                width : 138,
			                filterOption: true
			            }
					]
				},
				{
					id:'currencyDesc',
					title:'Currency',
					width: '100px',
					align: 'right',
					titleAlign: 'right'
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
					id: 'lastUpdate',
					width: '0',
					visible: false
				},
				{
					id: 'vesselCd',
					width: '0',
					visible: false
				},
				{
					id: 'geogLimit',
					width: '0',
					visible: false
				},
				{
					id: 'deductText',
					width: '0',
					visible: false
				},
				{
					id: 'dryPlace',
					width: '0',
					visible: false
				},
				{
					id: 'dryDate',
					width: '0',
					visible: false
				},
				{
					id: 'lossDate',
					width: '0',
					visible: false
				},
				{
					id: 'vesselName',
					width: '0',
					visible: false
				},
				{
					id: 'vestypeCd',
					width: '0',
					visible: false
				},
				{
					id: 'vesselOldName',
					width: '0',
					visible: false
				},
				{
					id: 'propelSw',
					width: '0',
					visible: false
				},
				{
					id: 'hullTypeCd',
					width: '0',
					visible: false
				},
				{
					id: 'regOwner',
					width: '0',
					visible: false
				},
				{
					id: 'regPlace',
					width: '0',
					visible: false
				},
				{
					id: 'grossTon',
					width: '0',
					visible: false
				},
				{
					id: 'netTon',
					width: '0',
					visible: false
				},
				{
					id: 'deadweight',
					width: '0',
					visible: false
				},
				{
					id: 'yearBuilt',
					width: '0',
					visible: false
				},
				{
					id: 'vessClassCd',
					width: '0',
					visible: false
				},
				{
					id: 'crewNat',
					width: '0',
					visible: false
				},
				{
					id: 'noCrew',
					width: '0',
					visible: false
				},
				{
					id: 'vesselLength',
					width: '0',
					visible: false
				},
				{
					id: 'vesselBreadth',
					width: '0',
					visible: false
				},
				{
					id: 'vestypeDesc',
					width: '0',
					visible: false
				},
				{
					id: 'vesselDepth',
					width: '0',
					visible: false
				},
				{
					id: 'hullDesc',
					width: '0',
					visible: false
				},
				{
					id: 'vessClassDesc',
					width: '0',
					visible: false
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
				}
             ],
             resetChangeTag: true,
     		 requiredColumns: '',
     		 rows: objCLMItem.objGiclMarineHullDtl
	};
		itemGrid = new MyTableGrid(tableModel);
		itemGrid.pager = objCLMItem.objectItemTableGrid;
		itemGrid.afterRender = function(){
			changeTag = 0;
			initializeChangeTagBehavior(function(){saveClaimsItemGrid(false);});
		};
		
		supplyClmMarineHullItem(null);
		
		itemGrid._mtgId = 1;
		itemGrid.render('addtlMHInfoGrid');
		
		window.scrollTo(0,0); 	
		hideNotice("");
		setModuleId("GICLS022");
		setDocumentTitle("Item Information - Marine Hull");
		
		
		//for item no. focus event
		observeClmItemNoFocus();		
		
		//for item no. blur event
		observeClmItemNoBlur();		
		
		//for delete button observe
		observeClmDeleteItem();
		
		
		//for add button observe
		observeClmAddItem(); 
		
		validateItemTableGrid();
		
		//LOV for item no. - marine hull
		$("itemNoDate").observe("click", function(){
			if (objCLMItem.selected != {} || objCLMItem.selected != null) if (unescapeHTML2(objCLMItem.selected[itemGrid.getColumnIndex('giclItemPerilExist')]) == "Y") return;
			showClmItemNoLOV(itemGrid.createNotInParam("itemNo"), "getClmMHItemLOV");
		});
		
		
		//for main button
	    observeClmItemAttachMedia();
		observeReloadForm("reloadForm", showClaimItemInfo);
		observeSaveForm("btnSave", function(){saveClaimsItemGrid(true);});
		observeCancelForm("btnCancel", function(){saveClaimsItemGrid(false);}, showClaimListing);
		
}
catch(e){
	showErrorMessage("marineHullItemInfo.jsp" ,e);
	
} 
</script>
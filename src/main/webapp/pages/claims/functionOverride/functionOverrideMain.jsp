<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>  
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="functionOverrideMainDiv">
	<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="functionOverrideExit">Exit</a></li>
				</ul>
			</div>
		</div>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Function Override</label>
		</div>
	</div>
	
	<div id="functionOverrideTGDiv" name="functionOverrideTGDiv" style="height: 470px">
		<div id="tableGridFunctionsDiv" name="tableGridFunctionsDiv" class="sectionDiv">
			<div id="functionListingTGDiv" name="functionListingTGDiv" style="padding: 10px 20px 40px 100px; height: 150px; width: 79%;"></div>			
		</div>
		
		
		<div id="tableGridFunctionRecordsDiv" name="tableGridFunctionRecordsDiv">
			<!-- moved to functionOverrideRecordsListing.jsp
			<div id="functionOverrideRecordsTGDiv" style="padding: 20px 25px 20px 40px; height: 210px; width: 93%;"> -->
				<jsp:include page="/pages/claims/functionOverride/subPages/functionOverrideRecordsListing.jsp"></jsp:include> 
			<!--</div> 
			
			<div id="functionOverrideRecordsButtonDiv" name="functionOverrideRecordsButtonDiv" class="buttonsDiv" style="margin-bottom: 10px;">
				<input id="btnApproveFunctOverride" name="btnApproveFunctOverride" type="button" class="button" value="Approve" style="width: 90px;">
			</div>		-->
		</div>
	</div>
	
</div>


<script type="text/javascript">
	setModuleId("GICLS183");
	setDocumentTitle("Function Override");
	changeTag = 0;
	disableButton("btnApproveFunctOverride");
	initializeAll();
	objGICLS183.exitPage = null;

	var selectedIndex = -1;	//holds the selected index
	var selectedRowInfo = null;	//holds the selected row info
	
	var objFunctOverride = new Object();
	objFunctOverride.functOverrideTableGrid = JSON.parse('${functionOverrideGrid}'.replace(/\\/g, '\\\\'));
	objFunctOverride.functOverrideObjRows = objFunctOverride.functOverrideTableGrid.rows || [];
	objFunctOverride.functOverrideList = [];	// holds all the geniisys rows
	objCLM.hideGICLS183 = {};
	
	try {
		var functionOverrideTableModel = {
			url: contextPath+"/GICLFunctionOverrideController?action=getGICLS183FunctionListing",
			options: {
				width: '681px',
				height: '140px',
				onCellFocus: function(element, value, x, y, id) {
					if(checkChangesInGICLS183Remarks()/*changeTag == 1*/){
						functionListingTableGrid.keys.setFocus(functionListingTableGrid.keys._nOldFocus);
						showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
								function(){
									updateFunctionOverride(false);
									changeTag = 0;
									focusSelectedFunction(element, value, x, y, id);
									functionOverrideRecordsTableGrid.keys.releaseKeys();
									disableButton("btnApproveFunctOverride");
									functionListingTableGrid.keys.setFocus(functionListingTableGrid.keys._nOldFocus);
								},
								function(){
									functionListingTableGrid.keys.setFocus(functionListingTableGrid.keys._nOldFocus);
									changeTag = 0;
									focusSelectedFunction(element, value, x, y, id);
									disableButton("btnApproveFunctOverride");	
								},
								function(){
									functionListingTableGrid.rows[selectedIndex];
									//functionListingTableGrid.keys.setFocus(functionListingTableGrid.keys._nOldFocus);
								}
						);
					}else {
						focusSelectedFunction(element, value, x, y, id);
						disableButton("btnApproveFunctOverride");
					}

				},
				onRemoveRowFocus: function(){
					functionListingTableGrid.keys.releaseKeys();
					refreshFunctionRecords();				
					disableButton("btnApproveFunctOverride");
					selectedRowInfo = "";
					selectedIndex = -1;
					objCLM.hideGICLS183.moduleId = null;
					objCLM.hideGICLS183.functionCd = null;
				},		
				/*beforeSort: function(){
					//var objFunctions = functionOverrideRecordsTableGrid.getModifiedRows();
					if(checkChangesInGICLS183Remarks()){
						showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
							function(){
								updateFunctionOverride(false);
								functionListingTableGrid._refreshList();
								functionOverrideRecordsTableGrid.onRemoveRowFocus();
							},
							function(){	
								functionListingTableGrid._refreshList();
								functionOverrideRecordsTableGrid.onRemoveRowFocus();
							},
							""
						);
						return false;
					}else {
						return true;
					}
				},*/
				beforeSort : function(){
					if(checkChangesInGICLS183Remarks()/*changeTag == 1*/){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
				},
				prePager : function(){
					if(checkChangesInGICLS183Remarks()/*changeTag == 1*/){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
				},
				checkChanges : function() {
					return (checkChangesInGICLS183Remarks()/*changeTag == 1*/ ? true : false);
				},
				masterDetailRequireSaving : function() {
					return (checkChangesInGICLS183Remarks()/*changeTag == 1*/ ? true : false);
				},
				masterDetailValidation : function() {
					return (checkChangesInGICLS183Remarks()/*changeTag == 1*/ ? true : false);
				},
				masterDetail : function() {
					return (checkChangesInGICLS183Remarks()/*changeTag == 1*/ ? true : false);
				},
				masterDetailSaveFunc : function() {
					return (checkChangesInGICLS183Remarks()/*changeTag == 1*/ ? true : false);
				},
				masterDetailNoFunc : function() {
					return (checkChangesInGICLS183Remarks()/*changeTag == 1*/ ? true : false);
				},
				onSort: function(){
					functionListingTableGrid.onRemoveRowFocus();
					/*refreshFunctionRecords();				
					disableButton("btnApproveFunctOverride");*/
				},
				onRefresh: function(){
					//functionListingTableGrid.onRemoveRowFocus();
					refreshFunctionRecords();
					disableButton("btnApproveFunctOverride");
				},
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onFilter: function() {
						functionListingTableGrid.onRemoveRowFocus();
						refreshFunctionRecords();
						disableButton("btnApproveFunctOverride");
					},
				}
				
			},
			columnModel: [
							{
								id: 'recordStatus',
								width: '0px',
								visible: false,
								editor: 'checkbox'
							},
							{
								id: 'divCtrId',
								width: '0px',
								visible: false
							},
							{
								id: 'moduleId',
								width: '0px',
								visible: false
							},
							{
								id: 'moduleName',
								title: 'Module Name',
								width: '200px',
								titleAlign: 'center',
								visible: true,
								filterOption: true
							},
							{
								id: 'functionCd',
								width: '0px',
								visible: false
							},
							{
								id: 'functionName',
								title: 'Function Name',
								width: '450px',
								titleAlign: 'center',
								visible: true,
								sortable: true,
								filterOption: true
							}
						],
						rows: objFunctOverride.functOverrideObjRows
		};

		functionListingTableGrid = new MyTableGrid(functionOverrideTableModel);
		functionListingTableGrid.pager = objFunctOverride.functOverrideTableGrid;
		functionListingTableGrid.render('functionListingTGDiv');	
		functionListingTableGrid.afterRender = function() {
				objFunctOverride.functOverrideList = functionListingTableGrid.geniisysRows;
		};
		
	}catch (e) {
		showMessageBox("Error in Functions TableGrid: " + e, imgMessage.ERROR);
	}
	
	function refreshFunctionRecords(){
		functionOverrideRecordsTableGrid.url = contextPath+"/GICLFunctionOverrideController?action=getGICLS183FunctionOverrideRecordsListing"+
												"&functionCd=null";
		functionOverrideRecordsTableGrid._refreshList();
	}
	
	function focusSelectedFunction(element, value, x, y, id){
		selectedIndex = y;
		selectedRowInfo = functionListingTableGrid.geniisysRows[y];
		objCLM.hideGICLS183.moduleId = selectedRowInfo.moduleId;
		objCLM.hideGICLS183.functionCd = selectedRowInfo.functionCd;
		
		functionOverrideRecordsTableGrid.url = contextPath+"/GICLFunctionOverrideController?action=getGICLS183FunctionOverrideRecordsListing"
		  										+"&moduleId="+selectedRowInfo.moduleId+"&functionCd="+selectedRowInfo.functionCd;
		functionOverrideRecordsTableGrid.refreshURL(functionOverrideRecordsTableGrid);
		functionOverrideRecordsTableGrid.refresh();
		functionListingTableGrid.keys.releaseKeys();
	}
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");	
	}
	
	function cancelGicls183(){
		if (checkChangesInGICLS183Remarks()/*changeTag == 1*/) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGICLS183.exitPage = exitPage;
						updateFunctionOverride(false);
						changeTag = 0;
						functionOverrideRecordsTableGrid.onRemoveRowFocus();
					},
					function(){
						goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");	
						changeTag = 0;
						functionOverrideRecordsTableGrid.onRemoveRowFocus();
					}, 
					""
			);
		}else {
			changeTag = 0;
			functionOverrideRecordsTableGrid.onRemoveRowFocus();
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");	
		}
	}
	

	$("btnApproveFunctOverride").observe("click", function(){	
		showConfirmBox("Confirmation", "Are you sure you want to approve the selected record/s?", "Ok", "Cancel", function() {	
			updateFunctionOverride(true);
		});
	});
	
	$("functionOverrideExit").observe("click", cancelGicls183);
	
	$("btnCancel").observe("click", cancelGicls183);
	
</script>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>

<div id="packParListingTableGridMainDiv" name="packParListingTableGridMainDiv" module="packParListing">
	<div id="packParListingMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="packParListingExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label id="">List of Package Policy Action Records for ${lineName}</label>
			<input type="hidden" id="lineCd" name="lineCd" value="${lineCd}">
			<input type="hidden" id="menuLineCd" name="menuLineCd" value="${menuLineCd}">
			<input type="hidden" id="ora2010Sw" name="ora2010Sw" value="${ora2010Sw}">
			<input type="hidden" id="riSwitch" name="riSwitch" value="${riSwitch}" />
		</div>
	</div>

	<div id="packTableGridSectionDiv" class="sectionDiv" style="height: 370px;">
		<div id="packParTableGridDiv" style="padding: 10px;">
			<div id="packParTableGrid" style="height: 325px; width: 900px;"></div>
		</div>			
	</div>
</div>
<jsp:include page="/pages/underwriting/menus/basicInfoMenu.jsp"></jsp:include>
<div id="parInfoDiv" name="parInfoDiv" style="display: none;"></div>

<script type="text/javascript">
	setModuleId("GIPIS001A");
	setDocumentTitle("Package PAR Listing - Policy");
	initializePackPARBasicMenu("P", $F("lineCd"));
	clearObjectValues(objUWGlobal);
	clearObjectValues(objUWParList);
	clearObjectValues(objGIPIWPolbas);
	selectedIndex = -1;
	row = null;
	var objUser = JSON.parse('${user}');
	var directParOpenAccess = '${directParOpenAccess}';
	
	try{
		var objPackPar = new Object();
		objPackPar.objPackParListTableGrid = JSON.parse('${gipiPackParListTableGrid}');
		objPackPar.objPackParList = objPackPar.objPackParListTableGrid.rows || [];
				
		var packTableModel = {
				url: contextPath+"/GIPIPackPARListController?action=refreshPackParListing&lineCd="+encodeURIComponent($F("lineCd"))+
					 "&riSwitch="+encodeURIComponent($F("riSwitch")),
				options:{
					title: '',
					width: '900px',
					//querySort: false,
					onCellFocus: function(element, value, x, y, id){
						var mtgId = packTableGrid._mtgId;
						selectedIndex = -1;
						if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
							selectedIndex = y;
							row = y;
						}
						observeChangeTagInTableGrid(packTableGrid);
					},
					checkChanges: function(){
						return (changeTag == 1 ? true : false);
					},
					masterDetailRequireSaving: function(){
						return (changeTag == 1 ? true : false);
					},
					masterDetailValidation: function(){
						return (changeTag == 1 ? true : false);
					},
					masterDetail: function(){
						return (changeTag == 1 ? true : false);
					},
					masterDetailSaveFunc: function() {
						return (changeTag == 1 ? true : false);
					},
					masterDetailNoFunc: function(){
						return (changeTag == 1 ? true : false);
					},
					onCellBlur: function(){
						observeChangeTagInTableGrid(packTableGrid);
					},
					onRemoveRowFocus: function(){
						selectedIndex = -1;
					},
					beforeSort: function(){
		            	if (changeTag == 1){
							showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
							return false;
	                	}
	                },
					onRowDoubleClick: function(y){
						var underwriter = packTableGrid.geniisysRows[y].underwriter;
						packTableGrid.keys.removeFocus(packTableGrid.keys._nCurrentFocus, true);
						packTableGrid.keys.releaseKeys();
						observeChangeTagInTableGrid(packTableGrid);
						if(validateUserEntryForPAR(objUser, underwriter, directParOpenAccess)){
							objUWParList = packTableGrid.geniisysRows;
							if(changeTag == 1){
								showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
										function(){
											savePackParTableGrid();
											goToPackBasicInfo(y);
										}, 
										function(){
											goToPackBasicInfo(y);
											changeTag = 0;
										}, "");
								
							}else{
								goToPackBasicInfo(y);
								changeTag = 0;
							}
							//commented by: Nica 11.21.2011 - to prevent error 'element is null' in updatePackParameters
							//updatePackParParameters(); // andrew - 04.12.2011 - added this function call to update the parameters and enable/disable the menus
						}
					},
					toolbar: {
						elements: [MyTableGrid.ADD_BTN, MyTableGrid.SAVE_BTN, MyTableGrid.EDIT_BTN, MyTableGrid.DEL_BTN, MyTableGrid.CANCEL_BTN, MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
						onAdd: function(){
							packTableGrid.keys.removeFocus(packTableGrid.keys._nCurrentFocus, true);
							packTableGrid.keys.releaseKeys();
							observeChangeTagInTableGrid(packTableGrid);
							if(changeTag == 1){
								showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
										function(){
											packTableGrid.deleteRow(-1);
											savePackParTableGrid();
											packTableGrid.addNewRow();
											resetPackPARGlobalElements();
											if($F("riSwitch") == "Y") {
												showRIPackParCreationPage("0","P");
											} else {
												showPackPARCreationPage($F("lineCd"));
											}
										}, 
										function(){
											resetPackPARGlobalElements();
											if($F("riSwitch") == "Y") {
												showRIPackParCreationPage("0","P");
											} else { 
												showPackPARCreationPage($F("lineCd"));
											}
											changetag = 0;
										}, function() {
											packTableGrid.deleteRow(-1);
										});
								
							}else{
								resetPackPARGlobalElements();
								if($F("riSwitch") == "Y") {
									showRIPackParCreationPage("0","P");
								} else {
									showPackPARCreationPage($F("lineCd"));
								}
								changetag = 0;
							}
						},
						onEdit: function(){
							packTableGrid.keys.removeFocus(packTableGrid.keys._nCurrentFocus, true);
							packTableGrid.keys.releaseKeys();
							observeChangeTagInTableGrid(packTableGrid);
							if(selectedIndex >= 0){
								var underwriter = packTableGrid.geniisysRows[selectedIndex].underwriter;
								if(validateUserEntryForPAR(objUser, underwriter, directParOpenAccess)){
									objUWParList = packTableGrid.geniisysRows;
									if(changeTag == 1){
										showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
												function(){
													savePackParTableGrid();
													goToPackBasicInfo(row);
												}, 
												function(){
													goToPackBasicInfo(row);
													changetag = 0;
												}, "");
										
									}else{
										goToPackBasicInfo(row);
										changetag = 0;
									}
									//commented by: Nica 11.21.2011 - to prevent error 'element is null' in updatePackParameters
									//updatePackParParameters(); // andrew - 04.12.2011 - added this function call to update the parameters and enable/disable the menus
								}
							}else{
								showMessageBox("Please select a PAR.", imgMessage.ERROR);
							}
						},
						onSave: function(){
							packTableGrid.keys.removeFocus(packTableGrid.keys._nCurrentFocus, true);
							packTableGrid.keys.releaseKeys();
							//var delRows  	 = packTableGrid.getDeletedRows();
							var modifiedRows = packTableGrid.getModifiedRows();
							var objParameters = new Object();
							//objParameters.delRows = delRows;
							objParameters.setRows = modifiedRows;
							var strParameters = JSON.stringify(objParameters);
							var ok = updatePackParRemarks(strParameters);
						},
						postSave: function(){
							packTableGrid.clear();
							packTableGrid.refresh();
							changeTag = 0;
							selectedIndex = -1;
						},
						onDelete:function(){
							if(selectedIndex >= 0){
								var row = packTableGrid.geniisysRows[selectedIndex];
								var packParId = row.packParId;
								var parNo = row.parNo;
								var underwriter = row.underwriter;
								if(validateDeletePAR(objUser, underwriter)){
									checkRITablesBeforeDeletion(packParId, parNo);								
								}
							}else{
								showMessageBox("Please select a PAR.", imgMessage.ERROR);
								return false;
							}
						},
						onCancel: function(){
							if(selectedIndex >= 0){
								var row = packTableGrid.geniisysRows[selectedIndex];
								var packParId = row.packParId;
								var parNo = row.parNo;
								var parStatus = row.parStatus;
								var underwriter = row.underwriter;
								if(validateCancelPAR(objUser, underwriter)){
									checkRITablesBeforeCancel(packParId, parStatus, parNo);								
								}
							}else{
								showMessageBox("Please select a PAR.", imgMessage.ERROR);
							}
						}
					}
				},
				columnModel: [
					{
					    id: 'recordStatus',
					    title: '',
					    width: '0',
					    visible: false 			
					},
					{
						id: 'divCtrId',
						width: '0',
						visible: false
					},
					{
						id: 'packParId',
						width: '0',
						visible: false
					},
					{
						id: 'issCd',
						width: '0',
						title: 'Issue Code',
						visible: false,
						filterOption: true
					},
					{
						id: 'parYy',
						width: '0',
						title: 'Par Year',
						visible: false,
						filterOption: true,
						filterOptionType: 'integerNoNegative'
					},
					{
						id: 'parSeqNo',
						width: '0',
						title: 'Par Seq No.',
						visible: false,
						type: 'number',
						filterOption: true,
						filterOptionType: 'integerNoNegative'
					},
					{
						id: 'quoteSeqNo',
						width: '0',
						title: 'Quote Seq No.',
						visible: false,
						type: 'number',
						filterOption: true,
						filterOptionType: 'integerNoNegative'
					},
					{
						id: 'parNo',
						title: 'Par No.',
						width: '130px'
					},
					{
						id: 'assdName',
						title: 'Assured Name',
						width: '220px',
						filterOption: true
					},
					{
						id: 'underwriter',
						title: 'User Id',
						width: '80px',
						filterOption: true
					},
					{
						id: 'status',
						title: 'Status',
						width: '150px',
						filterOption: true
					},
					{
						id: 'remarks',
						title: 'Remarks',
						width: $F("ora2010Sw")== "Y" ? '180px' : '300px',
						editable: true,
						maxlength: 4000,
						editor: new MyTableGrid.EditorInput({
							onClick: function(){
							var coords = packTableGrid.getCurrentPosition();
							var x = coords[0];
							var y = coords[1];
							var title = "Remarks ("+ packTableGrid.geniisysRows[y].parNo+")";
								showTableGridEditor(packTableGrid, x, y, title, 4000, false);
							}
						})
					},
					{
						id: 'bankRefNo',
						title: 'Bank Ref No.',
						width: $F("ora2010Sw") == "Y" ? '120px' : '0',
						visible: $F("ora2010Sw")== "Y" ? true : false,
						filterOption: $F("ora2010Sw")== "Y" ? true : false 
					}
				],
				requiredColumns: 'packParId parNo underwriter status',
				resetChangeTag: true,
				rows: objPackPar.objPackParList	
		};
	
		packTableGrid = new MyTableGrid(packTableModel);
		packTableGrid.pager = objPackPar.objPackParListTableGrid;
		/*packTableGrid.headerHeight = 28;
		packTableGrid.cellHeight = 27.5;
		packTableGrid.fontSize = 13;*/
		packTableGrid.render('packParTableGrid');		
		
	}catch(e){
		showErrorMessage("packParTableGrid", e);
	}

	function checkRITablesBeforeDeletion(packParId, parNo){
		var ok=false;
		try{
			new Ajax.Request(contextPath+"/GIPIPackPARListController?action=checkRIBeforeDeleteCancel", {
				method: "GET",
				asynchronous: true,
				evalScripts: true,
				parameters: {
					packParId: packParId
				},
				onComplete: function (response) {
					if (checkErrorOnResponse(response)) {
						if(response.responseText == "Y"){
							showConfirmBox("Delete PAR Confirmation", "Delete PAR No. " + parNo +" ?", "Ok", "Cancel", 
									function(){
										deletePackPAR(packParId, parNo);
										ok = true;
									}, 
									"");
						}else{
							showMessageBox("Cannot delete PAR since its binder is already posted.", imgMessage.ERROR);
							return false;
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("checkRITablesBeforeDeletion", e);
		}
		return ok;
	}

	function checkRITablesBeforeCancel(packParId, parStatus, parNo){
		var ok = false;
		try{
			new Ajax.Request(contextPath+"/GIPIPackPARListController?action=checkRIBeforeDeleteCancel", {
				method: "GET",
				asynchronous: true,
				evalScripts: true,
				parameters: {
					packParId: packParId
				},
				onComplete: function (response) {
					if (checkErrorOnResponse(response)) {
						if(response.responseText == "Y"){
							showConfirmBox("Cancel PAR Confirmation", "Cancel PAR No. " + parNo +" ?", "Ok", "Cancel", 
								function(){
									cancelPackPAR(packParId, parStatus, parNo);
									ok = true;
								}, 
								"");
						}else{
							showMessageBox("Cannot cancel PAR since its binder is already posted.", imgMessage.ERROR);
							return false;
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("checkRITablesBeforeCancel", e);
		}
		return ok;
	}

	function deletePackPAR(packParId, parNo) {
		try{
			new Ajax.Request(contextPath+"/GIPIPackPARListController?action=deletePackPAR", {
				method: "GET",
				asynchronous: true,
				evalScripts: true,
				parameters: {
					packParId: packParId,
					parNo: parNo
				},
				onCreate: function() {
					showNotice("Preparing to delete PAR No. " + parNo);
				},
				onComplete: function (response) {
					hideNotice("");
					if (checkErrorOnResponse(response)) {
						showMessageBox(response.responseText, imgMessage.INFO);
						packTableGrid.clear();
						packTableGrid.refresh();
						selectedIndex = -1;
					}
				}
			});
		}catch(e){
			showErrorMessage("deletePackPAR", e);
		}
	}

	function cancelPackPAR(packParId, parStatus, parNo) {
		try{
			new Ajax.Request(contextPath+"/GIPIPackPARListController?action=cancelPackPAR", {
				method: "GET",
				asynchronous: true,
				evalScripts: true,
				parameters: {
					packParId: packParId,
					parNo: parNo,
					parStatus: parStatus
				},
				onCreate: function() {
					showNotice("Preparing to cancel PAR No. " + parNo);
				},
				onComplete: function (response) {
					hideNotice("");
					if (checkErrorOnResponse(response)) {
						showMessageBox(response.responseText, imgMessage.INFO);
						packTableGrid.clear();
						packTableGrid.refresh();
						selectedIndex = -1;
					}
				}
			});
		}catch(e){
			showErrorMessage("cancelPackPAR", e);
		}
	}

	function updatePackParRemarks(modifiedRows){
		var ok = true;
		try{
			new Ajax.Request(contextPath+"/GIPIPackPARListController?action=updatePackParRemarks", {
				asynchronous: true,
				parameters:{
					updatedRows: modifiedRows
				},
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						if(response.responseText == "SUCCESS"){
							showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
							ok = true;
						}else{
							showMessageBox(response.responseText, imgMessage.ERROR);
							ok = false;
							return false;
						}
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
						ok = false;
						return false;
					}
				}
			});
			return ok;
		}catch(e){
			showErrorMessage("updatePackParRemarks", e);
		}
	}

	function goToPackBasicInfo(index){
		var objPar = objUWParList[index];
		setGlobalParametersForPackPar(objPar);
		showPackParBasicInfo();
	}

	function savePackParTableGrid(){
		var id = packTableGrid._mtgId;
		fireEvent($('mtgSaveBtn'+id), 'click');
	}
	
	$("packParListingExit").observe("click", function(){
		packTableGrid.keys.removeFocus(packTableGrid.keys._nCurrentFocus, true);
		packTableGrid.keys.releaseKeys();
		checkChangeTagBeforeUWMain();
	});

	initializeChangeTagBehavior(savePackParTableGrid);
	
</script>
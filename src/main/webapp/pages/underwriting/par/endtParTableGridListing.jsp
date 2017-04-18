<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>

<div id="parListingMainDiv" name="parListingMainDiv" module="endtParListing">
	<div id="parListingMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="endtParListingExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>List of Endorsement Policy Action Records for ${lineName}</label>
			<input type="hidden" id="lineCd" name="lineCd" value="${lineCd}">
			<input type="hidden" id="menuLineCd" name="menuLineCd" value="${menuLineCd}">
			<input type="hidden" id="ora2010Sw" name="ora2010Sw" value="${ora2010Sw}">
			<input type="hidden" id="riSwitch" name="riSwitch" value="${riSwitch}" />
		</div>
	</div>
	
	<div id="endtParTableGridSectionDiv" class="sectionDiv" style="height: 370px;">
		<div id="endtParTableGridDiv" style="padding: 10px;">
			<div id="endtParTableGrid" style="height: 325px; width: 900px;"></div>
		</div>
	</div>
</div>
<jsp:include page="/pages/underwriting/menus/basicInfoMenu.jsp"></jsp:include>
<div id="parInfoDiv" name="parInfoDiv" style="display: none;"></div>


<script type="text/javascript">
	setModuleId("GIPIS058");
	setDocumentTitle("PAR Listing - Endorsement");
	initializePARBasicMenu("E", $F("lineCd"));
	clearObjectValues(objUWParList);
	clearObjectValues(objGIPIWPolbas);
	selectedIndex = -1;
	var objUser = JSON.parse('${user}');
	var allowCancel; //edgar 02/16/2015

	try{
		var objEndtPar = new Object();
		objEndtPar.objEndtParListTableGrid = JSON.parse('${gipiEndtParListTableGrid}');
		objEndtPar.objEndtParList = objEndtPar.objEndtParListTableGrid.rows || [];
				
		var endtParTableModel = {
				url: contextPath+"/GIPIPARListController?action=refreshEndtParListing&lineCd="+encodeURIComponent($F("lineCd"))+
						"&riSwitch="+encodeURIComponent($F("riSwitch")),
				options:{
					title: '',
					width: '900px',
					//querySort: false,
					onCellFocus: function(element, value, x, y, id){
						var mtgId = endtParTableGrid._mtgId;
						selectedIndex = -1;
						if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
							selectedIndex = y;
						}
						observeChangeTagInTableGrid(endtParTableGrid);
					},
					onCellBlur: function(){
						observeChangeTagInTableGrid(endtParTableGrid);
					},
					onRemoveRowFocus: function(){
						selectedIndex = -1;
					},
					onRowDoubleClick: function(y){
						var row = endtParTableGrid.geniisysRows[y];
						var parId = row.parId;
						var underwriter = row.underwriter;
						endtParTableGrid.keys.removeFocus(endtParTableGrid.keys._nCurrentFocus, true);
						endtParTableGrid.keys.releaseKeys();
						observeChangeTagInTableGrid(endtParTableGrid);
						if(validateUserEntryForEndtPAR(objUser, underwriter)){
							$("globalParId").value = parId;
							if(changeTag == 1){
								showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
										function(){
											saveEndtParTableGrid();
											goToEndtParBasicInfo(row);
										}, 
										function(){
											goToEndtParBasicInfo(row);
											changeTag = 0;
										}, "");
								
							}else{
								goToEndtParBasicInfo(row);
								changeTag = 0;
							}
						}
					},
					toolbar: {
						elements: [MyTableGrid.ADD_BTN, MyTableGrid.SAVE_BTN, MyTableGrid.EDIT_BTN, MyTableGrid.DEL_BTN, MyTableGrid.CANCEL_BTN, MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
						onAdd: function(){
							endtParTableGrid.keys.removeFocus(endtParTableGrid.keys._nCurrentFocus, true);
							endtParTableGrid.keys.releaseKeys();
							observeChangeTagInTableGrid(endtParTableGrid);						
							if(changeTag == 1){		//condition added by shan 10.03.2013
								showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
										function(){
											saveEndtParTableGrid();
											resetPARGlobalElements();
											if($F("riSwitch") == "Y"){ // andrew - 10.19.2011
												showRIParCreationPage("0","E");
											} else {
												showEndtParCreationPage($F("lineCd")); // Nica 08.18.2012
											}
										}, 
										function(){
											resetPARGlobalElements();
											if($F("riSwitch") == "Y"){ // andrew - 10.19.2011
												showRIParCreationPage("0","E");
											} else {
												showEndtParCreationPage($F("lineCd")); // Nica 08.18.2012
											}
											changeTag = 0;
										}, "");
							
								return false;
							}else{
								resetPARGlobalElements();
								if($F("riSwitch") == "Y"){ // andrew - 10.19.2011
									showRIParCreationPage("0","E");
								} else {
									showEndtParCreationPage($F("lineCd")); // Nica 08.18.2012
								}
								changeTag = 0;
							}
						},
						onEdit: function(){
							endtParTableGrid.keys.removeFocus(endtParTableGrid.keys._nCurrentFocus, true);
							endtParTableGrid.keys.releaseKeys();
							observeChangeTagInTableGrid(endtParTableGrid);
							if(selectedIndex >= 0){
								var row = endtParTableGrid.geniisysRows[selectedIndex];
								var parId = row.parId;
								var underwriter = row.underwriter;
								if(validateUserEntryForEndtPAR(objUser, underwriter)){
									$("globalParId").value = parId;
									if(changeTag == 1){
										showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
												function(){
													saveEndtParTableGrid();
													goToEndtParBasicInfo(row);
												}, 
												function(){
													goToEndtParBasicInfo(row);
													changeTag = 0;
												}, "");
										
									}else{
										goToEndtParBasicInfo(row);
										changeTag = 0;
									}
								}
							}else{
								showMessageBox("Please select a PAR.", imgMessage.ERROR);
							}
						},
						onSave: function(){
							endtParTableGrid.keys.removeFocus(endtParTableGrid.keys._nCurrentFocus, true);
							endtParTableGrid.keys.releaseKeys();
							//var delRows  	 = endtParTableGrid.getDeletedRows();
							var modifiedRows = endtParTableGrid.getModifiedRows();
							var objParameters = new Object();
							//objParameters.delRows = delRows;
							objParameters.setRows = modifiedRows;
							var strParameters = JSON.stringify(objParameters);
							var ok = updateParRemarks(strParameters);
						},
						postSave: function(){
							endtParTableGrid.clear();
							endtParTableGrid.refresh();
							changeTag = 0;
							selectedIndex = -1;
						},
						onDelete:function(){
							if(selectedIndex >= 0){
								var row = endtParTableGrid.geniisysRows[selectedIndex];
								var parId = row.parId;
								var parNo = row.parNo;
								var underwriter = row.underwriter;
								if(validateDeletePAR(objUser, underwriter)){ // added by: Nica 08.22.2012
									checkRITablesBeforePARDeletion(parId, parNo);								
								}
							}else{
								showMessageBox("Please select a PAR.", imgMessage.ERROR);
								return false;
							}
							endtParTableGrid.keys.releaseKeys();
						},
						onCancel: function(){ //added edgar 02/16/2015
							if(selectedIndex >= 0){
								var row		= endtParTableGrid.geniisysRows[selectedIndex];
								var parId	= row.parId;
								var parStatus = row.parStatus;
								var parNo	= row.parNo;
								var underwriter = row.underwriter;
								if(validateCancelPAR(objUser, underwriter)){
									checkAllowCancel(parId, parStatus, parNo);	
									//checkRITablesBeforeEndtPARCancel(parId, parStatus, parNo);
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
						id: 'parId',
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
						filterOption: true,
						filterOptionType: 'integerNoNegative'
					},
					{
						id: 'quoteSeqNo',
						width: '0',
						title: 'Quote Seq No.',
						visible: false,
						filterOption: true,
						filterOptionType: 'integerNoNegative'
					},
					{
						id: 'parNo',
						title: 'Par No.',
						width: '250px'
					},
					{
						id: 'underwriter',
						title: 'User Id',
						width: '170px',
						filterOption: true
					},
					/*{
						id: 'status',
						title: 'Status',
						width: '200px',
						filterOption: true
					},*/
					{
						id: 'remarks',
						title: 'Remarks',
						width: $F("ora2010Sw")== "Y" ? '260px' : '460px',
						editable: true,
						maxlength: 4000,
						editor: new MyTableGrid.EditorInput({
							onClick: function(){
							var coords = endtParTableGrid.getCurrentPosition();
							var x = coords[0];
							var y = coords[1];
							var title = "Remarks ("+ endtParTableGrid.geniisysRows[y].parNo+")";
								showTableGridEditor(endtParTableGrid, x, y, title, 4000, false);
							}
						})
						
					},
					{
						id: 'bankRefNo',
						title: 'Bank Ref No.',
						width: $F("ora2010Sw")== "Y" ? '200px' : '0',
						visible: $F("ora2010Sw")== "Y" ? true : false,
						filterOption: $F("ora2010Sw")== "Y" ? true : false 
					}
				],
				requiredColumns: 'parId parNo underwriter status',
				resetChangeTag: true,
				rows: objEndtPar.objEndtParList	
		};
	
		endtParTableGrid = new MyTableGrid(endtParTableModel);
		endtParTableGrid.pager = objEndtPar.objEndtParListTableGrid;
		/*endtParTableGrid.headerHeight = 28;
		endtParTableGrid.cellHeight = 27.5;
		endtParTableGrid.fontSize = 13;*/
		endtParTableGrid.render('endtParTableGrid');		
		
	}catch(e){
		showErrorMessage("endtParTableGrid", e);
	}

	function checkRITablesBeforePARDeletion(parId, parNo){
		var ok=false;
		try{
			new Ajax.Request(contextPath+"/GIPIPARListController?action=checkRIBeforePARDeletionOrCancel", {
				method: "GET",
				asynchronous: true,
				evalScripts: true,
				parameters: {
					parId: parId
				},
				onComplete: function (response) {
					if (checkErrorOnResponse(response)) {
						if(response.responseText == "Y"){
							showConfirmBox("Delete PAR Confirmation", "Delete PAR No. " + parNo +" ?", "Ok", "Cancel", 
									function(){
										deletePAR(parId, parNo);
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
			showErrorMessage("checkRITablesBeforePARDeletion", e);
		}
		return ok;
	}

	function deletePAR(parId, parNo) {
		try{
			new Ajax.Request(contextPath+"/GIPIPARListController?action=deletePAR", {
				method: "GET",
				asynchronous: true,
				evalScripts: true,
				parameters: {
					parId: parId,
					parNo: parNo, 
					lineCd: $F("lineCd"),
					menuLineCd: $F("menuLineCd")
				},
				onCreate: function() {
					showNotice("Preparing to delete PAR No. " + parNo);
				},
				onComplete: function (response) {
					hideNotice("");
					if (checkErrorOnResponse(response)) {
						showMessageBox(response.responseText, imgMessage.INFO);
						endtParTableGrid.clear();
						endtParTableGrid.refresh();
						selectedIndex = -1;
					}
				}
			});
		}catch(e){
			showErrorMessage("deletePAR", e);
		}
	}

	function updateParRemarks(modifiedRows){
		var ok = true;
		
		try{
			new Ajax.Request(contextPath+"/GIPIPARListController?action=updateParRemarks", {
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
			showErrorMessage("updateParRemarks", e);
		}
	}
	//start edgar 02/16/2015
	function checkRITablesBeforeEndtPARCancel(parId, parStatus, parNo){
		var ok = false;
		try{
			new Ajax.Request(contextPath+"/GIPIPARListController?action=checkRIBeforePARDeletionOrCancel", {
				method: "GET",
				asynchronous: true,
				evalScripts: true,
				parameters: {
					parId: parId
				},
				onComplete: function (response) {
					if (checkErrorOnResponse(response)) {
						if(response.responseText != "Y" && allowCancel == "N"){
							allowCancel = "N";
							showMessageBox("Cannot cancel PAR since its binder is already posted.", imgMessage.ERROR);
							return false;
						}else if (response.responseText != "Y" && allowCancel == "Y"){
							allowCancel = "N";
							showConfirmBox("Cancel PAR Confirmation", "PAR No. " + parNo +" has posted binders. Continue to cancel the PAR ?", "Ok", "Cancel", 
									function(){
										cancelEndtPAR(parId, parStatus, parNo);
										ok = true;
									}, 
									"");
						}else {
							allowCancel = "N";
							showConfirmBox("Cancel PAR Confirmation", "Cancel PAR No. " + parNo +" ?", "Ok", "Cancel", 
									function(){
										cancelEndtPAR(parId, parStatus, parNo);
										ok = true;
									}, 
									"");
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("checkRITablesBeforePARCancel", e);
		}
		return ok;
	}
	
	function checkAllowCancel(parId, parStatus, parNo){//added edgar 02/16/2015
		var ok = false;
		try{
			new Ajax.Request(contextPath+"/GIPIPARListController?action=checkAllowCancel", {
				method: "GET",
				asynchronous: true,
				evalScripts: true,
				parameters: {
					parId: parId
				},
				onComplete: function (response) {
					if (checkErrorOnResponse(response)) {
						if(response.responseText == "Y"){
							allowCancel = "Y";
							if (checkRITablesBeforeEndtPARCancel(parId, parStatus, parNo)){
							 	ok = true;	
							}
						}else{
							allowCancel = "N";
							if (checkRITablesBeforeEndtPARCancel(parId, parStatus, parNo)){
							 	ok = true;	
							}
						}
					}
				}
			});
			
			return ok;
		}catch(e){
			showErrorMessage("checkAllowCancel", e);
		}
	}
	
	function cancelEndtPAR(parId, parStatus, parNo) {
		try{
			new Ajax.Request(contextPath+"/GIPIPARListController?action=cancelPAR", {
				method: "GET",
				asynchronous: true,
				evalScripts: true,
				parameters: {
					parId: parId,
					parNo: parNo,
					parStatus: parStatus
				},
				onCreate: function() {
					showNotice("Canceling PAR No. " + parNo);
				},
				onComplete: function (response) {
					hideNotice("");
					if (checkErrorOnResponse(response)) {
						showMessageBox(response.responseText, imgMessage.INFO);
						endtParTableGrid.clear();
						endtParTableGrid.refresh();
						selectedIndex = -1;
					}
				}
			});
		}catch(e){
			showErrorMessage("cancelPAR", e);
		}
	}
	//end edgar 02/16/2015
	function goToEndtParBasicInfo(row){
		if (row.lineCd == "SU" || objUWGlobal.menuLineCd == "SU"){
			//showBondBasicInfo();
			showEndtBondBasicInfo();
		}else{
			showBasicInfo();
		}
	}

	function saveEndtParTableGrid(){
		var id = endtParTableGrid._mtgId;
		fireEvent($('mtgSaveBtn'+id), 'click');
	}

	$("endtParListingExit").observe("click", function(){
		endtParTableGrid.keys.removeFocus(endtParTableGrid.keys._nCurrentFocus, true);
		endtParTableGrid.keys.releaseKeys();
		checkChangeTagBeforeUWMain();
	});

	initializeChangeTagBehavior(saveEndtParTableGrid);
	
</script>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>

<div id="packParListingTableGridMainDiv" name="packParListingTableGridMainDiv" module="endPackParListing">
	<div id="endtPackParListingMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="endtPackParListingExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>List of Endorsement Package Policy Action Records for ${lineName}</label>
			<input type="hidden" id="lineCd" name="lineCd" value="${lineCd}">
			<input type="hidden" id="menuLineCd" name="menuLineCd" value="${menuLineCd}">
			<input type="hidden" id="ora2010Sw" name="ora2010Sw" value="${ora2010Sw}">
			<input type="hidden" id="riSwitch" name="riSwitch" value="${riSwitch}" />
		</div>
	</div>

	<div id="endtPackTableGridSectionDiv" class="sectionDiv" style="height: 370px;">
		<div id="endtPackParTableGridDiv" style="padding: 10px;">
			<div id="endtPackParTableGrid" style="height: 325px; width: 900px;"></div>
		</div>			
	</div>
</div>
<jsp:include page="/pages/underwriting/menus/basicInfoMenu.jsp"></jsp:include>
<div id="parInfoDiv" name="parInfoDiv" style="display: none;"></div>

<script type="text/javascript">
	setModuleId("GIPIS058A");
	setDocumentTitle("Package PAR Listing - Endorsement");
	initializePackPARBasicMenu("E", $F("lineCd"));
	clearObjectValues(objUWGlobal);
	clearObjectValues(objUWParList);
	clearObjectValues(objGIPIWPolbas);
	selectedIndex = -1;
	var objUser = JSON.parse('${user}');
	objTempUWGlobal = null; // andrew - 09.08.2011
	
	var leavePackListing = "";	//added by shan 10.17.2013
	
	try{
		var objEndtPackPar = new Object();
		objEndtPackPar.objEndtPackParListTableGrid = JSON.parse('${gipiEndtPackParListTableGrid}');
		objEndtPackPar.objEndtPackParList = objEndtPackPar.objEndtPackParListTableGrid.rows || [];
				
		var endtPackTableModel = {
				url: contextPath+"/GIPIPackPARListController?action=refreshEndtPackParListing&lineCd="+encodeURIComponent($F("lineCd"))+
				     "&riSwitch="+encodeURIComponent($F("riSwitch")),
				options:{
					title: '',
					width: '900px',
					//querySort: false,
					onCellFocus: function(element, value, x, y, id){
						var mtgId = endtPackTableGrid._mtgId;
						selectedIndex = -1;
						if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
							selectedIndex = y;
						}
						observeChangeTagInTableGrid(endtPackTableGrid);
					},
					onCellBlur: function(){
						observeChangeTagInTableGrid(endtPackTableGrid);
					},
					onRemoveRowFocus: function(){
						selectedIndex = -1;
					},
					onRowDoubleClick: function(y){
						var underwriter = endtPackTableGrid.geniisysRows[y].underwriter;
						endtPackTableGrid.keys.removeFocus(endtPackTableGrid.keys._nCurrentFocus, true);
						endtPackTableGrid.keys.releaseKeys();
						observeChangeTagInTableGrid(endtPackTableGrid);
						if(validateUserEntryForEndtPAR(objUser, underwriter)){
							objUWParList = endtPackTableGrid.geniisysRows;
							if(changeTag == 1){
								showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
										function(){
											saveEndtPackParTableGrid();
											goToEndtPackBasicInfo(y);
										}, 
										function(){
											goToEndtPackBasicInfo(y);
											changeTag = 0;
										}, "");
								
							}else{
								goToEndtPackBasicInfo(y);
								changeTag = 0;
							}
						}
					},
					toolbar: {
						elements: [MyTableGrid.ADD_BTN, MyTableGrid.SAVE_BTN, MyTableGrid.EDIT_BTN, MyTableGrid.DEL_BTN, MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
						onAdd: function(){
							observeChangeTagInTableGrid(endtPackTableGrid);
							if(changeTag == 1){		//condition added by shan 10.17.2013
								showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
										function(){
											leavePackListing = onAddFunc;
											saveEndtPackParTableGrid();		// added by shan 10.17.2013											
										}, 
										onAddFunc, 
										"");
							
								return false;
							}else{
								/* moved to onAddFunc : shan 10.17.2013
								resetPackPARGlobalElements();
								if($F("riSwitch") == "Y") {
									showRIPackParCreationPage("0","E");
								} else {
									showEndtPackParCreationPage($F("lineCd")); // Nica 08.18.2012 - added lineCd parameter
								}
								
								changeTag = 0;*/
								onAddFunc();
							}
							
						},
						onEdit: function(){
							endtPackTableGrid.keys.removeFocus(endtPackTableGrid.keys._nCurrentFocus, true);
							endtPackTableGrid.keys.releaseKeys();
							observeChangeTagInTableGrid(endtPackTableGrid);
							if(selectedIndex >= 0){
								var underwriter = endtPackTableGrid.geniisysRows[selectedIndex].underwriter;
								if(validateUserEntryForEndtPAR(objUser, underwriter)){
									objUWParList = endtPackTableGrid.geniisysRows;
									if(changeTag == 1){
										showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
												function(){
													var ind = selectedIndex;
													leavePackListing = function(){	// added by shan 10.17.2013
														goToEndtPackBasicInfo(ind);	
													};
													saveEndtPackParTableGrid();
													//goToEndtPackBasicInfo(selectedIndex);		//commented out by shan 10.17.2013
												}, 
												function(){
													goToEndtPackBasicInfo(selectedIndex);
													changetag = 0;
												}, "");
										
									}else{
										goToEndtPackBasicInfo(selectedIndex);
										changetag = 0;
									}
								}
							}else{
								showMessageBox("Please select a PAR.", imgMessage.ERROR);
							}
						},
						onSave: function(){
							endtPackTableGrid.keys.removeFocus(endtPackTableGrid.keys._nCurrentFocus, true);
							endtPackTableGrid.keys.releaseKeys();
							//var delRows  	 = endtPackTableGrid.getDeletedRows();
							var modifiedRows = endtPackTableGrid.getModifiedRows();
							var objParameters = new Object();
							//objParameters.delRows = delRows;
							objParameters.setRows = modifiedRows;
							var strParameters = JSON.stringify(objParameters);
							var ok = updatePackParRemarks(strParameters);
						},
						postSave: function(){
							endtPackTableGrid.clear();
							endtPackTableGrid.refresh();
							changeTag = 0;
							selectedIndex = -1;
						},
						onDelete:function(){
							if(selectedIndex >= 0){
								var row = endtPackTableGrid.geniisysRows[selectedIndex];
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
						type: 'number',
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
						type: 'number',
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
							var coords = endtPackTableGrid.getCurrentPosition();
							var x = coords[0];
							var y = coords[1];
							var title = "Remarks ("+ endtPackTableGrid.geniisysRows[y].parNo+")";
								showTableGridEditor(endtPackTableGrid, x, y, title, 4000, false);
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
				requiredColumns: 'packParId parNo underwriter status',
				resetChangeTag: true,
				rows: objEndtPackPar.objEndtPackParList	
		};
	
		endtPackTableGrid = new MyTableGrid(endtPackTableModel);
		endtPackTableGrid.pager = objEndtPackPar.objEndtPackParListTableGrid;
		/*endtPackTableGrid.headerHeight = 28;
		endtPackTableGrid.cellHeight = 27.5;
		endtPackTableGrid.fontSize = 13;*/
		endtPackTableGrid.render('endtPackParTableGrid');		
		
	}catch(e){
		showErrorMessage("endtPackParTableGrid", e);

	}

	//added by shan 10.17.2013
	function onAddFunc(){
		try{
			resetPackPARGlobalElements();
			if($F("riSwitch") == "Y") {
				showRIPackParCreationPage("0","E");
			} else {
				showEndtPackParCreationPage($F("lineCd")); // Nica 08.18.2012 - added lineCd parameter
			}
			changeTag = 0;
		}catch(e){
			showErrorMessage("onAddFunc", e);
		}
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
						endtPackTableGrid.clear();
						endtPackTableGrid.refresh();
						selectedIndex = -1;
					}
				}
			});
		}catch(e){
			showErrorMessage("deletePackPAR", e);
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
							// change to showWaitingMessageBox : shan 10.17.2013
							showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
								if (leavePackListing != ""){
									leavePackListing();	
								}
								ok = true;
							});
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

	function goToEndtPackBasicInfo(index){
		var objPar = objUWParList[index];
		setGlobalParametersForPackPar(objPar);
		if(checkUserModule("GIPIS031A")) {
			showEndtPackParBasicInfo();
		} else {
			showMessageBox(objCommonMessage.NO_MODULE_ACCESS, "e");
		}
	}

	function saveEndtPackParTableGrid(){
		var id = endtPackTableGrid._mtgId;
		fireEvent($('mtgSaveBtn'+id), 'click');
	}
	
	$("endtPackParListingExit").observe("click", function(){
		endtPackTableGrid.keys.removeFocus(endtPackTableGrid.keys._nCurrentFocus, true);
		endtPackTableGrid.keys.releaseKeys();
		checkChangeTagBeforeUWMain();
	});

	initializeChangeTagBehavior(saveEndtPackParTableGrid);
	
</script>
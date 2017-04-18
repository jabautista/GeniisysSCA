<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>

<div id="parListingMainDiv" name="parListingMainDiv" module="parlisting">
	<div id="parListingMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="parListingExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>List of Policy Action Records for ${lineName}</label>
			<input type="hidden" id="lineCd" name="lineCd" value="${lineCd}">
			<input type="hidden" id="menuLineCd" name="menuLineCd" value="${menuLineCd}">
			<input type="hidden" id="ora2010Sw" name="ora2010Sw" value="${ora2010Sw}">
			<input type="hidden" id="riSwitch" name="riSwitch" value="${riSwitch}" />
		</div>
	</div>
	
	<div id="parTableGridSectionDiv" class="sectionDiv" style="height: 415px;">
		<div id="parTableGridDiv" style="padding: 10px;">
			<div id="parTableGrid" style="height: 325px; width: 900px;"></div>
		</div>
		<div id="parListingButtonsDiv" style="padding: 30px;" align="center">
			<input type="button" class="button" id="btnCoverNoteInquiry" name="btnCoverNoteInquiry" value="Cover Note Inquiry"/>
		</div>
	</div>
</div>
<jsp:include page="/pages/underwriting/menus/basicInfoMenu.jsp"></jsp:include>
<div id="parInfoDiv" name="parInfoDiv" style="display: none;"></div>


<script type="text/javascript">
	setModuleId("GIPIS001");
	setDocumentTitle("PAR Listing - Policy");
	initializePARBasicMenu("P", $F("lineCd"));
	clearObjectValues(objUWParList);
	clearObjectValues(objGIPIWPolbas);
	selectedIndex = -1;
	var objUser = JSON.parse('${user}');
	var directParOpenAccess = '${directParOpenAccess}';
	
	var leaveParListing = "";	//for showing message box before navigating to other page (applied on btnCoverNoteInquiry as of 10.18.2013) : shan 10.18.2013
	var allowCancel; //edgar 02/16/2015
	if($F("ora2010Sw") == "N"){
		$("parListingButtonsDiv").hide();
		$("parTableGridSectionDiv").setStyle({height : '370px'});
	}else{
		$("parListingButtonsDiv").show();
		$("parTableGridSectionDiv").setStyle({height : '415px'});
	}
	
	try{
		var objPar = new Object();
		objPar.objParListTableGrid = JSON.parse('${gipiParListTableGrid}');
		objPar.objParList = objPar.objParListTableGrid.rows || [];

		var parTableModel = {
			url: contextPath+"/GIPIPARListController?action=refreshParListing&lineCd="+encodeURIComponent($F("lineCd"))+
				"&riSwitch="+encodeURIComponent($F("riSwitch")),
			options:{
				title: '',
				width: '900px',
				//querySort: false,
				onCellFocus: function(element, value, x, y, id){
					var mtgId = parTableGrid._mtgId;
					selectedIndex = -1;
					if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
						selectedIndex = y;
					}
					observeChangeTagInTableGrid(parTableGrid);
				},
				onCellBlur: function(){
					observeChangeTagInTableGrid(parTableGrid);
				},
				onRemoveRowFocus: function(){
					selectedIndex = -1;
				},
				onRowDoubleClick: function(y){
					var row = parTableGrid.geniisysRows[y];
					var parId = row.parId;
					var underwriter = row.underwriter;
					parTableGrid.keys.removeFocus(parTableGrid.keys._nCurrentFocus, true);
					parTableGrid.keys.releaseKeys();
					observeChangeTagInTableGrid(parTableGrid);
					if(validateUserEntryForPAR(objUser, underwriter, directParOpenAccess)){
						$("globalParId").value = parId;
						ojbMiniReminder.parId = parId; // Added by J. Diago 08.23.2013
						if(changeTag == 1){
							showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
								function(){
									saveParTableGrid();
									goToParBasicInfo(row);
								}, 
								function(){
									goToParBasicInfo(row);
									changeTag = 0;
								}, "");
						}else{
							goToParBasicInfo(row);
							changeTag = 0;
						}
					}
				},
				toolbar: {
					elements: [MyTableGrid.ADD_BTN, MyTableGrid.SAVE_BTN, MyTableGrid.EDIT_BTN, MyTableGrid.DEL_BTN, MyTableGrid.COPY_BTN, MyTableGrid.CANCEL_BTN, MyTableGrid.PRINT_BTN, MyTableGrid.RETURN_QUOTN_BTN, MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onAdd: function(){
						parTableGrid.keys.releaseKeys();
						
						resetPARGlobalElements();
						if($F("riSwitch") == "Y") {
							showRIParCreationPage("0","P");
						} else {
							showPARCreationPage($F("lineCd"));
						}
					},
					onEdit: function(){
						parTableGrid.keys.removeFocus(parTableGrid.keys._nCurrentFocus, true);
						parTableGrid.keys.releaseKeys();
						observeChangeTagInTableGrid(parTableGrid);
						if(selectedIndex >= 0){
							var row = parTableGrid.geniisysRows[selectedIndex];
							var parId = row.parId;
							var underwriter = row.underwriter;
							if(validateUserEntryForPAR(objUser, underwriter, directParOpenAccess)){
								$("globalParId").value = parId;
								ojbMiniReminder.parId = parId; // Added by J. Diago 08.23.2013
								if(changeTag == 1){
									showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
										function(){
											saveParTableGrid();
											goToParBasicInfo(row);
										}, 
										function(){
											goToParBasicInfo(row);
											changeTag = 0;
										}, "");
								}else{
									goToParBasicInfo(row);
									changeTag = 0;
								}
							}
						}else{
							showMessageBox("Please select a PAR.", imgMessage.ERROR);
						}
					},
					onSave: function(){
						parTableGrid.keys.removeFocus(parTableGrid.keys._nCurrentFocus, true);
						parTableGrid.keys.releaseKeys();
						//var delRows  	 = parTableGrid.getDeletedRows();
						var modifiedRows = parTableGrid.getModifiedRows();
						var objParameters = new Object();
						//objParameters.delRows = delRows;
						objParameters.setRows = modifiedRows;
						var strParameters = JSON.stringify(objParameters);
						var ok = updateParRemarks(strParameters); // andrew - 02.23.2011 - added unescapeHTML function
					},
					postSave: function(){
						parTableGrid.clear();
						parTableGrid.refresh();
						changeTag = 0;
						selectedIndex = -1;
					},
					onDelete:function(){
						if(selectedIndex >= 0){
							var row = parTableGrid.geniisysRows[selectedIndex];
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
					},
					onCopy: function(){
						if(selectedIndex >= 0){
							var row = parTableGrid.geniisysRows[selectedIndex];
							var parId = row.parId;
							var parNo = row.parNo;
							var issCd = row.issCd;
							showConfirmBox("Copy PAR Confirmation", "Copy PAR No. " + parNo + " ?", "Yes", "No", 
								function(){										
									copyPAR(parId, parNo, issCd);
								}, 
								"");
						}else{
							showMessageBox("Please select a PAR.", imgMessage.ERROR);
						}
					},
					onCancel: function(){
						if(selectedIndex >= 0){
							var row		= parTableGrid.geniisysRows[selectedIndex];
							var parId	= row.parId;
							var parStatus = row.parStatus;
							var parNo	= row.parNo;
							var underwriter = row.underwriter;
							if(validateCancelPAR(objUser, underwriter)){ // added by: Nica 08.22.2012
								//checkRITablesBeforePARCancel(parId, parStatus, parNo); //commented out edgar 02/16/2015
								checkAllowCancel(parId, parStatus, parNo);// edgar 02/16/2015
							}
						}else{
							showMessageBox("Please select a PAR.", imgMessage.ERROR);
						}
					},
					onPrint: function(){
						if(selectedIndex >= 0){
							var row = parTableGrid.geniisysRows[selectedIndex];
							var parId = row.parId;
							var packParId = row.packParId;
								Modalbox.show(contextPath+"/PrintPolicyController?action=showReportGenerator&reportType=policy&globalParId="
									+nvl(parId, 0)+"&globalPackParId="+nvl(packParId,0),
									{ title: "Geniisys Report Generator",
									  width: 500
									}
						    );
						}else{
							showMessageBox("Please select a PAR.", imgMessage.ERROR);
						}
					},
					onReturnQuotation: function(){
						if(selectedIndex >= 0){
							var row = parTableGrid.geniisysRows[selectedIndex];
							var quoteId = row.quoteId;
							var parNo = row.parNo;
							
							if(nvl(quoteId, "") != ""){
								showConfirmBox("Return PAR to Quotation?", 
										"This option will automatically delete PAR No. " + parNo + " as a result of Return to Quotation function. Do you want to continue?", 
										"Yes", "No", 
										function(){
											returnPARToQuote(nvl(quoteId, ""));
										}, "");
							}else{
								showMessageBox("Quotation cannot be returned.<br/>Record originated from this module.", imgMessage.INFO);
							}
						}else{
							showMessageBox("Please select a PAR.", imgMessage.ERROR);
						}
					}
				}
			},
			columnModel: [
				{   id: 'recordStatus',
				    title: '',
				    width: '0',
				    visible: false,
				    editor: 'checkbox' 			
				},
				{	id: 'divCtrId',
					width: '0',
					visible: false
				},
				{	id: 'parId',
					width: '0',
					visible: false
				},
				{	id: 'issCd',
					width: '0',
					title: 'Issue Code',
					visible: false,
					filterOption: true
				},
				{	id: 'parYy',
					width: '0',
					title: 'Par Year',
					visible: false,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{	id: 'parSeqNo',
					width: '0',
					title: 'Par Seq No.',
					visible: false,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{	id: 'quoteSeqNo',
					width: '0',
					title: 'Quote Seq No.',
					visible: false,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{ 	id:			'polFlag',
					sortable:	false,
					align:		'center',
					title:		'&#160;&#160;R',
					altTitle:   'Renewal',
					titleAlign:	'center',
					width:		'23px',
					editable:	false,
					defaultValue:	false,
					otherValue:	false,
					validValue:	2,
					editor:		'checkbox'
				},
				{ 	id: 'quoteId',
				  	sortable: false,
				  	align: 'center',
				  	title: '&#160;&#160;Q',
				  	altTitle:   'With Quotation',
				  	titleAlign: 'center',
				  	width: '23px',
				  	editable: false,
				  	defaultValue: false,
				  	otherValue: false,
				  	editor: 'checkbox'	
				},
				{ 	id: 'cnDatePrinted',
				  	sortable: false,
				  	align: 'center',
				  	title: '&#160;&#160;C',
				  	altTitle:   'With Covernote',
				  	titleAlign: 'center',
				  	width: '23px',
				  	editable: false,
				  	defaultValue: false,
				  	otherValue: false,
				  	editor: 'checkbox'
				},
				{	id: 'parNo',
					title: 'Par No.',
					width: '130px'
				},
				{	id: 'assdName',
					title: $F("lineCd")== "SU" ? 'Principal Name': 'Assured Name',
					width: '180px',
					filterOption: true,
					renderer : function(value){ //added by steven 7/30/2013
						return escapeHTML2(value);
					}
				},
				{	id: 'underwriter',
					title: 'User ID',
					width: '80px',
					filterOption: true
				},
				{	id: 'status',
					title: 'Status',
					width: '140px',
					filterOption: true
				},
				{	id: 'remarks',
					title: 'Remarks',
					width: $F("ora2010Sw")== "Y" ? '160px' : '270px',
					editable: true,
					maxlength: 4000,
					renderer : function(value){ //added by steven 7/30/2013
						return escapeHTML2(value);
					},
					editor: new MyTableGrid.EditorInput({
						onClick: function(){
						var coords = parTableGrid.getCurrentPosition();
						var x = coords[0];
						var y = coords[1];
						var title = "Remarks ("+ parTableGrid.geniisysRows[y].parNo+")";
							//inputId = 'mtgInput' + parTableGrid._mtgId + '_' + coords[0] + ',' + coords[1];
							//showEditor(inputId, 4000);
							showTableGridEditor2(parTableGrid, x, y, title, 4000, false);
						}
					})
				},
				{	id: 'bankRefNo',
					title: 'Bank Ref No.',
					width: $F("ora2010Sw") == "Y" ? '120px' : '0',
					visible: $F("ora2010Sw") == "Y" ? true : false,
					filterOption: $F("ora2010Sw") == "Y" ? true : false
				}
			],
			requiredColumns: 'parId parNo underwriter status',
			resetChangeTag: true,
			rows: objPar.objParList	
		};
	
		parTableGrid = new MyTableGrid(parTableModel);
		parTableGrid.pager = objPar.objParListTableGrid;
		/*parTableGrid.headerHeight = 28;
		parTableGrid.cellHeight = 27.5;
		parTableGrid.fontSize = 13;*/
		parTableGrid.render('parTableGrid');		
		
	}catch(e){
		showErrorMessage("parTableGridListing.jsp", e);
	}

	function checkRITablesBeforePARDeletion(parId, parNo){
		try{
			var ok=false;
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
			return ok;
		}catch(e){
			showErrorMessage("checkRITablesBeforePARDeletion", e);
		}
	}

	function checkRITablesBeforePARCancel(parId, parStatus, parNo){
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
						/*if(response.responseText == "Y"){
							showConfirmBox("Cancel PAR Confirmation", "Cancel PAR No. " + parNo +" ?", "Ok", "Cancel", 
								function(){
									cancelPAR(parId, parStatus, parNo);
									ok = true;
								}, 
								"");
						}else{
							showMessageBox("Cannot cancel PAR since its binder is already posted.", imgMessage.ERROR);
							return false;
						}*/ //commented out and replaced with codes below : edgar 02/16/2015
						if(response.responseText != "Y" && allowCancel == "N"){
							allowCancel = "N";
							showMessageBox("Cannot cancel PAR since its binder is already posted.", imgMessage.ERROR);
							return false;
						}else if (response.responseText != "Y" && allowCancel == "Y"){
							allowCancel = "N";
							showConfirmBox("Cancel PAR Confirmation", "PAR No. " + parNo +" has posted binders. Continue to cancel the PAR ?", "Ok", "Cancel", 
									function(){
										cancelPAR(parId, parStatus, parNo);
										ok = true;
									}, 
									"");
						}else {
							allowCancel = "N";
							showConfirmBox("Cancel PAR Confirmation", "Cancel PAR No. " + parNo +" ?", "Ok", "Cancel", 
									function(){
										cancelPAR(parId, parStatus, parNo);
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
						parTableGrid.clear();
						parTableGrid.refresh();
						selectedIndex = -1;
					}
				}
			});
		}catch(e){
			showErrorMessage("deletePAR", e);
		}
	}

	function cancelPAR(parId, parStatus, parNo) {
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
						parTableGrid.clear();
						parTableGrid.refresh();
						selectedIndex = -1;
					}
				}
			});
		}catch(e){
			showErrorMessage("cancelPAR", e);
		}
	}

	function returnPARToQuote(quoteId) {
		try{
			if(quoteId == "") {
				showMessageBox("Quotation cannot be returned.<br/>Record originated from this module.", imgMessage.INFO);
				return false;
			} else {
				new Ajax.Request(contextPath+"/GIPIPARListController?action=updateStatusFromQuote", {
					method: "POST",
					asynchronous: true,
					evalScripts: true,
					parameters: {
						retQuoteId: quoteId
					},
					onCreate: function() {
						showNotice("Returning PAR...");
					},
					onComplete: function (response) {
						hideNotice("");
						if (checkErrorOnResponse(response)) {
							showMessageBox(response.responseText, imgMessage.INFO);
							parTableGrid.clear();
							parTableGrid.refresh();
							selectedIndex = -1;
						}
					}
				});
			}
		}catch(e){
			showErrorMessage("returnPARToQuote", e);
		}
	}

	function copyPAR(parId, parNo, issCd) {
		try{
			new Ajax.Request(contextPath+"/GIPIPARListController?action=copyParList", {
				method: "POST",
				asynchronous: true,
				evalScripts: true,
				parameters: {
					parId: parId,
					origParNo: parNo,
					issCd: issCd,
					lineCd: $F("lineCd")
				},
				onCreate: function() {
					showNotice("Copying PAR, please wait...");
				},
				onComplete: function (response) {
					if (checkErrorOnResponse(response)) {
						hideNotice("");
						showMessageBox(response.responseText, imgMessage.INFO);
						parTableGrid.clear();
						parTableGrid.refresh();
						selectedIndex = -1;
					}
				}
			});
		}catch(e){
			showErrorMessage("copyPAR", e);
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
							// changed to showWaitingMessageBox to show message box before navigating to other page : shan 10.18.2013
							// applied on btnCoverNoteInquiry as of 10.18.2013
							showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
								if (leaveParListing != ""){
									leaveParListing();
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
			showErrorMessage("updateParRemarks", e);
		}
	}

	function goToParBasicInfo(row){
		if (row.lineCd == "SU" || $F("menuLineCd") == 'SU'){
			showBondBasicInfo();
		}else{
			showBasicInfo();
		}
	}

	function saveParTableGrid(){
		var id = parTableGrid._mtgId;
		fireEvent($('mtgSaveBtn'+id), 'click');
	}

	//added by shan 10.18.2013
	function showCoverNoteInquiry(){
		try{
			objUWGlobal.lineName = '${lineName}';
			updateMainContentsDiv("/GIPIPARListController?action=getCoverNoteList", 
								 "Loading Cover Note Inquiry, please wait...",
								 function(){},[]);
		}catch(e){
			showErrorMessage("showCoverNoteInquiry", e);
		}
	}
	
	$("parListingExit").observe("click", function(){
		parTableGrid.keys.removeFocus(parTableGrid.keys._nCurrentFocus, true);
		parTableGrid.keys.releaseKeys();
		checkChangeTagBeforeUWMain();
	});
	
	observeAccessibleModule(accessType.BUTTON, "GIPIS213", "btnCoverNoteInquiry",  function(){		
		if (changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
							function(){
								leaveParListing = showCoverNoteInquiry;
								saveParTableGrid();
							},
							function(){
								parTableGrid.keys.removeFocus(parTableGrid.keys._nCurrentFocus, true);
								parTableGrid.keys.releaseKeys();
								showCoverNoteInquiry();
							},
							""
			);
		}else{
			parTableGrid.keys.removeFocus(parTableGrid.keys._nCurrentFocus, true);
			parTableGrid.keys.releaseKeys();
			showCoverNoteInquiry();
		}
	});
	
	/*$("btnCoverNoteInquiry").observe("click", function(){
		if (changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
							function(){
								leaveParListing = showCoverNoteInquiry;
								saveParTableGrid();
							},
							function(){
								parTableGrid.keys.removeFocus(parTableGrid.keys._nCurrentFocus, true);
								parTableGrid.keys.releaseKeys();
								showCoverNoteInquiry();
							},
							""
			);
		}else{
			parTableGrid.keys.removeFocus(parTableGrid.keys._nCurrentFocus, true);
			parTableGrid.keys.releaseKeys();
			showCoverNoteInquiry();
		}
	});*/
	
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
							if (checkRITablesBeforePARCancel(parId, parStatus, parNo)){
							 	ok = true;	
							}
						}else{
							allowCancel = "N";
							if (checkRITablesBeforePARCancel(parId, parStatus, parNo)){
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

	initializeChangeTagBehavior(saveParTableGrid);
	
	
	
</script>
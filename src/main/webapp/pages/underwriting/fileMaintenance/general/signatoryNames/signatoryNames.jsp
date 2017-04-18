<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss071MainDiv" name="giiss071MainDiv" style="">
	<div id="signatoryNamesDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="signatoryNameExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Signatory Name Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss071" name="giiss071">		
		<div class="sectionDiv">
			<div id="signatoryNamesTableDiv" style="padding-top: 10px;">
				<div id="signatoryNamesTable" style="height: 290px; margin-left: 20px;"></div>
			</div>
			<div align="center" id="signatoryNamesFormDiv">
				<table style="margin-top: 20px;">
					<tr>
						<td class="rightAligned">Code</td>
						<td class="leftAligned" >
							<input id="txtSignatoryId" type="text" class="integerNoNegativeUnformattedNoComma" readonly="readonly" style="width: 250px; text-align: right;" tabindex="201" maxlength="12">
						</td>
						<td width="" class="rightAligned">Status</td>
						<td class="leftAligned">
							<input type="hidden" id="hidStatus"/>
							<input type="hidden" id="hidFileName"/>
							<div id="statusMeanDiv" class="required" style="width: 256px; height: 20px; border: solid gray 1px; float: left;">
								<input id="txtStatusMean" name="txtStatusMean" type="text" maxlength="100" class="required" style="border: none; float: left; width: 230px; height: 13px; margin: 0px;" tabindex="202" />
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchStatusMeanLOV" alt="Go" style="float: right;" tabindex="203"/>							
							</div>
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Signatory</td>
						<td class="leftAligned" colspan="3">
							<input id="txtSignatory" type="text" class="required" style="width: 632px; float: left; " tabindex="204" maxlength="50">
						</td>						
					</tr>	
					<tr>
						<td class="rightAligned">Designation</td>
						<td class="leftAligned">
							<input id="txtDesignation" type="text" class="" style="width: 250px;" tabindex="205" maxlength="50">
						</td>
						<td class="rightAligned">Res. Cert. No.</td>
						<td class="leftAligned">
							<input id="txtResCertNo" type="text" class="" style="width: 250px;" tabindex="206" maxlength="15">
						</td>
					</tr>	
					
					<tr>
						<td width="" class="rightAligned">Date Issued</td>
						<td class="leftAligned">
							<div id="resCertPlaceDiv" style="float: left; border: 1px solid gray; width: 255px; height: 20px;">
								<input id="txtResCertDate" name="txtResCertDate" readonly="readonly" type="text" maxlength="10" style="border: none; float: left; width: 230px; height: 13px; margin: 0px;" value="" tabindex="207"/>
								<img id="imgResCertDate" alt="imgDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" tabindex="208"/>
							</div>	
						</td>
						<td class="rightAligned">Place Issued</td>
						<td class="leftAligned">
							<input id="txtResCertPlace" type="text" class="" style="width: 250px;" tabindex="209" maxlength="25">
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 638px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 612px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="210"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="211"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 250px;" readonly="readonly" tabindex="212"></td>
						<td width="" class="rightAligned" style="padding-left: 45px;">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 250px;" readonly="readonly" tabindex="213"></td>
					</tr>	
				</table>
			</div>
			<div style="margin: 10px 0 10px 0;" align="center">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="214">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="215">
			</div>
			<div style="margin: 15px; padding: 10px; border-top: 1px solid #E0E0E0; margin-bottom: 0;" align="center">
				<input type="button" class="button" id="btnAttach" value="Attach" tabindex="216" style="width: 66px;">
				<input type="button" class="button" id="btnView" value="View" style="width: 66px;" tabindex="217">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="218">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="219">
</div>
<script type="text/javascript">	
	setModuleId("GIISS071");
	setDocumentTitle("Signatory Name Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	
	var rowIndex = -1;
		
	function saveGiiss071(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgSignatoryNames.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgSignatoryNames.geniisysRows);
		new Ajax.Request(contextPath+"/GIISSignatoryNamesController", {
			method: "POST",
			parameters : {action : "saveGiiss071",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS071.exitPage != null) {
							objGIISS071.exitPage();
						} else {
							tbgSignatoryNames._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiiss071);
	
	var objGIISS071 = {};
	var objSignatoryNames = null;
	objGIISS071.signatoryNamesList = JSON.parse('${jsonSignatoryNamesList}');
	objGIISS071.exitPage = null;
	
	var signatoryNamesTableModel = {
			url : contextPath + "/GIISSignatoryNamesController?action=showGiiss071&refresh=1",
			options : {
				width : '888px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objSignatoryNames = tbgSignatoryNames.geniisysRows[y];
					setFieldValues(objSignatoryNames);
					tbgSignatoryNames.keys.removeFocus(tbgSignatoryNames.keys._nCurrentFocus, true);
					tbgSignatoryNames.keys.releaseKeys();
					$("txtStatusMean").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgSignatoryNames.keys.removeFocus(tbgSignatoryNames.keys._nCurrentFocus, true);
					tbgSignatoryNames.keys.releaseKeys();
					$("txtStatusMean").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgSignatoryNames.keys.removeFocus(tbgSignatoryNames.keys._nCurrentFocus, true);
						tbgSignatoryNames.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
				},
				onSort: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgSignatoryNames.keys.removeFocus(tbgSignatoryNames.keys._nCurrentFocus, true);
					tbgSignatoryNames.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgSignatoryNames.keys.removeFocus(tbgSignatoryNames.keys._nCurrentFocus, true);
					tbgSignatoryNames.keys.releaseKeys();
				},				
				prePager: function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
					rowIndex = -1;
					setFieldValues(null);
					tbgSignatoryNames.keys.removeFocus(tbgSignatoryNames.keys._nCurrentFocus, true);
					tbgSignatoryNames.keys.releaseKeys();
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
				}
			},
			columnModel : [
				{ 								// this column will only use for deletion
				    id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
				    width: '0',				    
				    visible : false			
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},	
				{
					id : 'signatoryId',
					filterOption : true,
					filterOptionType: 'integerNoNegative',
					title : 'Code',
					titleAlign: 'right',
					align: 'right',
					width : '100px'	,
					renderer: function(value){
						return value == null || value == "" ? null : formatNumberDigits(value, 12);
					}
				},	
				{
					id : 'signatory',
					filterOption : true,
					title : 'Signatory',
					width : '200px'				
				},
				{
					id : 'designation',
					filterOption : true,
					title : 'Designation',
					width : '150px'				
				},	
				{
					id : 'resCertNo',
					filterOption : true,
					title : 'Res. Cert. No.',
					width : '110px'				
				},	
				{
					id : 'resCertDate',
					title : 'Date Issued',
					width : '90px',
					align: 'center',
					titleAlign: 'center',
					filterOption : true,
					filterOptionType: 'formattedDate'
				},	
				{
					id : 'resCertPlace',
					filterOption : true,
					title : 'Place Issued',
					width : '110px'				
				},	
				{
					id : 'statusMean',
					filterOption : true,
					title : 'Status',
					width : '81px'				
				},	
				{
					id : 'status',
					width : '0',
					visible: false				
				},	
				{
					id : 'fileName',
					width : '0',
					visible: false				
				},	
				{
					id : 'remarks',
					width : '0',
					visible: false				
				},
				{
					id : 'userId',
					width : '0',
					visible: false
				},
				{
					id : 'lastUpdate',
					width : '0',
					visible: false				
				}
			],
			rows : objGIISS071.signatoryNamesList.rows
		};

		tbgSignatoryNames = new MyTableGrid(signatoryNamesTableModel);
		tbgSignatoryNames.pager = objGIISS071.signatoryNamesList;
		tbgSignatoryNames.render("signatoryNamesTable");
	
	function setFieldValues(rec){
		try{
			$("txtSignatoryId").value = (rec == null ? "" : (rec.signatoryId == null ? "" : formatNumberDigits(rec.signatoryId, 12) ));
			$("txtSignatoryId").setAttribute("lastValidValue", $("txtSignatoryId").value);
			$("txtSignatory").value = (rec == null ? "" : unescapeHTML2(rec.signatory));
			$("txtDesignation").value = (rec == null ? "" : unescapeHTML2(rec.designation));
			$("hidStatus").value = (rec == null ? "" : rec.status);
			$("hidFileName").value = (rec == null ? "" : unescapeHTML2(rec.fileName));
			$("txtStatusMean").value = (rec == null ? "" : unescapeHTML2(rec.statusMean));
			$("txtResCertNo").value = (rec == null ? "" : unescapeHTML2(rec.resCertNo));
			$("txtResCertDate").value = (rec == null ? "" : rec.resCertDate);
			$("txtResCertDate").setAttribute("lastValidValue", (rec == null ? "" : rec.resCertDate));
			$("txtResCertPlace").value = (rec == null ? "" : unescapeHTML2(rec.resCertPlace));
			$("txtResCertPlace").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.resCertPlace)));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			rec == null ? disableButton("btnAttach") : enableButton("btnAttach");
			rec == null ? disableButton("btnView") : ($F("hidFileName") == "" ? disableButton("btnView") : enableButton("btnView"));
			objSignatoryNames = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.signatoryId = $F("txtSignatoryId") == "" ? null : $F("txtSignatoryId");
			obj.signatory = escapeHTML2($F("txtSignatory"));
			obj.designation =  escapeHTML2($F("txtDesignation"));
			obj.status = $F("hidStatus");
			obj.statusMean = $F("txtStatusMean");
			obj.resCertNo =  escapeHTML2($F("txtResCertNo"));
			obj.resCertDate = $F("txtResCertDate");
			obj.resCertPlace =  escapeHTML2($F("txtResCertPlace"));
			obj.remarks =  escapeHTML2($F("txtRemarks"));
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGiiss071;
			var sigNames = setRec(objSignatoryNames);
			if($F("btnAdd") == "Add"){
				tbgSignatoryNames.addBottomRow(sigNames);
			} else {
				tbgSignatoryNames.updateVisibleRowOnly(sigNames, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgSignatoryNames.keys.removeFocus(tbgSignatoryNames.keys._nCurrentFocus, true);
			tbgSignatoryNames.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function validateResCertFields(){
		if($F("txtResCertNo") == "" && ($F("txtResCertPlace") != "" || $F("txtResCertDate") != "")){
			/*$("txtResCertPlace").clear();
			$("txtResCertDate").clear();*/
			showMessageBox("Entry of Residence Certificate requires Residence Certificate Place and Date.", "E");
			return false;
		}
		if($F("txtResCertNo") != "" && ($F("txtResCertPlace") == "" || $F("txtResCertDate") == "")){
			showMessageBox("Entry of Residence Certificate requires Residence Certificate Place and Date.", "E");
			return false;
		}
		return true;
	}
	
	function validateInputs(mode){
		var addedSameSigIdExists = false;
		var deletedSameSigIdExists = false;						

		var addedSameSigExists = false;
		var deletedSameSigExists = false;	
		
		var addedSameCertExists = false;
		var deletedSameCertExists = false;	
		
		for(var i=0; i<tbgSignatoryNames.geniisysRows.length; i++){
			if(tbgSignatoryNames.geniisysRows[i].recordStatus == 0 || tbgSignatoryNames.geniisysRows[i].recordStatus == 1){	
				if (mode == "ADD"){							
					/*if(tbgSignatoryNames.geniisysRows[i].signatoryId == $F("txtSignatoryId") && $F("txtSignatoryId") != ""){
						addedSameSigIdExists = true;								
					}*/	
					if(unescapeHTML2(tbgSignatoryNames.geniisysRows[i].signatory) == $F("txtSignatory")){
						addedSameSigExists = true;
					}
					if(unescapeHTML2(tbgSignatoryNames.geniisysRows[i].resCertNo) == $F("txtResCertNo") && $F("txtResCertNo") != ""){
						addedSameCertExists = true;								
					}
				}else{
					if(unescapeHTML2(tbgSignatoryNames.geniisysRows[i].signatory) == $F("txtSignatory") 
							&& unescapeHTML2(objSignatoryNames.signatory) != $F("txtSignatory")){
						addedSameSigExists = true;
					}
					if(unescapeHTML2(tbgSignatoryNames.geniisysRows[i].resCertNo) == $F("txtResCertNo") && $F("txtResCertNo") != ""
							&& unescapeHTML2(objSignatoryNames.resCertNo) != $F("txtResCertNo")){
						addedSameCertExists = true;								
					}
				}
			} else if(tbgSignatoryNames.geniisysRows[i].recordStatus == -1){
				if (mode == "ADD"){
					/*if(tbgSignatoryNames.geniisysRows[i].signatoryId == $F("txtSignatoryId") && $F("txtSignatoryId") != ""){
						deletedSameSigIdExists = true;
					}*/
					if(unescapeHTML2(tbgSignatoryNames.geniisysRows[i].signatory) == $F("txtSignatory")){
						deletedSameSigExists = true;
					}
					if(unescapeHTML2(tbgSignatoryNames.geniisysRows[i].resCertNo) == $F("txtResCertNo") && $F("txtResCertNo") != ""){
						deletedSameCertExists = true;
					}
				}else{
					if(unescapeHTML2(tbgSignatoryNames.geniisysRows[i].signatory) == $F("txtSignatory") 
							&& unescapeHTML2(objSignatoryNames.signatory) != $F("txtSignatory")){
						deletedSameSigExists = true;
					}
					if(unescapeHTML2(tbgSignatoryNames.geniisysRows[i].resCertNo) == $F("txtResCertNo") && $F("txtResCertNo") != ""
							&& unescapeHTML2(objSignatoryNames.resCertNo) != $F("txtResCertNo")){
						deletedSameCertExists = true;
					}
				}
			}
		}
		
		if((addedSameSigExists && !deletedSameSigExists) || (deletedSameSigExists && addedSameSigExists)){
			showMessageBox("Record already exists with the same signatory.", "E");
			return false;
		} else if((addedSameCertExists && !deletedSameCertExists) || (deletedSameCertExists && addedSameCertExists)){
			showMessageBox("Record already exists with the same res_cert_no.", "E");
			return false;
		} else if((deletedSameSigExists && !addedSameSigExists) || (deletedSameCertExists && !addedSameCertExists)){
			if(validateResCertFields()){
				addRec();
			}
			return false;
		}
		
		
		return true;
	}
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("signatoryNamesFormDiv")){
				if($F("btnAdd") == "Add") {
					if (validateInputs("ADD")){
						new Ajax.Request(contextPath + "/GIISSignatoryNamesController", {
							parameters : {action : "valAddRec",
										  signatoryId : $F("txtSignatoryId"),
										  signatory:	$F("txtSignatory"),
										  resCertNo:	$F("txtResCertNo")},
							onCreate : showNotice("Processing, please wait..."),
							onComplete : function(response){
								hideNotice();
								if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
									if(validateResCertFields()){
										addRec();
									}
								}
							}
						});
					}
				} else {
					if(validateInputs("UPDATE")){
						new Ajax.Request(contextPath + "/GIISSignatoryNamesController", {
							parameters : {action : "valUpdateRec",
										  signatoryId : $F("txtSignatoryId"),
										  signatory:	$F("txtSignatory"),
										  resCertNo:	$F("txtResCertNo")},
							onCreate : showNotice("Processing, please wait..."),
							onComplete : function(response){
								hideNotice();
								if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
									if(validateResCertFields()){
										addRec();
									}
								}
							}
						});
					}
				}
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}	
	
	function deleteRec(){
		changeTagFunc = saveGiiss071;
		objSignatoryNames.recordStatus = -1;
		tbgSignatoryNames.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISSignatoryNamesController", {
				parameters : {action : "valDeleteRec",
							  signatoryId : $F("txtSignatoryId")},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						deleteRec();
					}
				}
			});
		} catch(e){
			showErrorMessage("valDeleteRec", e);
		}
	}
	
	function exitPage(){
		deleteFilesFromServer();
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}	
	
	function cancelGiiss071(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS071.exitPage = exitPage;
						saveGiiss071();
					}, exitPage
					, "");
		} else {
			exitPage();
		}
	}
	
	function showStatusLOV(isIconClicked){
		try{
			var searchString = isIconClicked ? "%" : ($F("txtStatusMean").trim() == "" ? "%" : $F("txtStatusMean"));	
			
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getCgRefCodeLOV5",
					domain:	"GIIS_SIGNATORY_NAMES.STATUS",
					searchString : searchString+"%",
					page : 1
				},
				title : "List of Signatory Statuses",
				width : 360,
				height : 386,
				columnModel : [ {
					id : "rvLowValue",
					width : '0px',
					visible: false
				}, {
					id : "rvMeaning",
					title : "Status",
					width : '345px'
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("hidStatus").value = row.rvLowValue;
						$("txtStatusMean").setAttribute("lastValidValue", row.rvMeaning);
						$("txtStatusMean").value = unescapeHTML2(row.rvMeaning);
					}
				},
				onCancel: function(){
					$("txtStatusMean").focus();
					$("txtStatusMean").value = $("txtStatusMean").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtStatusMean").value = $("txtStatusMean").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtStatusMean");
				} 
			});
		}catch(e){
			showErrorMessage("showStatusLOV", e);
		}		
	}
	
	function validateResCertDate(){
		if(compareDatesIgnoreTime(Date.parse($F("txtResCertDate")), new Date()) == -1){
			$("txtResCertDate").value = $("txtResCertDate").getAttribute("lastValidValue") == 'null' ? "" : $("txtResCertDate").getAttribute("lastValidValue");
			showMessageBox("Cannot record future issuance of Residence Certificate.", "I");
		}		
		if ($("txtResCertDate").value == "" && $F("txtResCertNo") != ""){
			$("txtResCertDate").value = $("txtResCertDate").getAttribute("lastValidValue") == 'null' ? "" : $("txtResCertDate").getAttribute("lastValidValue");
			showMessageBox("Entry of Residence Certificate requires Residence Certificate Place and Date.", "E");
		}
	}
	
	/** begin : patterned from signatory maintenance **/
	function showBrowsePicture(){
		try{
			overlayBrowsePicture = Overlay.show(contextPath+"/GIISSignatoryNamesController", {
				urlContent: true,
				urlParameters: {action : "showAttachPicture",						
								ajax : "1",
								signatoryId : $F('txtSignatoryId')
								},
			    title: "Browse Picture",
			    height: 115,
			    width: 355,
			    draggable: true
			});
		}catch(e){
			showErrorMessage("showAttachPicture", e);
		}
	};
	
	function viewAttachment(){
		try{
			new Ajax.Request(contextPath+"/GIISSignatoryNamesController", {
				method: "POST",
				parameters : {
				action : "GIISS071WriteFileToServer",
				fileName2 : $F("hidFileName"),
			  	fileName : $F("hidFileName").substring($F("hidFileName").lastIndexOf("/") + 1)
							  },
			  onCreate:function(){
					showNotice("Processing, please wait...");
				},
				onComplete : function(response){
					hideNotice();
					//marco - 12.21.2015 - GENQA 5013
					if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
						window.open(contextPath + $F("hidFileName").substr($F("hidFileName").indexOf("/", 3), $F("hidFileName").length));
					}
				}
			});
		}catch(e){
			showErrorMessage("viewAttachment",e);
		}
	}
	
	function deleteFilesFromServer(){
		try{
			new Ajax.Request(contextPath+"/GIISSignatoryNamesController", {
				method: "POST",
				parameters : {
				action : "GIISS071DeleteFilesFromServer"
							  },
			  onCreate:function(){
					showNotice("Processing, please wait...");
				},
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
								
					}
				}
			});
		}catch(e){
			showErrorMessage("deleteFilesFromServer",e);
		}
	}	
	/** end : patterned from signatory maintenance **/
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("txtSignatory").observe("keyup", function(){
		$("txtSignatory").value = $F("txtSignatory").toUpperCase();
	});
	
	$("searchStatusMeanLOV").observe("click", function(){
		showStatusLOV(true);
	});
	
	$("txtStatusMean").observe("change", function(){
		if (this.value != ""){
			showStatusLOV(false);
		}else{
			$("hidStatus").clear();
			this.setAttribute("lastValidValue", "");
		}
	});
	
	$("txtResCertNo").observe("change", function(){
		if (this.value == ""){
			$("txtResCertDate").clear();
			$("txtResCertPlace").clear();
		}
	});
	
	$("imgResCertDate").observe("click", function(){
		scwNextAction = validateResCertDate.runsAfterSCW(this, null);
						
		scwShow($("txtResCertDate"),this, null);
	});
	
	$("txtResCertDate").observe("change", function(){
		validateResCertDate();
	});
	
	$("txtResCertPlace").observe("change", function(){
		if (this.value == "" && $F("txtResCertNo") != ""){
			this.value = this.getAttribute("lastValidValue");
			showMessageBox("Entry of Residence Certificate requires Residence Certificate Place and Date.", "E");
			return;
		}
	});
	
	$("btnAttach").observe("click", function(){
		if ($F("txtStatusMean") == "Resigned")	{
			showMessageBox("Resigned Signatory. Cannot attach signature.", "E");
			return false;
		}else{
			if ($F("hidFileName") != ""){
				showConfirmBox("CONFIRMATION", "Do you want to replace the current image attached?", "Ok", "Cancel",
								showBrowsePicture, 
								""		
				);
			}else if ($F("hidFileName") == ""){
				showBrowsePicture();
			}
		}
	});
	
	$("btnView").observe("click", function(){
		new Ajax.Request(contextPath+"/GIISSignatoryNamesController",{
			parameters: {
				action:			"getFilename",
				signatoryId:	$F("txtSignatoryId")
			},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					if (response.responseText == "" || response.responseText == null){
						showMessageBox("No attachments found.", "E");
					}else{
						viewAttachment();
					}
				}
			}
		});
	});
	
	disableButton("btnDelete");
	disableButton("btnAttach");
	disableButton("btnView");
	
	observeSaveForm("btnSave", saveGiiss071);
	$("btnCancel").observe("click", cancelGiiss071);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("signatoryNameExit").stopObserving("click");
	$("signatoryNameExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	$("txtStatusMean").focus();	
	deleteFilesFromServer();
</script>
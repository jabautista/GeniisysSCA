<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<jsp:include page="/pages/toolbar.jsp"></jsp:include>
<div id="giacs322MainDiv" name="giacs322MainDiv" style="">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Document Sequence per Branch Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giacs322" name="giacs322">	
		<div id="queryRecordsDiv" align="center" class="sectionDiv" style="padding-top:20px; padding-bottom: 20px;">
			<table cellspacing="0" width: 900px;">
				<tr>
					<td class="rightAligned" style="width:50px;">Company</td>
					<td class="leftAligned" style="width:350px;">
						<span class="lovSpan" style="width: 70px; height: 21px; margin: 2px 2px 0 0; float: left;">
							<input type="text" id="txtCompany" name="txtCompany" ignoreDelKey="1" style="width: 43px; float: left; border: none; height: 13px;" class="required disableDelKey allCaps" maxlength="3" tabindex="101" />
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchCompany" name="searchCompany" alt="Go" style="float: right;">
						</span> 
						<span class="lovSpan" style="border: none; height: 21px; margin: 0 2px 0 2px; float: left;">
							<input type="text" id="txtCompanyDesc" name="txtCompanyDesc" ignoreDelKey="1" style="width: 250px; float: left; height: 15px;" class="allCaps" maxlength="30" readonly="readonly" tabindex="102" />
						</span>
					</td>
					<td class="rightAligned" style="width:50px;">Branch</td>
					<td class="leftAligned" style="width:350px;">
						<span class="lovSpan required" style="width: 70px; height: 21px; margin: 2px 2px 0 0; float: left;">
							<input type="text" id="txtBranch" name="txtBranch" ignoreDelKey="1" style="width: 43px; float: left; border: none; height: 13px;" class="required disableDelKey allCaps" maxlength="2" tabindex="103" />
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranch" name="searchBranch" alt="Go" style="float: right;">
						</span> 
						<span class="lovSpan" style="border: none; height: 21px; margin: 0 2px 0 2px; float: left;">
							<input type="text" id="txtBranchDesc" name="txtBranchDesc" ignoreDelKey="1" style="width: 250px; float: left; height: 15px;" class="allCaps" maxlength="30" readonly="readonly" tabindex="104" />
						</span>
					</td>
				</tr>
			</table>
		</div>	
		<div class="sectionDiv">
			<div id="docSeqPerBranchTableDiv" style="padding-top: 10px;">
				<div id="docSeqPerBranchTable" style="height: 340px; margin-left: 115px;"></div>
			</div>
			<div align="center" id="docSeqPerBranchFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td width="" class="rightAligned">Document Name</td>
						<td class="leftAligned" colspan="3">
							<input id="txtDocName" type="text" class="required" style="width: 533px;" tabindex="201" maxlength="30" readonly="readonly">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Prefix</td>
						<td class="leftAligned">
							<input id="txtPref" type="text" class="" style="width: 200px; text-align: left;" tabindex="202" maxlength="5" readonly="readonly">
						</td>
						<td class="rightAligned" width="113px">Sequence Number</td>
						<td class="leftAligned">
							<input id="txtDocSeqNo" type="text" class="required integerNoNegativeUnformattedNoComma" style="width: 200px; text-align: right;" tabindex="203" maxlength="10" readonly="readonly">
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Approved Series</td>
						<td class="leftAligned" colspan="3">
							<input id="txtApprovedSeries" type="text" class="" style="width: 533px;" tabindex="204" maxlength="100" readonly="readonly" >
						</td>
					</tr>				
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="205" readonly="readonly"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="206"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="207"></td>
						<td width="" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="208"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;" align="center">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="209">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="210">
			</div>
			<div align="center" style="margin: 10px; padding: 10px; border-top: 1px solid #E0E0E0; margin-bottom: 0px;">
				<input type="button" class="disabledButton" id="btnCheckNumber" value="Check Number"  style="width: 130px;" tabindex="211">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="212">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="213">
</div>
<script type="text/javascript">	
	setModuleId("GIACS322");
	setDocumentTitle("Document Sequence per Branch Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	showToolbarButton("btnToolbarSave"); 
	hideToolbarButton("btnToolbarPrint");
	disableToolbarButton("btnToolbarExecuteQuery");
	disableButton("btnAdd");
	
	function saveGiacs322(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgDocSeqPerBranch.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgDocSeqPerBranch.geniisysRows);
		new Ajax.Request(contextPath+"/GIACDocSequenceController", {
			method: "POST",
			parameters : {action : "saveGiacs322",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIACS322.exitPage != null) {
							objGIACS322.exitPage();
						} else if (objGIACS322.enterQuery != null){
							objGIACS322.enterQuery();
						} else {
							tbgDocSeqPerBranch._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiacs322);
	
	var objGIACS322 = {};
	var objCurrDocSeqTitle = null;
	objGIACS322.docSequence = JSON.parse('${jsonDocSequence}');
	objGIACS322.exitPage = null;
	
	var docSeqPerBranchTable = {
			url : contextPath + "/GIACDocSequenceController?action=showGiacs322&refresh=1",
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrDocSeqTitle = tbgDocSeqPerBranch.geniisysRows[y];
					setFieldValues(objCurrDocSeqTitle);
					tbgDocSeqPerBranch.keys.removeFocus(tbgDocSeqPerBranch.keys._nCurrentFocus, true);
					tbgDocSeqPerBranch.keys.releaseKeys();
					$("txtPref").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgDocSeqPerBranch.keys.removeFocus(tbgDocSeqPerBranch.keys._nCurrentFocus, true);
					tbgDocSeqPerBranch.keys.releaseKeys();
					$("txtDocName").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgDocSeqPerBranch.keys.removeFocus(tbgDocSeqPerBranch.keys._nCurrentFocus, true);
						tbgDocSeqPerBranch.keys.releaseKeys();
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
					tbgDocSeqPerBranch.keys.removeFocus(tbgDocSeqPerBranch.keys._nCurrentFocus, true);
					tbgDocSeqPerBranch.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgDocSeqPerBranch.keys.removeFocus(tbgDocSeqPerBranch.keys._nCurrentFocus, true);
					tbgDocSeqPerBranch.keys.releaseKeys();
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
					tbgDocSeqPerBranch.keys.removeFocus(tbgDocSeqPerBranch.keys._nCurrentFocus, true);
					tbgDocSeqPerBranch.keys.releaseKeys();
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
					id : "docName",
					title : "Document Name",
					filterOption : true,
					width : '420px'
				},
				{
					id : 'docPrefSuf',
					filterOption : true,
					title : 'Prefix',
					width : '120px'				
				},
				{
					id : 'docSeqNo',
					filterOption : true,
					title : 'Sequence Number',
					width : '120px',
					align : "right",
					titleAlign : "right",
					filterOptionType: 'integerNoNegative',
					
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
			rows : objGIACS322.docSequence.rows
		};

		tbgDocSeqPerBranch = new MyTableGrid(docSeqPerBranchTable);
		tbgDocSeqPerBranch.pager = objGIACS322.docSequence;
		tbgDocSeqPerBranch.render("docSeqPerBranchTable");
	
	function setFieldValues(rec){
		try{
			$("txtDocName").value = (rec == null ? "" : unescapeHTML2(rec.docName));
			$("txtDocName").setAttribute("lastValidValue", (rec == null ? "" :unescapeHTML2(rec.docName)));
			$("txtDocSeqNo").value = (rec == null ? "" : unescapeHTML2(rec.docSeqNo));
			$("txtPref").value = (rec == null ? "" : unescapeHTML2(rec.docPrefSuf));
			$("txtApprovedSeries").value = (rec == null ? "" : unescapeHTML2(rec.approvedSeries));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
				
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtDocName").readOnly = false : $("txtDocName").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objCurrDocSeqTitle = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.fundCd = escapeHTML2($F("txtCompany"));
			obj.branchCd = escapeHTML2($F("txtBranch"));
			obj.docName = escapeHTML2($F("txtDocName"));
			obj.docSeqNo = $F("txtDocSeqNo");
			obj.approvedSeries = escapeHTML2($F("txtApprovedSeries"));
			obj.docPrefSuf = escapeHTML2($F("txtPref"));
			obj.remarks = escapeHTML2($F("txtRemarks"));
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
			changeTagFunc = saveGiacs322;
			var dept = setRec(objCurrDocSeqTitle);
			if($F("btnAdd") == "Add"){
				tbgDocSeqPerBranch.addBottomRow(dept);
			} else {
				tbgDocSeqPerBranch.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgDocSeqPerBranch.keys.removeFocus(tbgDocSeqPerBranch.keys._nCurrentFocus, true);
			tbgDocSeqPerBranch.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("docSeqPerBranchFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;	
					
					for ( var i = 0; i < tbgDocSeqPerBranch.geniisysRows.length; i++) {
						if (tbgDocSeqPerBranch.geniisysRows[i].recordStatus == 0 || tbgDocSeqPerBranch.geniisysRows[i].recordStatus == 1) {
							if (unescapeHTML2(tbgDocSeqPerBranch.geniisysRows[i].docName) == $F("txtDocName")) {
								addedSameExists = true;
							}
						} else if (tbgDocSeqPerBranch.geniisysRows[i].recordStatus == -1) {
							if (unescapeHTML2(tbgDocSeqPerBranch.geniisysRows[i].docName) == $F("txtDocName")) {
								deletedSameExists = true;
							}
						}
					}
					if ((addedSameExists && !deletedSameExists)|| (deletedSameExists && addedSameExists)) {
						showMessageBox("Record already exists with the same doc_name.", "E");
						return;
					} else if (deletedSameExists && !addedSameExists) {
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GIACDocSequenceController", {
						parameters : {action : "valAddRec",
									  docName : $F("txtDocName"),
									  fundCd : $F("txtCompany"), 
									  branchCd : $F("txtBranch")
									  },
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(response.responseText == "Y"){
								showMessageBox("Record already exists with the same doc_name.", imgMessage.ERROR);
							} else {
								addRec();
							}
						}
					});
				} else {
					addRec();
				}
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}	
	
	function deleteRec(){
		changeTagFunc = saveGiacs322;
		objCurrDocSeqTitle.recordStatus = -1;
		tbgDocSeqPerBranch.geniisysRows[rowIndex].fundCd = escapeHTML2(tbgDocSeqPerBranch.geniisysRows[rowIndex].fundCd);
		tbgDocSeqPerBranch.geniisysRows[rowIndex].branchCd = escapeHTML2(tbgDocSeqPerBranch.geniisysRows[rowIndex].branchCd);
		tbgDocSeqPerBranch.geniisysRows[rowIndex].docName = escapeHTML2(tbgDocSeqPerBranch.geniisysRows[rowIndex].docName);
		tbgDocSeqPerBranch.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIACDocSequenceController", {
				parameters : {action : "valDeleteRec",
							  docName : $F("txtDocName"),
							 },
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
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	}	
	
	function cancelGiacs322(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIACS322.exitPage = exitPage;
						saveGiacs322();
					}, function(){
						goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		}
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGiacs322);
	$("btnCancel").observe("click", cancelGiacs322);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);
	
	observeSaveForm("btnToolbarSave", saveGiacs322);

	$("btnToolbarExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtCompany").focus();	
	
	$("searchCompany").observe("click",function(){
		showCompanyLOV("%");
	});
	
	$("searchBranch").observe("click",function(){
		showBranchLOV("%");
	});
	
	function showCompanyLOV(x){
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					  action : "getGiacs322CompanyLOV",
					  search : x,
						page : 1
				},
				title: "List of Companies",
				width: 470,
				height: 400,
				columnModel: [
		 			{
						id : 'fundCd',
						title: 'Company Code',
						width : '100px',
						align: 'left'
					},
					{
						id : 'fundDesc',
						title: 'Company Name',
					    width: '335px',
					    align: 'left'
					}
				],
				autoSelectOneRecord : true,
				draggable: true,
				filterText: nvl(escapeHTML2(x), "%"), 
				onSelect: function(row) {
					if(row != undefined){
						$("txtCompany").value = unescapeHTML2(row.fundCd);
						$("txtCompanyDesc").value = unescapeHTML2(row.fundDesc);
						if($("txtCompany").getAttribute("lastValidValue") != $("txtCompany").value){
							$("txtBranch").value = "";
							$("txtBranchDesc").value = "";
							$("txtBranch").setAttribute("lastValidValue", "");
							$("txtBranchDesc").setAttribute("lastValidValue", "");
						}
						$("txtCompany").setAttribute("lastValidValue", unescapeHTML2(row.fundCd));
						$("txtCompanyDesc").setAttribute("lastValidValue", unescapeHTML2(row.fundDesc));
						enableToolbarButton("btnToolbarEnterQuery");
						enableToolbarButton("btnToolbarExecuteQuery");
					}
				},
				onCancel: function(){
					$("txtCompany").focus();
					$("txtCompany").value = $("txtCompany").getAttribute("lastValidValue");
					$("txtCompanyDesc").value = $("txtCompanyDesc").getAttribute("lastValidValue");
		  		},
				onUndefinedRow: function(){
					$("txtCompany").value = $("txtCompany").getAttribute("lastValidValue");
					$("txtCompanyDesc").value = $("txtCompanyDesc").getAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtCompany");
		  		}
			});
		}catch(e){
			showErrorMessage("showCompanyLOV",e);
		}
	}
	
	function showBranchLOV(x){
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					  action : "getGiacs322BranchLOV",
					  search : x,
					  fundCd : $("txtCompany").value,
						page : 1
				},
				title: "List of Branches",
				width: 470,
				height: 400,
				columnModel: [
		 			{
						id : 'branchCd',
						title: 'Branch Code',
						width : '100px',
						align: 'left'
					},
					{
						id : 'branchName',
						title: 'Branch Name',
					    width: '335px',
					    align: 'left'
					}
				],
				autoSelectOneRecord : true,
				filterText: nvl(escapeHTML2(x), "%"), 
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtBranch").value = unescapeHTML2(row.branchCd);
						$("txtBranchDesc").value = unescapeHTML2(row.branchName);
						$("txtBranch").setAttribute("lastValidValue", unescapeHTML2(row.branchCd));
						$("txtBranchDesc").setAttribute("lastValidValue", unescapeHTML2(row.branchName));
						enableToolbarButton("btnToolbarEnterQuery");
						enableToolbarButton("btnToolbarExecuteQuery");
					}
				},
				onCancel: function(){
					$("txtBranch").focus();
					$("txtBranch").value = $("txtBranch").getAttribute("lastValidValue");
					$("txtBranchDesc").value = $("txtBranchDesc").getAttribute("lastValidValue");
		  		},
		  		onUndefinedRow: function(){
		  			$("txtBranch").value = $("txtBranch").getAttribute("lastValidValue");
					$("txtBranchDesc").value = $("txtBranchDesc").getAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtBranch");
		  		}
			});
		}catch(e){
			showErrorMessage("showBranchLOV",e);
		}
	}
	
	$("txtBranch").observe("change",function(){
		if($("txtBranch").value == ""){
			$("txtBranchDesc").value = "";
			disableToolbarButton("btnToolbarExecuteQuery");
			if($("txtCompany").value == ""){
				disableToolbarButton("btnToolbarEnterQuery");
			}
			$("txtBranch").setAttribute("lastValidValue", "");
			$("txtBranchDesc").setAttribute("lastValidValue", "");
		} else if ($("txtBranch").value != ""){
			showBranchLOV($F("txtBranch"));
		}
	});
	
	$("txtCompany").observe("change",function(){
		if($("txtCompany").value == ""){
			$("txtCompanyDesc").value = "";
			disableToolbarButton("btnToolbarExecuteQuery");
			if($("txtBranch").value == ""){
				disableToolbarButton("btnToolbarEnterQuery");
			}
			$("txtBranch").value = "";
			$("txtBranchDesc").value = "";
			$("txtCompany").setAttribute("lastValidValue", "");
			$("txtCompanyDesc").setAttribute("lastValidValue", "");
			$("txtBranch").setAttribute("lastValidValue", "");
			$("txtBranchDesc").setAttribute("lastValidValue", "");
		} else if ($("txtCompany").value != ""){
			showCompanyLOV($F("txtCompany"));
		}
	});
	
	function executeState(){
		tbgDocSeqPerBranch.url = contextPath +"/GIACDocSequenceController?action=showGiacs322&refresh=1&fundCd="+encodeURIComponent($F("txtCompany"))+"&branchCd="+ encodeURIComponent($F("txtBranch"));
		tbgDocSeqPerBranch._refreshList();
		disableToolbarButton("btnToolbarExecuteQuery");
		disableSearch("searchCompany");
		disableSearch("searchBranch");
		$("txtCompany").readOnly = true;
		$("txtBranch").readOnly = true;
		$("txtDocName").readOnly = false;
		$("txtPref").readOnly = false;
		$("txtDocSeqNo").readOnly = false;
		$("txtApprovedSeries").readOnly = false;
		$("txtRemarks").readOnly = false;
		enableButton("btnAdd");
		if(checkUserModule("GIACS326")){
			enableButton("btnCheckNumber");
		}
	}
	
	function checkBranch(){
		new Ajax.Request(contextPath + "/GIACCheckNoController", {
			parameters: {
				action: "checkBranch",
				fundCd: $F("txtCompany"),
				branchCd: $F("txtBranch")
			},
			asynchronous: false,
			evalScripts:true,
	        onCreate: showNotice("Processing, please wait..."),
	        onComplete: function(response){
	        	hideNotice();
	        	if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
	        		showGIACS326();
	        	}
	        }
		});
	}
	
	function showGIACS326(){
		new Ajax.Request(contextPath + "/GIACCheckNoController", {
			method: "POST",
			parameters: {
				action: "showGIACS326",
				fundCd: $F("txtCompany"),
				fundDesc: $F("txtCompanyDesc"),
				branchCd: $F("txtBranch"),
				branchName: $F("txtBranchDesc")
			},
			asynchronous: false,
			evalScripts:true,
	        onCreate: showNotice("Loading, please wait..."),
	        onComplete: function(response){
	        	hideNotice();
	        	if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
	        		$("dynamicDiv").update(response.responseText);
	        	}
	        }
		});
	}
	
	$("btnCheckNumber").observe("click", function(){
		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
				function(){
					objGIACS322.exitPage = checkBranch;
					saveGiacs322();
				}, function(){
					checkBranch();
				}, "");
		}else{
			checkBranch();
		}
	});
	
	$("btnToolbarExecuteQuery").observe("click",function(){
		if(checkAllRequiredFieldsInDiv("queryRecordsDiv")){
			executeState();
		}
	});
	
	$("btnToolbarEnterQuery").observe("click", function(){
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						objGIACS322.enterQuery = showGiacs322;
						saveGiacs322();
					}, function() {
						showGiacs322();
					}, "");
		} else {
			showGiacs322();
		}
	});
	
	if(nvl('${fundCd}', "") == ""){
		disableToolbarButton("btnToolbarEnterQuery");		
	}else{
		$("txtCompany").value = '${fundCd}';
		$("txtCompanyDesc").value = '${fundDesc}';
		$("txtBranch").value = '${branchCd}';
		$("txtBranchDesc").value = '${branchName}';
		tbgDocSeqPerBranch.url = contextPath +"/GIACDocSequenceController?action=showGiacs322&refresh=1&fundCd="+encodeURIComponent($F("txtCompany"))+"&branchCd="+ encodeURIComponent($F("txtBranch"));
	}
</script>
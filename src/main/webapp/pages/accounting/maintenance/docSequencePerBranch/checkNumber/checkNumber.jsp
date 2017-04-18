<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="giacs326MainDiv" name="giacs326MainDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>

	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Check Number Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>
	
	<div>
		<div id="headerDiv" align="center" class="sectionDiv" style="padding-top:12px; padding-bottom: 15px;">
			<table cellspacing="0" style="width: 96%;">
				<tr>
					<td class="rightAligned" style="width:50px;">Company</td>
					<td class="leftAligned" style="width:350px;">
						<input type="text" id="fundCd" name="fundCd" style="width: 64px; float: left; height: 15px; margin-right: 4px;" readonly="readonly" tabindex="101" value="${fundCd}"/>
						<input type="text" id="fundDesc" name="fundDesc" style="width: 287px; float: left; height: 15px;" readonly="readonly" tabindex="102" value="${fundDesc}"/>
					</td>
					<td class="rightAligned" style="width:50px;">Branch</td>
					<td class="leftAligned" style="width:310px;">
						<input type="text" id="branchCd" name="branchCd" style="width: 64px; float: left; height: 15px; margin-right: 4px;" readonly="readonly" tabindex="103" value="${branchCd}"/>
						<input type="text" id="branchName" name="branchName" style="width: 250px; float: left; height: 15px;" readonly="readonly" tabindex="104" value="${branchName}"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width:50px;">Bank</td>
					<td class="leftAligned" style="width:350px;">
						<span class="required lovSpan" style="width: 70px; height: 21px; margin: 2px 2px 0 0; float: left;">
							<input type="text" id="bankCd" name="headerField" ignoreDelKey="1" style="width: 43px; float: left; border: none; height: 13px; text-align: right;" class="required integerNoNegativeUnformattedNoComma" maxlength="3" tabindex="105" lastValidValue=""/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBank" name="searchBank" alt="Go" style="float: right;">
						</span>
						<span class="lovSpan" style="border: none; height: 21px; margin: 0 2px 0 2px; float: left;">
							<input type="text" id="bankSName" name="headerField" style="width: 75px; float: left; height: 15px;" class="allCaps" maxlength="30" readonly="readonly" tabindex="106" />
						</span>
						<span class="lovSpan" style="border: none; height: 21px; margin: 0 2px 0 2px; float: left;">
							<input type="text" id="bankName" name="headerField" style="width: 200px; float: left; height: 15px;" class="allCaps" maxlength="30" readonly="readonly" tabindex="107" />
						</span>
					</td>
					<td class="rightAligned" style="width:75px;">Bank Account</td>
					<td class="leftAligned" style="width:310px;">
						<span class="required lovSpan" style="width: 70px; height: 21px; margin: 2px 2px 0 0; float: left;">
							<input type="text" id="bankAcctCd" name="headerField" ignoreDelKey="1" style="width: 43px; float: left; border: none; height: 13px;" class="required" maxlength="4" tabindex="108" lastValidValue=""/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBankAcct" name="searchBankAcct" alt="Go" style="float: right;">
						</span> 
						<span class="lovSpan" style="border: none; height: 21px; margin: 0 2px 0 2px; float: left;">
							<input type="text" id="bankAcctNo" name="headerField" ignoreDelKey="1" style="width: 250px; float: left; height: 15px;" class="allCaps" maxlength="30" readonly="readonly" tabindex="109" />
						</span>
					</td>
				</tr>
			</table>
		</div>
		
		<div class="sectionDiv" style="height: 495px;">
			<div style="padding-top: 10px;">
				<div id="checkNoTable" style="height: 340px; margin-left: 250px;"></div>
			</div>
			
			<div align="center" id="checkNoFormDiv" style="margin-right: 15px;">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Check Prefix</td>
						<td class="leftAligned"><input id="chkPrefix" type="text" class="required upper" style="width: 180px;" maxlength="5" readonly="readonly" tabindex="110"></td>
						<td class="rightAligned">Sequence Number</td>
						<td class="leftAligned"><input id="checkSeqNo" type="text" class="required integerNoNegativeUnformattedNoComma" style="width: 180px; text-align: right;" lastValidValue="" readonly="readonly" maxlength="15" tabindex="111"></td>
					</tr>
					<tr>
						<td class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 516px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 488px; margin-top: 0; border: none;" id="remarks" name="remarks" maxlength="4000" readonly="readonly" onkeyup="limitText(this,4000);" tabindex="112"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="userId" type="text" style="width: 180px; margin-right: 25px;" readonly="readonly" tabindex="113"></td>
						<td class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="lastUpdate" type="text" style="width: 180px;" readonly="readonly" tabindex="114"></td>
					</tr>
				</table>
			</div>
			
			<div style="margin: 10px;" align="center">
				<input type="button" class="disabledButton" id="btnAdd" value="Add" tabindex="115">
				<input type="button" class="disabledButton" id="btnDelete" value="Delete" tabindex="116">
			</div>
		</div>
	</div>
	<div class="buttonsDiv">
		<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="117">
		<input type="button" class="button" id="btnSave" value="Save" tabindex="118">
	</div>
</div>

<script type="text/javascript">
	var rowIndex = -1;
	var objGIACS326 = {};
	var selectedRow = null;
	var queryMode = "Y";
	objGIACS326.exitPage = null;

	var checkNoModel = {
		url: contextPath + "/GIACCheckNoController?action=showGIACS326&refresh=1",
		options: {
			width: '455px',
			height: '332px',
			pager: {},
			onCellFocus: function(element, value, x, y, id){
				rowIndex = y;
				setFieldValues(checkNoTG.geniisysRows[y]);
				checkNoTG.keys.removeFocus(checkNoTG.keys._nCurrentFocus, true);
				checkNoTG.keys.releaseKeys();
			},
			onRemoveRowFocus: function(){
				rowIndex = -1;
				setFieldValues(null);
				checkNoTG.keys.removeFocus(checkNoTG.keys._nCurrentFocus, true);
				checkNoTG.keys.releaseKeys();
			},
			toolbar: {
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
				onFilter: function(){
					checkNoTG.onRemoveRowFocus();
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
				checkNoTG.onRemoveRowFocus();
			},
			onRefresh: function(){
				checkNoTG.onRemoveRowFocus();
			},				
			prePager: function(){
				if(changeTag == 1){
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
						$("btnSave").focus();
					});
					return false;
				}
				checkNoTG.onRemoveRowFocus();
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
			{   id: 'recordStatus',
			    width: '0',				    
			    visible: false			
			},
			{	id: 'divCtrId',
				width: '0',
				visible: false
			},
			{	id: 'chkPrefix',
				title: 'Check Prefix',
				width: '155px',
				filterOption: true
			},
			{	id: 'checkSeqNo',
				title: 'Sequence Number',
				width: '260px',
				align: 'right',
				titleAlign: 'right',
				filterOption: true,
				filterOptionType: 'integerNoNegative'
			}
		],
		rows: []
	};
	checkNoTG = new MyTableGrid(checkNoModel);
	checkNoTG.pager = {};
	checkNoTG.render("checkNoTable");
	
	function newFormInstance(){
		changeTag = 0;
		initializeAll();
		toggleHeader();
		makeInputFieldUpperCase();
		setModuleId("GIACS326");
		setDocumentTitle("Check Number Maintenance");
		hideToolbarButton("btnToolbarPrint");
		showToolbarButton("btnToolbarSave");
		$("bankCd").focus();
	}
	
	function showGIACS326(){
		new Ajax.Request(contextPath + "/GIACCheckNoController", {
			method: "POST",
			parameters: {
				action : "showGIACS326",
				fundCd: $F("fundCd"),
				fundDesc: $F("fundDesc"),
				branchCd: $F("branchCd"),
				branchName: $F("branchName")
			},
			asynchronous: false,
			evalScripts:true,
	        onCreate: showNotice("Loading, please wait..."),
	        onComplete: function(response){
	        	hideNotice();
	        	if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
	        		changeTag = 0;
	        		$("dynamicDiv").update(response.responseText);
	        	}
	        }
		});
	}
	
	function showBankLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {
				action: "getBankLOV",
				fundCd: $F("fundCd"),
				branchCd: $F("branchCd"),
				filterText: $F("bankCd") != $("bankCd").getAttribute("lastValidValue") ? nvl($F("bankCd"), "%") : "%"
			},
			title: "List of Banks",
			width: 390,
			height: 386,
			columnModel:[
							{	id: "bankCd",
								title: "Bank Code",
								width: "85px",
								align: 'right',
								titleAlign: 'right'
							},
							{	id: "bankSName",
								title: "Bank Short Name",
								width: "125px"
							},
							{	id: "bankName",
								title: "Bank Name",
								width: "160px"
							}
						],
			draggable: true,
			showNotice: true,
			autoSelectOneRecord : true,
			filterText: $F("bankCd") != $("bankCd").getAttribute("lastValidValue") ? nvl($F("bankCd"), "%") : "%",
		    noticeMessage: "Getting list, please wait...",
			onSelect : function(row){
				if(row != undefined) {
					$("bankCd").value = unescapeHTML2(row.bankCd);
					$("bankSName").value = unescapeHTML2(row.bankSName);
					$("bankName").value = unescapeHTML2(row.bankName);
					$("bankCd").setAttribute("lastValidValue", $F("bankCd"));
					
					$("bankAcctCd").value = "";
					$("bankAcctNo").value = "";
					$("bankAcctCd").setAttribute("lastValidValue", "");
					$("bankAcctCd").focus();
					toggleHeader();
				}
			},
			onCancel: function(){
				$("bankCd").value = $("bankCd").getAttribute("lastValidValue");
			},
			onUndefinedRow: function(){
				showMessageBox("No record selected.", "I");
				$("bankCd").value = $("bankCd").getAttribute("lastValidValue");
			},
			onShow: function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		});
	}
	
	function showBankAcctLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {
				action: "getBankAcctLOV",
				bankCd: $F("bankCd"),
				filterText: $F("bankAcctCd") != $("bankAcctCd").getAttribute("lastValidValue") ? nvl($F("bankAcctCd"), "%") : "%"
			},
			title: "List of Bank Accounts",
			width: 340,
			height: 386,
			columnModel:[
							{	id: "bankAcctCd",
								title: "Bank Account Code",
								width: "130px"
							},
							{	id: "bankAcctNo",
								title: "Bank Account No.",
								width: "195px"
							}
						],
			draggable: true,
			showNotice: true,
			autoSelectOneRecord : true,
			filterText: $F("bankAcctCd") != $("bankAcctCd").getAttribute("lastValidValue") ? nvl($F("bankAcctCd"), "%") : "%",
		    noticeMessage: "Getting list, please wait...",
			onSelect : function(row){
				if(row != undefined) {
					$("bankAcctCd").value = unescapeHTML2(row.bankAcctCd);
					$("bankAcctNo").value = unescapeHTML2(row.bankAcctNo);
					$("bankAcctCd").setAttribute("lastValidValue", $F("bankAcctCd"));
					toggleHeader();
				}
			},
			onCancel: function(){
				$("bankAcctCd").value = $("bankAcctCd").getAttribute("lastValidValue");
			},
			onUndefinedRow: function(){
				showMessageBox("No record selected.", "I");
				$("bankAcctCd").value = $("bankAcctCd").getAttribute("lastValidValue");
			},
			onShow: function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		});
	}
	
	function toggleHeader(){
		if($F("bankCd") == "" && $F("bankAcctCd") == ""){
			disableToolbarButton("btnToolbarExecuteQuery");
			disableToolbarButton("btnToolbarEnterQuery");
		}else if($F("bankCd") != "" && $F("bankAcctCd") != ""){
			enableToolbarButton("btnToolbarExecuteQuery");
			enableToolbarButton("btnToolbarEnterQuery");
		}else if($F("bankCd") != "" || $F("bankAcctCd") != ""){
			disableToolbarButton("btnToolbarExecuteQuery");
			enableToolbarButton("btnToolbarEnterQuery");
		}
	}
	
	function resetForm(){
		$("bankCd").focus();
		$$("input[name='headerField']").each(function(i){
			i.value = "";
			i.setAttribute("lastValidValue", "");
		});
		
		checkNoTG.url = contextPath +"/GIACCheckNoController?action=showGIACS326&refresh=1";
		checkNoTG._refreshList();
		
		objGIACS326.exitPage = null;
		queryMode = "Y";
		changeTag = 0;
		toggleHeader();
		
		enableSearch("searchBank");
		enableSearch("searchBankAcct");
		
		enableInputField("bankCd");
		enableInputField("bankAcctCd");
		
		disableButton("btnAdd");
		disableButton("btnDelete");
		
		disableInputField("chkPrefix");
		disableInputField("checkSeqNo");
		disableInputField("remarks");
	}
	
	function enterQuery(){
		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
				function(){
					objGIACS326.exitPage = resetForm;
					saveGIACS326();
				}, resetForm, "");
		} else {
			resetForm();
		}
	}
	
	function executeQuery(){
		if(!checkAllRequiredFieldsInDiv("headerDiv")){
			return;
		}
		
		queryMode = "N";
		checkNoTG.url = contextPath + "/GIACCheckNoController?action=showGIACS326&refresh=1"+
										"&fundCd="+encodeURIComponent($F("fundCd"))+"&branchCd="+encodeURIComponent($F("branchCd"))+
										"&bankCd="+encodeURIComponent($F("bankCd"))+"&bankAcctCd="+encodeURIComponent($F("bankAcctCd"));
		checkNoTG._refreshList();
		
		enableInputField("checkSeqNo");
		enableInputField("remarks");
		enableButton("btnAdd");
		
		disableInputField("bankCd");
		disableInputField("bankAcctCd");
		disableSearch("searchBank");
		disableSearch("searchBankAcct");
		disableToolbarButton("btnToolbarExecuteQuery");
	}
	
	function setFieldValues(rec){
		try{
			$("chkPrefix").value = (rec == null ? "" : unescapeHTML2(rec.chkPrefix));
			$("checkSeqNo").value = (rec == null ? "" : rec.checkSeqNo);
			$("remarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("userId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("lastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			rec == null && queryMode == "N" ? $("chkPrefix").readOnly = false : $("chkPrefix").readOnly = true;
			queryMode == "Y" ? null : $("chkPrefix").focus();
			
			selectedRow = rec;
		}catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function exitPage(){
		changeTag = 0;
		new Ajax.Request(contextPath + "/GIACDocSequenceController", {
			parameters: {
				action: "showGiacs322",
				fundCd: $F("fundCd"),
				fundDesc: $F("fundDesc"),
				branchCd: $F("branchCd"),
				branchName: $F("branchName")
			},
	        onCreate: showNotice("Retrieving Sequence per Branch Maintenance, please wait..."),
	        onComplete: function(response){
	        	hideNotice();
	        	if (checkErrorOnResponse(response)) {
	        		$("dynamicDiv").update(response.responseText);
	        		
	        		enableToolbarButton("btnToolbarEnterQuery");
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
	        		
	        		if(checkUserModule("GIACS326")){
	        			enableButton("btnCheckNumber");
	        		}
	        	}
	        }
		});
	}
	
	function cancelGIACS326(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
				function(){
					objGIACS326.exitPage = exitPage;
					saveGIACS326();
				}, exitPage, "");
		} else {
			exitPage();
		}
	}
	
	function saveGIACS326(){
		var setRows = getAddedAndModifiedJSONObjects(checkNoTG.geniisysRows);
		var delRows = getDeletedJSONObjects(checkNoTG.geniisysRows);
        
		new Ajax.Request(contextPath+"/GIACCheckNoController", {
			method: "POST",
			parameters : {action : "saveGIACS326",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIACS326.exitPage != null) {
							objGIACS326.exitPage();
						} else {
							checkNoTG._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("checkNoFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;					
					
					for(var i = 0; i < checkNoTG.geniisysRows.length; i++){
						if(checkNoTG.geniisysRows[i].recordStatus == 0 || checkNoTG.geniisysRows[i].recordStatus == 1){								
							if(unescapeHTML2(checkNoTG.geniisysRows[i].chkPrefix) == $F("chkPrefix")){
								addedSameExists = true;								
							}							
						} else if(checkNoTG.geniisysRows[i].recordStatus == -1){
							if(unescapeHTML2(checkNoTG.geniisysRows[i].chkPrefix) == $F("chkPrefix")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same fund_cd, branch_cd, bank_cd, bank_acct_cd and chk_prefix.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					
					new Ajax.Request(contextPath + "/GIACCheckNoController", {
						parameters : {
							action : "valAddRec",
							fundCd: $F("fundCd"),
							branchCd: $F("branchCd"),
							bankCd: $F("bankCd"),
							bankAcctCdd: $F("bankAcctCd"),
							chkPrefix: $F("chkPrefix")
						},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								addRec();
							}
						}
					});
				} else {
					if(selectedRow.inUse == "Y" && parseInt(selectedRow.oldCheckSeqNo) > parseInt($F("checkSeqNo"))){
						showMessageBox("Check number already exists. Value should be greater than or equal to maximum check number.", "I");
						return;
					}else{
						addRec();
					}
				}
			} 
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			
			obj.fundCd = escapeHTML2($F("fundCd"));
			obj.branchCd = escapeHTML2($F("branchCd"));
			obj.bankCd = $F("bankCd");
			obj.bankAcctCd = escapeHTML2($F("bankAcctCd"));
			obj.chkPrefix = escapeHTML2($F("chkPrefix"));
			obj.checkSeqNo = $F("checkSeqNo");
			obj.remarks = escapeHTML2($F("remarks"));
			obj.userId = userId;
			obj.lastUpdate = dateFormat(new Date(), 'mm-dd-yyyy hh:MM:ss TT');
			obj.inUse = rec == null ? "N" : rec.inUse;
			obj.oldCheckSeqNo = rec == null ? "" : rec.oldCheckSeqNo;
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try{
			changeTagFunc = saveGIACS326;
			var row = setRec(selectedRow);
			
			if($F("btnAdd") == "Add"){
				checkNoTG.addBottomRow(row);
			} else {
				checkNoTG.updateVisibleRowOnly(row, rowIndex, false);
			}
			
			changeTag = 1;
			setFieldValues(null);
			checkNoTG.keys.removeFocus(checkNoTG.keys._nCurrentFocus, true);
			checkNoTG.keys.releaseKeys();
		}catch(e){
			showErrorMessage("addRec", e);
		}
	}
	
	function valDelRec(){
		try{
			new Ajax.Request(contextPath + "/GIACCheckNoController", {
				parameters: {
					action: "valDelRec",
					bankCd: $F("bankCd"),
					bankAcctCd: $F("bankAcctCd"),
					chkPrefix: $F("chkPrefix")
				},
				asynchronous: false,
				evalScripts: true,
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
	
	function deleteRec(){
		changeTagFunc = saveGIACS326;
		checkNoTG.geniisysRows[rowIndex].recordStatus = -1;
		checkNoTG.geniisysRows[rowIndex].fundCd = escapeHTML2($F("fundCd"));
		checkNoTG.geniisysRows[rowIndex].branchCd = escapeHTML2($F("branchCd"));
		checkNoTG.geniisysRows[rowIndex].bankAcctCd = escapeHTML2($F("bankAcctCd"));
		checkNoTG.geniisysRows[rowIndex].chkPrefix = escapeHTML2($F("chkPrefix"));
		checkNoTG.deleteRow(rowIndex);
		checkNoTG.onRemoveRowFocus();
		changeTag = 1;
	}
	
	$("bankCd").observe("change", function(){
		if($F("bankCd") != ""){
			showBankLOV();
		}else{
			$("bankCd").setAttribute("lastValidValue", "");
			$("bankSName").value = "";
			$("bankName").value = "";
			
			$("bankAcctCd").value = "";
			$("bankAcctNo").value = "";
			toggleHeader();
		}
	});
	
	$("bankAcctCd").observe("change", function(){
		if($F("bankAcctCd") != ""){
			showBankAcctLOV();
		}else{
			$("bankAcctCd").setAttribute("lastValidValue", "");
			$("bankAcctNo").value = "";
			toggleHeader();
		}
	});
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("remarks", 4000, $("remarks").hasAttribute("readonly"));
	});
	
	$("btnToolbarSave").stopObserving("click");
	$("btnToolbarSave").observe("click", function(){
		fireEvent($("btnSave"), "click");
	});
	
	$("btnToolbarExit").stopObserving("click");
	$("btnToolbarExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	$("searchBank").observe("click", showBankLOV);
	$("searchBankAcct").observe("click", showBankAcctLOV);
	$("btnToolbarEnterQuery").observe("click", enterQuery);
	$("btnToolbarExecuteQuery").observe("click", executeQuery);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDelRec);
	$("btnCancel").observe("click", cancelGIACS326);
	
	observeReloadForm("reloadForm", showGIACS326);
	observeSaveForm("btnSave", saveGIACS326);
	newFormInstance();
</script>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giacs340MainDiv" name="giacs340MainDiv" style=""></div>
<div id="giacs341MainDiv" name="giacs341MainDiv" style="">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="acExit">Exit</a></li>
				</ul>
			</div>
		</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>General Ledger Control Sub-Account Type</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giacs341" name="giacs341">		
		<div class="sectionDiv">
			<table align="left" style="margin: 10px 144px 10px">
				<tr>
					<td class="rightAligned">GL Control Account</td>
					<td class="leftAligned">
						<input type="text" id="txtLedgerCd" name="txtLedgerCd" value="${ledgerCd}" style="width: 110px; float: left; margin-right: 3px;"  readonly="readonly" ignoreDelKey="1" tabindex="101" />
						<input type="text" id="txtLedgerDesc" name="txtLedgerDesc" value="${ledgerDesc}" style="width: 369px; float: left;" readonly="readonly" ignoreDelKey="1"  tabindex="102"/>
					</td>
				</tr>
			</table>			
		</div>
		<div class="sectionDiv">
			<div id="glSubAcctTypesDiv" style="padding-top: 10px;">
				<div id="glSubAccountTypesTable" style="height: 340px; margin-left: 35px;"></div>
			</div>
			<div align="" id="glSubAcctTypesFormDiv" style="margin-left: 80px;">
				<table style="margin-top: 10px;">
					<tr>
						<td class="rightAligned">Sub-Ledger Code</td>
						<td class="leftAligned">
							<input id="txtSubLedgerCd" type="text" class="required" origValue="" style="width: 200px; text-align: left;" tabindex="201" maxlength="10">
						</td>
						<td class="rightAligned" width="160px">Active Tag</td>
						<td class="leftAligned">
							<select id="selActiveTag" style="width: 207px; height: 24px;" class="required" tabindex="202">
								<c:forEach var="activeTag" items="${activeTagLOV}">
									<option value="${activeTag.rvLowValue}">${activeTag.rvMeaning}</option>
								</c:forEach>
							</select>
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Description</td>
						<td class="leftAligned" colspan="3">
							<input id="txtSubLedgerDesc" type="text" class="required" style="width: 580px;" tabindex="203" maxlength="100">
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="width: 101px;">GL Account Code</td>
						<td class="leftAligned" colspan="3">
							<div id="glCodeDiv" style="float: left;">
								<input type="hidden" id="hidGlAcctId">
								<input type="hidden" id="hidGlAccountCode">
								<input type="text" style="width: 24px; text-align: right;" id="txtGlAcctCategory" 	name="glAccountCode" value="" class="required glAC integerNoNegativeUnformattedNoComma" regExpPatt="pDigit01" maxlength="1" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="9" customLabel="GL Account Category" tabindex=204/>
								<input type="text" style="width: 24px; text-align: right;" id="txtGlControlAcct" 	name="glAccountCode" 	value="" class="required glAC integerNoNegativeUnformattedNoComma" lpad="2" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Control Account" tabindex=205/>
								<input type="text" style="width: 24px; text-align: right;" id="txtGlSubAcct1" 		name="glAccountCode" 	value="" class="required glAC integerNoNegativeUnformattedNoComma" lpad="2" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Sub Account 1" tabindex=206/>
								<input type="text" style="width: 24px; text-align: right;" id="txtGlSubAcct2" 		name="glAccountCode"	value="" class="required glAC integerNoNegativeUnformattedNoComma" lpad="2" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Sub Account 2" tabindex=207/>
								<input type="text" style="width: 24px; text-align: right;" id="txtGlSubAcct3"		name="glAccountCode" 	value="" class="required glAC integerNoNegativeUnformattedNoComma" lpad="2" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Sub Account 3" tabindex=208/>
								<input type="text" style="width: 24px; text-align: right;" id="txtGlSubAcct4"		name="glAccountCode" 	value="" class="required glAC integerNoNegativeUnformattedNoComma" lpad="2" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Sub Account 4" tabindex=209/>
								<input type="text" style="width: 24px; text-align: right;" id="txtGlSubAcct5"		name="glAccountCode" 	value="" class="required glAC integerNoNegativeUnformattedNoComma" lpad="2" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Sub Account 5" tabindex=210/>
								<input type="text" style="width: 24px; text-align: right;" id="txtGlSubAcct6"		name="glAccountCode" 	value="" class="required glAC integerNoNegativeUnformattedNoComma" lpad="2" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Sub Account 6" tabindex=211/>
								<input type="text" style="width: 24px; text-align: right;" id="txtGlSubAcct7"		name="glAccountCode" 	value="" class="required glAC integerNoNegativeUnformattedNoComma" lpad="2" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Sub Account 7" tabindex=212/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchGl" name="imgSearchGl" alt="Search" style="margin-left: 3px; cursor: pointer;" tabindex="213"/>
							</div>
						</td>
						</td>					
					</tr>					
					<tr>
						<td width="" class="rightAligned">GL Account Name</td>
						<td class="leftAligned" colspan="3">
							<input id="txtGlAcctName" type="text" class="required" style="width: 580px;" readonly="readonly" tabindex="214"/>
						</td>
					</tr>										
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 586px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 560px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="215"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="216"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="217"></td>
						<td width="160px;" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="218"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;" align="center">
				<input type="button" class="button" id="btnAdd" value="Add" style="width: 80px;" tabindex="301">
				<input type="button" class="button" id="btnDelete" value="Delete" style="width: 80px;" tabindex="302">
				<input type="button" class="button" id="btnViewTranType" value="View Transaction Types" style="width: 150px;" tabindex="303">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" style="width: 85px;" tabindex="401">
	<input type="button" class="button" id="btnSave" value="Save" style="width: 85px;" tabindex="402">
</div>
<script type="text/javascript">	
	setModuleId("GIACS341");
	setDocumentTitle("General Ledger Control Sub-Account Type");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	var btnVal = null;
	var origSubLedgerCd = null;
	
	function saveGiacs341(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgGlSubAccountTypes.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgGlSubAccountTypes.geniisysRows);
		new Ajax.Request(contextPath+"/GIACGlSubAccountTypesController", {
			method: "POST",
			parameters : {action : "saveGiacs341",
				 origSubLedgerCd : origSubLedgerCd,
				          btnVal : btnVal,
				     	 setRows : prepareJsonAsParameter(setRows),
					 	 delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIACS341.exitPage != null) {
							objGIACS341.exitPage();
						} else {
							tbgGlSubAccountTypes._refreshList();
						}
					});
					changeTag = 0;
					origSubLedgerCd = null;
				}
			}
		});
	}		
	
	observeReloadForm("reloadForm", function() {
		changeTag = 0;
		tbgGlSubAccountTypes._refreshList();
	});
	
	var objGIACS341 = {};
	var objCurrGlAcctTypes = null;
	objGIACS341.glSubAccountTypesList = JSON.parse('${jsonGlSubAccountTypes}');
	objGIACS341.exitPage = null;
	
	var glSubAccountTypesTable = {
			url : contextPath + "/GIACGlSubAccountTypesController?action=showGiacs341&refresh=1&ledgerCd="+unescapeHTML2($F("txtLedgerCd")),
			options : {
				width : '850px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrGlAcctTypes = tbgGlSubAccountTypes.geniisysRows[y];
					setFieldValues(objCurrGlAcctTypes);
					tbgGlSubAccountTypes.keys.removeFocus(tbgGlSubAccountTypes.keys._nCurrentFocus, true);
					tbgGlSubAccountTypes.keys.releaseKeys();
					$("txtSubLedgerDesc").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgGlSubAccountTypes.keys.removeFocus(tbgGlSubAccountTypes.keys._nCurrentFocus, true);
					tbgGlSubAccountTypes.keys.releaseKeys();
					$("txtSubLedgerCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgGlSubAccountTypes.keys.removeFocus(tbgGlSubAccountTypes.keys._nCurrentFocus, true);
						tbgGlSubAccountTypes.keys.releaseKeys();
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
					tbgGlSubAccountTypes.keys.removeFocus(tbgGlSubAccountTypes.keys._nCurrentFocus, true);
					tbgGlSubAccountTypes.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgGlSubAccountTypes.keys.removeFocus(tbgGlSubAccountTypes.keys._nCurrentFocus, true);
					tbgGlSubAccountTypes.keys.releaseKeys();
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
					tbgGlSubAccountTypes.keys.removeFocus(tbgGlSubAccountTypes.keys._nCurrentFocus, true);
					tbgGlSubAccountTypes.keys.releaseKeys();
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
				    id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
				    width: '0',				    
				    visible : false			
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},	
				{
					id : "subLedgerCd",
					title : "Sub-Ledger Code",
					filterOption : true,
					width : '120px'
				},
				{
					id : 'subLedgerDesc',
					filterOption : true,
					title : 'Description',
					width : '170px'				
				},	
				{
					id : 'glAcctCategory glControlAcct glSubAcct1 glSubAcct2 glSubAcct3 glSubAcct4 glSubAcct5 glSubAcct6 glSubAcct7',
		        	   title: 'GL Account Code',
		        	   width: 288,
		        	   children: [
		        	               {
									   id : 'glAcctCategory',
									   width: 32,
									   align: 'right'
								   },
								   {
									   id : 'glControlAcct',
									   width: 32,
									   align: 'right',
									   renderer: function(value){
					            		   return lpad(value, 2, 0);
					            	   }
								   },
								   {
									   id : 'glSubAcct1',
									   width: 32,
									   align: 'right',
									   renderer: function(value){
					            		   return lpad(value, 2, 0);
					            	   }
								   },
								   {
									   id : 'glSubAcct2',
									   width: 32,
									   align: 'right',
									   renderer: function(value){
					            		   return lpad(value, 2, 0);
					            	   }
								   },
								   {
									   id : 'glSubAcct3',
									   width: 32,
									   align: 'right',
									   renderer: function(value){
					            		   return lpad(value, 2, 0);
					            	   }
								   },
								   {
									   id : 'glSubAcct4',
									   width: 32,
									   align: 'right',
									   renderer: function(value){
					            		   return lpad(value, 2, 0);
					            	   }
								   },
								   {
									   id : 'glSubAcct5',
									   width: 32,
									   align: 'right',
									   renderer: function(value){
					            		   return lpad(value, 2, 0);
					            	   }
								   },
								   {
									   id : 'glSubAcct6',
									   width: 32,
									   align: 'right',
									   renderer: function(value){
					            		   return lpad(value, 2, 0);
					            	   }
								   },
								   {
									   id : 'glSubAcct7',
									   width: 32,
									   align: 'right',
									   renderer: function(value){
					            		   return lpad(value, 2, 0);
					            	   }
								   }
				       ]
		        },
				{
					id : 'glAcctName',
					title : "GL Account Name",
					filterOption : true,
					width : '200'
				},
				{
					id : 'glAcctCategory',
					width : '0',
					title: "GL Acct Category",
					filterOption: true,
					filterOptionType: 'integerNoNegative',
					visible: false
				},
				{
					id : 'glControlAcct',
					width : '0',
					title: "GL Control Acct",
					filterOption: true,
					filterOptionType: 'integerNoNegative',
					visible: false
				},
				{
					id : 'glSubAcct1',
					width : '0',
					title: "GL Sub Acct 1",
					filterOption: true,
					filterOptionType: 'integerNoNegative',
					visible: false
				},
				{
					id : 'glSubAcct2',
					width : '0',
					title: "GL Sub Acct 2",
					filterOption: true,
					filterOptionType: 'integerNoNegative',
					visible: false
				},
				{
					id : 'glSubAcct3',
					width : '0',
					title: "GL Sub Acct 3",
					filterOption: true,
					filterOptionType: 'integerNoNegative',
					visible: false
				},				
				{
					id : 'glSubAcct4',
					width : '0',
					title: "GL Sub Acct 4",
					filterOption: true,
					filterOptionType: 'integerNoNegative',
					visible: false
				},				
				{
					id : 'glSubAcct5',
					width : '0',
					title: "GL Sub Acct 5",
					filterOption: true,
					filterOptionType: 'integerNoNegative',
					visible: false
				},				
				{
					id : 'glSubAcct6',
					width : '0',
					title: "GL Sub Acct 6",
					filterOption: true,
					filterOptionType: 'integerNoNegative',
					visible: false
				},				
				{
					id : 'glSubAcct7',
					width : '0',
					title: "GL Sub Acct 7",
					filterOption: true,
					filterOptionType: 'integerNoNegative',
					visible: false
				},				
				{
					id : 'activeTag',
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
			rows : objGIACS341.glSubAccountTypesList.rows
		};

		tbgGlSubAccountTypes = new MyTableGrid(glSubAccountTypesTable);
		tbgGlSubAccountTypes.pager = objGIACS341.glSubAccountTypesList;
		tbgGlSubAccountTypes.render("glSubAccountTypesTable");
		tbgGlSubAccountTypes.afterRender = function(){
			getAllGlAcctId();
		};

	
	function setFieldValues(rec){
		try{
			$("txtSubLedgerCd").value 		= (rec == null ? "" : unescapeHTML2(rec.subLedgerCd));
			$("txtSubLedgerDesc").value 	= (rec == null ? "" : unescapeHTML2(rec.subLedgerDesc));
			$("selActiveTag").value 		= (rec == null ? "" : rec.activeTag);
			$("txtRemarks").value 			= (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("txtUserId").value 			= (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value 		= (rec == null ? "" : rec.lastUpdate);
			$("txtGlAcctCategory").value 	= (rec == null ? "" : rec.glAcctCategory);
			$("txtGlControlAcct").value		= (rec == null ? "" : formatNumberDigits(rec.glControlAcct, 2));
			$("txtGlSubAcct1").value 		= (rec == null ? "" : formatNumberDigits(rec.glSubAcct1, 2));
			$("txtGlSubAcct2").value 		= (rec == null ? "" : formatNumberDigits(rec.glSubAcct2, 2));
			$("txtGlSubAcct3").value 		= (rec == null ? "" : formatNumberDigits(rec.glSubAcct3, 2));
			$("txtGlSubAcct4").value 		= (rec == null ? "" : formatNumberDigits(rec.glSubAcct4, 2));
			$("txtGlSubAcct5").value 		= (rec == null ? "" : formatNumberDigits(rec.glSubAcct5, 2));
			$("txtGlSubAcct6").value 		= (rec == null ? "" : formatNumberDigits(rec.glSubAcct6, 2));
			$("txtGlSubAcct7").value 		= (rec == null ? "" : formatNumberDigits(rec.glSubAcct7, 2));
			$("txtGlAcctName").value 		= (rec == null ? "" : unescapeHTML2(rec.glAcctName));			
			$("hidGlAcctId").value 			= (rec == null ? "" : rec.glAcctId);
			
			$("txtSubLedgerCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.subLedgerCd)));
			$("txtSubLedgerCd").setAttribute("origValue", (rec == null ? "" : unescapeHTML2(rec.subLedgerCd)));
			
			
			$("hidGlAccountCode").value = (rec == null ? "" : rec.glAcctCategory +
					  formatNumberDigits(rec.glControlAcct, 2) +
					  formatNumberDigits(rec.glSubAcct1, 2) +
					  formatNumberDigits(rec.glSubAcct2, 2) +
					  formatNumberDigits(rec.glSubAcct3, 2) +
					  formatNumberDigits(rec.glSubAcct4, 2) +
					  formatNumberDigits(rec.glSubAcct5, 2) +
					  formatNumberDigits(rec.glSubAcct6, 2) +
					  formatNumberDigits(rec.glSubAcct7, 2));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			rec == null ? disableButton("btnViewTranType") : enableButton("btnViewTranType");
			objCurrGlAcctTypes = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.ledgerCd	    = escapeHTML2($F("txtLedgerCd"));
			obj.subLedgerCd 	= escapeHTML2($F("txtSubLedgerCd"));
			obj.subLedgerDesc 	= escapeHTML2($F("txtSubLedgerDesc"));
			obj.activeTag 	 	= $F("selActiveTag");
			obj.glAcctCategory 	= $F("txtGlAcctCategory");
			obj.glControlAcct 	= $F("txtGlControlAcct");
			obj.glSubAcct1 		= $F("txtGlSubAcct1");
			obj.glSubAcct2 		= $F("txtGlSubAcct2");
			obj.glSubAcct3 		= $F("txtGlSubAcct3");
			obj.glSubAcct4 		= $F("txtGlSubAcct4");
			obj.glSubAcct5 		= $F("txtGlSubAcct5");
			obj.glSubAcct6 		= $F("txtGlSubAcct6");
			obj.glSubAcct7 	 	= $F("txtGlSubAcct7");
			obj.glAcctId 		= $F("hidGlAcctId");
			obj.glAcctName 		= escapeHTML2($F("txtGlAcctName"));
			obj.remarks 	 	= escapeHTML2($F("txtRemarks"));			
			obj.userId 		 	= userId;
			var lastUpdate 	 	= new Date();
			obj.lastUpdate 	 	= dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGiacs341;
			var rec = setRec(objCurrGlAcctTypes);
			if($F("btnAdd") == "Add"){
				tbgGlSubAccountTypes.addBottomRow(rec);
				btnVal = "Add";
			} else {
				tbgGlSubAccountTypes.updateVisibleRowOnly(rec, rowIndex, false);
				btnVal = "Update";
			}
			changeTag = 1;
			origSubLedgerCd = $("txtSubLedgerCd").getAttribute("origValue");
			setFieldValues(null);
			tbgGlSubAccountTypes.keys.removeFocus(tbgGlSubAccountTypes.keys._nCurrentFocus, true);
			tbgGlSubAccountTypes.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}
	
	function valTranTypeRec() {
		isRecValid = true;
		new Ajax.Request(contextPath + "/GIACGlSubAccountTypesController", {
			parameters : {action : "valAddGlSubAcctType",
						  btnVal : "Update",
					    ledgerCd : $F("txtLedgerCd"),
					 subLedgerCd : $("txtSubLedgerCd").getAttribute("origValue")
			},
			asynchronous: false,
			onCreate : showNotice("Processing, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					if (response.responseText.include("Geniisys Exception")){
						var message = response.responseText.split("#"); 
						showMessageBox(message[2], message[1]);
						isRecValid =  false;
					} 
				}
			}
		});	
		return isRecValid;
	}
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("glSubAcctTypesFormDiv")){
				var addedSameExists = false;
				var deletedSameExists = false;	
				
				if($F("btnAdd") == "Add") {
					for(var i=0; i<tbgGlSubAccountTypes.geniisysRows.length; i++){
						if(tbgGlSubAccountTypes.geniisysRows[i].recordStatus == 0 || tbgGlSubAccountTypes.geniisysRows[i].recordStatus == 1){								
							if(tbgGlSubAccountTypes.geniisysRows[i].subLedgerCd == $F("txtSubLedgerCd")){
								addedSameExists = true;								
							}							
						} else if(tbgGlSubAccountTypes.geniisysRows[i].recordStatus == -1){
							if(tbgGlSubAccountTypes.geniisysRows[i].subLedgerCd == $F("txtSubLedgerCd")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox($F("txtSubLedgerCd") + " already exists.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					new Ajax.Request(contextPath + "/GIACGlSubAccountTypesController", {
						parameters : {action : "valAddGlSubAcctType",
							          btnVal : "Add",
									ledgerCd : $F("txtLedgerCd"),
								 subLedgerCd : $F("txtSubLedgerCd")},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								addRec();
							}
						}
					});
				} else {
					/*--check child records--*/
					if (!valTranTypeRec()) return false; 
					
					/*--check records in tabledgrid*/
					for(var i=0; i<tbgGlSubAccountTypes.geniisysRows.length; i++){
						if(tbgGlSubAccountTypes.geniisysRows[i].recordStatus == 0 || tbgGlSubAccountTypes.geniisysRows[i].recordStatus == 1){								
							if(tbgGlSubAccountTypes.geniisysRows[i].subLedgerCd == $F("txtSubLedgerCd")){
								if ($F("txtSubLedgerCd") != $("txtSubLedgerCd").getAttribute("origValue")) {
									addedSameExists = true;
								}
							}							
						} else if(tbgGlSubAccountTypes.geniisysRows[i].recordStatus == -1){
							if(tbgGlSubAccountTypes.geniisysRows[i].subLedgerCd == $F("txtSubLedgerCd")){
								deletedSameExists = true;
							}
						}
					}

					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox($F("txtSubLedgerCd")+" already exists.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					} else if(!deletedSameExists && !addedSameExists){
						if ($F("txtSubLedgerCd") != $("txtSubLedgerCd").getAttribute("origValue")) {
							new Ajax.Request(contextPath + "/GIACGlSubAccountTypesController", {
								parameters : {action : "valUpdGlSubAcctType",
											ledgerCd : $F("txtLedgerCd"),
									  newSubLedgerCd : $F("txtSubLedgerCd")},
								onCreate : showNotice("Processing, please wait..."),
								onComplete : function(response){
									hideNotice();
									if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
										addRec();
									}
								}
							});
						}else {
							addRec();
						}
					}					
				}
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}	
	
	function deleteRec(){
		changeTagFunc = saveGiacs341;
		objCurrGlAcctTypes.recordStatus = -1;
		tbgGlSubAccountTypes.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIACGlSubAccountTypesController", {
				parameters : {action : "valDelGlSubAcctType",
							ledgerCd : $F("txtLedgerCd"),
					     subLedgerCd : $F("txtSubLedgerCd")},
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
	
	function getAllGlAcctId(){
		new Ajax.Request(contextPath+ "/GIACGlSubAccountTypesController", {
			method : "POST",
			parameters : {
				action : "getAllGlAcctIdGiacs341"	
			},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					objGIACS341.glAcctIdList = JSON.parse(response.responseText);
				}
			}
		});
	}
	
	function createNotInParam(){
		try{
			var notIn = '';
			var list = objGIACS341.glAcctIdList;
			
			for (var j = 0; j < list.length; j++){
				if (list[j].recordStatus != -1){
					notIn = notIn + "'" + list[j].glAcctId + "'" + ((j+1) == list.length ? "" : ",");
				}
			}

			if (notIn.substring(notIn.length-1, notIn.length) == ",") notIn = notIn.substring(0, notIn.length-1);
			
			return notIn;
		}catch(e){
			showErrorMessage("createNotInParam",e);
		}
	}

	function getGiacs341GlAcctCodeLOV(){
		var notIn = createNotInParam();
		var concatGl = ($F("txtGlAcctCategory").trim() == "" ? "": $F("txtGlAcctCategory")) +
		($F("txtGlControlAcct").trim() == "" ? "": formatNumberDigits($F("txtGlControlAcct"), 2)) +
		($F("txtGlSubAcct1").trim() == "" ? "": formatNumberDigits($F("txtGlSubAcct1"), 2)) +
		($F("txtGlSubAcct2").trim() == "" ? "": formatNumberDigits($F("txtGlSubAcct2"), 2)) +
		($F("txtGlSubAcct3").trim() == "" ? "": formatNumberDigits($F("txtGlSubAcct3"), 2)) +
		($F("txtGlSubAcct4").trim() == "" ? "": formatNumberDigits($F("txtGlSubAcct4"), 2)) +
		($F("txtGlSubAcct5").trim() == "" ? "": formatNumberDigits($F("txtGlSubAcct5"), 2)) +
		($F("txtGlSubAcct6").trim() == "" ? "": formatNumberDigits($F("txtGlSubAcct6"), 2)) +
		($F("txtGlSubAcct7").trim() == "" ? "": formatNumberDigits($F("txtGlSubAcct7"), 2));
		LOV.show({
			controller: "ACMaintenanceLOVController",
			urlParameters: {
				action : "getGiacs341GlAcctCodeLOV",
	  	    filterText : ($F("hidGlAccountCode").trim() != concatGl ? concatGl : ""),
			 	 notIn : notIn
						},
			title: "List of GL Account Codes",
			hideColumnChildTitle: true,
			width: 800,
			height: 403,
			columnModel : [
			               {
			            	   id : 'glAcctCode',
			            	   title: 'GL Account Code',
			            	   width: 270,
			            	   children: [
			            	               {
											   id : 'glAcctCategory',
											   width: 30,
											   align: 'right'											  
										   },
										   {
											   id : 'glControlAcct',
											   width: 30,
											   align: 'right',
											   renderer: function(value){
							            		   return lpad(value, 2, 0);
							            	   }
										   },
										   {
											   id : 'glSubAcct1',
											   width: 30,
											   align: 'right',
											   renderer: function(value){
							            		   return lpad(value, 2, 0);
							            	   }
										   },
										   {
											   id : 'glSubAcct2',
											   width: 30,
											   align: 'right',
											   renderer: function(value){
							            		   return lpad(value, 2, 0);
							            	   }
										   },
										   {
											   id : 'glSubAcct3',
											   width: 30,
											   align: 'right',
											   renderer: function(value){
							            		   return lpad(value, 2, 0);
							            	   }
										   },
										   {
											   id : 'glSubAcct4',
											   width: 30,
											   align: 'right',
											   renderer: function(value){
							            		   return lpad(value, 2, 0);
							            	   }
										   },
										   {
											   id : 'glSubAcct5',
											   width: 30,
											   align: 'right',
											   renderer: function(value){
							            		   return lpad(value, 2, 0);
							            	   }
										   },
										   {
											   id : 'glSubAcct6',
											   width: 30,
											   align: 'right',
											   renderer: function(value){
							            		   return lpad(value, 2, 0);
							            	   }
										   },
										   {
											   id : 'glSubAcct7',
											   width: 30,
											   align: 'right',
											   renderer: function(value){
							            		   return lpad(value, 2, 0);
							            	   }
										   }
						       ]
			               },
			               {
			            	   id : 'glAcctName',
			            	   title: 'Account Name',
			            	   width: '430px',
			            	   align: 'left'
			               },
			               {
			            	   id : 'glAcctId',
			            	   width: '0',
			            	   visible: false
			               }
			              ],
			autoSelectOneRecord: true,
			filterText : ($F("hidGlAccountCode").trim() != concatGl ? concatGl : ""),
			draggable: true,
				onSelect: function(row) {
					try {
						$("hidGlAcctId").value = row.glAcctId;
						$("txtGlAcctCategory").value 	= parseInt(row.glAcctCategory);
						$("txtGlControlAcct").value 	= parseInt(row.glControlAcct).toPaddedString(2);
						$("txtGlSubAcct1").value 		= parseInt(row.glSubAcct1).toPaddedString(2);
						$("txtGlSubAcct2").value 		= parseInt(row.glSubAcct2).toPaddedString(2);
						$("txtGlSubAcct3").value 		= parseInt(row.glSubAcct3).toPaddedString(2);
						$("txtGlSubAcct4").value 		= parseInt(row.glSubAcct4).toPaddedString(2);
						$("txtGlSubAcct5").value 		= parseInt(row.glSubAcct5).toPaddedString(2);
						$("txtGlSubAcct6").value 		= parseInt(row.glSubAcct6).toPaddedString(2);
						$("txtGlSubAcct7").value 		= parseInt(row.glSubAcct7).toPaddedString(2);
						$("txtGlAcctName").value 		= unescapeHTML2(row.glAcctName);
						
						$("txtGlAcctName").setAttribute("lastValidValue", unescapeHTML2(row.glAcctName));
						$("hidGlAccountCode").value = row.glAcctCategory +
						                              parseInt(row.glControlAcct).toPaddedString(2) +
						                              parseInt(row.glSubAcct1).toPaddedString(2) +
						                              parseInt(row.glSubAcct2).toPaddedString(2) +
						                              parseInt(row.glSubAcct3).toPaddedString(2) +
						                              parseInt(row.glSubAcct4).toPaddedString(2) +
						                              parseInt(row.glSubAcct5).toPaddedString(2) +
						                              parseInt(row.glSubAcct6).toPaddedString(2) +
						                              parseInt(row.glSubAcct7).toPaddedString(2);
						
						$("txtGlSubAcct7").focus();
					} catch(e){
						showErrorMessage("showAccountCodeLOV - onSelect", e);
					}
				},
				onCancel: function (){
					$("txtGlAcctName").value = $("txtGlAcctName").readAttribute("lastValidValue");
					$("txtGlAcctCategory").value = $F("hidGlAccountCode").substring(0, 1);
					$("txtGlControlAcct").value = $F("hidGlAccountCode").substring(1, 3);
					$("txtGlSubAcct1").value = $F("hidGlAccountCode").substring(3, 5);
					$("txtGlSubAcct2").value = $F("hidGlAccountCode").substring(5, 7);
					$("txtGlSubAcct3").value = $F("hidGlAccountCode").substring(7, 9);
					$("txtGlSubAcct4").value = $F("hidGlAccountCode").substring(9, 11);
					$("txtGlSubAcct5").value = $F("hidGlAccountCode").substring(11, 13);
					$("txtGlSubAcct6").value = $F("hidGlAccountCode").substring(13, 15);
					$("txtGlSubAcct7").value = $F("hidGlAccountCode").substring(15, 17);
					$("txtGlAcctName").value = $("txtGlAcctName").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$$("txtGlAcctName").value = $("txtGlAcctName").readAttribute("lastValidValue");
					$("txtGlAcctCategory").value = $F("hidGlAccountCode").substring(0, 1);
					$("txtGlControlAcct").value = $F("hidGlAccountCode").substring(1, 3);
					$("txtGlSubAcct1").value = $F("hidGlAccountCode").substring(3, 5);
					$("txtGlSubAcct2").value = $F("hidGlAccountCode").substring(5, 7);
					$("txtGlSubAcct3").value = $F("hidGlAccountCode").substring(7, 9);
					$("txtGlSubAcct4").value = $F("hidGlAccountCode").substring(9, 11);
					$("txtGlSubAcct5").value = $F("hidGlAccountCode").substring(11, 13);
					$("txtGlSubAcct6").value = $F("hidGlAccountCode").substring(13, 15);
					$("txtGlSubAcct7").value = $F("hidGlAccountCode").substring(15, 17);
					$("txtGlAcctName").value = $("txtGlAcctName").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
			});
	} 

	function showGlTranTypes() {
		overlayGlTranTypes = Overlay.show(contextPath + "/GIACGlSubAccountTypesController", {
			urlContent : true,
			urlParameters : {
				action : "showTransactionTypes",
			  ledgerCd : $F("txtLedgerCd"),
		   subLedgerCd : $F("txtSubLedgerCd")
				},
			title : "Transaction Types",
			height : '430px',
			width : '750px',
			draggable : true
		});	
	}
	
	function exitPage(){
		showGiacs340();
	}	
	
	function cancelGiacs341(func){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIACS341.exitPage = exitPage;
						saveGiacs341();
					}, function(){
						if (func) {
							showGiacs340();
						} else {
							showGlTranTypes();
						}
					}, "");
		} else {
			if (func) {
				showGiacs340();
			} else {
				showGlTranTypes();
			}
		}
	}
	
	$("txtSubLedgerCd").observe("keyup", function(){
		$("txtSubLedgerCd").value = $F("txtSubLedgerCd").toUpperCase();
	});
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});

	var glCodeId = ["txtGlAcctCategory","txtGlControlAcct","txtGlSubAcct1","txtGlSubAcct2","txtGlSubAcct3",
	                "txtGlSubAcct4","txtGlSubAcct5","txtGlSubAcct6","txtGlSubAcct7"];
	$$("#glCodeDiv input[type='text']").each(function(m) {
		m.observe("change",function() {
			var LOVcond = false;
					for ( var i = 0; i < glCodeId.length; i++) {
						if ($F(glCodeId[i]).trim() != "") {
							LOVcond = true;
						}else{
							LOVcond = false;
							break;
						}
					}
					if (LOVcond) {
						getGiacs341GlAcctCodeLOV();
					}else{
						$("txtGlAcctName").clear();
					}
				});
			});	
	
	disableButton("btnDelete");
	disableButton("btnViewTranType");
	
	$("selActiveTag").value = "Y";
	
	observeSaveForm("btnSave", saveGiacs341);
	$("btnCancel").observe("click", function() {
		cancelGiacs341(true);
	});
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);
	$("btnViewTranType").observe("click", function() {
		cancelGiacs341(false);
	});
	$("imgSearchGl").observe("click", getGiacs341GlAcctCodeLOV);	
	
	$("acExit").stopObserving("click");
	$("acExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtSubLedgerCd").focus();	
</script>
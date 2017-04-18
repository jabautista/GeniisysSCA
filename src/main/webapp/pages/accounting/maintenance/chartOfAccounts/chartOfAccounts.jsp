<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giacs311MainDiv" name="giacs311MainDiv" style="">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Chart of Accounts Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giacs311" name="giacs311">		
		<div class="sectionDiv">
			<div align="" id="charOfAccountsQueryDiv" style="margin-left: 115px;">
				<table style="margin-top: 10px;">
					<tr>
						<td class="rightAligned">Query Level</td>
						<td class="leftAligned" colspan="">
							<select id="selQueryLevel" style="width: 207px; height: 24px;" class="" lastValidValue="" tabindex="119">
								<option value=""></option>
								<option value="GLAC">GL_ACCT_CATEGORY</option>
								<option value="GLCA">GL_CONTROL_ACCT</option>
								<option value="GSA1">GL_SUB_ACCT_1</option>
								<option value="GSA2">GL_SUB_ACCT_2</option>
								<option value="GSA3">GL_SUB_ACCT_3</option>
								<option value="GSA4">GL_SUB_ACCT_4</option>
								<option value="GSA5">GL_SUB_ACCT_5</option>
								<option value="GSA6">GL_SUB_ACCT_6</option>
								<option value="GSA7">GL_SUB_ACCT_7</option>
							</select>
						</td>											
					</tr>
				</table>
			</div>
			<div id="charOfAccountsDiv" style="padding-top: 10px;">
				<div id="charOfAccountsTable" style="height: 340px; margin-left: 115px;"></div>
			</div>
			<div align="center" id="charOfAccountsFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned" style="width: 101px;">GL Account Code</td>
						<td class="leftAligned" style="width: 445px;"  colspan="3">
							<div id="glCodeDiv" style="float: left;">
								<input type="text" style="width: 22px;" id="txtGlAcctCategory" name="glAccountCode"		value="" class="required glAC applyWholeNosRegExp" regExpPatt="pDigit01" maxlength="1" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="9" customLabel="GL Account Code" tabindex=101/>
								<input type="text" style="width: 22px;" id="txtGlControlAcct"  name="glAccountCode" 	value="" class="required glAC applyWholeNosRegExp" regExpPatt="pDigit02" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Account Code" tabindex=102/>
								<input type="text" style="width: 22px;" id="txtGlSubAcct1" 	   name="glAccountCode" 	value="" class="required glAC applyWholeNosRegExp" regExpPatt="pDigit02" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Account Code" tabindex=103/>
								<input type="text" style="width: 22px;" id="txtGlSubAcct2" 	   name="glAccountCode"		value="" class="required glAC applyWholeNosRegExp" regExpPatt="pDigit02" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Account Code" tabindex=104/>
								<input type="text" style="width: 22px;" id="txtGlSubAcct3"	   name="glAccountCode" 	value="" class="required glAC applyWholeNosRegExp" regExpPatt="pDigit02" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Account Code" tabindex=105/>
								<input type="text" style="width: 22px;" id="txtGlSubAcct4"	   name="glAccountCode" 	value="" class="required glAC applyWholeNosRegExp" regExpPatt="pDigit02" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Account Code" tabindex=106/>
								<input type="text" style="width: 22px;" id="txtGlSubAcct5"	   name="glAccountCode" 	value="" class="required glAC applyWholeNosRegExp" regExpPatt="pDigit02" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Account Code" tabindex=107/>
								<input type="text" style="width: 22px;" id="txtGlSubAcct6"	   name="glAccountCode" 	value="" class="required glAC applyWholeNosRegExp" regExpPatt="pDigit02" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Account Code" tabindex=108/>
								<input type="text" style="width: 22px;" id="txtGlSubAcct7"	   name="glAccountCode" 	value="" class="required glAC applyWholeNosRegExp" regExpPatt="pDigit02" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Account Code" tabindex=109/>
							</div>
						</td>					
					</tr>
					<tr>
						<td class="rightAligned">GL Account Name</td>
						<td class="leftAligned" colspan="3">
							<input id="txtGlAcctName" type="text" class="required" style="width: 548px; text-align: left;" tabindex="110" maxlength="100">
						</td>
					</tr>	
					<tr>
						<td class="rightAligned">GL Short Name</td>
						<td class="leftAligned">
							<input id="txtGlAcctSname" type="text" class="required" style="width: 200px; text-align: left;" tabindex="111" maxlength="35">
						</td>
						<td class="rightAligned">Ref. Acct. Code</td>
						<td class="leftAligned">
							<input id="txtRefAcctCd" type="text" class="" style="width: 200px;" tabindex="120" maxlength="20">
						</td>
					</tr>	
					<tr>
						<td class="rightAligned" style="width: 100px;">SL Type Code</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan"  style="float: left; width: 100px; margin-top: 2px; margin-right:3px; height: 21px;">
								<input class="" type="text" id="txtGsltSlTypeCd" name="txtGsltSlTypeCd" style="width: 70px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="112" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgGsltSlTypeLOV" name="imgGsltSlTypeLOV" alt="Go" style="float: right;" tabindex="113"/>
							</span>
							<input id="txtDspSlTypeName" name="txtDspSlTypeName" type="text" style="width: 442px;" value="" readonly="readonly" tabindex="114" maxlength="100"/>
						</td>	
					</tr>																 
					<tr>
						<td colspan="4">
							<label style="margin: 6px 2px 0px 54px; float: left;">Leaf Tag</label>
							<input type="text" id="txtLeafTag" class="required" maxlength="1" style="margin-left: 4px; width: 95px; float: left;" tabindex="115" lastValidValue=""/>
							<label style="margin: 6px 2px 0px 24px; float: left;">Debit/Credit Tag</label>
							<input type="text" id="txtDrCrTag" class="required" maxlength="1" style="margin-left: 4px; width: 112px; float: left;" tabindex="116" lastValidValue=""/>
							<label style="margin: 6px 5px 0px 30px; float: left;">Acct. Type</label>
							<span class="lovSpan required"  style="float: left; width: 115px; margin-top: 2px; height: 21px;">
								<input class="required" type="text" id="txtAcctType" name="txtAcctType" style="width: 86px; float: left; border: none; height: 15px; margin: 0;" maxlength="1" tabindex="117" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgAcctTypeLOV" name="imgAcctTypeLOV" alt="Go" style="float: right;" tabindex="118"/>
							</span>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="121"></td>
						<td width="125px;" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="122"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;" align="center">
				<input type="button" class="button" id="btnCopy" value="Copy" tabindex="201">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="202">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="203">
			</div>
			<div style="margin: 10px; padding: 10px; border-top: 1px solid #E0E0E0; margin-bottom: 0;" align="center">
				<input type="button" class="button" id="btnAddNextLevel" value="Add Next Level" style="width: 140px;" tabindex="301">
				<input type="button" class="button" id="btnAddSameLevel" value="Add Same Level" style="width: 140px;" tabindex="302">
				<input type="button" class="button" id="btnPrintChartOfAcct" value="Print Chart of Acct." style="width: 140px;" tabindex="303">
			</div>			
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="401">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="402">
</div>

<script type="text/javascript">	
	setModuleId("GIACS311");
	setDocumentTitle("Chart of Accounts Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	motherGlAcctId = "";
	var userHasAccess = true;
	var slChanged = false;
	var rowIndex = -1;
	var glAcctCode = new Array();
	var changed = false;
	
	function checkUserFunction() {
		new Ajax.Request(contextPath+"/GIACChartOfAcctsController?action=checkUserFunction",{
			method: "POST",
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				hideNotice("");
				if (checkErrorOnResponse(response)){
					if (response.responseText == "N") {
						userHasAccess = false;
						setQueryMode(true);
					}
				}
			}
		});
	}checkUserFunction();
	
	function saveGiacs311(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgChartOfAccounts.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgChartOfAccounts.geniisysRows);
		new Ajax.Request(contextPath+"/GIACChartOfAcctsController", {
			method: "POST",
			parameters : {action : "saveGiacs311",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIACS311.exitPage != null) {
							objGIACS311.exitPage();
						} else {
							tbgChartOfAccounts._refreshList();
						}
					});
					changeTag = 0;
					$("selQueryLevel").setAttribute("lastValidValue", "");
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiacs311);
	
	var objGIACS311 = {};
	var objCurrChartOfAccounts = null;
	objGIACS311.charOfAccountsList = JSON.parse('${jsonChartOfAcctsList}');
	objGIACS311.exitPage = null;
	objCurrGlAcctId = null;
	
	var charOfAccountsTable = {
			url : contextPath + "/GIACChartOfAcctsController?action=showGiacs311&refresh=1&queryLevel="+$F("selQueryLevel"),
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrChartOfAccounts = tbgChartOfAccounts.geniisysRows[y];
					setFieldValues(objCurrChartOfAccounts);
					tbgChartOfAccounts.keys.removeFocus(tbgChartOfAccounts.keys._nCurrentFocus, true);
					tbgChartOfAccounts.keys.releaseKeys();
					$("txtGlAcctCategory").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgChartOfAccounts.keys.removeFocus(tbgChartOfAccounts.keys._nCurrentFocus, true);
					tbgChartOfAccounts.keys.releaseKeys();
					$("txtGlAcctCategory").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgChartOfAccounts.keys.removeFocus(tbgChartOfAccounts.keys._nCurrentFocus, true);
						tbgChartOfAccounts.keys.releaseKeys();
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
					tbgChartOfAccounts.keys.removeFocus(tbgChartOfAccounts.keys._nCurrentFocus, true);
					tbgChartOfAccounts.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgChartOfAccounts.keys.removeFocus(tbgChartOfAccounts.keys._nCurrentFocus, true);
					tbgChartOfAccounts.keys.releaseKeys();
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
					tbgChartOfAccounts.keys.removeFocus(tbgChartOfAccounts.keys._nCurrentFocus, true);
					tbgChartOfAccounts.keys.releaseKeys();
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
					   id: "glAcctName",
					   title: "GL Account Name",
					   width: '350px',
					   titleAlign: 'left',
					   filterOption: true,
					   align: 'left'
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
				},				{
					id : 'glSubAcct4',
					width : '0',
					title: "GL Sub Acct 4",
					filterOption: true,
					filterOptionType: 'integerNoNegative',
					visible: false
				},				{
					id : 'glSubAcct5',
					width : '0',
					title: "GL Sub Acct 5",
					filterOption: true,
					filterOptionType: 'integerNoNegative',
					visible: false
				},				{
					id : 'glSubAcct6',
					width : '0',
					title: "GL Sub Acct 6",
					filterOption: true,
					filterOptionType: 'integerNoNegative',
					visible: false
				},				{
					id : 'glSubAcct7',
					width : '0',
					title: "GL Sub Acct 7",
					filterOption: true,
					filterOptionType: 'integerNoNegative',
					visible: false
				}
			
			],
			rows : objGIACS311.charOfAccountsList.rows
		};

		tbgChartOfAccounts = new MyTableGrid(charOfAccountsTable);
		tbgChartOfAccounts.pager = objGIACS311.charOfAccountsList;
		tbgChartOfAccounts.render("charOfAccountsTable");

	function setFieldValues(rec){
		try{
			glAcctCode = [];
			$("txtGlAcctCategory").value 	= (rec == null ? "" : rec.glAcctCategory);
			$("txtGlControlAcct").value 	= (rec == null ? "" : parseInt(rec.glControlAcct).toPaddedString(2));
			$("txtGlSubAcct1").value 		= (rec == null ? "" : parseInt(rec.glSubAcct1).toPaddedString(2));
			$("txtGlSubAcct2").value 		= (rec == null ? "" : parseInt(rec.glSubAcct2).toPaddedString(2));
			$("txtGlSubAcct3").value 		= (rec == null ? "" : parseInt(rec.glSubAcct3).toPaddedString(2));
			$("txtGlSubAcct4").value 		= (rec == null ? "" : parseInt(rec.glSubAcct4).toPaddedString(2));
			$("txtGlSubAcct5").value 		= (rec == null ? "" : parseInt(rec.glSubAcct5).toPaddedString(2));
			$("txtGlSubAcct6").value 		= (rec == null ? "" : parseInt(rec.glSubAcct6).toPaddedString(2));
			$("txtGlSubAcct7").value 		= (rec == null ? "" : parseInt(rec.glSubAcct7).toPaddedString(2));
			$("txtGlAcctName").value 		= (rec == null ? "" : unescapeHTML2(rec.glAcctName));
			$("txtGlAcctSname").value 		= (rec == null ? "" : unescapeHTML2(rec.glAcctSname));
			$("txtGsltSlTypeCd").value 		= (rec == null ? "" : unescapeHTML2(rec.gsltSlTypeCd));
			$("txtDspSlTypeName").value 	= (rec == null ? "" : unescapeHTML2(rec.dspSlTypeName));
			$("txtLeafTag").value 			= (rec == null ? "" : unescapeHTML2(rec.leafTag));
			$("txtDrCrTag").value 			= (rec == null ? "" : unescapeHTML2(rec.drCrTag));
			$("txtAcctType").value 			= (rec == null ? "" : unescapeHTML2(rec.acctType));
			$("txtRefAcctCd").value 		= (rec == null ? "" : unescapeHTML2(rec.refAcctCd));
			$("txtUserId").value 			= (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value 		= (rec == null ? "" : rec.lastUpdate);
			$("txtGlAcctName").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.glAcctName)));
			$("txtDrCrTag").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.drCrTag)));
			$("txtLeafTag").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.leafTag)));
			
			rec == null ? $("txtGlAcctCategory").readOnly = false : $("txtGlAcctCategory").readOnly = true;
			rec == null ? $("txtGlControlAcct").readOnly = false : $("txtGlControlAcct").readOnly = true;
			rec == null ? $("txtGlSubAcct1").readOnly = false : $("txtGlSubAcct1").readOnly = true;
			rec == null ? $("txtGlSubAcct2").readOnly = false : $("txtGlSubAcct2").readOnly = true;
			rec == null ? $("txtGlSubAcct3").readOnly = false : $("txtGlSubAcct3").readOnly = true;
			rec == null ? $("txtGlSubAcct4").readOnly = false : $("txtGlSubAcct4").readOnly = true;
			rec == null ? $("txtGlSubAcct5").readOnly = false : $("txtGlSubAcct5").readOnly = true;
			rec == null ? $("txtGlSubAcct6").readOnly = false : $("txtGlSubAcct6").readOnly = true;
			rec == null ? $("txtGlSubAcct7").readOnly = false : $("txtGlSubAcct7").readOnly = true;
			
			if (userHasAccess) {
				objCurrGlAcctId 				= (rec == null ? "" : rec.glAcctId);
				rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
				rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
				rec == null ? disableButton("btnAddSameLevel") : enableButton("btnAddSameLevel");
				rec == null ? disableButton("btnAddNextLevel") : enableButton("btnAddNextLevel");
				rec == null ? disableButton("btnCopy") : enableButton("btnCopy");
				glAcctCode.push((rec == null ? "" : rec.glAcctCategory));
				glAcctCode.push((rec == null ? "" :rec.glControlAcct));
				glAcctCode.push((rec == null ? "" :rec.glSubAcct1));
				glAcctCode.push((rec == null ? "" :rec.glSubAcct2));
				glAcctCode.push((rec == null ? "" :rec.glSubAcct3));
				glAcctCode.push((rec == null ? "" :rec.glSubAcct4));
				glAcctCode.push((rec == null ? "" :rec.glSubAcct5));
				glAcctCode.push((rec == null ? "" :rec.glSubAcct6));
				glAcctCode.push((rec == null ? "" :rec.glSubAcct7));
				objCurrChartOfAccounts = rec;
			}
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.glAcctCategory 	= $F("txtGlAcctCategory");
			obj.glControlAcct 	= $F("txtGlControlAcct");
			obj.glSubAcct1 		= $F("txtGlSubAcct1");
			obj.glSubAcct2 		= $F("txtGlSubAcct2" );
			obj.glSubAcct3 		= $F("txtGlSubAcct3");
			obj.glSubAcct4 		= $F("txtGlSubAcct4");
			obj.glSubAcct5 		= $F("txtGlSubAcct5");
			obj.glSubAcct6 		= $F("txtGlSubAcct6");
			obj.glSubAcct7 		= $F("txtGlSubAcct7");
			obj.glAcctName 		= escapeHTML2($F("txtGlAcctName"));
			obj.glAcctSname 	= escapeHTML2($F("txtGlAcctSname"));
			obj.gsltSlTypeCd 	= escapeHTML2($F("txtGsltSlTypeCd"));
			obj.dspSlTypeName 	= escapeHTML2($F("txtDspSlTypeName"));
			obj.leafTag 		= escapeHTML2($F("txtLeafTag"));
			obj.drCrTag 		= escapeHTML2($F("txtDrCrTag"));
			obj.acctType 		= escapeHTML2($F("txtAcctType"));
			obj.refAcctCd 		= escapeHTML2($F("txtRefAcctCd"));
			obj.glAcctId		= objCurrGlAcctId;
			obj.userId 			= userId;
			var lastUpdate 		= new Date();
			obj.lastUpdate 		= dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGiacs311;
			var rec = setRec(objCurrChartOfAccounts);
			if($F("btnAdd") == "Add"){
				tbgChartOfAccounts.addBottomRow(rec);
			} else {
				tbgChartOfAccounts.updateVisibleRowOnly(rec, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgChartOfAccounts.keys.removeFocus(tbgChartOfAccounts.keys._nCurrentFocus, true);
			tbgChartOfAccounts.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		

	function valAddRec(){
		try{ 
			if(checkAllRequiredFieldsInDiv("charOfAccountsFormDiv")){
				if (validateCode()) {
					var addedSameExists = false;
					var deletedSameExists = false;	
					if($F("btnAdd") == "Add") {
						for(var i=0; i<tbgChartOfAccounts.geniisysRows.length; i++){
							if(tbgChartOfAccounts.geniisysRows[i].recordStatus == 0 || tbgChartOfAccounts.geniisysRows[i].recordStatus == 1){								
								if(removeLeadingZero(tbgChartOfAccounts.geniisysRows[i].glAcctCategory) == removeLeadingZero($F("txtGlAcctCategory")) && removeLeadingZero(tbgChartOfAccounts.geniisysRows[i].glControlAcct) == removeLeadingZero($F("txtGlControlAcct"))
										&& removeLeadingZero(tbgChartOfAccounts.geniisysRows[i].glSubAcct1) == removeLeadingZero($F("txtGlSubAcct1")) && removeLeadingZero(tbgChartOfAccounts.geniisysRows[i].glSubAcct2) == removeLeadingZero($F("txtGlSubAcct2"))
										&& removeLeadingZero(tbgChartOfAccounts.geniisysRows[i].glSubAcct3) == removeLeadingZero($F("txtGlSubAcct3")) && removeLeadingZero(tbgChartOfAccounts.geniisysRows[i].glSubAcct4) == removeLeadingZero($F("txtGlSubAcct4"))
										&& removeLeadingZero(tbgChartOfAccounts.geniisysRows[i].glSubAcct5) == removeLeadingZero($F("txtGlSubAcct5")) && removeLeadingZero(tbgChartOfAccounts.geniisysRows[i].glSubAcct6) == removeLeadingZero($F("txtGlSubAcct6"))
										&& removeLeadingZero(tbgChartOfAccounts.geniisysRows[i].glSubAcct7) == removeLeadingZero($F("txtGlSubAcct7"))){
									addedSameExists = true;								
								}							
							} else if(tbgChartOfAccounts.geniisysRows[i].recordStatus == -1){
								if(removeLeadingZero(tbgChartOfAccounts.geniisysRows[i].glAcctCategory) == removeLeadingZero($F("txtGlAcctCategory")) && removeLeadingZero(tbgChartOfAccounts.geniisysRows[i].glControlAcct) == removeLeadingZero($F("txtGlControlAcct"))
										&& removeLeadingZero(tbgChartOfAccounts.geniisysRows[i].glSubAcct1) == removeLeadingZero($F("txtGlSubAcct1")) && removeLeadingZero(tbgChartOfAccounts.geniisysRows[i].glSubAcct2) == removeLeadingZero($F("txtGlSubAcct2"))
										&& removeLeadingZero(tbgChartOfAccounts.geniisysRows[i].glSubAcct3) == removeLeadingZero($F("txtGlSubAcct3")) && removeLeadingZero(tbgChartOfAccounts.geniisysRows[i].glSubAcct4) == removeLeadingZero($F("txtGlSubAcct4"))
										&& removeLeadingZero(tbgChartOfAccounts.geniisysRows[i].glSubAcct5) == removeLeadingZero($F("txtGlSubAcct5")) && removeLeadingZero(tbgChartOfAccounts.geniisysRows[i].glSubAcct6) == removeLeadingZero($F("txtGlSubAcct6"))
										&& removeLeadingZero(tbgChartOfAccounts.geniisysRows[i].glSubAcct7) == removeLeadingZero($F("txtGlSubAcct7"))){
									deletedSameExists = true;
								}
							}
						}
						
						if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
							showMessageBox("Record already exists with the same gl_acct_category, gl_control_acct, gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6  and gl_sub_acct_7.", "E");
							return;
						} else if(deletedSameExists && !addedSameExists){
							addRec();
							return;
						}
						new Ajax.Request(contextPath + "/GIACChartOfAcctsController", {
							parameters : {
								action : "valAddRec",
								tran   : "ADD",
								glAcctCategory : $F("txtGlAcctCategory"),
								glControlAcct : $F("txtGlControlAcct"),
								glSubAcct1 : $F("txtGlSubAcct1"),
								glSubAcct2 : $F("txtGlSubAcct2"),
								glSubAcct3 : $F("txtGlSubAcct3"),
								glSubAcct4 : $F("txtGlSubAcct4"),
								glSubAcct5 : $F("txtGlSubAcct5"),
								glSubAcct6 : $F("txtGlSubAcct6"),
								glSubAcct7 : $F("txtGlSubAcct7"),
								glAcctId   : objCurrGlAcctId
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
						if (slChanged) {
							valUpdateRec();	
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
	
	function valUpdateRec() {
		new Ajax.Request(contextPath + "/GIACChartOfAcctsController", {
			parameters : {
				action : "valUpdateRec",
				glAcctId : objCurrGlAcctId
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					addRec();
				}else {
					$("txtGsltSlTypeCd").clear();
					$("txtDspSlTypeName").clear();
					slChanged = false;
				}
			}
		});
	}
	
	function deleteRec(){
		changeTagFunc = saveGiacs311;
		objCurrChartOfAccounts.recordStatus = -1;
		tbgChartOfAccounts.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIACChartOfAcctsController", {
				parameters : {
					action : "valDelRec",
					glAcctId : nvl(objCurrGlAcctId,0)
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
	
	function validateCode() {
		var val = true;
		if (parseInt($F("txtGlAcctCategory")) == 0) {
			customShowMessageBox("gl_acct_category level has been skipped.", imgMessage.INFO, "txtGlAcctCategory");
			val = false;
		}else {
			if (parseInt($F("txtGlControlAcct")) == 0) {
				if (parseInt($F("txtGlSubAcct1")) != 0) {
					customShowMessageBox("gl_control_acct level has been skipped.", imgMessage.INFO, "txtGlControlAcct");
					val = false;
				}
			}else {
				if (parseInt($F("txtGlSubAcct1")) == 0) {
					if (parseInt($F("txtGlSubAcct2")) != 0) {
						customShowMessageBox("gl_sub_acct_1 level has been skipped.", imgMessage.INFO, "txtGlSubAcct1");
						val = false;
					}	
				}else {
					if (parseInt($F("txtGlSubAcct2")) == 0) {
						if (parseInt($F("txtGlSubAcct3")) != 0) {
							customShowMessageBox("gl_sub_acct_2 level has been skipped.", imgMessage.INFO, "txtGlSubAcct2");
							val = false;
						}		
					}else {
						if (parseInt($F("txtGlSubAcct3")) == 0) {
							if (parseInt($F("txtGlSubAcct4")) != 0) {
								customShowMessageBox("gl_sub_acct_3 level has been skipped.", imgMessage.INFO, "txtGlSubAcct3");
								val = false;
							}	
						}else {
							if (parseInt($F("txtGlSubAcct4")) == 0) {
								if (parseInt($F("txtGlSubAcct5")) != 0) {
									customShowMessageBox("gl_sub_acct_4 level has been skipped.", imgMessage.INFO, "txtGlSubAcct4");
									val = false;
								}
							}else {
								if (parseInt($F("txtGlSubAcct5")) == 0) {
									if (parseInt($F("txtGlSubAcct6")) != 0) {
										customShowMessageBox("gl_sub_acct_5 level has been skipped.", imgMessage.INFO, "txtGlSubAcct5");
										val = false;
									}
								}else {
									if (parseInt($F("txtGlSubAcct6")) == 0) {
										if (parseInt($F("txtGlSubAcct7")) != 0) {
											customShowMessageBox("gl_sub_acct_6 level has been skipped.", imgMessage.INFO, "txtGlSubAcct3");
											val = false;
										}
									}
								}
							}
						}
					}
				}
			}
		}
		return val;
	}
	
	function showSlTypeLOV(isIconClicked) {
		try {
			var search = isIconClicked ? "%" : ($F("txtGsltSlTypeCd").trim() == "" ? "%" : $F("txtGsltSlTypeCd"));
			
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGiacs311SlTypeRecList",
			  gsltSlTypeCd : search,
					search : search,
					page: 1
				},
				title : "List of SL Types",
				width : 480,
				height : 386,
				columnModel : [
					{
						id : "gsltSlTypeCd",
						title : "SL Type Code",
						width : '150px'
					},
					{
						id : "dspSlTypeName",
						title : "SL Type Name",
						width : '300px'
					}
				],
				draggable : true,
				autoSelectOneRecord : true,
				filterText : escapeHTML2(search),
				onSelect : function(row) {
					if (row != null || row != undefined) {
						$("txtGsltSlTypeCd").value = unescapeHTML2(row.gsltSlTypeCd);
						$("txtGsltSlTypeCd").setAttribute("lastValidValue", unescapeHTML2(row.gsltSlTypeCd));
						$("txtDspSlTypeName").value = unescapeHTML2(row.dspSlTypeName);
						slChanged = true;
					}
				},
				onCancel : function() {
					$("txtGsltSlTypeCd").focus();
					$("txtGsltSlTypeCd").value = $("txtGsltSlTypeCd").readAttribute("lastValidValue");
					slChanged = false;
				},
				onUndefinedRow : function() {
					$("txtGsltSlTypeCd").value = $("txtGsltSlTypeCd").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtGsltSlTypeCd");
					slChanged = false;
				}
			});
		} catch (e) {
			showErrorMessage("showSlTypeLOV", e);
		}
	}

	function showAcctTypeLOV(isIconClicked) {
		try {
			var search = isIconClicked ? "%" : ($F("txtAcctType").trim() == "" ? "%" : $F("txtAcctType"));
			
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGiacs311AcctTypeRecList",
			      acctType : search,
					search : search + "%",
					page: 1
				},
				title : "List of Acct. Types",
				width : 480,
				height : 386,
				columnModel : [
					{
						id : "rvLowValue",
						title : "Accounting Type",
						width : '150px'
					},
					{
						id : "rvMeaning",
						title : "Description",
						width : '300px'
					}
				],
				draggable : true,
				autoSelectOneRecord : true,
				filterText : escapeHTML2(search),
				onSelect : function(row) {
					if (row != null || row != undefined) {
						$("txtAcctType").value = unescapeHTML2(row.rvLowValue);
						$("txtAcctType").setAttribute("lastValidValue", unescapeHTML2(row.rvLowValue));
					}
				},
				onCancel : function() {
					$("txtAcctType").focus();
					$("txtAcctType").value = $("txtAcctType").readAttribute("lastValidValue");
				},
				onUndefinedRow : function() {
					$("txtAcctType").value = $("txtAcctType").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtAcctType");
				}
			});
		} catch (e) {
			showErrorMessage("showAcctTypeLOV", e);
		}
	}
	
	function getGlMotherAcct(level) {
		new Ajax.Request(contextPath+"/GIACChartOfAcctsController?action=getGlMotherAcct",{
			method: "POST",
			parameters:{
			    glAcctId : objCurrGlAcctId,
				level : level
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				hideNotice("");
				if (checkErrorOnResponse(response)){
					var message = response.responseText.split("-#-");
					motherGlAcctId = message[0];
				}
			}
		});
	}
	
	function copyRecord() {
		tbgChartOfAccounts.unselectRows();
		objCurrChartOfAccounts = null;
		$("txtGlAcctSname").focus();
		objCurrGlAcctId = null;
		$("btnAdd").value = "Add";
		$("txtLastUpdate").value = dateFormat(new Date(), 'mm-dd-yyyy hh:MM:ss TT');
		$("txtUserId").value = "${PARAMETERS['USER'].userId}";
		$$("input[name='glAccountCode']").each(function(gl) {
			enableInputField(gl.id);	
		});
		disableButton("btnCopy");
		disableButton("btnDelete");
		disableButton("btnAddSameLevel");
		disableButton("btnAddNextLevel");
	}
	
	function setQueryMode(set) {
		if (set) {
			disableButton("btnCopy");
			disableButton("btnAdd");
			disableButton("btnDelete");
			disableButton("btnSave");
			disableButton("btnAddSameLevel");
			disableButton("btnAddNextLevel");
			disableSearch("imgAcctTypeLOV");
			disableSearch("imgGsltSlTypeLOV");
			disableInputField("txtGlAcctCategory");
			disableInputField("txtGlControlAcct");
			disableInputField("txtGlSubAcct1");
			disableInputField("txtGlSubAcct2");
			disableInputField("txtGlSubAcct3");
			disableInputField("txtGlSubAcct4");
			disableInputField("txtGlSubAcct5");
			disableInputField("txtGlSubAcct6");
			disableInputField("txtGlSubAcct7");
			disableInputField("txtGlAcctName");
			disableInputField("txtGlAcctSname");
			disableInputField("txtRefAcctCd");
			disableInputField("txtGsltSlTypeCd");
			disableInputField("txtLeafTag");
			disableInputField("txtDrCrTag");
			disableInputField("txtAcctType");
		}
	}
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	}	
	
	function cancelGiacs311(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIACS311.exitPage = exitPage;
						saveGiacs311();
					}, function(){
						changeTag = 0;
						goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		}
	}
	
	function showAddLevel(title, level) {
		overlayAddLevel = Overlay.show(contextPath + "/GIACChartOfAcctsController", {
			urlContent : true,
			urlParameters : {
				action : "showGiacs311AddLevel",
				level : level,
				glAcctId : objCurrGlAcctId,
				motherGlAcctId : motherGlAcctId
				},
			title : title,
			height : '420px',
			width : '740px',
			draggable : true
		});	
	}
	
	function printReport(){
		try {
			var content = contextPath + "/ChartOfAccountsPrintController?action=printChartOfAccount&reportId=GIGLR02A";
			
			if("screen" == $F("selDestination")){
				showPdfReport(content, "Chart of Accounts");
			}else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					parameters : {noOfCopies : $F("txtNoOfCopies"),
						  	      printerName : $F("selPrinter")},
					onCreate: showNotice("Processing, please wait..."),				
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							showMessageBox("Printing complete.", "S");
						}
					}
				});
			}else if("file" == $F("selDestination")){
				new Ajax.Request(content, {
					parameters : {destination : "file",
								  fileType : $("rdoPdf").checked ? "PDF" : "XLS"},
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							copyFileToLocal(response);
						}
					}
				});
			}else if("local" == $F("selDestination")){
				new Ajax.Request(content, {
					parameters : {destination : "local"},
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							var message = printToLocalPrinter(response.responseText);
							if(message != "SUCCESS"){
								showMessageBox(message, imgMessage.ERROR);
							}
						}
					}
				});
			}
		} catch (e){
			showErrorMessage("printReport", e);
		}
	}
	
	$("imgGsltSlTypeLOV").observe("click", function() {
		showSlTypeLOV(true);
	});

	$("txtGsltSlTypeCd").observe("change", function() {
		if (this.value != "") {
			showSlTypeLOV(false);
		} else {
			$("txtGsltSlTypeCd").value = "";
			$("txtDspSlTypeName").value = "";
			$("txtGsltSlTypeCd").setAttribute("lastValidValue", "");
		}slChanged = true;
	});

	$("imgAcctTypeLOV").observe("click", function() {
		showAcctTypeLOV(true);
	});

	$("txtAcctType").observe("change", function() {
		if (this.value != "") {
			showAcctTypeLOV(false);
		} else {
			$("txtAcctType").value = "";
			$("txtAcctType").setAttribute("lastValidValue", "");
		}
	});
	
	$("txtLeafTag").observe("change", function() {
		if ($F("txtLeafTag") == "Y" || $F("txtLeafTag") == "N") {
			$("txtLeafTag").setAttribute("lastValidValue",$F("txtLeafTag"));
		}else {
			customShowMessageBox("Invalid Leaf Tag. Valid values should be 'Y' or 'N'.", imgMessage.INFO,"txtLeafTag");
			$("txtLeafTag").value = $("txtLeafTag").getAttribute("lastValidValue");
		}
	});
	
	$("txtDrCrTag").observe("change", function() {
		if ($F("txtDrCrTag") == "D" || $F("txtDrCrTag") == "C") {
			$("txtDrCrTag").setAttribute("lastValidValue",$F("txtDrCrTag"));
		}else {
			customShowMessageBox("Invalid Debit/Credit Tag. Valid values should be 'D' or 'C'.", imgMessage.INFO,"txtDrCrTag");
			$("txtDrCrTag").value = $("txtDrCrTag").getAttribute("lastValidValue");
		}
	});

	$("txtGlAcctName").observe("keyup", function(){
		$("txtGlAcctName").value = $F("txtGlAcctName").toUpperCase();
	});
	
	$("txtGlAcctSname").observe("keyup", function(){
		$("txtGlAcctSname").value = $F("txtGlAcctSname").toUpperCase();
	});
	
	$("txtLeafTag").observe("keyup", function(){
		$("txtLeafTag").value = $F("txtLeafTag").toUpperCase();
	});
	
	$("txtDrCrTag").observe("keyup", function(){
		$("txtDrCrTag").value = $F("txtDrCrTag").toUpperCase();
	});
	
	$("txtRefAcctCd").observe("keyup", function(){
		$("txtRefAcctCd").value = $F("txtRefAcctCd").toUpperCase();
	});
	
	$$("input[name='glAccountCode']").each(function(gl) {
		gl.observe("change", function() {
			if (gl.id == "txtGlAcctCategory") {
				if (gl.value != glAcctCode[0]) {
					changed = true;
				}
			}else if (gl.id == "txtGlControlAcct") {
				if (gl.value != glAcctCode[1]) {
					changed = true;
				}
			}else if (gl.id == "txtGlSubAcct1") {
				if (gl.value != glAcctCode[2]) {
					changed = true;
				}
			}else if (gl.id == "txtGlSubAcct2") {
				if (gl.value != glAcctCode[3]) {
					changed = true;
				}
			}else if (gl.id == "txtGlSubAcct3") {
				if (gl.value != glAcctCode[4]) {
					changed = true;
				}
			}else if (gl.id == "txtGlSubAcct4") {
				if (gl.value != glAcctCode[5]) {
					changed = true;
				}
			}else if (gl.id == "txtGlSubAcct6") {
				if (gl.value != glAcctCode[7]) {
					changed = true;
				}
			}else if (gl.id == "txtGlSubAcct7") {
				if (gl.value != glAcctCode[8]) {
					changed = true;
				}
			}else{
				changed = false;
			}
			
			if (gl.id != "txtGlAcctCategory") {
				gl.value = formatNumberDigits(gl.value,2);
			}
		});
	});
	
	$("selQueryLevel").observe("change", function() {
		if (changeTag == 1) {
			showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
			$("selQueryLevel").value = $("selQueryLevel").getAttribute("lastValidValue");
		}else {
			tbgChartOfAccounts.url = contextPath + "/GIACChartOfAcctsController?action=showGiacs311&refresh=1&queryLevel="+$F("selQueryLevel");
			tbgChartOfAccounts._refreshList();
			$("selQueryLevel").setAttribute("lastValidValue", $F("selQueryLevel"));
		}
	});
	
	$("btnCopy").observe("click", function() {
		copyRecord();
	});
	
	$("btnAddNextLevel").observe("click", function() {
		if (changeTag != 1) {
			if ($F("txtLeafTag") == "N") {
				if (parseInt($F("txtGlSubAcct7")) > 0) {
					showMessageBox("This is the last level.", imgMessage.INFO);
				}else {
					getGlMotherAcct("next");
					showAddLevel("Add Next Level","next");
				}
			}else {
				showMessageBox("Next level is not available for leaf tag 'Y'.", imgMessage.INFO);
			}
		}else {
			showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
		}
	});
	
	$("btnAddSameLevel").observe("click", function() {
		if (changeTag != 1) {
			getGlMotherAcct("same");
			showAddLevel("Add Same Level","same");
		}else {
			showMessageBox(objCommonMessage.SAVE_CHANGES, imgMessage.INFO);
		}
	});
	
	$("btnPrintChartOfAcct").observe("click", function(){
		showGenericPrintDialog("Print Chart Of Accounts", printReport, "", true);
	});
	
	disableButton("btnDelete");
	disableButton("btnCopy");
	disableButton("btnAddNextLevel");
	disableButton("btnAddSameLevel");
	
	observeSaveForm("btnSave", saveGiacs311);
	$("btnCancel").observe("click", cancelGiacs311);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("acExit").stopObserving("click");
	$("acExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	$("txtGlAcctCategory").focus();
	
</script>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<jsp:include page="/pages/toolbar.jsp"></jsp:include>
<div id="giacs351MainDiv" name="giacs351MainDiv">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Month-end Report Detail Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>
	<div id="giacs351" name="giacs351">
		<div class="sectionDiv" id="giacs351LovDiv">
			<div style="" align="center" id="lovDiv">
				<table cellspacing="2" border="0" style="margin: 10px auto;">
					<tr>
						<td class="rightAligned">Report Title</td>
						<td class="leftAligned">
							<span class="lovSpan required" style="width: 100px; height: 22px; margin: 2px 2px 0 0; float: left;">
								<input id="txtRepCd" name="txtRepCd" type="text" class="required allCaps" style="width: 74px; text-align: left; height: 13px; float: left; border: none;" tabindex="201" maxlength="12" ignoreDelKey="1">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchRep" name="imgSearchRep" alt="Go" style="float: right;">
							</span>
							<input id="txtRepTitle" name="txtRepTitle" type="text" style="width: 400px; height: 16px;" readonly="readonly" tabindex="103"/>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="sectionDiv">
			<div id="giacs351TableDiv" style="padding-top: 10px;">
				<div id="giacs351Table" style="height: 340px; margin-left: 90px;"></div>
			</div>
			<div align="center" id="giacs351FormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">GL Account Code</td>
						<td class="leftAligned" colspan="3">
							<div id="glCodeDiv" style="float: left;">
							    <input id="hidGlAcctId" type="hidden">
							    <input id="hidGlAccountCode" type="hidden">
								<input id="txtGlAcctCategory" type="text" class="required glAC integerNoNegativeUnformattedNoComma rightAligned " maxlength="1" style="width: 20px; padding-right: 3px;" tabindex="104">
								<input id="txtGlControlAcct" type="text" class="required glAC integerNoNegativeUnformattedNoComma rightAligned " lpad="2" maxlength="2" style="width: 20px; padding-right: 3px;" tabindex="105" >
								<input id="txtGlSubAcct1" type="text" class="required glAC integerNoNegativeUnformattedNoComma rightAligned " lpad="2" maxlength="2" style="width: 20px; padding-right: 3px;" tabindex="106" > 
								<input id="txtGlSubAcct2" type="text" class="required glAC integerNoNegativeUnformattedNoComma rightAligned " lpad="2" maxlength="2" style="width: 20px; padding-right: 3px;" tabindex="107" > 
								<input id="txtGlSubAcct3" type="text" class="required glAC integerNoNegativeUnformattedNoComma rightAligned " lpad="2" maxlength="2" style="width: 20px; padding-right: 3px;" tabindex="108" > 
								<input id="txtGlSubAcct4" type="text" class="required glAC integerNoNegativeUnformattedNoComma rightAligned " lpad="2" maxlength="2" style="width: 20px; padding-right: 3px;" tabindex="109" > 
								<input id="txtGlSubAcct5" type="text" class="required glAC integerNoNegativeUnformattedNoComma rightAligned " lpad="2" maxlength="2" style="width: 20px; padding-right: 3px;" tabindex="110" > 
								<input id="txtGlSubAcct6" type="text" class="required glAC integerNoNegativeUnformattedNoComma rightAligned " lpad="2" maxlength="2" style="width: 20px; padding-right: 3px;" tabindex="111" > 
								<input id="txtGlSubAcct7" type="text" class="required glAC integerNoNegativeUnformattedNoComma rightAligned " lpad="2" maxlength="2" style="width: 20px; padding-right: 3px;"  tabindex="112">
								<img id="searchGLAcctNoLov" alt="GL Account No Lov" style="height: 17px; cursor: pointer;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">GL Account Name</td>
						<td class="leftAligned" colspan="3">
							<input class="" id="txtGlAcctName" type="text" readonly="readonly" style="width: 533px;" tabindex="113">
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="204"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="205"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned" style="width: 254px;"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="116"></td>
						<td width="" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="117"></td>
					</tr>
				</table>
			</div>
			<div align="center" style="margin: 10px;">
				<input type="button" class="button" id="btnAdd2" value="Add" tabindex="119">
				<input type="button" class="button" id="btnDelete2" value="Delete" tabindex="120">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="121">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="122">
	<input id="hidCallFrom" type="hidden" value="${callFrom}">
</div>
<script type="text/javascript">
	hideToolbarButton("btnToolbarPrint");
	showToolbarButton("btnToolbarSave");
	disableToolbarButton("btnToolbarExecuteQuery");
	disableToolbarButton("btnToolbarEnterQuery");
	
	setForm(false);
	function setForm(enable){
		if(enable){
			$("txtGlAcctCategory").readOnly = false;
			$("txtGlControlAcct").readOnly = false;
			$("txtGlSubAcct1").readOnly = false;
			$("txtGlSubAcct2").readOnly = false;
			$("txtGlSubAcct3").readOnly = false;
			$("txtGlSubAcct4").readOnly = false;
			$("txtGlSubAcct5").readOnly = false;
			$("txtGlSubAcct6").readOnly = false;
			$("txtGlSubAcct7").readOnly = false;
			$("txtRemarks").readOnly = false; 
			//$("searchGLAcctNoLov").show();
			enableSearch("searchGLAcctNoLov");
			enableButton("btnAdd2");
		} else {
			$("txtGlAcctCategory").readOnly = true;
			$("txtGlControlAcct").readOnly = true;
			$("txtGlSubAcct1").readOnly = true;
			$("txtGlSubAcct2").readOnly = true;
			$("txtGlSubAcct3").readOnly = true;
			$("txtGlSubAcct4").readOnly = true;
			$("txtGlSubAcct5").readOnly = true;
			$("txtGlSubAcct6").readOnly = true;
			$("txtGlSubAcct7").readOnly = true;
			$("txtRemarks").readOnly = true;
			//$("searchGLAcctNoLov").hide();
			disableSearch("searchGLAcctNoLov");
			disableButton("btnAdd2");
			disableButton("btnDelete2");
		}
	}
	
	setModuleId("GIACS351");
	setDocumentTitle("Month-end Report Detail Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	var objGIACS351 = {};
	var objCurrEomRepDtl = null;
	objGIACS351.eomRepDtlList = JSON.parse('${jsonEomRepDtlList}');
	objGIACS351.exitPage = null;
	objGIACS351.enterQuery = null;
	
	var eomRepDtlTable = {
			id : 201,
			url : contextPath + "/GIACEomRepController?action=showGiacs351&refresh=1",
			options : {
				width : '750px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrEomRepDtl = tbgEomRepDtl.geniisysRows[y];
					setFieldValuesDtl(objCurrEomRepDtl);
					tbgEomRepDtl.keys.removeFocus(tbgEomRepDtl.keys._nCurrentFocus, true);
					tbgEomRepDtl.keys.releaseKeys();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValuesDtl(null);
					tbgEomRepDtl.keys.removeFocus(tbgEomRepDtl.keys._nCurrentFocus, true);
					tbgEomRepDtl.keys.releaseKeys();
				},
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValuesDtl(null);
						tbgEomRepDtl.keys.removeFocus(tbgEomRepDtl.keys._nCurrentFocus, true);
						tbgEomRepDtl.keys.releaseKeys();
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
					setFieldValuesDtl(null);
					tbgEomRepDtl.keys.removeFocus(tbgEomRepDtl.keys._nCurrentFocus, true);
					tbgEomRepDtl.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValuesDtl(null);
					tbgEomRepDtl.keys.removeFocus(tbgEomRepDtl.keys._nCurrentFocus, true);
					tbgEomRepDtl.keys.releaseKeys();
				},
				prePager: function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
					rowIndex = -1;
					setFieldValuesDtl(null);
					tbgEomRepDtl.keys.removeFocus(tbgEomRepDtl.keys._nCurrentFocus, true);
					tbgEomRepDtl.keys.releaseKeys();
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
					id : 'repCd',
					width : '0',
					visible: false				
				},
				{
					id : 'glAcctId',
					width : '0',
					visible: false				
				},
				{
					id: 'glAcctCategory glControlAcct glSubAcct1 glSubAcct2 glSubAcct3 glSubAcct4 glSubAcct5 glSubAcct6 glSubAcct7',
					title: 'GL Account Code',
				    width : '256px',
				    children : [
				    	{
				    		id : 'glAcctCategory',
			                title: 'GL Acct Category',
			                type: "number",
			                align: "right",
			                width: 30,
			                filterOption: true,
				            filterOptionType: 'integerNoNegative', 
				    	},
				    	{
				    		id : 'glControlAcct',
			                title: 'GL Control Acct',
			                type: "number",
			                align: "right",
			                width: 30,
			                filterOption: true,
				            filterOptionType: 'integerNoNegative', 
			                renderer: function (value){
								return nvl(value,'') == '' ? '' :formatNumberDigits(value,2);
							}
				    	},
				    	{
				    		id : 'glSubAcct1',
			                title: 'GL Sub Acct 1',
			                type: "number",
			                align: "right",
			                width: 30,
			                filterOption: true,
				            filterOptionType: 'integerNoNegative', 
			                renderer: function (value){
								return nvl(value,'') == '' ? '' :formatNumberDigits(value,2);
							}
				    	},
				    	{
				    		id : 'glSubAcct2',
			                title: 'GL Sub Acct 2',
			                type: "number",
			                align: "right",
			                width: 30,
			                filterOption: true,
				            filterOptionType: 'integerNoNegative', 
			                renderer: function (value){
								return nvl(value,'') == '' ? '' :formatNumberDigits(value,2);
							}
				    	},
				    	{
				    		id : 'glSubAcct3',
			                title: 'GL Sub Acct 3',
			                type: "number",
			                align: "right",
			                width: 30,
			                filterOption: true,
				            filterOptionType: 'integerNoNegative', 
			                renderer: function (value){
								return nvl(value,'') == '' ? '' :formatNumberDigits(value,2);
							}
				    	},
				    	{
				    		id : 'glSubAcct4',
			                title: 'GL Sub Acct 4',
			                type: "number",
			                align: "right",
			                width: 30,
			                filterOption: true,
				            filterOptionType: 'integerNoNegative', 
			                renderer: function (value){
								return nvl(value,'') == '' ? '' :formatNumberDigits(value,2);
							}
				    	},
				    	{
				    		id : 'glSubAcct5',
			                title: 'GL Sub Acct 5',
			                type: "number",
			                align: "right",
			                width: 30,
			                filterOption: true,
				            filterOptionType: 'integerNoNegative', 
			                renderer: function (value){
								return nvl(value,'') == '' ? '' :formatNumberDigits(value,2);
							}
				    	},
				    	{
				    		id : 'glSubAcct6',
			                title: 'GL Sub Acct 6',
			                type: "number",
			                align: "right",
			                width: 30,
			                filterOption: true,
				            filterOptionType: 'integerNoNegative', 
			                renderer: function (value){
								return nvl(value,'') == '' ? '' :formatNumberDigits(value,2);
							}
				    	},
				    	{
				    		id : 'glSubAcct7',
			                title: 'GL Sub Acct 7',
			                type: "number",
			                align: "right",
			                width: 30,
			                filterOption: true,
				            filterOptionType: 'integerNoNegative', 
			                renderer: function (value){
								return nvl(value,'') == '' ? '' :formatNumberDigits(value,2);
							}
				    	}
					]
				},
				{
					id : "glAcctName",
					title : "GL Account Name",
					filterOption : true,
					width : '420px'
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
				},
				{
					id : 'glAcctNo',
					title : 'GL Account Code',
					width : '0',
					visible : false,
					//filterOption : true
				}
				    
            ],
            rows : objGIACS351.eomRepDtlList.rows
	};
	tbgEomRepDtl = new MyTableGrid(eomRepDtlTable);
	tbgEomRepDtl.pager = objGIACS351.eomRepDtlList;
	tbgEomRepDtl.render("giacs351Table");
	tbgEomRepDtl.afterRender = function(){
		/* if(tbgEomRepDtl.geniisysRows.length > 0){
			var rec = tbgEomRepDtl.geniisysRows[0];
			setRepHeaderForm(rec);
		} else {  */
			$("txtRepCd").value = (objGiacs351.repCd == null ? ($F("txtRepCd")) : unescapeHTML2(objGiacs351.repCd));
			$("txtRepTitle").value = (objGiacs351.repTitle == null ? ($F("txtRepTitle")) : unescapeHTML2(objGiacs351.repTitle));
		//}
	};
	
	function setRepHeaderForm(rec){
		$("txtRepCd").value = (rec == null ? "" : unescapeHTML2(rec.repCd));
		$("txtRepTitle").value = (rec == null ? "" : unescapeHTML2(rec.repTitle));
	}
	
	function setFieldValuesDtl(rec){
		try{
			$("hidGlAcctId").value = (rec == null ? "" : rec.glAcctId);
			$("txtGlAcctCategory").value = (rec == null ? "" : rec.glAcctCategory);
			$("txtGlControlAcct").value = (rec == null ? "" : formatNumberDigits(rec.glControlAcct, 2));
			$("txtGlSubAcct1").value = (rec == null ? "" : formatNumberDigits(rec.glSubAcct1, 2));
			$("txtGlSubAcct2").value = (rec == null ? "" : formatNumberDigits(rec.glSubAcct2, 2));
			$("txtGlSubAcct3").value = (rec == null ? "" : formatNumberDigits(rec.glSubAcct3, 2));
			$("txtGlSubAcct4").value = (rec == null ? "" : formatNumberDigits(rec.glSubAcct4, 2));
			$("txtGlSubAcct5").value = (rec == null ? "" : formatNumberDigits(rec.glSubAcct5, 2));
			$("txtGlSubAcct6").value = (rec == null ? "" : formatNumberDigits(rec.glSubAcct5, 2));
			$("txtGlSubAcct7").value = (rec == null ? "" : formatNumberDigits(rec.glSubAcct7, 2));
			$("txtGlAcctName").value = (rec == null ? "" : unescapeHTML2(rec.glAcctName));
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			
			rec == null ? $("btnAdd2").value = "Add" : $("btnAdd2").value = "Update";
			rec == null ? $("txtGlAcctCategory").readOnly = false : $("txtGlAcctCategory").readOnly = true;
			rec == null ? $("txtGlControlAcct").readOnly = false : $("txtGlControlAcct").readOnly = true;
			rec == null ? $("txtGlSubAcct1").readOnly = false : $("txtGlSubAcct1").readOnly = true;
			rec == null ? $("txtGlSubAcct2").readOnly = false : $("txtGlSubAcct2").readOnly = true;
			rec == null ? $("txtGlSubAcct3").readOnly = false : $("txtGlSubAcct3").readOnly = true;
			rec == null ? $("txtGlSubAcct4").readOnly = false : $("txtGlSubAcct4").readOnly = true;
			rec == null ? $("txtGlSubAcct5").readOnly = false : $("txtGlSubAcct5").readOnly = true;
			rec == null ? $("txtGlSubAcct6").readOnly = false : $("txtGlSubAcct6").readOnly = true;
			rec == null ? $("txtGlSubAcct7").readOnly = false : $("txtGlSubAcct7").readOnly = true;
			rec == null ? 	("btnDelete2") : enableButton("btnDelete2");
			//rec == null ? $("searchGLAcctNoLov").show() : $("searchGLAcctNoLov").hide();
			rec == null ? enableSearch("searchGLAcctNoLov") : disableSearch("searchGLAcctNoLov");
			objCurrEomRepDtl = rec;
		} catch(e){
			showErrorMessage("setFieldValuesDtl", e);
		}
	}
	
	$("txtRepCd").setAttribute("lastValidValue", "");
	$("txtRepTitle").setAttribute("lastValidValue", "");
	$("imgSearchRep").observe("click", showGiacs350RepLov);
	$("txtRepCd").observe("change", function() {
		if($F("txtRepCd").trim() == "") {
			$("txtRepCd").value = "";
			$("txtRepCd").setAttribute("lastValidValue", "");
			$("txtRepTitle").value = "";
			$("txtRepCd").value = "";
			$("txtRepCd").setAttribute("lastValidValue", "");
			$("txtRepTitle").value = "";
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
		} else {
			if($F("txtRepCd").trim() != "" && $F("txtRepCd") != $("txtRepCd").readAttribute("lastValidValue")) {
				showGiacs350RepLov();
			}
		}
	});
	
	function showGiacs350RepLov(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {
				action : "getGiacs350RepLov",
				moduleId :  "GIACS351",
				filterText : ($("txtRepCd").readAttribute("lastValidValue").trim() != $F("txtRepCd").trim() ? $F("txtRepCd").trim() : ""),
				page : 1
			},
			title: "List of Report Titles",
			width: 500,
			height: 400,
			columnModel : [
					{
						id : "repCd",
						title: "Report Code",
						width: '100px',
						filterOption: true,
					},
					{
						id : "repTitle",
						title: "Report Title",
						width: '325px',
					}
			],
			autoSelectOneRecord: true,
			filterText : ($("txtRepCd").readAttribute("lastValidValue").trim() != $F("txtRepCd").trim() ? $F("txtRepCd").trim() : ""),
			onSelect: function(row) {
				enableToolbarButton("btnToolbarEnterQuery");
				enableToolbarButton("btnToolbarExecuteQuery");
				$("txtRepCd").value = unescapeHTML2(row.repCd);
				$("txtRepTitle").value = unescapeHTML2(row.repTitle);
				$("txtRepCd").setAttribute("lastValidValue", $F("txtRepCd"));
				$("txtRepTitle").setAttribute("lastValidValue", $F("txtRepTitle"));
			},
			onCancel: function (){
				$("txtRepCd").value = $("txtRepCd").readAttribute("lastValidValue");
				$("txtRepTitle").value = $("txtRepTitle").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtRepCd").value = $("txtRepCd").readAttribute("lastValidValue");
				$("txtRepTitle").value = $("txtRepTitle").readAttribute("lastValidValue");
			},
			onShow : function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		  });
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	function executeQuery(){
		if(checkAllRequiredFieldsInDiv("lovDiv")) {			
			tbgEomRepDtl.url = contextPath + "/GIACEomRepController?action=showGiacs351&refresh=1&repCd=" + encodeURIComponent($F("txtRepCd")) + "&callFrom=" + $F("hidCallFrom");
			tbgEomRepDtl._refreshList();
			setForm(true);
			disableToolbarButton("btnToolbarExecuteQuery");
			$("txtRepCd").readOnly = true;
			disableSearch("imgSearchRep");
		}
	}
	
	function enterQuery(){
		function proceedEnterQuery(){
			$("txtRepCd").value = "";
			$("txtRepCd").setAttribute("lastValidValue", "");
			$("txtRepTitle").value = "";
			$("txtRepCd").readOnly = false;
			enableSearch("imgSearchRep");
			tbgEomRepDtl.url = contextPath + "/GIACEomRepController?action=showGiacs351&refresh=1&repCd=" + $F("txtRepCd")
			+ "&callFrom=" + $F("hidCallFrom");
			tbgEomRepDtl._refreshList();
			setFieldValuesDtl(null);
			disableToolbarButton("btnToolbarExecuteQuery");
			disableToolbarButton("btnToolbarEnterQuery");
			setForm(false);
			$("txtRepCd").focus();
			changeTag = 0;
			changeTagFunc = "";
		}
		
		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
				        objGIACS351.enterQuery = proceedEnterQuery;
						saveGiacs351();
					}, function(){
						proceedEnterQuery();
					}, "");
		} else {
			proceedEnterQuery();
		}	
	}
	
	function exitPage(){
		if($F("hidCallFrom") == "GIACS350"){
			$("giacs350MainDiv").style.display = null;
			$("giacs351Div").style.display = "none";
		} else {
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		}
	}
	
	function cancelGiacs351(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIACS351.exitPage = exitPage;
						saveGiacs351();						
					}, function(){
						if($F("hidCallFrom") == "GIACS350"){
							changeTag = 0;
							changeTagFunc = "";
							$("giacs350MainDiv").style.display = null;
							$("giacs351Div").style.display = "none";
							setModuleId("GIACS350");
							setDocumentTitle("Month-end Report Maintenance");
						} else {
							goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
						}
					}, "");
		} else {
			if($F("hidCallFrom") == "GIACS350"){
				changeTag = 0;
				changeTagFunc = "";
				$("giacs350MainDiv").style.display = null;
				$("giacs351Div").style.display = "none";
				setModuleId("GIACS350");
				setDocumentTitle("Month-end Report Maintenance");
			} else {
				goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
			}
		}
	}
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("giacs351FormDiv")){
				if($F("btnAdd2") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;					
					
					for(var i=0; i<tbgEomRepDtl.geniisysRows.length; i++){
						if(tbgEomRepDtl.geniisysRows[i].recordStatus == 0 || tbgEomRepDtl.geniisysRows[i].recordStatus == 1){								
							if(tbgEomRepDtl.geniisysRows[i].glAcctId == $F("hidGlAcctId")){
								addedSameExists = true;								
							}							
						} else if(tbgEomRepDtl.geniisysRows[i].recordStatus == -1){
							if(tbgEomRepDtl.geniisysRows[i].glAcctId == $F("hidGlAcctId")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same rep_cd and gl_acct_id.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					
					// galing lang ito kay validate function validateGLAcctNo
					new Ajax.Request(contextPath+"/GIACEomRepController?action=validateGLAcctNo",{
						parameters: {
							glAcctCategory : $F("txtGlAcctCategory"),
							glAcctControlAcct : $F("txtGlControlAcct"),
							glSubAcct1 : $F("txtGlSubAcct1"),
							glSubAcct2 : $F("txtGlSubAcct2"),
							glSubAcct3 : $F("txtGlSubAcct3"),
							glSubAcct4 : $F("txtGlSubAcct4"),
							glSubAcct5 : $F("txtGlSubAcct5"),
							glSubAcct6 : $F("txtGlSubAcct6"),
							glSubAcct7 : $F("txtGlSubAcct7"),
						},
						onCreate : showNotice("Validating, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								new Ajax.Request(contextPath + "/GIACEomRepController", {
									parameters : {
												action : "valAddDtlRec",
												repCd : $F("txtRepCd"),
												glAcctCategory : $F("txtGlAcctCategory"),
												glAcctControlAcct : $F("txtGlControlAcct"),
												glSubAcct1 : $F("txtGlSubAcct1"),
												glSubAcct2 : $F("txtGlSubAcct2"),
												glSubAcct3 : $F("txtGlSubAcct3"),
												glSubAcct4 : $F("txtGlSubAcct4"),
												glSubAcct5 : $F("txtGlSubAcct5"),
												glSubAcct6 : $F("txtGlSubAcct6"),
												glSubAcct7 : $F("txtGlSubAcct7")
									},
									onCreate : showNotice("Processing, please wait..."),
									onComplete : function(response){
										hideNotice();
										if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
											addRec();
										}
									}
								});								
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
	
	function addRec(){
		try {
			changeTagFunc = saveGiacs351;
			var repDtl = setRec(objCurrEomRepDtl);
			if($F("btnAdd2") == "Add"){
				tbgEomRepDtl.addBottomRow(repDtl);
			} else {
				tbgEomRepDtl.updateVisibleRowOnly(repDtl, rowIndex, false);
			}
			changeTag = 1;
			setFieldValuesDtl(null);
			tbgEomRepDtl.keys.removeFocus(tbgEomRepDtl.keys._nCurrentFocus, true);
			tbgEomRepDtl.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.repCd = escapeHTML2($F("txtRepCd"));
			obj.glAcctId = $F("hidGlAcctId");
			obj.glAcctName = escapeHTML2($F("txtGlAcctName"));
			obj.glAcctCategory = $F("txtGlAcctCategory");
			obj.glControlAcct = $F("txtGlControlAcct");
			obj.glSubAcct1 = $F("txtGlSubAcct1");
			obj.glSubAcct2 = $F("txtGlSubAcct2");
			obj.glSubAcct3 = $F("txtGlSubAcct3");
			obj.glSubAcct4 = $F("txtGlSubAcct4");
			obj.glSubAcct5 = $F("txtGlSubAcct5");
			obj.glSubAcct6 = $F("txtGlSubAcct6");
			obj.glSubAcct7 = $F("txtGlSubAcct7");
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function deleteRec(){
		changeTagFunc = saveGiacs351;
		objCurrEomRepDtl.recordStatus = -1;
		tbgEomRepDtl.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValuesDtl(null);
	}
	
	function saveGiacs351(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgEomRepDtl.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgEomRepDtl.geniisysRows);
        
		new Ajax.Request(contextPath+"/GIACEomRepController", {
			method: "POST",
			parameters : {action : "saveGiacs351",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIACS351.exitPage != null) {
							objGIACS351.exitPage();
						} else if(objGIACS351.enterQuery != null){
							changeTag = 0;
							objGIACS351.enterQuery();
						} else {
							tbgEomRepDtl._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	$("btnToolbarExecuteQuery").observe("click", executeQuery);
	$("btnToolbarEnterQuery").observe("click", enterQuery);	
	$("btnCancel").observe("click", cancelGiacs351);
	$("btnAdd2").observe("click", valAddRec);
	$("btnDelete2").observe("click", deleteRec);
	observeSaveForm("btnSave", saveGiacs351);
	observeSaveForm("btnToolbarSave", saveGiacs351);
	
	observeReloadForm("reloadForm", function(){
		showGiacs351('${callFrom}', '${repCd}');
	});
	
	$("btnToolbarExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	/* $("txtGlAcctCategory").setAttribute("lastValidValue", "");
	$("txtGlAcctCategory").observe("change", function(){
		whenValidateItemGL($("txtGlAcctCategory"), "1");
	});
	
	$("txtGlControlAcct").setAttribute("lastValidValue", "");
	$("txtGlControlAcct").observe("change", function(){
		whenValidateItemGL($("txtGlControlAcct"), "2");
	});
	
	$("txtGlSubAcct1").setAttribute("lastValidValue", "");
	$("txtGlSubAcct1").observe("change", function(){
		whenValidateItemGL($("txtGlSubAcct1"), "2");
	});
	
	$("txtGlSubAcct2").setAttribute("lastValidValue", "");
	$("txtGlSubAcct2").observe("change", function(){
		whenValidateItemGL($("txtGlSubAcct2"), "2");
	});
	
	$("txtGlSubAcct3").setAttribute("lastValidValue", "");
	$("txtGlSubAcct3").observe("change", function(){
		whenValidateItemGL($("txtGlSubAcct3"), "2");
	});
	
	$("txtGlSubAcct4").setAttribute("lastValidValue", "");
	$("txtGlSubAcct4").observe("change", function(){
		whenValidateItemGL($("txtGlSubAcct4"), "2");
	});
	
	$("txtGlSubAcct5").setAttribute("lastValidValue", "");
	$("txtGlSubAcct5").observe("change", function(){
		whenValidateItemGL($("txtGlSubAcct5"), "2");
	});
	
	$("txtGlSubAcct6").setAttribute("lastValidValue", "");
	$("txtGlSubAcct6").observe("change", function(){
		whenValidateItemGL($("txtGlSubAcct6"), "2");
	});
	
	$("txtGlSubAcct7").setAttribute("lastValidValue", "");
	$("txtGlSubAcct7").observe("change", function(){
		whenValidateItemGL($("txtGlSubAcct7"), "2");
	}); */
	
	/* function whenValidateItemGL(elemName, formatDigitTo){
		if($F("txtGlAcctCategory") != "" && $F("txtGlControlAcct") != "" && $F("txtGlSubAcct1") != "" &&
		   $F("txtGlSubAcct2") != "" && $F("txtGlSubAcct3") != "" && $F("txtGlSubAcct4") != "" && 
		   $F("txtGlSubAcct5") != "" && $F("txtGlSubAcct6") != "" && $F("txtGlSubAcct7") != ""){
		   validateGLAcctNo(elemName, formatDigitTo);
		} else {
			elemName.value = formatNumberDigits(elemName.value,formatDigitTo);
		}
		if(elemName.value != ""){
			elemName.value = formatNumberDigits(elemName.value,formatDigitTo);	
		}
	} */
	
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
						showGiacs351GlAcctLov();
					}else{
						$("txtGlAcctName").clear();
					}
				});
			});	
	
	/* function validateGLAcctNo(elemName, formatDigitTo){
		new Ajax.Request(contextPath+"/GIACEomRepController?action=validateGLAcctNo",{
			parameters: {
				glAcctCategory : $F("txtGlAcctCategory"),
				glAcctControlAcct : $F("txtGlControlAcct"),
				glSubAcct1 : $F("txtGlSubAcct1"),
				glSubAcct2 : $F("txtGlSubAcct2"),
				glSubAcct3 : $F("txtGlSubAcct3"),
				glSubAcct4 : $F("txtGlSubAcct4"),
				glSubAcct5 : $F("txtGlSubAcct5"),
				glSubAcct6 : $F("txtGlSubAcct6"),
				glSubAcct7 : $F("txtGlSubAcct7"),
			},
			onCreate : showNotice("Validating, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					elemName.value = formatNumberDigits(elemName.value, formatDigitTo);
					showGiacs351GlAcctLov();
				} else {
					if($F("txtGlAcctName") != ""){
						//setLastValidValue();
						readLastValidValue();
					} else {
						clearGLAcctNo();	
					}
				}
			}
		});
	} */
	
	$("searchGLAcctNoLov").observe("click", showGiacs351GlAcctLov);
	
	function showGiacs351GlAcctLov(){
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
			controller: "AccountingLOVController",
			urlParameters: {action: "getGiacs351GlAcctLov",
							filterText : ($F("hidGlAccountCode").trim() != concatGl ? concatGl : "")
						},
			title: "List of GL Account Codes",
			hideColumnChildTitle: true,
			width: 800,
			height: 403,
			columnModel : [
			               {
			            	   id : 'glAcctCategory glControlAcct glSubAcct1 glSubAcct2 glSubAcct3 glSubAcct4 glSubAcct5 glSubAcct6 glSubAcct7',
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
	
	function readLastValidValue(){
		$("hidGlAcctId").value = $("hidGlAcctId").readAttribute("lastValidValue");
		$("txtGlAcctCategory").value = $("txtGlAcctCategory").readAttribute("lastValidValue");
		$("txtGlControlAcct").value = $("txtGlControlAcct").readAttribute("lastValidValue");
		$("txtGlSubAcct1").value = $("txtGlSubAcct1").readAttribute("lastValidValue");
		$("txtGlSubAcct2").value = $("txtGlSubAcct2").readAttribute("lastValidValue");
		$("txtGlSubAcct3").value = $("txtGlSubAcct3").readAttribute("lastValidValue");
		$("txtGlSubAcct4").value = $("txtGlSubAcct4").readAttribute("lastValidValue");
		$("txtGlSubAcct5").value = $("txtGlSubAcct5").readAttribute("lastValidValue");
		$("txtGlSubAcct6").value = $("txtGlSubAcct6").readAttribute("lastValidValue");
		$("txtGlSubAcct7").value = $("txtGlSubAcct7").readAttribute("lastValidValue");
		$("txtGlAcctName").value = $("txtGlAcctName").readAttribute("lastValidValue");
	}
	
	function clearGLAcctNo(){
		$("txtGlAcctCategory").clear();
		$("txtGlControlAcct").clear();
		$("txtGlSubAcct1").clear();
		$("txtGlSubAcct2").clear();
		$("txtGlSubAcct3").clear();
		$("txtGlSubAcct4").clear();
		$("txtGlSubAcct5").clear();
		$("txtGlSubAcct6").clear();
		$("txtGlSubAcct7").clear();
		$("txtGlAcctName").clear();
		
		$("txtGlAcctCategory").setAttribute("lastValidValue", "");
		$("txtGlControlAcct").setAttribute("lastValidValue", "");
		$("txtGlSubAcct1").setAttribute("lastValidValue", "");
		$("txtGlSubAcct2").setAttribute("lastValidValue", "");
		$("txtGlSubAcct3").setAttribute("lastValidValue", "");
		$("txtGlSubAcct4").setAttribute("lastValidValue", "");
		$("txtGlSubAcct5").setAttribute("lastValidValue", "");
		$("txtGlSubAcct6").setAttribute("lastValidValue", "");
		$("txtGlSubAcct7").setAttribute("lastValidValue", "");
		$("txtGlAcctName").setAttribute("lastValidValue", "");
	}
	
	function whenNewFormInstance(){
		if($F("hidCallFrom") == "GIACS350"){
			setForm(true);
			disableSearch("imgSearchRep");
			$("txtRepCd").readOnly = true;
			tbgEomRepDtl.url = contextPath + "/GIACEomRepController?action=showGiacs351&refresh=1&repCd=" + encodeURIComponent('${repCd}')
			+ "&callFrom=" + ($F("hidCallFrom"));
			//tbgEomRepDtl._refreshList();
		}
	}
	
	$("txtRepCd").focus();
	whenNewFormInstance();
</script>
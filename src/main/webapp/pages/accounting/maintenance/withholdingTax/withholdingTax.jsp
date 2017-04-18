<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<script type="text/javascript">
	$("smoothmenu1").hide();
</script>
<jsp:include page="/pages/toolbar.jsp"></jsp:include>
<div id="giacs318MainDiv" name="giacs318MainDiv" style="">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   	<label>Withholding Tax Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giacs318" name="giacs318">
		<div class="sectionDiv" id="giacs318">
			<div style="" align="center">
				<table cellspacing="3" border="0" style="margin: 10px auto;">	 			
					<tr>
						<td class="rightAligned" style="" id="">Company</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan required" style="float: left; width: 65px; margin-right: 5px; margin-top: 2px; height: 19px;">
								<input class="required" type="text" id="txtFundCd" name="txtFundCd" style="width: 40px; float: left; border: none; height: 13px; margin: 0;" maxlength="3" tabindex="101" lastValidValue="" ignoreDelKey="1"/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchFundCd" name="imgSearchFundCd" alt="Go" style="float: right;" tabindex="102"/>
							</span>
							<input id="txtFundDesc" name="txtFundDesc" type="text" style="width: 280px;" value="" readonly="readonly" tabindex="103"/>
						</td>
						<td class="rightAligned" style="width: 65px;" id="">Branch</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan required" style="float: left; width: 65px; margin-right: 5px; margin-top: 2px; height: 19px;">
								<input class="required" type="text" id="txtBranchCd" name="txtBranchCd" style="width: 40px; float: left; border: none; height: 13px; margin: 0;" maxlength="2" tabindex="104" lastValidValue="" ignoreDelKey="1"/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchBranchCd" name="imgSearchBranchCd" alt="Go" style="float: right;" tabindex="105"/>
							</span>
							<input id="txtBranchName" name="txtBranchName" type="text" style="width: 280px;" value="" readonly="readonly" tabindex="106"/>
						</td>
					</tr>
				</table>			
			</div>		
		</div>
		<div class="sectionDiv">
			<div id="wholdingTaxTableDiv" style="padding-top: 10px;">
				<div id="wholdingTaxTable" style="height: 335px; margin-left: 10px;"></div>
			</div>
			<div align="center" id="whtaxFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Code</td>
						<td class="leftAligned">
							<input id="hidWhtaxId" type="hidden" class="" style="width: 200px;">
							<input id="txtWhtaxCode" type="text" class="required integerNoNegativeUnformattedNoComma" style="width: 200px; text-align: right;" tabindex="201" maxlength="2">
							<input id="txtOrigWhtaxCode" type="hidden">
						</td>
						<td class="rightAligned">BIR Code</td>
						<td width="150" class="leftAligned">
							<input id="txtBirTaxCd" class="required" type="text" style="width: 200px;" tabindex="202" maxlength="10"></td>
						<td class="leftAligned"></td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Withholding Tax Name</td>
						<td class="leftAligned" colspan="3">
							<input id="txtWhtaxDesc" type="text" class="required" style="width: 570px;" tabindex="203" maxlength="100">
						</td>
					</tr>	
					<tr>
						<td class="rightAligned">Ind. / Corp. Tag</td>
						<td class="leftAligned">
							<select id="selIndCorpTag" class="required" style="width: 204px; height: 24px;">
								<option value=""></option>
								<option value="I">I</option>
								<option value="C">C</option>
							</select>
						</td>
						<td class="rightAligned">Tax Rate</td>
						<td width="150" class="leftAligned">
							<input id="txtPercentRate" class="required" type="text" style="width: 200px; text-align: right;" tabindex="207" maxlength="6">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Start Date</td>
						<td class="leftAligned">
							<div style="float: left; width: 206px; height: 22px; margin: 0px;" class="withIconDiv required">
								<input type="text" id="txtStartDt" name="txtStartDt" class="withIcon required" readonly="readonly" style="width: 180px; height: 15px;" tabindex="205"/>
								<img id="hrefStartDt" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Go" tabindex="206"/>
							</div>
						</td>
						<td class="rightAligned">End Date</td>
						<td width="" class="leftAligned">
							<div style="float: left; width: 206px; height: 22px; margin: 0px;" class="withIconDiv">
								<input type="text" id="txtEndDt" name="txtEndDt" class="withIcon" readonly="readonly" style="width: 180px; height: 15px;" tabindex="208"/>
								<img id="hrefEndDt" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Go" tabindex="209"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="">GL Account Code</td>
						<td class="leftAligned" style="" colspan="3">
							<div id="glCodeDiv" style="float: left;">
								<input type="hidden" id="hidGlAcctId">
								<input type="hidden" id="hidGlAccountCode">
								<input type="text" style="width: 24px; text-align: right;" id="txtDspGlAcctCategory" 	name="glAccountCode" value="" class="required glAC integerNoNegativeUnformattedNoComma" regExpPatt="pDigit01" maxlength="1" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="9" customLabel="GL Account Category" tabindex=210/>
								<input type="text" style="width: 24px; text-align: right;" id="txtDspGlControlAcct" 	name="glAccountCode" 	value="" class="required glAC integerNoNegativeUnformattedNoComma" lpad="2" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Control Account" tabindex=211/>
								<input type="text" style="width: 24px; text-align: right;" id="txtDspGlSubAcct1" 		name="glAccountCode" 	value="" class="required glAC integerNoNegativeUnformattedNoComma" lpad="2" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Sub Account 1" tabindex=212/>
								<input type="text" style="width: 24px; text-align: right;" id="txtDspGlSubAcct2" 		name="glAccountCode"	value="" class="required glAC integerNoNegativeUnformattedNoComma" lpad="2" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Sub Account 2" tabindex=213/>
								<input type="text" style="width: 24px; text-align: right;" id="txtDspGlSubAcct3"		name="glAccountCode" 	value="" class="required glAC integerNoNegativeUnformattedNoComma" lpad="2" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Sub Account 3" tabindex=214/>
								<input type="text" style="width: 24px; text-align: right;" id="txtDspGlSubAcct4"		name="glAccountCode" 	value="" class="required glAC integerNoNegativeUnformattedNoComma" lpad="2" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Sub Account 4" tabindex=215/>
								<input type="text" style="width: 24px; text-align: right;" id="txtDspGlSubAcct5"		name="glAccountCode" 	value="" class="required glAC integerNoNegativeUnformattedNoComma" lpad="2" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Sub Account 5" tabindex=216/>
								<input type="text" style="width: 24px; text-align: right;" id="txtDspGlSubAcct6"		name="glAccountCode" 	value="" class="required glAC integerNoNegativeUnformattedNoComma" lpad="2" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Sub Account 6" tabindex=217/>
								<input type="text" style="width: 24px; text-align: right;" id="txtDspGlSubAcct7"		name="glAccountCode" 	value="" class="required glAC integerNoNegativeUnformattedNoComma" lpad="2" maxlength="2" hasOwnChange="Y" hasOwnBlur="Y" min="0" max="99" customLabel="GL Sub Account 7" tabindex=218/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchGl" name="imgSearchGl" alt="Search" style="margin-left: 3px; cursor: pointer;" tabindex="219"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="">SL Code</td>
						<td class="leftAligned" style="" colspan="3">
							<input type="text" id="txtSlTypeCd" name="txtSlTypeCd" style="width: 40px;" maxlength="4" tabindex="220" lastValidValue="" readonly="readonly"/>
							<input id="txtDspSlTypeName" name="txtDspSlTypeName" type="text" style="width: 283px;" value="" readonly="readonly" tabindex="221"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned" style="">Account Name</td>
						<td class="leftAligned" style="" colspan="3">
							<input type="text" style="width: 570px;" id="txtDspGlAcctName" name="txtDspGlAcctName" value="" class="" readonly="readonly" tabindex=222/>
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 576px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 550px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="223"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="224"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="225"></td>
						<td width="" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="226"></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 10px;">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="227">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="228">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="229">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="230">
</div>
<script type="text/javascript">	
	hideToolbarButton("btnToolbarPrint");
	showToolbarButton("btnToolbarSave");
	disableToolbarButton("btnToolbarExecuteQuery");
	disableToolbarButton("btnToolbarEnterQuery");
	$("txtBranchCd").readOnly = true;
	disableSearch("imgSearchBranchCd");
	setForm(false);
	setModuleId("GIACS318");
	setDocumentTitle("Withholding Tax Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	var allRecObj = {};
	
	function saveGiacs318(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgWholdingTax.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgWholdingTax.geniisysRows);
		new Ajax.Request(contextPath+"/GIACWholdingTaxController", {
			method: "POST",
			parameters : {action : "saveGiacs318",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						changeTagFunc = "";
						if(objGIACS318.exitPage != null) {
							objGIACS318.exitPage();
						} else {
							tbgWholdingTax._refreshList();
						}
					});
					changeTag = 0;					
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGiacs318);
	
	var objGIACS318 = {};
	var objCurrWhtax = null;
	objGIACS318.exitPage = null;
	
	var wholdingTaxTable = {
			url : contextPath + "/GIACWholdingTaxController?action=showGiacs318&refresh=1&fundCd=&branchCd=",
			options : {
				width : '900px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrWhtax = tbgWholdingTax.geniisysRows[y];
					setFieldValues(objCurrWhtax);
					tbgWholdingTax.keys.removeFocus(tbgWholdingTax.keys._nCurrentFocus, true);
					tbgWholdingTax.keys.releaseKeys();
					$("txtBirTaxCd").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgWholdingTax.keys.removeFocus(tbgWholdingTax.keys._nCurrentFocus, true);
					tbgWholdingTax.keys.releaseKeys();
					$("txtWhtaxCode").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgWholdingTax.keys.removeFocus(tbgWholdingTax.keys._nCurrentFocus, true);
						tbgWholdingTax.keys.releaseKeys();
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
					tbgWholdingTax.keys.removeFocus(tbgWholdingTax.keys._nCurrentFocus, true);
					tbgWholdingTax.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgWholdingTax.keys.removeFocus(tbgWholdingTax.keys._nCurrentFocus, true);
					tbgWholdingTax.keys.releaseKeys();
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
					tbgWholdingTax.keys.removeFocus(tbgWholdingTax.keys._nCurrentFocus, true);
					tbgWholdingTax.keys.releaseKeys();
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
					id : "whtaxCode",
					title : "Code",
					filterOption : true,
					filterOptionType : 'integerNoNegative',
					width : '80px',
					align : 'right',
					titleAlign : 'right',
					renderer : function(value){
						return formatNumberDigits(value, 2);
					}
				},
				{
					id : 'birTaxCd',
					filterOption : true,
					title : 'BIR Code',
					width : '120px'				
				},
				{
					id : 'whtaxDesc',
					filterOption : true,
					title : 'Withholding Tax Name',
					width : '450px'				
				},
				{
					id : 'indCorpTag',
					filterOption : true,
					title : 'I/C',
					titleAlign : 'center',
					width : '30px',
					align : 'center',
					altTitle : 'Ind. / Corp. Tag'
				},
				{
					id : 'percentRate',
					filterOption : true,
					title : 'Tax Rate',
					align : 'right',
					titleAlign : 'right',					
					width : '120px',
					filterOptionType : 'numberNoNegative',
					renderer : function(value){
						return formatToNthDecimal(value, 3);
					}
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
					id : 'gibrGfunFundCd',
					width : '0',
					visible: false				
				},
				{
					id : 'gibrBranchCd',
					width : '0',
					visible: false				
				},
				{
					id : 'startDt',
					width : '0',
					visible: false				
				},
				{
					id : 'endDt',
					width : '0',
					visible: false				
				},
				{
					id : 'whtaxId',
					width : '0',
					visible: false				
				},
				{
					id : 'slTypeCd',
					width : '0',
					visible: false				
				},
				{
					id : 'dspSlTypeName',
					width : '0',
					visible: false				
				},
				{
					id : 'glAcctId',
					width : '0',
					visible: false				
				},
				{
					id : 'dspGlAcctCategory',
					width : '0',
					visible: false				
				},
				{
					id : 'dspGlSubAcct1',
					width : '0',
					visible: false				
				},
				{
					id : 'dspGlSubAcct2',
					width : '0',
					visible: false				
				},
				{
					id : 'dspGlSubAcct3',
					width : '0',
					visible: false				
				},
				{
					id : 'dspGlSubAcct4',
					width : '0',
					visible: false				
				},
				{
					id : 'dspGlSubAcct5',
					width : '0',
					visible: false
				},
				{
					id : 'dspGlSubAcct6',
					width : '0',
					visible: false
				},
				{
					id : 'dspGlSubAcct7',
					width : '0',
					visible: false
				},
				{
					id : 'dspGlAcctName',
					width : '0',
					visible: false		
				}
			],
			rows : []//objGIACS303.department.rows
		};

		tbgWholdingTax = new MyTableGrid(wholdingTaxTable);
		//tbgWholdingTax.pager = objGIACS318.department;
		tbgWholdingTax.render("wholdingTaxTable");
		tbgWholdingTax.afterRender = function(){
     		allRecObj = getAllRecord();				
		};
		
	function executeQuery(){
		if($F("txtFundCd").trim() != "" && $F("txtBranchCd").trim() != "") {
			tbgWholdingTax.url = contextPath + "/GIACWholdingTaxController?action=showGiacs318&refresh=1&fundCd="+encodeURIComponent($F("txtFundCd"))+"&branchCd="+encodeURIComponent($F("txtBranchCd"));
			tbgWholdingTax._refreshList();
			setForm(true);
			disableToolbarButton("btnToolbarExecuteQuery");			
			$("txtFundCd").readOnly = true;
			$("txtBranchCd").readOnly = true;
			disableSearch("imgSearchFundCd");
			disableSearch("imgSearchBranchCd");
			$("txtWhtaxCode").focus();
		}
	}
	
	function enterQuery(){
		function proceedEnterQuery(){
			if($F("txtFundCd").trim() != "" || $F("txtBranchCd").trim() != "") {
				disableToolbarButton("btnToolbarExecuteQuery");
				disableToolbarButton("btnToolbarEnterQuery");
				$("txtFundCd").value = "";
				$("txtFundCd").setAttribute("lastValidValue", "");
				$("txtBranchCd").value = "";
				$("txtBranchCd").setAttribute("lastValidValue", "");
				$("txtFundDesc").value = "";
				$("txtBranchName").value = "";
				$("txtFundCd").readOnly = false;
				enableSearch("imgSearchFundCd");
				tbgWholdingTax.url = contextPath + "/GIACWholdingTaxController?action=showGiacs318&refresh=1&fundCd="+$F("txtFundCd")+"&branchCd="+$F("txtBranchCd");
				tbgWholdingTax._refreshList();
				setFieldValues(null);
				$("txtFundCd").focus();
				setForm(false);
			}
		}
		
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveGiacs318();
						proceedEnterQuery();
					}, function(){
						proceedEnterQuery();
						changeTag = 0;
					}, "");
		} else {
			proceedEnterQuery();
		}		
	}
	
	function getAllRecord() {
		try {
			var objReturn = {};
			new Ajax.Request(contextPath + "/GIACWholdingTaxController", {
				parameters : {action : "showAllGiacs318",
					          fundCd: $F("txtFundCd"),
					          branchCd: $F("txtBranchCd")},
			    asynchronous: false,
				evalScripts: true,
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						var obj = {};
						obj = JSON.parse(response.responseText.replace(/\\\\/g, '\\'));
						objReturn = obj.rows;
					}
				}
			});
			return objReturn;
		} catch (e) {
			showErrorMessage("getAllRecord",e);
		}
	}
	
	function setForm(enable){
		if(enable){
			$("txtWhtaxCode").readOnly = false;
			$("txtWhtaxDesc").readOnly = false;
			$("txtRemarks").readOnly = false;
			$("txtBirTaxCd").readOnly = false;
			$("txtPercentRate").readOnly = false;
			$("txtDspGlAcctCategory").readOnly = false;
			$("txtDspGlControlAcct").readOnly = false;
			$("txtDspGlSubAcct1").readOnly = false;
			$("txtDspGlSubAcct2").readOnly = false;
			$("txtDspGlSubAcct3").readOnly = false;
			$("txtDspGlSubAcct4").readOnly = false;
			$("txtDspGlSubAcct5").readOnly = false;
			$("txtDspGlSubAcct6").readOnly = false;
			$("txtDspGlSubAcct7").readOnly = false;
			$("selIndCorpTag").disabled = false;
			enableDate("hrefStartDt");
			enableDate("hrefEndDt");
			enableSearch("imgSearchGl");
			enableButton("btnAdd");
		} else {
			$("txtWhtaxCode").readOnly = true;
			$("txtWhtaxDesc").readOnly = true;
			$("txtRemarks").readOnly = true;
			$("txtBirTaxCd").readOnly = true;
			$("txtPercentRate").readOnly = true;
			$("txtDspGlAcctCategory").readOnly = true;
			$("txtDspGlControlAcct").readOnly = true;
			$("txtDspGlSubAcct1").readOnly = true;
			$("txtDspGlSubAcct2").readOnly = true;
			$("txtDspGlSubAcct3").readOnly = true;
			$("txtDspGlSubAcct4").readOnly = true;
			$("txtDspGlSubAcct5").readOnly = true;
			$("txtDspGlSubAcct6").readOnly = true;
			$("txtDspGlSubAcct7").readOnly = true;
			$("selIndCorpTag").disabled = true;
			disableDate("hrefStartDt");
			disableDate("hrefEndDt");
			disableSearch("imgSearchGl");
			disableButton("btnAdd");
			disableButton("btnDelete");
		}
	}
	
	function setFieldValues(rec){
		try{
			$("hidWhtaxId").value = (rec == null ? "" : rec.whtaxId);
			$("txtWhtaxCode").value = (rec == null ? "" : formatNumberDigits(rec.whtaxCode, 2));
			$("txtOrigWhtaxCode").value = (rec == null ? "" : formatNumberDigits(rec.whtaxCode, 2));			
			$("txtWhtaxCode").setAttribute("lastValidValue", (rec == null ? "" : rec.whtaxCode));
			$("txtWhtaxDesc").value = (rec == null ? "" : unescapeHTML2(rec.whtaxDesc));
			$("txtBirTaxCd").value = (rec == null ? "" : unescapeHTML2(rec.birTaxCd));
			$("txtPercentRate").value = (rec == null ? "" : formatToNthDecimal(rec.percentRate, 3));
			$("txtPercentRate").setAttribute("lastValidValue", (rec == null ? "" : formatToNthDecimal(rec.percentRate, 3)));
			$("txtStartDt").value = (rec == null ? "" : rec.startDt);
			$("txtEndDt").value = (rec == null ? "" : rec.endDt);
			$("txtSlTypeCd").value = (rec == null ? "" : rec.slTypeCd);
			$("txtDspSlTypeName").value = (rec == null ? "" : unescapeHTML2(rec.dspSlTypeName));
			$("hidGlAcctId").value = (rec == null ? "" : rec.glAcctId);
						
			$("txtDspGlAcctName").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.dspGlAcctName)));
			$("hidGlAccountCode").value = (rec == null ? "" : rec.dspGlAcctCategory +
															  formatNumberDigits(rec.dspGlControlAcct, 2) +
															  formatNumberDigits(rec.dspGlSubAcct1, 2) +
															  formatNumberDigits(rec.dspGlSubAcct2, 2) +
															  formatNumberDigits(rec.dspGlSubAcct3, 2) +
															  formatNumberDigits(rec.dspGlSubAcct4, 2) +
															  formatNumberDigits(rec.dspGlSubAcct5, 2) +
															  formatNumberDigits(rec.dspGlSubAcct6, 2) +
															  formatNumberDigits(rec.dspGlSubAcct7, 2));
			
			$("txtDspGlAcctCategory").value = (rec == null ? "" : rec.dspGlAcctCategory);
			$("txtDspGlControlAcct").value = (rec == null ? "" : formatNumberDigits(rec.dspGlControlAcct, 2));
			$("txtDspGlSubAcct1").value = (rec == null ? "" : formatNumberDigits(rec.dspGlSubAcct1, 2));
			$("txtDspGlSubAcct2").value = (rec == null ? "" : formatNumberDigits(rec.dspGlSubAcct2, 2));
			$("txtDspGlSubAcct3").value = (rec == null ? "" : formatNumberDigits(rec.dspGlSubAcct3, 2));
			$("txtDspGlSubAcct4").value = (rec == null ? "" : formatNumberDigits(rec.dspGlSubAcct4, 2));
			$("txtDspGlSubAcct5").value = (rec == null ? "" : formatNumberDigits(rec.dspGlSubAcct5, 2));
			$("txtDspGlSubAcct6").value = (rec == null ? "" : formatNumberDigits(rec.dspGlSubAcct6, 2));
			$("txtDspGlSubAcct7").value = (rec == null ? "" : formatNumberDigits(rec.dspGlSubAcct7, 2));
			$("txtDspGlAcctName").value = (rec == null ? "" : unescapeHTML2(rec.dspGlAcctName));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("selIndCorpTag").value = (rec == null ? "" : rec.indCorpTag);
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			rec == null ? $("txtWhtaxCode").readOnly = false : $("txtWhtaxCode").readOnly = true;
			objCurrWhtax = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.whtaxId = (rec == null ? null : $F("hidWhtaxId"));
			obj.gibrGfunFundCd = escapeHTML2($F("txtFundCd"));
			obj.gibrBranchCd = escapeHTML2($F("txtBranchCd"));
			obj.whtaxCode = $F("txtWhtaxCode");
			obj.whtaxDesc = escapeHTML2($F("txtWhtaxDesc"));
			obj.birTaxCd = escapeHTML2($F("txtBirTaxCd"));
			obj.indCorpTag = $F("selIndCorpTag");
			obj.percentRate = $F("txtPercentRate");
			obj.startDt = $F("txtStartDt");
			obj.endDt = ($F("txtEndDt") == "" ? null : $F("txtEndDt"));
			obj.glAcctId = $F("hidGlAcctId");
			obj.slTypeCd = $F("txtSlTypeCd");
			obj.dspSlTypeName = escapeHTML2($F("txtDspSlTypeName"));
			obj.dspGlAcctCategory = $F("txtDspGlAcctCategory");
			obj.dspGlControlAcct = $F("txtDspGlControlAcct");
			obj.dspGlSubAcct1 = $F("txtDspGlSubAcct1");
			obj.dspGlSubAcct2 = $F("txtDspGlSubAcct2");
			obj.dspGlSubAcct3 = $F("txtDspGlSubAcct3");
			obj.dspGlSubAcct4 = $F("txtDspGlSubAcct4");
			obj.dspGlSubAcct5 = $F("txtDspGlSubAcct5");
			obj.dspGlSubAcct6 = $F("txtDspGlSubAcct6");
			obj.dspGlSubAcct7 = $F("txtDspGlSubAcct7");
			obj.dspGlAcctName = escapeHTML2($F("txtDspGlAcctName"));
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.userId = escapeHTML2(userId);
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function valAddRec() {
		try {
			if (checkAllRequiredFieldsInDiv("whtaxFormDiv")) {
				for(var i=0; i<allRecObj.length; i++){
					if(allRecObj[i].recordStatus != -1 ){
						if ($F("btnAdd") == "Add") {
							if(allRecObj[i].whtaxCode == $F("txtWhtaxCode")){
								showMessageBox("Record already exists with the same whtax_code.", "E");
								return;
							}
						} 
					} 
				}
				addRec();					
			}
		} catch (e) {
			showErrorMessage("valAddRec", e);
		}
	}
	
	function addRec(){			
		try {		
			var whtax = setRec(objCurrWhtax);
			var newObj = setRec(null);			
			if($F("btnAdd") == "Add"){
				tbgWholdingTax.addBottomRow(whtax);
				newObj.recordStatus = 0;
				allRecObj.push(newObj);
			} else {
				tbgWholdingTax.updateVisibleRowOnly(whtax, rowIndex, false);
				for(var i = 0; i<allRecObj.length; i++){
					if ((allRecObj[i].whtaxCode == newObj.whtaxCode)&&(allRecObj[i].recordStatus != -1)){
						newObj.recordStatus = 1;
						allRecObj.splice(i, 1, newObj);
					}
				}
			}
			changeTag = 1;
			changeTagFunc = saveGiacs318;
			setFieldValues(null);
			tbgWholdingTax.keys.removeFocus(tbgWholdingTax.keys._nCurrentFocus, true);
			tbgWholdingTax.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function deleteWhtax(){
		objCurrWhtax.recordStatus = -1;
		var newObj = setRec(null);
		tbgWholdingTax.deleteRow(rowIndex);
		changeTag = 1;
		changeTagFunc = saveGiacs318;
		setFieldValues(null);				
		for(var i = 0; i<allRecObj.length; i++){
			if ((allRecObj[i].whtaxCode == unescapeHTML2(newObj.whtaxCode))&&(allRecObj[i].recordStatus != -1)){
				newObj.recordStatus = -1;
				allRecObj.splice(i, 1, newObj);
			}
		}
	}
	
	function valDeleteWhtax(){
		try{
			new Ajax.Request(contextPath + "/GIACWholdingTaxController", {
				parameters : {action : "valDeleteWhtax",
							  whtaxId : $F("hidWhtaxId")},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						deleteWhtax();
					}
				}
			});
		} catch(e){
			showErrorMessage("valDeleteWhtax", e);
		}
	}
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
	}	
	
	function cancelGiacs318(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIACS318.exitPage = exitPage;
						saveGiacs318();
					}, function(){
						goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		}
	}
	
	function showGIACS318FundLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : "getFundLOV3",
							moduleId :  "GIACS318",
							filterText : ($("txtFundCd").readAttribute("lastValidValue").trim() != $F("txtFundCd").trim() ? $F("txtFundCd").trim() : ""),
							page : 1},
			title: "List of Companies",
			width: 450,
			height: 400,
			columnModel : [ {
								id: "fundCd",
								title: "Company Code",
								width : '100px',
							}, {
								id : "fundDesc",
								title : "Company Name",
								width : '335px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							} ],
				autoSelectOneRecord: true,
				filterText : ($("txtFundCd").readAttribute("lastValidValue").trim() != $F("txtFundCd").trim() ? escapeHTML2($F("txtFundCd").trim()) : ""),
				onSelect: function(row) {
					if($F("txtBranchCd").trim() != ""){
						enableToolbarButton("btnToolbarExecuteQuery");
					}					
					enableToolbarButton("btnToolbarEnterQuery");						
					$("txtFundCd").value = unescapeHTML2(row.fundCd);
					$("txtFundDesc").value = unescapeHTML2(row.fundDesc);
					$("txtFundCd").setAttribute("lastValidValue", unescapeHTML2(row.fundCd));
					$("txtBranchCd").readOnly = false;
					enableSearch("imgSearchBranchCd");
					$("txtBranchCd").value = "";
					$("txtBranchName").value = "";
					$("txtBranchCd").setAttribute("lastValidValue", "");
					$("txtBranchCd").focus();
				},
				onCancel: function (){
					$("txtFundCd").value = $("txtFundCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtFundCd").value = $("txtFundCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	function showGIACS318BranchLOV(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : "getGIACBranchLOV",
							gfunFundCd : $F("txtFundCd"),
							moduleId :  "GIACS318",
							filterText : ($("txtBranchCd").readAttribute("lastValidValue").trim() != $F("txtBranchCd").trim() ? $F("txtBranchCd").trim() : ""),
							page : 1},
			title: "List of Branches",
			width: 400,
			height: 400,
			columnModel : [
							{
								id : "branchCd",
								title: "Branch Code",
								width: '100px',
								filterOption: true
							},
							{
								id : "branchName",
								title: "Branch Name",
								width: '285px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("txtBranchCd").readAttribute("lastValidValue").trim() != $F("txtBranchCd").trim() ? escapeHTML2($F("txtBranchCd").trim()) : ""),
				onSelect: function(row) {
					if($F("txtFundCd").trim() != ""){
						enableToolbarButton("btnToolbarExecuteQuery");
					}
					$("txtBranchCd").value = unescapeHTML2(row.branchCd);
					$("txtBranchName").value = unescapeHTML2(row.branchName);
					$("txtBranchCd").setAttribute("lastValidValue", unescapeHTML2(row.branchCd));								
				},
				onCancel: function (){
					$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	function showAccountCodeLOV(){
		var concatGl = ($F("txtDspGlAcctCategory").trim() == "" ? "": $F("txtDspGlAcctCategory")) +
		($F("txtDspGlControlAcct").trim() == "" ? "": formatNumberDigits($F("txtDspGlControlAcct"), 2)) +
		($F("txtDspGlSubAcct1").trim() == "" ? "": formatNumberDigits($F("txtDspGlSubAcct1"), 2)) +
		($F("txtDspGlSubAcct2").trim() == "" ? "": formatNumberDigits($F("txtDspGlSubAcct2"), 2)) +
		($F("txtDspGlSubAcct3").trim() == "" ? "": formatNumberDigits($F("txtDspGlSubAcct3"), 2)) +
		($F("txtDspGlSubAcct4").trim() == "" ? "": formatNumberDigits($F("txtDspGlSubAcct4"), 2)) +
		($F("txtDspGlSubAcct5").trim() == "" ? "": formatNumberDigits($F("txtDspGlSubAcct5"), 2)) +
		($F("txtDspGlSubAcct6").trim() == "" ? "": formatNumberDigits($F("txtDspGlSubAcct6"), 2)) +
		($F("txtDspGlSubAcct7").trim() == "" ? "": formatNumberDigits($F("txtDspGlSubAcct7"), 2));
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action: "getGiacs318GlAcctCodeLOV",
							filterText : ($F("hidGlAccountCode").trim() != concatGl ? concatGl : "")
						//	glAcctCategory: ($("txtDspGlAcctCategory").readAttribute("lastValidValue") != $F("txtDspGlAcctCategory") ? $F("txtDspGlAcctCategory") : ""),
						//	glControlAcct: ($("txtDspGlControlAcct").readAttribute("lastValidValue") != $F("txtDspGlControlAcct") ? $F("txtDspGlControlAcct") : ""),
						//	glSubAcct1: ($("txtDspGlSubAcct1").readAttribute("lastValidValue") != $F("txtDspGlSubAcct1") ? $F("txtDspGlSubAcct1") : ""),
						//	glSubAcct2: ($("txtDspGlSubAcct2").readAttribute("lastValidValue") != $F("txtDspGlSubAcct2") ? $F("txtDspGlSubAcct2") : ""),
						//	glSubAcct3: ($("txtDspGlSubAcct3").readAttribute("lastValidValue") != $F("txtDspGlSubAcct3") ? $F("txtDspGlSubAcct3") : ""),
						//	glSubAcct4: ($("txtDspGlSubAcct4").readAttribute("lastValidValue") != $F("txtDspGlSubAcct4") ? $F("txtDspGlSubAcct4") : ""),
						//	glSubAcct5: ($("txtDspGlSubAcct5").readAttribute("lastValidValue") != $F("txtDspGlSubAcct5") ? $F("txtDspGlSubAcct5") : ""),
						//	glSubAcct6: ($("txtDspGlSubAcct6").readAttribute("lastValidValue") != $F("txtDspGlSubAcct6") ? $F("txtDspGlSubAcct6") : ""),
						//	glSubAcct7: ($("txtDspGlSubAcct7").readAttribute("lastValidValue") != $F("txtDspGlSubAcct7") ? $F("txtDspGlSubAcct7") : "")
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
			            	   id : 'gsltSlTypeCd',
			            	   width: '0',
			            	   visible : false
			               },
			               {
			            	   id : 'glAcctId',
			            	   width: '0',
			            	   visible: false
			               }
			               /*,
			               {
			            	   id : "slCd",
			            	   width: '0',
			            	   visible:false
			               }*/
			              ],
			autoSelectOneRecord: true,
			filterText : ($F("hidGlAccountCode").trim() != concatGl ? concatGl : ""),
			draggable: true,
				onSelect: function(row) {
					try {
						$("hidGlAcctId").value = row.glAcctId;
						$("txtDspGlAcctCategory").value 	= parseInt(row.glAcctCategory);
						$("txtDspGlControlAcct").value 	= parseInt(row.glControlAcct).toPaddedString(2);
						$("txtDspGlSubAcct1").value 		= parseInt(row.glSubAcct1).toPaddedString(2);
						$("txtDspGlSubAcct2").value 		= parseInt(row.glSubAcct2).toPaddedString(2);
						$("txtDspGlSubAcct3").value 		= parseInt(row.glSubAcct3).toPaddedString(2);
						$("txtDspGlSubAcct4").value 		= parseInt(row.glSubAcct4).toPaddedString(2);
						$("txtDspGlSubAcct5").value 		= parseInt(row.glSubAcct5).toPaddedString(2);
						$("txtDspGlSubAcct6").value 		= parseInt(row.glSubAcct6).toPaddedString(2);
						$("txtDspGlSubAcct7").value 		= parseInt(row.glSubAcct7).toPaddedString(2);
						$("txtDspGlAcctName").value 		= unescapeHTML2(row.glAcctName);
						$("txtSlTypeCd").value = row.gsltSlTypeCd;
						$("txtDspSlTypeName").value = unescapeHTML2(row.dspSlTypeName);		
						
						$("txtSlTypeCd").setAttribute("lastValidValue", unescapeHTML2(row.gsltSlTypeCd));
						$("txtDspSlTypeName").setAttribute("lastValidValue", unescapeHTML2(row.dspSlTypeName));
						$("txtDspGlAcctName").setAttribute("lastValidValue", unescapeHTML2(row.glAcctName));
						$("hidGlAccountCode").value = row.glAcctCategory +
						                              parseInt(row.glControlAcct).toPaddedString(2) +
						                              parseInt(row.glSubAcct1).toPaddedString(2) +
						                              parseInt(row.glSubAcct2).toPaddedString(2) +
						                              parseInt(row.glSubAcct3).toPaddedString(2) +
						                              parseInt(row.glSubAcct4).toPaddedString(2) +
						                              parseInt(row.glSubAcct5).toPaddedString(2) +
						                              parseInt(row.glSubAcct6).toPaddedString(2) +
						                              parseInt(row.glSubAcct7).toPaddedString(2);
						
						$("txtDspGlSubAcct7").focus();
					} catch(e){
						showErrorMessage("showAccountCodeLOV - onSelect", e);
					}
				},
				onCancel: function (){
					$("txtDspGlAcctName").value = $("txtDspGlAcctName").readAttribute("lastValidValue");
					$("txtDspGlAcctCategory").value = $F("hidGlAccountCode").substring(0, 1);
					$("txtDspGlControlAcct").value = $F("hidGlAccountCode").substring(1, 3);
					$("txtDspGlSubAcct1").value = $F("hidGlAccountCode").substring(3, 5);
					$("txtDspGlSubAcct2").value = $F("hidGlAccountCode").substring(5, 7);
					$("txtDspGlSubAcct3").value = $F("hidGlAccountCode").substring(7, 9);
					$("txtDspGlSubAcct4").value = $F("hidGlAccountCode").substring(9, 11);
					$("txtDspGlSubAcct5").value = $F("hidGlAccountCode").substring(11, 13);
					$("txtDspGlSubAcct6").value = $F("hidGlAccountCode").substring(13, 15);
					$("txtDspGlSubAcct7").value = $F("hidGlAccountCode").substring(15, 17);
					$("txtDspGlAcctName").value = $("txtDspGlAcctName").readAttribute("lastValidValue");
					$("txtSlTypeCd").value = $("txtSlTypeCd").readAttribute("lastValidValue");
					$("txtDspSlTypeName").value = $("txtDspSlTypeName").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$$("txtDspGlAcctName").value = $("txtDspGlAcctName").readAttribute("lastValidValue");
					$("txtDspGlAcctCategory").value = $F("hidGlAccountCode").substring(0, 1);
					$("txtDspGlControlAcct").value = $F("hidGlAccountCode").substring(1, 3);
					$("txtDspGlSubAcct1").value = $F("hidGlAccountCode").substring(3, 5);
					$("txtDspGlSubAcct2").value = $F("hidGlAccountCode").substring(5, 7);
					$("txtDspGlSubAcct3").value = $F("hidGlAccountCode").substring(7, 9);
					$("txtDspGlSubAcct4").value = $F("hidGlAccountCode").substring(9, 11);
					$("txtDspGlSubAcct5").value = $F("hidGlAccountCode").substring(11, 13);
					$("txtDspGlSubAcct6").value = $F("hidGlAccountCode").substring(13, 15);
					$("txtDspGlSubAcct7").value = $F("hidGlAccountCode").substring(15, 17);
					$("txtDspGlAcctName").value = $("txtDspGlAcctName").readAttribute("lastValidValue");
					$("txtSlTypeCd").value = $("txtSlTypeCd").readAttribute("lastValidValue");
					$("txtDspSlTypeName").value = $("txtDspSlTypeName").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
			});
	} 
	
	$("imgSearchGl").observe("click", showAccountCodeLOV);	
	$("imgSearchFundCd").observe("click", showGIACS318FundLOV);
	$("imgSearchBranchCd").observe("click", showGIACS318BranchLOV);
	
	$("txtWhtaxCode").observe("change", function() {
		if($F("txtWhtaxCode").trim() == "") {
			$("txtWhtaxCode").value = "";
			$("txtWhtaxCode").setAttribute("lastValidValue", "");
		} else {
			if(parseInt($F("txtWhtaxCode")) < 0 || parseInt($F("txtWhtaxCode")) > 99){
				showWaitingMessageBox("Invalid Code. Valid value should be from 0 to 99.", "I", function(){
					$("txtWhtaxCode").value = formatNumberDigits($("txtWhtaxCode").readAttribute("lastValidValue"), 2);
					$("txtWhtaxCode").focus();
				});
			} else {
				$("txtWhtaxCode").setAttribute("lastValidValue", $F("txtWhtaxCode"));
				$("txtWhtaxCode").value = formatNumberDigits($F("txtWhtaxCode"), 2);
			}		
		}
	});
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
 	
	$("txtFundCd").observe("change", function() {		
		if($F("txtFundCd").trim() == "") {
			$("txtFundCd").value = "";
			$("txtFundDesc").value = "";
			$("txtFundCd").setAttribute("lastValidValue", "");
			disableToolbarButton("btnToolbarExecuteQuery");
			disableToolbarButton("btnToolbarEnterQuery");
			$("txtBranchCd").value = "";
			$("txtBranchName").value = "";
			$("txtBranchCd").setAttribute("lastValidValue", "");
			$("txtBranchCd").readOnly = true;
			disableSearch("imgSearchBranchCd");
		} else {
			if($F("txtFundCd").trim() != "" && $F("txtFundCd") != $("txtFundCd").readAttribute("lastValidValue")) {
				showGIACS318FundLOV();
			}
		}
	});
	
 	$("txtBranchCd").observe("change", function() {		
		if($F("txtBranchCd").trim() == "") {
			$("txtBranchCd").value = "";
			$("txtBranchName").value = "";
			$("txtBranchCd").setAttribute("lastValidValue", "");
			disableToolbarButton("btnToolbarExecuteQuery");
		} else {
			if($F("txtBranchCd").trim() != "" && $F("txtBranchCd") != $("txtBranchCd").readAttribute("lastValidValue")) {
				showGIACS318BranchLOV();	
			}
		}
	});	 	
 	
	$("hrefStartDt").observe("click", function() {
		if ($("hrefStartDt").disabled == true) return;
		scwShow($('txtStartDt'),this, null);
	});
 	
	$("hrefEndDt").observe("click", function() {
		if ($("hrefEndDt").disabled == true) return;
		scwShow($('txtEndDt'),this, null);
	});	
	
	$("txtStartDt").observe("focus", function(){	
		var fromDate = $F("txtStartDt") != "" ? new Date($F("txtStartDt").replace(/-/g,"/")) :"";
		var toDate = $F("txtEndDt") != "" ? new Date($F("txtEndDt").replace(/-/g,"/")) :"";
		if (toDate < fromDate && toDate != ""){
			customShowMessageBox("Start Date should not be later than End Date.", "I", "txtStartDt");
			$("txtStartDt").clear();
			return false;
		}
	});
	 	
 	$("txtEndDt").observe("focus", function(){
		var toDate = $F("txtEndDt") != "" ? new Date($F("txtEndDt").replace(/-/g,"/")) :"";
		var fromDate = $F("txtStartDt") != "" ? new Date($F("txtStartDt").replace(/-/g,"/")) :"";
		if (toDate < fromDate && toDate != ""){
			customShowMessageBox("Start Date should not be later than End Date.", "I", "txtEndDt");
			$("txtEndDt").clear();
			return false;
		}			
	});
	
	$("txtFundCd").observe("keyup", function(){
		$("txtFundCd").value = $F("txtFundCd").toUpperCase();
	});
	
	$("txtBranchCd").observe("keyup", function(){
		$("txtBranchCd").value = $F("txtBranchCd").toUpperCase();
	});

	$("txtBirTaxCd").observe("keyup", function(){
		$("txtBirTaxCd").value = $F("txtBirTaxCd").toUpperCase();
	});
	
	$("txtPercentRate").observe("change", function(){
		if($F("txtPercentRate").trim() == "") {
			$("txtPercentRate").value = "";
			$("txtPercentRate").setAttribute("lastValidValue", "");
		} else {
			if(parseInt($F("txtPercentRate")) < 0 || parseInt($F("txtPercentRate")) > 99.999){
				showWaitingMessageBox("Invalid Tax Rate. Valid value should be from 0 to 99.999", "I", function(){
					$("txtPercentRate").value = formatToNthDecimal($("txtPercentRate").readAttribute("lastValidValue"), 3);
					$("txtPercentRate").focus();
				});
			} else {				
				$("txtPercentRate").setAttribute("lastValidValue", $F("txtPercentRate"));
				$("txtPercentRate").value = formatToNthDecimal($F("txtPercentRate"), 3);
			}		
		}
	});
	
	$("txtPercentRate").observe("keyup", function(e) {		
		if(isNaN($F("txtPercentRate"))) {
			$("txtPercentRate").value = $("txtPercentRate").value.substring($("txtPercentRate").value.length-1,"");
		}		
	});

	var glCodeId = ["txtDspGlAcctCategory","txtDspGlControlAcct","txtDspGlSubAcct1","txtDspGlSubAcct2","txtDspGlSubAcct3",
	                "txtDspGlSubAcct4","txtDspGlSubAcct5","txtDspGlSubAcct6","txtDspGlSubAcct7"];
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
						showAccountCodeLOV();
					}else{
						$("txtDspGlAcctName").clear();
						$("txtSlTypeCd").clear();
						$("txtDspSlTypeName").clear();
					}
				});
			});	
	
	observeSaveForm("btnSave", saveGiacs318);
	observeSaveForm("btnToolbarSave", saveGiacs318);
	$("btnCancel").observe("click", cancelGiacs318);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteWhtax);
		
	$("btnToolbarExecuteQuery").observe("click", executeQuery);
	$("btnToolbarEnterQuery").observe("click", enterQuery);	
	$("btnToolbarExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtFundCd").focus();
</script>
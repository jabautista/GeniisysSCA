<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss219MainDiv" name="giiss219MainDiv">
	<div id="giiss219Div">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="giiss219Exit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="giiss219Block1" name="giiss219Block1">	
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
		   		<label id = "block1">Plan Maintenance</label>
		   		<span class="refreshers" style="margin-top: 0;">
		   			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
					<label id="reloadForm" name="reloadForm">Reload Form</label>
				</span>
		   	</div>
		</div>
		<div id="giiss219Block1Body" name="giiss219Block1Body">	
			<div class="sectionDiv">
				<div id="giiss219TabsMenu" style="width: 100%; float: left;">
					<div id="tabComponentsDiv1" class="tabComponents1" style="float: left;">
						<ul>
							<li class="tab1 selectedTab1"><a id="tabRegular">Regular</a></li>
							<li class="tab1"><a id="tabPackage">Package</a></li>
						</ul>
					</div>
					<div class="tabBorderBottom1"></div>		
				</div> 	
				<div id="giiss219TableDiv" style="padding-top: 50px;">
					<div id="giiss219Table" style="height: 340px; margin-left: 10px;"></div>
				</div>
				<div align="center" id="giiss219FormDiv">
					<table style="margin-top: 5px;">
						<tr>
							<td class="rightAligned">Plan Code</td>
							<td class="leftAligned" colspan="3">
								<input id="txtPlanCd" type="text" style="width: 200px; text-align: right;" tabindex="101" readonly="readonly">
							</td>
						</tr>	
						<tr>
							<td class="rightAligned">Description</td>
							<td class="leftAligned" colspan="3">
								<input id="txtPlanDesc" type="text" class="required" style="width: 533px;" tabindex="102" maxlength="50">
							</td>
						</tr>	
						<tr>
							<td class="rightAligned" id="trLineName">Line</td>
							<td class="leftAligned">
								<input id="txtLineCd" type="hidden">
								<span class="lovSpan required" style="width: 206px; margin: 0px;">
									<input type="text" id="txtLineName" ignoreDelKey="true" style="width: 180px; float: left; border: none; height: 14px; margin: 0;" class="required" tabindex="103" lastValidValue="" maxlength="20"/> 
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgLineSearch" alt="Go" style="float: right;" tabindex="104"/>
								</span>
							</td>
							<td class="rightAligned" id="trSublineName">Subline</td>
							<td class="leftAligned">
								<input id="txtSublineCd" type="hidden">
								<span class="lovSpan required" style="width: 206px; margin: 0px;">
									<input type="text" id="txtSublineName" ignoreDelKey="true" style="width: 180px; float: left; border: none; height: 14px; margin: 0;" class="required" tabindex="105" lastValidValue="" maxlength="30"/> 
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSublineSearch" alt="Go" style="float: right;" tabindex="106"/>
								</span>
							</td>
						</tr>
						<tr id="trRemarks">
							<td class="rightAligned">Remarks</td>
							<td class="leftAligned" colspan="3">
								<div id="remarksPlanDiv" name="remarksPlanDiv" style="float: left; width: 539px; border: 1px solid gray; height: 22px;">
									<textarea style="float: left; height: 16px; width: 513px; margin-top: 0; border: none;" id="txtPlanRemarks" name="txtPlanRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="107"></textarea>
									<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editPlanRemarks"  tabindex="108"/>
								</div>
							</td>
						</tr>			
						<tr>
							<td class="rightAligned">User ID</td>
							<td class="leftAligned"><input id="txtPlanUserId" type="text" class="readOnly" style="width: 200px;" readonly="readonly" tabindex="109"></td>
							<td width="" class="rightAligned" style="padding-left: 47px">Last Update</td>
							<td class="leftAligned"><input id="txtPlanLastUpdate" type="text" class="readOnly" style="width: 200px;" readonly="readonly" tabindex="110"></td>
						</tr>			
					</table>
				</div>
				<div style="margin: 10px;" align = "center">
					<input type="button" class="button" id="btnAddPlan" value="Add" tabindex="111">
					<input type="button" class="button" id="btnDeletePlan" value="Delete" tabindex="112">
				</div>
			</div>
		</div>
	</div>
	<div id="giiss219Block2" name="giiss219Block2">	
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
		   		<label id = "block2">Package Plan Cover Maintenance</label>
		   		<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label> 
				</span>
		   	</div>
		</div>	
		<div id="giiss219Block2Body" name="giiss219Block2Body">	
			<div class="sectionDiv">
				<div id="giiss219TableDiv2" style="padding-top: 10px;">
					<div id="giiss219Table2" style="height: 340px; margin-left: 10px;"></div>
				</div>
				<div align="center" id="giiss219FormDiv2">
					<table style="margin-top: 5px;">
						<tr>
							<td class="rightAligned">Line</td>
							<td class="leftAligned" colspan="3">
								<span class="lovSpan required" style="width: 130px; margin: 0px;">
									<input type="text" id="txtPackPlanCoverLineCd" ignoreDelKey="true" style="width: 105px; float: left; border: none; height: 14px; margin: 0;" class="required" tabindex="201" lastValidValue="" maxlength="2"/> 
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgPackPlanCoverLineSearch" alt="Go" style="float: right;" tabindex="202"/>
								</span>
								<input id="txtPackPlanCoverLineName" type="text" class="readOnly" style="width: 396px; margin-left:5px; margin-top:0px;" readonly="readonly" tabindex="203">
							</td>
						</tr>
						<tr>
							<td class="rightAligned">Subline</td>
							<td class="leftAligned" colspan="3">
								<span class="lovSpan required" style="width: 130px; margin: 0px;">
									<input type="text" id="txtPackPlanCoverSublineCd" ignoreDelKey="true" style="width: 105px; float: left; border: none; height: 14px; margin: 0;" class="required" tabindex="204" lastValidValue="" maxlength="7"/> 
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgPackPlanCoverSublineSearch" alt="Go" style="float: right;" tabindex="205"/>
								</span>
								<input id="txtPackPlanCoverSublineName" type="text" class="readOnly" style="width: 396px; margin-left:5px; margin-top:0px;" readonly="readonly" tabindex="206">
							</td>
						</tr>
						<tr>
							<td class="rightAligned">User ID</td>
							<td class="leftAligned"><input id="txtPackPlanCoverUserId" type="text" class="readOnly" style="width: 200px;" readonly="readonly" tabindex="207"></td>
							<td width="" class="rightAligned" style="padding-left: 47px">Last Update</td>
							<td class="leftAligned"><input id="txtPackPlanCoverLastUpdate" type="text" class="readOnly" style="width: 200px;" readonly="readonly" tabindex="208"></td>
						</tr>			
					</table>
				</div>
				<div style="margin: 10px;" align = "center">
					<input type="button" class="button" id="btnAddPackPlanCover" value="Add" tabindex="209">
					<input type="button" class="button" id="btnDeletePackPlanCover" value="Delete" tabindex="210">
				</div>
			</div>
		</div>
	</div>
	<div id="giiss219Block3" name="giiss219Block3">	
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
		   		<label  id = "block3">Plan Detail Maintenance</label>
		   		<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label> 
				</span>
		   	</div>
		</div>
		<div id="giiss219Block3Body" name="giiss219Block3Body">	
			<div class="sectionDiv">
				<div id="giiss219TableDiv3" style="padding-top: 10px;">
					<div id="giiss219Table3" style="height: 340px; margin-left: 10px;"></div>
				</div>
				<div id="giiss219TotalsDiv2">
				<table align="right"  style="margin-right: 38px;">
					<tr>
						<td class="rightAligned">Total</td>
						<td class="leftAligned" style="padding-right: 198px;">
							<input id="txtTotalPremAmt" type="text" style="width: 138px; text-align: right;" readonly="readonly" tabindex="301">
						</td>
						<td class="leftAligned">
							<input id="txtTotalTsiAmt" type="text" style="width: 138px; text-align: right;" readonly="readonly" tabindex="302">
						</td>
					</tr>
				</table>
			</div>
				<div align="center" id="giiss219FormDiv3">
					<table style="margin-top: 50px;">
						<tr>
							<td class="rightAligned"></td>
							<td>
								<input type="checkbox" style="float: left; margin-right: 7px; margin-top: 3px; margin-left: 4px;" title="Aggregate" id="chkAggregateSw" tabindex="303">
								<label style="float: left; margin-top: 3px;" for="chkAggregateSw" title="Aggregate">Aggregate</label>
							</td>
						</tr>	
						<tr>
							<td class="rightAligned">Peril</td>
							<td class="leftAligned">
								<input id="txtPerilType" type="hidden">
								<input id="txtPerilCd" type="hidden" lastValidValue="">
								<span class="lovSpan required" style="width: 206px; margin: 0px;">
									<input type="text" id="txtPerilName" ignoreDelKey="true" style="width: 180px; float: left; border: none; height: 14px; margin: 0;" class="required" tabindex="304" lastValidValue="" maxlength="20"/> 
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgPerilNameSearch" alt="Go" style="float: right;" tabindex="305"/>
								</span>
							</td>
							<td width="" class="rightAligned">Prem. Rate</td>
							<td class="leftAligned">
								<input id="txtPremRate" type="text" class="nthDecimal2" style="width: 200px;" tabindex="306" errorMsg = "Invalid Premium Rate. Valid value should be from  0.000000000 to 100.000000000." min="0" max="100" maxlength="13">
							</td>
						</tr>
						<tr>
							<td width="" class="rightAligned">Premium Amount</td>
							<td class="leftAligned">
								<input id="txtPremAmt" type="text" class="money4" style="width: 200px;" tabindex="307" maxlength="13" errorMsg = "Invalid Premium Amount. Valid value should be from 0.00 to 9,999,999,999.99." min="0" max="9999999999.99">
							</td>
							<td width="" class="rightAligned">Base Amt.</td>
							<td class="leftAligned">
								<input id="txtBaseAmt" type="text" class="money4" style="width: 200px;" tabindex="308" maxlength="17" errorMsg = "Invalid Base Amount. Valid value should be from 0.00 to 99,999,999,999,999.99." min="0" max="99999999999999.99">
							</td>
						</tr>	
						<tr>
							<td width="" class="rightAligned">Days</td>
							<td class="leftAligned">
								<input id="txtNoOfDays" type="text" class="integerNoNegativeUnformattedNoComma" style="width: 200px; text-align: right;" tabindex="309" maxlength="5">
							</td>
							<td width="" class="rightAligned">Sum Insured</td>
							<td class="leftAligned">
								<input id="txtTsiAmt" type="text" class="money4" style="width: 200px;" tabindex="310" maxlength="17" errorMsg = "Invalid Sum Insured. Valid value should be from 0.00 to 99,999,999,999,999.99." min="0" max="99999999999999.99">
							</td>
						</tr>				
						<tr>
							<td class="rightAligned">User ID</td>
							<td class="leftAligned"><input id="txtPlanDtlUserId" type="text" class="readOnly" style="width: 200px;" readonly="readonly" tabindex="311"></td>
							<td width="" class="rightAligned" style="padding-left: 47px">Last Update</td>
							<td class="leftAligned"><input id="txtPlanDtlLastUpdate" type="text" class="readOnly" style="width: 200px;" readonly="readonly" tabindex="312"></td>
						</tr>			
					</table>
				</div>
				<div style="margin: 10px;" align = "center">
					<input type="button" class="button" id="btnAddPlanDtl" value="Add" tabindex="313">
					<input type="button" class="button" id="btnDeletePlanDtl" value="Delete" tabindex="314">
				</div>
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="315">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="316">
</div>
<script type="text/javascript">	
	setModuleId("GIISS219");
	setDocumentTitle("Package Product Maintenance");
	initializeAll();
	initializeAllMoneyFields();
	initializeAccordion();
	changeTag = 0;
	var changeTagPlan = 0;
	var changeTagPackPlanCover = 0;
	var changeTagPlanDtl = 0;
	var rowIndexPlan = -1;
	var rowIndexPackPlanCover = -1;
	var rowIndexPlanDtl = -1;
	var giiss219Array = {};
	var toShowIntTab = false;	
	$("giiss219Block2").hide();

	function resetAllFields() {
		changeTag = 0;
		changeTagPlan = 0;
		changeTagPackPlanCover = 0;
		changeTagPlanDtl = 0;
		rowIndexPlan = -1;
		rowIndexPackPlanCover = -1;
		rowIndexPlanDtl = -1;
		giiss219Array = {};
// 		giiss219Array.giisPlan = [];
// 		giiss219Array.giisPackPlan = [];
		objGIISS219.exitPage = null;
		
		enableDisableFields(["giiss219FormDiv3","giiss219FormDiv2"], "disable");
		disableButton("btnAddPackPlanCover");
		disableButton("btnAddPlanDtl");
		disableButton("btnDeletePlan");
		disableButton("btnDeletePackPlanCover");
		disableButton("btnDeletePlanDtl");
		
		$("txtLineName").setAttribute("lastValidValue", "");
		$("txtSublineName").setAttribute("lastValidValue", "");
		$("txtSublineName").readOnly = true;
		disableSearch("imgSublineSearch");
		$("txtPackPlanCoverLineCd").setAttribute("lastValidValue", "");
		$("txtPackPlanCoverSublineCd").setAttribute("lastValidValue", "");
		$("txtPerilCd").setAttribute("lastValidValue", "");
		$("txtPerilName").setAttribute("lastValidValue", "");
		
		$("txtTotalPremAmt").value = formatCurrency(0);
		$("txtTotalTsiAmt").value = formatCurrency(0);
	}
	
 	function enableDisableFields(divArray,toDo){
		try{
			if (divArray!= null){
				for ( var i = 0; i < divArray.length; i++) {
					$$("div#"+divArray[i]+" input[type='text'], div#"+divArray[i]+" textarea, div#"+divArray[i]+" input[type='hidden']").each(function (b) {
						if (!($(b).hasClassName("readOnly"))) {
							toDo == "enable" ?  $(b).readOnly= false : $(b).readOnly= true;
						}
						if (toDo == "disable"){
							$(b).clear();
						}
					});
					$$("div#"+divArray[i]+" input[type='checkbox']").each(function (b) {
						$(b).checked = false;
						toDo == "enable" ?  $(b).enable() : $(b).disable();
					});
					$$("div#"+divArray[i]+" img").each(function (img) {
						var src = img.src;
						var id = img.id;
						if(nvl(img, null) != null){
							if(src.include("searchIcon.png")){
								toDo == "enable" ? enableSearch(img) : disableSearch(img);
							}else if(src.include("but_calendar.gif")){
								toDo == "enable" ? enableDate(img) : disableDate(img); 
							}
						}
					});
				}
			}
		}catch(e){
			showErrorMessage("enableDisableFields", e);
		}
	}
 	
	function saveGiiss219(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var objParams = new Object();
		if (objGIISS219.type == "regular") {
			objParams.setGIISPlanDtl = getAddedAndModifiedJSONObjects(tbgGIISPlanDtl.geniisysRows);
			objParams.delGIISPlanDtl = getDeletedJSONObjects(tbgGIISPlanDtl.geniisysRows);
			objParams.setGIISPackPlanCover = [];
			objParams.delGIISPackPlanCover = [];
			objParams.setGIISPackPlanCoverDtl = [];
			objParams.delGIISPackPlanCoverDtl = [];
		} else if(objGIISS219.type == "package") {
			objParams.setGIISPlanDtl = [];
			objParams.delGIISPlanDtl = [];
			objParams.setGIISPackPlanCover = getAddedAndModifiedJSONObjects(tbgGIISPackPlanCover.geniisysRows);
			objParams.delGIISPackPlanCover = getDeletedJSONObjects(tbgGIISPackPlanCover.geniisysRows);
			objParams.setGIISPackPlanCoverDtl = getAddedAndModifiedJSONObjects(tbgGIISPlanDtl.geniisysRows);
			objParams.delGIISPackPlanCoverDtl = getDeletedJSONObjects(tbgGIISPlanDtl.geniisysRows);
		}
 		new Ajax.Request(contextPath+"/GIISS219Controller", {
			method: "POST",
			parameters : {action : "saveGiiss219",
						  params : JSON.stringify(giiss219Array),
						  params2 :JSON.stringify(objParams)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS219.exitPage != null) {
							tbgGIISPlan.keys.releaseKeys();
							tbgGIISPackPlanCover.keys.releaseKeys();
							tbgGIISPlanDtl.keys.releaseKeys();
							objGIISS219.exitPage();
						} else {
							resetAllFields();
							tbgGIISPlan._refreshList();
							tbgGIISPlan.keys.releaseKeys();
							tbgGIISPackPlanCover.keys.releaseKeys();
							tbgGIISPlanDtl.keys.releaseKeys();
						}
					});
					changeTag = 0;
					changeTagPlan = 0;
					changeTagPackPlanCover = 0;
					changeTagPlanDtl = 0;
				}
			}
		}); 
	}
	
	observeReloadForm("reloadForm", showGiiss219);
	
	objGIISS219 = {};
	objGIISS219.exitPage = null;
	objGIISS219.type = "regular";
	//GIIS_PLAN/GIIS_PACK_PLAN tablegrid...
	var objCurrGIISPlan = null;
	objGIISS219.giiss219Plan = JSON.parse('${jsonGIISS219}');
 	function initializePlanTbg(type,mode) {
		try {
			var giiss219PlanTable = {
					url : contextPath + "/GIISS219Controller?action=showGiiss219&refresh=1&type="+type+"&mode="+mode,
					id: "giisPlan",
					options : {
						width : '900px',
						pager : {},
						beforeClick: function(){
							if (mode == "regular") {
								if(changeTagPlanDtl == 1){
			 						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
			 							$("btnSave").focus();
			 						});
			 						return false;
			 					}
							} else {
								if(changeTagPlanDtl == 1 || changeTagPackPlanCover == 1){
			 						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
			 							$("btnSave").focus();
			 						});
			 						return false;
			 					}
							}
						},
						onCellFocus : function(element, value, x, y, id){
		 					rowIndexPlan = y;
		 					objCurrGIISPlan = tbgGIISPlan.geniisysRows[y];
		 					setFieldValues(objCurrGIISPlan, type, mode);
		 					showPageBlock(type, mode, null);
		 					tbgGIISPlan.keys.removeFocus(tbgGIISPlan.keys._nCurrentFocus, true);
		 					tbgGIISPlan.keys.releaseKeys();
		 					$("txtPlanDesc").focus();
						},
						onRemoveRowFocus : function(){
		 					rowIndexPlan = -1;
		 					setFieldValues(null,type, mode);
		 					showPageBlock(type, null, mode);
		 					tbgGIISPlan.keys.removeFocus(tbgGIISPlan.keys._nCurrentFocus, true);
		 					tbgGIISPlan.keys.releaseKeys();
		 					$("txtPlanDesc").focus();
						},					
						toolbar : {
							elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
							onFilter: function(){
		 						rowIndexPlan = -1;
			 					setFieldValues(null,type, mode);
			 					showPageBlock(type, null, mode);
			 					tbgGIISPlan.keys.removeFocus(tbgGIISPlan.keys._nCurrentFocus, true);
			 					tbgGIISPlan.keys.releaseKeys();
							}
						},
						beforeSort : function(){
							if (mode == "regular") {
								if(changeTagPlan == 1 || changeTagPlanDtl == 1){
			 						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
			 							$("btnSave").focus();
			 						});
			 						return false;
			 					}
							} else {
								if(changeTagPlan == 1 || changeTagPlanDtl == 1 || changeTagPackPlanCover == 1){
			 						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
			 							$("btnSave").focus();
			 						});
			 						return false;
			 					}
							}
						},
						onSort: function(){
							rowIndexPlan = -1;
		 					setFieldValues(null,type, mode);
		 					showPageBlock(type, null, mode);
		 					tbgGIISPlan.keys.removeFocus(tbgGIISPlan.keys._nCurrentFocus, true);
		 					tbgGIISPlan.keys.releaseKeys();
						},
						onRefresh: function(){
							rowIndexPlan = -1;
		 					setFieldValues(null,type, mode);
		 					showPageBlock(type, null, mode);
		 					tbgGIISPlan.keys.removeFocus(tbgGIISPlan.keys._nCurrentFocus, true);
		 					tbgGIISPlan.keys.releaseKeys();
						},				
						prePager: function(){
							if (mode == "regular") {
								if(changeTagPlan == 1 || changeTagPlanDtl == 1){
			 						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
			 							$("btnSave").focus();
			 						});
			 						return false;
			 					}
							} else {
								if(changeTagPlan == 1 || changeTagPlanDtl == 1 || changeTagPackPlanCover == 1){
			 						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
			 							$("btnSave").focus();
			 						});
			 						return false;
			 					}
							}
							rowIndexPlan = -1;
		 					setFieldValues(null,type, mode);
		 					showPageBlock(type, null, mode);
		 					tbgGIISPlan.keys.removeFocus(tbgGIISPlan.keys._nCurrentFocus, true);
		 					tbgGIISPlan.keys.releaseKeys();
						},
						checkChanges: function(){
							if (mode == "regular") {
								return (changeTagPlan == 1 || changeTagPlanDtl == 1 ? true : false);
							} else {
								return (changeTagPlan == 1 || changeTagPlanDtl == 1 || changeTagPackPlanCover == 1 ? true : false);
							}
						},
						masterDetailRequireSaving: function(){
		 					if (mode == "regular") {
								return (changeTagPlan == 1 || changeTagPlanDtl == 1 ? true : false);
							} else {
								return (changeTagPlan == 1 || changeTagPlanDtl == 1 || changeTagPackPlanCover == 1 ? true : false);
							}
						},
						masterDetailValidation: function(){
							if (mode == "regular") {
								return (changeTagPlan == 1 || changeTagPlanDtl == 1 ? true : false);
							} else {
								return (changeTagPlan == 1 || changeTagPlanDtl == 1 || changeTagPackPlanCover == 1 ? true : false);
							}
						},
						masterDetail: function(){
							if (mode == "regular") {
								return (changeTagPlan == 1 || changeTagPlanDtl == 1 ? true : false);
							} else {
								return (changeTagPlan == 1 || changeTagPlanDtl == 1 || changeTagPackPlanCover == 1 ? true : false);
							}
						},
						masterDetailSaveFunc: function() {
							if (mode == "regular") {
								return (changeTagPlan == 1 || changeTagPlanDtl == 1 ? true : false);
							} else {
								return (changeTagPlan == 1 || changeTagPlanDtl == 1 || changeTagPackPlanCover == 1 ? true : false);
							}
						},
						masterDetailNoFunc: function(){
							if (mode == "regular") {
								return (changeTagPlan == 1 || changeTagPlanDtl == 1 ? true : false);
							} else {
								return (changeTagPlan == 1 || changeTagPlanDtl == 1 || changeTagPackPlanCover == 1 ? true : false);
							}
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
							id : "planCd",
							title : "Plan Code",
							filterOption : true,
							filterOptionType : 'integerNoNegative',
							titleAlign : 'right',
							align : 'right',
							width : '100px'
						},
						{
							id : 'planDesc',
							title : 'Description',
							filterOption : true,
							width : '300px'				
						},
						{
							id : 'lineName',
							title : type == "regular"? 'Line' : 'Package Line',
							filterOption : true,
							width : '220px'				
						},
						{
							id : 'sublineName',
							title : type == "regular"? 'Subline' : 'Package Subline',
							filterOption : true,
							width : '220px'				
						},
						{
							id : 'lineCd',
							width : '0',
							visible: false			
						},
						{
							id : 'sublineCd',
							width : '0',
							visible: false				
						},
						{
							id : 'packLineCd',
							width : '0',
							visible: false			
						},
						{
							id : 'packSublineCd',
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
					rows : objGIISS219.giiss219Plan.rows
				};

				tbgGIISPlan = new MyTableGrid(giiss219PlanTable);
				tbgGIISPlan.pager = objGIISS219.giiss219Plan;
				tbgGIISPlan.render("giiss219Table");
				tbgGIISPlan.afterRender = function () {
					if (objGIISS219.type == "regular") {
						giiss219Array.giisPlan = tbgGIISPlan.geniisysRows;
					} else {
						giiss219Array.giisPackPlan = tbgGIISPlan.geniisysRows;
					}
					if (toShowIntTab) {
						toShowIntTab = false;
						tbgGIISPlan.refresh();
					}
				};
		} catch (e) {
			showErrorMessage("initializePlanTbg",e);
		}
	} 
	//GIIS_PACK_PLAN_COVER tablegrid...
	var objCurrGIISPackPlanCover = null;
	objGIISS219.giiss219PackPlanCover = [];
	var giiss219PackPlanCoverTable = {
			url : contextPath + "/GIISS219Controller?action=showGiiss219&refresh=1&type=package&mode=giisPackPlanCover",
			id: "giisPackPlanCover",
			options : {
				hideColumnChildTitle: true,
				width : '900px',
				height: '340px',
				pager : {},
				beforeClick: function(){
					if(changeTagPlanDtl == 1){
 						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
 							$("btnSave").focus();
 						});
 						return false;
 					}
				},
				onCellFocus : function(element, value, x, y, id){
					rowIndexPackPlanCover = y;
					objCurrGIISPackPlanCover = tbgGIISPackPlanCover.geniisysRows[y];
					setFieldValues(objCurrGIISPackPlanCover, "package", "giisPackPlanCover");
					showPageBlock("package", "giisPackPlanCover", null);
					tbgGIISPackPlanCover.keys.removeFocus(tbgGIISPackPlanCover.keys._nCurrentFocus, true);
					tbgGIISPackPlanCover.keys.releaseKeys();
					$("txtPackPlanCoverLineCd").focus();
				},
				onRemoveRowFocus : function(){
					rowIndexPackPlanCover = -1;
					setFieldValues(null, "package", "giisPackPlanCover");
					showPageBlock("package", null, "giisPackPlanCover"); 
					tbgGIISPackPlanCover.keys.removeFocus(tbgGIISPackPlanCover.keys._nCurrentFocus, true);
					tbgGIISPackPlanCover.keys.releaseKeys();
					$("txtPackPlanCoverLineCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndexPackPlanCover = -1;
						setFieldValues(null, "package", "giisPackPlanCover");
						showPageBlock("package", null, "giisPackPlanCover"); 
						tbgGIISPackPlanCover.keys.removeFocus(tbgGIISPackPlanCover.keys._nCurrentFocus, true);
						tbgGIISPackPlanCover.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					if(changeTagPackPlanCover == 1 || changeTagPlanDtl == 1){
 						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
 							$("btnSave").focus();
 						});
 						return false;
 					}
				},
				onSort: function(){
					rowIndexPackPlanCover = -1;
					setFieldValues(null, "package", "giisPackPlanCover");
					showPageBlock("package", null, "giisPackPlanCover"); 
					tbgGIISPackPlanCover.keys.removeFocus(tbgGIISPackPlanCover.keys._nCurrentFocus, true);
					tbgGIISPackPlanCover.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndexPackPlanCover = -1;
					setFieldValues(null, "package", "giisPackPlanCover");
					showPageBlock("package", null, "giisPackPlanCover"); 
					tbgGIISPackPlanCover.keys.removeFocus(tbgGIISPackPlanCover.keys._nCurrentFocus, true);
					tbgGIISPackPlanCover.keys.releaseKeys();
				},				
				prePager: function(){
					if(changeTagPackPlanCover == 1 || changeTagPlanDtl == 1){
 						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
 							$("btnSave").focus();
 						});
 						return false;
 					}
					rowIndexPackPlanCover = -1;
					setFieldValues(null, "package", "giisPackPlanCover");
					showPageBlock("package", null, "giisPackPlanCover"); 
					tbgGIISPackPlanCover.keys.removeFocus(tbgGIISPackPlanCover.keys._nCurrentFocus, true);
					tbgGIISPackPlanCover.keys.releaseKeys();
				},
				checkChanges: function(){
					return (changeTagPackPlanCover == 1 || changeTagPlanDtl == 1 ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (changeTagPackPlanCover == 1 || changeTagPlanDtl == 1 ? true : false);
				},
				masterDetailValidation: function(){
					return (changeTagPackPlanCover == 1 || changeTagPlanDtl == 1 ? true : false);
				},
				masterDetail: function(){
					return (changeTagPackPlanCover == 1 || changeTagPlanDtl == 1 ? true : false);
				},
				masterDetailSaveFunc: function() {
					return (changeTagPackPlanCover == 1 || changeTagPlanDtl == 1 ? true : false);
				},
				masterDetailNoFunc: function(){
					return (changeTagPackPlanCover == 1 || changeTagPlanDtl == 1 ? true : false);
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
			    	id:'packLineCd lineName',
			    	title: 'Line',
			    	width: 400,
			    	children: [
			    	   	    {	id: 'packLineCd',
			    	   	    	title: 'Pack Line Code',
						    	width: 150,
						    	filterOption: true,	
						    	align: 'left'
						    },
						    {	id: 'lineName',
			    	   	    	title: 'Line Name',
						    	width: 250,
						    	filterOption: true,	
						    	align: 'left'
						    },
			    	          ]
			    },
			    {
			    	id:'packSublineCd sublineName',
			    	title: 'Subline',
			    	width: 450,
			    	children: [
			    	   	    {	id: 'packSublineCd',
			    	   	    	title: 'Pack Subline Code',
						    	width: 150,
						    	filterOption: true,	
						    	align: 'left'
						    },
						    {	id: 'sublineName',
			    	   	    	title: 'Subline Name',
						    	width: 300,
						    	filterOption: true,	
						    	align: 'left'
						    },
			    	          ]
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
			rows : []
		};

		tbgGIISPackPlanCover = new MyTableGrid(giiss219PackPlanCoverTable);
		tbgGIISPackPlanCover.render("giiss219Table2");
		tbgGIISPackPlanCover.afterRender = function () {
			if(rowIndexPlan > -1 ){
				giiss219Array.giisPackPlan[rowIndexPlan].giisPackPlanCover = tbgGIISPackPlanCover.geniisysRows;
			}
		}; 
	//GIIS_PLAN_DTL/GIIS_PACK_PLAN_COVER_DTL tablegrid...
	var objCurrGIISPlanDtl = null;
	objGIISS219.giiss219PlanDtl = [];
	var giiss219PlanDtlTable = {
			url : contextPath + "/GIISS219Controller?action=showGiiss219&refresh=1&type=regular&mode=giisPlanDtl",
			id:"giisPlanDtl",
			options : {
				width : '900px',
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndexPlanDtl = y;
					objCurrGIISPlanDtl = tbgGIISPlanDtl.geniisysRows[y];
					setFieldValues(objCurrGIISPlanDtl, objGIISS219.type, objGIISS219.type == "regular"? "giisPlanDtl" : "giisPackPlanCoverDtl"); 
					tbgGIISPlanDtl.keys.removeFocus(tbgGIISPlanDtl.keys._nCurrentFocus, true);
					tbgGIISPlanDtl.keys.releaseKeys();
					$("txtPerilName").focus();
				},
				onRemoveRowFocus : function(){
					rowIndexPlanDtl = -1;
					setFieldValues(null, objGIISS219.type, objGIISS219.type == "regular"? "giisPlanDtl" : "giisPackPlanCoverDtl"); 
					tbgGIISPlanDtl.keys.removeFocus(tbgGIISPlanDtl.keys._nCurrentFocus, true);
					tbgGIISPlanDtl.keys.releaseKeys();
					$("txtPerilCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndexPlanDtl = -1;
						setFieldValues(null, objGIISS219.type, objGIISS219.type == "regular"? "giisPlanDtl" : "giisPackPlanCoverDtl"); 
						tbgGIISPlanDtl.keys.removeFocus(tbgGIISPlanDtl.keys._nCurrentFocus, true);
						tbgGIISPlanDtl.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					if(changeTagPlanDtl == 1 ){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
				},
				onSort: function(){
					rowIndexPlanDtl = -1;
					setFieldValues(null, objGIISS219.type, objGIISS219.type == "regular"? "giisPlanDtl" : "giisPackPlanCoverDtl"); 
					tbgGIISPlanDtl.keys.removeFocus(tbgGIISPlanDtl.keys._nCurrentFocus, true);
					tbgGIISPlanDtl.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndexPlanDtl = -1;
					setFieldValues(null, objGIISS219.type, objGIISS219.type == "regular"? "giisPlanDtl" : "giisPackPlanCoverDtl"); 
					tbgGIISPlanDtl.keys.removeFocus(tbgGIISPlanDtl.keys._nCurrentFocus, true);
					tbgGIISPlanDtl.keys.releaseKeys();
				},				
				prePager: function(){
					if(changeTagPlanDtl == 1 ){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
					rowIndexPlanDtl = -1;
					setFieldValues(null, objGIISS219.type, objGIISS219.type == "regular"? "giisPlanDtl" : "giisPackPlanCoverDtl"); 
					tbgGIISPlanDtl.keys.removeFocus(tbgGIISPlanDtl.keys._nCurrentFocus, true);
					tbgGIISPlanDtl.keys.releaseKeys();
				},
				checkChanges: function(){
					return (changeTagPlanDtl == 1  ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (changeTagPlanDtl == 1  ? true : false);
				},
				masterDetailValidation: function(){
					return (changeTagPlanDtl == 1  ? true : false);
				},
				masterDetail: function(){
					return (changeTagPlanDtl == 1  ? true : false);
				},
				masterDetailSaveFunc: function() {
					return (changeTagPlanDtl == 1  ? true : false);
				},
				masterDetailNoFunc: function(){
					return (changeTagPlanDtl == 1  ? true : false);
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
					id : "planCd",
					width : '0',
					visible: false
				},
				{
					id : "perilCd",
					width : '0',
					visible: false
				},
				{
					id: 'aggregateSw',
					title: '&#160;A',
	            	width: '23px',
	            	altTitle: 'Aggregate',
	            	titleAlign: 'center',
	            	filterOption : true,
	            	filterOptionType : 'checkbox',
	            	editable: false,
	            	editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
			            	return value ? "Y" : "N";
		            	}
	            	})
				},
				{
					id : "perilName",
					title : "Peril",
					filterOption : true,
					width : '200px'
				},
				{
					id : 'premRt',
					title : 'Prem. Rate',
					filterOption : true,
					filterOptionType : 'numberNoNegative',
					geniisysClass : 'rate',
					titleAlign: 'right',
					align: 'right',
					width : '140px'				
				},
				{
					id : 'premAmt',
					title : 'Premium Amount',
					filterOption : true,
					filterOptionType : 'numberNoNegative',
					geniisysClass : 'money',
					titleAlign: 'right',
					align: 'right',
					width : '140px'				
				},
				{
					id : 'noOfDays',
					title : 'Days',
					filterOption : true,
					filterOptionType : 'integerNoNegative',
					titleAlign: 'right',
					align: 'right',
					width : '60px'				
				},
				{
					id : 'baseAmt',
					title : 'Base Amt.',
					filterOption : true,
					filterOptionType : 'numberNoNegative',
					geniisysClass : 'money',
					titleAlign: 'right',
					align: 'right',
					width : '140px'				
				},
				{
					id : 'tsiAmt',
					title : 'Sum Insured',
					filterOption : true,
					filterOptionType : 'numberNoNegative',
					geniisysClass : 'money',
					titleAlign: 'right',
					align: 'right',
					width : '140px'				
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
			rows : []
		};
		tbgGIISPlanDtl = new MyTableGrid(giiss219PlanDtlTable);
		tbgGIISPlanDtl.render("giiss219Table3");
		tbgGIISPlanDtl.afterRender = function(){
			if (objGIISS219.type == "regular") {
				if(rowIndexPlan > -1 ){
					giiss219Array.giisPlan[rowIndexPlan].giisPlanDtl = tbgGIISPlanDtl.geniisysRows;
				}
			} else {
				if(rowIndexPlan > -1 && rowIndexPackPlanCover > -1){
					giiss219Array.giisPackPlan[rowIndexPlan].giisPackPlanCover[rowIndexPackPlanCover].giisPackPlanCoverDtl = tbgGIISPlanDtl.geniisysRows;
				}
			} 
			var totalPremAmt = 0;
			var totalTsiAmt = 0;
			if(tbgGIISPlanDtl.geniisysRows.length != 0){
				totalPremAmt=tbgGIISPlanDtl.geniisysRows[0].totalPrem;
				totalTsiAmt=tbgGIISPlanDtl.geniisysRows[0].totalTsi;
			}
			$("txtTotalPremAmt").value = formatCurrency(nvl(totalPremAmt,0));
			$("txtTotalTsiAmt").value = formatCurrency(nvl(totalTsiAmt,0));
		};
		
	function computeTotalPremAmountInTable(val) {
		try {
			var total=unformatCurrency("txtTotalPremAmt");
			total = parseFloat(total) + (parseFloat(val));
			$("txtTotalPremAmt").value = formatCurrency(total);
		} catch (e) {
			showErrorMessage("computeTotalPremAmountInTable", e);
		}
	}
	
	function computeTSIInTable(val1,val2,mode) {
		try {
			var result = "0.00"; 
			new Ajax.Request(contextPath + "/GIISPackageBenefitController", {
				parameters : {action : "computeTotalAmount",
					          total : unformatValueToString($F("txtTotalTsiAmt")),
					          val1 : nvl(val1,"0"),
					          val2 : nvl(val2,"0"),
					          mode : mode},
		  		evalScripts: true,
				asynchronous: false,
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						result = response.responseText;
					}
				}
			});
			$("txtTotalTsiAmt").value = formatCurrency(result);
		} catch (e) {
			showErrorMessage("computeTSIInTable", e);
		}
	}
	
	function showGIISS219LineLOV(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : objGIISS219.type == "regular" ? "getGiiss219LineLOV" : "getGiiss219LinePackLOV",
							filterText : ($("txtLineName").readAttribute("lastValidValue").trim() != $F("txtLineName").trim() ? $F("txtLineName").trim() : ""),
							page : 1},
			title: "List of Lines",
			width: 500,
			height: 400,
			columnModel : [ {
								id: "lineCd",
								title: "Line Code",
								width : '100px',
							}, {
								id : "lineName",
								title : "Line Name",
								width : '360px'
							} ],
				autoSelectOneRecord: true,
				filterText : ($("txtLineName").readAttribute("lastValidValue").trim() != $F("txtLineName").trim() ? $F("txtLineName").trim() : ""),
				onSelect: function(row) {
					$("txtLineCd").value = unescapeHTML2(row.lineCd);
					$("txtLineName").value = unescapeHTML2(row.lineName);
					$("txtLineName").setAttribute("lastValidValue", unescapeHTML2(row.lineName));
					$("txtSublineName").clear();
					$("txtSublineCd").clear();
					$("txtSublineCd").setAttribute("lastValidValue", "");
					$("txtSublineName").setAttribute("lastValidValue", "");
					$("txtSublineName").readOnly = false;
					enableSearch("imgSublineSearch");
					$("txtSublineName").focus();
				},
				onCancel: function (){
					$("txtLineName").value = $("txtLineName").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtLineName").value = $("txtLineName").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	function showGIISS219SublineLOV(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : objGIISS219.type == "regular" ? "getGiiss219SublineLOV" : "getGiiss219SublinePackLOV",
				            lineCd : unescapeHTML2($F("txtLineCd")),
							filterText : ($("txtSublineName").readAttribute("lastValidValue").trim() != $F("txtSublineName").trim() ? $F("txtSublineName").trim() : ""),
							page : 1},
			title: "List of Sublines",
			width: 500,
			height: 400,
			columnModel : [ {
								id: "sublineCd",
								title: "Subline Code",
								width : '100px',
							}, {
								id : "sublineName",
								title : "Subline Name",
								width : '360px'
							} ],
				autoSelectOneRecord: true,
				filterText : ($("txtSublineName").readAttribute("lastValidValue").trim() != $F("txtSublineName").trim() ? $F("txtSublineName").trim() : ""),
				onSelect: function(row) {
					$("txtSublineCd").value = unescapeHTML2(row.sublineCd);
					$("txtSublineName").value = unescapeHTML2(row.sublineName);
					$("txtSublineName").setAttribute("lastValidValue", unescapeHTML2(row.sublineName));
				},
				onCancel: function (){
					$("txtSublineName").value = $("txtSublineName").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtSublineName").value = $("txtSublineName").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	function showGIISS219PackLineLOV(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getGiiss219PackLineLOV",
				 		    lineCd : unescapeHTML2($F("txtLineCd")),
							filterText : (unescapeHTML2($("txtPackPlanCoverLineCd").readAttribute("lastValidValue").trim()) != $F("txtPackPlanCoverLineCd").trim() ? $F("txtPackPlanCoverLineCd").trim() : ""),
							page : 1},
			title: "List of Lines",
			width: 500,
			height: 400,
			columnModel : [ {
								id: "packLineCd",
								title: "Line Code",
								width : '100px',
							}, {
								id : "lineName",
								title : "Line Name",
								width : '360px'
							} ],
				autoSelectOneRecord: true,
				filterText : ($("txtPackPlanCoverLineCd").readAttribute("lastValidValue").trim() != $F("txtPackPlanCoverLineCd").trim() ? $F("txtPackPlanCoverLineCd").trim() : ""),
				onSelect: function(row) {
					$("txtPackPlanCoverLineCd").value = unescapeHTML2(row.packLineCd);
					$("txtPackPlanCoverLineName").value = unescapeHTML2(row.lineName);
					$("txtPackPlanCoverLineCd").setAttribute("lastValidValue", unescapeHTML2(row.packLineCd));
					$("txtPackPlanCoverSublineCd").clear();
					$("txtPackPlanCoverSublineName").clear();
					$("txtPackPlanCoverSublineCd").setAttribute("lastValidValue", "");
					$("txtPackPlanCoverSublineName").setAttribute("lastValidValue", "");
					$("txtPackPlanCoverSublineCd").readOnly = false;
					enableSearch("imgPackPlanCoverSublineSearch");
					$("txtPackPlanCoverSublineCd").focus();
				},
				onCancel: function (){
					$("txtPackPlanCoverLineCd").value = $("txtPackPlanCoverLineCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtPackPlanCoverLineCd").value = $("txtPackPlanCoverLineCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	function showGIISS219PackSublineLOV(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getGiiss219PackSublineLOV",
				            lineCd : unescapeHTML2($F("txtLineCd")),
				            packLineCd : unescapeHTML2($F("txtPackPlanCoverLineCd")),
							filterText : ($("txtPackPlanCoverSublineCd").readAttribute("lastValidValue").trim() != $F("txtPackPlanCoverSublineCd").trim() ? $F("txtPackPlanCoverSublineCd").trim() : ""),
							page : 1},
			title: "List of Sublines",
			width: 500,
			height: 400,
			columnModel : [ {
								id: "packSublineCd",
								title: "Subline Code",
								width : '100px',
							}, {
								id : "sublineName",
								title : "Subline Name",
								width : '360px'
							} ],
				autoSelectOneRecord: true,
				filterText : ($("txtPackPlanCoverSublineCd").readAttribute("lastValidValue").trim() != $F("txtPackPlanCoverSublineCd").trim() ? $F("txtPackPlanCoverSublineCd").trim() : ""),
				onSelect: function(row) {
					$("txtPackPlanCoverSublineCd").value = unescapeHTML2(row.packSublineCd);
					$("txtPackPlanCoverSublineName").value = unescapeHTML2(row.sublineName);
					$("txtPackPlanCoverSublineCd").setAttribute("lastValidValue", unescapeHTML2(row.packSublineCd));
				},
				onCancel: function (){
					$("txtPackPlanCoverSublineCd").value = $("txtPackPlanCoverSublineCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtPackPlanCoverSublineCd").value = $("txtPackPlanCoverSublineCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	function showGIISS219PerilLOV(lineCd,sublineCd){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getGiiss219PerilLOV",
				            lineCd : unescapeHTML2(lineCd),
				            sublineCd : unescapeHTML2(sublineCd),
							filterText : ($("txtPerilName").readAttribute("lastValidValue").trim() != $F("txtPerilName").trim() ? $F("txtPerilName").trim() : ""),
							page : 1},
			title: "List of Perils",
			width: 500,
			height: 400,
			columnModel : [ {
								id: "perilCd",
								title: "Peril Code",
								width : '100px',
							},{
								id : "perilCd",
								width : '0',
								visible: false
							},{
								id : "perilName",
								title : "Peril Name",
								width : '360px'
							} ],
				autoSelectOneRecord: true,
				filterText : ($("txtPerilName").readAttribute("lastValidValue").trim() != $F("txtPerilName").trim() ? $F("txtPerilName").trim() : ""),
				onSelect: function(row) {
					$("txtPerilCd").value = unescapeHTML2(row.perilCd);
					$("txtPerilType").value = unescapeHTML2(row.perilType);
					$("txtPerilName").value = unescapeHTML2(row.perilName);
					$("txtPerilCd").setAttribute("lastValidValue", row.perilCd);
					$("txtPerilName").setAttribute("lastValidValue", unescapeHTML2(row.perilName));
				},
				onCancel: function (){
					$("txtPerilCd").value = $("txtPerilCd").readAttribute("lastValidValue");
					$("txtPerilName").value = $("txtPerilName").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtPerilCd").value = $("txtPerilCd").readAttribute("lastValidValue");
					$("txtPerilName").value = $("txtPerilName").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	function showPageBlock(type, focusMode, unfocusMode) {
		try {
			if (type == "regular") {
				if (focusMode == "giisPlan") {
					tbgGIISPlanDtl.url =  contextPath + "/GIISS219Controller?action=showGiiss219&refresh=1&type=regular&mode=giisPlanDtl&planCd="+$F("txtPlanCd");
					tbgGIISPlanDtl._refreshList();
					enableButton("btnAddPlanDtl");
					enableDisableFields(["giiss219FormDiv3"], "enable");
					if ($F("txtLineCd") !=  "PA") {
						$("txtBaseAmt").readOnly = true;
						$("txtNoOfDays").readOnly = true;
					}else{
						$("txtBaseAmt").readOnly = false;
						$("txtNoOfDays").readOnly = false;
					}
				}
				if (unfocusMode == "giisPlan") {
					tbgGIISPlanDtl.url = contextPath + "/GIISS219Controller?action=showGiiss219&refresh=1&type=regular";
					tbgGIISPlanDtl._refreshList();
					disableButton("btnAddPlanDtl");
					enableDisableFields(["giiss219FormDiv3"], "disable");
				}
			} else {
				if (focusMode == "giisPackPlan") {
					tbgGIISPackPlanCover.url = contextPath + "/GIISS219Controller?action=showGiiss219&refresh=1&type=package&mode=giisPackPlanCover&planCd="+$F("txtPlanCd");
					tbgGIISPackPlanCover._refreshList();
					enableButton("btnAddPackPlanCover");
					enableDisableFields(["giiss219FormDiv2"], "enable");
					$("txtPackPlanCoverSublineCd").setAttribute("lastValidValue", "");
					$("txtPackPlanCoverSublineCd").readOnly = true;
					disableSearch("imgPackPlanCoverSublineSearch");
				} else if(focusMode == "giisPackPlanCover") {
					tbgGIISPlanDtl.url = contextPath + "/GIISS219Controller?action=showGiiss219&refresh=1&type=package&mode=giisPackPlanCoverDtl&planCd="+$F("txtPlanCd")
																																		   +"&packLineCd="+encodeURIComponent($F("txtPackPlanCoverLineCd"))
																																		   +"&packSublineCd="+encodeURIComponent($F("txtPackPlanCoverSublineCd"));
					tbgGIISPlanDtl._refreshList();
					enableButton("btnAddPlanDtl");
					enableDisableFields(["giiss219FormDiv3"], "enable");
					if ($F("txtPackPlanCoverLineCd") !=  "PA") {
						$("txtBaseAmt").readOnly = true;
						$("txtNoOfDays").readOnly = true;
					}else{
						$("txtBaseAmt").readOnly = false;
						$("txtNoOfDays").readOnly = false;
					}
				} 
				if (unfocusMode == "giisPackPlan") {
					tbgGIISPackPlanCover.url = contextPath + "/GIISS219Controller?action=showGiiss219&refresh=1&type=package";
					tbgGIISPackPlanCover._refreshList();
					tbgGIISPlanDtl.url = contextPath + "/GIISS219Controller?action=showGiiss219&refresh=1&type=package";
					tbgGIISPlanDtl._refreshList();
					disableButton("btnAddPackPlanCover");
					disableButton("btnAddPlanDtl");
					enableDisableFields(["giiss219FormDiv3","giiss219FormDiv2"], "disable");
				} else if(unfocusMode == "giisPackPlanCover") {
					tbgGIISPlanDtl.url = contextPath + "/GIISS219Controller?action=showGiiss219&refresh=1&type=package";
					tbgGIISPlanDtl._refreshList();
					disableButton("btnAddPlanDtl");
					enableDisableFields(["giiss219FormDiv3"], "disable");
				} 
			}
		} catch (e) {
			showErrorMessage("showPageBlock",e);
		}
	}
	function setFieldValues(rec,type,mode){
		try{
			if (type == "regular") {
				if (mode == "giisPlan") {
					$("txtPlanCd").value = (rec == null ? "" : rec.planCd);
					$("txtPlanDesc").value = (rec == null ? "" : unescapeHTML2(rec.planDesc));
					$("txtLineCd").value = (rec == null ? "" : unescapeHTML2(rec.lineCd));
					$("txtLineName").value = (rec == null ? "" : unescapeHTML2(rec.lineName));
					$("txtLineName").setAttribute("lastValidValue", (rec == null ? "" : rec.lineName));
					$("txtSublineCd").value = (rec == null ? "" : unescapeHTML2(rec.sublineCd));
					$("txtSublineName").value = (rec == null ? "" : unescapeHTML2(rec.sublineName));
					$("txtSublineName").setAttribute("lastValidValue", (rec == null ? "" : rec.sublineName));
					$("txtPlanRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
					$("txtPlanUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
					$("txtPlanLastUpdate").value = (rec == null ? "" : rec.lastUpdate);

					rec == null ? $("txtLineName").readOnly = false : $("txtLineName").readOnly = true;
					rec == null ? enableSearch("imgLineSearch") : disableSearch("imgLineSearch");
					rec == null ? $("btnAddPlan").value = "Add" : $("btnAddPlan").value = "Update";
					rec == null ? disableButton("btnDeletePlan") : enableButton("btnDeletePlan");
					$("txtSublineName").readOnly = true;
					disableSearch("imgSublineSearch");
					objCurrGIISPlan = rec;
				}else if (mode == "giisPlanDtl") {
					$("txtPerilType").value = (rec == null ? "" : rec.perilType);
					$("txtPerilCd").value = (rec == null ? "" : unescapeHTML2(rec.perilCd));
					$("txtPerilCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.perilCd)));
					$("txtPerilName").value = (rec == null ? "" : unescapeHTML2(rec.perilName));
					$("txtPerilName").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.perilName)));
					$("txtPremRate").value = (rec == null ? "" : formatToNthDecimal(rec.premRt,9));
					$("txtPremAmt").value = (rec == null ? "" :formatCurrency(rec.premAmt));
					$("txtNoOfDays").value = (rec == null ? "" : rec.noOfDays);
					$("txtBaseAmt").value = (rec == null ? "" : formatCurrency(rec.baseAmt));
					$("txtTsiAmt").value = (rec == null ? "" : formatCurrency(rec.tsiAmt));
					$("chkAggregateSw").checked = (rec == null ? false : rec.aggregateSw == 'Y' ? true : false);
					$("txtPlanDtlUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
					$("txtPlanDtlLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
					
					rec == null ? $("btnAddPlanDtl").value = "Add" : $("btnAddPlanDtl").value = "Update";
					rec == null ? $("txtPerilName").readOnly = false : $("txtPerilName").readOnly = true;
					rec == null ? enableSearch("imgPerilNameSearch") : disableSearch("imgPerilNameSearch");
					rec == null ? disableButton("btnDeletePlanDtl") : enableButton("btnDeletePlanDtl");
					objCurrGIISPlanDtl = rec;
				}
			} else {
				if (mode == "giisPackPlan") {
					$("txtPlanCd").value = (rec == null ? "" : rec.planCd);
					$("txtPlanDesc").value = (rec == null ? "" : unescapeHTML2(rec.planDesc));
					$("txtLineCd").value = (rec == null ? "" : unescapeHTML2(rec.packLineCd));
					$("txtLineName").value = (rec == null ? "" : unescapeHTML2(rec.lineName));
					$("txtLineName").setAttribute("lastValidValue", (rec == null ? "" : rec.lineName));
					$("txtSublineCd").value = (rec == null ? "" : unescapeHTML2(rec.packSublineCd));
					$("txtSublineName").value = (rec == null ? "" : unescapeHTML2(rec.sublineName));
					$("txtSublineName").setAttribute("lastValidValue", (rec == null ? "" : rec.sublineName));
					$("txtPlanUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
					$("txtPlanLastUpdate").value = (rec == null ? "" : rec.lastUpdate);

					rec == null ? $("txtLineName").readOnly = false : $("txtLineName").readOnly = true;
					rec == null ? enableSearch("imgLineSearch") : disableSearch("imgLineSearch");
					rec == null ? $("btnAddPlan").value = "Add" : $("btnAddPlan").value = "Update";
					rec == null ? disableButton("btnDeletePlan") : enableButton("btnDeletePlan");
					$("txtSublineName").readOnly = true;
					disableSearch("imgSublineSearch");
					objCurrGIISPlan = rec;
				} else if(mode == "giisPackPlanCover") {
					$("txtPackPlanCoverLineCd").value = (rec == null ? "" : unescapeHTML2(rec.packLineCd));
					$("txtPackPlanCoverLineCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.packLineCd)));
					$("txtPackPlanCoverLineName").value = (rec == null ? "" : unescapeHTML2(rec.lineName));
					$("txtPackPlanCoverSublineCd").value = (rec == null ? "" : unescapeHTML2(rec.packSublineCd));
					$("txtPackPlanCoverSublineCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.packSublineCd)));
					$("txtPackPlanCoverSublineName").value = (rec == null ? "" : unescapeHTML2(rec.sublineName));
					$("txtPackPlanCoverUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
					$("txtPackPlanCoverLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
					
					rec == null ? $("txtPackPlanCoverLineCd").readOnly = false : $("txtPackPlanCoverLineCd").readOnly = true;
					rec == null ? enableSearch("imgPackPlanCoverLineSearch") : disableSearch("imgPackPlanCoverLineSearch");
					$("txtPackPlanCoverSublineCd").readOnly = true;
					disableSearch("imgPackPlanCoverSublineSearch");
					rec == null ? enableButton("btnAddPackPlanCover") : disableButton("btnAddPackPlanCover");
					rec == null ? disableButton("btnDeletePackPlanCover") : enableButton("btnDeletePackPlanCover");
					objCurrGIISPackPlanCover = rec;
				} else if(mode == "giisPackPlanCoverDtl") {
					$("txtPerilType").value = (rec == null ? "" : rec.perilType);
					$("txtPerilCd").value = (rec == null ? "" : unescapeHTML2(rec.perilCd));
					$("txtPerilCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.perilCd)));
					$("txtPerilName").value = (rec == null ? "" : unescapeHTML2(rec.perilName));
					$("txtPerilName").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.perilName)));
					$("txtPremRate").value = (rec == null ? "" : formatToNthDecimal(rec.premRt,9));
					$("txtPremAmt").value = (rec == null ? "" :formatCurrency(rec.premAmt));
					$("txtNoOfDays").value = (rec == null ? "" : rec.noOfDays);
					$("txtBaseAmt").value = (rec == null ? "" : formatCurrency(rec.baseAmt));
					$("txtTsiAmt").value = (rec == null ? "" : formatCurrency(rec.tsiAmt));
					$("chkAggregateSw").checked = (rec == null ? false : rec.aggregateSw == 'Y' ? true : false);
					$("txtPlanDtlUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
					$("txtPlanDtlLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
					
					rec == null ? $("btnAddPlanDtl").value = "Add" : $("btnAddPlanDtl").value = "Update";
					rec == null ? $("txtPerilName").readOnly = false : $("txtPerilName").readOnly = true;
					rec == null ? enableSearch("imgPerilNameSearch") : disableSearch("imgPerilNameSearch");
					rec == null ? disableButton("btnDeletePlanDtl") : enableButton("btnDeletePlanDtl");
					objCurrGIISPlanDtl = rec;
				} 
			}
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec,type,mode){
		try {
			var obj = (rec == null ? {} : rec);
			if (type == "regular") {
				if (mode == "giisPlan") {
					obj.planCd = $("txtPlanCd").value;
					obj.planDesc = escapeHTML2($F("txtPlanDesc"));
					obj.lineCd = escapeHTML2($F("txtLineCd"));
					obj.lineName= escapeHTML2($F("txtLineName"));
					obj.sublineCd = escapeHTML2($F("txtSublineCd"));
					obj.sublineName=escapeHTML2($F("txtSublineName"));
					obj.remarks = escapeHTML2($F("txtPlanRemarks"));
					obj.userId = userId;
					var lastUpdate = new Date();
					obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
				}else if (mode == "giisPlanDtl") {
					obj.perilType = $("txtPerilType").value;
					obj.planCd = $("txtPlanCd").value;
					obj.perilCd = escapeHTML2($F("txtPerilCd"));
					obj.perilName = escapeHTML2($F("txtPerilName"));
					obj.premRt = $F("txtPremRate");
					obj.premAmt = unformatCurrency($("txtPremAmt"));
					obj.noOfDays=unformatCurrency($("txtNoOfDays"));
					obj.baseAmt = unformatValueToString($F("txtBaseAmt"));
					obj.tsiAmt = unformatValueToString($F("txtTsiAmt"));
					obj.lineCd = $F("txtLineCd");
					obj.aggregateSw = $("chkAggregateSw").checked ? 'Y' : 'N';
					obj.userId = userId;
					var lastUpdate = new Date();
					obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
				}
			} else {
				if (mode == "giisPackPlan") {
					obj.planCd = $("txtPlanCd").value;
					obj.planDesc = escapeHTML2($F("txtPlanDesc"));
					obj.packLineCd = escapeHTML2($F("txtLineCd"));
					obj.lineName= escapeHTML2($F("txtLineName"));
					obj.packSublineCd = escapeHTML2($F("txtSublineCd"));
					obj.sublineName=escapeHTML2($F("txtSublineName"));
					obj.remarks = escapeHTML2($F("txtPlanRemarks"));
					obj.userId = userId;
					var lastUpdate = new Date();
					obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
				} else if(mode == "giisPackPlanCover") {
					obj.planCd = $("txtPlanCd").value;
					obj.packLineCd =escapeHTML2($F("txtPackPlanCoverLineCd"));
					obj.lineName =escapeHTML2($F("txtPackPlanCoverLineName"));
					obj.packSublineCd= escapeHTML2($F("txtPackPlanCoverSublineCd"));
					obj.sublineName=escapeHTML2($F("txtPackPlanCoverSublineName"));
					obj.userId = userId;
					var lastUpdate = new Date();
					obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
				} else if(mode == "giisPackPlanCoverDtl") {
					obj.perilType = $("txtPerilType").value;
					obj.planCd = $("txtPlanCd").value;
					obj.perilCd = escapeHTML2($F("txtPerilCd"));
					obj.perilName = escapeHTML2($F("txtPerilName"));
					obj.premRt = $F("txtPremRate");
					obj.premAmt = unformatCurrency($("txtPremAmt"));
					obj.noOfDays=$F("txtNoOfDays");
					obj.baseAmt = unformatValueToString($F("txtBaseAmt"));
					obj.tsiAmt = unformatValueToString($F("txtTsiAmt"));
					obj.packLineCd =escapeHTML2($F("txtPackPlanCoverLineCd"));
					obj.packSublineCd= escapeHTML2($F("txtPackPlanCoverSublineCd"));
					obj.aggregateSw = $("chkAggregateSw").checked ? 'Y' : 'N';
					obj.userId = userId;
					var lastUpdate = new Date();
					obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
				} 
			}
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(type, mode){
		try {
			changeTagFunc = saveGiiss219;
			if (type == "regular") {
				if (mode == "giisPlan") {
					var dept = setRec(objCurrGIISPlan, type, mode);
					if($F("btnAddPlan") == "Add"){
						tbgGIISPlan.addBottomRow(dept);
					} else {
						if (changeTagPlanDtl == 1) {
							showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
								$("btnSave").focus();
							});
							return;
						} else {
							tbgGIISPlan.updateVisibleRowOnly(dept, rowIndexPlan, false); 
							showPageBlock(type, null, mode);
						}
					}
					giiss219Array.giisPlan = tbgGIISPlan.geniisysRows;
					changeTag = 1;
					changeTagPlan = 1;
					setFieldValues(null, type, mode);
					tbgGIISPlan.keys.removeFocus(tbgGIISPlan.keys._nCurrentFocus, true);
					tbgGIISPlan.keys.releaseKeys();
				}else if (mode == "giisPlanDtl") {
					var dept = null;
					if($F("btnAddPlanDtl") == "Add"){
						dept = setRec(objCurrGIISPlanDtl, type, mode);
						var premAmt = parseFloat(nvl(dept.premAmt,0));
						var tsiAmt = 0;
						if (dept.perilType === "B") {
							tsiAmt = parseFloat(nvl(dept.tsiAmt,0));
						}
						computeTotalPremAmountInTable(premAmt);
						computeTSIInTable(tsiAmt, "0", "add");
						tbgGIISPlanDtl.addBottomRow(dept);
					} else {
						dept = setRec(null, type, mode);
						var premAmt = parseFloat(nvl(dept.premAmt,0)) - parseFloat(nvl(tbgGIISPlanDtl.geniisysRows[rowIndexPlanDtl].premAmt,0));
						if (dept.perilType === "B") {
							computeTSIInTable(dept.tsiAmt, tbgGIISPlanDtl.geniisysRows[rowIndexPlanDtl].tsiAmt, "update");
						}
						computeTotalPremAmountInTable(premAmt);
						dept = setRec(objCurrGIISPlanDtl, type, mode);
						tbgGIISPlanDtl.updateVisibleRowOnly(dept, rowIndexPlanDtl, false); 
					}
					giiss219Array.giisPlan[rowIndexPlan].giisPlanDtl = tbgGIISPlanDtl.geniisysRows;
					changeTag = 1;
					changeTagPlanDtl = 1;
					setFieldValues(null, type, mode);
					tbgGIISPlanDtl.keys.removeFocus(tbgGIISPlanDtl.keys._nCurrentFocus, true);
					tbgGIISPlanDtl.keys.releaseKeys();
				}
			} else {
				if (mode == "giisPackPlan") {
					var dept = setRec(objCurrGIISPlan, type, mode);
					if($F("btnAddPlan") == "Add"){
						tbgGIISPlan.addBottomRow(dept);
					} else {
						if (changeTagPackPlanCover == 1 || changeTagPlanDtl == 1) {
							showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
								$("btnSave").focus();
							});
							return;
						} else {
							tbgGIISPlan.updateVisibleRowOnly(dept, rowIndexPlan, false); 
							showPageBlock(type, null, mode);
						}
					}
					giiss219Array.giisPackPlan = tbgGIISPlan.geniisysRows;
					changeTag = 1;
					changeTagPlan = 1;
					setFieldValues(null, type, mode);
					tbgGIISPlan.keys.removeFocus(tbgGIISPlan.keys._nCurrentFocus, true);
					tbgGIISPlan.keys.releaseKeys();
				} else if(mode == "giisPackPlanCover") {
					var dept = setRec(objCurrGIISPackPlanCover, type, mode);
					tbgGIISPackPlanCover.addBottomRow(dept);
					giiss219Array.giisPackPlan[rowIndexPlan].giisPackPlanCover = tbgGIISPackPlanCover.geniisysRows;
					changeTag = 1;
					changeTagPackPlanCover = 1;
					setFieldValues(null, type, mode);
					tbgGIISPackPlanCover.keys.removeFocus(tbgGIISPackPlanCover.keys._nCurrentFocus, true);
					tbgGIISPackPlanCover.keys.releaseKeys();
				} else if(mode == "giisPackPlanCoverDtl") {
					var dept = null;
					if($F("btnAddPlanDtl") == "Add"){
						dept = setRec(objCurrGIISPlanDtl, type, mode);
						var premAmt = parseFloat(nvl(dept.premAmt,0));
						var tsiAmt = 0;
						if (dept.perilType === "B") {
							tsiAmt = parseFloat(nvl(dept.tsiAmt,0));
						}
						computeTotalPremAmountInTable(premAmt);
						computeTSIInTable(tsiAmt, "0", "add");
						tbgGIISPlanDtl.addBottomRow(dept);
					} else {
						dept = setRec(null, type, mode);
						var premAmt = parseFloat(nvl(dept.premAmt,0)) - parseFloat(nvl(tbgGIISPlanDtl.geniisysRows[rowIndexPlanDtl].premAmt,0));
						if (dept.perilType === "B") {
							computeTSIInTable(dept.tsiAmt, tbgGIISPlanDtl.geniisysRows[rowIndexPlanDtl].tsiAmt, "update");
						}
						computeTotalPremAmountInTable(premAmt);
						dept = setRec(objCurrGIISPlanDtl, type, mode);
						tbgGIISPlanDtl.updateVisibleRowOnly(dept, rowIndexPlanDtl, false); 
					}
					giiss219Array.giisPackPlan[rowIndexPlan].giisPackPlanCover[rowIndexPackPlanCover].giisPackPlanCoverDtl = tbgGIISPlanDtl.geniisysRows;
					changeTag = 1;
					changeTagPlanDtl = 1;
					setFieldValues(null, type, mode);
					tbgGIISPlanDtl.keys.removeFocus(tbgGIISPlanDtl.keys._nCurrentFocus, true);
					tbgGIISPlanDtl.keys.releaseKeys();
				} 
			}
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddUpdateRec(type,mode,toDo) {
		try {
			var addedSameExists = false;
			var deletedSameExists = false;	
			if (type == "regular") {
				if (mode == "giisPlan") {
					addRec(type, mode);
				}else if (mode == "giisPlanDtl") {
					if (toDo == "add") {
						for(var i=0; i<tbgGIISPlanDtl.geniisysRows.length; i++){
							if(tbgGIISPlanDtl.geniisysRows[i].recordStatus == 0 || tbgGIISPlanDtl.geniisysRows[i].recordStatus == 1){								
								if(tbgGIISPlanDtl.geniisysRows[i].perilCd == $F("txtPerilCd")){
									addedSameExists = true;								
								}							
							} else if(tbgGIISPlanDtl.geniisysRows[i].recordStatus == -1){
								if(tbgGIISPlanDtl.geniisysRows[i].perilCd == $F("txtPerilCd")){
									deletedSameExists = true;
								}
							}
						}
						if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
							showMessageBox("Record already exists with the same peril_cd.", "E");
							return;
						} else if(deletedSameExists && !addedSameExists){
							addRec(type, mode);
							return;
						}
						new Ajax.Request(contextPath + "/GIISS219Controller", {
							parameters : {action : "valAddRec",
										  packLineCd : null,
								          packSublineCd : null,
										  recId : $F("txtPerilCd"),
										  recId2 : $F("txtPlanCd"),
										  mode : mode},
							onCreate : showNotice("Processing, please wait..."),
							onComplete : function(response){
								hideNotice();
								if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
									addRec(type, mode);
								}
							}
						});
					} else {
						addRec(type, mode);
					}
				}
			} else {
				if (mode == "giisPackPlan") {
					addRec(type, mode);
				} else if(mode == "giisPackPlanCover") {
					for(var i=0; i<tbgGIISPackPlanCover.geniisysRows.length; i++){
						if(tbgGIISPackPlanCover.geniisysRows[i].recordStatus == 0 || tbgGIISPackPlanCover.geniisysRows[i].recordStatus == 1){								
							if(unescapeHTML2(tbgGIISPackPlanCover.geniisysRows[i].packLineCd) == $F("txtPackPlanCoverLineCd") && unescapeHTML2(tbgGIISPackPlanCover.geniisysRows[i].packSublineCd) == $F("txtPackPlanCoverSublineCd")){
								addedSameExists = true;								
							}							
						} else if(tbgGIISPackPlanCover.geniisysRows[i].recordStatus == -1){
							if(unescapeHTML2(tbgGIISPackPlanCover.geniisysRows[i].packLineCd) == $F("txtPackPlanCoverLineCd") && unescapeHTML2(tbgGIISPackPlanCover.geniisysRows[i].packSublineCd) == $F("txtPackPlanCoverSublineCd")){
								deletedSameExists = true;
							}
						}
					}
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same pack_line_cd and pack_subline_cd.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec(type, mode);
						return;
					}
					new Ajax.Request(contextPath + "/GIISS219Controller", {
						parameters : {action : "valAddRec",
									  packLineCd : $F("txtPackPlanCoverLineCd"),
							          packSublineCd : $F("txtPackPlanCoverSublineCd"),
									  recId : null,
									  recId2 : $F("txtPlanCd"),
									  mode : mode},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								addRec(type, mode);
							}
						}
					});
				} else if(mode == "giisPackPlanCoverDtl") {
					if (toDo == "add") {
						for(var i=0; i<tbgGIISPlanDtl.geniisysRows.length; i++){
							if(tbgGIISPlanDtl.geniisysRows[i].recordStatus == 0 || tbgGIISPlanDtl.geniisysRows[i].recordStatus == 1){								
								if(tbgGIISPlanDtl.geniisysRows[i].perilCd == $F("txtPerilCd")){
									addedSameExists = true;								
								}							
							} else if(tbgGIISPlanDtl.geniisysRows[i].recordStatus == -1){
								if(tbgGIISPlanDtl.geniisysRows[i].perilCd == $F("txtPerilCd")){
									deletedSameExists = true;
								}
							}
						}
						if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
							showMessageBox("Record already exists with the same peril_cd.", "E");
							return;
						} else if(deletedSameExists && !addedSameExists){
							addRec(type, mode);
							return;
						}
						new Ajax.Request(contextPath + "/GIISS219Controller", {
							parameters : {action : "valAddRec",
										  packLineCd : $F("txtPackPlanCoverLineCd"),
						          		  packSublineCd : $F("txtPackPlanCoverSublineCd"),
										  recId : $F("txtPerilCd"),
										  recId2 : $F("txtPlanCd"),
										  mode : mode},
							onCreate : showNotice("Processing, please wait..."),
							onComplete : function(response){
								hideNotice();
								if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
									addRec(type, mode);
								}
							}
						});
					} else {
						addRec(type, mode);
					}
				} 
			}
		} catch (e) {
			showErrorMessage("valAddUpdateRec",e);
		}
	}
	
	function valAddRec(type,mode){
		try{
			if (type == "regular") {
				if (mode == "giisPlan") {
					if(checkAllRequiredFieldsInDiv("giiss219FormDiv")){
						if($F("btnAddPlan") == "Add") {
							valAddUpdateRec(type, mode, "add");
						} else {
							valAddUpdateRec(type, mode, "update");
						}
					}
				}else if (mode == "giisPlanDtl") {
					if(checkAllRequiredFieldsInDiv("giiss219FormDiv3")){
						if ($F("txtPremRate").trim() == "" && $F("txtPremAmt").trim() == "") {
							showMessageBox("Please enter the premium rate or premium amount.","I");
							return;
						}
						if($F("btnAddPlanDtl") == "Add") {
							valAddUpdateRec(type, mode, "add");
						} else {
							valAddUpdateRec(type, mode, "update");
						}
					}
				}
			} else {
				if (mode == "giisPackPlan") {
					if(checkAllRequiredFieldsInDiv("giiss219FormDiv")){
						if($F("btnAddPlan") == "Add") {
							valAddUpdateRec(type, mode, "add");
						} else {
							valAddUpdateRec(type, mode, "update");
						}
					}
				} else if(mode == "giisPackPlanCover") {
					if(checkAllRequiredFieldsInDiv("giiss219FormDiv2")){
						valAddUpdateRec(type, mode, "add");
					}
				} else if(mode == "giisPackPlanCoverDtl") {
					if(checkAllRequiredFieldsInDiv("giiss219FormDiv3")){
						if ($F("txtPremRate").trim() == "" && $F("txtPremAmt").trim() == "") {
							showMessageBox("Please enter the premium rate or premium amount.","I");
							return;
						}
						if($F("btnAddPlanDtl") == "Add") {
							valAddUpdateRec(type, mode, "add");
						} else {
							valAddUpdateRec(type, mode, "update");
						}
					}
				} 
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}	
	
	function deleteRec(type, mode){
		changeTagFunc = saveGiiss219;
		if (type == "regular") {
			if (mode == "giisPlan") {
				objCurrGIISPlan.recordStatus = -1;
				tbgGIISPlan.deleteRow(rowIndexPlan); 
				giiss219Array.giisPlan = tbgGIISPlan.geniisysRows;
				changeTag = 1;
				changeTagPlan = 1;
				showPageBlock(type, null, mode);
			}else if (mode == "giisPlanDtl") {
				objCurrGIISPlanDtl.recordStatus = -1;
				var premAmt = -1*parseFloat(nvl(tbgGIISPlanDtl.geniisysRows[rowIndexPlanDtl].premAmt,0));
				if (tbgGIISPlanDtl.geniisysRows[rowIndexPlanDtl].perilType === "B") {
					computeTSIInTable(tbgGIISPlanDtl.geniisysRows[rowIndexPlanDtl].tsiAmt, "0", "delete");
				}
				computeTotalPremAmountInTable(premAmt);
				tbgGIISPlanDtl.deleteRow(rowIndexPlanDtl); 
				giiss219Array.giisPlan[rowIndexPlan].giisPlanDtl = tbgGIISPlanDtl.geniisysRows;
				changeTag = 1;
				changeTagPlanDtl = 1;
			}
		} else {
			if (mode == "giisPackPlan") {
				objCurrGIISPlan.recordStatus = -1;
				tbgGIISPlan.deleteRow(rowIndexPlan); 
				giiss219Array.giisPackPlan = tbgGIISPlan.geniisysRows;
				changeTag = 1;
				changeTagPlan = 1;
				showPageBlock(type, null, mode);
			} else if(mode == "giisPackPlanCover") {
				objCurrGIISPackPlanCover.recordStatus = -1;
				tbgGIISPackPlanCover.deleteRow(rowIndexPackPlanCover); 
				giiss219Array.giisPackPlan[rowIndexPlan].giisPackPlanCover = tbgGIISPackPlanCover.geniisysRows;
				changeTag = 1;
				changeTagPlan = 1;
				showPageBlock(type, null, mode);
			} else if(mode == "giisPackPlanCoverDtl") {
				objCurrGIISPlanDtl.recordStatus = -1;
				var premAmt = -1*parseFloat(nvl(tbgGIISPlanDtl.geniisysRows[rowIndexPlanDtl].premAmt,0));
				if (tbgGIISPlanDtl.geniisysRows[rowIndexPlanDtl].perilType === "B") {
					computeTSIInTable(tbgGIISPlanDtl.geniisysRows[rowIndexPlanDtl].tsiAmt, "0", "delete");
				}
				computeTotalPremAmountInTable(premAmt);
				tbgGIISPlanDtl.deleteRow(rowIndexPlanDtl); 
				giiss219Array.giisPackPlan[rowIndexPlan].giisPackPlanCover[rowIndexPackPlanCover].giisPackPlanCoverDtl  = tbgGIISPlanDtl.geniisysRows;
				changeTag = 1;
				changeTagPlanDtl = 1;
			} 
		}
		setFieldValues(null, type, mode);
	}
	
	function valDeleteRec(type, mode){
		try{
			new Ajax.Request(contextPath + "/GIISS219Controller", {
				parameters : {action : "valDeleteRec",
					 		  packLineCd : $F("txtPackPlanCoverLineCd"),
	          		 		  packSublineCd : $F("txtPackPlanCoverSublineCd"),
					  		  recId : $F("txtPlanCd")},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						deleteRec(type, mode);
					}
				}
			});
		} catch(e){
			showErrorMessage("valDeleteRec", e);
		}
	}

	function exitPage(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", "");	
	}	
	
	function cancelGiiss219(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS219.exitPage = exitPage;
						saveGiiss219();
					}, function(){
						goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", "");	
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", "");	
		}
	}
	
	function setCurrentTab(id){
		$$("div.tabComponents1 a").each(function(a){
			if(a.id == id) {
				$(id).up("li").addClassName("selectedTab1");					
			}else{
				a.up("li").removeClassName("selectedTab1");	
			}	
		});
	}
	
	function showGiiss219Tab(type) {
		try {
			toShowIntTab = true;
			objGIISS219.type = type;
			if (type == "regular") {
				$("trRemarks").show();
				$("giiss219Block2").hide();
				$("trLineName").innerHTML = "Line";
				$("trSublineName").innerHTML = "Subline";
				$("block1").innerHTML = "Plan Maintenance";
				$("block3").innerHTML = "Plan Detail Maintenance";
				initializePlanTbg(type, "giisPlan");
			} else {
				$("giiss219Block2").show();
				$("trRemarks").hide();
				$("trLineName").innerHTML = "Package Line";
				$("trSublineName").innerHTML = "Package Subline";
				$("block1").innerHTML = "Package Plan Maintenance";
				$("block3").innerHTML = "Package Plan Cover Detail Maintenance";
				initializePlanTbg(type, "giisPackPlan");
			}
			resetAllFields();
		} catch (e) {
			showErrorMessage("showGiiss219Tab",e);
		}
	}
	
	function unformatValueToString(value) {
		try{
			value = nvl(value, "");
			var unformattedValue = "";	
			if (value.replace(/,/g, "") != "" && !isNaN(parseFloat(value.replace(/,/g, "")))){
				unformattedValue = value.replace(/,/g, "");
			}
			return unformattedValue;	
		}catch(e){
			showErrorMessage("unformatValueToString", e);
		}	
	}
	
	observeSaveForm("btnSave", saveGiiss219);
	$("btnCancel").observe("click", cancelGiiss219);
	
	$("tabRegular").observe("click", function(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveGiiss219();
						showGiiss219Tab("regular");
						setCurrentTab("tabRegular");
					}, function(){
						showGiiss219Tab("regular");
						setCurrentTab("tabRegular");
					}, "");
		} else {
			showGiiss219Tab("regular");
			setCurrentTab("tabRegular");
		}
	});
	
	$("tabPackage").observe("click", function(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
				        saveGiiss219();
						showGiiss219Tab("package");
						setCurrentTab("tabPackage");
					}, function(){
						showGiiss219Tab("package");
						setCurrentTab("tabPackage");
					}, "");
		} else {
			showGiiss219Tab("package");
			setCurrentTab("tabPackage");
		}
	});
	
	$("imgLineSearch").observe("click",showGIISS219LineLOV);
	$("imgSublineSearch").observe("click",showGIISS219SublineLOV);
	$("imgPackPlanCoverLineSearch").observe("click",showGIISS219PackLineLOV);
	$("imgPackPlanCoverSublineSearch").observe("click",showGIISS219PackSublineLOV);
	$("imgPerilNameSearch").observe("click",function(){
		if (objGIISS219.type == "regular") {
			showGIISS219PerilLOV($F("txtLineCd"), $F("txtSublineCd"));
		} else {
			showGIISS219PerilLOV($F("txtPackPlanCoverLineCd"), $F("txtPackPlanCoverSublineCd"));
		}
	});
	
	$("txtLineName").observe("change", function() {
		if($F("txtLineName").trim() == "") {
			$("txtLineCd").clear();
			$("txtLineName").clear();
			$("txtLineCd").setAttribute("lastValidValue", "");
			$("txtLineName").setAttribute("lastValidValue", "");
			$("txtSublineCd").clear();
			$("txtSublineName").clear();
			$("txtSublineName").setAttribute("lastValidValue", "");
			$("txtSublineCd").setAttribute("lastValidValue", "");
			$("txtSublineName").readOnly = true;
			disableSearch("imgSublineSearch");
		} else {
			if($F("txtLineName").trim() != "" && $F("txtLineName") != unescapeHTML2($("txtLineName").readAttribute("lastValidValue"))) {
				showGIISS219LineLOV();
			}
		}
	});
	$("txtSublineName").observe("change", function() {
		if($F("txtSublineName").trim() == "") {
			$("txtSublineCd").clear();
			$("txtSublineName").clear();
			$("txtSublineCd").setAttribute("lastValidValue", "");
			$("txtSublineName").setAttribute("lastValidValue", "");
		} else {
			if($F("txtSublineName").trim() != "" && $F("txtSublineName") != unescapeHTML2($("txtSublineName").readAttribute("lastValidValue"))) {
				showGIISS219SublineLOV();
			}
		}
	});
	$("txtPackPlanCoverLineCd").observe("change", function() {
		if($F("txtPackPlanCoverLineCd").trim() == "") {
			$("txtPackPlanCoverLineCd").clear();
			$("txtPackPlanCoverLineName").clear();
			$("txtPackPlanCoverLineCd").setAttribute("lastValidValue", "");
			$("txtPackPlanCoverLineName").setAttribute("lastValidValue", "");
			$("txtPackPlanCoverSublineCd").clear();
			$("txtPackPlanCoverSublineName").clear();
			$("txtPackPlanCoverSublineCd").setAttribute("lastValidValue", "");
			$("txtPackPlanCoverSublineName").setAttribute("lastValidValue", "");
			$("txtPackPlanCoverSublineCd").readOnly = true;
			disableSearch("imgPackPlanCoverSublineSearch");
		} else {
			if($F("txtPackPlanCoverLineCd").trim() != "" && $F("txtPackPlanCoverLineCd") != $("txtPackPlanCoverLineCd").readAttribute("lastValidValue")) {
				showGIISS219PackLineLOV();
			}
		}
	});
	$("txtPackPlanCoverSublineCd").observe("change", function() {
		if($F("txtPackPlanCoverSublineCd").trim() == "") {
			$("txtPackPlanCoverSublineCd").clear();
			$("txtPackPlanCoverSublineName").clear();
			$("txtPackPlanCoverSublineCd").setAttribute("lastValidValue", "");
			$("txtPackPlanCoverSublineName").setAttribute("lastValidValue", "");
		} else {
			if($F("txtPackPlanCoverSublineCd").trim() != "" && $F("txtPackPlanCoverSublineCd") != $("txtPackPlanCoverSublineCd").readAttribute("lastValidValue")) {
				showGIISS219PackSublineLOV();
			}
		}
	});
	$("txtPerilName").observe("change", function() {
		if($F("txtPerilName").trim() == "") {
			$("txtPerilType").clear();
			$("txtPerilName").clear();
			$("txtPerilCd").clear();
			$("txtPerilName").setAttribute("lastValidValue", "");
			$("txtPerilCd").setAttribute("lastValidValue", "");
		} else {
			if($F("txtPerilName").trim() != "" && $F("txtPerilName") != $("txtPerilName").readAttribute("lastValidValue")) {
				if (objGIISS219.type == "regular") {
					showGIISS219PerilLOV($F("txtLineCd"), $F("txtSublineCd"));
				} else {
					showGIISS219PerilLOV($F("txtPackPlanCoverLineCd"), $F("txtPackPlanCoverSublineCd"));
				}
			}
		}
	});
	
	
	$("txtPlanDesc").observe("keyup", function(){
		$("txtPlanDesc").value = $F("txtPlanDesc").toUpperCase();
	});
	
	$("editPlanRemarks").observe("click", function(){
		showOverlayEditor("txtPlanRemarks", 4000, $("txtPlanRemarks").hasAttribute("readonly"));
	});
	$("btnAddPlan").observe("click", function() {
		var mode = objGIISS219.type == "regular" ? "giisPlan" : "giisPackPlan"; 
		valAddRec(objGIISS219.type, mode);
	}); 
	$("btnAddPackPlanCover").observe("click", function() {
		valAddRec(objGIISS219.type, "giisPackPlanCover");
	}); 
	$("btnAddPlanDtl").observe("click", function() {
		var mode = objGIISS219.type == "regular" ? "giisPlanDtl" : "giisPackPlanCoverDtl"; 
		valAddRec(objGIISS219.type, mode);
	}); 
	$("btnDeletePlan").observe("click", function () {
		var mode = objGIISS219.type == "regular" ? "giisPlan" : "giisPackPlan"; 
		deleteRec(objGIISS219.type, mode);
	});
	$("btnDeletePackPlanCover").observe("click", function () {
		valDeleteRec(objGIISS219.type,"giisPackPlanCover");
	});
	$("btnDeletePlanDtl").observe("click", function () {
		var mode = objGIISS219.type == "regular" ? "giisPlanDtl" : "giisPackPlanCoverDtl"; 
		deleteRec(objGIISS219.type, mode);
	});
	
	$("giiss219Exit").stopObserving("click");
	$("giiss219Exit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	$("txtPlanDesc").focus();	
	resetAllFields();
	initializePlanTbg("regular", "giisPlan");
</script>
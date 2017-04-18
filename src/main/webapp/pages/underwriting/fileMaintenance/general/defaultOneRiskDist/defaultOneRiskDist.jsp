<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss065MainDiv" name="giiss065MainDiv">
	<div id="giiss065MenuDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="menuFileMaintenanceExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Default One Risk Distribution Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
	   			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>
	<div id="giisDefaultDistDiv" name="giisDefaultDistDiv">
		<div class="sectionDiv">
			<div id="giisDefaultDistTableDiv" style="padding-top: 10px;" align="center">
				<div id="giisDefaultDistTable" style="height: 335px; margin-left: 10px;"></div>
			</div>
			<div align="center" id="giisDefaultDistFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Default No.</td>
						<td class="leftAligned">
							<input id="txtDefaultNo" type="text" style="width: 267px; text-align: right;" tabindex="201" readonly="readonly">
						</td>
						<td class="rightAligned">Issuing Source</td>
						<td class="leftAligned">
							<span class="lovSpan required" style="float: left; width: 60px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required" ignoreDelKey="" type="text" id="txtIssCd" name="txtIssCd" style="width: 35px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="202" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchIssuance" name="imgSearchIssuance" alt="Go" style="float: right;">
							</span>
							<input id="txtDspIssName" name="txtDspIssName" readonly="readonly" type="text" style="width: 200px;" tabindex="203"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Line</td>
						<td class="leftAligned">
							<span class="lovSpan required" style="float: left; width: 60px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required" ignoreDelKey="" type="text" id="txtLineCd" name="txtLineCd" style="width: 35px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="204" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchLine" name="imgSearchLine" alt="Go" style="float: right;">
							</span>
							<input id="txtDspLineName" name="txtDspLineName" readonly="readonly" type="text" style="width: 200px;" tabindex="205"/>
						</td>
						<td class="rightAligned">Default Dist. Type</td>
						<td class="leftAligned">
							<span class="lovSpan required" style="float: left; width: 60px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required" ignoreDelKey="" type="text" id="txtDistType" name="txtDistType" style="width: 35px; float: left; border: none; height: 15px; margin: 0; text-align: left;" maxlength="1" tabindex="206" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchDistType" name="imgSearchDistType" alt="Go" style="float: right;">
							</span>
							<input id="txtDspDistName" name="txtDspDistName" readonly="readonly" type="text" style="width: 200px;" tabindex="207"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Subline</td>
						<td class="leftAligned">
							<span class="lovSpan required" style="float: left; width: 60px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required" ignoreDelKey="" type="text" id="txtSublineCd" name="txtSublineCd" style="width: 35px; float: left; border: none; height: 15px; margin: 0;" maxlength="7" tabindex="208" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchSubline" name="imgSearchSubline" alt="Go" style="float: right;">
							</span>
							<input id="txtDspSublineName" name="txtDspSublineName" readonly="readonly" type="text" style="width: 200px;" tabindex="209"/>
						</td>
						<td class="rightAligned">Default Type</td>
						<td class="leftAligned">
							<span class="lovSpan required" style="float: left; width: 60px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required" ignoreDelKey="" type="text" id="txtDefaultType" name="txtDefaultType" style="width: 35px; float: left; border: none; height: 15px; margin: 0; text-align: left;" maxlength="1" tabindex="210" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchDefaultType" name="imgSearchDefaultType" alt="Go" style="float: right;">
							</span>
							<input id="txtDspDefaultName" name="txtDspDefaultName" readonly="readonly" type="text" style="width: 200px;" tabindex="211"/>
						</td>
					</tr>
				</table>
			</div>
			<div style="margin: 10px;" align="center">
				<input type="button" class="button" id="btnAddDefaultDist" value="Add" tabindex="212">
				<input type="button" class="button" id="btnDeleteDefaultDist" value="Delete" tabindex="213">
			</div>
			<!-- <div style="margin: 10px; padding: 10px; border-top: 1px solid #E0E0E0; margin-bottom: 0;" align="center">
				<input type="button" class="button" id="btnRange" value="Range" style="width: 150px;">
			</div> --> <!-- Commented out by Jerome 08.05.2016 SR 5552 -->
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Default One Risk Detail</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label name="gro" style="margin-left: 5px;">Hide</label> 
			</span>
	   	</div>
	</div>
	<div id="giisDefaultDistDtlMainDiv" name="giisDefaultDistDtlMainDiv">
	<div id="giisDefaultDistDtl" name="giisDefaultDistDtl">
		<div class="sectionDiv">
			<div id="giisDefaultDistDtlTableDiv" style="padding-top: 10px; height: 100px;" align="center">
				<div id="giisDefaultDistDtlTable" style="height: 100px; margin-left: 180px; position:absolute"></div>
			</div>
			<div align="center" id="giisDefaultDistDtlFormDiv" style="width: 99%; margin-top: 160px; margin-left: 2px;">
				<table style="margin-top: 5px;">
					<tr>
						<td align="right">Range From</td>
						<td style="padding-left: 5px;">
							<input id="txtRangeFrom" class="money" type="text" style="width:150px; margin-bottom: 0px; text-align: right;" tabindex="601" class="applyDecimalRegExp" hasOwnKeyUp="N" hasOwnBlur="N" hasOwnChange="N" customLabel="Range From" max="999999999.99" min="0.00" regexppatt="pDeci0902" maxlength="12" lastValidValue=""/>
						</td>
						<td align="right" style="padding-left: 20px;">Range To</td>
						<td style="padding-left: 5px;">
							<input id="txtRangeTo" class="money" type="text" style="width:150px; margin-bottom: 0px; text-align: right;" tabindex="602" class="applyDecimalRegExp" hasOwnKeyUp="N" hasOwnBlur="N" hasOwnChange="N" customLabel="Range To" max="999999999.99" min="1.00" regexppatt="pDeci0902" maxlength="12" lastValidValue=""/>
						</td>
					</tr>
				</table>
			</div>
			<div align="center" style="margin: 10px;">
				<input type="button" class="button" id="btnAddRange" value="Add" tabindex="404" style="width: 80px;">
				<input type="button" class="button" id="btnDeleteRange" value="Delete" tabindex="405" style="width: 80px;">
			</div>
		</div>
	</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Default One Risk Distribution Group</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label name="gro" style="margin-left: 5px;">Hide</label> 
			</span>
	   	</div>
	</div>	
	<div id="giisDefautlDistGroupMainDiv" name="giisDefautlDistGroupMainDiv">
		<div class="sectionDiv">
			<div id="giisDefaultDistGroupTableDiv" style="padding-top: 10px;">
				<div id="giisDefaultDistGroupTable" style="height: 335px; margin-left: 110px;"></div>
			</div>
			<div align="center" id="giisDefaultDistGroupFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Sequence</td>
						<td class="leftAligned">
							<input id="txtSequence" type="text" class="" style="width: 200px; text-align: right;" tabindex="218" readonly="readonly">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Share</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan required" style="float: left; width: 85px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required integerNoNegativeUnformatted" ignoreDelKey="" type="text" id="txtShareCd" name="txtShareCd" style="width: 60px; float: left; border: none; height: 15px; margin: 0; text-align: right;" maxlength="3" tabindex="219" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchShare" name="imgSearchShare" alt="Go" style="float: right;">
							</span>
							<input id="txtDspTreatyName" name="txtDspTreatyName" readonly="readonly" type="text" style="width: 456px;" tabindex="220"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Percent Share</td>
						<td class="leftAligned">
							<input id="txtSharePct" type="text" class="nthDecimal2" style="width: 200px; text-align: right;" tabindex="221" readonly="readonly" maxlength="13" min="1" max="100" errorMsg = "Invalid Percent Share. Valid value should be from 1 to 100.">
						</td>
						<td class="rightAligned">Share Amount</td>
						<td class="leftAligned">
							<input id="txtShareAmt1" type="text" class="money4" style="width: 200px; text-align: right;" tabindex="222" readonly="readonly" maxlength="18" min="-99999999999990.99" max="99999999999990.99" errorMsg = "Invalid Share Amount. Valid value should be from -99,999,999,999,990.99 to 99,999,999,999,990.99.">
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 554px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 527px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="223"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="224"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned" style="width: 254px;"><input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="225"></td>
						<td width="" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="226"></td>
					</tr>
				</table>
			</div>
			<div style="margin: 10px;" align = "center">
				<input type="button" class="button" id="btnAddDefaultDistGroup" value="Add" tabindex="227">
				<input type="button" class="button" id="btnDeleteDefaultDistGroup" value="Delete" tabindex="228">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="229">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="230">
</div>
<input id="txtlastValidRangeFrom" type="hidden"/>
<input id="txtlastValidRangeTo" type="hidden"/>
<script type="text/javascript">
	setModuleId("GIISS065");
	setDocumentTitle("Default One Risk Distribution Maintenance");
	initializeAll();
	initializeAccordion();
	initializeAllMoneyFields();
	setGroup("N");
	
	//var objGIISS065 = {};
	var defaultDistGroupAllObj = null;
	var defaultDistAllObj = JSON.parse('${jsonGiisDefaultDistAll}');
	var defaultDistAllList = defaultDistAllObj.rows;
	var origIssCd = null;
	var origDefaultType = null;
	objGIISS065.exitPage = null;
	changeTag = 0;
	changeTagGroup = 0;
	disableButton("btnAddRange");
	disableButton("btnDeleteRange");
	
	/* Default Distribution */
	var rowIndexDefaultDist = -1;
	var objCurrDefaultDist = null;
	objGIISS065.defaultDistList = JSON.parse('${jsonGiisDefaultDist}');
	var totalPct2 = 0; //Added by Jerome SR 5552
	var updateSw = "N";
	
	var giisDefaultDistTable = {
			url : contextPath + "/GIISDefaultOneRiskController?action=showGiiss065&refresh=1",
			options : {
				width : '900px',
				hideColumnChildTitle: true,
				pager : {},
				beforeClick: function(){
					if(changeTagGroup == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
				},
				onCellFocus : function(element, value, x, y, id){
					rowIndexDefaultDist = y;
					objCurrDefaultDist = tbgDefaultDist.geniisysRows[y];
					setFieldValuesDefaultDist(objCurrDefaultDist);
					setGroup("Y");
					tbgDefaultDist.keys.removeFocus(tbgDefaultDist.keys._nCurrentFocus, true);
					tbgDefaultDist.keys.releaseKeys();
					$("txtDefaultNo").focus();
				},
				onRemoveRowFocus : function(){
					rowIndexDefaultDist = -1;
					setFieldValuesDefaultDist(null);
					setGroup("N");
					tbgDefaultDist.keys.removeFocus(tbgDefaultDist.keys._nCurrentFocus, true);
					tbgDefaultDist.keys.releaseKeys();
					$("txtDefaultNo").focus();
				},
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndexDefaultDist = -1;
						setFieldValuesDefaultDist(null);
						setGroup("N");
						tbgDefaultDist.keys.removeFocus(tbgDefaultDist.keys._nCurrentFocus, true);
						tbgDefaultDist.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					if(changeTag == 1 || changeTagGroup == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
				},
				onSort: function(){
					rowIndexDefaultDist = -1;
					setFieldValuesDefaultDist(null);
					setGroup("N");
					tbgDefaultDist.keys.removeFocus(tbgDefaultDist.keys._nCurrentFocus, true);
					tbgDefaultDist.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndexDefaultDist = -1;
					setFieldValuesDefaultDist(null);
					setGroup("N");
					tbgDefaultDist.keys.removeFocus(tbgDefaultDist.keys._nCurrentFocus, true);
					tbgDefaultDist.keys.releaseKeys();
				},
				prePager: function(){
					if(changeTag == 1 || changeTagGroup == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
					rowIndexDefaultDist = -1;
					setFieldValuesDefaultDist(null);
					setGroup("N");
					tbgDefaultDist.keys.removeFocus(tbgDefaultDist.keys._nCurrentFocus, true);
					tbgDefaultDist.keys.releaseKeys();
				},
				checkChanges: function(){
					return (changeTag == 1 || changeTagGroup == 1 ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (changeTag == 1 || changeTagGroup == 1? true : false);
				},
				masterDetailValidation: function(){
					return (changeTag == 1 || changeTagGroup == 1? true : false);
				},
				masterDetail: function(){
					return (changeTag == 1 || changeTagGroup == 1? true : false);
				},
				masterDetailSaveFunc: function() {
					return (changeTag == 1 || changeTagGroup == 1? true : false);
				},
				masterDetailNoFunc: function(){
					return (changeTag == 1 || changeTagGroup == 1? true : false);
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
					id : "defaultNo",
					title : "Default No.",
					filterOption : true,
					align : "right",
					titleAlign : "right",
					filterOptionType : 'integerNoNegative',
					width : '65px',
					renderer : function(value){
						return nvl(value, "") == "" ? "" : formatNumberDigits(value, 9);
					}
				},
				{
					id : "dspLineName",
					title : "Line Name",
					filterOption : true,
					width : '150px'
				},
				{
					id : "dspSublineName",
					title : "Subline Name",
					filterOption : true,
					width : '170px'
				},
				{
					id : "dspIssName",
					title : "Issue Name",
					filterOption : true,
					width : '160px'
				},
				{
					id : "dspDistName",
					title : "Dist. Name",
					filterOption : true,
					width : '150px'
				},
				{
					id : "dspDefaultName",
					title : "Default Name",
					filterOption : true,
					width : '150px'
				},
				{
					id : "lineCd",
					width : '0px',
					visible : false
				},
				{
					id : "sublineCd",
					width : '0px',
					visible : false
				},
				{
					id : "issCd",
					width : '0px',
					visible : false
				},
				{
					id : "distType",
					width : '0px',
					visible : false
				},
				{
					id : "defaultType",
					width : '0px',
					visible : false
				}
			],
			rows : objGIISS065.defaultDistList.rows
	};
	tbgDefaultDist = new MyTableGrid(giisDefaultDistTable);
	tbgDefaultDist.pager = objGIISS065.defaultDistList;
	tbgDefaultDist.render("giisDefaultDistTable");
	
	function setFieldValuesDefaultDist(rec){
		try{
			$("txtDefaultNo").value = (rec == null ? "" : rec.defaultNo == null || rec.defaultNo == "" ? "" : formatNumberDigits(rec.defaultNo,9));
			$("txtLineCd").value = (rec == null ? "" : unescapeHTML2(rec.lineCd));
			$("txtLineCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.lineCd)));
			$("txtDspLineName").value = (rec == null ? "" : unescapeHTML2(rec.dspLineName));
			$("txtDspLineName").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.dspLineName)));
			$("txtSublineCd").value = (rec == null ? "" : unescapeHTML2(rec.sublineCd));
			$("txtSublineCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.sublineCd)));
			$("txtDspSublineName").value = (rec == null ? "" : unescapeHTML2(rec.dspSublineName));
			$("txtDspSublineName").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.dspSublineName)));
			$("txtIssCd").value = (rec == null ? "" : unescapeHTML2(rec.issCd));
			origIssCd = (rec == null ? "" : unescapeHTML2(rec.issCd));
			$("txtIssCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.issCd)));
			$("txtDspIssName").value = (rec == null ? "" : unescapeHTML2(rec.dspIssName));
			$("txtDspIssName").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.dspIssName)));
			$("txtDistType").value = (rec == null ? "" : rec.distType);
			$("txtDistType").setAttribute("lastValidValue", (rec == null ? "" : rec.distType));
			$("txtDspDistName").value = (rec == null ? "" : unescapeHTML2(rec.dspDistName));
			$("txtDspDistName").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.dspDistName)));
			$("txtDefaultType").value = (rec == null ? "" : rec.defaultType);
			$("txtDefaultType").setAttribute("lastValidValue", (rec == null ? "" : rec.defaultType));
			origDefaultType = (rec == null ? "" : rec.defaultType);
			$("txtDspDefaultName").value = (rec == null ? "" : unescapeHTML2(rec.dspDefaultName));
			$("txtDspDefaultName").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.dspDefaultName)));
			$("txtRangeFrom").value = (rec == null ? "" : formatCurrency(rec.rangeFrom));
			$("txtRangeTo").value = (rec == null ? "" : formatCurrency(rec.rangeTo));
			
			rec == null ? $("txtLineCd").readOnly = false : $("txtLineCd").readOnly = true;
			rec == null ? enableSearch("imgSearchLine") : disableSearch("imgSearchLine");
			rec == null ? $("txtSublineCd").readOnly = false : $("txtSublineCd").readOnly = true;
			rec == null ? enableSearch("imgSearchSubline") : disableSearch("imgSearchSubline");
			
			rec == null ? $("btnAddDefaultDist").value = "Add" : $("btnAddDefaultDist").value = "Update";
			rec == null ? disableButton("btnDeleteDefaultDist") : enableButton("btnDeleteDefaultDist");
			rec == null ? disableButton("btnAddDefaultDistGroup") : enableButton("btnAddDefaultDistGroup");
			rec == null ? disableButton("btnAddRange") : enableButton("btnAddRange");
			//rec == null ? disableButton("btnDeleteRange") : enableButton("btnDeleteRange");
     		//disableButton("btnRange"); //Commented out by Jerome 07.22.2016 SR 5552
			
			if (rec == null) {
				queryGiisDefaultDistGroup(0);
				queryGiisDefaultDistDtl(0);
				disableButton("btnDeleteRange");
				defaultDistGroupAllObj = null;
				$("txtSharePct").readOnly = true;
				$("txtShareAmt1").readOnly = true;
				$("txtSharePct").removeClassName("required");
				$("txtShareAmt1").removeClassName("required");
				$("txtShareCd").readOnly = true;
				disableSearch("imgSearchShare");
				$("txtRemarks").readOnly = true;
			} else {
				resetGroupFields();
				$("btnAddRange").value = "Add";
				queryGiisDefaultDistGroup(rec.defaultNo);
				queryGiisDefaultDistDtl(rec.defaultNo);
				defaultDistGroupAllObj = getAllRecord(rec.defaultNo);
				
				for(var i = 0; i<defaultDistGroupAllObj.length;i++){
					totalPct2 = defaultDistGroupAllObj[i].sharePct;
				}
			}
			objCurrDefaultDist = rec;
		} catch(e){
			showErrorMessage("setFieldValuesDefaultDist", e);
		}
	}
	
	$("txtLineCd").setAttribute("lastValidValue", "");
	$("imgSearchLine").observe("click", showGiiss065LineLov);
	$("txtLineCd").observe("keyup", function(){
		$("txtLineCd").value = $F("txtLineCd").toUpperCase();
	});
	$("txtLineCd").observe("change", function() {		
		if($F("txtLineCd").trim() == "") {
			$("txtLineCd").value = "";
			$("txtLineCd").setAttribute("lastValidValue", "");
			$("txtDspLineName").value = "";
			$("txtDspLineName").setAttribute("lastValidValue", "");
			$("txtSublineCd").value = "";
			$("txtDspSublineName").value = "";
			$("txtSublineCd").setAttribute("lastValidValue", "");
			$("txtDspSublineName").setAttribute("lastValidValue", "");
		} else {
			if($F("txtLineCd").trim() != "" && $F("txtLineCd") != $("txtLineCd").readAttribute("lastValidValue")) {
				$("txtSublineCd").value = "";
				$("txtDspSublineName").value = "";
				showGiiss065LineLov();
			}
		}
	});
	
	function showGiiss065LineLov(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getGiiss065LineLov",
				            issCd : $F("txtIssCd"),
							filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
							page : 1},
			title: "List of Lines",
			width: 450,
			height: 400,
			columnModel : [
							{
								id : "lineCd",
								title: "Line Code",
								width: '100px',
								filterOption: true
							},
							{
								id : "lineName",
								title: "Line Name",
								width: '325px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
				onSelect: function(row) {
					$("txtLineCd").value = unescapeHTML2(row.lineCd);
					$("txtDspLineName").value = unescapeHTML2(row.lineName);
					$("txtLineCd").setAttribute("lastValidValue", unescapeHTML2(row.lineCd));
					$("txtDspLineName").setAttribute("lastValidValue", unescapeHTML2(row.lineName));
					$("txtSublineCd").value = "";
					$("txtDspSublineName").value = "";
					$("txtSublineCd").setAttribute("lastValidValue", "");
					$("txtDspSublineName").setAttribute("lastValidValue", "");
				},
				onCancel: function (){
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
					$("txtDspLineName").value = $("txtDspLineName").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	$("txtSublineCd").setAttribute("lastValidValue", "");
	$("imgSearchSubline").observe("click", function(){
		if($F("txtLineCd") != ""){
			showGiiss065SublineLov();
		} else {
			showMessageBox("Line Code is required.", "I");
		}
	});
	$("txtSublineCd").observe("keyup", function(){
		$("txtSublineCd").value = $F("txtSublineCd").toUpperCase();
	});
	$("txtSublineCd").observe("change", function() {	
		if($F("txtLineCd") != ""){
			if($F("txtSublineCd").trim() == "") {
				$("txtSublineCd").value = "";
				$("txtSublineCd").setAttribute("lastValidValue", "");
				$("txtDspSublineName").value = "";
				$("txtDspSublineName").setAttribute("lastValidValue", "");
			} else {
				if($F("txtSublineCd").trim() != "" && $F("txtSublineCd") != $("txtSublineCd").readAttribute("lastValidValue")) {
					showGiiss065SublineLov();
				}
			}
		} else {
			showMessageBox("Line Code is required.", "I");
		}
	});
	
	function showGiiss065SublineLov(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getGiiss065SublineLov",
				            lineCd : $F("txtLineCd"),
							filterText : ($("txtSublineCd").readAttribute("lastValidValue").trim() != $F("txtSublineCd").trim() ? $F("txtSublineCd").trim() : ""),
							page : 1},
			title: "List of Sublines",
			width: 450,
			height: 400,
			columnModel : [
							{
								id : "sublineCd",
								title: "Subline Code",
								width: '100px',
								filterOption: true
							},
							{
								id : "sublineName",
								title: "Subline Name",
								width: '325px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("txtSublineCd").readAttribute("lastValidValue").trim() != $F("txtSublineCd").trim() ? $F("txtSublineCd").trim() : ""),
				onSelect: function(row) {
					$("txtSublineCd").value = unescapeHTML2(row.sublineCd);
					$("txtDspSublineName").value = unescapeHTML2(row.sublineName);
					$("txtSublineCd").setAttribute("lastValidValue", unescapeHTML2(row.sublineCd));
					$("txtDspSublineName").setAttribute("lastValidValue", unescapeHTML2(row.sublineName));
				},
				onCancel: function (){
					$("txtSublineCd").value = $("txtSublineCd").readAttribute("lastValidValue");
					$("txtDspSublineName").value = $("txtDspSublineName").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtSublineCd").value = $("txtSublineCd").readAttribute("lastValidValue");
					$("txtDspSublineName").value = $("txtDspSublineName").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	$("txtIssCd").setAttribute("lastValidValue", "");
	$("imgSearchIssuance").observe("click", showGiiss065IssLov);
	$("txtIssCd").observe("keyup", function(){
		$("txtIssCd").value = $F("txtIssCd").toUpperCase();
	});
	$("txtIssCd").observe("change", function() {		
		if($F("txtIssCd").trim() == "") {
			$("txtIssCd").value = "";
			$("txtIssCd").setAttribute("lastValidValue", "");
			$("txtDspIssName").value = "";
			$("txtDspIssName").setAttribute("lastValidValue", "");
		} else {
			if($F("txtIssCd").trim() != "" && $F("txtIssCd") != $("txtIssCd").readAttribute("lastValidValue")) {
				showGiiss065IssLov();
			}
		}
	});
	
	function showGiiss065IssLov(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getGiiss065IssLov",
				            lineCd : $F("txtLineCd"),
							filterText : ($("txtIssCd").readAttribute("lastValidValue").trim() != $F("txtIssCd").trim() ? $F("txtIssCd").trim() : ""),
							page : 1},
			title: "List of Issue Sources",
			width: 450,
			height: 400,
			columnModel : [
							{
								id : "issCd",
								title: "Issue Code",
								width: '100px',
								filterOption: true
							},
							{
								id : "issName",
								title: "Issue Name",
								width: '325px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("txtIssCd").readAttribute("lastValidValue").trim() != $F("txtIssCd").trim() ? $F("txtIssCd").trim() : ""),
				onSelect: function(row) {
					$("txtIssCd").value = unescapeHTML2(row.issCd);
					$("txtDspIssName").value = unescapeHTML2(row.issName);
					$("txtIssCd").setAttribute("lastValidValue", unescapeHTML2(row.issCd));	
					$("txtDspIssName").setAttribute("lastValidValue", unescapeHTML2(row.issName));
				},
				onCancel: function (){
					$("txtIssCd").value = $("txtIssCd").readAttribute("lastValidValue");
					$("txtDspIssName").value = $("txtDspIssName").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtIssCd").value = $("txtIssCd").readAttribute("lastValidValue");
					$("txtDspIssName").value = $("txtDspIssName").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	$("txtDistType").setAttribute("lastValidValue", "");
	$("imgSearchDistType").observe("click", showGiiss065DistTypeLov);
	$("txtDistType").observe("keyup", function(){
		$("txtDistType").value = $F("txtDistType").toUpperCase();
	});
	$("txtDistType").observe("change", function() {		
		if($F("txtDistType").trim() == "") {
			$("txtDistType").value = "";
			$("txtDistType").setAttribute("lastValidValue", "");
			$("txtDspDistName").value = "";
			$("txtDspDistName").setAttribute("lastValidValue", "");
		} else {
			if($F("txtDistType").trim() != "" && $F("txtDistType") != $("txtDistType").readAttribute("lastValidValue")) {
				showGiiss065DistTypeLov();
			}
		}
	});
	
	function showGiiss065DistTypeLov(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getGiiss065DistTypeLov",
							filterText : ($("txtDistType").readAttribute("lastValidValue").trim() != $F("txtDistType").trim() ? $F("txtDistType").trim() : ""),
							page : 1},
			title: "List of Distribution Types",
			width: 450,
			height: 400,
			columnModel : [
							{
								id : "distType",
								title: "Dist. Type",
								width: '100px',
								filterOption: true
							},
							{
								id : "distName",
								title: "Dist. Name",
								width: '325px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("txtDistType").readAttribute("lastValidValue").trim() != $F("txtDistType").trim() ? $F("txtDistType").trim() : ""),
				onSelect: function(row) {
					$("txtDistType").value = unescapeHTML2(row.distType);
					$("txtDspDistName").value = unescapeHTML2(row.distName);
					$("txtDistType").setAttribute("lastValidValue", unescapeHTML2(row.distType));	
					$("txtDspDistName").setAttribute("lastValidValue", unescapeHTML2(row.distName));	
				},
				onCancel: function (){
					$("txtDistType").value = $("txtDistType").readAttribute("lastValidValue");
					$("txtDspDistName").value = $("txtDspDistName").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtDistType").value = $("txtDistType").readAttribute("lastValidValue");
					$("txtDspDistName").value = $("txtDspDistName").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	$("txtDefaultType").setAttribute("lastValidValue", "");
	$("imgSearchDefaultType").observe("click", valExistingDistPerilRecord);
	$("txtDefaultType").observe("keyup", function(){
		$("txtDefaultType").value = $F("txtDefaultType").toUpperCase();
	});
	$("txtDefaultType").observe("change", function() {		
		if($F("txtDefaultType").trim() == "") {
			$("txtDefaultType").value = "";
			$("txtDefaultType").setAttribute("lastValidValue", "");
			$("txtDspDefaultName").value = "";
			$("txtDspDefaultName").setAttribute("lastValidValue", "");
		} else {
			if($F("txtDefaultType").trim() != "" && $F("txtDefaultType") != $("txtDefaultType").readAttribute("lastValidValue")) {
				valExistingDistPerilRecord();
			}
		}
	});
	
	function valExistingDistPerilRecord(){
		new Ajax.Request(contextPath + "/GIISDefaultOneRiskController", {
			parameters : {action : "valExistingDistPerilRecord",
				          defaultNo : $F("txtDefaultNo"),
						  lineCd : $F("txtLineCd")
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					showGiiss065DefaultTypeLov();
				}else{
					$("txtDefaultType").value = origDefaultType;
				}
			}
		});
	}
	
	function showGiiss065DefaultTypeLov(){
		if(tbgDefaultDistGroup.geniisysRows.length > 0){
			showWaitingMessageBox("You cannot change the default type if there are already existing default distribution records.", "I",function(){
				$("txtDefaultType").value = origDefaultType;
			});
			return;
		}
		
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getGiiss065DefaultTypeLov",
							filterText : ($("txtDefaultType").readAttribute("lastValidValue").trim() != $F("txtDefaultType").trim() ? $F("txtDefaultType").trim() : ""),
							page : 1},
			title: "List of Default Types",
			width: 450,
			height: 400,
			columnModel : [
							{
								id : "defaultType",
								title: "Default Type",
								width: '100px',
								filterOption: true
							},
							{
								id : "defaultName",
								title: "Default Name",
								width: '325px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("txtDefaultType").readAttribute("lastValidValue").trim() != $F("txtDefaultType").trim() ? $F("txtDefaultType").trim() : ""),
				onSelect: function(row) {
					$("txtDefaultType").value = unescapeHTML2(row.defaultType);
					$("txtDspDefaultName").value = unescapeHTML2(row.defaultName);
					$("txtDefaultType").setAttribute("lastValidValue", unescapeHTML2(row.defaultType));
					$("txtDspDefaultName").setAttribute("lastValidValue", unescapeHTML2(row.defaultName));
				},
				onCancel: function (){
					$("txtDefaultType").value = $("txtDefaultType").readAttribute("lastValidValue");
					$("txtDspDefaultName").value = $("txtDspDefaultName").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtDefaultType").value = $("txtDefaultType").readAttribute("lastValidValue");
					$("txtDspDefaultName").value = $("txtDspDefaultName").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	function valAddDefaultDistRec(){
		try{
			if(checkAllRequiredFieldsInDiv("giisDefaultDistFormDiv")){
				for(var i=0; i<defaultDistAllList.length; i++){
					if(defaultDistAllList[i].recordStatus != -1 ){
						if ($F("btnAddDefaultDist") == "Add") {
							if(unescapeHTML2(defaultDistAllList[i].lineCd) == $F("txtLineCd") && unescapeHTML2(defaultDistAllList[i].sublineCd) == $F("txtSublineCd") && unescapeHTML2(defaultDistAllList[i].issCd) == $F("txtIssCd")){
								showMessageBox("Record already exists with the same line_cd, subline_cd and iss_cd.", "E");
								return;
							}
						} else{
							if(origIssCd != $F("txtIssCd") && unescapeHTML2(defaultDistAllList[i].lineCd) == $F("txtLineCd") && unescapeHTML2(defaultDistAllList[i].sublineCd) == $F("txtSublineCd") && unescapeHTML2(defaultDistAllList[i].issCd) == $F("txtIssCd")){
								showMessageBox("Record already exists with the same line_cd, subline_cd and iss_cd.", "E");
								return;
							}
						}
					} 
				}
				addDefaultDistRec();
			}
		} catch(e){
			showErrorMessage("valAddDefaultDistRec", e);
		}
	}

	function addDefaultDistRec(){
		try {
			changeTagFunc = saveGiiss065;
			var defaultDist = setDefaultDisRec(objCurrDefaultDist);
			var newObj = setDefaultDisRec(null);
			if($F("btnAddDefaultDist") == "Add"){
				tbgDefaultDist.addBottomRow(defaultDist);
				newObj.recordStatus = 0;
				defaultDistAllList.push(newObj);
			} else {
				updateSw = "Y";
				if (changeTagGroup == 1) {
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
						$("btnSave").focus();
					});
					return;
				}
				tbgDefaultDist.updateVisibleRowOnly(defaultDist, rowIndexDefaultDist, false);
				for(var i = 0; i<defaultDistAllList.length; i++){
					if(defaultDistAllList[i].lineCd == newObj.lineCd && defaultDistAllList[i].sublineCd == newObj.sublineCd && defaultDistAllList[i].issCd == newObj.issCd &&(defaultDistAllList[i].recordStatus != -1)){
						newObj.recordStatus = 1;
						defaultDistAllList.splice(i, 1, newObj);
					}
				}
			}
			changeTag = 1;
			setFieldValuesDefaultDist(null);
			tbgDefaultDist.keys.removeFocus(tbgDefaultDist.keys._nCurrentFocus, true);
			tbgDefaultDist.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addDefaultDistRec", e);
		}
	}
	
	function setDefaultDisRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.defaultNo = $F("txtDefaultNo");
			obj.lineCd = escapeHTML2($F("txtLineCd"));
			obj.dspLineName = escapeHTML2($F("txtDspLineName"));
		    obj.sublineCd = escapeHTML2($F("txtSublineCd"));
		    obj.dspSublineName = escapeHTML2($F("txtDspSublineName"));
		    obj.issCd = escapeHTML2($F("txtIssCd"));
		    obj.dspIssName = escapeHTML2($F("txtDspIssName"));
		    obj.distType = escapeHTML2($F("txtDistType"));
		    obj.dspDistName = escapeHTML2($F("txtDspDistName"));
		    obj.defaultType = escapeHTML2($F("txtDefaultType"));
		    obj.dspDefaultName = escapeHTML2($F("txtDspDefaultName"));
			
			return obj;
		} catch(e){
			showErrorMessage("setDefaultDisRec", e);
		}
	}
	
	function valDelDefaultDistRec(){
		try{
			new Ajax.Request(contextPath + "/GIISDefaultOneRiskController", {
				parameters : {action : "valDelDefaultDistRec",
							  defaultNo : $F("txtDefaultNo")
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						deleteDefaultDistRec();
					}
				}
			});
		} catch(e){
			showErrorMessage("valDelDefaultDistRec", e);
		}
	}
	
	function deleteDefaultDistRec(){
		changeTagFunc = saveGiiss065;
		objCurrDefaultDist.recordStatus = -1;
		var newObj = setDefaultDisRec(null);
		if (changeTagGroup == 1) {
			showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
				$("btnSave").focus();
			});
			return;
		}
		tbgDefaultDist.deleteRow(rowIndexDefaultDist);
		for(var i = 0; i<defaultDistAllList.length; i++){
			if(defaultDistAllList[i].lineCd == newObj.lineCd && defaultDistAllList[i].sublineCd == newObj.sublineCd && defaultDistAllList[i].issCd == newObj.issCd &&(defaultDistAllList[i].recordStatus != -1)){
				newObj.recordStatus = -1;
				defaultDistAllList.splice(i, 1, newObj);
			}
		}
		changeTag = 1;
		setFieldValuesDefaultDist(null);
	}
	
	$("btnAddDefaultDist").observe("click", valAddDefaultDistRec);
	$("btnDeleteDefaultDist").observe("click", valDelDefaultDistRec);
	
	/* Default Distribution Group */
	function queryGiisDefaultDistGroup(defaultNo){
		tbgDefaultDistGroup.url = contextPath + "/GIISDefaultOneRiskController?action=queryGiisDefaultDistGroup&refresh=1&defaultNo=" + defaultNo;
		tbgDefaultDistGroup._refreshList();
		
		resetGroupFields();
	}
	
	function queryGiisDefaultDistGroup2(defaultNo, rangeFrom, rangeTo){
		tbgDefaultDistGroup.url = contextPath + "/GIISDefaultOneRiskController?action=queryGiisDefaultDistGroup2&refresh=1&defaultNo=" + defaultNo
				+ "&rangeFrom=" + rangeFrom + "&rangeTo=" + rangeTo;
		tbgDefaultDistGroup._refreshList();
		
		resetGroupFields();
	}
	
	function queryGiisDefaultDistDtl(defaultNo){ //Added by Jerome 08.05.2016 SR 5552
		tbgRange.url = contextPath + "/GIISDefaultOneRiskController?action=showGiiss065Range&refresh=1" + "&defaultNo=" + defaultNo;
		tbgRange._refreshList();
		
	}
	
	function resetGroupFields(){
		if($F("txtDefaultType") == "2"){
			$("txtSharePct").readOnly = false;
			$("txtShareAmt1").readOnly = true;
			$("txtSharePct").addClassName("required");
			$("txtShareAmt1").removeClassName("required");
		} else if($F("txtDefaultType") == "1"){
			$("txtSharePct").readOnly = true;
			$("txtShareAmt1").readOnly = false;
			$("txtSharePct").removeClassName("required");
			$("txtShareAmt1").addClassName("required");
		}
	}
	
	var rowIndexRange = -1; //Added by Jerome 08.05.2016 SR 5552
	
	var objRange = {};
	var objCurrRange = null;
	objRange.rangeList = JSON.parse('${jsonGiisDefaultDistDtl}');
	var objDefaultRange = []; //Added by Jerome 07.22.2016 SR 5552
	
	var rangeTable = {
			url : contextPath + "/GIISDefaultOneRiskController?action=showGiiss065Range&refresh=1" + "&defaultNo=" + $F("txtDefaultNo"),
			options : {
				width : '575px',
				height : '250px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndexRange = y;
					objCurrRange = tbgRange.geniisysRows[y];
					setRangeFieldValues(objCurrRange);
					tbgRange.keys.removeFocus(tbgRange.keys._nCurrentFocus, true);
					tbgRange.keys.releaseKeys();
					$("txtRangeFrom").focus();
					$("btnAddRange").value = "Update"
				},
				onRemoveRowFocus : function(){
					rowIndexRange = -1;
					setRangeFieldValues(null);
					tbgRange.keys.removeFocus(tbgRange.keys._nCurrentFocus, true);
					tbgRange.keys.releaseKeys();
					$("btnAddRange").value = "Add";
				},
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndexRange = -1;
						setRangeFieldValues(null);
						tbgRange.keys.removeFocus(tbgRange.keys._nCurrentFocus, true);
						tbgRange.keys.releaseKeys();
					},
					onRefresh : function() {
						tbgRange._refreshList();
						rowIndexRange = -1;
						setRangeFieldValues(null);
						$("btnAddRange").value = "Add";
						tbgRange.keys.removeFocus(tbgRange.keys._nCurrentFocus, true);
						tbgRange.keys.releaseKeys();
					}
				},
				onSort: function(){
					rowIndexRange = -1;
					setRangeFieldValues(null);
					tbgRange.keys.removeFocus(tbgRange.keys._nCurrentFocus, true);
					tbgRange.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndexRange = -1;
					//setRangeFieldValues(null);
					tbgRange.keys.removeFocus(tbgRange.keys._nCurrentFocus, true);
					tbgRange.keys.releaseKeys();
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
					id : "rangeFrom",
					title : "Range From",
					titleAlign : 'right',
					width : '275px',
					geniisysClass: 'money',
					align : 'right',
				},
				{
					id : "rangeTo",
					title : "Range To",
					titleAlign : 'right',
					width : '275px',
					geniisysClass: 'money',
					align : 'right',
				},
				{
					id : "lineCd",
					width : '0',
					visible : false
				},
				{
					id : "shareCd",
					width : '0',
					visible : false
				}
			],
			rows : objRange.rangeList.rows
	};
	
	tbgRange = new MyTableGrid(rangeTable);
	tbgRange.pager = objRange.rangeList;
	tbgRange.render("giisDefaultDistDtlTable");
	tbgRange.afterRender = function(){
		objDefaultRange = tbgRange.geniisysRows;
	};
	
	function setRangeFieldValues(rec){
		try{
			$("txtRangeFrom").value = (rec == null ? "" : formatCurrency(rec.rangeFrom));
			$("txtRangeTo").value = (rec == null ? "" : formatCurrency(rec.rangeTo));
			$("txtlastValidRangeFrom").value = (rec == null ? "" : formatCurrency(rec.rangeFrom));
			$("txtlastValidRangeTo").value = (rec == null ? "" : formatCurrency(rec.rangeTo));
			
			//rec == null ? enableButton("btnAddRange") : disableButton("btnAddRange");
			rec == null ? disableButton("btnDeleteRange") : enableButton("btnDeleteRange");
			
			if (rec == null) {
				queryGiisDefaultDistGroup($F("txtDefaultNo"));
				$("btnAddRange").value = "Add";
			} else {
				resetGroupFields();
				queryGiisDefaultDistGroup2($F("txtDefaultNo"),unformatCurrencyValue($F("txtRangeFrom")),unformatCurrencyValue($F("txtRangeTo")));
				defaultDistGroupAllObj = getDistGroupRec(rec.defaultNo,unformatCurrencyValue($F("txtRangeFrom")),unformatCurrencyValue($F("txtRangeTo")));
			}
			objCurrRange = rec;
		} catch(e){
			showErrorMessage("setRangeFieldValues", e);
		}
	}
	
	$("btnAddRange").observe("click", valAddRec);
	$("btnDeleteRange").observe("click", deleteRange);
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("giisDefaultDistDtlFormDiv")){
				if($F("btnAddRange") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;					
					
					for(var i=0; i<tbgRange.geniisysRows.length; i++){
						if(tbgRange.geniisysRows[i].recordStatus == 0 || tbgRange.geniisysRows[i].recordStatus == 1){
							if(tbgRange.geniisysRows[i].rangeFrom == $F("txtRangeFrom") && tbgRange.geniisysRows[i].rangeTo == $F("txtRangeTo")){
								addedSameExists = true;								
							}							
						} else if(tbgRange.geniisysRows[i].recordStatus == -1){
							if(tbgRange.geniisysRows[i].rangeFrom == $F("txtRangeFrom") && tbgRange.geniisysRows[i].rangeTo == $F("txtRangeTo")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same Range From and Range To.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addUpdateRange();
						return;
					}
					addUpdateRange();
				} else {
					updateSw = "Y";
					addUpdateRange();
				}
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}
	
	$("txtRangeFrom").observe("change", function() {
		if ($("txtRangeFrom").value != "") {
			validateRange($("txtRangeFrom"), $("txtlastValidRangeFrom"), "txtRangeFrom");	
		}
	});	
	
	$("txtRangeFrom").observe("blur", function() {
		if ($("txtRangeFrom").value != "") {
			validateRange($("txtRangeFrom"), $("txtlastValidRangeFrom"), "txtRangeFrom");	
		}
	});
	
	$("txtRangeTo").observe("change", function() {
		if ($("txtRangeTo").value != "") {
			validateRange($("txtRangeTo"), $("txtlastValidRangeTo"), "txtRangeTo");	
		}
	});	
	
	$("txtRangeTo").observe("blur", function() {
		if ($("txtRangeTo").value != "") {
			validateRange($("txtRangeTo"), $("txtlastValidRangeTo"), "txtRangeTo");	
		}
	});
	
	function addUpdateRange(){ 
 		postRangeObj = createRangeObj($("btnAddRange").value);
 		if (checkAllRequiredFieldsInDiv("giisDefaultDistDtlFormDiv")) {
 	 		if ($("btnAddRange").value != "Add") {
 	 			objDefaultRange.splice(rowIndexRange, 1, postRangeObj);
 	 		 	tbgRange.updateVisibleRowOnly(postRangeObj, rowIndexRange);
 	 		 	tbgRange.onRemoveRowFocus();
 	 		 	changeTag = 1;
 			} else {
 					unsavedStatus = 1;
 					objDefaultRange.push(postRangeObj);
 		 	 		tbgRange.addBottomRow(postRangeObj);
 		 			tbgRange.onRemoveRowFocus();
 		 			changeTag = 1;
 			}
		}
 	}
	
 	function validateRange(range, lastValidValue, focus){
		if (isNaN(range.value)) {
			range.value = lastValidValue.value;
		} else if ((range.value < (parseInt(range.getAttribute("min")))) || (range.value > 999999999.99)) {
			customShowMessageBox("Invalid " + range.getAttribute("customLabel") + ". Valid value should be from 1.00 to 999,999,999.99.", imgMessage.INFO, focus);
			range.value = lastValidValue.value;
		} else if ((range.value).include("-")) {
			customShowMessageBox("Invalid " + range.getAttribute("customLabel") + ". Valid value should be from 1.00 to 999,999,999.99.", imgMessage.INFO, focus);
			range.value = lastValidValue.value;
		} else if (unformatCurrencyValue($F("txtRangeFrom")) > unformatCurrencyValue($F("txtRangeTo")) && unformatCurrencyValue($F("txtRangeTo")) != "") {
				customShowMessageBox("Range From should not exceed Range To", imgMessage.INFO, "txtRangeFrom");
		}
		else {
			range.value = addSeparatorToNumber2(formatNumberByRegExpPattern(range), ",");
			var decimalrange = ((range.value).include(".") ? range.value : (range.value)).split(".");
			if(decimalrange[1].length > 2){				
				customShowMessageBox("Invalid " + range.getAttribute("customLabel") + ". Valid value should be from 0.00 to 999,999,999.99.", imgMessage.INFO, focus);
				range.value = lastValidValue.value;
			}else{				
				lastValidValue.value = range.value;
			}
		}
	}
	
 	function createRangeObj(func){
 		try {
  	       var range = new Object();
		   
  	     if($F("txtSequence") == "" && $F("txtDefaultNo") == ""){
				range.childTag = "Y";
				objCurrDefaultDist.childTag = "Y";
				tbgDefaultDist.updateVisibleRowOnly(objCurrDefaultDist, rowIndexDefaultDist, true);
			}
  	       
  	       range.rangeFrom = $F("txtRangeFrom");
  	       range.rangeTo = $F("txtRangeTo");
  	       range.defaultNo = $F("txtDefaultNo");
  	       range.recordStatus   = func == "Delete" ? -1 : func == "Add" ? 0 : 1;
  	       return range;
  	     } catch (e) {
  	       showErrorMessage("createRangeObj", e);
  	     }
 	}
 	
 	function deleteRange(){
		objCurrRange.recordStatus = -1;
		tbgRange.deleteRow(rowIndexRange);
		changeTag = 1;
		$("btnAddRange").value = "Add";
		setRangeFieldValues(null);
	}
	
	var rowIndexDefaultDistGroup = -1;
	var objCurrDefaultDistGroup = null;
	objGIISS065.defaultDistGroupList = JSON.parse('${jsonGiisDefaultDistGroup}');
	
	var totalPct = 0;
	var tbgDefaultDistGroupRowsLength = 0;
	var tbgDefaultDistGroupRowsCount = 0;
	
	var giisDefaultDistGroupTable = {
			url : contextPath + "/GIISDefaultOneRiskController?action=queryGiisDefaultDistGroup&refresh=1",
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndexDefaultDistGroup = y;
					objCurrDefaultDistGroup = tbgDefaultDistGroup.geniisysRows[y];
					setFieldValuesDefaultDistGroup(objCurrDefaultDistGroup);
					tbgDefaultDistGroup.keys.removeFocus(tbgDefaultDistGroup.keys._nCurrentFocus, true);
					tbgDefaultDistGroup.keys.releaseKeys();
					$("txtShareCd").focus();
					//enableButton("btnRange"); //Added by Jerome 07.29.2016 SR 5552
				},
				onRemoveRowFocus : function(){
					rowIndexDefaultDistGroup = -1;
					setFieldValuesDefaultDistGroup(null);
					tbgDefaultDistGroup.keys.removeFocus(tbgDefaultDistGroup.keys._nCurrentFocus, true);
					tbgDefaultDistGroup.keys.releaseKeys();
					$("txtShareCd").focus();
				},
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndexDefaultDistGroup = -1;
						setFieldValuesDefaultDistGroup(null);
						tbgDefaultDistGroup.keys.removeFocus(tbgDefaultDistGroup.keys._nCurrentFocus, true);
						tbgDefaultDistGroup.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					if(changeTagGroup == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
				},
				onSort: function(){
					rowIndexDefaultDistGroup = -1;
					setFieldValuesDefaultDistGroup(null);
					tbgDefaultDistGroup.keys.removeFocus(tbgDefaultDistGroup.keys._nCurrentFocus, true);
					tbgDefaultDistGroup.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndexDefaultDistGroup = -1;
					setFieldValuesDefaultDistGroup(null);
					tbgDefaultDistGroup.keys.removeFocus(tbgDefaultDistGroup.keys._nCurrentFocus, true);
					tbgDefaultDistGroup.keys.releaseKeys();
				},
				prePager: function(){
					if(changeTagGroup == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
					rowIndexDefaultDistGroup = -1;
					setFieldValuesDefaultDistGroup(null);
					tbgDefaultDistGroup.keys.removeFocus(tbgDefaultDistGroup.keys._nCurrentFocus, true);
					tbgDefaultDistGroup.keys.releaseKeys();
				},
				checkChanges: function(){
					return (changeTagGroup == 1 ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (changeTagGroup == 1 ? true : false);
				},
				masterDetailValidation: function(){
					return (changeTagGroup == 1 ? true : false);
				},
				masterDetail: function(){
					return (changeTagGroup == 1 ? true : false);
				},
				masterDetailSaveFunc: function() {
					return (changeTagGroup == 1 ? true : false);
				},
				masterDetailNoFunc: function(){
					return (changeTagGroup == 1 ? true : false);
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
					id : "sequence",
					title : "Sequence",
					filterOption : true,
					align : "right",
					titleAlign : "right",
					filterOptionType : 'integerNoNegative',
					width : '60px',
					renderer : function(value){
						return formatNumberDigits(value, 3);
					}
				},
				{
					id : 'dspTreatyName',
					filterOption : true,
					title : 'Share',
					width : '285px'	,
					renderer : function(value){
						return unescapeHTML2(value);
					}
				},
				{
					id : 'sharePct',
					title : 'Percent Share',
					align: 'right',
					titleAlign : 'right',
					filterOption : true,
					filterOptionType : 'numberNoNegative',
					width : '155px',
					renderer : function(value){
						return formatToNthDecimal(value, 9);
					}
				},
				{
					id : "shareAmt1",
					title : "Share Amount",
					align: 'right',
					titleAlign : 'right',
					width : '155px',
					geniisysClass: 'money',
					filterOption : true,
					filterOptionType : 'number',
					align : 'right',
				},
				{
					id : 'defaultNo',
					width : '0',
					visible: false				
				},
				{
					id : 'lineCd',
					width : '0',
					visible: false				
				},
				{
					id : 'shareCd',
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
			rows : objGIISS065.defaultDistGroupList.rows
	};
	tbgDefaultDistGroup = new MyTableGrid(giisDefaultDistGroupTable);
	tbgDefaultDistGroup.pager = objGIISS065.defaultDistGroupList;
	tbgDefaultDistGroup.render("giisDefaultDistGroupTable");
	tbgDefaultDistGroup.afterRender = function(){
		tbgDefaultDistGroup.keys.removeFocus(tbgDefaultDistGroup.keys._nCurrentFocus, true);
		tbgDefaultDistGroup.keys.releaseKeys();
		
		tbgDefaultDistGroupRowsLength = tbgDefaultDistGroup.geniisysRows.length;
		tbgDefaultDistGroupRowsCount = tbgDefaultDistGroup.geniisysRows.length;
		
		totalPct = 0;
		if($F("txtDefaultType") == "2"){
			for (var i = 0; i < tbgDefaultDistGroup.geniisysRows.length; i++) {
				totalPct = parseFloat(tbgDefaultDistGroup.geniisysRows[0].totalSharePct);
			}
		}
	};
	
	function setFieldValuesDefaultDistGroup(rec){
		try{
			$("txtSequence").value = (rec == null ? "" : rec.sequence);
			$("txtShareCd").value = (rec == null ? "" : rec.shareCd);
			$("txtShareCd").setAttribute("lastValidValue", (rec == null ? "" : rec.shareCd));
			$("txtDspTreatyName").value = (rec == null ? "" : unescapeHTML2(rec.dspTreatyName));
			$("txtDspTreatyName").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.dspTreatyName)));
			$("txtSharePct").value = (rec == null ? "" : formatToNthDecimal(rec.sharePct, 9));
			$("txtSharePct").setAttribute("lastValidValue", (rec == null ? "0" : rec.sharePct));
			$("txtShareAmt1").value = (rec == null ? "" : formatCurrency(rec.shareAmt1));
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			
			rec == null ? $("txtShareCd").readOnly = false : $("txtShareCd").readOnly = true;
			rec == null ? enableSearch("imgSearchShare") : disableSearch("imgSearchShare");
			
			rec == null ? $("btnAddDefaultDistGroup").value = "Add" : $("btnAddDefaultDistGroup").value = "Update";
			rec == null ? disableButton("btnDeleteDefaultDistGroup") : enableButton("btnDeleteDefaultDistGroup");
			objCurrDefaultDistGroup = rec;
		} catch(e){
			showErrorMessage("setFieldValuesDefaultDistGroup", e);
		}
	}
	
	$("txtShareCd").setAttribute("lastValidValue", "");
	$("imgSearchShare").observe("click", showGiiss065ShareLov);
	$("txtShareCd").observe("keyup", function(){
		$("txtShareCd").value = $F("txtShareCd").toUpperCase();
	});
	$("txtShareCd").observe("change", function() {		
		if($F("txtShareCd").trim() == "") {
			$("txtShareCd").value = "";
			$("txtShareCd").setAttribute("lastValidValue", "");
			$("txtDspTreatyName").value = "";
			$("txtDspTreatyName").setAttribute("lastValidValue", "");
		} else {
			if($F("txtShareCd").trim() != "" && $F("txtShareCd") != $("txtShareCd").readAttribute("lastValidValue")) {
				showGiiss065ShareLov();
			}
		}
	});
	
	function showGiiss065ShareLov(){
		var action;
		
		if($F("txtDefaultType") == "1"){
			action = "getGiiss065Share01Lov";
		} else{
			action = "getGiiss065Share999Lov";
		}
		
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : action,
				            lineCd : $F("txtLineCd"),
							filterText : ($("txtShareCd").readAttribute("lastValidValue").trim() != $F("txtShareCd").trim() ? $F("txtShareCd").trim() : ""),
							page : 1},
			title: "List of Share Types",
			width: 450,
			height: 400,
			columnModel : [
							{
								id : "shareCd",
								title: "Share Code",
								width: '100px',
								align: 'right',
								filterOption: true
							},
							{
								id : "shareName",
								title: "Share Name",
								width: '325px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("txtShareCd").readAttribute("lastValidValue").trim() != $F("txtShareCd").trim() ? $F("txtShareCd").trim() : ""),
				onSelect: function(row) {
					$("txtShareCd").value = row.shareCd;
					$("txtDspTreatyName").value = unescapeHTML2(row.shareName);
					$("txtShareCd").setAttribute("lastValidValue", row.shareCd);
					$("txtDspTreatyName").setAttribute("lastValidValue", unescapeHTML2(row.shareName));
				},
				onCancel: function (){
					$("txtShareCd").value = $("txtShareCd").readAttribute("lastValidValue");
					$("txtDspTreatyName").value = $("txtDspTreatyName").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtShareCd").value = $("txtShareCd").readAttribute("lastValidValue");
					$("txtDspTreatyName").value = $("txtDspTreatyName").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	function setGroup(option){
		if(option == "N"){
			$("txtShareCd").readOnly = true;
			disableSearch("imgSearchShare");
			$("txtRemarks").readOnly = true;
		} else {
			$("txtShareCd").readOnly = false;
			enableSearch("imgSearchShare");
			$("txtRemarks").readOnly = false;
		}
	}
	
	function valAddDefaultDistGroupRec(){
		try{
			if(checkAllRequiredFieldsInDiv("giisDefaultDistGroupFormDiv")){
				if($F("btnAddDefaultDistGroup") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;

					for(var i=0; i<tbgDefaultDistGroup.geniisysRows.length; i++){
						if(tbgDefaultDistGroup.geniisysRows[i].recordStatus == 0 || tbgDefaultDistGroup.geniisysRows[i].recordStatus == 1){								
							if(tbgDefaultDistGroup.geniisysRows[i].shareCd == $F("txtShareCd")){
								addedSameExists = true;								
							}
						} else if(tbgDefaultDistGroup.geniisysRows[i].recordStatus == -1){
							if(tbgDefaultDistGroup.geniisysRows[i].shareCd == $F("txtShareCd")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same default_no, line_cd and share_cd.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addDefaultRiskGroupRec();
						return;
					}
					
					new Ajax.Request(contextPath + "/GIISDefaultOneRiskController", {
						parameters : {action : "valAddDefaultDistGroupRec",
									  defaultNo : $F("txtDefaultNo"),
									  shareCd : $F("txtShareCd")
						},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response) && (totalPct2 != 100 && totalPct != 100)){
								addDefaultRiskGroupRec();
							} else{
								showMessageBox("Total share percent of the record is already at 100, cannot add anymore shares.", "E");
								return;
							}
						}
					});
				} else {
					if($F("txtShareCd") != $("txtShareCd").readAttribute("lastValidValue")){
						new Ajax.Request(contextPath + "/GIISDefaultOneRiskController", {
							parameters : {action : "valAddDefaultDistGroupRec",
										  defaultNo : $F("txtDefaultNo"),
										  shareCd : $F("txtShareCd")
							},
							onCreate : showNotice("Processing, please wait..."),
							onComplete : function(response){
								hideNotice();
								if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response) && totalPct2 != 100){
									addDefaultRiskGroupRec();
								}
							}
						});
					} else {
						addDefaultRiskGroupRec();
					}
				}
			}
		} catch(e){
			showErrorMessage("valAddDefaultDistGroupRec", e);
		}
	}
	
	var addCtr = 0;
	function addDefaultRiskGroupRec(){
		try {
			if($F("btnAddDefaultDistGroup") == "Add"){
				if (recomputeTotalPct("add")){
					return;
				}
			} else {
				if (recomputeTotalPct("update")){
					return;
				}
			}
			changeTagFunc = saveGiiss065;
			var defaultDistGroup = setDefaultDistGroupRec(objCurrDefaultDistGroup);
			var newObj = setDefaultDistGroupRec(null);
			if($F("btnAddDefaultDistGroup") == "Add"){
				newObj.recordStatus = 0;
				defaultDistGroupAllObj.push(newObj);
				tbgDefaultDistGroup.addBottomRow(defaultDistGroup);
				addCtr = addCtr + 1;
			} else {
				tbgDefaultDistGroup.updateVisibleRowOnly(defaultDistGroup, rowIndexDefaultDistGroup, false);
				updateSw = "Y";
				for(var i = 0; i<defaultDistGroupAllObj.length; i++){
					if ((defaultDistGroupAllObj[i].sequence == newObj.sequence)&&(defaultDistGroupAllObj[i].recordStatus != -1)){
						newObj.recordStatus = 1;
						defaultDistGroupAllObj.splice(i, 1, newObj);
					}
				}
			}
			changeTag = 1;
			changeTagGroup = 1;
			setFieldValuesDefaultDistGroup(null);
			tbgDefaultDistGroup.keys.removeFocus(tbgDefaultDistGroup.keys._nCurrentFocus, true);
			tbgDefaultDistGroup.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addDefaultRiskGroupRec", e);
		}
	}
	
	function recomputeTotalPct(func){
		var origTotalPct = totalPct;
		if(func == "add"){
			totalPct = totalPct + parseFloat($F("txtSharePct"));
		} else if(func == "update"){
			var lastValidValue = 0;
			
			if(isNaN(parseFloat($("txtSharePct").getAttribute("lastValidValue")))){
				lastValidValue = 0;
			} else {
				lastValidValue = parseFloat($("txtSharePct").getAttribute("lastValidValue"));
			}
			
			totalPct = totalPct - (lastValidValue - parseFloat($("txtSharePct").value));
		} else if(func == "delete"){
			totalPct = totalPct -  parseFloat($F("txtSharePct"));
		}
		if($F("txtDefaultType") == "2"){
			if(totalPct > 100){
				totalPct = origTotalPct;
				showMessageBox("Total share percent must not exceed 100%.", "I");
				return true;
			}	
		}
		return false;
	}
	
	function setDefaultDistGroupRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			
			if($F("txtSequence") == "" && $F("txtDefaultNo") == ""){
				obj.childTag = "Y";
				objCurrDefaultDist.childTag = "Y";
				tbgDefaultDist.updateVisibleRowOnly(objCurrDefaultDist, rowIndexDefaultDist, true);
			}
			
			obj.defaultNo = $F("txtDefaultNo");
			obj.lineCd = $F("txtLineCd");
			obj.shareCd = $F("txtShareCd");
			obj.dspTreatyName = escapeHTML2($F("txtDspTreatyName"));
			obj.sequence = $F("txtSequence") == "" ? generateSequenceNo() : $F("txtSequence");
			obj.sharePct = $F("txtSharePct");
			obj.shareAmt1 = $F("txtShareAmt1");
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setDefaultDistGroupRec", e);
		}
	}
	
	
	/* function generateSequenceNo(){ //Commented out and replaced by Jerome 11.07.2016 SR 5552
		var maxSeqNo = 0;
		for ( var i = 0; i < defaultDistGroupAllObj.length; i++) {
			if (defaultDistGroupAllObj[i].sequence > maxSeqNo && defaultDistGroupAllObj[i].recordStatus != -1) {
				maxSeqNo = defaultDistGroupAllObj[i].sequence;
			}
		}
		return (parseInt(maxSeqNo) + 1);
	} */
	
	function generateSequenceNo(){
		var maxSeqNo = 0;
		
		try{
			new Ajax.Request(contextPath + "/GIISDefaultOneRiskController", {
				parameters : {action : "getMaxSequenceNo",
							  defaultNo : $F("txtDefaultNo")},
			    asynchronous: false,
				evalScripts: true,
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						maxSeqNo = parseInt(JSON.parse(response.responseText)) + 1;
					}
				}
			});
			
			for (var i=0; i<defaultDistGroupAllObj.length;i++){
				if(maxSeqNo == defaultDistGroupAllObj[i].sequence){
					maxSeqNo = maxSeqNo + 1;
				}
			}
			
			return maxSeqNo;
		}catch(e){
			showErrorMessage("generateSequenceNo",e);
		}
	}
			
	var deleteCtr = 0;
	function valDelDefaultDistGroupRec(){
		var ctrSeqNo = 0;
		for (var i = 0; i < defaultDistGroupAllObj.length; i++) {
			if (defaultDistGroupAllObj[i].sequence > ctrSeqNo && defaultDistGroupAllObj[i].recordStatus != -1) {
				ctrSeqNo = defaultDistGroupAllObj[i].sequence;
			}
		}
		
		if(ctrSeqNo > 1){
			if(ctrSeqNo == parseInt($("txtSequence").value)){
				deleteRec();
			} else {
				showMessageBox("Only records with the last sequence can be deleted.", "I");
				return;
			}
		} else {
			deleteRec();
		}
	}
	
	function deleteRec(){
		if (recomputeTotalPct("delete")){
			return;
		}
		changeTagFunc = saveGiiss065;
		var newObj = setDefaultDistGroupRec(null);
		tbgDefaultDistGroupRowsCount = tbgDefaultDistGroupRowsCount - 1;
		objCurrDefaultDistGroup.recordStatus = -1;
		tbgDefaultDistGroup.deleteRow(rowIndexDefaultDistGroup);
		for(var i = 0; i<defaultDistGroupAllObj.length; i++){
			if ((defaultDistGroupAllObj[i].sequence == newObj.sequence)&&(defaultDistGroupAllObj[i].recordStatus != -1)){
				newObj.recordStatus = -1;
				defaultDistGroupAllObj.splice(i, 1, newObj);
			}
		}
		changeTag = 1;
		changeTagGroup = 1;
		deleteCtr = deleteCtr + 1;
		setFieldValuesDefaultDistGroup(null);
	}
	
	function getAllRecord(defaultNo) {
		try {
			var objReturn = {};
			new Ajax.Request(contextPath + "/GIISDefaultOneRiskController", {
				parameters : {action : "queryAllGiisDefaultDistGroup",
							  defaultNo : defaultNo},
			    asynchronous: false,
				evalScripts: true,
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						var obj = {};
						obj = JSON.parse(response.responseText);
						objReturn = obj.rows;
					}
				}
			});
			return objReturn;
		} catch (e) {
			showErrorMessage("getAllRecord",e);
		}
	}
	
	function getDistGroupRec(defaultNo, rangeFrom, rangeTo) {
		try {
			var objReturn = {};
			new Ajax.Request(contextPath + "/GIISDefaultOneRiskController", {
				parameters : {action : "queryGiisDefaultDistGroup2",
					          refresh : 1,
							  defaultNo : defaultNo,
							  rangeFrom : rangeFrom,
							  rangeTo : rangeTo},
			    asynchronous: false,
				evalScripts: true,
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						var obj = {};
						obj = JSON.parse(response.responseText);
						objReturn = obj.rows;
					}
				}
			});
			return objReturn;
		} catch (e) {
			showErrorMessage("getDistGroupRec",e);
		}
	}
	
	$("btnAddDefaultDistGroup").observe("click", valAddDefaultDistGroupRec);
	$("btnDeleteDefaultDistGroup").observe("click", valDelDefaultDistGroupRec);
	
	function saveGiiss065(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
			
		if($F("txtDefaultType") == "2"){
			if(totalPct != 0 && totalPct != 100){
				showMessageBox("Total % Share must be equal to 100.", "I");
				return;
			}
		}	
		
		var setGIISDefaultDist = getAddedAndModifiedJSONObjects(tbgDefaultDist.geniisysRows);
		var delGIISDefaultDist = getDeletedJSONObjects(tbgDefaultDist.geniisysRows);
		var setGIISDefaultDistDtl = getAddedAndModifiedJSONObjects(tbgRange.geniisysRows);
		var delGIISDefaultDistDtl = getDeletedJSONObjects(tbgRange.geniisysRows);
		var setGIISDefaultDistGroup = getAddedAndModifiedJSONObjects(tbgDefaultDistGroup.geniisysRows);
		var delGIISDefaultDistGroup = getDeletedJSONObjects(tbgDefaultDistGroup.geniisysRows);
		
		if(updateSw == "N"){
			if((setGIISDefaultDistGroup == "" || setGIISDefaultDistGroup == null) && (setGIISDefaultDistDtl != null || setGIISDefaultDistDtl != "") && (delGIISDefaultDistGroup == "" && delGIISDefaultDistDtl == "" && delGIISDefaultDist == "")
					&& (setGIISDefaultDist == "" || setGIISDefaultDist == null)){
				showMessageBox("Cannot save record. Add a share and share percentage first.","I")
				return false;
			}
		}
		
		new Ajax.Request(contextPath+"/GIISDefaultOneRiskController", {
			method: "POST",
			parameters : {action : "saveGiiss065",
						  setGIISDefaultDist : prepareJsonAsParameter(setGIISDefaultDist),
						  delGIISDefaultDist : prepareJsonAsParameter(delGIISDefaultDist),
						  setGIISDefaultDistDtl : prepareJsonAsParameter(setGIISDefaultDistDtl),
						  delGIISDefaultDistDtl : prepareJsonAsParameter(delGIISDefaultDistDtl),
						  setGIISDefaultDistGroup : prepareJsonAsParameter(setGIISDefaultDistGroup),
						  delGIISDefaultDistGroup : prepareJsonAsParameter(delGIISDefaultDistGroup),
						  lineCd : $F("txtLineCd"),
						  defaultNo : $F("txtDefaultNo") //Added by Jerome 10.17.2016 SR 5552
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS065.exitPage != null) {
							tbgDefaultDist.keys.releaseKeys();
							objGIISS065.exitPage();
						} else {
							tbgDefaultDist._refreshList();
							tbgDefaultDist.keys.releaseKeys();
							tbgDefaultDistGroup.keys.releaseKeys();
						}
					});
					changeTag = 0;
					changeTagGroup = 0;
					addCtr = 0;
					deleteCtr = 0;
				}
			}
		});
	}
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}
	
	function cancelGiiss065(){
		if(changeTag == 1 || changeTagGroup == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS065.exitPage = exitPage;
						saveGiiss065();
					}, function(){
						goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
	}
	
	function validateSaveExist(){
		new Ajax.Request(contextPath + "/GIISDefaultOneRiskController", {
			parameters : {action : "validateSaveExist",
						  lineCd : $F("txtLineCd"),
						  sublineCd : $F("txtSublineCd"),
						  issCd : $F("txtIssCd"),
						  distType : $F("txtDistType"),
						  defaultType : $F("txtDefaultType"),
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete : function(response){
				hideNotice();
				if (checkErrorOnResponse(response)){
					var res = JSON.parse(response.responseText);
					if(res.vExists == "Y"){
						showConfirmBox("Confirmation", "Saving this record will delete the existing record for the same line_cd, default_type, dist_type, subline_cd, and iss_cd with NULL range values. Do you want to continue?", "Ok", "Cancel",
								function(){
									saveGiiss065();
								},
								function(){
									
								}, "1");
					} else {
						saveGiiss065();
					}
				}
			}
		});
	}
	
	//observeSaveForm("btnSave", validateSaveExist);
	observeSaveForm("btnSave", saveGiiss065);
	observeReloadForm("reloadForm", showGiiss065);
	$("btnCancel").observe("click", cancelGiiss065);
	//$("btnRange").observe("click", showGiiss065Range);
	
	function showGiiss065Range(){
		try {
			overlayGiiss065Range = 
				Overlay.show(contextPath+"/GIISDefaultOneRiskController", {
					urlContent: true,
					urlParameters: {
						action : "showGiiss065Range",																
						defaultNo : $F("txtDefaultNo"),
						shareCd : objGIISS065.defaultDistGroupList.shareCd
					},
				    title: "Range",
				    height: 400,
				    width: 600,
				    draggable: true
				});
		} catch (e) {
			showErrorMessage("Distribution Range Overlay Error :" , e);
		}
	}
	
	$("menuFileMaintenanceExit").stopObserving("click");
	$("menuFileMaintenanceExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	disableButton("btnDeleteDefaultDist");
	disableButton("btnAddDefaultDistGroup");
	disableButton("btnDeleteDefaultDistGroup");
	//disableButton("btnRange");
	
	$("txtLineCd").focus();	
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
</script>
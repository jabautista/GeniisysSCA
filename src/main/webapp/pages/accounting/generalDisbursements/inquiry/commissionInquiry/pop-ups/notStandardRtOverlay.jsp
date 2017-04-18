<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="contentsDiv" style="padding: 10px 5px 5px 5px;">
	<div class="sectionDiv" id="notStandardRtDiv" style="width: 99%;">
		<table align="center" style="padding: 20px 10px 20px 10px;">
			<tr>
				<td class="rightAligned">From</td>
				<td>
					<div style="float: left; width: 130px;" class="withIconDiv required">
						<input type="text" id="txtFromDate" name="txtFromDate" class="withIcon required" readonly="readonly" style="width: 105px;"/>
						<img id="hrefFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date"/>
					</div>
				</td>
				<td class="rightAligned">To</td>
				<td>
					<div style="float: left; width: 130px;" class="withIconDiv required">
						<input type="text" id="txtToDate" name="txtToDate" class="withIcon required" readonly="readonly" style="width: 105px;"/>
						<img id="hrefToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date"/>
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Branch</td>
				<td colspan="3">
					<span class="lovSpan" style="width:55px; height: 21px; margin: 2px 4px 0 0; float: left;">
						<input  class="rightAligned allCaps"  type="text" id="txtBranchCd" name="txtBranchCd" style="width: 25px; float: left; margin-right: 4px; border: none; height: 13px;" lastValidValue =""/>	
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranchCd" name="searchBranchCd" alt="Go" style="float: right;"/>
					</span>
					<input type="text" id="txtBranchName" name="txtBranchName" style="width: 217px; float: left; text-align: left;" value="" readonly="readonly"/>										
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Line</td>
				<td colspan="3">
					<span class="lovSpan" style="width:55px; height: 21px; margin: 2px 4px 0 0; float: left;">
						<input  class="rightAligned allCaps"  type="text" id="txtLineCd" name="txtLineCd" style="width: 25px; float: left; margin-right: 4px; border: none; height: 13px;" lastValidValue =""/>		
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineCd" name="searchLineCd" alt="Go" style="float: right;"/>
					</span>
					<input type="text" id="txtLineName" name="txtLineName" style="width: 217px; float: left; text-align: left;" value="" readonly="readonly"/>								
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Intm Type</td>
				<td colspan="3">
					<span class="lovSpan" style="width:55px; height: 21px; margin: 2px 4px 0 0; float: left;">
						<input  class="rightAligned allCaps"  type="text" id="txtIntmType" name="txtIntmType" style="width: 25px; float: left; margin-right: 4px; border: none; height: 13px;" lastValidValue =""/>		
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIntmType" name="searchIntmType" alt="Go" style="float: right;"/>
					</span>
					<input type="text" id="txtIntmDesc" name="txtIntmDesc" style="width: 217px; float: left; text-align: left;" value="" readonly="readonly"/>								
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Intermediary</td>
				<td colspan="3">
					<span class="lovSpan" style="width:55px; height: 21px; margin: 2px 4px 0 0; float: left;">
						<input  class="rightAligned"  type="text" id="txtIntmNo" name="txtIntmNo" style="width: 25px; float: left; margin-right: 4px; border: none; height: 13px;" lastValidValue =""/>	
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIntmNo" name="searchIntmNo" alt="Go" style="float: right;"/>
					</span>
					<input type="text" id="txtIntmName" name="txtIntmName" style="width: 217px; float: left; text-align: left;" value="" readonly="readonly"/>										
				</td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv" id="rdoTypeDiv" style="width: 99%; height:130px; padding: 10px 0 10px 0;">
		<fieldset style="width: 42%; height: 100px; float: left; margin-left: 11px;">
			<legend>Date Parameter</legend>
			<table style="margin-top: 8px;">
				<tr>
					<td class="rightAligned">
						<input type="radio"id="rdoEffDate" name="byDate" title="Effectivity Date" style="float: left; margin-right: 3px;"/>
						<label for="rdoEffDate" style="float: left; height: 20px; padding-top: 3px;">Effectivity Date</label>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">
						<input type="radio" checked="checked" id="rdoIssDate" name="byDate" title="Issue Date" style="float: left; margin-right: 3px;"/>
						<label for="rdoIssDate" style="float: left; height: 20px; padding-top: 3px;">Issue Date</label>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">
						<input type="radio"id="rdoActDate" name="byDate" title="Accounting Entry Date" style="float: left; margin-right: 3px;"/>
						<label for="rdoActDate" style="float: left; height: 20px; padding-top: 3px;">Accounting Entry Date</label>
					</td>
				</tr>
			</table>
		</fieldset>
		<fieldset style="width: 42%; height: 100px; float: left;">
			<legend>Branch Parameter</legend>
			<table style="margin-top: 8px;">
				<tr>
					<td class="rightAligned" height="40px">
						<input type="radio" checked="checked" id="rdoIssSource" name="byBranch" title="Issue Source" style="float: left; margin-right: 3px;"/>
						<label for="rdoIssSource" style="float: left; height: 20px; padding-top: 3px;">Issue Source</label>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">
						<input type="radio" id="rdoCredBranch" name="byBranch" title="Crediting Branch" style="float: left; margin-right: 3px;"/>
						<label for="rdoCredBranch" style="float: left; height: 20px; padding-top: 3px;">Crediting Branch</label>
					</td>
				</tr>
			</table>
		</fieldset>
	</div>
	<div id="buttonsDiv" align="center" style="width: 100%; height: 50px;">
		<input type="button" class="button" id="btnOk" name="btnOk" value="OK" style="width: 100px; margin: 10px 0 10px 0;">
	</div>
</div>
<script>
	initializeAll();
	var branchExist = true;
	var lineExist = true;
	var intmTypeExist = true;
	var intmNoExist = true;
	populateNotStandardRt(objACGlobal.hideGIACS221Obj.notStandardRt);
	observeBackSpaceOnDate("txtFromDate");
	observeBackSpaceOnDate("txtFromDate");
	
	function populateNotStandardRt(obj) {
		$("txtFromDate").value 			= obj			== null ? "" : nvl(obj.fromDate,"");
		$("txtToDate").value 			= obj			== null ? "" : nvl(obj.toDate,"");
		$("txtBranchCd").value 			= obj			== null ? "" : unescapeHTML2(nvl(obj.branchCd,""));
		$("txtBranchCd").setAttribute("lastValidValue", $("txtBranchCd").value);
		$("txtBranchName").value 		= obj			== null ? "ALL BRANCHES" : unescapeHTML2(nvl(obj.branchName,"ALL BRANCHES"));
		$("txtLineCd").value 			= obj			== null ? "" : unescapeHTML2(nvl(obj.lineCd,""));
		$("txtLineName").value 			= obj			== null ? "ALL LINES" : unescapeHTML2(nvl(obj.lineName,"ALL LINES"));
		$("txtIntmType").value 			= obj			== null ? "" : unescapeHTML2(nvl(obj.intmType,""));
		$("txtIntmDesc").value 			= obj			== null ? "ALL INTM TYPES" : unescapeHTML2(nvl(obj.intmDesc,"ALL INTM TYPES"));
		$("txtIntmNo").value 			= obj			== null ? "" : unescapeHTML2(nvl(obj.intmNo,""));
		$("txtIntmName").value 			= obj			== null ? "ALL INTERMEDIARIES" : unescapeHTML2(nvl(obj.intmName,"ALL INTERMEDIARIES"));
		if (obj.dateType == "EFF_DATE") {
			$("rdoEffDate").checked = true;
		} else if(obj.dateType == "ISSUE_DATE") {
			$("rdoIssDate").checked = true;
		}else{
			$("rdoActDate").checked = true;
		}
		if (obj.branchType == 'ISS_CD') {
			$("rdoIssSource").checked = true;
		} else {
			$("rdoCredBranch").checked = true;
		}
	}
	
	function setNotStandardRt(obj) {
		obj.fromDate = $F("txtFromDate");
		obj.toDate = $F("txtToDate");
		obj.branchCd = $F("txtBranchCd");
		obj.branchName = $F("txtBranchName");
		obj.lineCd = $F("txtLineCd");
		obj.lineName = $F("txtLineName");
		obj.intmType = $F("txtIntmType");
		obj.intmDesc = $F("txtIntmDesc");
		obj.intmNo = $F("txtIntmNo");
		obj.intmName = $F("txtIntmName");
		if ($("rdoEffDate").checked) {
			obj.dateType = "EFF_DATE";
		} else if($("rdoIssDate").checked) {
			obj.dateType = "ISSUE_DATE";
		}else{
			obj.dateType = "ACC_ENTDATE";
		}
		obj.branchType = $("rdoCredBranch").checked ? "CRED_BRANCH" : "ISS_CD";
	}
	
	function showGiacs221BranchLov(){
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
								 action   : "getGiacs101BranchLOV",
								 moduleId : 'GIACS221',
								 filterText : ($("txtBranchCd").readAttribute("lastValidValue").trim() != $F("txtBranchCd").trim() ? $F("txtBranchCd").trim() : "%"),
								 page : 1
				},
				title: "List of Branches",
				width: 400,
				height: 400,
				columnModel: [
					{
						id : 'branchCd',
						title: 'Branch Code',
						width : '100px',
						align: 'right'
					},
					{
						id : 'branchName',
						title: 'Branch Name',
					    width: '250px',
					    align: 'left'
					}
				],
				draggable: true,
				autoSelectOneRecord: true,
				filterText : ($("txtBranchCd").readAttribute("lastValidValue").trim() != $F("txtBranchCd").trim() ? $F("txtBranchCd").trim() : ""),
				onSelect: function(row) {
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
		}catch(e){
			showErrorMessage("showGiacs221BranchLov",e);
		}
	}
	
	function showGiacs221LineLOV(){
		try{
			LOV.show({
				controller: "AccountingLOVController",
				urlParameters: {
					action: "getGiacs221LineLOV",
					filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : "%"),
					page :	1 
				},
				title: "Lists of Lines",
				width: 405,
				height: 400,
				columnModel:[
				             	{	id : "lineCd",
									title: "Line Code",
									width: '80px'
								},
								{	id : "lineName",
									title: "Line Name",
									width: '310px'
								}
							],
				draggable: true,
				autoSelectOneRecord: true,
				filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
				onSelect: function(row) {
					$("txtLineCd").value = unescapeHTML2(row.lineCd);
					$("txtLineName").value = unescapeHTML2(row.lineName);
					$("txtLineCd").setAttribute("lastValidValue", unescapeHTML2(row.lineCd));
				},
				onCancel: function (){
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
				
			});
		}catch(e){
			showErrorMessage("showGiisLineLOV",e);
		}
	}
	
 	function showGiacs221IntmDescLov(){
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
								 action   :  "getGiacs221IntmLOV",
								 filterText : ($("txtIntmType").readAttribute("lastValidValue").trim() != $F("txtIntmType").trim() ? $F("txtIntmType").trim() : "%"),
								 page : 1
				},
				title: "Intermediary Type",
				width: 405,
				height: 400,
				columnModel: [
					{
						id :   'intmType',
						title: 'Intm. Type',
						width : '80px',
						align: 'left'
					},
					{
						id : 'intmDesc',
						title: 'Intm Desc',
					    width: '310px',
					    align: 'left'
					}
				],
				draggable: true,
				autoSelectOneRecord: true,
				filterText : ($("txtIntmType").readAttribute("lastValidValue").trim() != $F("txtIntmType").trim() ? $F("txtIntmType").trim() : ""),
				onSelect: function(row) {
					$("txtIntmType").value = unescapeHTML2(row.intmType);
					$("txtIntmDesc").value = unescapeHTML2(row.intmDesc);
					$("txtIntmType").setAttribute("lastValidValue", unescapeHTML2(row.intmType));
					$("txtIntmNo").value = "";
					$("txtIntmName").value = "ALL INTERMEDIARIES";
					$("txtIntmNo").setAttribute("lastValidValue", "");
				},
				onCancel: function (){
					$("txtIntmType").value = $("txtIntmType").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtIntmType").value = $("txtIntmType").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
			});
		}catch(e){
			showErrorMessage("showGiacs221IntmDescLov",e);
		}
	}
 	
 	function showGiacs221IntmNameLov(){
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
								 action   : "getGiacs221Intermediary2Lov",
								 intmType : $F("txtIntmType"),
								 filterText : ($("txtIntmNo").readAttribute("lastValidValue").trim() != $F("txtIntmNo").trim() ? $F("txtIntmNo").trim() : "%"),
								 page : 1
				},
				title: "Intermediaries",
				width: 405,
				height: 400,
				columnModel: [
					{
						id :  'intmNo',
						title: 'Intm. No.',
						width : '80px',
						align: 'right'
					},
					{
						id : 'intmName',
						title: 'Intm. Name',
					    width: '310px',
					    align: 'left'
					}
				],
				draggable: true,
				autoSelectOneRecord: true,
				filterText : ($("txtIntmNo").readAttribute("lastValidValue").trim() != $F("txtIntmNo").trim() ? $F("txtIntmNo").trim() : ""),
				onSelect: function(row) {
					$("txtIntmNo").value = row.intmNo;
					$("txtIntmName").value = unescapeHTML2(row.intmName);
					$("txtIntmNo").setAttribute("lastValidValue", unescapeHTML2(row.intmNo));
				},
				onCancel: function (){
					$("txtIntmNo").value = $("txtIntmNo").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtIntmNo").value = $("txtIntmNo").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
			});
		}catch(e){
			showErrorMessage("showGiacs221IntmNameLov",e);
		}
	}
	
	$("searchBranchCd").observe("click", showGiacs221BranchLov);
	
	$("txtBranchCd").observe("change", function() {
		if($F("txtBranchCd").trim() == "") {
			$("txtBranchCd").value = "";
			$("txtBranchName").value = "ALL BRANCHES";
			$("txtBranchCd").setAttribute("lastValidValue", "");
		} else {
			if($F("txtBranchCd").trim() != "" && $F("txtBranchCd") != $("txtBranchCd").readAttribute("lastValidValue")) {
				showGiacs221BranchLov();
			}
		}
	});
	
	$("searchLineCd").observe("click", showGiacs221LineLOV);
	
	$("txtLineCd").observe("change", function() {
		if($F("txtLineCd").trim() == "") {
			$("txtLineCd").value = "";
			$("txtLineName").value = "ALL LINES";
			$("txtLineCd").setAttribute("lastValidValue", "");
		} else {
			if($F("txtLineCd").trim() != "" && $F("txtLineCd") != $("txtLineCd").readAttribute("lastValidValue")) {
				showGiacs221LineLOV();
			}
		}
	});
	
	$("searchIntmType").observe("click", showGiacs221IntmDescLov);
	
	$("txtIntmType").observe("change", function() {
		if($F("txtIntmType").trim() == "") {
			$("txtIntmType").value = "";
			$("txtIntmDesc").value = "ALL INTM TYPES";
			$("txtIntmType").setAttribute("lastValidValue", "");
			$("txtIntmNo").value = "";
			$("txtIntmName").value = "ALL INTERMEDIARIES";
			$("txtIntmNo").setAttribute("lastValidValue", "");
		} else {
			if($F("txtIntmType").trim() != "" && $F("txtIntmType") != $("txtIntmType").readAttribute("lastValidValue")) {
				showGiacs221IntmDescLov();
			}
		}
	});
	
	$("searchIntmNo").observe("click", showGiacs221IntmNameLov);
	
	$("txtIntmNo").observe("change", function() {
		if($F("txtIntmNo").trim() == "") {
			$("txtIntmNo").value = "";
			$("txtIntmName").value = "ALL INTERMEDIARIES";
			$("txtIntmNo").setAttribute("lastValidValue", "");
		} else {
			if($F("txtIntmNo").trim() != "" && $F("txtIntmNo") != $("txtIntmNo").readAttribute("lastValidValue")) {
				showGiacs221IntmNameLov();
			}
		}
	});
	
	$("hrefFromDate").observe("click", function(){
		scwShow($('txtFromDate'),this, null);
	});
	$("hrefToDate").observe("click", function(){
		scwShow($('txtToDate'),this, null);
	});
	
	$("txtFromDate").observe("focus", function(){
		if ($("txtToDate").value != "" && this.value != "") {
			if (compareDatesIgnoreTime(Date.parse($F("txtFromDate")),Date.parse($("txtToDate").value)) == -1) {
				customShowMessageBox("From Date should not be later than To Date.","E","txtFromDate");
				this.clear();
			}
		}
	});
	
	$("txtToDate").observe("focus", function(){
		if ($("txtFromDate").value != ""&& this.value != "") {
			if (compareDatesIgnoreTime(Date.parse($F("txtFromDate")),Date.parse($("txtToDate").value)) == -1) {
				customShowMessageBox("From Date should not be later than To Date.","E","txtToDate");
				this.clear();
			}
		}
	});
	
	$("btnOk").observe("click",function(){
		setNotStandardRt(objACGlobal.hideGIACS221Obj.notStandardRt);
		notStandardRtOverlay.close();
	});
</script>
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
	<div class="sectionDiv" id="unreleaseCommDiv" style="width: 99%;">
		<table align="center" style="padding: 20px;">
			<tr>
				<td class="rightAligned">Branch</td>
				<td colspan="3">
					<span class="lovSpan" style="width:55px; height: 21px; margin: 2px 4px 0 0; float: left;">
						<input  class="rightAligned"  type="text" id="txtBranchCd" name="txtBranchCd" style="width: 25px; float: left; margin-right: 4px; border: none; height: 13px;" lastValidValue =""/>	
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranchCd" name="searchBranchCd" alt="Go" style="float: right;"/>
					</span>
					<input type="text" id="txtBranchName" name="txtBranchName" style="width: 170px; float: left; text-align: left;" value="" readonly="readonly"/>								
				</td>
			</tr>
			<tr> <!-- vondanix 10.07.2015 SR 5019 -->
				<td class="rightAligned">Intermediary</td>
				<td colspan="3">
					<span class="lovSpan" style="width:55px; height: 21px; margin: 2px 4px 0 0; float: left;">
						<input  class="rightAligned"  type="text" id="txtIntmNo" name="txtIntmNo" style="width: 25px; float: left; margin-right: 4px; border: none; height: 13px;" lastValidValue =""/>	
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIntmNo" name="searchIntmNo" alt="Go" style="float: right;"/>
					</span>
					<input type="text" id="txtIntmName" name="txtIntmName" style="width: 170px; float: left; text-align: left;" value="" readonly="readonly"/>								
				</td>
			</tr> 
			<tr>
				<td></td>
				<td>
					<input type="radio" checked="checked" id="rdoIssSource" name="byBranch" title="Issue Source" style="float: left; margin-right: 3px;"/><label for="rdoIssSource" style="float: left; height: 20px; padding-top: 3px;">Issue Source</label>
					<input type="radio" id="rdoCredBranch" name="byBranch" title="Crediting Branch" style="float: left; margin-right: 3px; margin-left: 30px;"/><label for="rdoCredBranch" style="float: left; height: 20px; padding-top: 3px;">Crediting Branch</label>
				</td>
			</tr>
		</table>
	</div>
	<div id="buttonsDiv" align="center" style="width: 100%; height: 50px;">
		<input type="button" class="button" id="btnOk" name="btnOk" value="OK" style="width: 100px; margin: 10px 0 10px 0;">
	</div>
</div>
<script>
	initializeAll();
	var branchExist = true;
	populateUnreleaseComm(objACGlobal.hideGIACS221Obj.unreleaseComm);

	function populateUnreleaseComm(obj) {
		$("txtBranchCd").value 			= obj			== null ? "" : unescapeHTML2(nvl(obj.branchCd,""));
		$("txtBranchCd").setAttribute("lastValidValue", $("txtBranchCd").value);
		$("txtBranchName").value 		= obj			== null ? "ALL BRANCHES" : unescapeHTML2(nvl(obj.branchName,"ALL BRANCHES"));
		//added by vondanix 10.05.2015 SR 5019
		$("txtIntmNo").value 			= obj			== null ? "" : unescapeHTML2(nvl(obj.intmNo,0));
		$("txtIntmNo").setAttribute("lastValidValue", $("txtIntmNo").value);
		$("txtIntmName").value 			= obj			== null ? "ALL INTERMEDIARY" : unescapeHTML2(nvl(obj.intmName,"ALL INTERMEDIARY")); 
		if (obj.branchType == 'ISS_CD') {
			$("rdoIssSource").checked = true;
		} else {
			$("rdoCredBranch").checked = true;
		}
	}
	
	function setUnreleaseComm(obj) {
		obj.branchCd = $F("txtBranchCd");
		obj.branchName = $F("txtBranchName");
		obj.intmNo = $F("txtIntmNo"); //added by vondanix 10.05.2015 SR 5019
		obj.intmName = $F("txtIntmName"); //added by vondanix 10.05.2015 SR 5019
		obj.branchType = $("rdoCredBranch").checked ? "CRED_BRANCH" : "ISS_CD";
	}
	
	function showGiacs221BranchLov(){
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
								 action   : "fetchSimpleBranchLOVNoRI", //"getGiacs101BranchLOV" changed by vondanix 10.06.2015 SR 5019
								 moduleId : 'GIACS221',
								 riIssCd  : 'RI', //vondanix 10.06.2015 SR 5019
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
	
	//added by vondanix 10.05.2015 SR 5019
	function showGiacs221IntermediaryLov(){
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
								 action   : "getGIACS512IntmNoLOV",
								 moduleId : 'GIACS221',
								 filterText : ($("txtIntmNo").readAttribute("lastValidValue").trim() != $F("txtIntmNo").trim() ? $F("txtIntmNo").trim() : "%"),
								 page : 1
				},
				title: "List of Intermediary",
				width: 400,
				height: 400,
				columnModel: [
					{
						id : 'intmNo',
						title: 'Intermediary No.',
						width : '100px',
						align: 'right'
					},
					{
						id : 'intmName',
						title: 'Intermediary Name',
					    width: '250px',
					    align: 'left'
					}
				],
				draggable: true,
				autoSelectOneRecord: true,
				filterText : ($("txtIntmNo").readAttribute("lastValidValue").trim() != $F("txtIntmNo").trim() ? $F("txtIntmNo").trim() : ""),
				onSelect: function(row) {
					$("txtIntmNo").value = row.intmNo;
					$("txtIntmName").value = unescapeHTML2(row.intmName);
					$("txtIntmNo").setAttribute("lastValidValue", row.intmNo);
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
			showErrorMessage("showGiacs221IntermediaryLov",e);
		}
	}
	
	$("searchBranchCd").observe("click", showGiacs221BranchLov);
	$("searchIntmNo").observe("click", showGiacs221IntermediaryLov); //added by vondanix 10.05.2015 SR 5019
	
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
	
	//added by vondanix 10.05.2015 SR 5019
	$("txtIntmNo").observe("change", function() {
		if($F("txtIntmNo").trim() == "") {
			$("txtIntmNo").value = "";
			$("txtIntmName").value = "ALL INTERMEDIARY";
			$("txtIntmNo").setAttribute("lastValidValue", "");
		} else {
			if($F("txtIntmNo").trim() != "" && $F("txtIntmNo") != $("txtIntmNo").readAttribute("lastValidValue")) {
				showGiacs221IntermediaryLov();
			}
		}
	});	

	$("btnOk").observe("click",function(){
		setUnreleaseComm(objACGlobal.hideGIACS221Obj.unreleaseComm);
		unreleaseCommOverlay.close();
	});
</script>
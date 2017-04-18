<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>
<div id="gipis111HiddenValue"><!--  this is use when GICLS260 is called -->
	<input id="lineCd" type="hidden" value="" name="lineCd">
	<input id="menuLineCd" type="hidden" value="" name="menuLineCd">
</div>
<div id="claimInfoDummyMainDiv">
</div>
<div id="casualtyAccumulationDiv" name="casualtyAccumulationDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
   			<label>Casualty Accumulation</label>
   			<span class="refreshers" style="margin-top: 0;">
				<label name="gro" style="margin-left: 5px;">Hide</label> 
			 	<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
	   	</div>
	</div>
	<div id="casualtyAccumulationMainDiv" name="casualtyAccumulationMainDiv" class="sectionDiv" style="border:none; margin: 0 0 2px 0;">
		<div id="casualtyAccumulationBodyDiv" name="casualtyAccumulationBodyDiv" class="sectionDiv">
			<table align="right" style="margin:5px 40px 0 0;">
				<tr>
					<td style="padding-right: 30px">
						<input type="checkbox" name="sortBy" id="chkExcludeExpire" title="Exclude expired records" style="float: left; margin-right: 7px; margin-top: 3px;"/>
						<label for="chkExcludeExpire" style="float: left; height: 20px; padding-top: 3px;">Exclude expired records</label>
					</td>
					<td style="padding-left: 20px">
						<input type="radio" name="busType" id="rdoAssumeBus" title="Assumed Business" style="float: left; margin-right: 7px; margin-top: 3px;"/>	
						<label for="rdoAssumeBus" style="float: left; height: 20px; padding-top: 3px;">Assumed Business</label>
					</td>
				</tr>
				<tr>
					<td style="padding-right: 30px">
						<input type="checkbox" name="sortBy" id="chkExcludeNotEff" title="Exclude not yet effective records" style="float: left; margin-right: 7px; margin-top: 3px;"/>
						<label for="chkExcludeNotEff" style="float: left; height: 20px; padding-top: 3px;">Exclude not yet effective records</label>
					</td>
					<td style="padding-left: 20px">
						<input type="radio" name="busType" id="rdoDirectBus" title="Direct Business" style="float: left; margin-right: 7px; margin-top: 3px;"/>	
						<label for="rdoDirectBus" style="float: left; height: 20px; padding-top: 3px;">Direct Business</label>
					</td>
				</tr>
				<tr>
					<td></td>
					<td style="padding-left: 20px">
						<input type="radio" name="busType" id="rdoAssumeDirectBus" title="Assumed and Direct Business" style="float: left; margin-right: 7px; margin-top: 3px;"/>	
						<label for="rdoAssumeDirectBus" style="float: left; height: 20px; padding-top: 3px;">Assumed and Direct Business</label>
					</td>
				</tr>
			</table>
			<div id="casualtyAccumulationTableDiv" style="padding: 85px 0 0 11px;">
				<div id="casualtyAccumulationTable" style="height: 340px; padding: 10px 0 0 0;"></div>
			</div>
			<table align="center" width="100%">
				<tr>
					<td class="rightAligned" width="100px">Remarks</td>
					<td>
						<div id="remarksDiv" style="border: 1px solid gray; height: 20px; width: 95%;">
							<textarea id="txtGIPIS111Remarks" name="txtGIPIS111Remarks" style="width: 94%; border: none; height: 13px;" readonly="readonly"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editGIPIS111Remarks" textField="txtGIPIS111Remarks" charLimit="2000"/>
						</div>
					</td>
				</tr>
			
			</table>
			<div id="buttonsDiv" name="buttonsDiv" class="buttonsDiv" style="margin: 10px 0 10px 0;">
				<input type="button" id="btnExtract" name="btnExtract" class="button"	style="width:100px;" value="Extract"/>
				<!-- <input type="button" id="btnView" name="btnView" class="button"	style="width:100px;" value="View"/> remove; same kasi ng ginagawa sa extract..-->
			</div>
		</div>	
		<div id="casualtyAccumulationBodyDiv2" name="casualtyAccumulationBodyDiv2">
		</div>
		<div id="casualtyAccumulationBodyDiv3" name="casualtyAccumulationBodyDiv3">
		</div>
		<div id="casualtyAccumulationBodyDiv4" name="casualtyAccumulationBodyDiv3">
		</div>
	</div> 
</div> 

<script type="text/javascript">
	resetPage();
	initializeAll();
	initializeAccordion();
	setModuleId("GIPIS111");
	setDocumentTitle("Casualty Accumulation");
	objUWGlobal.hidGIPIS111Obj = {};
	
	function resetPage() {
		try {
			$("btnToolbarPrint").hide();
			$("casualtyAccumulationBodyDiv").show();
			$("casualtyAccumulationBodyDiv2").hide();
			$("casualtyAccumulationBodyDiv3").hide();
			$("casualtyAccumulationBodyDiv4").hide();
			$("btnToolbarPrintSep").hide();
			$("rdoAssumeDirectBus").checked = true;
			$("chkExcludeNotEff").checked = false;
			$("chkExcludeExpire").checked = false;
			disableToolbarButton("btnToolbarExecuteQuery");
			enableToolbarButton("btnToolbarEnterQuery");
			$("txtGIPIS111Remarks").clear();
		} catch (e) {
			showErrorMessage("resetPage",e);
		}
	}
	
	try {
		var jsonCasualtyAccumulation = JSON.parse('${jsonCasualtyAccumulation}');
		objUWGlobal.hidGIPIS111Obj.selectedObj = null;
		casualtyAccumulationTableModel = {
			url : contextPath+ "/GIPIPolbasicController?action=showViewCasualtyAccumulation&refresh=1",
			options : {
				width : '900px',
				height : '310px',
				onCellFocus : function(element, value, x, y, id) {
					objUWGlobal.hidGIPIS111Obj.selectedObj = tbgCasualtyAccumulation.geniisysRows[y];
					populateCasualty(objUWGlobal.hidGIPIS111Obj.selectedObj);
					tbgCasualtyAccumulation.keys.removeFocus(tbgCasualtyAccumulation.keys._nCurrentFocus, true);
					tbgCasualtyAccumulation.keys.releaseKeys();
				},
				onRowDoubleClick: function(y){
					objUWGlobal.hidGIPIS111Obj.selectedObj = tbgCasualtyAccumulation.geniisysRows[y];
					if (objUWGlobal.hidGIPIS111Obj.selectedObj != null) {
						showCasualtyAccumulationDtl();
					} else {
						showMessageBox("Please specify the record to be retrieved.","I");
					}
					tbgCasualtyAccumulation.keys.removeFocus(tbgCasualtyAccumulation.keys._nCurrentFocus, true);
					tbgCasualtyAccumulation.keys.releaseKeys();
				},
				postPager : function() {
					objUWGlobal.hidGIPIS111Obj.selectedObj = null;
					populateCasualty(null);
					tbgCasualtyAccumulation.keys.removeFocus(tbgCasualtyAccumulation.keys._nCurrentFocus, true);
					tbgCasualtyAccumulation.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					objUWGlobal.hidGIPIS111Obj.selectedObj = null;
					populateCasualty(null);
					tbgCasualtyAccumulation.keys.removeFocus(tbgCasualtyAccumulation.keys._nCurrentFocus, true);
					tbgCasualtyAccumulation.keys.releaseKeys();
				},
				onSort : function() {
					objUWGlobal.hidGIPIS111Obj.selectedObj = null;
					populateCasualty(null);
					tbgCasualtyAccumulation.keys.removeFocus(tbgCasualtyAccumulation.keys._nCurrentFocus, true);
					tbgCasualtyAccumulation.keys.releaseKeys();
				},
				toolbar : {
					elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
					onFilter : function() {
						objUWGlobal.hidGIPIS111Obj.selectedObj = null;
						populateCasualty(null);
						tbgCasualtyAccumulation.keys.removeFocus(tbgCasualtyAccumulation.keys._nCurrentFocus, true);
						tbgCasualtyAccumulation.keys.releaseKeys();
					},
					onRefresh : function() {
						objUWGlobal.hidGIPIS111Obj.selectedObj = null;
						populateCasualty(null);
						tbgCasualtyAccumulation.keys.removeFocus(tbgCasualtyAccumulation.keys._nCurrentFocus, true);
						tbgCasualtyAccumulation.keys.releaseKeys();
					},
				}
			},
			columnModel : [
					{
						id : 'recordStatus',
						title : '',
						width : '0',
						visible : false
					},
					{
						id : 'divCtrId',
						width : '0',
						visible : false
					},
					{
						id : "locationCd",
						title : "Code",
						width : '80px',
						titleAlign: 'right',
						align: 'right',
						filterOption: true
					},
					{
						id : "locationDesc",
						title : "Description",
						width : '300px',
						filterOption: true
					},
					{
						id : "dspFromDate",
						title : "From",
						width : '100px',
						titleAlign: 'center',
						align: 'center',
						filterOptionType: 'formattedDate',
						filterOption: true
					},
					{
						id : "dspToDate",
						title : "To",
						width : '100px',
						titleAlign: 'center',
						align: 'center',
						filterOptionType: 'formattedDate',
						filterOption: true
					},
					{
						id : "retLimit",
						title : "Retention Limit",
						width : '150px',
						titleAlign: 'right',
						align: 'right',
						geniisysClass: 'money',
						filterOptionType: 'number',
						filterOption: true
					},
					{
						id : "treatyLimit",
						title : "Treaty Limit",
						width : '150px',
						titleAlign: 'right',
						align: 'right',
						geniisysClass: 'money',
						filterOptionType: 'number',
						filterOption: true
					}
				],
			rows : jsonCasualtyAccumulation.rows
		};
		tbgCasualtyAccumulation = new MyTableGrid(casualtyAccumulationTableModel);
		tbgCasualtyAccumulation.pager = jsonCasualtyAccumulation;
		tbgCasualtyAccumulation.render('casualtyAccumulationTable');
	} catch (e) {
		showErrorMessage("casualtyAccumulationTableModel", e);
	}
	
	function populateCasualty(obj) {
		$("txtGIPIS111Remarks").value		= obj == null ? "" : unescapeHTML2(nvl(obj.remarks,""));
	}
 	
 	function showCasualtyAccumulationDtl() {
 		try{
 			objUWGlobal.hidGIPIS111Obj.busType = "3";
			objUWGlobal.hidGIPIS111Obj.excludeExpired = $("chkExcludeExpire").checked ? "Y" : "N";
			objUWGlobal.hidGIPIS111Obj.excludeNotEff = $("chkExcludeNotEff").checked ? "Y" : "N";
			if ($("rdoAssumeBus").checked) {
				objUWGlobal.hidGIPIS111Obj.busType = "2";
			} else if($("rdoDirectBus").checked) {
				objUWGlobal.hidGIPIS111Obj.busType = "1";
			}else if($("rdoAssumeDirectBus").checked){
				objUWGlobal.hidGIPIS111Obj.busType = "3";
			}
 			new Ajax.Request(contextPath+"/GIPIPolbasicController",{
 				method: "POST",
 				parameters : { action : "showCasualtyAccumulationDtl",
			 				   locationCd : objUWGlobal.hidGIPIS111Obj.selectedObj.locationCd,
			                   busType : objUWGlobal.hidGIPIS111Obj.busType,
			                   excludeExpired : objUWGlobal.hidGIPIS111Obj.excludeExpired,
			                   excludeNotEff : objUWGlobal.hidGIPIS111Obj.excludeNotEff},
 				asynchronous: false,
 				evalScripts: true,
 				onCreate: function (){
 					showNotice("Loading, please wait...");
 				},
 				onComplete: function(response){
 					hideNotice();
 					if (checkErrorOnResponse(response)){
 						$("casualtyAccumulationBodyDiv").hide();
 						$("casualtyAccumulationBodyDiv3").hide();
 						$("casualtyAccumulationBodyDiv4").hide();
 						$("casualtyAccumulationBodyDiv2").update(response.responseText);
 						$("casualtyAccumulationBodyDiv2").show();
 						
 					}
 				}
 			});
 		} catch(e){
 			showErrorMessage("showCasualtyAccumulationDtl", e);
 		}
 	}
 	
 	$("btnExtract").observe("click" , function() {
 		if (objUWGlobal.hidGIPIS111Obj.selectedObj != null) {
 			showCasualtyAccumulationDtl();
		} else {
			showMessageBox("Please specify the record to be retrieved.","I");
		}
	});
 	
 	$("editGIPIS111Remarks").observe("click", function(){
		showEditor("txtGIPIS111Remarks", 2000,'true');
	});
 	
	$("btnToolbarExecuteQuery").observe("click" , function() {
		objUWGlobal.hidGIPIS111Obj.selectedObj = null;
		disableToolbarButton("btnToolbarExecuteQuery");
		enableToolbarButton("btnToolbarEnterQuery");
		tbgCasualtyAccumulation.url = contextPath+ "/GIPIPolbasicController?action=showViewCasualtyAccumulation&refresh=1";
		tbgCasualtyAccumulation._refreshList();
	});

	$("btnToolbarEnterQuery").observe("click" , function() {
		 objUWGlobal.hidGIPIS111Obj.selectedObj = null;
		 resetPage();
		 enableToolbarButton("btnToolbarExecuteQuery");
		 disableToolbarButton("btnToolbarEnterQuery");
		 tbgCasualtyAccumulation.url = contextPath+ "/GIPIPolbasicController?action=showViewCasualtyAccumulation&refresh=1&enterQuery=Y";
		 tbgCasualtyAccumulation._refreshList();
	});
	
	$("btnToolbarExit").observe("click" , function() {
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});

	$("reloadForm").observe("click" , function() {
		showViewPropertyFloaterAccumulation();
	});
</script>
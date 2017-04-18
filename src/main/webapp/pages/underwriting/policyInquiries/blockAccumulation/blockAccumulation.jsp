<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>
<div id="gipis110HiddenValue"><!--  this is use when GICLS260 is called -->
	<input id="lineCd" type="hidden" value="" name="lineCd">
	<input id="menuLineCd" type="hidden" value="" name="menuLineCd">
</div>
<div id="claimInfoDummyMainDiv">
</div>
<div id="blockAccumulationDiv" name="blockAccumulationDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
   			<label>Block Accumulation</label>
   			<span class="refreshers" style="margin-top: 0;">
			 	<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
	   	</div>
	</div>
	<div id="blockAccumulationMainDiv" name="blockAccumulationMainDiv">
		<div id="blockAccumulationBodyDiv" name="blockAccumulationBodyDiv" class="sectionDiv" style="margin-bottom: 20px;">
		<div id="blockAccumulationHead1" style="float: left; width: 45%;">
			<table align="left" style="margin:10px 0 0 35px;">
				<tr>
					<td class="rightAligned" style="width: 65px;" id="">Province</td>
					<td class="leftAligned">
						<span class="lovSpan required" style="float: left; width: 65px; margin-right: 5px; margin-top: 2px; height: 21px;">
							<input maxlength="6" class="required" type="text" id="txtProvCd" name="txtProvCd" style="width: 40px; float: left; border: none; height: 15px; margin: 0;" lastValidValue="" ignoreDelKey = "true" tabindex="101"/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchProvCd" name="imgSearchProvCd" alt="Go" style="float: right;"/>
						</span>
						<input class="required" id="txtProvName" name="txtProvName" type="text" style="width: 222px;" value="" readonly="readonly" tabindex="102"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 65px;" id="">City</td>
					<td class="leftAligned">
						<span class="lovSpan required" style="float: left; width: 300px; margin-right: 5px; margin-top: 2px; height: 21px;">
							<input class="required" type="hidden" id="txtCityCd" name="txtCityCd" lastValidValue=""/>
							<input maxlength="40" class="required allCaps" type="text" id="txtCityName" name="txtCityName" style="width: 275px; float: left; border: none; height: 15px; margin: 0;" lastValidValue="" ignoreDelKey = "true" tabindex="103"/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchCityCd" name="imgSearchCityCd" alt="Go" style="float: right;"/>
						</span>
					</td>
				</tr>
			</table>
		</div>
		<div id="blockAccumulationHead2"  style="float: left; width: 55%; ">
			<table align="right" style="margin:5px 40px 0 0; border-collapse: collapse;">
				<tr>
					<td style="padding-right: 10px">
						<input type="checkbox" name="sortBy" id="chkExcludeExpire" title="Exclude expired records" style="float: left; margin-right: 7px; margin-top: 3px;" tabindex="104"/>
						<label for="chkExcludeExpire" style="float: left; height: 20px; padding-top: 3px;">Exclude expired records</label>
					</td>
					<td style="padding-left: 20px">
						<input type="radio" name="busType" id="rdoAssumeBus" title="Assumed Business" style="float: left; margin-right: 7px; margin-top: 3px;" tabindex="106"/>	
						<label for="rdoAssumeBus" style="float: left; height: 20px; padding-top: 3px;">Assumed Business</label>
					</td>
				</tr>
				<tr>
					<td style="padding-right: 10px">
						<input type="checkbox" name="sortBy" id="chkExcludeNotEff" title="Exclude not yet effective records" style="float: left; margin-right: 7px; margin-top: 3px;" tabindex="105"/>
						<label for="chkExcludeNotEff" style="float: left; height: 20px; padding-top: 3px;">Exclude not yet effective records</label>
					</td>
					<td style="padding-left: 20px">
						<input type="radio" name="busType" id="rdoDirectBus" title="Direct Business" style="float: left; margin-right: 7px; margin-top: 3px;" tabindex="107"/>	
						<label for="rdoDirectBus" style="float: left; height: 20px; padding-top: 3px;">Direct Business</label>
					</td>
				</tr>
				<tr>
					<td></td>
					<td style="padding-left: 20px">
						<input type="radio" name="busType" id="rdoAssumeDirectBus" title="Assumed and Direct Business" style="float: left; margin-right: 7px; margin-top: 3px;" tabindex="108"/>	
						<label for="rdoAssumeDirectBus" style="float: left; height: 20px; padding-top: 3px;">Assumed and Direct Business</label>
					</td>
				</tr>
			</table>
		</div>
			<div id="blockAccumulationTableDiv" style="padding: 85px 0 0 11px;">
				<div id="blockAccumulationTable" style="height: 340px; padding: 10px 0 0 0;"></div>
			</div>
			<table align="center" width="100%">
				<tr>
					<td class="rightAligned" width="100px">District Desc</td>
					<td class="leftAligned">
						<div id="districtDiv" style="border: 1px solid gray; height: 20px; width: 95%;">
							<textarea id="txtGIPIS110District" name="txtGIPIS110District" style="width: 94%; border: none; height: 13px;" readonly="readonly" tabindex="109"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editGIPIS110District" textField="txtGIPIS110District" charLimit="40"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" width="100px">Remarks</td>
					<td class="leftAligned">
						<div id="remarksDiv" style="border: 1px solid gray; height: 20px; width: 95%;">
							<textarea id="txtGIPIS110Remarks" name="txtGIPIS110Remarks" style="width: 94%; border: none; height: 13px;" readonly="readonly" tabindex="110"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editGIPIS110Remarks" textField="txtGIPIS110Remarks" charLimit="4000"/>
						</div>
					</td>
				</tr>
			
			</table>
			<div id="buttonsDiv" name="buttonsDiv" class="buttonsDiv" style="margin: 10px 0 10px 0;">
				<input type="button" id="btnOk" name="btnOk" class="button"	style="width:100px;" value="Ok" tabindex="111"/>
			</div>
		</div>	
		<div id="blockAccumulationBodyDiv2" name="blockAccumulationBodyDiv2">
		</div>
		<div id="blockAccumulationBodyDiv3" name="blockAccumulationBodyDiv3">
		</div>
		<div id="blockAccumulationBodyDiv4" name="blockAccumulationBodyDiv4">
		</div>
		<div id="blockAccumulationBodyDiv5" name="blockAccumulationBodyDiv5">
		</div>
	</div> 
</div> 

<script type="text/javascript">
	resetPage();
	initializeAll();
	setModuleId("GIPIS110");
	setDocumentTitle("Block Accumulation");
	objUWGlobal.hidGIPIS110Obj = {};
	
	function resetPage() {
		try {
			$("txtProvCd").focus();
			$("btnToolbarPrint").hide();
			$("blockAccumulationBodyDiv").show();
			$("blockAccumulationBodyDiv2").hide();
			$("blockAccumulationBodyDiv3").hide();
			$("blockAccumulationBodyDiv4").hide();
			$("blockAccumulationBodyDiv5").hide();
			$("btnToolbarPrintSep").hide();
			$("rdoAssumeDirectBus").checked = true;
			$("chkExcludeNotEff").checked = false;
			$("chkExcludeExpire").checked = false;
			disableToolbarButton("btnToolbarExecuteQuery");
			disableToolbarButton("btnToolbarEnterQuery");
			$("txtGIPIS110Remarks").clear();
			$("txtGIPIS110District").clear();
			$("txtProvCd").clear();
			$("txtProvName").clear();
			$("txtCityName").clear();
			$("txtCityCd").clear();
			$("txtCityName").setAttribute("lastValidValue", "");	
			$("txtProvCd").setAttribute("lastValidValue", "");
			$("txtProvCd").readOnly = false;	
			$("txtCityName").readOnly = false;	
			enableSearch("imgSearchProvCd");
			enableSearch("imgSearchCityCd");
			$("chkExcludeExpire").checked = false;
			$("chkExcludeNotEff").checked = false;
		} catch (e) {
			showErrorMessage("resetPage",e);
		}
	}
	
	try {
		var jsonBlockAccumulation = JSON.parse('${jsonBlockAccumulation}');
		objUWGlobal.hidGIPIS110Obj.selectedObj = null;
		blockAccumulationTableModel = {
			url : contextPath+ "/GIPIPolbasicController?action=showViewBlockAccumulation&refresh=1",
			options : {
				width : '900px',
				height : '310px',
				onCellFocus : function(element, value, x, y, id) {
					objUWGlobal.hidGIPIS110Obj.selectedObj = tbgBlockAccumulation.geniisysRows[y];
					populateBlock(objUWGlobal.hidGIPIS110Obj.selectedObj);
					tbgBlockAccumulation.keys.removeFocus(tbgBlockAccumulation.keys._nCurrentFocus, true);
					tbgBlockAccumulation.keys.releaseKeys();
				},
				onRowDoubleClick: function(y){
					objUWGlobal.hidGIPIS110Obj.selectedObj = tbgBlockAccumulation.geniisysRows[y];
					if (objUWGlobal.hidGIPIS110Obj.selectedObj != null) {
						showBlockAccumulationDtl();
					} else {
						showMessageBox("Please specify the record to be retrieved.","I");
					}
					tbgBlockAccumulation.keys.removeFocus(tbgBlockAccumulation.keys._nCurrentFocus, true);
					tbgBlockAccumulation.keys.releaseKeys();
				},
				postPager : function() {
					objUWGlobal.hidGIPIS110Obj.selectedObj = null;
					populateBlock(null);
					tbgBlockAccumulation.keys.removeFocus(tbgBlockAccumulation.keys._nCurrentFocus, true);
					tbgBlockAccumulation.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					objUWGlobal.hidGIPIS110Obj.selectedObj = null;
					populateBlock(null);
					tbgBlockAccumulation.keys.removeFocus(tbgBlockAccumulation.keys._nCurrentFocus, true);
					tbgBlockAccumulation.keys.releaseKeys();
				},
				onSort : function() {
					objUWGlobal.hidGIPIS110Obj.selectedObj = null;
					populateBlock(null);
					tbgBlockAccumulation.keys.removeFocus(tbgBlockAccumulation.keys._nCurrentFocus, true);
					tbgBlockAccumulation.keys.releaseKeys();
				},
				toolbar : {
					elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
					onFilter : function() {
						objUWGlobal.hidGIPIS110Obj.selectedObj = null;
						populateBlock(null);
						tbgBlockAccumulation.keys.removeFocus(tbgBlockAccumulation.keys._nCurrentFocus, true);
						tbgBlockAccumulation.keys.releaseKeys();
					},
					onRefresh : function() {
						objUWGlobal.hidGIPIS110Obj.selectedObj = null;
						populateBlock(null);
						tbgBlockAccumulation.keys.removeFocus(tbgBlockAccumulation.keys._nCurrentFocus, true);
						tbgBlockAccumulation.keys.releaseKeys();
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
						id : "districtNo",
						title : "District No.",
						width : '120px',
						filterOption: true
					},
					{
						id : "blockNo",
						title : "Block No.",
						width : '120px',
						filterOption: true
					},
					{
						id : "blockDesc",
						title : "Block Description",
						width : '320px',
						filterOption: true
					},
					{
						id : "retnLimAmt",
						title : "Retention Limit",
						width : '150px',
						titleAlign: 'right',
						align: 'right',
						geniisysClass: 'money',
						filterOptionType: 'number',
						filterOption: true
					},
					{
						id : "trtyLimAmt",
						title : "Treaty Limit",
						width : '150px',
						titleAlign: 'right',
						align: 'right',
						geniisysClass: 'money',
						filterOptionType: 'number',
						filterOption: true
					}
				],
			rows : jsonBlockAccumulation.rows
		};
		tbgBlockAccumulation = new MyTableGrid(blockAccumulationTableModel);
		tbgBlockAccumulation.pager = jsonBlockAccumulation;
		tbgBlockAccumulation.render('blockAccumulationTable');
	} catch (e) {
		showErrorMessage("blockAccumulationTableModel", e);
	}
	
	function populateBlock(obj) {
		$("txtGIPIS110Remarks").value		= obj == null ? "" : unescapeHTML2(nvl(obj.remarks,""));
		$("txtGIPIS110District").value		= obj == null ? "" : unescapeHTML2(nvl(obj.districtDesc,""));
	}
	
	function showGIPIS110ProvinceLOV(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getGipis110ProvinceLOV",
							findText2 : ($("txtProvCd").readAttribute("lastValidValue").trim() != $F("txtProvCd").trim() ? $F("txtProvCd").trim() : ""),
							page : 1},
			title: "List of Provinces",
			width: 500,
			height: 400,
			columnModel : [
							{
								id : "provinceCd",
								title: "Code",
								width: '100px',
								filterOption: true
							},
							{
								id : "provinceDesc",
								title: "Province",
								width: '325px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("txtProvCd").readAttribute("lastValidValue").trim() != $F("txtProvCd").trim() ? $F("txtProvCd").trim() : ""),
				onSelect: function(row) {
					$("txtProvCd").value = row.provinceCd;
					$("txtProvName").value = row.provinceDesc;
					$("txtProvCd").setAttribute("lastValidValue", row.provinceCd);	
					$("txtCityName").focus();
					enableToolbarButton("btnToolbarEnterQuery");
				},
				onCancel: function (){
					$("txtProvCd").value = $("txtProvCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtProvCd").value = $("txtProvCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	function showGIPIS110CityLOV(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getGipis110CityLOV",
							findText2 : ($("txtCityName").readAttribute("lastValidValue").trim() != $F("txtCityName").trim() ? $F("txtCityName").trim() : ""),
							provinceCd : $F("txtProvCd"),
							page : 1},
			title: "List of Cities",
			width: 500,
			height: 400,
			columnModel : [
							{
								id : "cityCd",
								title: "Code",
								width: '100px',
								filterOption: true
							},
							{
								id : "city",
								title: "City",
								width: '325px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("txtCityName").readAttribute("lastValidValue").trim() != $F("txtCityName").trim() ? $F("txtCityName").trim() : ""),
				onSelect: function(row) {
					$("txtCityName").value = row.city;
					$("txtCityCd").value = row.cityCd;
					$("txtCityName").setAttribute("lastValidValue", row.city);	
					$("txtProvCd").value = row.provinceCd;
					$("txtProvName").value = row.provinceDesc;
					$("txtProvCd").setAttribute("lastValidValue", row.provinceCd);	
					enableToolbarButton("btnToolbarExecuteQuery");
					enableToolbarButton("btnToolbarEnterQuery");
					
				},
				onCancel: function (){
					$("txtCityName").value = $("txtCityName").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtCityName").value = $("txtCityName").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
 	
 	function showBlockAccumulationDtl() {
 		try{
 			objUWGlobal.hidGIPIS110Obj.busType = "3";
			objUWGlobal.hidGIPIS110Obj.excludeExpired = $("chkExcludeExpire").checked ? "Y" : "N";
			objUWGlobal.hidGIPIS110Obj.excludeNotEff = $("chkExcludeNotEff").checked ? "Y" : "N";
			if ($("rdoAssumeBus").checked) {
				objUWGlobal.hidGIPIS110Obj.busType = "2";
			} else if($("rdoDirectBus").checked) {
				objUWGlobal.hidGIPIS110Obj.busType = "1";
			}else if($("rdoAssumeDirectBus").checked){
				objUWGlobal.hidGIPIS110Obj.busType = "3";
			}
 			new Ajax.Request(contextPath+"/GIPIPolbasicController",{
 				method: "POST",
 				parameters : { action : "showBlockAccumulationDtl",
 							   blockId : objUWGlobal.hidGIPIS110Obj.selectedObj.blockId,
 							   excludeNotEff : objUWGlobal.hidGIPIS110Obj.excludeNotEff,
 							   exclude : objUWGlobal.hidGIPIS110Obj.excludeExpired,
 							   districtNo : objUWGlobal.hidGIPIS110Obj.selectedObj.districtNo,
 							   blockNo : objUWGlobal.hidGIPIS110Obj.selectedObj.blockNo,
 							   provinceCd : $F("txtProvCd"),
							   cityCd : $F("txtCityCd"),
							   city : $F("txtCityName"),
			                   busType : objUWGlobal.hidGIPIS110Obj.busType},
 				asynchronous: false,
 				evalScripts: true,
 				onCreate: function (){
 					showNotice("Loading, please wait...");
 				},
 				onComplete: function(response){
 					hideNotice();
 					if (checkErrorOnResponse(response)){
 						$("blockAccumulationBodyDiv").hide();
 						$("blockAccumulationBodyDiv3").hide();
 						$("blockAccumulationBodyDiv4").hide();
 						$("blockAccumulationBodyDiv5").hide();
 						$("blockAccumulationBodyDiv2").update(response.responseText);
 						$("blockAccumulationBodyDiv2").show();
 						
 					}
 				}
 			});
 		} catch(e){
 			showErrorMessage("showBlockAccumulationDtl", e);
 		}
 	}
 	
 	$("imgSearchProvCd").observe("click", showGIPIS110ProvinceLOV);
	$("imgSearchCityCd").observe("click", showGIPIS110CityLOV);
	
	$("txtProvCd").observe("change", function() {		
		if($F("txtProvCd").trim() == "") {
			$("txtProvCd").value = "";
			$("txtProvCd").setAttribute("lastValidValue", "");
			$("txtProvName").value = "";
		} else {
			if($F("txtProvCd").trim() != "" && $F("txtProvCd") != $("txtProvCd").readAttribute("lastValidValue")) {
				showGIPIS110ProvinceLOV();
			}
		}
	});	 	
	
	$("txtCityName").observe("change", function() {		
		if($F("txtCityName").trim() == "") {
			$("txtCityName").value = "";
			$("txtCityName").setAttribute("lastValidValue", "");
			$("txtCityCd").value = "";
		} else {
			if($F("txtCityName").trim() != "" && $F("txtCityName") != $("txtCityName").readAttribute("lastValidValue")) {
				showGIPIS110CityLOV();
			}
		}
	});	 	
 	
 	$("btnOk").observe("click" , function() {
 		if (objUWGlobal.hidGIPIS110Obj.selectedObj != null) {
 			showBlockAccumulationDtl();
		} else {
			showMessageBox("Please specify the record to be retrieved.","I");
		}
	});
 	
 	$("editGIPIS110Remarks").observe("click", function(){
		showEditor("txtGIPIS110Remarks", 2000,'true');
	});
 	
 	$("editGIPIS110District").observe("click", function(){
		showEditor("txtGIPIS110District", 2000,'true');
	});
 	
	$("btnToolbarExecuteQuery").observe("click" , function() {
		if (checkAllRequiredFieldsInDiv("blockAccumulationHead1")) {
			objUWGlobal.hidGIPIS110Obj.selectedObj = null;
			disableToolbarButton("btnToolbarExecuteQuery");
			enableToolbarButton("btnToolbarEnterQuery");
			$("txtProvCd").readOnly = true;	
			$("txtCityName").readOnly = true;
			disableSearch("imgSearchProvCd");
			disableSearch("imgSearchCityCd");
// 			$("chkExcludeExpire").checked = true;
// 			$("chkExcludeNotEff").checked = true;
			tbgBlockAccumulation.url = contextPath+ "/GIPIPolbasicController?action=showViewBlockAccumulation&refresh=1&cityCd="+  encodeURIComponent($F("txtCityCd"))
																													 +"&provinceCd="+  encodeURIComponent($F("txtProvCd"));
			tbgBlockAccumulation._refreshList();
			if (tbgBlockAccumulation.geniisysRows.length < 1) {
				showMessageBox("Query caused no records to be retrieved.", "I");
			}
		}
	});

	$("btnToolbarEnterQuery").observe("click" , function() {
		 objUWGlobal.hidGIPIS110Obj.selectedObj = null;
		 resetPage();
		 tbgBlockAccumulation.url = contextPath+ "/GIPIPolbasicController?action=showViewBlockAccumulation&refresh=1";
		 tbgBlockAccumulation._refreshList();
	});
	
	$("btnToolbarExit").observe("click" , function() {
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});

	$("reloadForm").observe("click" , function() {
		showViewBlockAccumulation();
	});
	var fiAccess = '${fiAccess}';
	if (fiAccess == '0') {
		showWaitingMessageBox("You have no access to any Fire line.","I",
				function(){
					goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
				});
	}
</script>
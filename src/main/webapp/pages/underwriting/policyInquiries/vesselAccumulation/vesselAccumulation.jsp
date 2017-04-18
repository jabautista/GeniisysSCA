<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>

<div id="vesselAccumulationDiv" name="vesselAccumulationDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
   			<label>View Vessel Accumulation</label>
   			<span class="refreshers" style="margin-top: 0;">
				<label name="gro" style="margin-left: 5px;">Hide</label> 
			 	<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
	   	</div>
	</div>
	<div id="vesselAccumulationMainDiv" name="vesselAccumulationMainDiv" class="sectionDiv" style="border:none; margin: 0 0 2px 0;">
		<div id="vesselAccumulationBodyDiv" name="vesselAccumulationBodyDiv" class="sectionDiv">
			<table align="right" style="margin:5px 40px 0 0;">
				<tr>
					<td style="padding-right: 30px">
						<input type="checkbox" name="sortBy" id="chkExcludeNotEff" title="Exclude not yet effective records" style="float: left; margin-right: 7px; margin-top: 3px;"/>
						<label for="chkExcludeNotEff" style="float: left; height: 20px; padding-top: 3px;">Exclude not yet effective records</label>
					</td>
					<td style="padding-left: 20px">
						<input type="radio" name="busType" id="rdoAssumeBus" title="Assumed Business" style="float: left; margin-right: 7px; margin-top: 3px;"/>	
						<label for="rdoAssumeBus" style="float: left; height: 20px; padding-top: 3px;">Assumed Business</label>
					</td>
				</tr>
				<tr>
					<td style="padding-right: 30px">
						<input type="checkbox" name="sortBy" id="chkExcludeExpire" title="Exclude expired records" style="float: left; margin-right: 7px; margin-top: 3px;"/>
						<label for="chkExcludeExpire" style="float: left; height: 20px; padding-top: 3px;">Exclude expired records</label>
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
			<div id="vesselAccumulationTableDiv" style="padding: 85px 0 0 11px;">
				<div id="vesselAccumulationTable" style="height: 340px; padding: 10px 0 0 0;"></div>
			</div>
			<div id="buttonsDiv" name="buttonsDiv" class="buttonsDiv" style="margin: 10px 0 10px 0;">
				<input type="button" id="btnView" name="btnView" class="button"	style="width:100px;" value="View"/>
			</div>
		</div>	
	</div> 
</div> 

<script type="text/javascript">
	resetPage();
	initializeAll();
	initializeAccordion();
	setModuleId("GIPIS109");
	setDocumentTitle("View Vessel Accumulation");
	objUWGlobal.hidGIPIS109Obj = {};
	
	function resetPage() {
		try {
			$("btnToolbarPrint").hide();
			$("btnToolbarPrintSep").hide();
			$("rdoAssumeDirectBus").checked = true;
			$("chkExcludeNotEff").checked = true;
			$("chkExcludeExpire").checked = true;
			disableToolbarButton("btnToolbarExecuteQuery");
			enableToolbarButton("btnToolbarEnterQuery");
		} catch (e) {
			showErrorMessage("resetPage",e);
		}
	}
	function showOnLoadMsg(msg) {
		showMessageBox(msg,"E");
		jsonVesselAccumulation.rows = [];
		jsonVesselAccumulation.total = 0;
		$("rdoAssumeDirectBus").checked = false;
		enableToolbarButton("btnToolbarExecuteQuery");
		disableToolbarButton("btnToolbarEnterQuery");
	}
	
	try {
		var jsonVesselAccumulation = JSON.parse('${jsonVesselAccumulation}');
		for ( var i = 0; i < jsonVesselAccumulation.rows.length; i++) {
			if (jsonVesselAccumulation.rows[i].lineMnMsg != null) {
				showOnLoadMsg(jsonVesselAccumulation.rows[i].lineMnMsg);
			} else if(jsonVesselAccumulation.rows[i].lineMhMsg != null) {
				showOnLoadMsg(jsonVesselAccumulation.rows[i].lineMhMsg);
			}else if(jsonVesselAccumulation.rows[i].lineAvMsg != null){
				showOnLoadMsg(jsonVesselAccumulation.rows[i].lineAvMsg);
			}
			break;
		}
		objUWGlobal.hidGIPIS109Obj.selectedObj = null;
		vesselAccumulationTableModel = {
			url : contextPath+ "/GIPIPolbasicController?action=showViewVesselAccumulation&refresh=1",
			options : {
				width : '900px',
				height : '310px',
				onCellFocus : function(element, value, x, y, id) {
					objUWGlobal.hidGIPIS109Obj.selectedObj = tbgVesselAccumulation.geniisysRows[y];
// 					populateVessel(objUWGlobal.hidGIPIS109Obj.selectedObj);
					tbgVesselAccumulation.keys.removeFocus(tbgVesselAccumulation.keys._nCurrentFocus, true);
					tbgVesselAccumulation.keys.releaseKeys();
				},
				onRowDoubleClick: function(y){
					objUWGlobal.hidGIPIS109Obj.selectedObj = tbgVesselAccumulation.geniisysRows[y];
					if (objUWGlobal.hidGIPIS109Obj.selectedObj != null) {
			 			showVesselAccumulationDtlOverlay();
					} else {
						showMessageBox("Please specify the record to be retrieved.","I");
					}
					tbgVesselAccumulation.keys.removeFocus(tbgVesselAccumulation.keys._nCurrentFocus, true);
					tbgVesselAccumulation.keys.releaseKeys();
				},
				postPager : function() {
					objUWGlobal.hidGIPIS109Obj.selectedObj = null;
					tbgVesselAccumulation.keys.removeFocus(tbgVesselAccumulation.keys._nCurrentFocus, true);
					tbgVesselAccumulation.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					objUWGlobal.hidGIPIS109Obj.selectedObj = null;
// 					populateVessel(objUWGlobal.hidGIPIS109Obj.selectedObj);
					tbgVesselAccumulation.keys.removeFocus(tbgVesselAccumulation.keys._nCurrentFocus, true);
					tbgVesselAccumulation.keys.releaseKeys();
				},
				onSort : function() {
					objUWGlobal.hidGIPIS109Obj.selectedObj = null;
					tbgVesselAccumulation.keys.removeFocus(tbgVesselAccumulation.keys._nCurrentFocus, true);
					tbgVesselAccumulation.keys.releaseKeys();
				},
				toolbar : {
					elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
					onFilter : function() {
						objUWGlobal.hidGIPIS109Obj.selectedObj = null;
						tbgVesselAccumulation.keys.removeFocus(tbgVesselAccumulation.keys._nCurrentFocus, true);
						tbgVesselAccumulation.keys.releaseKeys();
					},
					onRefresh : function() {
						objUWGlobal.hidGIPIS109Obj.selectedObj = null;
						tbgVesselAccumulation.keys.removeFocus(tbgVesselAccumulation.keys._nCurrentFocus, true);
						tbgVesselAccumulation.keys.releaseKeys();
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
						id : "vesselCd",
						title : "Vessel Code",
						width : '170px',
						filterOption: true
					},
					{
						id : "vesselName",
						title : "Vessel Name",
						width : '540px',
						filterOption: true
					},
					{
						id : "nbtVestype",
						title : "Vessel Type",
						width : '170px',
						filterOption: true
					}
				],
			rows : jsonVesselAccumulation.rows
		};
		tbgVesselAccumulation = new MyTableGrid(vesselAccumulationTableModel);
		tbgVesselAccumulation.pager = jsonVesselAccumulation;
		tbgVesselAccumulation.render('vesselAccumulationTable');
// 		tbgVesselAccumulation.afterRender = function(){
// 											};
	} catch (e) {
		showErrorMessage("vesselAccumulationTableModel", e);
	}
	
	/* function populateVessel(obj) { remove by steven 01.22.2014;base on testcase
		if (obj != null) {
			$("chkExcludeNotEff").checked = obj.excludeNotEff == 'Y' ? true : false;
			$("chkExcludeExpire").checked = obj.excludeExpired == 'Y' ? true : false;
		} 
	} */
 	function showVesselAccumulationDtlOverlay() {
		try{
			objUWGlobal.hidGIPIS109Obj.busType = "3";
			objUWGlobal.hidGIPIS109Obj.excludeExpired = $("chkExcludeExpire").checked ? "Y" : "N";
			objUWGlobal.hidGIPIS109Obj.excludeNotEff = $("chkExcludeNotEff").checked ? "Y" : "N";
			if ($("rdoAssumeBus").checked) {
				objUWGlobal.hidGIPIS109Obj.busType = "2";
			} else if($("rdoDirectBus").checked) {
				objUWGlobal.hidGIPIS109Obj.busType = "1";
			}else if($("rdoAssumeDirectBus").checked){
				objUWGlobal.hidGIPIS109Obj.busType = "3";
			}
			overlayVesselAccumulationDtl = Overlay.show(contextPath+"/GIPIPolbasicController",
					{urlContent: true,
					 title: "Exposures",
					 urlParameters: {
		                    action : "showVesselAccumulationDtl",
		                    vesselCd : objUWGlobal.hidGIPIS109Obj.selectedObj.vesselCd,
		                    vesselName : objUWGlobal.hidGIPIS109Obj.selectedObj.vesselName,
		                    busType : objUWGlobal.hidGIPIS109Obj.busType,
		                    excludeExpired : objUWGlobal.hidGIPIS109Obj.excludeExpired,
		                    excludeNotEff : objUWGlobal.hidGIPIS109Obj.excludeNotEff
		            },
					 height: 350,
					 width: 880,
					 draggable: false
					});
		}catch (e) {
			showErrorMessage("showVesselAccumulationDtlOverlay",e);
		}
	}
 	
 	$("btnView").observe("click" , function() {
 		if (objUWGlobal.hidGIPIS109Obj.selectedObj != null) {
 			showVesselAccumulationDtlOverlay();
		} else {
			showMessageBox("Please specify the record to be retrieved.","I");
		}
	});
 	
	$("btnToolbarExecuteQuery").observe("click" , function() {
		objUWGlobal.hidGIPIS109Obj.selectedObj = null;
		disableToolbarButton("btnToolbarExecuteQuery");
		enableToolbarButton("btnToolbarEnterQuery");
		tbgVesselAccumulation.url = contextPath+ "/GIPIPolbasicController?action=showViewVesselAccumulation&refresh=1";
		tbgVesselAccumulation._refreshList();
	});

	$("btnToolbarEnterQuery").observe("click" , function() {
		 objUWGlobal.hidGIPIS109Obj.selectedObj = null;
		 resetPage();
		 enableToolbarButton("btnToolbarExecuteQuery");
		 disableToolbarButton("btnToolbarEnterQuery");
		 tbgVesselAccumulation.url = contextPath+ "/GIPIPolbasicController?action=showViewVesselAccumulation&refresh=1&enterQuery=Y";
		 tbgVesselAccumulation._refreshList();
	});
	
	$("btnToolbarExit").observe("click" , function() {
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});

	$("reloadForm").observe("click" , function() {
			showViewVesselAccumulation();
	});
</script>
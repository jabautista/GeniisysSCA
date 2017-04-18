<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="actualExposuresContentsDiv" >
	<div class="sectionDiv" align="center" style="width: 100%; margin-top: 1px;">
		<table align="center" style="padding: 5px 0 0 0;">
			<tr>
				<td class="rightAligned">Location</td>
				<td class="leftAligned" style="padding: 0 0 0 5px;" colspan="4">
					<input type="text" id="txtLocationCdActual" readonly="readonly" style="width: 100px;"/>
					<input type="text" id="txtLocationNameActual" readonly="readonly" style="width: 580px;"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">From</td>
				<td class="leftAligned" style="padding: 0 0 0 5px;" colspan="2"><input type="text" id="txtFromDateActual" readonly="readonly" style="width: 220px;"/></td>
				<td class="rightAligned" style="padding-left: 150px;">Retention Limit</td>
				<td class="leftAligned" style="padding: 0 0 0 5px;"><input type="text" id="txtRetLimitActual" readonly="readonly" style="width: 220px; text-align: right;"/></td>
			</tr>
			<tr>
				<td class="rightAligned">To</td>
				<td class="leftAligned" style="padding: 0 0 0 5px;" colspan="2"><input type="text" id="txtToDateActual" readonly="readonly" style="width: 220px;"/></td>
				<td class="rightAligned">Treaty Limit</td>
				<td class="leftAligned" style="padding: 0 0 0 5px;"><input type="text" id="txtTreatyLimitActual" readonly="readonly" style="width: 220px; text-align: right;"/></td>
			</tr>
		</table>
		<div id="casualtyActualExposureTabsMenu" style="width: 100%; float: left;">
			<div id="tabComponentsDiv1" class="tabComponents1" style="float: left;">
				<ul>
					<li class="tab1 selectedTab1"><a id="tabItemActualExposure">Breakdown by Item</a></li>
					<li class="tab1"><a id="tabPerilActualExposure">Breakdown by Peril</a></li>
				</ul>
			</div>
			<div class="tabBorderBottom1"></div>		
		</div> 
		<div id="casualtyActualExposuresTable" style="height: 340px; padding: 50px 10px 0 10px;"></div>
		<input type="button" id="btnActualClaimInfo" class="button" value="Claim Information" style="width: 150px; margin-bottom: 10px;"/>
	</div>
	<div class="buttonDiv"align="center" style="padding: 535px 0 0 0;">
		<input type="button" id="btnActualReturn" class="button" value="Return" style="width: 100px;"/>
	</div>
</div>
<script>
 	initializeAll();
 	try {
		var mode = '${mode}';
		var claimId = null;
		$("txtLocationCdActual").value = unescapeHTML2(nvl(objUWGlobal.hidGIPIS111Obj.selectedObj.locationCd,""));
		$("txtLocationNameActual").value = unescapeHTML2(nvl(objUWGlobal.hidGIPIS111Obj.selectedObj.locationDesc,""));
		$("txtFromDateActual").value = objUWGlobal.hidGIPIS111Obj.selectedObj.dspFromDate2;
		$("txtToDateActual").value = objUWGlobal.hidGIPIS111Obj.selectedObj.dspToDate2;
		$("txtRetLimitActual").value = formatCurrency(nvl(objUWGlobal.hidGIPIS111Obj.selectedObj.retLimit,"0"));
		$("txtTreatyLimitActual").value = formatCurrency(nvl(objUWGlobal.hidGIPIS111Obj.selectedObj.treatyLimit,"0"));
		disableButton("btnActualClaimInfo");
		var jsonVasualtyActualExposures = JSON.parse('${jsonItemActualExposures}');
		casualtyActualExposuresTableModel = {
			url : contextPath+ "/GIPIPolbasicController?action=showGipis111ActualExposures&refresh=1&locationCd=" + objUWGlobal.hidGIPIS111Obj.selectedObj.locationCd
																						 	 + "&mode=" + mode 
																							 + "&excludeExpired=" + objUWGlobal.hidGIPIS111Obj.excludeExpired
																							 + "&excludeNotEff=" + objUWGlobal.hidGIPIS111Obj.excludeNotEff,
		 	id : "GIPIS111ItemActualExposures",	
			options : {
				width : '900px',
				height : '310px',
				onCellFocus : function(element, value, x, y, id) {
					var obj = tbgCasualtyActualExposures.geniisysRows[y];
					populateActualExposure(obj);
					tbgCasualtyActualExposures.keys.removeFocus(tbgCasualtyActualExposures.keys._nCurrentFocus, true);
					tbgCasualtyActualExposures.keys.releaseKeys();
				},
				postPager : function() {
					populateActualExposure(null);
					tbgCasualtyActualExposures.keys.removeFocus(tbgCasualtyActualExposures.keys._nCurrentFocus, true);
					tbgCasualtyActualExposures.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					populateActualExposure(null);
					tbgCasualtyActualExposures.keys.removeFocus(tbgCasualtyActualExposures.keys._nCurrentFocus, true);
					tbgCasualtyActualExposures.keys.releaseKeys();
				},
				onSort : function() {
					populateActualExposure(null);
					tbgCasualtyActualExposures.keys.removeFocus(tbgCasualtyActualExposures.keys._nCurrentFocus, true);
					tbgCasualtyActualExposures.keys.releaseKeys();
				},
				toolbar : {
					elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
					onFilter : function() {
						populateActualExposure(null);
						tbgCasualtyActualExposures.keys.removeFocus(tbgCasualtyActualExposures.keys._nCurrentFocus, true);
						tbgCasualtyActualExposures.keys.releaseKeys();
					},
					onRefresh : function() {
						populateActualExposure(null);
						tbgCasualtyActualExposures.keys.removeFocus(tbgCasualtyActualExposures.keys._nCurrentFocus, true);
						tbgCasualtyActualExposures.keys.releaseKeys();
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
					{	id : 'expired',
				    	title: 'E',
				    	tooltip: 'Expired',
				    	altTitle: 'Expired',
				    	align: 'center',
				    	titleAlign: 'center',
				    	width: '40px',
				    	sortable: false,
				    	editable: false,
				    	editor: new MyTableGrid.CellCheckbox({ 
				    		getValueOf: function(value){
				    			if (value){
				    				return "Y";
				    			}else{
				    				return "N";	
				    			}	
				    		}
				    	}),	
				    },
				    {	id : 'notYetEff',
				    	title: 'N',
				    	tooltip: 'Not yet effective',
				    	altTitle: 'Not yet effective',
				    	align: 'center',
				    	titleAlign: 'center',
				    	width: '40px',
				    	sortable: false,
				    	editable: false,
				    	editor: new MyTableGrid.CellCheckbox({ 
				    		getValueOf: function(value){
				    			if (value){
				    				return "Y";
				    			}else{
				    				return "N";	
				    			}	
				    		}
				    	}),	
				    },
					{
						id : "policyNo",
						title : "Policy Number",
						width : '230px',
						filterOption: true
					},
					{
						id : "itemNo",
						title : "Item",
						width : '50px',
						align: 'right',
				    	titleAlign: 'right',
						filterOption: true
						//renderer: function(value){
				    		//return nvl(value,'') == '' ? '' :formatNumberDigits(nvl(value, 0),12);
				    	//}
					},
					{
						id : "itemTitle",
						title : "Item Title",
						width : mode == "ITEM" ? '230px' : 0,
						filterOption: mode == "ITEM" ? true : false, 
						visible: mode == "ITEM" ? true : false
					},
					{
						id : "perilName",
						title : "Peril",
						width : mode == "PERIL" ? '230px' : 0,
						filterOption: mode == "PERIL" ? true : false, 
						visible: mode == "PERIL" ? true : false
					},
					{
						id : "premRt",
						title : "Rate",
						align: 'right',
				    	titleAlign: 'right',
				    	geniisysClass: 'rate',
				    	filterOptionType: 'number',
						width : mode == "PERIL" ? '120px' : 0,
						filterOption: mode == "PERIL" ? true : false, 
						visible: mode == "PERIL" ? true : false,
					},
					{
						id : "annTsiAmt",
						title : "Sum Insured",
						align: 'right',
				    	titleAlign: 'right',
				    	geniisysClass: 'money',
				    	filterOptionType: 'number',
						width : '120px',
						filterOption: true
					},
					{
						id : "distTsi",
						title : "Dist TSI",
						align: 'right',
				    	titleAlign: 'right',
				    	geniisysClass: 'money',
				    	filterOptionType: 'number',
						width : '120px',
						filterOption: true
					},
					{
						id : "assdName",
						title : "Assured",
						width : '250px',
						filterOption: true
					},
					{
						id : "distStat",
						title : "Dist. Status",
						width : '120px',
						filterOption: true
					},
					{
						id : "dspMaxExpiry",
						title : "Expiry",
						align: 'center',
				    	titleAlign: 'center',
						width : '120px',
						filterOptionType: 'formattedDate',
						filterOption: true
					},
				],
			rows : jsonVasualtyActualExposures.rows
		};
		tbgCasualtyActualExposures = new MyTableGrid(casualtyActualExposuresTableModel);
		tbgCasualtyActualExposures.pager = jsonVasualtyActualExposures;
		tbgCasualtyActualExposures.render('casualtyActualExposuresTable');
	} catch (e) {
		showErrorMessage("casualtyActualExposuresTableModel", e);
	} 
	
	function populateActualExposure(obj) {
		if (obj==null) {
			disableButton("btnActualClaimInfo");
			claimId = null;
			$("lineCd").value = null;
			$("menuLineCd").value = null;
		} else {
			if (obj.claimExists == "Y") {
				enableButton("btnActualClaimInfo");
				claimId = obj.claimId;
				$("lineCd").value = obj.lineCd;
				$("menuLineCd").value = obj.lineCd;
			} else {
				disableButton("btnActualClaimInfo");
				claimId = null;
				$("lineCd").value = null;
				$("menuLineCd").value = null;
			}
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
	
	objUWGlobal.hidGIPIS111Obj.setCurrentTab = setCurrentTab;
	
	function showActualExposures(modeParam) {
		try{
			new Ajax.Request(contextPath+"/GIPIPolbasicController",{
				method: "POST",
				parameters : { action : "showGipis111ActualExposures",
			                   excludeExpired : objUWGlobal.hidGIPIS111Obj.excludeExpired,
			                   excludeNotEff : objUWGlobal.hidGIPIS111Obj.excludeNotEff,
			                   locationCd : objUWGlobal.hidGIPIS111Obj.selectedObj.locationCd,
			                   mode : modeParam
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function (){
					showNotice("Loading, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						$("actualExposuresContentsDiv").update(response.responseText);
					}
				}
			});
		} catch(e){
			showErrorMessage("showActualExposures", e);
		}
	}
	
	$("tabItemActualExposure").observe("click", function(){
		if (mode != "ITEM") {
			mode = "ITEM";
			showActualExposures(mode);
		}
		setCurrentTab("tabItemActualExposure");
	});
	
	$("tabPerilActualExposure").observe("click", function(){
		if (mode != "PERIL") {
			mode = "PERIL";
			showActualExposures(mode);
		}
		setCurrentTab("tabPerilActualExposure");
	});
	
	$("btnActualClaimInfo").observe("click", function(){
		objCLMGlobal.claimId = claimId;
		objUWGlobal.hidGIPIS111Obj.exposureMode = "ACTUAL";
		objUWGlobal.hidGIPIS111Obj.exposureType = mode;
		objCLMGlobal.callingForm = "GIPIS111";
		$("casualtyAccumulationDiv").hide();
		showClaimInformationMain("claimInfoDummyMainDiv");
	});
	
	$("btnActualReturn").observe("click",function(){
		$("casualtyAccumulationBodyDiv").hide();
		$("casualtyAccumulationBodyDiv2").show();
		$("casualtyAccumulationBodyDiv3").hide();
		$("casualtyAccumulationBodyDiv4").hide();
	});
</script>
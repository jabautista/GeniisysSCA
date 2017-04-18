<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="temporaryExposuresContentsDiv" >
	<div class="sectionDiv" align="center" style="width: 100%; margin-top: 1px;">
		<table align="center" style="padding: 5px 0 0 0;">
			<tr>
				<td class="rightAligned">Location</td>
				<td class="leftAligned" style="padding: 0 0 0 5px;" colspan="4">
					<input type="text" id="txtLocationCdTemp" readonly="readonly" style="width: 100px;"/>
					<input type="text" id="txtLocationNameTemp" readonly="readonly" style="width: 580px;"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">From</td>
				<td class="leftAligned" style="padding: 0 0 0 5px;" colspan="2"><input type="text" id="txtFromDateTemp" readonly="readonly" style="width: 220px;"/></td>
				<td class="rightAligned" style="padding-left: 150px;">Retention Limit</td>
				<td class="leftAligned" style="padding: 0 0 0 5px;"><input type="text" id="txtRetLimitTemp" readonly="readonly" style="width: 220px; text-align: right;"/></td>
			</tr>
			<tr>
				<td class="rightAligned">To</td>
				<td class="leftAligned" style="padding: 0 0 0 5px;" colspan="2"><input type="text" id="txtToDateTemp" readonly="readonly" style="width: 220px;"/></td>
				<td class="rightAligned">Treaty Limit</td>
				<td class="leftAligned" style="padding: 0 0 0 5px;"><input type="text" id="txtTreatyLimitTemp" readonly="readonly" style="width: 220px; text-align: right;"/></td>
			</tr>
		</table>
		<div id="casualtyTemporaryExposureTabsMenu" style="width: 100%; float: left;">
			<div id="tabComponentsDiv1" class="tabComponents1" style="float: left;">
				<ul>
					<li class="tab1 selectedTab1"><a id="tabItemTemporaryExposure">Breakdown by Item</a></li>
					<li class="tab1"><a id="tabPerilTemporaryExposure">Breakdown by Peril</a></li>
				</ul>
			</div>
			<div class="tabBorderBottom1"></div>		
		</div> 
		<div id="casualtyTemporaryExposuresTable" style="height: 340px; padding: 50px 10px 0 10px;"></div>
		<input type="button" id="btnTemporaryClaimInfo" class="button" value="Claim Information" style="width: 150px; margin-bottom: 10px;"/>
	</div>
	<div class="buttonDiv"align="center" style="padding: 535px 0 0 0;">
		<input type="button" id="btnTemporaryReturn" class="button" value="Return" style="width: 100px;"/>
	</div>
</div>
<script>
 	initializeAll();
 	try {
		var mode = '${mode}';
		var claimId = null;
		$("txtLocationCdTemp").value = unescapeHTML2(nvl(objUWGlobal.hidGIPIS111Obj.selectedObj.locationCd,""));
		$("txtLocationNameTemp").value = unescapeHTML2(nvl(objUWGlobal.hidGIPIS111Obj.selectedObj.locationDesc,""));
		$("txtFromDateTemp").value = objUWGlobal.hidGIPIS111Obj.selectedObj.dspFromDate2;
		$("txtToDateTemp").value = objUWGlobal.hidGIPIS111Obj.selectedObj.dspToDate2;
		$("txtRetLimitTemp").value = formatCurrency(nvl(objUWGlobal.hidGIPIS111Obj.selectedObj.retLimit,"0"));
		$("txtTreatyLimitTemp").value = formatCurrency(nvl(objUWGlobal.hidGIPIS111Obj.selectedObj.treatyLimit,"0"));
		disableButton("btnTemporaryClaimInfo");
		var jsonCasualtyTemporaryExposures = JSON.parse('${jsonItemTemporaryExposures}');
		casualtyTemporaryExposuresTableModel = {
			url : contextPath+ "/GIPIPolbasicController?action=showGipis111TemporaryExposures&refresh=1&locationCd=" + objUWGlobal.hidGIPIS111Obj.selectedObj.locationCd
																						 	 + "&mode=" + mode 
																							 + "&excludeExpired=" + objUWGlobal.hidGIPIS111Obj.excludeExpired
																							 + "&excludeNotEff=" + objUWGlobal.hidGIPIS111Obj.excludeNotEff,
		 	id : "GIPIS111ItemTemporaryExposures",	
			options : {
				width : '900px',
				height : '310px',
				onCellFocus : function(element, value, x, y, id) {
					var obj = tbgCasualtyTemporaryExposures.geniisysRows[y];
					populateTemporaryExposure(obj);
					tbgCasualtyTemporaryExposures.keys.removeFocus(tbgCasualtyTemporaryExposures.keys._nCurrentFocus, true);
					tbgCasualtyTemporaryExposures.keys.releaseKeys();
				},
				postPager : function() {
					populateTemporaryExposure(null);
					tbgCasualtyTemporaryExposures.keys.removeFocus(tbgCasualtyTemporaryExposures.keys._nCurrentFocus, true);
					tbgCasualtyTemporaryExposures.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					populateTemporaryExposure(null);
					tbgCasualtyTemporaryExposures.keys.removeFocus(tbgCasualtyTemporaryExposures.keys._nCurrentFocus, true);
					tbgCasualtyTemporaryExposures.keys.releaseKeys();
				},
				onSort : function() {
					populateTemporaryExposure(null);
					tbgCasualtyTemporaryExposures.keys.removeFocus(tbgCasualtyTemporaryExposures.keys._nCurrentFocus, true);
					tbgCasualtyTemporaryExposures.keys.releaseKeys();
				},
				toolbar : {
					elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
					onFilter : function() {
						populateTemporaryExposure(null);
						tbgCasualtyTemporaryExposures.keys.removeFocus(tbgCasualtyTemporaryExposures.keys._nCurrentFocus, true);
						tbgCasualtyTemporaryExposures.keys.releaseKeys();
					},
					onRefresh : function() {
						populateTemporaryExposure(null);
						tbgCasualtyTemporaryExposures.keys.removeFocus(tbgCasualtyTemporaryExposures.keys._nCurrentFocus, true);
						tbgCasualtyTemporaryExposures.keys.releaseKeys();
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
						id : "parNo",
						title : "PAR Number",
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
						width : mode == "PERIL" ? '120px' : 0,
					    filterOptionType: 'number',
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
			rows : jsonCasualtyTemporaryExposures.rows
		};
		tbgCasualtyTemporaryExposures = new MyTableGrid(casualtyTemporaryExposuresTableModel);
		tbgCasualtyTemporaryExposures.pager = jsonCasualtyTemporaryExposures;
		tbgCasualtyTemporaryExposures.render('casualtyTemporaryExposuresTable');
	} catch (e) {
		showErrorMessage("casualtyTemporaryExposuresTableModel", e);
	} 
	
	function populateTemporaryExposure(obj) {
		if (obj==null) {
			disableButton("btnTemporaryClaimInfo");
			claimId = null;
			$("lineCd").value = null;
			$("menuLineCd").value = null;
		} else {
			if (obj.claimExists == "Y") {
				enableButton("btnTemporaryClaimInfo");
				claimId = obj.claimId;
				$("lineCd").value = obj.lineCd;
				$("menuLineCd").value = obj.lineCd;
			} else {
				disableButton("btnTemporaryClaimInfo");
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
	
	function showTemporaryExposures(modeParam) {
		try{
			new Ajax.Request(contextPath+"/GIPIPolbasicController",{
				method: "POST",
				parameters : { action : "showGipis111TemporaryExposures",
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
						$("temporaryExposuresContentsDiv").update(response.responseText);
					}
				}
			});
		} catch(e){
			showErrorMessage("showTemporaryExposures", e);
		}
	}
	
	$("tabItemTemporaryExposure").observe("click", function(){
		if (mode != "ITEM") {
			mode = "ITEM";
			showTemporaryExposures(mode);
		}
		setCurrentTab("tabItemTemporaryExposure");
	});
	
	$("tabPerilTemporaryExposure").observe("click", function(){
		if (mode != "PERIL") {
			mode = "PERIL";
			showTemporaryExposures(mode);
		}
		setCurrentTab("tabPerilTemporaryExposure");
	});
	
	$("btnTemporaryClaimInfo").observe("click", function(){
		objCLMGlobal.claimId = claimId;
		objUWGlobal.hidGIPIS111Obj.exposureMode = "TEMP";
		objUWGlobal.hidGIPIS111Obj.exposureType = mode;
		objCLMGlobal.callingForm = "GIPIS111";
		$("casualtyAccumulationDiv").hide();
		showClaimInformationMain("claimInfoDummyMainDiv");
	});
	
	$("btnTemporaryReturn").observe("click",function(){
		$("casualtyAccumulationBodyDiv").hide();
		$("casualtyAccumulationBodyDiv2").show();
		$("casualtyAccumulationBodyDiv3").hide();
		$("casualtyAccumulationBodyDiv4").hide();
	});
</script>
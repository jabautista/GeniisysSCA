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
		<table align="center" style="padding: 5px 0 15px 0;">
			<tr>
				<td class="rightAligned">District No.</td>
				<td class="leftAligned" style="padding: 0 0 0 5px;" colspan="4">
					<input type="text" id="txtTemporaryDistrictNo" readonly="readonly" style="width: 70px;"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Block No.</td>
				<td class="leftAligned" style="padding: 0 0 0 5px;"><input type="text" id="txtTemporaryBlockNo" readonly="readonly" style="width: 70px;"/></td>
				<td><input type="text" id="txtTemporaryBlockDesc" readonly="readonly" style="width: 280px;"/></td>
				<td class="rightAligned" style="padding-left: 80px;">Retention Limit</td>
				<td class="leftAligned" style="padding: 0 0 0 5px;"><input type="text" id="txtTemporaryRetLimit" readonly="readonly" style="width: 220px; text-align: right;"/></td>
			</tr>
			<tr>
				<td class="rightAligned">Risk </td>
				<td class="leftAligned" style="padding: 0 0 0 5px;"><input type="text" id="txtTemporaryRiskCd" readonly="readonly" style="width: 70px;"/></td>
				<td><input type="text" id="txtTemporaryRiskDesc" readonly="readonly" style="width: 280px;"/></td>
				<td class="rightAligned">Treaty Limit</td>
				<td class="leftAligned" style="padding: 0 0 0 5px;"><input type="text" id="txtTemporaryTreatyLimit" readonly="readonly" style="width: 220px; text-align: right;"/></td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv" style="width: 100%; margin-bottom: 20px;">
		<div id="blockTemporaryExposureTabsMenu" style="width: 100%; float: left;">
			<div id="tabComponentsDiv1" class="tabComponents1" style="float: left;">
				<ul>
					<li class="tab1 selectedTab1"><a id="tabItemTemporaryExposure">Breakdown by Item</a></li>
					<li class="tab1"><a id="tabPerilTemporaryExposure">Breakdown by Peril</a></li>
				</ul>
			</div>
			<div class="tabBorderBottom1"></div>		
		</div> 
		<div id="blockTemporaryExposuresTable" style="height: 340px; padding: 50px 10px 0 10px;"></div>
		<div class="buttonDiv"align="center" style="padding: 10px 0 10px 0;">
			<input type="button" id="btnTemporaryExposure" class="button" value="Exposures" style="width: 100px;"/>
			<input type="button" id="btnTemporaryClaimInfo" class="button" value="Claim Information" style="width: 150px; margin-bottom: 10px;"/>
		</div>
	</div>
</div>
<script>
 	initializeAll();
 	try {
 		var mode = '${mode}';
		var all = '${all}';
		var shareType = '${shareType}';
		var claimId = null;
		var excludeExpired = objUWGlobal.hidGIPIS110Obj.isListExposure ? 'N': objUWGlobal.hidGIPIS110Obj.excludeExpired;
		var excludeNotEff = objUWGlobal.hidGIPIS110Obj.isListExposure ? 'N': objUWGlobal.hidGIPIS110Obj.excludeNotEff;
		
		$("txtTemporaryDistrictNo").value = unescapeHTML2(nvl(objUWGlobal.hidGIPIS110Obj.selectedObj.districtNo,""));
		$("txtTemporaryBlockNo").value = unescapeHTML2(nvl(objUWGlobal.hidGIPIS110Obj.selectedObj.blockNo,""));
		$("txtTemporaryBlockDesc").value = unescapeHTML2(nvl(objUWGlobal.hidGIPIS110Obj.selectedObj.blockDesc,""));
		$("txtTemporaryRiskCd").value = unescapeHTML2(nvl(objUWGlobal.hidGIPIS110Obj.selectedObj.riskCd,""));
		$("txtTemporaryRiskDesc").value = unescapeHTML2(nvl(objUWGlobal.hidGIPIS110Obj.selectedObj.riskDesc,""));
		$("txtTemporaryRetLimit").value = formatCurrency(nvl(objUWGlobal.hidGIPIS110Obj.selectedObj.retnLimAmt,""));
		$("txtTemporaryTreatyLimit").value = formatCurrency(nvl(objUWGlobal.hidGIPIS110Obj.selectedObj.trtyLimAmt,""));
		disableButton("btnTemporaryClaimInfo");
		var jsonBlockTemporaryExposures = JSON.parse('${jsonItemTemporaryExposures}');
		blockTemporaryExposuresTableModel = {
			url : contextPath+ "/GIPIPolbasicController?action=showGipis110TemporaryExposures&refresh=1&exclude=" + excludeExpired
																									+ "&excludeNotEff=" + excludeNotEff
																									+ "&shareType=" + shareType 
																									+ "&blockId=" + objUWGlobal.hidGIPIS110Obj.selectedObj.blockId 
																									+ "&all=" + all
																									+ "&mode=" + mode
																									+ "&riskCd=" + objUWGlobal.hidGIPIS110Obj.selectedObj.riskCd, //nieko 07132016 kb 894, added riskCd parameter
		 	id : "GIPIS110TemporaryExposures",	
			options : {
				width : '900px',
				height : '310px',
				onCellFocus : function(element, value, x, y, id) {
					var obj = tbgBlockTemporaryExposures.geniisysRows[y];
					populateTemporaryExposure(obj);
					tbgBlockTemporaryExposures.keys.removeFocus(tbgBlockTemporaryExposures.keys._nCurrentFocus, true);
					tbgBlockTemporaryExposures.keys.releaseKeys();
				},
				postPager : function() {
					populateTemporaryExposure(null);
					tbgBlockTemporaryExposures.keys.removeFocus(tbgBlockTemporaryExposures.keys._nCurrentFocus, true);
					tbgBlockTemporaryExposures.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					populateTemporaryExposure(null);
					tbgBlockTemporaryExposures.keys.removeFocus(tbgBlockTemporaryExposures.keys._nCurrentFocus, true);
					tbgBlockTemporaryExposures.keys.releaseKeys();
				},
				onSort : function() {
					populateTemporaryExposure(null);
					tbgBlockTemporaryExposures.keys.removeFocus(tbgBlockTemporaryExposures.keys._nCurrentFocus, true);
					tbgBlockTemporaryExposures.keys.releaseKeys();
				},
				toolbar : {
					elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
					onFilter : function() {
						populateTemporaryExposure(null);
						tbgBlockTemporaryExposures.keys.removeFocus(tbgBlockTemporaryExposures.keys._nCurrentFocus, true);
						tbgBlockTemporaryExposures.keys.releaseKeys();
					},
					onRefresh : function() {
						populateTemporaryExposure(null);
						tbgBlockTemporaryExposures.keys.removeFocus(tbgBlockTemporaryExposures.keys._nCurrentFocus, true);
						tbgBlockTemporaryExposures.keys.releaseKeys();
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
				    	width: '30px',
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
				    	width: '30px',
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
						id : "dspParNo",
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
					},
					{
						id : "perilName",
						title : "Peril",
						width : mode == "PERIL" ? '230px' : '0',
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
						width : mode == "PERIL" ? '120px' : '0',
						filterOption: mode == "PERIL" ? true : false, 
						visible: mode == "PERIL" ? true : false
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
				    	width : all == "N" ? '120px' : '0',
						filterOption: all == "N" ? true : false, 
						visible: all == "N" ? true : false
					},
					{
						id : "assdName",
						title : "Assured",
						width : '250px',
						filterOption: true
					},
					{
						id : "dspItemType",
						title : "Fire Item Type",
						width : '120px',
						filterOption: true
					},
					{
						id : "tarfCd",
						title : "Tariff Code",
						width : '120px',
						filterOption: true
					},
					{
						id : "dspDistStatus",
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
					{
						id : "locRisk",
						title : "Risk Location",
						width : '200px',
						filterOption: true
					},
					{
						id : "nbtConsDesc",
						title : "Construction",
						width : '200px',
						filterOption: true
					}
				],
			rows : jsonBlockTemporaryExposures.rows
		};
		tbgBlockTemporaryExposures = new MyTableGrid(blockTemporaryExposuresTableModel);
		tbgBlockTemporaryExposures.pager = jsonBlockTemporaryExposures;
		tbgBlockTemporaryExposures.render('blockTemporaryExposuresTable');
	} catch (e) {
		showErrorMessage("blockTemporaryExposuresTableModel", e);
	} 
	
	function populateTemporaryExposure(obj) {
		if (obj==null) {
			disableButton("btnTemporaryClaimInfo");
			claimId = null;
			$("lineCd").value = null;
			$("menuLineCd").value = null;
		} else {
			if (obj.withClaims  != "0") {
				enableButton("btnTemporaryClaimInfo");
				claimId = obj.withClaims;
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
	
	objUWGlobal.hidGIPIS110Obj.setCurrentTab = setCurrentTab;
	
	function showTemporaryExposures(modeParam) {
		try{
			new Ajax.Request(contextPath+"/GIPIPolbasicController",{
				method: "POST",
				parameters : { action : "showGipis110TemporaryExposures",
							   exclude : excludeExpired,
			 				   excludeNotEff : excludeNotEff,
			 				   shareType : shareType,
			 				   blockId : objUWGlobal.hidGIPIS110Obj.selectedObj.blockId,
			 				   all : all,
						       mode : modeParam,
						       riskCd : objUWGlobal.hidGIPIS110Obj.selectedObj.riskCd //nieko 07132016 kb 894, added riskCd parameter
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
		objUWGlobal.hidGIPIS110Obj.exposureMode = "TEMP";
		objUWGlobal.hidGIPIS110Obj.exposureType = mode;
		objCLMGlobal.callingForm = "GIPIS110";
		$("blockAccumulationDiv").hide();
		showClaimInformationMain("claimInfoDummyMainDiv");
	});
	
	$("btnTemporaryExposure").observe("click",function(){
		objUWGlobal.hidGIPIS110Obj.isListExposure = false;
		if (shareType == null || shareType == "") {
			$("blockAccumulationBodyDiv").hide();
			$("blockAccumulationBodyDiv2").show();
			$("blockAccumulationBodyDiv3").hide();
			$("blockAccumulationBodyDiv4").hide();
			$("blockAccumulationBodyDiv5").hide();
		} else {
			$("blockAccumulationBodyDiv").hide();
			$("blockAccumulationBodyDiv2").hide();
			$("blockAccumulationBodyDiv3").hide();
			$("blockAccumulationBodyDiv4").hide();
			$("blockAccumulationBodyDiv5").show();
		}
	});
</script>
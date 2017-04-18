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
		<table align="center" style="padding: 5px 0 15px 0;">
			<tr>
				<td class="rightAligned">District No.</td>
				<td class="leftAligned" style="padding: 0 0 0 5px;" colspan="4">
					<input type="text" id="txtActualDistrictNo" readonly="readonly" style="width: 70px;"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Block No.</td>
				<td class="leftAligned" style="padding: 0 0 0 5px;"><input type="text" id="txtActualBlockNo" readonly="readonly" style="width: 70px;"/></td>
				<td><input type="text" id="txtActualBlockDesc" readonly="readonly" style="width: 280px;"/></td>
				<td class="rightAligned" style="padding-left: 80px;">Retention Limit</td>
				<td class="leftAligned" style="padding: 0 0 0 5px;"><input type="text" id="txtActualRetLimit" readonly="readonly" style="width: 220px; text-align: right;"/></td>
			</tr>
			<tr>
				<td class="rightAligned">Risk </td>
				<td class="leftAligned" style="padding: 0 0 0 5px;"><input type="text" id="txtActualRiskCd" readonly="readonly" style="width: 70px;"/></td>
				<td><input type="text" id="txtActualRiskDesc" readonly="readonly" style="width: 280px;"/></td>
				<td class="rightAligned">Treaty Limit</td>
				<td class="leftAligned" style="padding: 0 0 0 5px;"><input type="text" id="txtActualTreatyLimit" readonly="readonly" style="width: 220px; text-align: right;"/></td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv" style="width: 100%; margin-bottom: 20px;">
		<div id="blockActualExposureTabsMenu" style="width: 100%; float: left;">
			<div id="tabComponentsDiv1" class="tabComponents1" style="float: left;">
				<ul>
					<li class="tab1 selectedTab1"><a id="tabItemActualExposure">Breakdown by Item</a></li>
					<li class="tab1"><a id="tabPerilActualExposure">Breakdown by Peril</a></li>
				</ul>
			</div>
			<div class="tabBorderBottom1"></div>		
		</div> 
		<div id="blockActualExposuresTable" style="height: 340px; padding: 50px 10px 0 10px;"></div>
		<div class="buttonDiv"align="center" style="padding: 10px 0 10px 0;">
			<input type="button" id="btnActualExposure" class="button" value="Exposures" style="width: 100px;"/>
			<input type="button" id="btnActualClaimInfo" class="button" value="Claim Information" style="width: 150px; margin-bottom: 10px;"/>
		</div>
	</div>
</div>
<script>
 	initializeAll();
 	
 	policyNo = new Object(); //nieko kb 894 12152016
 	
 	try {
		var mode = '${mode}';
		var all = '${all}';
		var shareType = '${shareType}';
		var claimId = null;
		var excludeExpired = objUWGlobal.hidGIPIS110Obj.isListExposure ? 'N': objUWGlobal.hidGIPIS110Obj.excludeExpired;
		var excludeNotEff = objUWGlobal.hidGIPIS110Obj.isListExposure ? 'N': objUWGlobal.hidGIPIS110Obj.excludeNotEff;
		$("txtActualDistrictNo").value = unescapeHTML2(nvl(objUWGlobal.hidGIPIS110Obj.selectedObj.districtNo,""));
		$("txtActualBlockNo").value = unescapeHTML2(nvl(objUWGlobal.hidGIPIS110Obj.selectedObj.blockNo,""));
		$("txtActualBlockDesc").value = unescapeHTML2(nvl(objUWGlobal.hidGIPIS110Obj.selectedObj.blockDesc,""));
		$("txtActualRiskCd").value = unescapeHTML2(nvl(objUWGlobal.hidGIPIS110Obj.selectedObj.riskCd,""));
		$("txtActualRiskDesc").value = unescapeHTML2(nvl(objUWGlobal.hidGIPIS110Obj.selectedObj.riskDesc,""));
		$("txtActualRetLimit").value = formatCurrency(nvl(objUWGlobal.hidGIPIS110Obj.selectedObj.retnLimAmt,""));
		$("txtActualTreatyLimit").value = formatCurrency(nvl(objUWGlobal.hidGIPIS110Obj.selectedObj.trtyLimAmt,""));
		disableButton("btnActualClaimInfo");
		var jsonVasualtyActualExposures = JSON.parse('${jsonItemActualExposures}');
		blockActualExposuresTableModel = {
			url : contextPath+ "/GIPIPolbasicController?action=showGipis110ActualExposures&refresh=1&exclude=" + excludeExpired
																							 + "&excludeNotEff=" + excludeNotEff
																							 + "&shareType=" + shareType 
																							 + "&blockId=" + objUWGlobal.hidGIPIS110Obj.selectedObj.blockId 
																							 + "&all=" + all
																							 + "&mode=" + mode
																							 + "&riskCd=" + objUWGlobal.hidGIPIS110Obj.selectedObj.riskCd, //nieko 07132016 kb 894, added riskCd parameter
		 	id : "GIPIS110ActualExposures",	
			options : {
				width : '900px',
				height : '310px',
				onCellFocus : function(element, value, x, y, id) {
					var obj = tbgBlockActualExposures.geniisysRows[y];
					populateActualExposure(obj);
					tbgBlockActualExposures.keys.removeFocus(tbgBlockActualExposures.keys._nCurrentFocus, true);
					tbgBlockActualExposures.keys.releaseKeys();
				},
				postPager : function() {
					populateActualExposure(null);
					tbgBlockActualExposures.keys.removeFocus(tbgBlockActualExposures.keys._nCurrentFocus, true);
					tbgBlockActualExposures.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					populateActualExposure(null);
					tbgBlockActualExposures.keys.removeFocus(tbgBlockActualExposures.keys._nCurrentFocus, true);
					tbgBlockActualExposures.keys.releaseKeys();
				},
				onSort : function() {
					populateActualExposure(null);
					tbgBlockActualExposures.keys.removeFocus(tbgBlockActualExposures.keys._nCurrentFocus, true);
					tbgBlockActualExposures.keys.releaseKeys();
				},
				toolbar : {
					elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
					onFilter : function() {
						populateActualExposure(null);
						tbgBlockActualExposures.keys.removeFocus(tbgBlockActualExposures.keys._nCurrentFocus, true);
						tbgBlockActualExposures.keys.releaseKeys();
					},
					onRefresh : function() {
						populateActualExposure(null);
						tbgBlockActualExposures.keys.removeFocus(tbgBlockActualExposures.keys._nCurrentFocus, true);
						tbgBlockActualExposures.keys.releaseKeys();
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
				    	//width : mode == "ITEM" || all == "N" ? '120px' : '0',
						//filterOption: mode == "ITEM" || all == "N" ? true : false, 
						//visible: mode == "ITEM" || all == "N" ? true : false
						//nieko 12122016
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
			rows : jsonVasualtyActualExposures.rows
		};
		tbgBlockActualExposures = new MyTableGrid(blockActualExposuresTableModel);
		tbgBlockActualExposures.pager = jsonVasualtyActualExposures;
		tbgBlockActualExposures.render('blockActualExposuresTable');
	} catch (e) {
		showErrorMessage("blockActualExposuresTableModel", e);
	} 
	
	function populateActualExposure(obj) {
		if (obj==null) {
			disableButton("btnActualClaimInfo");
			claimId = null;
			$("lineCd").value = null;
			$("menuLineCd").value = null;
		} else {
			if (obj.withClaims != "0") {
				enableButton("btnActualClaimInfo");
				claimId = obj.withClaims;
				$("lineCd").value = obj.lineCd;
				$("menuLineCd").value = obj.lineCd;
			} else {
				disableButton("btnActualClaimInfo");
				claimId = null;
				$("lineCd").value = null;
				$("menuLineCd").value = null;
			}
		}
		
		//nieko kb 894 12152016
		policyNo.lineCd = obj.lineCd;
		policyNo.sublineCd = obj.sublineCd;
		policyNo.issCd = obj.issCd;
		policyNo.issueYy = obj.issueYy;
		policyNo.polSeqNo = obj.polSeqNo;
		policyNo.renewNo = obj.renewNo;
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
	
	function showActualExposures(modeParam) {
		try{
			new Ajax.Request(contextPath+"/GIPIPolbasicController",{
 				method: "POST",
 				parameters : { action : "showGipis110ActualExposures",
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
		objUWGlobal.hidGIPIS110Obj.exposureMode = "ACTUAL";
		objUWGlobal.hidGIPIS110Obj.exposureType = mode;
		objCLMGlobal.callingForm2 = "GIPIS110";	
		$("blockAccumulationDiv").hide();
		showClaimInformationListing2(policyNo.lineCd, policyNo.sublineCd, policyNo.issCd, policyNo.issueYy, policyNo.polSeqNo, policyNo.renewNo);
		
		//showClaimInformationMain("claimInfoDummyMainDiv"); 
	});
	
	$("btnActualExposure").observe("click",function(){
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
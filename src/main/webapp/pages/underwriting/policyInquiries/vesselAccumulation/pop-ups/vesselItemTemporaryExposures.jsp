<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="temporaryExposuresContentsDiv" >
	<div class="sectionDiv" align="center" style="width: 99.5%; margin-top: 2px;">
		<table align="center" style="padding: 15px 0 0 0;">
			<tr>
				<td class="rightAligned">Vessel Name</td>
				<td class="leftAligned" style="padding: 0 0 0 5px;"><input type="text" id="txtTemporaryVesselCd"  readonly="readonly" style="width: 120px" /></td>
				<td class="leftAligned" style="padding: 0 0 0 5px;"><input type="text" id="txtTemporaryVesselName" readonly="readonly" style="width: 580px" /></td>
			</tr>
		</table>
		<div id="vesselTemporaryExposureTabsMenu" style="width: 100%; float: left;">
			<div id="tabComponentsDiv1" class="tabComponents1" style="float: left;">
				<ul>
					<li class="tab1 selectedTab1"><a id="tabItemTemporaryExposure">Breakdown by Item</a></li>
					<li class="tab1"><a id="tabPerilTemporaryExposure">Breakdown by Peril</a></li>
				</ul>
			</div>
			<div class="tabBorderBottom1" style="z-index: 1000000000000000000000000;"></div>		
		</div> 
		<div id="vesselTemporaryExposuresTable" style="height: 355px; padding: 50px 10px 0 10px;"></div>
		<table style="padding: 0 0 10px 0">
			<tr>
				<td class="rightAligned">Cargo Type</td>
				<td class="leftAligned" style="padding: 0 0 0 5px;"><input type="text" id="txtTemporaryCargoType" readonly="readonly" style="width: 650px" /></td>
			</tr>
			<tr>
				<td class="rightAligned">Cargo Class</td>
				<td class="leftAligned" style="padding: 0 0 0 5px;"><input type="text" id="txtTemporaryCargoClass" readonly="readonly" style="width: 650px" /></td>
			</tr>
		</table>
	</div>
	<div class="buttonDiv"align="center" style="padding: 535px 0 0 0;">
		<input type="button" id="btnTemporaryReturn" class="button" value="Return" style="width: 100px;"/>
	</div>
</div>
<script>
 	initializeAll();
 	try {
		var shareCd = '${shareCd}';
		var all = '${all}';
		var mode = '${mode}';
		var excludeExpired = objUWGlobal.hidGIPIS109Obj.isListExposure ? 'N': objUWGlobal.hidGIPIS109Obj.excludeExpired;
		var excludeNotEff = objUWGlobal.hidGIPIS109Obj.isListExposure ? 'N': objUWGlobal.hidGIPIS109Obj.excludeNotEff;
		var distTsiCond = all == "Y"? false : true;
		$("txtTemporaryVesselCd").value = objUWGlobal.hidGIPIS109Obj.selectedObj.vesselCd;
		$("txtTemporaryVesselName").value = unescapeHTML2(objUWGlobal.hidGIPIS109Obj.selectedObj.vesselName); //benjo 10.12.2015 added unescapeHTML2 GENQA-SR-5049
		var jsonVesselTemporaryExposures = JSON.parse('${jsonItemTemporaryExposures}');
		vesselTemporaryExposuresTableModel = {
			url : contextPath+ "/GIPIPolbasicController?action=showItemTemporaryExposures&refresh=1&vesselCd=" + objUWGlobal.hidGIPIS109Obj.selectedObj.vesselCd 
																						     + "&shareCd=" + shareCd 
																						 	 + "&all=" + all 
																						 	 + "&mode=" + mode 
																							 + "&excludeExpired=" + excludeExpired
																							 + "&excludeNotEff=" + excludeNotEff,
		 	id : "GIPIS109ItemTemporaryExposures",	
			options : {
				width : '855px',
				height : '325px',
				onCellFocus : function(element, value, x, y, id) {
					var obj = tbgVesselTemporaryExposures.geniisysRows[y];
					populateTemporaryExposure(obj);
					tbgVesselTemporaryExposures.keys.removeFocus(tbgVesselTemporaryExposures.keys._nCurrentFocus, true);
					tbgVesselTemporaryExposures.keys.releaseKeys();
				},
				postPager : function() {
					populateTemporaryExposure(null);
					tbgVesselTemporaryExposures.keys.removeFocus(tbgVesselTemporaryExposures.keys._nCurrentFocus, true);
					tbgVesselTemporaryExposures.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					populateTemporaryExposure(null);
					tbgVesselTemporaryExposures.keys.removeFocus(tbgVesselTemporaryExposures.keys._nCurrentFocus, true);
					tbgVesselTemporaryExposures.keys.releaseKeys();
				},
				onSort : function() {
					populateTemporaryExposure(null);
					tbgVesselTemporaryExposures.keys.removeFocus(tbgVesselTemporaryExposures.keys._nCurrentFocus, true);
					tbgVesselTemporaryExposures.keys.releaseKeys();
				},
				toolbar : {
					elements : [ MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN ],
					onFilter : function() {
						populateTemporaryExposure(null);
						tbgVesselTemporaryExposures.keys.removeFocus(tbgVesselTemporaryExposures.keys._nCurrentFocus, true);
						tbgVesselTemporaryExposures.keys.releaseKeys();
					},
					onRefresh : function() {
						populateTemporaryExposure(null);
						tbgVesselTemporaryExposures.keys.removeFocus(tbgVesselTemporaryExposures.keys._nCurrentFocus, true);
						tbgVesselTemporaryExposures.keys.releaseKeys();
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
						width : '80px',
						align: 'right',
				    	titleAlign: 'right',
						filterOption: true,
						renderer: function(value){
				    		return nvl(value,'') == '' ? '' :formatNumberDigits(nvl(value, 0),12);
				    	}
					},
					{
						id : "itemTitle",
						title : "Item Title",
						width : mode == "ITEM" ? '230px' : '0',
						filterOption: mode == "ITEM" ? true : false, 
						visible: mode == "ITEM" ? true : false
					},
					{
						id : "perilName",
						title : "Perils",
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
						width : mode == "PERIL" ? '120px' : '0',
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
						width : distTsiCond ? '120px' : '0',
						filterOption: distTsiCond,
						visible: distTsiCond
					},
					{
						id : "assdName",
						title : "Assured",
						width : '250px',
						filterOption: true
					},
					{
						id : "dspEta",
						title : "ETA",
						align: 'center',
				    	titleAlign: 'center',
						width : '100px',
						filterOption: true
					},
					{
						id : "dspEtd",
						title : "ETD",
						align: 'center',
				    	titleAlign: 'center',
						width : '120px',
						filterOption: true
					},
					{
						id : "blAwb",
						title : "BL/AWB",
						width : '120px',
						filterOption: true
					},
					{
						id : "nbtDistStatus",
						title : "Dist. Status",
						width : '120px',
						filterOption: true
					},
					{
						id : "dspExpiryDate",
						title : "Expiry",
						align: 'center',
				    	titleAlign: 'center',
						width : '120px',
						filterOption: true
					},
				],
			rows : jsonVesselTemporaryExposures.rows
		};
		tbgVesselTemporaryExposures = new MyTableGrid(vesselTemporaryExposuresTableModel);
		tbgVesselTemporaryExposures.pager = jsonVesselTemporaryExposures;
		tbgVesselTemporaryExposures.render('vesselTemporaryExposuresTable');
	} catch (e) {
		showErrorMessage("vesselTemporaryExposuresTableModel", e);
	} 
	
	function populateTemporaryExposure(obj) {
		$("txtTemporaryCargoType").value 			= obj			== null ? "" : unescapeHTML2(nvl(obj.cargoType,""));
		$("txtTemporaryCargoClass").value 			= obj			== null ? "" : unescapeHTML2(nvl(obj.cargoClass,""));
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
	
	function showTemporaryExposures(modeParam) {
		try{
			new Ajax.Request(contextPath+"/GIPIPolbasicController",{
				method: "POST",
				parameters : {action : "showItemTemporaryExposures",
							  vesselCd : objUWGlobal.hidGIPIS109Obj.selectedObj.vesselCd,
							  shareCd : shareCd,
							  all : all,
							  mode : modeParam,
							  excludeExpired : excludeExpired,
							  excludeNotEff : excludeNotEff
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
	
	$("btnTemporaryReturn").observe("click",function(){
		objUWGlobal.hidGIPIS109Obj.isListExposure = false;
		overlayTemporaryExposures.close();
	});
</script>
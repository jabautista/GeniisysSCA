<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="catastrophicEventMainDiv" name="catastrophicEventMainDiv" style="height: 1250px;">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Catastrophic Event Inquiry</label>
	   	</div>
	</div>
	<div id="sectionDivTop" class="sectionDiv">
		<table cellspacing="0" align="center" style="margin: 15px 100px 15px 100px;">
			<tr>
				<td class="rightAligned">Catastrophic Event</td>
				<td class="leftAligned" colspan="5">
					<span class="lovSpan" style="width: 70px; height: 21px; margin: 2px 2px 0 0; float: left;">
						<input type="text" id="txtCatEventCd" name="txtCatEventCd" style="width: 43px; float: left; border: none; height: 13px;" class="integerNoNegativeUnformattedNoComma rightAligned searchField" lpad="5" maxlength="7" tabindex="101" />
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchCatEvent" name="searchCatEvent" alt="Go" style="float: right;" class="searchLOV">
					</span> 
					<span class="lovSpan" style="border: none; width: 527px; height: 21px; margin: 0 2px 0 2px; float: left;">
						<input type="text" id="txtCatEventName" name="txtCatEventName" style="width: 517px; float: left; height: 15px;" class="disableDelKey allCaps" maxlength="50" readonly="readonly"/>
					</span>	
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Line</td>
				<td class="leftAligned" colspan="2">
					<span class="lovSpan" style="width: 70px; height: 21px; margin: 2px 2px 0 0; float: left;">
						<input type="text" id="txtLineCd" name="txtLineCd" style="width: 43px; float: left; border: none; height: 13px;" class="allCaps searchField" maxlength="2" tabindex="102" />
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLine" name="searchLine" alt="Go" style="float: right;" class="searchLOV">
					</span> 
					<span class="lovSpan" style="border: none; width: 186px; height: 21px; margin: 0 2px 0 2px; float: left;">
						<input type="text" id="txtLineName" name="txtLineName" style="width: 176px; float: left; height: 15px;" class="disableDelKey allCaps" maxlength="30" readonly="readonly"/>
					</span>	
				</td>
				<td class="rightAligned" style="width: 68px;">Branch</td>
				<td class="leftAligned" colspan="2">
					<span class="lovSpan" style="width: 70px; height: 21px; margin: 2px 2px 0 0; float: left;">
						<input type="text" id="txtBranchCd" name="txtBranchCd" style="width: 43px; float: left; border: none; height: 13px;" class="allCaps searchField" maxlength="2" tabindex="103" />
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranch" name="searchBranch" alt="Go" style="float: right;" class="searchLOV">
					</span> 
					<span class="lovSpan" style="border: none; width: 187px; height: 21px; margin: 0 2px 0 2px; float: left;">
						<input type="text" id="txtBranchName" name="txtBranchName" style="width: 177px; float: left; height: 15px;" class="disableDelKey allCaps" maxlength="30" readonly="readonly"/>
					</span>	
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Location</td>
				<td colspan="5">
					<span class="lovSpan" style="border: none; width: 603px; height: 21px; margin: 0 2px 0 4px; float: left;">
						<input type="text" id="txtLocation" name="txtLocation" style="width: 593px; float: left; height: 13px;" class="allCaps searchField" maxlength="160" tabindex="104" />
					</span>
				</td>
			</tr>
			<tr>  
				<td class="rightAligned">Loss Date From</td>
				<td class="leftAligned" colspan="2">
					<span class="lovSpan" style="width: 258px; height: 21px; margin: 4px 4px 0 0; float: left;">
						<input id="txtFromDate" readonly="readonly" type="text" class="date" maxlength="10" style="border: none; float: left; width: 233px; height: 13px; margin: 0px;" value="" />
						<img id="imgFromDate" alt="imgFromDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtFromDate'),this, null);" tabindex="105"/>
					</span>
				</td>
				<td class="rightAligned">To</td>
				<td class="leftAligned" colspan="2">
					<span class="lovSpan" style="width: 259px; height: 21px; margin: 4px 4px 0 0; float: left;">
						<input id="txtToDate" readonly="readonly" type="text" class="date" maxlength="10" style="border: none; float: left; width: 234px; height: 13px; margin: 0px;" value="" />
						<img id="imgToDate" alt="imgToDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtToDate'),this, null);" tabindex="106" />
					</span>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Loss Category</td>
				<td class="leftAligned" colspan="5">
					<span class="lovSpan" style="width: 70px; height: 21px; margin: 2px 2px 0 0; float: left;">
						<input type="text" id="txtLossCategoryCd" name="txtLossCategoryCd" style="width: 43px; float: left; border: none; height: 13px;" class="allCaps subField" maxlength="2" tabindex="107" />
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLossCategory" name="searchLossCategory" alt="Go" style="float: right;" class="subLOV">
					</span> 
					<span class="lovSpan" style="border: none; width: 527px; height: 21px; margin: 0 2px 0 2px; float: left;">
						<input type="text" id="txtLossCategoryName" name="txtLossCategoryName" style="width: 517px; float: left; height: 15px;" class="disableDelKey allCaps" maxlength="25" readonly="readonly"/>
					</span>	
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Province</td>
				<td class="leftAligned" colspan="2">
					<span class="lovSpan" style="width: 70px; height: 21px; margin: 2px 2px 0 0; float: left;">
						<input type="text" id="txtProvinceCd" name="txtProvinceCd" style="width: 43px; float: left; border: none; height: 13px;" class="allCaps subField" maxlength="6" tabindex="108" />
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchProvince" name="searchProvince" alt="Go" style="float: right;" class="subLOV">
					</span> 
					<span class="lovSpan" style="border: none; width: 186px; height: 21px; margin: 0 2px 0 2px; float: left;">
						<input type="text" id="txtProvinceName" name="txtProvinceName" style="width: 176px; float: left; height: 15px;" class="disableDelKey allCaps" maxlength="30" readonly="readonly"/>
					</span>	
				</td>
				<td class="rightAligned" style="width: 68px;">City</td>
				<td class="leftAligned" colspan="2">
					<span class="lovSpan" style="width: 70px; height: 21px; margin: 2px 2px 0 0; float: left;">
						<input type="text" id="txtCityCd" name="txtCityCd" style="width: 43px; float: left; border: none; height: 13px;" class="allCaps subField" maxlength="6" tabindex="110" />
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchCity" name="searchCity" alt="Go" style="float: right;" class="subLOV">
					</span> 
					<span class="lovSpan" style="border: none; width: 187px; height: 21px; margin: 0 2px 0 2px; float: left;">
						<input type="text" id="txtCityName" name="txtCityName" style="width: 177px; float: left; height: 15px;" class="disableDelKey allCaps" maxlength="40" readonly="readonly"/>
					</span>	
				</td>
			</tr>
			<tr>
				<td class="rightAligned">District</td>
				<td class="leftAligned" colspan="2">
					<span class="lovSpan" style="width: 70px; height: 21px; margin: 2px 2px 0 0; float: left;">
						<input type="text" id="txtDistrictCd" name="txtDistrictCd" style="width: 43px; float: left; border: none; height: 13px;" class="allCaps subField" maxlength="6" tabindex="109" />
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchDistrict" name="searchDistrict" alt="Go" style="float: right;" class="subLOV">
					</span> 
					<span class="lovSpan" style="border: none; width: 186px; height: 21px; margin: 0 2px 0 2px; float: left;">
						<input type="text" id="txtDistrictName" name="txtDistrictName" style="width: 176px; float: left; height: 15px;" class="disableDelKey allCaps" maxlength="40" readonly="readonly"/>
					</span>	
				</td>
				<td class="rightAligned" style="width: 68px;">Block</td>
				<td class="leftAligned" colspan="2">
					<span class="lovSpan" style="width: 70px; height: 21px; margin: 2px 2px 0 0; float: left;">
						<input type="text" id="txtBlockCd" name="txtBlockCd" style="width: 43px; float: left; border: none; height: 13px;" class="disableDelKey allCaps subField" maxlength="6" tabindex="111" />
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBlock" name="searchBlock" alt="Go" style="float: right;" class="subLOV">
					</span> 
					<span class="lovSpan" style="border: none; width: 187px; height: 21px; margin: 0 2px 0 2px; float: left;">
						<input type="text" id="txtBlockName" name="txtBlockName" style="width: 177px; float: left; height: 15px;" class="disableDelKey allCaps" maxlength="40" readonly="readonly"/>
					</span>	
				</td>
			</tr>
			<tr>
				<td></td>
				<td class="leftAligned" colspan="2">
					<input type="radio" name="rdoQueryCondition" id="rdoAll" style="float: left; margin: 15px 10px 3px 0px;" tabindex="112" checked="checked"/>
					<label for="rdoAll" style="float: left; height: 20px; padding-top: 15px;" title="Claim File Date">Satisfy All Conditions entered</label>
				</td>
				<td class="leftAligned" colspan="2">
					<input type="radio" name="rdoQueryCondition" id="rdoAtleastOne" style="float: left; margin: 15px 10px 3px 50px;" tabindex="113"/>
					<label for="rdoAtleastOne" style="float: left; height: 20px; padding-top: 15px;" title="Loss Date">Satisfy at least one of the Conditions entered</label>
				</td>
			</tr>
		</table>
	</div>
	<div class=sectionDiv>
		<div id="catastrophicEventTableDiv" style="padding: 10px 10px 10px 10px;">
			<div id="catastrophicEventTable" style="height: 355px;"></div>
		</div>
		<div>
			<fieldset class="sectionDiv" style="float:left; margin:20px; margin-top: 0;margin-right:0; width:47%;">
				<legend style="font-weight: bold; font-size: 11px;">Reserve Amount Totals</legend>
				<div id="totalsDiv" class="" style="padding:20px;">
					<table>
						<tr>
							<td class="rightAligned" style="width:150px;">Net Retention</td>
							<td class="leftAligned"><input class="rightAligned" type="text" id="txtNetRetention" name="txtNetRetention" style="width:200px;" value="0.00" readonly="readonly"></td>
						</tr>
						<tr>
							<td class="rightAligned">Proportional Treaty</td>
							<td class="leftAligned"><input class="rightAligned" type="text" id="txtPropTrty" name="txtPropTrty" style="width:200px;" value="0.00" readonly="readonly"></td>
						</tr>
						<tr>
							<td class="rightAligned">Non-Proportional Treaty</td>
							<td class="leftAligned"><input class="rightAligned" type="text" id="txtNonPropTrty" name="txtNonPropTrty" style="width:200px;" value="0.00" readonly="readonly"></td>
						</tr>
						<tr>
							<td class="rightAligned">Facul</td>
							<td class="leftAligned"><input class="rightAligned" type="text" id="txtFacul" name="txtFacul" style="width:200px;" value="0.00" readonly="readonly"></td>
						</tr>							
					</table>
				</div>
			</fieldset>
			<fieldset class="sectionDiv" style="float:right; margin:20px; margin-top: 0;margin-left:0; width:47%;">
				<legend style="font-weight: bold; font-size: 11px;">Paid Amount Totals</legend>
				<div id="totalsDiv" class="" style="padding:20px;">
					<table>
						<tr>
							<td class="rightAligned" style="width:150px;">Net Retention</td>
							<td class="leftAligned"><input class="rightAligned" type="text" id="txtPNetRetention" name="txtPNetRetention" style="width:200px;" value="0.00" readonly="readonly"></td>
						</tr>
						<tr>
							<td class="rightAligned">Proportional Treaty</td>
							<td class="leftAligned"><input class="rightAligned" type="text" id="txtPPropTrty" name="txtPPropTrty" style="width:200px;" value="0.00" readonly="readonly"></td>
						</tr>
						<tr>
							<td class="rightAligned">Non-Proportional Treaty</td>
							<td class="leftAligned"><input class="rightAligned" type="text" id="txtPNonPropTrty" name="txtPNonPropTrty" style="width:200px;" value="0.00" readonly="readonly"></td>
						</tr>
						<tr>
							<td class="rightAligned">Facul</td>
							<td class="leftAligned"><input class="rightAligned" type="text" id="txtPFacul" name="txtPFacul" style="width:200px;" value="0.00" readonly="readonly"></td>
						</tr>							
					</table>
				</div>
			</fieldset>
		</div>
				<div>
			<fieldset class="sectionDiv" style="width:880px; margin:20px; margin-top: 0;">
				<div id="totalsDiv" class="" style="padding:20px;">
					<table>
						<tr>
							<td class="rightAligned" style="width:120px;">Policy Number</td>
							<td class="leftAligned"><input class="leftAligned" type="text" id="txtPolNo" name="txtPolNo" style="width:250px;" readonly="readonly"></td>
							<td class="rightAligned" style="width:120px;">Loss Reserve</td>
							<td class="leftAligned"><input class="rightAligned" type="text" id="txtLossRes" name="txtLossRes" style="width:250px;" value="0.00" readonly="readonly"></td>
						</tr>
						<tr>
							<td class="rightAligned">Assured</td>
							<td class="leftAligned"><input class="leftAligned" type="text" id="txtAssured" name="txtAssured" style="width:250px;"  readonly="readonly"></td>
							<td class="rightAligned">Losses Paid</td>
							<td class="leftAligned"><input class="rightAligned" type="text" id="txtLossPd" name="txtLossPd" style="width:250px;" value="0.00" readonly="readonly"></td>
						</tr>
						<tr>
							<td class="rightAligned">Processor</td>
							<td class="leftAligned"><input class="leftAligned" type="text" id="txtProc" name="txtProc" style="width:250px;"  readonly="readonly"></td>
							<td class="rightAligned">Expense Reserve</td>
							<td class="leftAligned"><input class="rightAligned" type="text" id="txtExpRes" name="txtExpRes" style="width:250px;" value="0.00" readonly="readonly"></td>
						</tr>
						<tr>
							<td class="rightAligned">Status</td>
							<td class="leftAligned">
								<input class="leftAligned" type="text" id="txtStatCd" name="txtStatCd" style="width:50px;"  readonly="readonly">
								<input class="leftAligned" type="text" id="txtStatus" name="txtStatus" style="width:188px;" readonly="readonly">
							</td>
							<td class="rightAligned">Expenses Paid</td>
							<td class="leftAligned"><input class="rightAligned" type="text" id="txtExpPd" name="txtExpPd" style="width:250px;" value="0.00" readonly="readonly"></td>
						</tr>							
					</table>
				</div>
			</fieldset>
		</div>
		<div style="float: left; width: 100%; margin-bottom: 10px;" align="center">
			<input type="button" class="button" id="btnCatMaintenance" value="Catastrophic Maintenance" tabindex="401" style="width: 200px;"/>
			<input type="button" class="button" id="btnGrpRecords" value="Group Records" tabindex="402" style="width: 200px;"/>
		</div>
		<div style="float: left; width: 100%; margin-bottom: 10px;" align="center">
			<input type="button" class="button" id="btnPrintReport" value="Print Report" tabindex="403" style="width: 140px;"/>
		</div>
	</div>
</div>
<script type="text/javascript">
	setModuleId("GICLS057");
	setDocumentTitle("Catastrophic Event Inquiry");
	initializeAll();
	initializeAccordion();
	defaultPageSetting();
	
	var selectedRow = new Object();
	var row = 0;	
	
	function showTableGrid(){
		try {
			CatastrophicEventTableModel = {
				url : contextPath+ "/GICLCatastrophicEventController?action=showCatastrophicEventInquiry&refresh=1",
				id: "CatastrophicEventTable",
				options : {
					height : '350px',
					pager : {},
					onCellFocus : function(element, value, x, y, id) {
						tgbCatastrophicEvent.keys.releaseKeys();
						populateDetails(tgbCatastrophicEvent.geniisysRows[y]);
						row = y;
						//selectedRow = tgbCatastrophicEvent.geniisysRows[y];
					},
					onRemoveRowFocus : function(element, value, x, y, id) {
						tgbCatastrophicEvent.keys.releaseKeys();
						populateDetails(null);
					},
					onSort : function(){
						tgbCatastrophicEvent.keys.releaseKeys();
						tgbCatastrophicEvent.keys.removeFocus(tgbCatastrophicEvent.keys._nCurrentFocus, true);
						populateDetails(null);
					},
					postPager : function() {
						tgbCatastrophicEvent.keys.releaseKeys();
						populateDetails(null);
					},
					onRefresh : function() {
						tgbCatastrophicEvent.keys.releaseKeys();
						tgbCatastrophicEvent.keys.removeFocus(tgbCatastrophicEvent.keys._nCurrentFocus, true);
						populateDetails(null);
					}
				},
				columnModel : [ 
					{
					    id: 'recordStatus',
					    width: '0',
					    visible: false
					},
					{
						id: 'divCtrId',
						width: '0',
						visible: false 
					},{
						id : "",
						title : "",
						sortable:false,
						children : [{
							id: 'grpSw',
		              		title : 'C',
			              	width: 32,
			              	sortable: false,
			              	editable: false,
			              	editor: new MyTableGrid.CellCheckbox({
				            	getValueOf : function(value) {
									if (value) {
										return "Y";
									} else {
										return "N";
									}
								}
			              	})
						},{
							id : "claimNo",
							title : "Claim Number",
							width : 140,
						}, 
						{
							id : "lossCatDes",
							title : "Loss Category",
							width : 140,
						},
						{
							id : "catastrophicDesc",
							title : "Catastrophic Event",
							width : 150,
						},
						{
							id : "lossDate",
							title : "Loss Date",
							width : 80,
						},
						{
							id : "location",
							title : "Location",
							width : 150,
						}]
					},
					{
						id : "resAmount",
						title : "Reserve Amount",
						sortable:false,
						children : [ {
							id : "netResAmt",
							title : "Net Retention",
							align : "right",
							titleAlign: "right",
							width : 160,
							filterOptionType: 'number',
							filterOption : true,
							renderer : function(value) {
						    	return formatCurrency(value);
						    }
						},
						{
							id : "trtyResAmt",
							title : "Proportional Treaty",
							align : "right",
							titleAlign: "right",
							width : 160,
							filterOptionType: 'number',
							filterOption : true,
							renderer : function(value) {
						    	return formatCurrency(value);
						    }
						},
						{
							id : "npTrtyResAmt",
							title : "Non-Proportional Treaty",
							align : "right",
							titleAlign: "right",
							width : 160,
							filterOptionType: 'number',
							filterOption : true,
							renderer : function(value) {
						    	return formatCurrency(value);
						    }
						},
						{
							id : "faculResAmt",
							title : "Facul",
							align : "right",
							titleAlign: "right",
							width : 160,
							filterOptionType: 'number',
							filterOption : true,
							renderer : function(value) {
						    	return formatCurrency(value);
						    }
						}]
					},{
						id : "pdAmount",
						title : "Paid Amount",
						sortable:false,
						children : [ {
							id : "netPdAmt",
							title : "Net Retention",
							align : "right",
							titleAlign: "right",
							width : 160,
							filterOptionType: 'number',
							filterOption : true,
							renderer : function(value) {
						    	return formatCurrency(value);
						    }
						},
						{
							id : "trtyPdAmt",
							title : "Proportional Treaty",
							align : "right",
							titleAlign: "right",
							width : 160,
							filterOptionType: 'number',
							filterOption : true,
							renderer : function(value) {
						    	return formatCurrency(value);
						    }
						},
						{
							id : "npTrtyPdAmt",
							title : "Non-Proportional Treaty",
							align : "right",
							titleAlign: "right",
							width : 160,
							filterOptionType: 'number',
							filterOption : true,
							renderer : function(value) {
						    	return formatCurrency(value);
						    }
						},
						{
							id : "faculPdAmt",
							title : "Facul",
							align : "right",
							titleAlign: "right",
							width : 160,
							filterOptionType: 'number',
							filterOption : true,
							renderer : function(value) {
						    	return formatCurrency(value);
						    }
						}]
					},{
						sortable:false,
						children : [ {
							id : "province",
							title : "Province",
							width : 130,
						},
						{
							id : "city",
							title : "City",
							width : 130,
						},
						{
							id : "districtDesc",
							title : "District",
							width : 130,
						},
						{
							id : "blockDesc",
							title : "Block",
							width : 130,
						}]
					}
				],
				rows : []
			};
			tgbCatastrophicEvent = new MyTableGrid(CatastrophicEventTableModel);
			tgbCatastrophicEvent.render('catastrophicEventTable');
		} catch (e) {
			showErrorMessage("CatastrophicEventInquiry.jsp", e);
		} 
	}
	
	$("btnCatMaintenance").observe("click",function(){
		showMessageBox(objCommonMessage.UNAVAILABLE_MODULE, imgMessage.INFO);
	});
	
	$("btnToolbarExit").observe("click", function(){
		document.stopObserving("keyup");
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
	});
	
	$("searchCatEvent").observe("click", showCatastrophicLOV);
	$("searchLine").observe("click", showLineLOV);
	$("searchBranch").observe("click", showBranchLOV);
	$("searchLossCategory").observe("click", showLossCatLOV);
	$("searchProvince").observe("click", showProvinceLOV);
	$("searchCity").observe("click", showCityLOV);
	$("searchDistrict").observe("click", showDistrictLOV);
	$("searchBlock").observe("click", showBlockLOV);
	
	function showCatastrophicLOV(){
		try{
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action   : "getGicls057CatastrophicLOV",
					page : 1
				},
				title: "Catastrophic Event",
				width: 470,
				height: 400,
				columnModel: [
		 			{
						id : 'catastrophicCd',
						title: 'Catastrophic Cd',
						width : '100px',
						align: 'right',
						titleAlign : 'right'
					},
					{
						id : 'catastrophicDesc',
						title: 'Catastrophic Desc',
					    width: '335px',
					    align: 'left'
					}
				],
				autoSelectOneRecord : true,
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtCatEventCd").value = unescapeHTML2(row.catastrophicCd);
						$("txtCatEventName").value = unescapeHTML2(row.catastrophicDesc);
						toggleToolbarButton(true);
					}
				},
				onCancel: function(){
					$("txtCatEventCd").focus();
		  		}
			});
		}catch(e){
			showErrorMessage("showCatastrophicLOV",e);
		}
	}
	
	function showLineLOV(){
		try{
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action   : "getGicls057LineLOV",
					moduleId : "GICLS057",
					page : 1
				},
				title: "Line",
				width: 470,
				height: 400,
				columnModel: [
		 			{
						id : 'lineCd',
						title: 'Line Cd',
						width : '100px',
						align: 'right',
						titleAlign : 'right'
					},
					{
						id : 'lineName',
						title: 'Line Name',
					    width: '335px',
					    align: 'left'
					}
				],
				autoSelectOneRecord : true,
				draggable: true,
				findText : $("txtLineCd").value,
				onSelect: function(row) {
					if(row != undefined){
						$("txtLineCd").value = unescapeHTML2(row.lineCd);
						$("txtLineName").value = unescapeHTML2(row.lineName); 
						toggleToolbarButton(true);
						$("txtLossCategoryCd").readOnly = false;
						enableSearch("searchLossCategory");
						validateLineIfFI($("txtLineCd").value);
					}
				},
				onCancel: function(){
					$("txtLineCd").focus();
		  		}
			});
		}catch(e){
			showErrorMessage("showLineLOV",e);
		}
	}
	
	function showBranchLOV(){
		try{
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action   : "getGicls057BranchLOV",
					moduleId : "GICLS057",
					page : 1
				},
				title: "Issue Source",
				width: 470,
				height: 400,
				columnModel: [
		 			{
						id : 'issCd',
						title: 'Issue Cd',
						width : '100px',
						align: 'right',
						titleAlign : 'right'
					},
					{
						id : 'issName',
						title: 'Issue Name',
					    width: '335px',
					    align: 'left'
					}
				],
				autoSelectOneRecord : true,
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtBranchCd").value = unescapeHTML2(row.issCd);
						$("txtBranchName").value = unescapeHTML2(row.issName); 
						toggleToolbarButton(true);
					}
				},
				onCancel: function(){
					$("txtBranchCd").focus();
		  		}
			});
		}catch(e){
			showErrorMessage("showBranchLOV",e);
		}
	}
	
	function showLossCatLOV(){
		try{
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action   : "getGicls057LossCatLOV",
					lineCd : $("txtLineCd").value,
					page : 1
				},
				title: "Loss Category",
				width: 470,
				height: 400,
				columnModel: [
		 			{
						id : 'lossCatCd',
						title: 'Loss Category Cd',
						width : '100px',
						align: 'right',
						titleAlign : 'right'
					},
					{
						id : 'lossCatDes',
						title: 'Loss Category Desc',
					    width: '335px',
					    align: 'left'
					}
				],
				autoSelectOneRecord : true,
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtLossCategoryCd").value = unescapeHTML2(row.lossCatCd);
						$("txtLossCategoryName").value = unescapeHTML2(row.lossCatDes); 
						toggleToolbarButton(true);
					}
				},
				onCancel: function(){
					$("txtLossCategoryCd").focus();
		  		}
			});
		}catch(e){
			showErrorMessage("showLossCatLOV",e);
		}
	}
		
	function showProvinceLOV(){
			try{
				LOV.show({
					controller : "ClaimsLOVController",
					urlParameters : {
						action   : "getGicls057ProvinceLOV",
						page : 1
					},
					title: "Province",
					width: 470,
					height: 400,
					columnModel: [
			 			{
							id : 'provinceCd',
							title: 'Province Cd',
							width : '100px',
							align: 'right',
							titleAlign : 'right'
						},
						{
							id : 'provinceDesc',
							title: 'Province Desc',
						    width: '335px',
						    align: 'left'
						}
					],
					autoSelectOneRecord : true,
					draggable: true,
					onSelect: function(row) {
						if(row != undefined){
							$("txtProvinceCd").value = unescapeHTML2(row.provinceCd);
							$("txtProvinceName").value = unescapeHTML2(row.provinceDesc); 
							toggleToolbarButton(true);
							$("txtCityCd").readOnly = false;
							enableSearch("searchCity");
						}
					},
					onCancel: function(){
						$("txtProvinceCd").focus();
			  		}
				});
			}catch(e){
				showErrorMessage("showProvinceLOV",e);
			}
	}
	
	function showCityLOV(){
		try{
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action   : "getGicls057CityLOV",
					provinceCd : $("txtProvinceCd").value,
					page : 1
				},
				title: "Province",
				width: 470,
				height: 400,
				columnModel: [
		 			{
						id : 'cityCd',
						title: 'City Cd',
						width : '100px',
						align: 'right',
						titleAlign : 'right'
					},
					{
						id : 'city',
						title: 'City',
					    width: '335px',
					    align: 'left'
					}
				],
				autoSelectOneRecord : true,
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtCityCd").value = unescapeHTML2(row.cityCd);
						$("txtCityName").value = unescapeHTML2(row.city); 
						toggleToolbarButton(true);
					}
				},
				onCancel: function(){
					$("txtCityCd").focus();
		  		}
			});
		}catch(e){
			showErrorMessage("showCityLOV",e);
		}
	}
	
	function showDistrictLOV(){
		try{
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action   : "getGicls057DistrictLOV",
					provinceCd : $("txtProvinceCd").value,
					cityCd : $("txtCityCd").value,
					page : 1
				},
				title: "District",
				width: 470,
				height: 400,
				columnModel: [
		 			{
						id : 'districtNo',
						title: 'District No',
						width : '100px',
						align: 'right',
						titleAlign : 'right'
					},
					{
						id : 'districtDesc',
						title: 'District',
					    width: '335px',
					    align: 'left'
					}
				],
				autoSelectOneRecord : true,
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtDistrictCd").value = unescapeHTML2(row.districtNo);
						$("txtDistrictName").value = unescapeHTML2(row.districtDesc); 
						toggleToolbarButton(true);
						$("txtBlockCd").readOnly = false;
						enableSearch("searchBlock");
					}
				},
				onCancel: function(){
					$("txtDistrictCd").focus();
		  		}
			});
		}catch(e){
			showErrorMessage("showDistrictLOV",e);
		}
	}
	
	function showBlockLOV(){
		try{
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action   : "getGicls057BlockLOV",
					provinceCd : $("txtProvinceCd").value,
					cityCd : $("txtCityCd").value,
					districtCd : $("txtDistrictCd").value,
					page : 1
				},
				title: "Block",
				width: 470,
				height: 400,
				columnModel: [
		 			{
						id : 'blockNo',
						title: 'Block No',
						width : '100px',
						align: 'right',
						titleAlign : 'right'
					},
					{
						id : 'blockDesc',
						title: 'Block Desc',
					    width: '335px',
					    align: 'left'
					}
				],
				autoSelectOneRecord : true,
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtBlockCd").value = unescapeHTML2(row.blockNo);
						$("txtBlockName").value = unescapeHTML2(row.blockDesc); 
						toggleToolbarButton(true);
					}
				},
				onCancel: function(){
					$("txtBlockCd").focus();
		  		}
			});
		}catch(e){
			showErrorMessage("showBlockLOV",e);
		}
	}
	
	function validateLineCd(){
		new Ajax.Request(contextPath+"/GICLCatastrophicEventController", {
			method: "POST",
			parameters: {
				action: "validateGicls057Line",
				lineCd: $F("txtLineCd")
			},
			onCreate: showNotice("Please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(nvl(obj.lineCd, "") == ""){
						showWaitingMessageBox("Invalid Value for Line.", "I", function(){
							$("txtLineCd").focus();
							$("txtLineCd").value = "";
							$("txtLineName").value = "";
							toggleToolbarButton(false);
						});
					}else{
						$("txtLineCd").value = obj.lineCd;
						$("txtLineName").value = obj.lineName;
						toggleToolbarButton(true);
						$("txtLossCategoryCd").readOnly = false;
						enableSearch("searchLossCategory");
						validateLineIfFI($("txtLineCd").value);
					}
				}
			}
		});
	}
	$("txtLineCd").observe("change", function(){
		if($("txtLineCd").value != ""){
			validateLineCd();
		}
		if($("txtLineCd").value == ""){
			$("txtLineName").value = "";
			disableSubSearch();
			$("txtLossCategoryCd").readOnly = true;
			$("txtLossCategoryCd").clear();
			$("txtLossCategoryName").clear();
			disableSearch("searchLossCategory");
		}
	});
	
	function validateCatastrophyCd(){
		new Ajax.Request(contextPath+"/GICLCatastrophicEventController", {
			method: "POST",
			parameters: {
				action: "validateGicls057Catastrophy",
				catastrophicCd: $F("txtCatEventCd")
			},
			onCreate: showNotice("Please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(nvl(obj.catastrophicCd, "") == ""){
						showWaitingMessageBox("Invalid Value for Catastrophic Event.", "I", function(){
							$("txtCatEventCd").focus();
							$("txtCatEventCd").value = "";
							$("txtCatEventName").value = "";
							toggleToolbarButton(false);
						});
					}else{
						$("txtCatEventCd").value = obj.catastrophicCd;
						$("txtCatEventName").value = obj.catastrophicDesc;
						toggleToolbarButton(true);
					}
				}
			}
		});
	}
	$("txtCatEventCd").observe("change", function(){
		if($("txtCatEventCd").value != ""){
			validateCatastrophyCd();
		}
		if($("txtCatEventCd").value == ""){
			$("txtCatEventName").value = "";
		}
	});
	
	function validateBranchCd(){
		new Ajax.Request(contextPath+"/GICLCatastrophicEventController", {
			method: "POST",
			parameters: {
				action: "validateGicls057Branch",
				issCd: $F("txtBranchCd")
			},
			onCreate: showNotice("Please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(nvl(obj.issCd, "") == ""){
						showWaitingMessageBox("Invalid Value for Branch.", "I", function(){
							$("txtBranchCd").focus();
							$("txtBranchCd").value = "";
							$("txtBranchName").value = "";
							toggleToolbarButton(false);
						});
					}else{
						$("txtBranchCd").value = obj.issCd;
						$("txtBranchName").value = obj.issName;
						toggleToolbarButton(true);
					}
				}
			}
		});
	}
	$("txtBranchCd").observe("change", function(){
		if($("txtBranchCd").value != ""){
			validateBranchCd();
		}
		if($("txtBranchCd").value == ""){
			$("txtBranchName").value = "";
		}
	});
	
	$("txtLossCategoryCd").observe("change", function(){
		if($("txtLossCategoryCd").value == ""){
			$("txtLossCategoryName").value = "";
		}
	});
	
	$("txtProvinceCd").observe("change", function(){
		if($("txtProvinceCd").value == ""){
			$("txtProvinceName").value = "";
			$("txtCityCd").readOnly = true;
			$("txtCityCd").clear();
			$("txtCityName").clear();
			disableSearch("searchCity");
		}
		if($("txtDistrictCd").value != ""){
			$("txtCityCd").readOnly = false;
			enableSearch("searchCity");
			$("txtCityCd").clear();
			$("txtCityName").clear();
		}
	});
	
	$("txtCityCd").observe("change", function(){
		if($("txtCityCd").value == ""){
			$("txtCityName").value = "";
		}
	});
	
	$("txtDistrictCd").observe("change", function(){
		if($("txtDistrictCd").value == ""){
			$("txtDistrictName").value = "";
			$("txtBlockCd").readOnly = true;
			$("txtBlockCd").clear();
			$("txtBlockName").clear();
			disableSearch("searchBlock");
		}
		if($("txtDistrictCd").value != ""){
			$("txtBlockCd").readOnly = false;
			enableSearch("searchBlock");
			$("txtBlockCd").clear();
			$("txtBlockName").clear();
		}
	});
	
	$("txtBlockCd").observe("change", function(){
		if($("txtBlockCd").value == ""){
			$("txtBlockName").value = "";
		}
	});
	
	function getParameters(calTotal){
		var param ="";
		var selection = 1;
		if($("rdoAll").checked){
			selection = 1;
		} else if ($("rdoAtleastOne").checked){
			selection = 2;
		}
		param = "&selection="+selection+"&catastrophicCd="+$F("txtCatEventCd")+"&lineCd="+$F("txtLineCd")+"&issCd="+$F("txtBranchCd")+"&location="+$F("txtLocation")+"&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate")+
				"&lossCatCd="+$F("txtLossCategoryCd")+"&provinceCd="+$F("txtProvinceCd")+"&cityCd="+$F("txtCityCd")+"&districtNo="+$F("txtDistrictCd")+"&blockNo="+$F("txtBlockCd")+"&calTotal="+calTotal; // 4-29-2016 SR-5417
		return param;
	}
	
	function queryTable(calTotal){ // 4-29-2016 SR-5417
		tgbCatastrophicEvent.url = contextPath +"/GICLCatastrophicEventController?action=showCatastrophicEventInquiry&refresh=1"+getParameters(calTotal);
		tgbCatastrophicEvent._refreshList();
		if(calTotal != null){ // 4-29-2016 SR-5417
			populateTotal(tgbCatastrophicEvent.geniisysRows);
		}
		enableToolbarButton("btnToolbarPrint");
		enableButton("btnCatMaintenance");
		enableButton("btnPrintReport");
	}
	
	function populateTotal(obj){
		try{
			var totNetRet = 0;
			var totPropTrty = 0;
			var totNonPropTrty = 0;
			var totFacul = 0;
			var totPNetRet = 0;
			var totPPropTrty = 0;
			var totPNonPropTrty = 0;
			var totPFacul = 0;
			if(obj != null){
				for(var i=0;i<obj.length;i++){
					totNetRet = Number(totNetRet) + Number(obj[i].netResAmt);
					totPropTrty = Number(totPropTrty) + Number(obj[i].trtyResAmt);
					totNonPropTrty = Number(totNonPropTrty) + Number(obj[i].npTrtyResAmt);
					totFacul = Number(totFacul) + Number(obj[i].faculResAmt);
					totPNetRet = Number(totPNetRet) + Number(obj[i].netPdAmt);
					totPPropTrty = Number(totPPropTrty) + Number(obj[i].trtyPdAmt);
					totPNonPropTrty = Number(totPNonPropTrty) + Number(obj[i].npTrtyPdAmt);
					totPFacul = Number(totPFacul) + Number(obj[i].faculPdAmt);
				}
			}
			$("txtNetRetention").value 	= formatCurrency(nvl(totNetRet, 0));
			$("txtPropTrty").value 		= formatCurrency(nvl(totPropTrty, 0));
			$("txtNonPropTrty").value 	= formatCurrency(nvl(totNonPropTrty, 0));
			$("txtFacul").value 		= formatCurrency(nvl(totFacul,0));
			$("txtPNetRetention").value = formatCurrency(nvl(totPNetRet, 0));
			$("txtPPropTrty").value		= formatCurrency(nvl(totPPropTrty, 0));
			$("txtPNonPropTrty").value 	= formatCurrency(nvl(totPNonPropTrty, 0));
			$("txtPFacul").value 		= formatCurrency(nvl(totPFacul,0));
		} catch(e) {
			showErrorMessage("populateTotal", e);
		}
	}
	
	function toggleSearch(sw){
		if(sw){
			$$("div#sectionDivTop img.searchLOV").each(function(x){
				disableSearch(x);
			});
			$$("div#sectionDivTop img.subLOV").each(function(x){
				disableSearch(x);
			});
			$$("div#sectionDivTop input[type='text'].subField").each(function(x){
				x.readOnly = true;
			});
			disableDate("imgFromDate");
			disableDate("imgToDate");
		} else {
			$$("div#sectionDivTop img.searchLOV").each(function(x){
				enableSearch(x);
			});
			enableDate("imgFromDate");
			enableDate("imgToDate");
			$$("div#sectionDivTop input[type='text'].subField").each(function(x){
				x.readOnly = true;
			});
			$$("div#sectionDivTop img.subLOV").each(function(x){
				disableSearch(x);
			});
		}
		
		//switch
		$$("div#sectionDivTop input[type='text'].searchField").each(function(x){
			x.readOnly = sw;
		});
		$$("div#sectionDivTop input[type='radio']").each(function(x){
			x.disabled = sw;
		});
	}
	
	function populateDetails(rec){
		try{
			$("txtPolNo").value 		= rec == null ? "" : unescapeHTML2(rec.policyNo);
			$("txtAssured").value		= rec == null ? "" : unescapeHTML2(rec.assdName);
			$("txtProc").value			= rec == null ? "" : unescapeHTML2(rec.inHouAdj);
			$("txtStatCd").value		= rec == null ? "" : unescapeHTML2(rec.clmStatCd);
			$("txtStatus").value		= rec == null ? "" : unescapeHTML2(rec.clmStatDesc);
			$("txtLossRes").value		= rec == null ? "0.00" : formatCurrency(nvl(rec.lossResAmt,0));
			$("txtLossPd").value		= rec == null ? "0.00" : formatCurrency(nvl(rec.lossPdAmt,0));
			$("txtExpRes").value		= rec == null ? "0.00" : formatCurrency(nvl(rec.expResAmt,0));
			$("txtExpPd").value			= rec == null ? "0.00" : formatCurrency(nvl(rec.expPdAmt,0));
		} catch(e){	
			showErrorMessage("setDetailsForm", e);
		}
	}
	
	function defaultPageSetting(){
		$("txtCatEventCd").focus();
		toggleSearch(false);
		populateDetails(null);
		populateTotal(null);
		disableToolbarButton("btnToolbarPrint");
		toggleToolbarButton(false);
		showTableGrid();
		$$("div#sectionDivTop input[type='text']").each(function(x){
			x.clear();
		});
		disableButton("btnCatMaintenance");
		disableButton("btnGrpRecords");
		disableButton("btnPrintReport");
	}
	
	function toggleToolbarButton(sw){
		if(sw){
			enableToolbarButton("btnToolbarExecuteQuery");
			enableToolbarButton("btnToolbarEnterQuery");
		} else {
			disableToolbarButton("btnToolbarExecuteQuery");
			disableToolbarButton("btnToolbarEnterQuery");
		}
	}
	
	$("btnToolbarExecuteQuery").observe("click",function(){
		var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g, "/")) : "";
		var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g, "/")) : "";
		
		if (fromDate == "" && toDate != "") {   // start: 4-29-2016 SR-5417
			customShowMessageBox("From date is empty.", "I", "txtFromDate");
		}else if (fromDate != "" && toDate == ""){
			customShowMessageBox("To date is empty.", "I", "txtFromDate"); // end: 4-29-2016 SR-5417
		}else{
			toggleSearch(true);
			queryTable("calculate"); // 4-29-2016 SR-5417
			queryTable(null);
			disableToolbarButton("btnToolbarExecuteQuery");
		}
	});
	
	$("btnToolbarEnterQuery").observe("click",function(){
		defaultPageSetting();
	});
	
	$$("div#sectionDivTop input[type='text'].searchField").each(function(x){
		x.observe("change",function(){
			if($(x).value != ""){
				toggleToolbarButton(true);
			} else {
				toggleToolbarButton(false);
			}
		});
	});
	$("txtFromDate").observe("focus",function(){
		if($("txtFromDate").value != ""){
			toggleToolbarButton(true);
		} else {
			toggleToolbarButton(false);
		}
	});
	$("txtToDate").observe("focus",function(){
		if($("txtToDate").value != ""){
			toggleToolbarButton(true);
		} else {
			toggleToolbarButton(false);
		}
	});
	
	function validateLineIfFI(line){
		if(line == "FI"){
			$("txtProvinceCd").readOnly = false;
			$("txtDistrictCd").readOnly = false;
			enableSearch("searchProvince");
			enableSearch("searchDistrict");
		}
		else{
			disableSubSearch();
			return false;
		}
	}
	
	function disableSubSearch(){
		$("txtProvinceCd").readOnly = true;
		$("txtProvinceCd").clear();
		$("txtProvinceName").clear();
		disableSearch("searchProvince");
		
		$("txtDistrictCd").readOnly = true;
		$("txtDistrictCd").clear();
		$("txtDistrictName").clear();
		disableSearch("searchDistrict");
	}
	
	observeBackSpaceOnDate("txtFromDate");
	observeBackSpaceOnDate("txtToDate");
	
	$("btnPrintReport").observe("click", function(){
		showGenericPrintDialog("Print Claim Listing", printReport, "", true);
		$("csvOptionDiv").show(); // added by Kevin for SR-5417
	});
	
	$("btnToolbarPrint").observe("click", function(){
		showGenericPrintDialog("Print Claim Listing", printReport, "", true);
		$("csvOptionDiv").show(); // added by Kevin for SR-5417
	});
	
	function printReport() {
		try {
			var reportId;
			if($("rdoAll").checked){ //start: SR-5417
				if($("txtLineCd").value == "FI"){
					if($F("txtDistrictCd") == "" && $F("txtBlockCd") == "" && $F("txtProvinceCd") == "" && $F("txtCityCd") == ""){
						reportId = "GICLR057B";
					}else{
						reportId = "GICLR057A";
					}
				}else{
					reportId = "GICLR057D";
				}
			}else{
				reportId = "GICLR057C";
			}
			
			if($F("selDestination") == "file") {
				if ($("rdoCsv").checked) 
					reportId = reportId+"_CSV";
			}//end: SR-5417
			var content = contextPath + "/PrintClaimListingInquiryController?action=printReport"
			+"&reportId="+reportId+"&catCd="+$("txtCatEventCd").value
			+"&lineCd="+$("txtLineCd").value
			+"&lossCatCd="+$("txtLossCategoryCd").value
			+"&issCd="+$F("txtBranchCd")
			+"&location="+$F("txtLocation")
			+"&blockNo="+$F("txtBlockCd")
			+"&districtNo="+$F("txtDistrictCd")
			+"&cityCd="+$F("txtCityCd")
			+"&provinceCd="+$F("txtProvinceCd")
			+"&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate");
			if ("screen" == $F("selDestination")) {
				showPdfReport(content, "Catastrophic Event Inquiry");
			} else if ($F("selDestination") == "printer") {
				new Ajax.Request(content, {
					parameters : {
						noOfCopies : $F("txtNoOfCopies"),
						printerName : $F("selPrinter")
						},
					onCreate : showNotice("Processing, please wait..."),
					onComplete : function(response) {
						hideNotice();
						if (checkErrorOnResponse(response)) {

						}
					}
				});
			} else if ("file" == $F("selDestination")) {
				var fileType = "PDF"; /* start: added by Kevin 4-22-2016 SR-5417 */
				
				if($("rdoPdf").checked)
					fileType = "PDF";
				else if ($("rdoCsv").checked)
					fileType = "CSV2"; //end SR-5417
					
				new Ajax.Request(content, {
					parameters : {
						destination : "file",
						fileType : fileType
					},
					onCreate : showNotice("Generating report, please wait..."),
					onComplete : function(response) {
						hideNotice();
						if (checkErrorOnResponse(response)){
							if (fileType == "CSV2"){ //start: added by Kevin 4-22-2016 SR-5417
								copyFileToLocal(response, "csv");
							} else 
								copyFileToLocal(response);
						} //end SR-5417
					}
				});
			} else if ("local" == $F("selDestination")) {
				new Ajax.Request(content, {
					parameters : {
						destination : "local"
					},
					onComplete : function(response) {
						hideNotice();
						if (checkErrorOnResponse(response)) {
							var message = printToLocalPrinter(response.responseText);
							if (message != "SUCCESS") {
								showMessageBox(message, imgMessage.ERROR);
							}
						}
					}
				});
			}
		} catch (e) {
			showErrorMessage("printReport", e);
		}
	}
	
	function validateCollFromAndTo(field) {
		var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g, "/")) : "";
		var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g, "/")) : "";
		
		if (fromDate > toDate && toDate != "") {
			if (field == "txtFromDate") {
				customShowMessageBox("From Date should not be later than To Date.", "I", "txtFromDate");
			} else {
				customShowMessageBox("From Date should not be later than To Date.", "I", "txtToDate");
			}
			$(field).clear();
			return false;
		}
	}
	
	$("txtFromDate").observe("focus", function() {
		validateCollFromAndTo("txtFromDate");
	});
	
	$("txtToDate").observe("focus", function() {
		validateCollFromAndTo("txtToDate");
	});
</script>

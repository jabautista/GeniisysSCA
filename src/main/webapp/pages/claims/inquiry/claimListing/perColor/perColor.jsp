<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="perColorMainDiv" name="perColorMainDiv" style="float: left; margin-bottom: 50px;">
<!--  	<div id="mainNav" name="mainNav"> -->
<!-- 		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu"> -->
<!-- 			<ul> -->
<!-- 				<li><a id="clmPerColorExit">Exit</a></li> -->
<!-- 			</ul> -->
<!-- 		</div> -->
<!-- 	</div> -->
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Claim Listing per Color</label>
	   	</div>
	</div>	
	<div class="sectionDiv">
		<div style="float: left;">
			<table style="margin: 10px 10px 5px 60px;">
				<tr>
					<td class="rightAligned">Color</td>
					<td class="leftAligned">
						<span class="lovSpan" style="width: 400px; margin-right: 30px;">
							<input type="hidden" id="hidColorCd" name="hidColorCd"/>
							<input type="hidden" id="hidColor" name="hidColor"/>
							<input type="text" id="txtColor" name="txtColor" style="width: 370px; float: left; border: none; height: 14px; margin: 0;" class="" tabindex="101"/>  
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchColor" name="imgSearchColor" alt="Go" style="float: right;" tabindex="102"/>
						</span>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Basic Color</td>
					<td class="leftAligned">
						<span class="lovSpan" style="width: 400px; margin-right: 30px;">
							<input type="hidden" id="hidBasicColorCd" name="hidBasicColorCd"/>
							<input type="text" id="txtBasicColor" name="txtBasicColor" style="width: 370px; float: left; border: none; height: 14px; margin: 0;" class="" tabindex="103"/>  
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchBasicColor" name="imgSearchBasicColor" alt="Go" style="float: right;" tabindex="104"/>
						</span>
					</td>
				</tr>
			</table>
			<div style="float: left; margin-left: 134px; margin-bottom: 10px;">
				<fieldset style="width: 386px;">
					<legend>Search By</legend>
					<table>
						<tr>
							<td class="rightAligned">
								<input type="radio" name="searchBy" id="rdoClaimFileDate" style="float: left; margin: 3px 2px 3px 70px;" tabindex="105" />
								<label for="rdoClaimFileDate" style="float: left; height: 20px; padding-top: 3px;" title="Claim File Date">Claim File Date</label>
							</td>
							<td class="rightAligned">
								<input type="radio" name="searchBy" id="rdoLossDate" style="float: left; margin: 3px 2px 3px 50px;" tabindex="106"/>
								<label for="rdoLossDate" style="float: left; height: 20px; padding-top: 3px;" title="Loss Date">Loss Date</label>
							</td>
						</tr>
					</table>
				</fieldset>
			</div>	
		</div>
		<div class="sectionDiv" style="float: left; width: 255px; margin: 12px;">
			<table style="margin: 8px;">	
				<tr>
					<td class="rightAligned"><input type="radio" name="byDate" id="rdoAsOf" title="As of" style="float: left;" tabindex="107"/><label for="rdoAsOf" title="As of" style="float: left; height: 20px; padding-top: 3px;">As of</label></td>
					<td class="leftAligned">
						<div style="float: left; width: 165px;" class="withIconDiv" id="asOfDiv">
							<input type="text" id="txtAsOfDate" name="txtAsOfDate" removeStyle="true" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="108"/>
							<img id="hrefAsOfDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="As of Date" tabindex="109"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned"><input type="radio" name="byDate" id="rdoFrom" title="From" style="float: left;" tabindex="110"/><label for="rdoFrom" style="float: left; height: 20px; padding-top: 3px;">From</label></td>
					<td class="leftAligned">
						<div style="float: left; width: 165px;" class="withIconDiv" id="fromDiv">
							<input type="text" id="txtFromDate" name="txtFromDate" removeStyle="true" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="111"/>
							<img id="hrefFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" tabindex="112"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">To</td>
					<td class="leftAligned">
						<div style="float: left; width: 165px;" class="withIconDiv" id="toDiv">
							<input type="text" id="txtToDate" name="txtToDate" removeStyle="true" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="113"/>
							<img id="hrefToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To Date" tabindex="114"/>
						</div>
					</td>
				</tr>
			</table>
		</div>	
	</div>
	<div class="sectionDiv">
		<div id="perColorTableDiv" style="padding: 10px 0 0 10px;">
			<div id="perColorTable" style="height: 340px"></div>
		</div>
		<div>
			<table style="margin: 5px; float: right; margin-right: 20px;">
				<tr>
					<td class="rightAligned">Totals</td>
					<td class=""><input type="text" id="txtTotLossResAmt" style="width: 120px; text-align: right;" readonly="readonly" tabindex="201"/></td>
					<td class=""><input type="text" id="txtTotLossPaidAmt" style="width: 120px; text-align: right;" readonly="readonly" tabindex="202"/></td>
					<td class=""><input type="text" id="txtTotExpResAmt" style="width: 120px; text-align: right;" readonly="readonly" tabindex="203"/></td>
					<td class=""><input type="text" id="txtTotExpPaidAmt" style="width: 120px; text-align: right;" readonly="readonly" tabindex="204"/></td>
				</tr>
			</table>
		</div>
		<div class="sectionDiv" style="margin: 10px; float: left; width: 97.5%;">
			<table style="margin: 5px; float: left;">
				<tr>
					<td class="rightAligned">Claim No</td>
					<td class="leftAligned"><input type="text" id="txtClaimNo" style="width: 400px;" readonly="readonly" tabindex="301"/></td>
					<td class="rightAligned" style="width: 110px;">Claim Status</td>
					<td class="leftAligned"><input type="text" id="txtClaimStatus" style="width: 250px;" readonly="readonly" tabindex="302"/></td>
				</tr>
				<tr>
					<td class="rightAligned">Policy No</td>
					<td class="leftAligned"><input type="text" id="txtPolicyNo" style="width: 400px;" readonly="readonly" tabindex="303"/></td>
					<td class="rightAligned">Loss Date</td>
					<td class="leftAligned"><input type="text" id="txtLossDate" style="width: 250px;" readonly="readonly" tabindex="304"/></td>
				</tr>
				<tr>
					<td class="rightAligned">Assured Name</td>
					<td class="leftAligned"><input type="text" id="txtAssured" style="width: 400px;" readonly="readonly" tabindex="305"/></td>
					<td class="rightAligned">Claim File Date</td>
					<td class="leftAligned"><input type="text" id="txtClaimFileDate" style="width: 250px;" readonly="readonly" tabindex="306"/></td>
				</tr>
				<tr>
					<input type="hidden" id="txtSearchBy" name="txtSearchBy" value=""/>				
				</tr>			
			</table>
		</div>
		<div style="float: left; width: 100%; margin-bottom: 10px;" align="center">
			<input type="button" class="button" id="btnPrintReport" value="Print Report" tabindex="401"/>
		</div>
	</div>
</div>
<script type="text/javascript">

	initializeAll();
	setModuleId("GICLS264");
	setDocumentTitle("Claim Listing Per Color");
	filterOn = false;
	colorResponse = "";
	basicColorResponse = "";
	
	//var jsonClmListPerColor = JSON.parse('${jsonClmListPerColor}');	
	perColorTableModel = {
			url : contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerColor&refresh=1",
			options: {
				toolbar: {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter : function(){
						setDetailsForm(null);
						tbgClaimsPerColor.keys.removeFocus(tbgClaimsPerColor.keys._nCurrentFocus, true);
						tbgClaimsPerColor.keys.releaseKeys();
						filterOn = true;
						togglePrintButton(false);
					}
				},
				width: '900px',
				pager: {
				},
				onCellFocus : function(element, value, x, y, id) {
					setDetailsForm(tbgClaimsPerColor.geniisysRows[y]);					
					tbgClaimsPerColor.keys.removeFocus(tbgClaimsPerColor.keys._nCurrentFocus, true);
					tbgClaimsPerColor.keys.releaseKeys();
					togglePrintButton(true);
				},
				prePager: function(){
					setDetailsForm(null);
					tbgClaimsPerColor.keys.removeFocus(tbgClaimsPerColor.keys._nCurrentFocus, true);
					tbgClaimsPerColor.keys.releaseKeys();
					togglePrintButton(false);
				},
				onRemoveRowFocus : function(element, value, x, y, id){					
					setDetailsForm(null);
					togglePrintButton(false);
				},
				onSort : function(){
					setDetailsForm(null);
					tbgClaimsPerColor.keys.removeFocus(tbgClaimsPerColor.keys._nCurrentFocus, true);
					tbgClaimsPerColor.keys.releaseKeys();	
					togglePrintButton(false);
				},
				onRefresh : function(){
					setDetailsForm(null);
					tbgClaimsPerColor.keys.removeFocus(tbgClaimsPerColor.keys._nCurrentFocus, true);
					tbgClaimsPerColor.keys.releaseKeys();
					togglePrintButton(false);
				}				
			},									
			columnModel: [
				{
				    id: 'recordStatus',
				    title: '',
				    width: '0',
				    visible: false
				},
				{
					id: 'divCtrId',
					width: '0',
					visible: false 
				},				
				{
					id : "itemNo",
					title: "Item No.",
					width: '80px',
					filterOption : true,
					filterOptionType: 'number',
					align : "right",
					titleAlign : "right"
				},				
				{
					id : "itemTitle",
					title: "Item Title",
					width: '150px',
					filterOption : true
				},
				{
					id : "plateNo",
					title: "Plate No.",
					width: '120px',
					filterOption : true
				},
				{
					id : "lossResAmt",
					title: "Loss Reserve",
					width: '130px',
					filterOption : true,
					align : 'right',
					titleAlign : 'right',
					filterOptionType: 'number',
					geniisysClass: 'money'
				},
				{
					id : "lossPaidAmt",
					title: "Losses Paid",
					width: '130px',
					filterOption : true,
					align : 'right',
					titleAlign : 'right',
					filterOptionType: 'number',
					geniisysClass: 'money'
				},
				{
					id : "expResAmt",
					title: "Expense Reserve",
					width: '130px',
					filterOption : true,
					align : 'right',
					titleAlign : 'right',
					filterOptionType: 'number',
					geniisysClass: 'money'
				},
				{
					id : "expPaidAmt",
					title: "Expenses Paid",
					width: '130px',
					filterOption : true,
					align : 'right',
					titleAlign : 'right',
					filterOptionType: 'number',
					geniisysClass: 'money'
				}
			],
			rows: []//jsonClmListPerColor.rows
		};
	
	tbgClaimsPerColor = new MyTableGrid(perColorTableModel);
	//tbgClaimsPerColor.pager = jsonClmListPerColor;
	tbgClaimsPerColor.render('perColorTable');
	tbgClaimsPerColor.afterRender = function(){
		if(tbgClaimsPerColor.geniisysRows.length > 0){
			if (filterOn == true) {
				computeTotal();
			}else {
				var rec = tbgClaimsPerColor.geniisysRows[0];
	 			$("txtTotLossResAmt").value 	= formatCurrency(rec.totLossResAmt);
				$("txtTotLossPaidAmt").value 	= formatCurrency(rec.totLossPaidAmt);
				$("txtTotExpResAmt").value 		= formatCurrency(rec.totExpResAmt);
				$("txtTotExpPaidAmt").value 	= formatCurrency(rec.totExpPaidAmt);
			}
		} else {
			$("txtTotLossResAmt").value 	= "";
			$("txtTotLossPaidAmt").value 	= "";
			$("txtTotExpResAmt").value 		= "";
			$("txtTotExpPaidAmt").value 	= "";
		}
	};
	
	function computeTotal() {
		var totLossResAmt  = 0;
		var totLossPaidAmt = 0;
		var totExpResAmt   = 0;
		var totExpPaidAmt  = 0;
		for (var i = 0; i < tbgClaimsPerColor.geniisysRows.length; i++) {
			totLossResAmt 	= totLossResAmt  + parseFloat(tbgClaimsPerColor.geniisysRows[i].lossResAmt);
			totLossPaidAmt	= totLossPaidAmt + parseFloat(tbgClaimsPerColor.geniisysRows[i].lossPaidAmt);
			totExpResAmt	= totExpResAmt   + parseFloat(tbgClaimsPerColor.geniisysRows[i].expResAmt);
			totExpPaidAmt	= totExpPaidAmt  + parseFloat(tbgClaimsPerColor.geniisysRows[i].expPaidAmt);
		}
		$("txtTotLossResAmt").value  = formatCurrency(parseFloat(nvl(totLossResAmt, "0")));
		$("txtTotLossPaidAmt").value = formatCurrency(parseFloat(nvl(totLossPaidAmt, "0")));
		$("txtTotExpResAmt").value	 = formatCurrency(parseFloat(nvl(totExpResAmt, "0")));
		$("txtTotExpPaidAmt").value  = formatCurrency(parseFloat(nvl(totExpPaidAmt, "0")));
	}
	
	function setDetailsForm(rec){
		try{
			$("txtClaimNo").value 		= rec == null ? "" : rec.claimNumber;
			$("txtPolicyNo").value		= rec == null ? "" : rec.policyNo;
			$("txtAssured").value		= rec == null ? "" : unescapeHTML2(rec.assdName);
			$("txtClaimStatus").value	= rec == null ? "" : rec.clmStatDesc;
			$("txtLossDate").value		= rec == null ? "" : dateFormat(rec.lossDate, "mm-dd-yyyy");
			$("txtClaimFileDate").value = rec == null ? "" : dateFormat(rec.clmFileDate, "mm-dd-yyyy");
		} catch(e){
			showErrorMessage("setDetailsForm", e);
		}
	}
	
	function setFieldOnSearch() {
		validateDate();
		if (validateDate()) {
			toggleDateFields();
			toggleSearchBy();
			setTbgParametersPerDate();
			setTbgParametersPerSearchBy();
			disableSearch("imgSearchColor");
			disableSearch("imgSearchBasicColor");
			disableInputField("txtColor");
			disableInputField("txtBasicColor");
	 		if (tbgClaimsPerColor.geniisysRows.length == 0) {
				customShowMessageBox("Query caused no records to be retrieved. Re-enter.", imgMessage.INFO, "txtColor");
				disableButton("btnPrintReport");
			}
	 		disableToolbarButton("btnToolbarExecuteQuery");
		}
	}
	
	function resetHeaderForm(){
		try{
			if($F("hidColorCd") != "" || $F("txtColor") != "" || $F("hidBasicColorCd") != "" || $F("txtBasicColor") != ""){
				$("hidColorCd").value = "";
				$("hidColor").value = "";
				$("txtColor").value = "";
				$("hidBasicColorCd").value = "";
				$("txtBasicColor").value = "";
				enableInputField("txtBasicColor");
				enableInputField("txtColor");
				basicColorResponse = "";
				colorResponse = "";
				color = "";
				setClaimListingPerColor();
				tbgClaimsPerColor.url = contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerColor&refresh=1&colorCd="+$F("hidColorCd")+"&basicColorCd="+$F("hidBasicColorCd");
				tbgClaimsPerColor._refreshList();
				$("txtColor").focus();
				executeQuery = false;
			}
		} catch(e){
			showErrorMessage("resetHeaderForm", e);
		}
	}
	
	//set searchby parameter value
	function toggleSearchBy() {
		if ($("rdoClaimFileDate").checked == true) {
			$("txtSearchBy").value = "claimFileDate";
		}else {
			$("txtSearchBy").value = "lossDate";
		}
	}
	
	//set tbg url per selected date params
 	function setTbgParametersPerDate() {
		if ($("rdoAsOf").checked == true) {
			tbgClaimsPerColor.url = contextPath +"/GICLClaimListingInquiryController?action=showClaimListingPerColor&refresh=1&colorCd="+$F("hidColorCd")
												+"&basicColorCd="+$F("hidBasicColorCd")+"&searchBy="+ $F("txtSearchBy") +"&asOfDate="+$F("txtAsOfDate");
			tbgClaimsPerColor._refreshList();
		}
		
		if ($("rdoFrom").checked == true) {
			tbgClaimsPerColor.url = contextPath +"/GICLClaimListingInquiryController?action=showClaimListingPerColor&refresh=1&colorCd="+$F("hidColorCd")
												+"&basicColorCd="+$F("hidBasicColorCd")+"&searchBy="+ $F("txtSearchBy") +"&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate");
			tbgClaimsPerColor._refreshList();
		}
	} 
	
	//set tbg url per selected searchby params
	function setTbgParametersPerSearchBy() {
		if ($("rdoClaimFileDate").checked == true) {
			$("txtSearchBy").value = "claimFileDate";
			tbgClaimsPerColor.url = contextPath +"/GICLClaimListingInquiryController?action=showClaimListingPerColor&refresh=1&colorCd="+$F("hidColorCd")
												+"&basicColorCd="+$F("hidBasicColorCd")+"&searchBy="+$F("txtSearchBy")+"&asOfDate="+$F("txtAsOfDate")
												+"&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate");
			tbgClaimsPerColor._refreshList();
		}
		
		if ($("rdoLossDate").checked == true) {
			$("txtSearchBy").value = "lossDate";
			tbgClaimsPerColor.url = contextPath +"/GICLClaimListingInquiryController?action=showClaimListingPerColor&refresh=1&colorCd="+$F("hidColorCd")
												+"&basicColorCd="+$F("hidBasicColorCd")+"&searchBy="+$F("txtSearchBy")+"&asOfDate="+$F("txtAsOfDate") 
												+"&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate");
			tbgClaimsPerColor._refreshList();
		}
	}
	
	//enable/disable date fields based on selected radio button
	function toggleDateFields() {
		if ($("rdoAsOf").checked == true) {
			disableDate("hrefAsOfDate");
			$("rdoAsOf").disabled 		= true;
			$("rdoFrom").disabled 		= true;
			$("txtAsOfDate").disabled 	= true;
		} else if ($("rdoFrom").checked == true) {
			disableDate("hrefFromDate");
			disableDate("hrefToDate");
			$("rdoFrom").disabled 		= true;
			$("rdoAsOf").disabled 		= true;
			$("txtFromDate").disabled 	= true;
			$("txtToDate").disabled 	= true;
		}
	}
	
	//enable/disable calendar icon
	function toggleCalendar(enable){
		if (nvl(enable,false) == true){
			//enable asof calendar
			$("txtAsOfDate").value 		= "";
			$("txtAsOfDate").disabled 	= true;
			$("txtFromDate").disabled 	= false;
			$("txtToDate").disabled 	= false;
			disableDate("hrefAsOfDate");
			enableDate("hrefFromDate");
			enableDate("hrefToDate");
			$("txtFromDate").setStyle({backgroundColor: '#FFFACD'});
			$("fromDiv").setStyle({backgroundColor: '#FFFACD'});
			$("txtToDate").setStyle({backgroundColor: '#FFFACD'});
			$("toDiv").setStyle({backgroundColor: '#FFFACD'});
			$("txtAsOfDate").setStyle({backgroundColor: '#F0F0F0'});
			$("asOfDiv").setStyle({backgroundColor: '#F0F0F0'});
		}else{	
			//disable asof calendar
			$("txtAsOfDate").value 		= getCurrentDate();
			$("txtFromDate").value 		= "";
			$("txtToDate").value 		= "";
			$("txtAsOfDate").disabled 	= false;
			$("txtFromDate").disabled 	= true;
			$("txtToDate").disabled 	= true;
			enableDate("hrefAsOfDate");
			disableDate("hrefFromDate");
			disableDate("hrefToDate");
			$("txtFromDate").setStyle({backgroundColor: '#F0F0F0'});
			$("fromDiv").setStyle({backgroundColor: '#F0F0F0'});
			$("txtToDate").setStyle({backgroundColor: '#F0F0F0'});
			$("toDiv").setStyle({backgroundColor: '#F0F0F0'});
			$("txtAsOfDate").setStyle({backgroundColor: 'white'});
			$("asOfDiv").setStyle({backgroundColor: 'white'});	
		}
	}
	
	//toggle toolbar buttons
	function togglePrintButton(enable) {
		if (nvl(enable,false) == true){
			enableButton("btnPrintReport");
			enableToolbarButton("btnToolbarPrint");
		}else {
			disableButton("btnPrintReport");
			disableToolbarButton("btnToolbarPrint");
		}
	}
	
	//initialize default ClaimListingPerColor settings
	function setClaimListingPerColor() {
		$("rdoClaimFileDate").checked 	= true;
		$("rdoAsOf").checked 			= true;
		$("rdoFrom").disabled 			= false;
		$("rdoAsOf").disabled 			= false;
		enableDate("hrefAsOfDate");
		enableDate("hrefFromDate");
		enableDate("hrefToDate");
		enableSearch("imgSearchColor");
		enableSearch("imgSearchBasicColor");
		disableButton("btnPrintReport");
		disableToolbarButton("btnToolbarPrint");
		disableToolbarButton("btnToolbarExecuteQuery");
		disableToolbarButton("btnToolbarEnterQuery");
		toggleCalendar(false);
	}
	
	function validateDate() {
		if ($("rdoFrom").checked == true) {
			if ($("txtFromDate").value == "") {
				customShowMessageBox("Pls. enter FROM date.", imgMessage.INFO, "txtFromDate");
				return false;
			}
			if ($("txtToDate").value == "") {
				customShowMessageBox("Pls. enter TO date.", imgMessage.INFO, "txtToDate");
				return false;
			}
		}
		return true;
	}
	
	//color LOV
	function showGICLS264ColorLOV(){
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getColorListLOV",
				basicColorCd : $("hidBasicColorCd").value,
				color: $F("txtColor"),
				page : 1
			},
			title : "List of Colors",
			width : 450,
			height : 390,
			columnModel : [ {
				id : "colorCd",
				title : "Color Code",
				width : '120px',
			}, {
				id : "color",
				title : "Color",
				width : '310px'
			} ],
			draggable : true,
			autoSelectOneRecord: true,
			filterText:  $("txtColor").value,
			onSelect : function(row) {
				$("txtColor").value = unescapeHTML2(row.color);
				$("hidColorCd").value = row.colorCd;
				$("txtBasicColor").value = row.basicColor;
				$("hidBasicColorCd").value = unescapeHTML2(row.basicColorCd);
				enableToolbarButton("btnToolbarExecuteQuery");
				enableToolbarButton("btnToolbarEnterQuery");
			},
			onCancel: function(){
				$("txtColor").focus();
			},
			onShow: function(){$(this.id + "_txtLOVFindText").focus();}
		});
	}
	
	//color validation on search
	function validateColorPerColor(basicColorCd) {
		new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
			method: "POST",
			parameters: {
				action : "validateColorPerColor",
				basicColorCd : basicColorCd,
				color : $F("txtColor")
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				if (response.responseText == '0') {
					colorResponse = response.responseText;
					$("txtColor").value = "";
					customShowMessageBox("There is no record of this color in GIIS_MC_COLOR.", imgMessage.INFO, "txtColor");
				} else if(response.responseText == '1') {
					validateDate();
					if (validateDate()) {
						colorResponse = response.responseText;
						if (basicColorResponse == '1') {
							$("txtColor").value = $("hidColor").value;
							if ($("txtBasicColor").value != "") {
								enableToolbarButton("btnToolbarExecuteQuery");
							}else {
								disableToolbarButton("btnToolbarExecuteQuery");
							}
						}else {
							showGICLS264ColorLOV();
							if ($("txtBasicColor").value != "") {
								enableToolbarButton("btnToolbarExecuteQuery");
							}else {
								disableToolbarButton("btnToolbarExecuteQuery");
							}
						}
					}
				} else if (response.responseText.include("Sql Exception")) {
					colorResponse = "Y";
					showGICLS264ColorLOV();
					enableToolbarButton("btnToolbarEnterQuery");
					if ($("txtColor").value != "" && $("txtBasicColor").value != "") {
						enableToolbarButton("btnToolbarExecuteQuery");
					}else {
						disableToolbarButton("btnToolbarExecuteQuery");
					}
				}
			}
		});			
	}
	
	function showGICLS264BasicColorLOV(){
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getBasicColorListLOV",
				basicColor: $F("txtBasicColor"),
				page : 1
			},
			title : "List of Basic Colors",
			width : 450,
			height : 390,
			columnModel : [ {
				id : "basicColorCd",
				title : "Basic Color Code",
				width : '120px',
			}, {
				id : "basicColor",
				title : "Basic Color",
				width : '310px'
			} ],
			draggable : true,
			autoSelectOneRecord: true,
			filterText:  $("txtBasicColor").value,
			onSelect : function(row) {
				$("txtBasicColor").value = row.basicColor;
				$("hidBasicColorCd").value = row.basicColorCd;
				$("hidColor").value = row.color;
				$("hidColorCd").value = row.colorCd;
				validateColorPerColor(row.basicColorCd);
				enableToolbarButton("btnToolbarEnterQuery");
			},
			onCancel : function(){
				$("txtBasicColor").focus();
			}
		});
	}
	
	//basic color validation on search
	function validateBasicColorPerColor() {
		new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
			method: "POST",
			parameters: {
				action : "validateBasicColorPerColor",
				basicColor : $F("txtBasicColor")
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				if (response.responseText == '0') {
					basicColorResponse = response.responseText;
					$("txtBasicColor").value = "";
					customShowMessageBox("There is no record of this basic_color in GIIS_MC_COLOR.", imgMessage.INFO, "txtBasicColor");
				} else if(response.responseText == '1') {
						basicColorResponse = response.responseText;
						showGICLS264BasicColorLOV();
						enableToolbarButton("btnToolbarEnterQuery");
						if ($("txtColor").value != "") {
							enableToolbarButton("btnToolbarExecuteQuery");
						}else {
							disableToolbarButton("btnToolbarExecuteQuery");
						}
				} else if (response.responseText.include("Sql Exception")) {
					basicColorResponse = "Y";
					showGICLS264BasicColorLOV();
					if ($("txtColor").value != "") {
						enableToolbarButton("btnToolbarExecuteQuery");
					}else {
						disableToolbarButton("btnToolbarExecuteQuery");
					}
				}
			}
		});			
	}
	
	//enable backspace on date fields
	observeBackSpaceOnDate("txtAsOfDate");
	observeBackSpaceOnDate("txtFromDate");
	observeBackSpaceOnDate("txtToDate");
	
	//date field validations
	$("txtFromDate").observe("focus", function(){
		if ($("hrefFromDate").disabled == true) return;
		var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g,"/")) :"";
		var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g,"/")) : "";
		var sysdate = new Date();
		if (fromDate > sysdate && fromDate != ""){
			customShowMessageBox("Date should not be greater than the current date.", "I", "txtFromDate");
			$("txtFromDate").clear();
			return false;
		}
		if (fromDate > toDate && toDate != ""){
			customShowMessageBox("From Date should not be later than To Date.", "I", "txtFromDate");
			$("txtFromDate").clear();
			return false;
		}
	});
	
	$("txtToDate").observe("focus", function(){
		if ($("hrefToDate").disabled == true) return;
		var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g,"/")) :"";
		var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g,"/")) :"";
		var sysdate = new Date();
		if (toDate > sysdate && toDate != ""){
			customShowMessageBox("Date should not be greater than the current date.", "I", "txtToDate");
			$("txtToDate").clear();
			return false;
		}
		if (toDate < fromDate && toDate != ""){
			customShowMessageBox("From Date should not be later than To Date.", "I", "txtToDate");
			$("txtToDate").clear();
			return false;
		}
	});
	
	$("txtAsOfDate").observe("focus", function(){
		if ($("hrefAsOfDate").disabled == true) return;
		var asOfDate = $F("txtAsOfDate") != "" ? new Date($F("txtAsOfDate").replace(/-/g,"/")) :"";
		var sysdate = new Date();
		if (asOfDate > sysdate && asOfDate != ""){
			customShowMessageBox("Date should not be greater than the current date.", "I", "txtAsOfDate");
			$("txtAsOfDate").clear();
			return false;
		}
	});
	
	//field onchange
	$("txtColor").observe("change", function() {
		if ($("txtColor").value != "") {
			$("hidColor").value = $("txtColor").value;
			validateColorPerColor($("hidBasicColorCd").value);
		}
	});
	$("txtBasicColor").observe("change", function() {
		if ($("txtBasicColor").value != "") {
			validateBasicColorPerColor();
		}
	});
	
	//tbg setting per searchby radio btn
	$("rdoClaimFileDate").observe("click", function() {
		if ($F("txtColor") != "" && colorResponse != '0' && basicColorResponse != '0' && executeQuery) {
			setTbgParametersPerSearchBy();
		}
	});
	$("rdoLossDate").observe("click", function() {
		if ($F("txtColor") != "" && colorResponse != '0' && basicColorResponse != '0' && executeQuery) {
			setTbgParametersPerSearchBy();
		}
	});
	
	//calendar icon setting per radio btn
	$("rdoFrom").observe("click", function() {
		toggleCalendar(true);
	});
	$("rdoAsOf").observe("click", function() {
		toggleCalendar(false);
	});
	
	//date fields calendar
	$("hrefFromDate").observe("click", function() {
		if ($("hrefFromDate").disabled == true) return;
		scwShow($('txtFromDate'),this, null);
	});
	$("hrefToDate").observe("click", function() {
		if($("hrefToDate").disabled == true) return;
		scwShow($('txtToDate'),this, null);
	});
	$("hrefAsOfDate").observe("click", function() {
		if ($("hrefAsOfDate").disabled == true) return;
		scwShow($('txtAsOfDate'),this, null);
	});
	
// 	//menu button
// 	$("clmPerColorExit").observe("click", function(){
// 		document.stopObserving("keyup");
// 		goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
// 	});
	
	//toolbar buttons
	$("btnToolbarEnterQuery").observe("click", resetHeaderForm);
	$("btnToolbarExecuteQuery").observe("click", function() {
		if ($("txtColor").value != "") {
			setFieldOnSearch();	
			executeQuery = true;
		}
	});
	$("btnToolbarPrint").observe("click", function(){
		showGenericPrintDialog("Print Claim Listing per Color", printReport, "", true);
		$("csvOptionDiv").show();   //added for gilcr264 csv by carlo de guzman 3/1/2016
	});
	$("btnToolbarExit").observe("click", function(){
		document.stopObserving("keyup");
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
	});
	
	//LOV btn
	$("imgSearchColor").observe("click", function() {
		showGICLS264ColorLOV();
	});
	$("imgSearchBasicColor").observe("click", function() {
		showGICLS264BasicColorLOV();
	});
	
	$("btnPrintReport").observe("click", function(){
		showGenericPrintDialog("Print Claim Listing per Color", printReport, "", true);
		$("csvOptionDiv").show();  //added for gilcr264 csv by carlo de guzman 3/1/2016
	});

	function printReport(){
		try {
			var content = contextPath + "/PrintClaimListingInquiryController?action=printReport"
							+"&reportId=GICLR264&colorCd="+$F("hidColorCd")
							+"&basicColorCd="+$F("hidBasicColorCd")
							//+"&searchBy="+($F("rdoAsOf") ? 1 : 2) changed by the codes below by robert 10.02.2013
							+"&searchBy="+($("rdoClaimFileDate").checked ? 1 : 2)
							+"&asOfDate="+$F("txtAsOfDate")
							+"&fromDate="+$F("txtFromDate")
							+"&toDate="+$F("txtToDate");
			
			if("screen" == $F("selDestination")){
				showPdfReport(content, "Claim Listing per Color");
			}else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					parameters : {noOfCopies : $F("txtNoOfCopies"),
						  	      printerName : $F("selPrinter")},
					onCreate: showNotice("Processing, please wait..."),				
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							
						}
					}
				});
			}else if("file" == $F("selDestination")){
				//added csv filetype for gilcr264 by carlo de guzman 3/1/2016 
				var fileType = "PDF";
					
					if($("rdoPdf").checked)
						fileType = "PDF";
					else if ($("rdoCsv").checked)
						fileType = "CSV";
					
					new Ajax.Request(content, {
						parameters : {destination : "file",
						fileType : fileType},
						onCreate: showNotice("Generating report, please wait..."),
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response))
							{if (fileType == "CSV"){
								copyFileToLocal(response, "csv");
								deleteCSVFileFromServer(response.responseText);
								} else 
								copyFileToLocal(response);
							}
						}
					  
					});  // end added csv filetype for gilcr264 by carlo de guzman 3/1/2016 
			}else if("local" == $F("selDestination")){
				new Ajax.Request(content, {
					parameters : {destination : "local"},
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							var message = printToLocalPrinter(response.responseText);
							if(message != "SUCCESS"){
								showMessageBox(message, imgMessage.ERROR);
							}
						}
					}
				});
			}
		} catch (e){
			showErrorMessage("printReport", e);
		}
	}
	
	$("txtColor").focus();
	setClaimListingPerColor();
	initializeAccordion();
	var executeQuery = false;

/* 	$("txtColor").observe("keyup", function(event){
		if(event.keyCode == 120 && document.activeElement.id == "txtColor"){
			showGICLS264ColorLOV();
		}
 	});

	document.observe("keyup", function(event){
		if(document.activeElement.id != "txtColor"){
			if(event.keyCode == 70){
				resetHeaderForm();
			}
		}
	}); */
	
/* 	document.stopObserving("keyup");
	document.observe("keyup", function(event){
		if(event.keyCode == 70){
			setDetailsForm(null);
			resetHeaderForm();
		} else if(event.keyCode == 71){
			if($F("hidColorCd") != "" && $F("hidBasicColorCd") != ""){
				tbgClaimsPerColor.url = contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerColor&refresh=1&colorCd="+$F("hidColorCd")+"&basicColorCd="+$F("hidBasicColorCd");
				tbgClaimsPerColor._refreshList();
			}
		}
	}); */
</script>
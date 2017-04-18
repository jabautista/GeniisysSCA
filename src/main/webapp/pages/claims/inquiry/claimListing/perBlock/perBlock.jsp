
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="perBlockMainDiv" name="perBlockMainDiv" style="float: left; margin-bottom: 50px;">
 	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="clmPerBlockExit">Exit</a></li>
			</ul>
		</div>
	</div>
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Claim Listing per Block</label>
	   	</div>
	</div>	
	<div class="sectionDiv">
		<div style="float: left;">
			<table style="margin: 10px 10px 5px 60px;">
				<tr>
					<td class="rightAligned">District</td>
					<td class="leftAligned">
						<span class="lovSpan" style="width: 400px; margin-right: 30px;">
							<input type="hidden" id="hidDistrictNo" name="hidDistrictNo"/>
							<input type="text" id="txtDistrict" name="txtDistrict" style="width: 370px; float: left; border: none; height: 14px; margin: 0;" class="" tabindex="101"/>  
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchDistrict" name="imgSearchDistrict" alt="Go" style="float: right;" tabindex="102"/>
						</span>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Block</td>
					<td class="leftAligned">
						<span class="lovSpan" style="width: 400px; margin-right: 30px;">
							<input type="hidden" id="hidBlockId" name="hidBlockId"/>
							<input type="hidden" id="hidBlockNo" name="hidBlockNo"/>
							<input type="text" id="txtBlock" name="txtBlock" style="width: 370px; float: left; border: none; height: 14px; margin: 0;" class="" tabindex="103"/>  
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchBlock" name="imgSearchBlock" alt="Go" style="float: right;" tabindex="104"/>
						</span>
					</td>
				</tr>
			</table>
			<div style="float: left; margin-left: 108px; margin-bottom: 10px;">
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
						<div style="float: left; width: 165px;" class="withIconDiv">
							<input type="text" id="txtAsOfDate" name="txtAsOfDate" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="108"/>
							<img id="hrefAsOfDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="As of Date" tabindex="109"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned"><input type="radio" name="byDate" id="rdoFrom" title="From" style="float: left;" tabindex="110"/><label for="rdoFrom" style="float: left; height: 20px; padding-top: 3px;">From</label></td>
					<td class="leftAligned">
						<div style="float: left; width: 165px;" class="withIconDiv">
							<input type="text" id="txtFromDate" name="txtFromDate" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="111"/>
							<img id="hrefFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" tabindex="112"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">To</td>
					<td class="leftAligned">
						<div style="float: left; width: 165px;" class="withIconDiv">
							<input type="text" id="txtToDate" name="txtToDate" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="113"/>
							<img id="hrefToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To Date" tabindex="114"/>
						</div>
					</td>
				</tr>
			</table>
		</div>	
	</div>
	<div class="sectionDiv">
		<div id="perBlockTableDiv" style="padding: 10px 0 0 10px;">
			<div id="perBlockTable" style="height: 340px"></div>
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
					<input type="hidden" id="txtDateCondition" name="txtDateCondition" value=""/>				
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
	setModuleId("GICLS279");
	setDocumentTitle("Claim Listing Per Block");
	filterOn = false;
	districtResponse = "";
	blockResponse = "";
	
	var jsonClmListPerBlock = JSON.parse('${jsonClmListPerBlock}');	
	perBlockTableModel = {
			url : contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerBlock&refresh=1",
			options: {
				toolbar: {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter : function(){
						setDetailsForm(null);
						tbgClaimsPerBlock.keys.removeFocus(tbgClaimsPerBlock.keys._nCurrentFocus, true);
						tbgClaimsPerBlock.keys.releaseKeys();
						filterOn = true;
						togglePrintButton(false);
					}
				},
				width: '900px',
				pager: {
				},
				onCellFocus : function(element, value, x, y, id) {
					setDetailsForm(tbgClaimsPerBlock.geniisysRows[y]);					
					tbgClaimsPerBlock.keys.removeFocus(tbgClaimsPerBlock.keys._nCurrentFocus, true);
					tbgClaimsPerBlock.keys.releaseKeys();
					togglePrintButton(true);
				},
				prePager: function(){
					setDetailsForm(null);
					tbgClaimsPerBlock.keys.removeFocus(tbgClaimsPerBlock.keys._nCurrentFocus, true);
					tbgClaimsPerBlock.keys.releaseKeys();
					togglePrintButton(false);
				},
				onRemoveRowFocus : function(element, value, x, y, id){					
					setDetailsForm(null);
					togglePrintButton(false);
				},
				onSort : function(){
					setDetailsForm(null);
					tbgClaimsPerBlock.keys.removeFocus(tbgClaimsPerBlock.keys._nCurrentFocus, true);
					tbgClaimsPerBlock.keys.releaseKeys();	
					togglePrintButton(false);
				},
				onRefresh : function(){
					setDetailsForm(null);
					tbgClaimsPerBlock.keys.removeFocus(tbgClaimsPerBlock.keys._nCurrentFocus, true);
					tbgClaimsPerBlock.keys.releaseKeys();
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
					align : "right",
					titleAlign : "right"
				},				
				{
					id : "itemTitle",
					title: "Item Title.",
					width: '272px',
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
					title: "Loss Paid",
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
					title: "Expense Paid",
					width: '130px',
					filterOption : true,
					align : 'right',
					titleAlign : 'right',
					filterOptionType: 'number',
					geniisysClass: 'money'
				},
				{
				    id: 'blockId',
				    title: '',
				    width: '0',
				    visible: false
				}
			],
			rows: jsonClmListPerBlock.rows
		};
		
	
	tbgClaimsPerBlock = new MyTableGrid(perBlockTableModel);
	tbgClaimsPerBlock.pager = jsonClmListPerBlock;
	tbgClaimsPerBlock.render('perBlockTable');
	tbgClaimsPerBlock.afterRender = function(){
		if(tbgClaimsPerBlock.geniisysRows.length > 0){
			if (filterOn == true) {
				computeTotal();
			}else {
				var rec = tbgClaimsPerBlock.geniisysRows[0];
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
		for (var i = 0; i < tbgClaimsPerBlock.geniisysRows.length; i++) {
			totLossResAmt 	= totLossResAmt  + parseFloat(tbgClaimsPerBlock.geniisysRows[i].lossResAmt);
			totLossPaidAmt	= totLossPaidAmt + parseFloat(tbgClaimsPerBlock.geniisysRows[i].lossPaidAmt);
			totExpResAmt	= totExpResAmt   + parseFloat(tbgClaimsPerBlock.geniisysRows[i].expResAmt);
			totExpPaidAmt	= totExpPaidAmt  + parseFloat(tbgClaimsPerBlock.geniisysRows[i].expPaidAmt);
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
			$("hidBlockId").value 		= rec == null ? "" : rec.blockId;
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
			disableSearch("imgSearchDistrict");
			disableSearch("imgSearchBlock");
			disableInputField("txtDistrict");
			disableInputField("txtBlock");
	 		if (tbgClaimsPerBlock.geniisysRows.length == 0) {
				customShowMessageBox("Query caused no records to be retrieved. Re-enter.", imgMessage.INFO, "txtDistrict");
				disableButton("btnPrintReport");
			}
		}
	}
	
	function resetHeaderForm(){
		try{
			if($F("hidDistrictNo") != "" || $F("txtDistrict") != "" || $F("hidBlockNo") != "" || $F("txtBlock") != ""){
				$("hidDistrictNo").value = "";
				$("txtDistrict").value = "";
				$("hidBlockNo").value = "";
				$("txtBlock").value = "";
				$("hidBlockId").value = "";
				enableInputField("txtDistrict");
				disableInputField("txtBlock");
				blockResponse = "";
				districtResponse = "";
				district = "";
				setClaimListingPerBlock();
				tbgClaimsPerBlock.url = contextPath+"/GICLClaimListingInquiryController?action=showClaimListingPerBlock&refresh=1&districtNo="+$F("hidDistrictNo")+"&blockNo="+$F("hidBlockNo");
				tbgClaimsPerBlock._refreshList();
				$("txtDistrict").focus();
				$("txtDistrict").setAttribute("lastValidValue", "");
				$("txtBlock").setAttribute("lastValidValue", "");
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
			tbgClaimsPerBlock.url = contextPath +"/GICLClaimListingInquiryController?action=showClaimListingPerBlock&refresh=1&districtNo="+$F("hidDistrictNo")
												+"&blockNo="+$F("hidBlockNo")+"&searchBy="+ $F("txtSearchBy") +"&asOfDate="+$F("txtAsOfDate");
			tbgClaimsPerBlock._refreshList();
		}
		
		if ($("rdoFrom").checked == true) {
			tbgClaimsPerBlock.url = contextPath +"/GICLClaimListingInquiryController?action=showClaimListingPerBlock&refresh=1&districtNo="+$F("hidDistrictNo")
												+"&blockNo="+$F("hidBlockNo")+"&searchBy="+ $F("txtSearchBy") +"&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate");
			tbgClaimsPerBlock._refreshList();
		}
	} 
	
	//set tbg url per selected searchby params
	function setTbgParametersPerSearchBy() {
		if ($("rdoClaimFileDate").checked == true) {
			$("txtSearchBy").value = "claimFileDate";
			tbgClaimsPerBlock.url = contextPath +"/GICLClaimListingInquiryController?action=showClaimListingPerBlock&refresh=1&districtNo="+$F("hidDistrictNo")
												+"&blockNo="+$F("hidBlockNo")+"&searchBy="+$F("txtSearchBy")+"&asOfDate="+$F("txtAsOfDate")
												+"&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate");
			tbgClaimsPerBlock._refreshList();
		}
		
		if ($("rdoLossDate").checked == true) {
			$("txtSearchBy").value = "lossDate";
			tbgClaimsPerBlock.url = contextPath +"/GICLClaimListingInquiryController?action=showClaimListingPerBlock&refresh=1&districtNo="+$F("hidDistrictNo")
												+"&blockNo="+$F("hidBlockNo")+"&searchBy="+$F("txtSearchBy")+"&asOfDate="+$F("txtAsOfDate") 
												+"&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate");
			tbgClaimsPerBlock._refreshList();
		}
		
		setDateCondition();
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
	
	
	//initialize default ClaimListingPerBlock settings
	function setClaimListingPerBlock() {
		$("rdoClaimFileDate").checked 	= true;
		$("rdoAsOf").checked 			= true;
		$("rdoFrom").disabled 			= false;
		$("rdoAsOf").disabled 			= false;
		enableDate("hrefAsOfDate");
		enableDate("hrefFromDate");
		enableDate("hrefToDate");
		enableSearch("imgSearchDistrict");
		disableSearch("imgSearchBlock");
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
	
	//district LOV
	function showGICLS279DistrictLOV(){		
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getDistrictDtlLOV",
				searchString : ($("txtDistrict").readAttribute("lastValidValue") != $F("txtDistrict") ? nvl($F("txtDistrict"),"%") : "%"),
				page : 1
			},
			title : "List of Districts",
			width : 450,
			height : 390,
			columnModel : [ {
				id : "districtNo",
				title : "District No",
				width : '120px',
			}, {
				id : "districtDesc",
				title : "District",
				width : '310px'
			} ],
			draggable : true,
			autoSelectOneRecord: true,
			filterText:  $("txtDistrict").value,
			onSelect : function(row) {
				$("txtDistrict").setAttribute("lastValidValue", row.districtDesc);
				$("txtDistrict").value = unescapeHTML2(row.districtDesc);
				$("hidDistrictNo").value = row.districtNo;
				getBlock();
				validateBlockPerBlock();
				enableToolbarButton("btnToolbarEnterQuery");
			},
			onUndefinedRow : function() {	
				customShowMessageBox("No record selected.", imgMessage.INFO,
				"txtDistrict");
				$("txtDistrict").value = "";	
				$("txtDistrict").setAttribute("lastValidValue", "");		
			},
			onCancel: function(){
				$("txtDistrict").focus();
				$("txtDistrict").value=$("txtBlock").readAttribute("lastValidValue");
			}
		});
	}	
	
	
	//district validation on search
	function validateDistrictPerBlock(blockNo) {
		new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
			method: "POST",
			parameters: {
				action : "validateDistrictPerBlock",
				blockNo : blockNo,
				district : $F("txtDistrict")
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				if (response.responseText == '0') {
					districtResponse = response.responseText;
					$("txtDistrict").value = "";
					customShowMessageBox("There is no record of this district in GIIS_BLOCK.", imgMessage.INFO, "txtDistrict");
				} else if(response.responseText == '1') {
					validateDate();
						districtResponse = response.responseText;						
						showGICLS279DistrictLOV();
						enableToolbarButton("btnToolbarEnterQuery");
						if ($("txtBlock").value != "") {
							enableToolbarButton("btnToolbarExecuteQuery");
						}else {
							disableToolbarButton("btnToolbarExecuteQuery");
						}
				} else if (response.responseText.include("Sql Exception")) {
					districtResponse = "Y";
					showGICLS279DistrictLOV();
					if ($("txtBlock").value != "") {
						enableToolbarButton("btnToolbarExecuteQuery");
					}else {
						disableToolbarButton("btnToolbarExecuteQuery");
					}
				}
			}
		});			
	}
	
	function getBlock(){
		new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
			method: "POST",
			parameters: {
				action : "getBlockByDistrictNo",
				districtNo : $F('hidDistrictNo')
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				var json = JSON.parse(response.responseText);
				if(json.blockDesc != null){
					enableSearch("imgSearchBlock");
					enableInputField("txtBlock");
				}
				if(json.blockDesc != 'F'){
					$("txtBlock").value = json.blockDesc;
					$("hidBlockNo").value = json.blockNo;
				}
			}
		});
	}
	
	function showGICLS279BlockLOV(){
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getBlockDtlLOV",
				districtNo: $F("hidDistrictNo"),
				searchString : ($("txtBlock").readAttribute("lastValidValue") != $F("txtBlock") ? nvl($F("txtBlock"),"%") : "%"),
				page : 1
			},
			title : "List of Blocks",
			width : 450,
			height : 390,
			columnModel : [ {
				id : "blockNo",
				title : "Block No.",
				width : '120px',
			}, {
				id : "blockDesc",
				title : "Block",
				width : '310px'
			} ],
			draggable : true,
			autoSelectOneRecord: true,
			filterText:  $("txtBlock").value,
			onSelect : function(row) {
				$("txtBlock").setAttribute("lastValidValue", row.blockDesc);
				$("txtBlock").value = unescapeHTML2(row.blockDesc);
				$("hidBlockNo").value = row.blockNo;
				$("hidBlockId").value = row.blockId;
				$("hidDistrictNo").value = row.districtNo;
				enableToolbarButton("btnToolbarExecuteQuery");
				enableToolbarButton("btnToolbarEnterQuery");
			},
			onCancel : function(){
				$("txtBlock").focus();
				$("txtBlock").value=$("txtBlock").readAttribute("lastValidValue");
			},
			onUndefinedRow : function() {	
				customShowMessageBox("No record selected.", imgMessage.INFO,
				"txtBlock");		
				$("txtBlock").value = "";	
				$("txtBlock").setAttribute("lastValidValue", "");		
			},
			onShow: function(){$(this.id + "_txtLOVFindText").focus();
			}
		});
	}
	
	//block validation on search
	function validateBlockPerBlock() {
		new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
			method: "POST",
			parameters: {
				action : "validateBlockPerBlock",
				block : $F("txtBlock")
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response) {
				if (response.responseText == '0') {
					blockResponse = response.responseText;
					$("txtBlock").value = "";
					customShowMessageBox("There is no record of this block in GIIS_BLOCK.", imgMessage.INFO, "txtBlock");
				} else if(response.responseText == '1') {
					validateDate();
					if (validateDate()) {
						blockResponse = response.responseText;
						if (districtResponse == '1') {
							if ($("txtDistrict").value != "") {
								enableToolbarButton("btnToolbarExecuteQuery");
							}else {
								disableToolbarButton("btnToolbarExecuteQuery");
							}
						}else {
							showGICLS279BlockLOV();
							if ($("txtDistrict").value != "") {
								enableToolbarButton("btnToolbarExecuteQuery");
							}else {
								disableToolbarButton("btnToolbarExecuteQuery");
							}
						}
					}
				} else if (response.responseText.include("Sql Exception")) {
					blockResponse = "Y";
					showGICLS279BlockLOV();
					enableToolbarButton("btnToolbarEnterQuery");
					if ($("txtDistrict").value != "" && $("txtBlock").value != "") {
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
		var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g,"/")) : "";
		var sysdate = new Date();
		if (fromDate > sysdate && fromDate != ""){
			customShowMessageBox("Date should not be greater than the current date.", "I", "txtFromDate");
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
			customShowMessageBox("TO Date should not be less than the FROM date.", "I", "txtToDate");
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
	$("txtDistrict").observe("change", function() {
		if ($("txtDistrict").value != "") {
			validateDistrictPerBlock($("hidBlockNo").value);
		}else if($F("txtDistrict").trim() == ""){ //added by fons 10.30.2013
			$("txtDistrict").setAttribute("lastValidValue","");
			resetHeaderForm();
		}
	});
	$("txtBlock").observe("change", function() {
		if ($("txtBlock").value != "") {
			validateBlockPerBlock();
		}else if($F("txtBlock").trim() == ""){
			$("txtBlock").setAttribute("lastValidValue","");
		}
	});
	
	
	//tbg setting per searchby radio btn
	$("rdoClaimFileDate").observe("click", function() {
		if ($F("txtDistrict") != "" && districtResponse != '0' && blockResponse != '0' && executeQuery) {
			setTbgParametersPerSearchBy();
		}
	});
	$("rdoLossDate").observe("click", function() {
		if ($F("txtDistrict") != "" && districtResponse != '0' && blockResponse != '0' && executeQuery) {
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
	
	//menu button
	$("clmPerBlockExit").observe("click", function(){
		document.stopObserving("keyup");
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
	});
	
	//toolbar buttons
	$("btnToolbarEnterQuery").observe("click", resetHeaderForm);
	$("btnToolbarExecuteQuery").observe("click", function() {
		if ($("txtDistrict").value != "") {
			setFieldOnSearch();	
			executeQuery = true;
			disableToolbarButton("btnToolbarExecuteQuery");
		}
	});
	$("btnToolbarPrint").observe("click", function(){
		showGenericPrintDialog("Print Claim Listing per Block", printReport, "", true);
		$("csvOptionDiv").show(); //added by Kevin for SR-5415
	});
	$("btnToolbarExit").observe("click", function(){
		document.stopObserving("keyup");
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
	});
	
	//LOV btn
	$("imgSearchDistrict").observe("click", function() {
		showGICLS279DistrictLOV();
	});
	$("imgSearchBlock").observe("click", function() {
		showGICLS279BlockLOV();
	});

	$("btnPrintReport").observe("click", function(){
		showGenericPrintDialog("Print Claim Listing per Block", printReport, "", true);
		$("csvOptionDiv").show(); //added by Kevin for SR-5415
	});
	
	function setDateCondition(){
		if($F("txtSearchBy") == "claimFileDate"){
			if ($("rdoAsOf").checked == true) {
				$("txtDateCondition").value = "and trunc(b.clm_file_date) <= to_date(\'" + $F("txtAsOfDate") + "\')";
			} else {
				$("txtDateCondition").value = "and trunc(b.clm_file_date) BETWEEN to_date(\'" + $F("txtFromDate") + "\')" +
				  "AND to_date(\'" + $F("txtToDate") + "\')";
			}
		} else {
			if ($("rdoAsOf").checked == true) {
				$("txtDateCondition").value = "and trunc(b.loss_date) <= to_date(\'" + $F("txtAsOfDate") + "\')";
			} else {
				$("txtDateCondition").value = "and trunc(b.loss_date) BETWEEN to_date(\'" + $F("txtFromDate") + "\')" +
				  "AND to_date(\'" + $F("txtToDate") + "\')";
			}
		}	
	} 
	
	function printReport(){
		try {
			var reportId; // SR-5415
			
			if($F("selDestination") == "file") { //start: SR-5415
				if ($("rdoPdf").checked) 
					reportId = "GICLR279";
				else 
					reportId = "GICLR279_CSV";		
			} else {
				reportId = "GICLR279";
			} //end: SR-5415
			
			var content = contextPath + "/PrintClaimListingInquiryController?action=printReport"
							+"&reportId="+reportId+"&districtNo="+$F("hidDistrictNo") //reportId SR-5415
							+"&blockNo="+$F("hidBlockNo")
							+"&searchBy="+$F("txtSearchBy")
							+"&asOfDate="+$F("txtAsOfDate")
							+"&fromDate="+$F("txtFromDate")
							+"&toDate="+$F("txtToDate")
							+"&blockId="+$F("hidBlockId");
			
			if("screen" == $F("selDestination")){
				showPdfReport(content, "Claim Listing per Block");
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
				var fileType = "PDF"; //Start: SR-5415
				
				if ($("rdoPdf").checked)
					fileType = "PDF";
				else
					fileType = "CSV2"; //End: SR-5415
					
				new Ajax.Request(content, {
					parameters : {destination : "file",
								  fileType    : fileType},
						  	    //fileType    : $("rdoPdf").checked ? "PDF" : "XLS"}, //SR-5415
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							if (fileType == "CSV2"){ //Start: SR-5415
								copyFileToLocal(response, "csv");
							} else 
								copyFileToLocal(response);
						} //End: SR-5415
					}
				});
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
	
	disableInputField("txtBlock");
	$("txtDistrict").focus();
	setClaimListingPerBlock();
	initializeAccordion();
	var executeQuery = false;
</script>
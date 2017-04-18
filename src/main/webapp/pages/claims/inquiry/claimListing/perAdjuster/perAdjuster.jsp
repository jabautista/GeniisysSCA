<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<!-- <div id="perAdjusterDiv"> -->
<!--  	<div id="mainNav" name="mainNav"> -->
<!-- 		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu"> -->
<!-- 			<ul>
				<li><a id="clmListingPerAdjusterQuery">Query</a></li>
			</ul> -->		
<!-- 			<ul> -->
<!-- 				<li><a id="clmListingPerAdjusterExit">Exit</a></li> -->
<!-- 			</ul> -->
<!-- 		</div> -->
<!-- 	</div> -->
<!-- </div> -->
<div id="clmListingPerAdjusterMainDiv" name="clmListingPerAdjusterMainDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Claim Listing per Adjuster</label>
	   		<span class="refreshers" style="margin-top: 0;"> 
<!-- 	   			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label> -->
<!-- 		   		<label id="reloadclmListingPerAdjuster" name="reloadclmListingPerAdjuster">Reload Form</label>  -->
	   		</span>
	   	</div>
	</div>	
	<div id="clmListingPerAdjusterDiv" align="center" class="sectionDiv">
		<div style="margin: 5px; margin-left: 10px; width: 530px; float: left; height: 85px;">
			<table border="0" align="left" style="margin-top: 15px;">
				<tr>
					<td class="rightAligned">Adjuster</td>
					<td class="leftAligned">
						<span class="lovSpan required" style="width: 453px; margin-right: 30px;">
							<input type="hidden" id="hidPayeeNo" name="hidPayeeNo"/>
							<input type="text" id="txtAdjuster" name="txtAdjuster" style="width: 410px; float: left; border: none; height: 14px; margin: 0;" class="required" tabindex="101"></input>  
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchAdjuster" name="imgSearchAdjuster" alt="Go" style="float: right;" tabindex="102"/>
						</span>
					</td>
				</tr>	
			</table>		
<!-- 			<tr>
					<td class="rightAligned" style="width: 75px;">Status </td>
				</tr> -->
			<fieldset style="width: 440px; margin-left: 45px;">
				<legend>Status</legend>
				<table style="margin-bottom: 10px;">
					<tr>
						<td><input type="radio" id="rdoOutstanding" name="rdoStatus" value="outstanding" style="width: 30px" tabindex="103"/></td>
						<td><label for="rdoOutstanding"> Outstanding</label></td>
						<td><input type="radio" id="rdoCompleted" name="rdoStatus" value="completed" style="width: 30px" tabindex="104"/></td>
						<td><label for="rdoCompleted">Completed</label></td>
						<td><input type="radio" id="rdoCancelled" name="rdoStatus" value="cancelled" style="width: 30px" tabindex="105"/></td>
						<td><label for="rdoCancelled">Cancelled</label></td>
						<td><input type="radio" id="rdoAllAdjuster" name="rdoStatus" value="allAdjuster" style="width: 30px" checked="checked" tabindex="106"/></td>
						<td><label for="rdoAllAdjuster">All Adjuster</label></td>
					</tr>
				</table>
			</fieldset>
		</div>
		<div class="sectionDiv" style="margin: 5px; margin-right: 15px; width: 340px; float: right; height: 110px;">
			<table border="0" align="center" style="margin-top: 3px;">
				<tr>
					<td class="leftAligned" style="width: 120px;">Search By: </td>
				</tr>
				<tr>
					<td class="leftAligned">
						<input style="float: left;" type="radio" id="rdoSearchBy1" name="rdoNbtDateType" value="claimFileDate" checked="checked">
						<label for="rdoSearchBy1" style="float: left;">Claim File Date</label>
					</td>
					<td class="rightAligned">
						<input type="radio" id="rdoDateBtn1" name="rdoDateBtn" value="asOf" checked="checked">
					</td>
					<td class="leftAligned"><label for="rdoDateBtn1">As of: </label></td>
					<td class="rightAligned">
						<div style="float: left; margin-left: 3px; width: 130px;" class="withIconDiv" id="asOfDiv">
					    	<input style="width: 105px;" removeStyle="true" class="withIcon" id="txtNbtAsOfDate" name="txtNbtAsOfDate" type="text" readOnly="readonly"/>
					    	<img id="hrefNbtAsOfDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="As of Date" />
					    </div>
					</td>					
				</tr>
				<tr>
					<td class="leftAligned">
						<input style="float: left;" type="radio" id="rdoSearchBy2" name="rdoNbtDateType" value="lossDate" >
						<label for="rdoSearchBy2" style="float: left;">Loss Date</label>
					</td>
					<td class="rightAligned">
						<input type="radio" id="rdoDateBtn2" name="rdoDateBtn" value="fromTo">
					</td>
					<td class="leftAligned"><label for="rdoDateBtn2">From: </label></td>
					<td class="rightAligned">
						<div style="float: left; margin-left: 3px; width: 130px;" class="withIconDiv" id="fromDiv">
					    	<input style="width: 105px;" removeStyle="true" class="withIcon" id="txtNbtFromDate" name="txtNbtFromDate" type="text" readOnly="readonly"/>
					    	<img id="hrefNbtFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="As of Date" />
					    </div>
					</td>
				</tr>
				<tr>
					<td class="leftAligned">
						<input style="float: left;" type="radio" id="rdoSearchBy3" name="rdoNbtDateType" value="dateAssigned" >
						<label for="rdoSearchBy3" style="float: left;">Date Assigned</label>
					</td>
					<td class="rightAligned"></td>
					<td class="leftAligned"><label>To: </label></td>
					<td class="rightAligned">
						<div style="float: left; margin-left: 3px; width: 130px;" class="withIconDiv "id="toDiv">
					    	<input style="width: 105px;" removeStyle="true" class="withIcon" id="txtNbtToDate" name="txtNbtToDate" type="text" readOnly="readonly"/>
					    	<img id="hrefNbtToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="As of Date" />
					    </div>
					</td>	
				</tr>
			</table>
		</div>
	</div>
</div>
<div class="sectionDiv">
	<div id="perAdjusterTableDiv" style="padding: 10px 0 0 10px;">
		<div id="perAdjusterTable" style="height: 340px"></div>
	</div>
	<div>
		<table style="margin: 5px; float: right; margin-right: 12px;">
			<tr>
				<td class="rightAligned">Total</td>
				<td class=""><input type="text" id="txtTotPaidAmt" style="width: 120px; text-align: right;" readonly="readonly"></td>
		 	</tr>
		</table>
	</div>
</div>
<div class="sectionDiv">
	<!-- <div style="margin: 5px; margin-left: 90px; width: 650px; float: left; height: 120px;"> -->
	<div style="margin: 0px; margin-bottom: 30px; float: right; width: 95%; padding: 10px 0 0 10px;">
	<table align="left">
		<tr>
			<td class="rightAligned">Claim Number</td>
			<td class="leftAligned"><input type="text" id="txtClaimNo" name="txtClaimNo" value="" readonly="readonly" style="width: 300px;"></td>
			<td class="rightAligned">Assured Name</td>
			<td class="leftAligned"><input type="text" id="txtAssuredName" name="txtAssuredName" value="" readonly="readonly" style="width: 300px;"></td>			
		</tr>
		<tr>
			<td class="rightAligned">Policy No.</td>
			<td class="leftAligned"><input type="text" id="txtPolicyNo" name="txtPolicyNo" value="" readonly="readonly" style="width: 300px;"></td>
			<td class="rightAligned">Loss Date</td>
			<td class="leftAligned"><input type="text" id="txtLossDate" name="txtLossDate" value="" readonly="readonly" style="width: 300px;"></td>			
		</tr>	
		<tr>
			<td class="rightAligned">Claim Status</td>
			<td class="leftAligned"><input type="text" id="txtClaimStatus" name="txtClaimStatus" value="" readonly="readonly" style="width: 300px;"></td>
			<td class="rightAligned">File Date</td>
			<td class="leftAligned"><input type="text" id="txtFileDate" name="txtFileDate" value="" readonly="readonly" style="width: 300px;"></td>			
		</tr>	
		<tr>
			<td class="rightAligned">Loss Description</td>
 			<td class="leftAligned" colspan = "3"><input type="text" id="txtLossDesc" name="txtLossDesc" value="" readonly="readonly" style="width: 705px;"></td>
		</tr>
		<tr>
			<td colspan="4" align="center"><input type="button" class="button" id="btnPrintReport" name="btnPrintReport" value= "Print Report" style="margin: 10px 0 10px 0;"/></td>
		</tr>				
	</table>
	</div>
</div>

<script type="text/javascript">
try{
	var executeQuery = false;
	var jsonClmListPerAdjuster = JSON.parse('${jsonClmListPerAdjuster}');	
	perAdjusterTableModel = {
			url : contextPath+"/GICLClaimListingInquiryController?action=showClmListingPerAdjuster&refresh=1",
			options: {
				toolbar: {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter : function(){
						setDetailsForm(null);
						tbgClaimsPerAdjuster.keys.removeFocus(tbgClaimsPerAdjuster.keys._nCurrentFocus, true);
						tbgClaimsPerAdjuster.keys.releaseKeys();
					}
				},
				width: '900px',
				height: '335px',
				pager: {
				},
				onCellFocus : function(element, value, x, y, id) {
					setDetailsForm(tbgClaimsPerAdjuster.geniisysRows[y]);					
					tbgClaimsPerAdjuster.keys.removeFocus(tbgClaimsPerAdjuster.keys._nCurrentFocus, true);
					tbgClaimsPerAdjuster.keys.releaseKeys();
				},
				prePager: function(){
					setDetailsForm(null);
					tbgClaimsPerAdjuster.keys.removeFocus(tbgClaimsPerAdjuster.keys._nCurrentFocus, true);
					tbgClaimsPerAdjuster.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id){					
					setDetailsForm(null);
				},
				onSort : function(){
					setDetailsForm(null);
					tbgClaimsPerAdjuster.keys.removeFocus(tbgClaimsPerAdjuster.keys._nCurrentFocus, true);
					tbgClaimsPerAdjuster.keys.releaseKeys();	
				},
				onRefresh : function(){
					setDetailsForm(null);
					tbgClaimsPerAdjuster.keys.removeFocus(tbgClaimsPerAdjuster.keys._nCurrentFocus, true);
					tbgClaimsPerAdjuster.keys.releaseKeys();
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
					id : "payeeName",
					title: "Private Adjuster",
					width: '300px',
					filterOption : true,
					align : 'left',
					titleAlign : 'center'
				},				
				{
					id : "assignDate",
					title: "Date Assigned",
					width: '115px',
					align : 'center',
					titleAlign : 'center',
					filterOption : true,
					filterOptionType : 'formattedDate',
 					renderer: function (value){
						var dateTemp;
						if(value=="" || value==null){
							dateTemp = "";
						}else{
							dateTemp = dateFormat(value,"mm-dd-yyyy");
						}
						value = dateTemp;
						return value;
					} 
				},				
				{
					id : "completeDate",
					title: "Date Completed",
					width: '115px',
					filterOption : true,
					align : 'center',
					titleAlign : 'center',
					filterOptionType : 'formattedDate',
 					renderer: function (value){
						var dateTemp;
						if(value=="" || value==null){
							dateTemp = "";
						}else{
							dateTemp = dateFormat(value,"mm-dd-yyyy");
						}
						value = dateTemp;
						return value;
					} 
				},				
				{
					id : "cancelDate",
					title: "Date Cancelled",
					width: '110px',
					filterOption : true,
					align : 'center',
					titleAlign : 'center',
					filterOptionType : 'formattedDate',
 					renderer: function (value){
						var dateTemp;
						if(value=="" || value==null){
							dateTemp = "";
						}else{
							dateTemp = dateFormat(value,"mm-dd-yyyy");
						}
						value = dateTemp;
						return value;
					} 
				},				
				{
					id: "dPO",
					altTitle: "No. of Days Processed/Outstanding",
					title: "#D P/O",
					width: '115px',
					filterOption: true,
					filterOptionType: 'integerNoNegative',
					align: 'right',
					titleAlign: 'center'
				},				
				{
					id : "paidAmount",
					title: "Paid Amount",
					width: '125px',
					filterOption : true,
					align : 'right',
					titleAlign : 'center',
					filterOptionType: 'number',
					geniisysClass: 'money'
				}
				
			],
			rows: jsonClmListPerAdjuster.rows
		};
	
	
	tbgClaimsPerAdjuster = new MyTableGrid(perAdjusterTableModel);
	tbgClaimsPerAdjuster.pager = jsonClmListPerAdjuster;
	tbgClaimsPerAdjuster.render('perAdjusterTable');
	tbgClaimsPerAdjuster.afterRender = function(){
		if(tbgClaimsPerAdjuster.geniisysRows.length > 0){
			var totPaidAmt  = 0;
			for (var i = 0; i < tbgClaimsPerAdjuster.geniisysRows.length; i++) {
				totPaidAmt 	= totPaidAmt  + parseFloat(tbgClaimsPerAdjuster.geniisysRows[i].paidAmount);
			}
			$("txtTotPaidAmt").value  = formatCurrency(nvl(totPaidAmt, "0"));
		} else {
			$("txtTotPaidAmt").value = "";
		}
	};
	
	function setDetailsForm(rec){
		try{
			$("txtClaimNo").value 		= rec == null ? "" : rec.claimNumber;
			$("txtAssuredName").value 	= rec == null ? "" : unescapeHTML2(rec.assuredName);
			$("txtPolicyNo").value 		= rec == null ? "" : rec.policyNumber;
			$("txtLossDate").value 		= rec == null ? "" : dateFormat(rec.lossDate, "mm-dd-yyyy");
			$("txtClaimStatus").value 	= rec == null ? "" : unescapeHTML2(rec.claimStatus);
			$("txtFileDate").value 		= rec == null ? "" : dateFormat(rec.fileDate, "mm-dd-yyyy");
			$("txtLossDesc").value 		= rec == null ? "" : unescapeHTML2(rec.lossDesc);
				
		} catch(e){
			showErrorMessage("setDetailsForm", e);
		}
	}
	var resp = "";
	function validatePayeePerAdjuster() {
		new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
			method: "POST",
			parameters: {
				action : "validatePayeePerAdjuster",
				payee : $F("txtAdjuster")
			},
			asynchronous : false,
			evalScripts: true,
			onComplete: function(response) {
				resp = response.responseText;
				if (response.responseText == '0') {
// 					customShowMessageBox("There is no record of this payee in GIIS_PAYEES.", imgMessage.INFO, "txtAdjuster");
// 					$("txtAdjuster").value = "";
					showGICLS257AdjusterLOV($F("txtAdjuster"));
					enableToolbarButton("btnToolbarEnterQuery");
				}else if (response.responseText == '1') {
					showGICLS257AdjusterLOV($F("txtAdjuster"));
				}else if (response.responseText.include("Sql Exception")) {
					showGICLS257AdjusterLOV($F("txtAdjuster"));
				}
			}
		});
	}
	
	function showGICLS257AdjusterLOV(adjuster){
		LOV.show({
			controller : "ClaimsLOVController",
			urlParameters : {
				action : "getPayeesByAdjLOV",
				desc : adjuster, 
				page : 1
			},
			title : "List of Adjuster",
			width : 480,
			height : 400,
			columnModel : [ {
				id : "id",
				title : "Payee No",
				width : '120px',
			}, {
				id : "desc",
				title : "Payee Name",
				width : '320px'
			} ],
			draggable : true,
			autoSelectOneRecord : true,
			filterText : adjuster,
			onSelect : function(row) {
				$("txtAdjuster").value = unescapeHTML2(row.desc);
				$("hidPayeeNo").value = row.id;
				enableToolbarButton("btnToolbarExecuteQuery");
				enableToolbarButton("btnToolbarEnterQuery");
			}
		});
	}
	
	function setFormOnSelect() {
		if (validateDateFields()) {
			getPerAdjusterParams();
			$("txtNbtAsOfDate").disabled = true;
			$("txtNbtFromDate").disabled = true;
			$("txtNbtToDate").disabled = true;
			$("rdoDateBtn1").disabled = true;
			$("rdoDateBtn2").disabled = true;
			disableInputField("txtAdjuster");
			disableSearch("imgSearchAdjuster");
			disableDate("hrefNbtAsOfDate");
			disableDate("hrefNbtFromDate");
			disableDate("hrefNbtToDate");
			disableToolbarButton("btnToolbarExecuteQuery");
			enableToolbarButton("btnToolbarPrint");
			enableButton("btnPrintReport");
	 		if (tbgClaimsPerAdjuster.geniisysRows.length == 0) {
				customShowMessageBox("Query caused no records to be retrieved. Re-enter.", imgMessage.INFO, "txtAdjuster");
				disableButton("btnPrintReport");
				disableToolbarButton("btnToolbarPrint");
				$("txtNbtAsOfDate").disabled = true;
				$("txtNbtFromDate").disabled = true;
				$("txtNbtToDate").disabled = true;
				$("rdoDateBtn1").disabled = true;
				$("rdoDateBtn2").disabled = true;
				$("rdoSearchBy1").disabled = true;
				$("rdoSearchBy2").disabled = true;
				$("rdoSearchBy3").disabled = true;
				$("rdoCompleted").disabled = true;
				$("rdoCancelled").disabled = true;
				$("rdoAllAdjuster").disabled = true;
				$("rdoOutstanding").disabled = true;
			}
		}
	}
	
	//Get Parameters
	function getPerAdjusterParams(){
		//get Date
		$$("input[name='rdoNbtDateType']").each(function(btn){
			if (btn.checked){
				payeeNo = $F("hidPayeeNo");
				searchBy = $F(btn);
				dateAsOf = $F("txtNbtAsOfDate");
				dateFrom = $F("txtNbtFromDate");
				dateTo = $F("txtNbtToDate");
			}			
		});
		//get Status
		$$("input[name='rdoStatus']").each(function(btn){
			if (btn.checked){
				status = $F(btn);
			}			
		});
		if($("txtAdjuster").value != "" && executeQuery){
			refreshTbgClmListPerAdjuster(payeeNo, searchBy, dateAsOf, dateFrom, dateTo,  status);
		}
	}
	
	//Populate tbgClaimsPerAdjuster
	function refreshTbgClmListPerAdjuster(payeeNo, searchBy, dateAsOf, dateFrom, dateTo, status){
		tbgClaimsPerAdjuster.url = contextPath+"/GICLClaimListingInquiryController?action=showClmListingPerAdjuster&refresh=1&id="+payeeNo+"&searchBy="+searchBy+"&dateAsOf="+dateAsOf+"&dateFrom="+dateFrom+"&dateTo="+dateTo+"&status="+status;
		tbgClaimsPerAdjuster._refreshList();
	}	
	
	//Search By Radio Event
 	$$("input[name='rdoNbtDateType']").each(function(btn){
		btn.observe("click", function(){
			try{
				if($("txtAdjuster").value != ""){
					getPerAdjusterParams();	
				}
			}catch(e){
				showErrorMessage("rdoNbtDateType", e);
			}						
		});	
	});
	
 	$$("input[name='rdoStatus']").each(function(btn){
		btn.observe("click", function(){
			try{
				if($("txtAdjuster").value != ""){
					getPerAdjusterParams();	
				}	
			}catch(e){
				showErrorMessage("rdoStatus", e);
			}						
		});	
	});
	
	//Enable or Disable details in Date
	function enableFromToDate(enable){
		if (nvl(enable,false) == true){
			//enable
			$("txtNbtAsOfDate").value 		= "";
			$("txtNbtAsOfDate").disabled 	= true;
			$("txtNbtFromDate").disabled 	= false;
			$("txtNbtToDate").disabled 		= false;
			disableDate("hrefNbtAsOfDate");
			enableDate("hrefNbtFromDate");
			enableDate("hrefNbtToDate");
			$("txtNbtFromDate").setStyle({backgroundColor: '#FFFACD'});
			$("fromDiv").setStyle({backgroundColor: '#FFFACD'});
			$("txtNbtToDate").setStyle({backgroundColor: '#FFFACD'});
			$("toDiv").setStyle({backgroundColor: '#FFFACD'});
			$("txtNbtAsOfDate").setStyle({backgroundColor: '#F0F0F0'});
			$("asOfDiv").setStyle({backgroundColor: '#F0F0F0'});
		}else{	
			//disable
			$("txtNbtAsOfDate").value 		= getCurrentDate();
			$("txtNbtAsOfDate").disabled 	= false;
			$("txtNbtFromDate").value 		= "";
			$("txtNbtToDate").value 		= "";
			$("txtNbtFromDate").disabled 	= true;
			$("txtNbtToDate").disabled 		= true;
			enableDate("hrefNbtAsOfDate");
			disableDate("hrefNbtFromDate");
			disableDate("hrefNbtToDate");
			$("txtNbtFromDate").setStyle({backgroundColor: '#F0F0F0'});
			$("fromDiv").setStyle({backgroundColor: '#F0F0F0'});
			$("txtNbtToDate").setStyle({backgroundColor: '#F0F0F0'});
			$("toDiv").setStyle({backgroundColor: '#F0F0F0'});
			$("txtNbtAsOfDate").setStyle({backgroundColor: 'white'});
			$("asOfDiv").setStyle({backgroundColor: 'white'});			
		}
	}	
		
	//Initialize GICL257
	function initGICL257(){
		$("rdoSearchBy1").checked 	= true; 
		$("rdoDateBtn1").checked 	= true; 
		enableFromToDate(false);
		disableButton("btnPrintReport");
		disableToolbarButton("btnToolbarPrint");
		disableToolbarButton("btnToolbarExecuteQuery");
		disableToolbarButton("btnToolbarEnterQuery");
	}
	
	function validateDateFields() {
		if ($("rdoDateBtn2").checked == true) {
			if ($("txtNbtFromDate").value == "") {
				customShowMessageBox("Pls. enter FROM date.", imgMessage.INFO, "txtNbtFromDate");
				return false;
			}
			if ($("txtNbtToDate").value == "") {
				customShowMessageBox("Pls. enter TO date.", imgMessage.INFO, "txtNbtToDate");
				return false;
			}
		}
		executeQuery = true;
		return true;
	}
	
	$("txtAdjuster").observe("change", function() {
		if ($F("txtAdjuster") != null) {
			validatePayeePerAdjuster();
		}
	});
	
	//As Of Radio Button Event
	$("rdoDateBtn1").observe("click", function(a){
		enableFromToDate(false);
	});
	
	//From Radio Button Event
	$("rdoDateBtn2").observe("click", function(a){
		enableFromToDate(true);
	});
	
	//As of Date ICON CLICK event
	$("hrefNbtAsOfDate").observe("click", function(){
		if ($("hrefNbtAsOfDate").disabled == true) return;
		scwShow($('txtNbtAsOfDate'),this, null);
	});
	
	//As of Date validate event
	$("txtNbtAsOfDate").observe("focus", function(){
		if ($("hrefNbtAsOfDate").disabled == true) return;
		var asOfDate = $F("txtNbtAsOfDate") != "" ? new Date($F("txtNbtAsOfDate").replace(/-/g,"/")) :"";
		var sysdate = new Date();
		if (asOfDate > sysdate && asOfDate != ""){
			customShowMessageBox("Date should not be greater than the current date.", "I", "txtNbtAsOfDate");
			$("txtNbtAsOfDate").clear();
			return false;
		}
		getPerAdjusterParams();
	});
	
	//From Date ICON CLICK event
	$("hrefNbtFromDate").observe("click", function(){
		if ($("hrefNbtFromDate").disabled == true) return;
		scwShow($('txtNbtFromDate'),this, null);
	});
	
	//From Date validate event
	$("txtNbtFromDate").observe("focus", function(){
		if ($("hrefNbtFromDate").disabled == true) return;
		var toDate = $F("txtNbtToDate") != "" ? new Date($F("txtNbtToDate").replace(/-/g,"/")) :"";
		var fromDate = $F("txtNbtFromDate") != "" ? new Date($F("txtNbtFromDate").replace(/-/g,"/")) :"";
		var sysdate = new Date();
		if (fromDate > sysdate && fromDate != ""){
			customShowMessageBox("Date should not be greater than the current date.", "I", "txtNbtAsOfDate");
			$("txtNbtFromDate").clear();
			return false;
		}
		if (fromDate > toDate && toDate != ""){
			customShowMessageBox("From Date should not be later than To Date.", "I", "txtNbtFromDate");
			$("txtNbtFromDate").clear();
			return false;
		}
		if (($F("txtNbtToDate") != "") && ($F("txtNbtFromDate") != "")){
			getPerAdjusterParams();
		}		
	});
	
	//To Date ICON CLICK event
	$("hrefNbtToDate").observe("click", function(){
		if ($("hrefNbtToDate").disabled == true) return;
		scwShow($('txtNbtToDate'),this, null);
	});
	
	//To Date validate event
	$("txtNbtToDate").observe("focus", function(){
		if ($("hrefNbtToDate").disabled == true) return;
		var toDate = $F("txtNbtToDate") != "" ? new Date($F("txtNbtToDate").replace(/-/g,"/")) :"";
		var fromDate = $F("txtNbtFromDate") != "" ? new Date($F("txtNbtFromDate").replace(/-/g,"/")) :"";
		var sysdate = new Date();
		if (toDate > sysdate && toDate != ""){
			customShowMessageBox("Date should not be greater than the current date.", "I", "txtNbtToDate");
			$("txtNbtToDate").clear();
			return false;
		}
		if (toDate < fromDate && toDate != ""){
			customShowMessageBox("From Date should not be later than To Date.", "I", "txtNbtToDate");
			$("txtNbtToDate").clear();
			return false;
		}
 		if (($F("txtNbtToDate") != "") && ($F("txtNbtFromDate") != "")){
			getPerAdjusterParams();
		} 	
	});
	
	//Observe delete on DATE field
	observeBackSpaceOnDate("txtNbtAsOfDate");
	observeBackSpaceOnDate("txtNbtFromDate");
	observeBackSpaceOnDate("txtNbtToDate");
	
	//toolbar execute query
	$("btnToolbarExecuteQuery").observe("click", function() {
		setFormOnSelect();
	});
	
	$("imgSearchAdjuster").observe("click", function() {
		var adj = "";
		if ($F("txtAdjuster") != "") {
			if (resp == "0") {
				showGICLS257AdjusterLOV($F("txtAdjuster"));
			}else {
				showGICLS257AdjusterLOV("");
			}
		}else {
			showGICLS257AdjusterLOV($F("txtAdjuster"));
		}
			
	});
	
	function getPrintParams(){
		var params = "";
		var searchBy;
		var status;
		var payeeNo;
		$$("input[name='rdoNbtDateType']").each(function(btn){
			if (btn.checked){
				searchBy = $F(btn);
			}			
		});
		$$("input[name='rdoStatus']").each(function(btn){
			if (btn.checked){
				status = $F(btn);
			}			
		});
		if ($("outstandingAllAdjusters").checked || $("pendingAllAdjusters").checked) {
			payeeNo = "";
		}else  {
			payeeNo = $F("hidPayeeNo");
		}
		params = "&payeeNo="+payeeNo+"&payeeNoA="+$F("hidPayeeNo")+"&searchBy="+searchBy+"&dateAsOf="+$F("txtNbtAsOfDate")+"&dateFrom="+$F("txtNbtFromDate")+"&dateTo="+$F("txtNbtToDate")+"&status="+status;
		return params;
	}
	
	//toolbar print
	$("btnToolbarPrint").observe("click", function(){
		showGenericPrintDialog("Print Claim Listing per Adjuster", checkReport, loadPrintGiclr257, true);
	});
	
	//button print
	$("btnPrintReport").observe("click", function(){
		showGenericPrintDialog("Print Claim Listing per Adjuster", checkReport, loadPrintGiclr257, true);
	});
	
	var reports = [];
	function checkReport(){
		if(!($("clmListingPerAdjuster").checked) && !($("outstandingAdjusterAssignments").checked) && !($("listOfPendingCases").checked)){
			showMessageBox("Please select the type of report you want to print.", "I");
			return false;
		}
		var report = [];
		if($("clmListingPerAdjuster").checked){
			report.push({reportId : "GICLR257", reportTitle : "Claim Listing per Adjuster"});
		}
		if($("outstandingAdjusterAssignments").checked){
			report.push({reportId : "GICLR257A", reportTitle : "Outstanding Adjuster Assignments"});
		}
		if($("listOfPendingCases").checked){
			report.push({reportId : "GICLR257B", reportTitle : "List of Pending Cases"});
		}
		for(var i=0; i < report.length; i++){
			doPrint(report[i].reportId, report[i].reportTitle);	
		}
		if ("screen" == $F("selDestination")) {
			showMultiPdfReport(reports);
			reports = [];
		}
	}
	
	function doPrint(reportId, reportTitle){
		var content;
		content = contextPath+"/PrintClaimListingInquiryController?action=printReport&reportId="+reportId+"&printerName="+$F("selPrinter")+getPrintParams();
		if($F("selDestination") == "screen"){
			reports.push({reportUrl : content, reportTitle : reportTitle});			
		}else if($F("selDestination") == "printer"){
			new Ajax.Request(content, {
				method: "GET",
				parameters : {noOfCopies : $F("txtNoOfCopies"),
						 	 printerName : $F("selPrinter")
						 	 },
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if (checkErrorOnResponse(response)){
					
					}
				}
			});
		}else if($F("selDestination") == "file"){
			new Ajax.Request(content, {
				method: "POST",
				parameters : {destination : "file",
							  fileType    : $("rdoPdf").checked ? "PDF" : "XLS"},
				evalScripts: true,
				asynchronous: true,
				onCreate: showNotice("Generating report, please wait..."),
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						copyFileToLocal(response);
					}
				}
			});
		}else if("local" == $F("selDestination")){
			new Ajax.Request(content, {
				method: "POST",
				parameters : {destination : "local"},
				evalScripts: true,
				asynchronous: true,
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
	}
	
	function loadPrintGiclr257(){
		try{ 
			var content = "<table border='0' style='margin: auto; margin-top: 10px; margin-bottom: 10px;'><tr><td><input type='checkbox' id='clmListingPerAdjuster' name='clmListingPerAdjuster' style='float: left; margin-bottom: 3px;'><label style='margin-top: 2px; margin-right: 20px;' for='clmListingPerAdjuster'>Claim Listing Per Adjuster</label></td></tr>"+
						  "<tr><td><input type='checkbox' id='outstandingAdjusterAssignments' name='outstandingAdjusterAssignments' style='float: left; padding-bottom: 3px; margin-bottom: 3px;'><label for='outstandingAdjusterAssignments'>Outstanding Adjuster Assignments</label></td></tr>"+
						  "<tr><td><input type='checkbox' id='outstandingAllAdjusters' name='outstandingAllAdjusters' style='float: left; padding-bottom: 3px; margin-left: 50px; margin-bottom: 3px;'><label for='outstandingAllAdjusters'>All Adjusters</label></td></tr>"+
						  "<tr><td><input type='checkbox' id='listOfPendingCases' name='listOfPendingCases' style='float: left; padding-bottom: 3px; margin-bottom: 3px;'><label for='listOfPendingCases'>List of Pending Cases</label></td></tr>"+
						  "<tr><td><input type='checkbox' id='pendingAllAdjusters' name='pendingAllAdjusters' style='float: left; padding-bottom: 3px; margin-left: 50px; margin-bottom: 3px;'><label for='pendingAllAdjusters'>All Adjusters</label></td></tr>";
			$("printDialogFormDiv2").update(content); 
			$("printDialogFormDiv2").show();
			$("printDialogMainDiv").up("div",1).style.height = "295px";
			$($("printDialogMainDiv").up("div",1).id).up("div",0).style.height = "327px";
			
			$("clmListingPerAdjuster").checked = true;
			$("outstandingAllAdjusters").disabled = true;
			$("pendingAllAdjusters").disabled = true;
			
			$("outstandingAdjusterAssignments").observe("click", function(){
				if($("outstandingAdjusterAssignments").checked){
					$("outstandingAllAdjusters").disabled = false;
				}else{
					$("outstandingAllAdjusters").disabled = true;
					$("outstandingAllAdjusters").checked = false;
				}	
			});
			
			$("listOfPendingCases").observe("click", function(){
				if($("listOfPendingCases").checked){
					$("pendingAllAdjusters").disabled = false;
				}else{
					$("pendingAllAdjusters").disabled = true;
					$("pendingAllAdjusters").checked = false;
				}	
			});
			
			$("selPrinter").removeClassName("required");
			$("txtNoOfCopies").removeClassName("required");
			$("selDestination").observe("change", function(){
				if($F("selDestination") != "printer"){
					$("selPrinter").removeClassName("required");
					$("txtNoOfCopies").removeClassName("required");
				}else{
					$("selPrinter").addClassName("required");
					$("txtNoOfCopies").addClassName("required");
				}
			});
		}catch(e){
			showErrorMessage("loadPrintGiclr268", e);	
		}
	}
	
// 	//menu exit
// 	$("clmListingPerAdjusterExit").observe("click", function(){
// 		goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
// 	});
	
	//toolbar exit
	$("btnToolbarExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
	});

	//toolbar query
	$("btnToolbarEnterQuery").observe("click", function(){
		new Ajax.Request(contextPath + "/GICLClaimListingInquiryController", {
		    parameters : {action : "showClmListingPerAdjuster"},
		    onCreate : showNotice("Loading, please wait..."),
			onComplete : function(response){
				hideNotice();
				try {
					if(checkErrorOnResponse(response)){
						enableSearch("imgSearchAdjuster");
						executeQuery = false;
						$("dynamicDiv").update(response.responseText);
					}
				} catch(e){
					showErrorMessage("showClmListingPerAdjuster - onComplete : ", e);
				}								
			} 
		});
	});
	
 	setModuleId("GICLS257");
	setDocumentTitle("Claim Listing per Adjuster");
	initializeAll();
	initGICL257();
		
} catch (e){
	showErrorMessage("Claim Listing Per Adjuster Error: ", e);
}		
</script>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="redistParamMainDiv" name="redistParamMainDiv" style="margin-top: 1px;">
	<div id="redistParamDiv" name="redistParamDiv" class="sectionDiv" style="width: 98%; margin-left: 4px; margin-top: 10px; height: 165px;">
		<table align="center" style="padding: 10px; width: 100%;">
			<tr>
				<td style="width: 45px; padding-left: 60px;">
					<input type="radio" id="rdoByClaimFileDate" name="dateOption" value="Claim File Date" style="margin-left: 15px; float: left;" checked="checked"/>
					<label for="rdoByClaimFileDate" style="margin-top: 3px;">Claim File Date</label>
				</td>
				<td style="width: 100px;">
					<input type="radio" id="rdoByLossDate" name="dateOption" value="Loss Date" style="margin-left: 15px; float: left; margin-left: 50px;"/>
					<label for="rdoByLossDate" style="margin-top: 3px;">Loss Date</label>
				</td>
			</tr>
		</table>
		<table align="center" style="padding: 5px; width: 100%;">
			<tr>
				<td class="rightAligned" width="55px">From</td>
				<td style="padding-left: 2px;">
					<div style="float: left; width: 160px;" class="withIconDiv">
						<input type="text" id="txtFromDate" name="txtFromDate" class="withIcon" readonly="readonly" tabindex="1" style="width: 135px;"/>
						<img id="imgFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date"/>
					</div>
				</td>
				<td class="rightAligned" width="20px">To</td>
				<td style="padding-left: 2px;">
					<div style="float: left; width: 160px;" class="withIconDiv">
						<input type="text" id="txtToDate" name="txtToDate" class="withIcon" readonly="readonly" tabindex="2" style="width: 135px;"/>
						<img id="imgToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Date"/>
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" width="70px">Subline Code</td>
				<td colspan="3" style="padding-left: 2px;">
					<span class="lovSpan" style="width:66px; height: 21px; margin: 2px 4px 0 0; float: left;">
						<input  class="rightAligned" type="text" id="txtSublineCd" name="txtSublineCd" tabindex="3" style="width: 36px; float: left; margin-right: 4px; border: none; height: 13px; text-align: left;" tabindex="9" maxlength="7"/>	
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchSublineCd" name="imgSearchSublineCd" alt="Go" style="float: right;"/>
					</span>
					<span class="lovSpan" style="width:299.5px; height: 21px; margin: 2px 4px 0 0; float: left;">
						<input  class="leftAligned" type="text" id="txtSublineName" name="txtSublineName"  value="" readonly="readonly" tabindex="4" style="width: 290px; float: left; margin-right: 4px; border: none; height: 13px;" tabindex="10"/>	
					</span>								
				</td>
			</tr>
			<tr>
				<td class="rightAligned" width="76px">Branch Code</td>
				<td colspan="3" style="padding-left: 2px;">
					<span class="lovSpan" style="width:66px; height: 21px; margin: 2px 4px 0 0; float: left;">
						<input  class="rightAligned" type="text" id="txtBranchCd" name="txtBranchCd" tabindex="5" style="width: 36px; float: left; margin-right: 4px; border: none; height: 13px; text-align: left;" tabindex="9" maxlength="2"/>	
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchBranchCd" name="imgSearchBranchCd" alt="Go" style="float: right;"/>
					</span>
					<span class="lovSpan" style="width:299.5px; height: 21px; margin: 2px 4px 0 0; float: left;">
						<input  class="leftAligned" type="text" id="txtBranchName" name="txtBranchName"  value="" readonly="readonly" tabindex="6" style="width: 290px; float: left; margin-right: 4px; border: none; height: 13px;" tabindex="10"/>	
					</span>								
				</td>
			</tr>
			<tr>
				<td class="rightAligned" width="76px">Reserve</td>
				<td style="padding-left: 2px;" width="76px" colspan="3">
					<div id="optionReserveDiv" style="float: left; width: 68px; height: 21px; margin: 2px 4px 0 0;">
						<select style="width: 68px;" id="operand" name="operand" class="mandatoryEnchancement" tabindex="7">
							<option></option>
							<option value="=">=</option>
							<option value="<="><=</option>
							<option value=">=">>=</option>
						</select>
					</div>
					<input type="text" id="txtAmount" name="txtAmount" tabindex="8" style="float: left; width: 294px; height: 13px;" class="money2"/>
				</td>
			</tr>
		</table>
	</div>
	<div class="buttonDiv" style="float: left; width: 98%; padding-bottom: 5px; padding-top: 10px; margin-left: 4px;"> 
		<table align="center">
			<tbody>
				<tr>
					<td>
						<input id="btnInspection" class="button noChangeTagAttr" type="button" style="display: none; value="Select Inspection" name="btnInspection">
					</td>
					<td>
						<input id="btnOk" name="btnOk" class="button" type="button" style="width: 120px;" value="Ok">
					</td>
					<td>
						<input id="btnCancel" name="btnCancel" class="button" type="button" style="width: 120px;" value="Cancel">
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	<input type="hidden" id="hidLineCd" name="hidLineCd" value="${lineCd}"/>
	<input type="hidden" id="hidCurrentView" name="hidCurrentView" value="${currentView}"/>
</div>
<script type="text/javascript">

	/* $("imgSearchSublineCd").observe("click", function(){
		getGICLS038SublineCd();
	});
	
	$("txtSublineCd").observe("blur", function(){
		if($F("txtSublineCd") != ""){
			getGICLS038SublineCd();	
		}
	}); */
	
	$("txtSublineCd").observe("keyup", function(){
		$("txtSublineCd").value = $F("txtSublineCd").toUpperCase();
	});
	$("txtSublineCd").setAttribute("lastValidValue", "");
	$("imgSearchSublineCd").observe("click", getGICLS038SublineCd);
	$("txtSublineCd").observe("change", function() {		
		if($F("txtSublineCd").trim() == "") {
			$("txtSublineCd").value = "";
			$("txtSublineCd").setAttribute("lastValidValue", "");
			$("txtSublineName").value = "";
		} else {
			if($F("txtSublineCd").trim() != "" && $F("txtSublineCd") != $("txtSublineCd").readAttribute("lastValidValue")) {
				getGICLS038SublineCd();
			}
		}
	});
	
	/* $("imgSearchBranchCd").observe("click", function(){
		getGICLS038BranchCd();
	});
	
	$("txtBranchCd").observe("blur", function(){
		if($F("txtBranchCd") != ""){
			getGICLS038BranchCd();	
		}
	}); */
	
	$("txtBranchCd").observe("keyup", function(){
		$("txtBranchCd").value = $F("txtBranchCd").toUpperCase();
	});
	$("txtBranchCd").setAttribute("lastValidValue", "");
	$("imgSearchBranchCd").observe("click", getGICLS038BranchCd);
	$("txtBranchCd").observe("change", function() {		
		if($F("txtBranchCd").trim() == "") {
			$("txtBranchCd").value = "";
			$("txtBranchCd").setAttribute("lastValidValue", "");
			$("txtBranchName").value = "";
		} else {
			if($F("txtBranchCd").trim() != "" && $F("txtBranchCd") != $("txtBranchCd").readAttribute("lastValidValue")) {
				getGICLS038BranchCd();
			}
		}
	});
	
	function getGICLS038SublineCd(){
		/* LOV.show({
			controller: 'UnderwritingLOVController',
			urlParameters: {
				action:		"getGICLS038SublineCd",
				sublineCd:  $F("txtSublineCd"),
				lineCd:     $F("hidLineCd")
			},
			title: "Valid Values for Subline",
			width: 405,
			height: 386,
			draggable: true,
			columnModel: [
				{
					id: "sublineCd",
					title: "Subline Code",
					width: "100px"
				},
				{
					id: "sublineName",
					title: "Subline Name",
					width: "290px"
				}
			],
			onSelect: function(row){
				if(row != undefined){
					$("txtSublineCd").value = row.sublineCd;
					$("txtSublineName").value = row.sublineName;
				}
			}
		}); */
		
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getGICLS038SublineCd",
							sublineCd:  $F("txtSublineCd"),
							lineCd:     $F("hidLineCd"),
							filterText : ($("txtSublineCd").readAttribute("lastValidValue").trim() != $F("txtSublineCd").trim() ? $F("txtSublineCd").trim() : ""),
							page : 1},
			title: "List of Sublines",
			width: 500,
			height: 400,
			columnModel : [
							{
								id : "sublineCd",
								title: "Subline Code",
								width: "100px",
								filterOption: true
							},
							{
								id : "sublineName",
								title: "Subline Name",
								width: '325px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("txtSublineCd").readAttribute("lastValidValue").trim() != $F("txtSublineCd").trim() ? $F("txtSublineCd").trim() : ""),
				onSelect: function(row) {
					$("txtSublineCd").value = row.sublineCd;
					$("txtSublineName").value = row.sublineName;
					$("txtSublineCd").setAttribute("lastValidValue", row.sublineCd);								
				},
				onCancel: function (){
					$("txtSublineCd").value = $("txtSublineCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtSublineCd").value = $("txtSublineCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	function getGICLS038BranchCd(){
		/* LOV.show({
			controller: 'UnderwritingLOVController',
			urlParameters: {
				action:		"getGICLS038BranchCd",
				branchCd:   $F("txtBranchCd")
			},
			title: "Valid Values for Branches",
			width: 405,
			height: 386,
			draggable: true,
			columnModel: [
				{
					id: "issCd",
					title: "Branch Code",
					width: "100px"
				},
				{
					id: "issName",
					title: "Branch Name",
					width: "290px"
				}
			],
			onSelect: function(row){
				if(row != undefined){
					$("txtBranchCd").value = row.issCd;
					$("txtBranchName").value = row.issName;
				}
			}
		}); */
		
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getGICLS038BranchCd",
				            lineCd:     $F("hidLineCd"),
							filterText : ($("txtBranchCd").readAttribute("lastValidValue").trim() != $F("txtBranchCd").trim() ? $F("txtBranchCd").trim() : ""),
							page : 1},
			title: "List of Branches",
			width: 500,
			height: 400,
			columnModel : [
							{
								id : "issCd",
								title: "Branch Code",
								width: "100px",
								filterOption: true
							},
							{
								id : "issName",
								title: "Branch Name",
								width: '325px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("txtBranchCd").readAttribute("lastValidValue").trim() != $F("txtBranchCd").trim() ? $F("txtBranchCd").trim() : ""),
				onSelect: function(row) {
					$("txtBranchCd").value = row.issCd;
					$("txtBranchName").value = row.issName;
					$("txtBranchCd").setAttribute("lastValidValue", row.issCd);								
				},
				onCancel: function (){
					$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}

	$("imgFromDate").observe("click", function(){
		scwShow($('txtFromDate'),this, null);
	});	

	$("imgToDate").observe("click", function(){
		scwShow($('txtToDate'),this, null);
	});
	
	/* $("txtFromDate").observe("blur", function(){
		if($F("txtFromDate") != "" && validateDateFormat($F("txtFromDate"), "txtFromDate")){
			if($F("txtToDate") != "" && validateDateFormat($F("txtToDate"), "txtToDate")){
				validateFromToDate("txtFromDate", "txtFromDate", "txtFromDate");
			}
		}
	});
	
	$("txtToDate").observe("blur", function(){
		if($F("txtToDate") != "" && validateDateFormat($F("txtToDate"), "txtToDate")){
			if($F("txtFromDate") != "" && validateDateFormat($F("txtFromDate"), "txtFromDate")){
				validateFromToDate("txtFromDate", "txtToDate", "txtToDate");
			}
		}
	}); */
	
	$("txtFromDate").observe("focus", function(){
		if ($("txtToDate").value != "" && this.value != "") {
			if (compareDatesIgnoreTime(Date.parse($F("txtFromDate")),Date.parse($("txtToDate").value)) == -1) {
				customShowMessageBox("From Date should not be later than To Date.","I","txtFromDate");
				this.clear();
			}
		}
	});
	
	$("txtToDate").observe("focus", function(){
		if ($("txtFromDate").value != ""&& this.value != "") {
			if (compareDatesIgnoreTime(Date.parse($F("txtFromDate")),Date.parse($("txtToDate").value)) == -1) {
				customShowMessageBox("From Date should not be later than To Date.","I","txtToDate");
				this.clear();
			}
		}
	});
	
	function validateFromToDate(elemNameFr, elemNameTo, currElemName){
		var isValid = true;		
		var elemDateFr = Date.parse($F(elemNameFr), "mm-dd-yyyy");
		var elemDateTo = Date.parse($F(elemNameTo), "mm-dd-yyyy");
		
		var output = compareDatesIgnoreTime(elemDateFr, elemDateTo);
		if(output < 0){
			if(currElemName == elemNameFr){
				showMessageBox("The date you entered is LATER THAN the TO DATE.", "E");
				$("txtToDate").value = "";
				$("txtFromDate").value = "";
			} else {
				showMessageBox("The date you entered is EARLIER THAN the FROM DATE.", "E");
				$("txtToDate").value = "";
				$("txtFromDate").value = "";
			}
			$(currElemName).focus();
			isValid = false;
		}
		return isValid;
	}
	
	function validateDateFormat(strValue, elemName){
		var text = strValue; 
		var comp = text.split('-');
		var m = parseInt(comp[0], 10);
		var d = parseInt(comp[1], 10);
		var y = parseInt(comp[2], 10);
		var status = true;
		var isMatch = text.match(/^(\d{1,2})-(\d{1,2})-(\d{4})$/);
		var date = new Date(y,m-1,d);
		
		if(isNaN(y) || isNaN(m) || isNaN(d) || y.toString().length < 4 || !isMatch ){
			customShowMessageBox("Date must be entered in a format like MM-DD-RRRR.", imgMessage.INFO, elemName);
			status = false;
		}
		if(0 >= m || 13 <= m){
			customShowMessageBox("Month must be between 1 and 12.", imgMessage.INFO, elemName);	
			status = false; 
		}
		if(date.getDate() != d){				
			customShowMessageBox("Day must be between 1 and the last of the month.", imgMessage.INFO, elemName);	
			status = false;
		}
		if(!status){
			$(elemName).value = "";
		}
		return status;
	}
	
	$("rdoByClaimFileDate").checked = true;
	$("txtFromDate").focus();
	
	$("btnOk").observe("click", function(){
		if(($F("txtFromDate") != "" && $F("txtToDate") != "") || $F("txtSublineCd") != "" || $F("txtBranchCd") != "" || $F("operand") != ""){
			var dateToday = ignoreDateTime(new Date());
			var fromDate;
			var toDate;
			var dateParam;
			var operand;
			var amt;
			
			if($F("operand") != ""){
				operand = $F("operand"); 
			} else {
				operand = "=";
			}
			
			if($F("txtAmount") != ""){
				amt = unformatCurrencyValue($F("txtAmount"));
			} else {
				if($F("hidCurrentView") == "R"){
					amt = "loss_reserve";	
				} else {
					amt = "paid_amt";
				}
			}
			
			if($F("txtFromDate") != ""){
				fromDate = $F("txtFromDate");
			} else {
				fromDate = "01-01-1800";
			}
			
			if($F("txtToDate") != ""){
				toDate = $F("txtToDate");
			} else {
				toDate = dateFormat(dateToday, "mm-dd-yyyy");
			}
			
			if($("rdoByClaimFileDate").checked){
				dateParam = "TRUNC(clm_file_date)";
			} else {
				dateParam = "TRUNC(loss_date)";
			}
			
			if($F("hidCurrentView") == "R"){
				reserveDtlsTableGrid.url = contextPath + "/GICLClaimReserveController?action=showCLMBatchRedistribution&refresh=1" 
				+ "&lineCd=" + $F("hidLineCd")
				+ "&currentView=" + $F("hidCurrentView")
				+ "&sublineCd=" + $F("txtSublineCd")
				+ "&issCd=" + $F("txtBranchCd")
				+ "&andAmount=" + "loss_reserve " + operand + " " + amt
				+ "&andDate=" + "(" + dateParam + " >= " + "TO_DATE(" + "'" + fromDate + "'" + ", 'MM-DD-RRRR')" + " AND " + dateParam + " <= " + "TO_DATE(" + "'" + toDate + "'" + ", 'MM-DD-RRRR')" + ")";
				
				reserveDtlsTableGrid._refreshList();	
			} else if($F("hidCurrentView") == "L"){
				lossExpenseDtlsTableGrid.url = contextPath + "/GICLClaimReserveController?action=showCLMBatchRedistribution&refresh=1" 
				+ "&lineCd=" + $F("hidLineCd")
				+ "&currentView=" + $F("hidCurrentView")
				+ "&sublineCd=" + $F("txtSublineCd")
				+ "&issCd=" + $F("txtBranchCd")
				+ "&andAmount=" + "paid_amt " + operand + " " + amt
				+ "&andDate=" + "(" + dateParam + " >= " + "TO_DATE(" + "'" + fromDate + "'" + ", 'MM-DD-RRRR')" + " AND " + dateParam + " <= " + "TO_DATE(" + "'" + toDate + "'" + ", 'MM-DD-RRRR')" + ")";
				
				lossExpenseDtlsTableGrid._refreshList();
			}
			
			$(rdoSelectedItems).checked = true;
		
			overlayRedistParam.close();
		} else {
			overlayRedistParam.close();
		}
	});	

	$("btnCancel").observe("click", function(){
		overlayRedistParam.close();
		delete overlayRedistParam;
	});
	
	initializeAll();
	initializeAllMoneyFields();
</script>
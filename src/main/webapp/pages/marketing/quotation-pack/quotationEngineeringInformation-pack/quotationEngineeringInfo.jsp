<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>	
	
<div id="quoteENInfoDiv" name="quoteENInfoDiv" class="quoteENInfo" style="margin-top: 10px;">
	<table align="center" style="width: 77.5%;">
		<tr>
			<td class="rightAligned" width="20%">Subline</td>
			<td class="leftAligned" colspan="3">
				<input type="hidden" id="sublineCdParam" name="sublineCdParam" />
				<input type="text" id="enSublineName" name="enSublineName" readonly="readonly" style="width: 90%;"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width="25%">Inception Date</td>
			<td class="leftAligned" width="25%">
				<input type="text" id="enInceptDate" name="enInceptDate" readonly="readonly"/>
			</td>
			<td class="rightAligned" width="20%">Expiry Date</td>
			<td class="leftAligned" width="30%">
				<input type="text" id="enExpiryDate" name="enExpiryDate" readonly="readonly"/>
			</td>
		</tr>
	</table>
	
	<table align="center" width="80%" style="margin-top: 30px; margin-left: 50px;">
		<tr>
			<td width="30%"><label class="rightAligned" id="titleLbl"  style="float: right;">Project</label></td>
			<td class="leftAligned" width="70%" colspan="3">
				<div style="width: 97%; border: 1px solid gray;">
					<input type="text" id="enProjectName" name="enProjectName" style="width: 93%; border: none;"/>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="EditTitle" id="editProjText"/>
			</div>
		</td>
	</tr>
	<tr>
		<td width="30%"><label class="rightAligned" id="siteLbl" style="float: right;">Site of Erection</label></td>
		<td class="leftAligned" width="70%" colspan="3">
			<div style="width: 97%; border: 1px solid gray;">
				<input type="text" id="enSiteLoc" name="enSiteLoc" style="width: 93%; border: none;"/>
				<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="EditSite" id="editSiteText"/>
			</div>
		</td>
	</tr>
	
	<tr>
		<td width="30%"><label class="rightAligned" id="weeksLbl" style="float: right; display: none;">Weeks Testing/ Commissioning</label></td>
		<td class="leftAligned" width="25%">
			<div id="constructFromSpan" style="width: 100%; display: none;" >
				<input type="text" id="constructFrom" name="constructFrom" style="width: 80%;" readonly="readonly"/>
				<img id="imgConstFrom" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="$('constructFrom').focus(); scwShow($('constructFrom'),this, null);" style="margin: 0;" />
			</div>
			<input type="text" id="weeksTesting" name="weeksTesting" maxlength="4" style="width: 30%; display: none;"/>
			<input type="text" id="mbiPolNo" name="mbiPolNo" style="width: 100%; display: none;" />
		</td>
		<td class="rightAligned" width="15%"><label id="consLbl" style="float: right; display: none;">To</label></td>
		<td class="leftAligned" width="25%">
			<span id="constructToSpan" style="width: 100%; display: none;" >
				<input type="text" id="constructTo" name="constructTo" style="width: 80%;" readonly="readonly"/>
				<img id="imgConstTo" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="$('constructTo').focus(); scwShow($('constructTo'),this, null);" style="margin: 0;" />
			</span>
		</td>
	</tr>
	<tr>
		<td width="30%"><label class="rightAligned" id="mainFromLbl" style="float: right; display: none;">Maintenance Period From</label></td>
		<td class="leftAligned" width="25%">
			<span id="mainFromSpan" style="width: 100%; display: none;">
				<input type="text" id="mainFrom" name="mainFrom" style="width: 80%;" readonly="readonly"/>
				<img id="imgMainFrom" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="$('mainFrom').focus(); scwShow($('mainFrom'),this, null);" style="margin: 0;" />
			</span>
			<input type="text" id="timeExcess" name="timeExcess" maxlength="4" style="width: 40%; display: none;" />
		</td>
		<td class="rightAligned" width="15%"><label id="mainToLbl" style=" float: right; display: none;">To</label></td>
		<td class="leftAligned" width="25%">
			<span id="mainToSpan" style="width: 90%; display: none;">
				<input type="text" id="mainTo" name="mainTo" style="width: 80%; " readonly="readonly"/>
				<img id="imgMainTo" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="$('mainTo').focus(); scwShow($('mainTo'),this, null);" style="margin: 0;" />
				</span>
			</td>
		</tr>
	</table>
	<div style="display: none;">
		<input type="hidden" id="enggBasicInfoNum" name="enggBasicInfoNum" value="">
		<input type="hidden" id="testStartDate" name="testStartDate" value="">
		<input type="hidden" id="testEndDate" name="testEndDate" value="">
	</div>
	<div class="buttonsDiv" style="margin-bottom: 10px;" changeTagAttr="true">
		<input type="button" class="button" id="btnUpdateENInfo" name="btnUpdateENInfo" value="Update" style="width: 90px;" />
		<input type="button" class="button" id="btnDeleteENInfo" name="btnDeleteENInfo" value="Delete" style="width: 90px;" />
	</div>
	<div id="principalInfoDiv" name="principalInfoDiv" style="display: none;">
		<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
			<div id="innerDiv" name="innerDiv">
				<label>Principal</label>
				<span class="refreshers" style="margin-top: 0;">
					<label id="togglePrincipal" name="gro" style="margin-left: 5px;">Show</label>
				</span>
			</div>
		</div>
		<div id="enPrincipalInfo" class="sectionDiv" style="display: none; border: none;"></div>
	</div>
	<div id="contractorInfoDiv" name="contractorInfoDiv" style="display: none;">
		<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
			<div id="innerDiv" name="innerDiv">
				<label>Contractor</label>
				<span class="refreshers" style="margin-top: 0;">
					<label id="toggleContractor" name="gro" style="margin-left: 5px;">Show</label>
				</span>
			</div>
		</div>
		<div id="enContractorInfo" class="sectionDiv" style="display: none; border: none;"></div>
	</div>
</div>

<script type="text/javascript">
	var constFromPrev = "";
	var constToPrev = "";
	var mainFromPrev = "";
	var mainToPrev = "";
	
	$("editProjText").observe("click", function () {
		showEditor("enProjectName", 250);
	});

	$("editSiteText").observe("click", function () {
		showEditor("enSiteLoc", 250);
	});

	$("enProjectName").observe("keyup", function () {
		limitText(this, 250);
	});

	$("enSiteLoc").observe("keyup", function () {
		limitText(this, 250);
	});

	$("mbiPolNo").observe("keyup", function() {
		limitText(this, 30);
	});

	$("weeksTesting").observe("blur", function(){
		var subline = $F("sublineCdParam");
		 
		if(isNaN(parseFloat($F("weeksTesting"))) && subline == "ERECTION_ALL_RISK") {
			showMessageBox("Weeks Testing/Commisioning legal characters are 0-9 - + E.", imgMessage.ERROR);
			$("weeksTesting").value = "";
			return false;
		}else if((parseFloat($F("weeksTesting").replace(/,/g, "")) > 999 || parseFloat($F("weeksTesting").replace(/,/g, "")) < -999) && subline == "ERECTION_ALL_RISK") {
			showMessageBox("Weeks Testing/Commisioning must be in range -999 to 999.", imgMessage.ERROR);
			$("weeksTesting").value = "";
			return false;
		}else if (!isNaN(parseFloat($F("weeksTesting"))) && $F("weeksTesting") != ""){
			$("weeksTesting").value = formatNumber(parseFloat($F("weeksTesting")));
		}   
	});

	$("timeExcess").observe("blur", function(){
		var subline = $F("sublineCdParam");
		
		if(isNaN(parseFloat($F("timeExcess"))) && subline == "MACHINERY_LOSS_OF_PROFIT") {
			showMessageBox("Time Excess legal characters are 0-9 - + E.", imgMessage.ERROR);
			$("timeExcess").value = "";
			return false;
		}else if((parseFloat($F("timeExcess").replace(/,/g, "")) > 999 || parseFloat($F("timeExcess").replace(/,/g, "")) < -999) && 
				subline == "MACHINERY_LOSS_OF_PROFIT") {
			showMessageBox("Time Excess must be in range -999 to 999.", imgMessage.ERROR);
			$("timeExcess").value = "";
			return false;
		}else if (!isNaN(parseFloat($F("timeExcess"))) && $F("timeExcess") != ""){
			$("timeExcess").value = formatNumber(parseFloat($F("timeExcess")));
		}
		 
	});

	$("constructFrom").observe("blur", function() {	validateConstructionDates("from"); });
	$("constructTo").observe("blur", function() { validateConstructionDates("to"); });
	$("mainFrom").observe("blur", function () {	validateMaintenanceDates("from"); });
	$("mainTo").observe("blur", function() { validateMaintenanceDates("to");	});

	$("togglePrincipal").observe("click", function(){
		if($("enPrincipalInfo").empty()) {
			showPrincipalListForENPackQuote("P");
		}
	});

	$("toggleContractor").observe("click", function(){
		if($("enContractorInfo").empty()) {
			showPrincipalListForENPackQuote("C");
		}
	});

	function validateConstructionDates(elem) {
		var inceptDate = objCurrPackQuote.inceptDate;
		var expiryDate = objCurrPackQuote.expiryDate;
		var subline = $F("sublineCdParam");
		
		if(subline == "CONTRACTOR_ALL_RISK" || subline == "CONTRACTORS_ALL_RISK") {
			var constFrom = makeDate($F("constructFrom"));
			var constTo = makeDate($F("constructTo"));
			var maintFrom = makeDate($F("mainFrom"));
			var maintTo = makeDate($F("mainTo"));
			var incept = makeDate(inceptDate);
			var expiry = makeDate(expiryDate);
	
			if (constTo > expiry) {
				showMessageBox("Construction To Date should not be later than Expiry Date.", imgMessage.ERROR);
				$("constructTo").value = constToPrev;
				return false;
			} else if (constFrom > constTo && elem == "from") {
				showMessageBox("Construction Period From Date must be earlier than Construction Period To Date.", imgMessage.ERROR);
				$("constructFrom").value = constFromPrev;
				return false;
			} else if (constTo < constFrom && elem == "to") {
				showMessageBox("Construction Period End Date must not be earlier than Construction Period From Date.", imgMessage.ERROR);
				$("constructTo").value = constToPrev;
				return false;
			} else if (elem == "to" && constTo > maintFrom || constTo > maintTo) {
				showMessageBox("Construction Period End Date must be earlier than Maintenance Period.", imgMessage.ERROR);
				$("constructTo").value = constToPrev;
				return false;
			} else {
				constFromPrev = $F("constructFrom");
				constToPrev = $F("constructTo");
				hideNotice();
			}
		}
	}

	function validateMaintenanceDates(elem) {
		var inceptDate = objCurrPackQuote.inceptDate;
		var expiryDate = objCurrPackQuote.expiryDate;
		var subline = $F("sublineCdParam");
		
		if(subline == "CONTRACTOR_ALL_RISK" || subline == "CONTRACTORS_ALL_RISK") {
			var constFrom = makeDate($F("constructFrom"));
			var constTo = makeDate($F("constructTo"));
			var maintFrom = makeDate($F("mainFrom"));
			var maintTo = makeDate($F("mainTo"));
			var incept = makeDate(inceptDate);
			var expiry = makeDate(expiryDate);

			if (maintFrom < constTo) {
				showMessageBox("Maintenance Period From Date must not be earlier than Construction Period To Date.", imgMessage.ERROR);
				$("mainFrom").value = mainFromPrev;
				return false;
			} else if(!(maintTo == "" || maintTo == null) && maintFrom > maintTo && elem == "from") {
				showMessageBox("Maintenance Period From Date must be earlier than Maintenance Period To Date.", imgMessage.ERROR);
				$("mainFrom").value = mainFromPrev;
				return false;
			} else if(!(maintFrom == "" || maintFrom == null) && maintFrom > maintTo && elem == "to") {
				showMessageBox("Maintenance Period End Date must not be earlier than Maintenance Period From Date.", imgMessage.ERROR);
				$("mainTo").value = mainToPrev;
				return false;
			} else if(maintTo < constTo) {
				showMessageBox("Maintenance Period End Date must not be earlier than Construction Period To Date.", imgMessage.ERROR);
				$("mainTo").value = mainToPrev;
				return false;	
			} else {
				mainFromPrev = $F("mainFrom");
				mainToPrev = $F("mainTo");
				hideNotice();
			}	
		}
	}
	
</script>
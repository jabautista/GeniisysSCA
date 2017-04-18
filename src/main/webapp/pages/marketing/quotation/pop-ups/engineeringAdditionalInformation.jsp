<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div id="additionalInformationDiv${aiItemNo}" name="additionalInformationDiv" style="">
<input type="hidden" id="aiItemNo${aiItemNo}" name="aiItemNo${aiItemNo}" value="${aiItemNo}"/>
<!--<div id="outerDiv" name="outerDiv">-->
<!--	<div id="innerDiv" name="innerDiv">-->
<!--   		<label>Additional Information </label>-->
<!--   		<span class="refreshers" style="margin-top: 0;">-->
<!--   			<label name='gro'>Show</label>-->
<!--   		</span>-->
<!--   	</div>-->
<!--</div>-->
<div class="sectionDiv" id="additionalInformationSectionDiv${aiItemNo}" name="additionalInformationSectionDiv" style="">
	<form id="engineeringAdditionalInformationForm" name="engineeringAdditionalInformationForm">
		<input type="hidden" id="quoteId${aiItemNo}" name="quoteId" value="${gipiQuote.quoteId}" />
		<input type="hidden" id="aiItemNo${aiItemNo}" name="aiItemNo" value="${aiItemNo}" />
		
		<input type="hidden" id="inceptDate${aiItemNo}" name="inceptDate" value="${inceptDate}" />
		<input type="hidden" id="expiryDate${aiItemNo}" name="expiryDate" value="${expiryDate}" />
		<span class="notice" id="noticePopup" name="noticePopup" style="display: none;">Saving, please wait...</span>		
		<table align="center" style="width: 45%; margin-top: 10px; margin-bottom: 10px;">
			<tr>
				<td class="rightAligned" style="width: 100px;">Title of Contract</td>
				<td class="leftAligned" colspan="3"><input type="text" id="title${aiItemNo}" name="title" style="width: 228px;" maxlength="250" value="${quoteItemEN.contractProjBussTitle}"/></td>
			</tr>
			<tr>
				<td class="rightAligned">Location of Contract Site</td>
				<td class="leftAligned" colspan="3"><input type="text" id="location${aiItemNo}" name="location" style="width: 228px;" maxlength="250" value="${quoteItemEN.siteLocation}"/></td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 150px;">Construction Period From </td>
				<td class="leftAligned">
					<span style="width: 98px;">
						<input style="border: none; width: 70px;" id="constFrom${aiItemNo}" name="constFrom" type="text" value="<fmt:formatDate pattern="MM-dd-yyyy" value="${quoteItemEN.constructStartDate}" />" readonly="readonly" />
						<img id="imgConstFrom${aiItemNo}" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="$('constFrom${aiItemNo}').focus(); scwShow($('constFrom${aiItemNo}'),this, null);" style="margin: 0;" />
					</span>
				</td>
				<td class="rightAligned" style="text-align: center; width: 10px;">to</td>
				<td class="leftAligned">
					<span style="width: 98px;">
						<input style="border: none; width: 70px;" id="constTo${aiItemNo}" name="constTo" type="text" value="<fmt:formatDate pattern="MM-dd-yyyy" value="${quoteItemEN.constructEndDate}" />" readonly="readonly" />
						<img id="imgConstTo${aiItemNo}" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="$('constTo${aiItemNo}').focus(); scwShow($('constTo${aiItemNo}'),this, null);" style="margin: 0;" />
					</span>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 150px;">Maintenance Period From </td>
				<td class="leftAligned">
					<span style="width: 98px;">
						<input style="border: none; width: 70px;" id="maintFrom${aiItemNo}" name="maintFrom" type="text" value="<fmt:formatDate pattern="MM-dd-yyyy" value="${quoteItemEN.maintainStartDate}" />" readonly="readonly" />
						<img id="imgMaintFrom${aiItemNo}" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="$('maintFrom${aiItemNo}').focus(); scwShow($('maintFrom${aiItemNo}'),this, null);" style="margin: 0;" />
					</span>
				</td>
				<td class="rightAligned" style="text-align: center; width: 10px;">to</td>
				<td class="leftAligned">
					<span style="width: 98px;">
						<input style="border: none; width: 70px;" id="maintTo${aiItemNo}" name="maintTo" type="text" value="<fmt:formatDate pattern="MM-dd-yyyy" value="${quoteItemEN.maintainEndDate}" />" readonly="readonly" />
						<img id="imgMaintTo${aiItemNo}" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="$('maintTo${aiItemNo}').focus(); scwShow($('maintTo${aiItemNo}'),this, null);" style="margin: 0;" />
					</span>
				</td>
			</tr>
		</table>
	</form>
</div>
</div>
<script>
	initializeAll();

	var inceptDate  = makeDate($F("inceptDate${aiItemNo}"));
	var expiryDate = makeDate($F("expiryDate${aiItemNo}"));

	function isEngineeringDetailsValid(){
		var constructionStart = makeDate($F("constFrom${aiItemNo}"));
		var constructionEnd   = makeDate($F("constTo${aiItemNo}"));
		var maintenanceStart  = makeDate($F("maintFrom${aiItemNo}"));
		var maintenanceEnd 	  = makeDate($F("maintTo${aiItemNo}"));
		
		if($F("title${aiItemNo}")==""){
			return false;
		} else if($F("location${aiItemNo}")==""){
			return false;
		} else if(validateConstructionPeriod() != true){
			return false;
		} else if(validateMaintenancePeriod() != true){
			return false;
		} else{
			$("noticePopup").hide();
		}		
	}

	$("constFrom${aiItemNo}").setStyle("border: none; width: 70px; margin: 0;");
	$("constFrom${aiItemNo}").up("span", 0).setStyle("float: left; border: 1px solid gray; padding: 0; background-color: #fff; width: 98px;");

	$("constTo${aiItemNo}").setStyle("border: none; width: 70px; margin: 0;");
	$("constTo${aiItemNo}").up("span", 0).setStyle("float: left; border: 1px solid gray; padding: 0; background-color: #fff; width: 98px;");

	$("maintFrom${aiItemNo}").setStyle("border: none; width: 70px; margin: 0;");
	$("maintFrom${aiItemNo}").up("span", 0).setStyle("float: left; border: 1px solid gray; padding: 0; background-color: #fff; width: 98px;");

	$("maintTo${aiItemNo}").setStyle("border: none; width: 70px; margin: 0;");
	$("maintTo${aiItemNo}").up("span", 0).setStyle("float: left; border: 1px solid gray; padding: 0; background-color: #fff; width: 98px;");
	
	$("constTo${aiItemNo}").observe("blur", validateConstructionPeriod);
	$("constFrom${aiItemNo}").observe("blur", validateConstructionPeriod);

	function validateConstructionPeriod() {
		var constFrom = makeDate($F("constFrom${aiItemNo}"));
		var constTo = makeDate($F("constTo${aiItemNo}"));
		var maintFrom = makeDate($F("maintFrom${aiItemNo}"));
		var maintTo = makeDate($F("maintTo${aiItemNo}"));

		if (constTo < constFrom) {
			showQuotationListingError("Construction Period To must not be earlier than Construction Period From.");
			$("constFrom${aiItemNo}").value = "";
			$("constTo${aiItemNo}").value = "";
			return false;
		} else if (constTo > expiryDate || constFrom < inceptDate || constTo < inceptDate || constFrom > expiryDate ) {
			showQuotationListingError("Constructiion Period must be earlier than Maintenance Period and should be within the Inception Date and Expiry Date.");
			$("constFrom${aiItemNo}").value = "";
			$("constTo${aiItemNo}").value = "";
			return false;
		} else if ( maintTo <= constFrom || maintFrom <= constTo ||
				maintTo <= constTo   || maintFrom <= constFrom) {
				showQuotationListingError("Construction Period must be earlier than Maintenance Period and should be within the Inception Date and Expiry Date.");
				$("constFrom${aiItemNo}").value = "";
				$("constTo${aiItemNo}").value = "";
				return false;	
		} else {
//			$("noticePopup").hide();
			hideNotice();
		}
	}
	
	$("maintFrom${aiItemNo}").observe("blur", validateMaintenancePeriod);
	$("maintTo${aiItemNo}").observe("blur", validateMaintenancePeriod);

	function validateMaintenancePeriod() {
		var constFrom = makeDate($F("constFrom${aiItemNo}"));
		var constTo = makeDate($F("constTo${aiItemNo}"));
		var maintFrom = makeDate($F("maintFrom${aiItemNo}"));
		var maintTo = makeDate($F("maintTo${aiItemNo}"));

		if (maintTo < inceptDate || maintTo > expiryDate || maintFrom < inceptDate || maintFrom > expiryDate){
			showQuotationListingError("Maintenance Period must be later than Construction Period and should be within the Inception Date and Expiry Date.");		
			$("maintFrom${aiItemNo}").value = "";
			$("maintTo${aiItemNo}").value   = "";
		} else if ( maintTo <= constFrom || maintFrom <= constTo ||
			maintTo <= constTo   || maintFrom <= constFrom) {
			showQuotationListingError("Maintenance Period must be later than Construction Period and should be within the Inception Date and Expiry Date.");
			$("maintFrom${aiItemNo}").value = "";
			$("maintTo${aiItemNo}").value   = "";
			return false;
		} else if ( maintTo < maintFrom ) {
			showQuotationListingError("Maintenance Period To must not be earlier than Maintenance Period From.");
			$("maintFrom${aiItemNo}").value = "";
			$("maintTo${aiItemNo}").value   = "";
			return false;
		} else {
//			$("noticePopup").hide(); dateFormat
			hideNotice();
		}
	}

	initializeAccordion();
</script>
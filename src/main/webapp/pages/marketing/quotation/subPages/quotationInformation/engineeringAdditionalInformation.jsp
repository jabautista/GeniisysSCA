<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<div id="additionalInformationDiv" name="additionalInformationDiv" style="display: none;">
	<div class="sectionDiv" id="additionalInformationSectionDiv" name="additionalInformationSectionDiv" style="overflow: visible; display: none;">
		<form id="engineeringAdditionalInfoForm" name="engineeringAdditionalInfoForm">
			<table align="center" style="margin-top: 10px; margin-bottom: 10px;">
				<tr>
					<td class="rightAligned" width="150px">Title of Contract</td>
					<td class="leftAligned" width="360px" colspan="3">
						<div style="width: 350px; border: 1px solid gray; height: 20px; padding-bottom: 1px;">
							<!-- <input type="text" tabindex="3" style="width: 320px; height: ; float: left; border: none;" id="inputTitle" name="inputTitle" maxlength="250" class="aiInput"/> replaced by textarea christian 03/12/2013-->
							<textarea id="inputTitle" name="inputTitle" tabindex="3" style="width: 320px; height:14px; float: left; border: none;" maxlength="250" class="aiInput"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: left;" alt="EditTitle" id="editTitle" class="aiInput"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" width="150px">Location of Contract Site</td>
					<td class="leftAligned" width="360px" colspan="3">
						<div style="width: 350px; border: 1px solid gray; height: 20px; padding-bottom: 1px;">
							<!-- <input type="text" tabindex="3" style="width: 320px; height: ; float: left; border: none;" id="inputLocation" name="inputLocation" maxlength="250" class="aiInput"/> replaced by textarea christian 03/12/2013-->
							<textarea id="inputLocation" name="inputLocation" tabindex="3" style="width: 320px; height:14px; float: left; border: none;" maxlength="250" class="aiInput"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: left;" alt="EditLocation" id="editLocation" class="aiInput"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" width="150px">Construction Period From: </td>
					<td class="leftAligned" width="140px">
						<div id="constructFromSpan" style="width: 135px; border: 1px solid gray; height: 22px; padding-top: 0px;" >
							<input type="text" id="constructFrom" name="constructFrom" style="width: 100px; border: none;" readonly="readonly"/>
							<img id="imgConstFrom" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="$('constructFrom').focus(); scwShow($('constructFrom'),this, null);" style="margin: 0;" alt="Go" class="aiInput"/>
						</div>
					</td>
					<td class="rightAligned" width="60px">To: </label></td>
					<td class="leftAligned" width="140px">
						<div id="constructToSpan" style="width: 135px; border: 1px solid gray; height: 22px; padding-top: 0px;" >
							<input type="text" id="constructTo" name="constructTo" style="width: 100px; border: none;" readonly="readonly"/>
							<img id="imgConstTo" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="$('constructTo').focus(); scwShow($('constructTo'),this, null);" style="margin: 0;" alt="Go" class="aiInput"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" width="150px">Maintenance Period From: </td>
					<td class="leftAligned" width="140px">
						<div id="mainFromDiv" style="width: 135px; border: 1px solid gray; height: 22px; padding-top: 0px;">
							<input type="text" id="mainFrom" name="mainFrom" style="width: 100px; border: none;" readonly="readonly"/>
							<img id="imgMainFrom" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="$('mainFrom').focus(); scwShow($('mainFrom'),this, null);" style="margin: 0;" alt="Go" class="aiInput"/>
						</div>
					</td>
					<td class="rightAligned" width="60px">To: </td>
					<td class="leftAligned" width="140px">
						<div id="mainToDiv" style="width: 135px; border: 1px solid gray; height: 22px; padding-top: 0px;">
							<input type="text" id="mainTo" name="mainTo" style="width: 100px; border: none;" readonly="readonly"/>
							<img id="imgMainTo" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="$('mainTo').focus(); scwShow($('mainTo'),this, null);" style="margin: 0;" alt="Go" class="aiInput"/>
						</div>
					</td>
				</tr>
			</table>
			<div style="margin-left: auto; margin-right: auto; margin-bottom: 20px;">
				<input type="button" id="aiENUpdateBtn" name="aiENUpdateBtn" value="Apply Changes" class="disabledButton"/>  <!-- edited by steven 11/7/2012 binago ko ung id niya kasi parehas siya sa ibang jsp na tinatawag dito kaya nag-eerror ung function --> 
			</div>
		</form>
	</div>
</div>

<script type="text/javascript">
	/*var inceptDate = $F("txtInceptionDate");
	var expiryDate = $F("txtExpirationDate");*/

	$("constructFrom").observe("blur", function() {	validateConstruction("from");	});
	$("constructTo").observe("blur", function() {	validateConstruction("to");		});
	$("mainFrom").observe("blur", function () {		validateMaintenance("from");	});
	$("mainTo").observe("blur", function() {		validateMaintenance("to");	});
	
	function validateConstruction(elem) {
		// modified by: nica 06.13.2011 - to be reusable by package quotation
		var inceptDate = objMKGlobal.packQuoteId != null ? objCurrPackQuote.inceptDate : $F("txtInceptionDate");
		var expiryDate = objMKGlobal.packQuoteId != null ? objCurrPackQuote.expiryDate : $F("txtExpirationDate");
		
		var constFrom = makeDate($F("constructFrom"));
		var constTo = makeDate($F("constructTo"));
		var maintFrom = makeDate($F("mainFrom"));
		var maintTo = makeDate($F("mainTo"));

		if (constFrom > constTo && elem == "from") {
			showMessageBox("Construction Period From Date must be earlier than Construction Period To Date.", imgMessage.ERROR);
			$("constructFrom").value = constFromPrev;
			return false;
		} else if (constTo < constFrom && elem == "to") {
			showMessageBox("Construction Period End Date must not be earlier than Construction Period From Date.", imgMessage.ERROR);
			$("constructTo").value = constToPrev;
			return false;
		} else if (elem == "to" && constTo > maintFrom || constTo > maintTo) {
			showMessageBox("Construction Period End Date must be earlier than Maintenance Period", imgMessage.ERROR);
			$("constructTo").value = constToPrev;
			return false;
		} else {
			constFromPrev = $F("constructFrom");
			constToPrev = $F("constructTo");
			hideNotice();
		}
	}
	
	function validateMaintenance(elem) {
		// modified by: nica 06.13.2011 - to be reusable by package quotation
		var inceptDate = objMKGlobal.packQuoteId != null ? objCurrPackQuote.inceptDate : $F("txtInceptionDate");
		var expiryDate = objMKGlobal.packQuoteId != null ? objCurrPackQuote.expiryDate : $F("txtExpirationDate");
		
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
			showMessageBox("Maintenance Period From Date must be earlier than Maintenance Period To Date", imgMessage.ERROR);
			$("mainFrom").value = mainFromPrev;
			return false;
		} else if(!(maintFrom == "" || maintFrom == null) && maintFrom > maintTo && elem == "to") {
			showMessageBox("Maintenance Period End Date must not be earlier than Maintenance Period From Date", imgMessage.ERROR);
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
	
	$("editTitle").observe("click", function () {
		showEditor("inputTitle", 250);
	});
	
	$("editLocation").observe("click", function () {
		showEditor("inputLocation", 250);
	});
	
	$("inputTitle").observe("keyup", function () {
		limitText(this, 250);
	});
	
	$("inputLocation").observe("keyup", function () {
		limitText(this, 250);
	});
	
	initializeAiType("aiENUpdateBtn");
	
	$("aiENUpdateBtn").observe("click", function(){
		fireEvent($("btnAddItem"), "click");
		clearChangeAttribute("additionalInformationSectionDiv");
	});
</script>
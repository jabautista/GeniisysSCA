<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<div id="additionalInformationDiv" name="additionalInformationDiv"style="display: none;">
	<div class="sectionDiv" id="additionalInformationSectionDiv" name="additionalInformationSectionDiv" style="overflow: visible;">
		<form id="engineeringAdditionalInfoForm" name="engineeringAdditionalInfoForm">
			<table align="center" style="margin-top: 10px;">
				<tr>
					<td class="rightAligned" width="150px">Title of Contract</td>
					<td class="leftAligned" width="360px" colspan="3">
						<div style="width: 350px; border: 1px solid gray; height: 20px; padding-bottom: 1px;">
							<input type="hidden" id="txtEnggBasicInfoNum" name="txtEnggBasicInfoNum"/>
							<input type="text"  style="width: 323px; height: ; float: left; border: none;" id="txtConProjBussTitle" name="txtConProjBussTitle" maxlength="250" class="aiInput"  tabindex="301"/>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: left;" alt="EditTitle" id="editTitle" class="hover" tabindex="302"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" width="150px">Location of Contract Site</td>
					<td class="leftAligned" width="360px" colspan="3">
						<div style="width: 350px; border: 1px solid gray; height: 20px; padding-bottom: 1px;">
							<input type="text" style="width: 323px; height: ; float: left; border: none;" id="txtSiteLocation" name="txtSiteLocation" maxlength="250" class="aiInput upper" tabindex="303"/>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: left;" alt="EditLocation" id="editLocation" class="hover" tabindex="304"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" width="150px">Construction Period From: </td>
					<td class="leftAligned" width="140px">
						<div id="constructFromSpan" style="float: left; border: solid 1px gray; width: 135px; height: 20px; margin-right: 3px;">
							<input type="text" id="txtConstructStartDate" name="txtConstructStartDate" style="float: left; margin-top: 0px; margin-right: 3px; width: 107px; border: none;" readonly="readonly" tabindex="305"/>
							<img id="imgConstFrom" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" style="margin: 0; height: 18px;" alt="Go" class="hover" tabindex="306"/>
						</div>
					</td>
					<td class="rightAligned" width="58px">To: </label></td>
					<td class="leftAligned" width="140px">
						<div id="constructToSpan" style="width: 135px; border: 1px solid gray; height: 20px; padding-top: 0px;" >
							<input type="text" id="txtConstructEndDate" name="txtConstructEndDate" style="float: left; margin-top: 0px; margin-right: 3px; width: 107px; border: none;" readonly="readonly"  tabindex="307"/>
							<img id="imgConstTo" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" style="margin: 0;" alt="Go" class="hover" tabindex="308"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" width="150px">Maintenance Period From: </td>
					<td class="leftAligned" width="140px">
						<div id="mainFromDiv" style="width: 135px; border: 1px solid gray; height: 20px; padding-top: 0px;">
							<input type="text" id="txtMaintainStartDate" name="txtMaintainStartDate" style="float: left; margin-top: 0px; margin-right: 3px; width: 107px; border: none;" readonly="readonly" tabindex="309"/>
							<img id="imgMainFrom" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" style="margin: 0;" alt="Go" class="hover" tabindex="310"/>
						</div>
					</td>
					<td class="rightAligned" width="58px">To: </td>
					<td class="leftAligned" width="140px">
						<div id="mainToDiv" style="width: 135px; border: 1px solid gray; height: 20px; padding-top: 0px;">
							<input type="text" id="txtMaintainEndDate" name="txtMaintainEndDate" style="float: left; margin-top: 0px; margin-right: 3px; width: 107px; border: none;" readonly="readonly" tabindex="311"/>
							<img id="imgMainTo" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" style="margin: 0;" alt="Go" class="hover" tabindex="312"/>
						</div>
					</td>
				</tr>
			</table>
			<div class="buttonsDiv" style="margin-bottom: 10px;">
				<input type="button" id="aiUpdateBtn" name="aiUpdateBtn" value="Apply Changes" class="disabledButton"  tabindex="313"/>
			</div>
		</form>
	</div>
</div>

<script type="text/javascript">
	/* removed by robert 01.13.2015
		$("txtConstructStartDate").observe("blur", validateConstruction);
		$("txtConstructEndDate").observe("blur", validateConstruction);
		$("txtMaintainStartDate").observe("blur", validateMaintenance);
		$("txtMaintainEndDate").observe("blur",validateMaintenance);
		
		function validateConstruction() {
			var constFrom = makeDate($F("txtConstructStartDate"));
			var constTo = makeDate($F("txtConstructEndDate"));
			if (constTo < constFrom) {
				showMessageBox("Construction END date should not be earlier than START date.", "I");
				return false;
			}
		}
		
		function validateMaintenance() {
			var maintFrom = makeDate($F("txtMaintainStartDate"));
			var maintTo = makeDate($F("txtMaintainEndDate"));
			 if(maintTo < maintFrom) {
				showMessageBox("Maintain END date should not be earlier than START date.", "I");
				return false;
			 }
		} 
	*/
	
	//added by robert 01.13.2015
	var inceptDate 		= makeDate(objGIPIQuote.strInceptDate);
	var expiryDate 		= makeDate(objGIPIQuote.strExpiryDate);
	var tempDate 		= null;
	var origConstFrom 	= null;
	var origConstTo		= null;
	var constFromDate 	= null;
	var constToDate		= null;
	var mainFromDate 	= null;
	var mainToDate		= null;
	
	function initializeDates(){
		constFromDate 	= makeDate($F("txtConstructStartDate"));
		constToDate		= makeDate($F("txtConstructEndDate"));
		mainFromDate 	= makeDate($F("txtMaintainStartDate"));
		mainToDate		= makeDate($F("txtMaintainEndDate"));
	}
			
	function validateConsFromDate(){
		if(!($F("txtConstructStartDate").empty())){
			initializeDates();
			if(!($F("txtMaintainStartDate").empty()) && constFromDate > mainFromDate){
				$("txtConstructStartDate").value = tempDate;
				customShowMessageBox("Construction Start date should not be later than the Maintenance Start date.", imgMessage.INFO, "imgConstFrom");
			}else if(!($F("txtMaintainEndDate").empty()) && constFromDate > mainToDate){
				$("txtConstructStartDate").value = tempDate;
				customShowMessageBox("Construction Start date should not be later than the Maintenance End date.", imgMessage.INFO, "imgConstFrom");
			}else if(constFromDate > expiryDate){
				$("txtConstructStartDate").value = tempDate;
				customShowMessageBox("Construction Start date should not be later than the expiry date.", imgMessage.INFO, "imgConstFrom");				
			}else if(constFromDate < inceptDate){
				$("txtConstructStartDate").value = (((objGIPIQuote.strInceptDate).split(" "))[0]);
				customShowMessageBox("Construction Start date should not be earlier than the inception date. " +
						"Will copy incept date value from basic information.", imgMessage.INFO, "imgConstFrom");
			}else if(!($F("txtConstructEndDate").empty()) && constFromDate > constToDate){
				$("txtConstructStartDate").value = tempDate;
				customShowMessageBox("Construction Start date should not be later than the Construction End date.", imgMessage.INFO, "imgConstFrom");
			}
		}else{
			if(!($F("txtMaintainStartDate").empty()) || !($F("txtMaintainEndDate").empty())){
				showConfirmBox("Construction Period", "Deleting Construction Start date will result to the deletion of Maintenance Period. Do you want to continue ?",
						"Continue", "Cancel", function(){
					$("txtMaintainStartDate").value = null;
					$("txtMaintainEndDate").value = null;
				}, function(){
					$("txtConstructStartDate").value = origConstFrom;
				});
			}
		}
	}
	
	function validateConsToDate(){
		if(!($F("txtConstructEndDate").empty())){
			initializeDates();
			if(!($F("txtMaintainStartDate").empty()) && constToDate > mainFromDate){
				$("txtConstructEndDate").value = tempDate;
				customShowMessageBox("Construction End date should not be later than the Maintenance Start date.", imgMessage.INFO, "imgConstTo");
			}else if(!($F("txtMaintainEndDate").empty()) && constToDate > mainToDate){
				$("txtConstructEndDate").value = tempDate;
				customShowMessageBox("Construction End date should not be later than the Maintenance End date.", imgMessage.INFO, "imgConstTo");
			}else if(constToDate > expiryDate){
				$("txtConstructEndDate").value = tempDate;
				customShowMessageBox("Construction End date should not be later than the expiry date.", imgMessage.INFO, "imgConstTo");				
			}else if(constToDate < inceptDate){
				$("txtConstructEndDate").value = tempDate;
				customShowMessageBox("Construction End date should not be earlier than the inception date.", imgMessage.INFO, "imgConstTo");
			}else if(!($F("txtConstructStartDate").empty()) && constFromDate > constToDate){
				$("txtConstructEndDate").value = tempDate;
				customShowMessageBox("Construction End date should not be earlier than the Construction Start date.", imgMessage.INFO, "imgConstTo");
			}
		}else{
			if(!($F("txtMaintainStartDate").empty()) || !($F("txtMaintainEndDate").empty())){
				showConfirmBox("Construction Period", "Deleting Construction End date will result to the deletion of Maintenance Period. Do you want to continue ?",
						"Continue", "Cancel", function(){
					$("txtMaintainStartDate").value = null;
					$("txtMaintainEndDate").value = null;
				}, function(){
					$("txtConstructEndDate").value = origConstTo;
				});
			}
		}
	}
	
	function validateMainFromDate(){
		if(!($F("txtMaintainStartDate").empty())){
			if(!($F("txtConstructStartDate").empty()) && !($F("txtConstructEndDate").empty())){
				initializeDates();
				if(mainFromDate < inceptDate){
					$("txtMaintainStartDate").value = tempDate;
					customShowMessageBox("Maintenance Start date should not be earlier than the inception date.", imgMessage.INFO, "imgMainFrom");
				}else if(mainFromDate < constFromDate){
					$("txtMaintainStartDate").value = tempDate;
					customShowMessageBox("Maintenance Start date should not be earlier than the Construction Start date.", imgMessage.INFO, "imgMainFrom");
				}else if(mainFromDate < constToDate){
					$("txtMaintainStartDate").value = tempDate;
					customShowMessageBox("Maintenance Start date should not be earlier than the Construction End date.", imgMessage.INFO, "imgMainFrom");
				}else if(mainFromDate > expiryDate){
					$("txtMaintainStartDate").value = tempDate;
					customShowMessageBox("Maintenance Start date should not be later than the expiry date.", imgMessage.INFO, "imgMainFrom");	
				}else if(!($F("txtMaintainEndDate").empty()) && mainFromDate > mainToDate){
					$("txtMaintainStartDate").value = tempDate;
					customShowMessageBox("Maintenance Start date should not be later than the Maintenance End date.", imgMessage.INFO, "imgMainFrom");
				}
			}else{
				$("txtMaintainStartDate").value = null;
				customShowMessageBox("Please enter Construction Period first.", imgMessage.INFO, "imgConstFrom");
			}
		}
	}
	
	function validateMainToDate(){
		if(!($F("txtMaintainEndDate").empty())){
			if(!($F("txtConstructStartDate").empty()) && !($F("txtConstructEndDate").empty())){
				initializeDates();
			    if(mainToDate < inceptDate){
					$("txtMaintainEndDate").value = tempDate;
					customShowMessageBox("Maintenance End date should not be earlier than the inception date.", imgMessage.INFO, "imgMainTo");
			    }else if(mainToDate < constFromDate){
					$("txtMaintainEndDate").value = tempDate;
					customShowMessageBox("Maintenance End date should not be earlier than the Construction Start date.", imgMessage.INFO, "imgMainTo");
				}else if(mainToDate < constToDate){
					$("txtMaintainEndDate").value = tempDate;
					customShowMessageBox("Maintenance End date should not be earlier than the Construction End date.", imgMessage.INFO, "imgMainTo");
				}else if(mainToDate > expiryDate){
					$("txtMaintainEndDate").value = ((objGIPIQuote.strExpiryDate).split(" "))[0];
					customShowMessageBox("Maintenance End date should not be later than the expiry date. " +
							"Will copy expiry date value from basic information.", imgMessage.INFO, "imgMainTo");	
				}else if(!($F("txtConstructEndDate").empty()) && mainFromDate > mainToDate){
					$("txtMaintainEndDate").value = tempDate;
					customShowMessageBox("Maintenance End date should not be earlier than the Maintenance Start date.", imgMessage.INFO, "imgMainTo");
				}
			}else{
				$("txtMaintainEndDate").value = null;
				customShowMessageBox("Please enter Construction Period first.", imgMessage.INFO, "imgConstFrom");
			}
		}
	}
	$("txtConstructStartDate").observe("focus", function(){
		origConstFrom = $F("txtConstructStartDate");
	});
	$("txtConstructEndDate").observe("focus", function(){
		origConstTo = $F("txtConstructEndDate");
	});
    $("txtConstructStartDate").observe("blur", validateConsFromDate);
    $("txtConstructEndDate").observe("blur", validateConsToDate);
    $("txtMaintainStartDate").observe("blur", validateMainFromDate);
	$("txtMaintainEndDate").observe("blur",validateMainToDate); 
	$("imgConstFrom").observe("click", function(){
		tempDate = $F("txtConstructStartDate");
		scwShow($('txtConstructStartDate'),this, null);
	});
    $("imgConstTo").observe("click", function(){
    	tempDate	= $F("txtConstructEndDate");
		scwShow($('txtConstructEndDate'),this, null);
	});
    $("imgMainFrom").observe("click", function(){
    	tempDate = $F("txtMaintainStartDate");
		scwShow($('txtMaintainStartDate'),this, null);
	});
	$("imgMainTo").observe("click", function(){
		tempDate = $F("txtMaintainEndDate");
		scwShow($('txtMaintainEndDate'),this, null);
	});
	//end by robert

	$("editTitle").observe("click", function () {
		showEditor("txtConProjBussTitle", 250);
	});
	
	$("editTitle").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showEditor("txtConProjBussTitle", 250);
		}
	});

	$("editLocation").observe("click", function () {
		showEditor("txtSiteLocation", 250);
	});
	
	$("editLocation").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showEditor("txtSiteLocation", 250);
		}
	});
	
	$("imgConstFrom").observe("keypress", function (event) {
		if (event.keyCode == 13){
			scwShow($('txtConstructStartDate'),this, null);
		}
	});
	
	$("imgConstTo").observe("keypress", function (event) {
		if (event.keyCode == 13){
			scwShow($('txtConstructEndDate'),this, null);
		}
	});
	
	$("imgMainFrom").observe("keypress", function (event) {
		if (event.keyCode == 13){
			scwShow($('txtMaintainStartDate'),this, null);
		}
	});
	
	$("imgMainTo").observe("keypress", function (event) {
		if (event.keyCode == 13){
			scwShow($('txtMaintainEndDate'),this, null);
		}
	});

	$("txtConProjBussTitle").observe("keyup", function () {
		limitText(this, 250);
	});

	$("txtSiteLocation").observe("keyup", function () {
		limitText(this, 250);
	});
	
	initializeAiType("aiUpdateBtn");
	initializeChangeAttribute();
	
	$("aiUpdateBtn").observe("click", function(){
		objQuote.addtlInfo = 'Y'; //robert 9.28.2012
		fireEvent($("btnAddItem"), "click");
		clearChangeAttribute("additionalInformationSectionDiv");
		disableButton("aiUpdateBtn");
	});
</script>
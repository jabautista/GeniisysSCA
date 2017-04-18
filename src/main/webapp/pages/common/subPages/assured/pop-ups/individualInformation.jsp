<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div id="individualDiv" name="individualDiv" class="sectionDiv" changeTagAttr="true" style="width: 99%; margin-top: 5px;">
	<span class="notice" id="noticePopup" name="noticePopup" style="display: none;">Saving, please wait...</span>
	<form id="individualForm" name="individualForm" style="margin: auto;">
		<input type="hidden" id="assdNo" name="assdNo" value="${assdNo}" />
		
		<!-- <div id="outerDiv" name="outerDiv" style="width: 100%;">
			<div id="innerDiv" name="outerDiv">
				<label>Please fill out all details.</label>
			</div>
		</div> --> 
		
		<div class="sectionDiv">
			<table align="center" style="width: 100%;">
				<tr>
					<td class="rightAligned" style="width: 140px;">Assured Name</td>
					<td class="leftAligned"><input type="text" id="assdName" name="assdName" style="width: 465px;" value="${assuredName}" readonly="readonly" /></td>
				</tr>
			</table>
		</div>
		
		<div class="sectionDiv">
			<table align="center" style="width: 100%;">
				<tr>
					<td class="rightAligned" style="width: 140px;">Birthdate</td>
					<td class="leftAligned">
						<span style="width: 98px;">
							<input type="text" id="birthdate" name="birthdate" style="width: 180px;" value="<fmt:formatDate value="${assdIndInfo.birthdate}" pattern="MM-dd-yyyy" />" readonly="readonly" lastValidValue=""/>
							<img id="imgBirthdate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" style="margin: 0;" alt="Birthdate" />
						</span></td>
					<td class="rightAligned" style="width: 80px;">Gender</td>
					<td class="leftAligned">
						<select id="sex" name="sex" style="width: 188px;">
							<option value=""></option>
							<c:forEach var="s" items="${sexes}">
								<option value="${s.rvLowValue}"
								<c:if test="${assdIndInfo.sex eq s.rvLowValue}">
									selected="selected"
								</c:if>
								>${s.rvMeaning}</option>
							</c:forEach>
						</select></td>
				</tr>
				<tr>
					<td class="rightAligned">Citizenship</td>
					<td class="leftAligned"><input type="text" id="citizenship" name="citizenship" style="width: 180px;" maxlength=15 value="${assdIndInfo.citizenship}" /></td>
					<td class="rightAligned">Civil Status</td>
					<td class="leftAligned">
						<select id="civilStatus" name="civilStatus" style="width: 188px;">
							<option value=""></option>
							<c:forEach var="c" items="${civilStatuses}">
								<option value="${c.rvLowValue}"
								<c:if test="${assdIndInfo.status eq c.rvLowValue}">
									selected="selected"
								</c:if>
								>${c.rvMeaning}</option>
							</c:forEach>
						</select></td>
				</tr>
				<tr>
					<td class="rightAligned">Email Address</td>
					<td class="leftAligned"><input type="text" id="emailAddress" name="emailAddress" style="width: 180px;" maxlength=100 value="${assdIndInfo.emailAddress}" /></td>
				</tr>
			</table>
		</div>
		
		<div class="sectionDiv">
			<table align="center" style="width: 100%;">
				<tr>
					<td class="rightAligned" style="width: 140px;">Home Ownership</td>
					<td class="leftAligned">
						<select id="homeOwnership" name="homeOwnership" style="width: 188px;">
							<option value=""></option>
							<%-- <c:forEach var="s" items="${hos}">
								<option value="${s.rvLowValue}"
									<c:if test="${assdIndInfo.homeOwnership eq s.rvLowValue}">
										selected="selected"
									</c:if>
								>${s.rvMeaning}</option>
							</c:forEach> --%>
							<option value="L">Living with Parents</option>
							<option value="M">Mortgaged</option>
							<option value="O">Owned</option>
							<option value="R">Rented</option>
						</select></td>
						<td class="rightAligned" style="width: 100px; " id="rentAmtLbl">Monthly Amortization/Rent</td>
						<td class="leftAligned"><input type="text" id="rentAmt" name="rentAmt" style="width: 157px;" class="money" value="${assdIndInfo.rentAmt}" /></td>
				</tr>
				<tr>
					<td class="rightAligned">With Whom</td>
					<td class="leftAligned"><input type="text" id="mortName" name="mortName" style="width: 180px;" maxlength=40 value="${assdIndInfo.mortName}" /></td>
					<td class="rightAligned">Years of Stay</td>
					<td class="leftAligned"><input type="text" id="yearsOfStay" name="yearsOfStay" style="width: 100px;" maxlength=3 class="rightAligned" value="${assdIndInfo.yearsOfStay}" /></td>
				</tr>
				<tr>
					<!-- <td class="rightAligned">No. of Owned Cars</td> -->
					<td class="rightAligned">No. of Cars Owned</td>
					<td class="leftAligned"><input type="text" id="noOfCars" name="noOfCars" style="width: 180px; text-align: right;" maxlength=3 value="${assdIndInfo.noOfCars}" /></td>
				</tr>
			</table>
		</div>
		
		<div class="sectionDiv">
			<table align="center" style="width: 100%;">
				<tr>
					<td class="rightAligned" style="width: 140px;">Educational Attainment</td>
					<td class="leftAligned">
						<select id="educationalAttainment" name="educationalAttainment" style="width: 188px;">
							<option value=""></option>
							<%-- <c:forEach var="e" items="${eas}">
								<option value="${e.rvLowValue}"
								<c:if test="${assdIndInfo.educationalAttainment eq e.rvLowValue}">
									selected="selected"
								</c:if>
								>${e.rvMeaning}</option>
							</c:forEach> --%>
							<option value="C">College</option>
							<option value="H">High School</option>
							<option value="P">Post Graduate</option>
							<option value="S">Some College</option>
						</select></td>
					<td class="rightAligned" style="width: 80px;">Employment</td>
					<td class="leftAligned">
						<select id="employment" name="employment" style="width: 188px;">
							<option value=""></option>
							<%-- <c:forEach var="e" items="${employments}">
								<option value="${e.rvLowValue}"
								<c:if test="${assdIndInfo.employment eq e.rvLowValue}">
									selected="selected"
								</c:if>
								>${e.rvMeaning}</option> 
							</c:forEach>--%>
							<option value="G">Government</option>
							<option value="P">Private</option>
							<option value="R">Retired</option>
							<option value="S">Self Employed</option>
						</select></td>
				</tr>
			</table>
		</div>
		
		<div class="sectionDiv">
			<table align="center" style="width: 100%;">
				<tr>
					<td class="rightAligned" style="width: 140px;">Nature of Business</td>
					<td class="leftAligned">
						<select id="natureOfBusiness" name="natureOfBusiness" style="width: 188px;">
							<option value=""></option>
							<%-- <c:forEach var="n" items="${nobs}">
								<option value="${n.rvLowValue}"
								<c:if test="${assdIndInfo.natureOfBusiness eq n.rvLowValue}">
									selected="selected"
								</c:if>
								>${n.rvMeaning}</option>
							</c:forEach> --%>
							<option value="E">Media</option>
							<option value="F">Financial Institutions</option>
							<option value="G">Government</option>
							<option value="M">Manufacturing</option>
							<option value="O">Others</option>
							<option value="R">Retail</option>
							<option value="T">Travel/Entertainment</option>
						</select></td>
					<td class="rightAligned" style="width: 80px;">Gross Annual Income</td>
					<td class="leftAligned">
						<select id="grossAnnualIncome" name="grossAnnualIncome" style="width: 188px;">
							<option value=""></option>
							<%-- <c:forEach var="g" items="${gais}">
								<option value="${g.rvLowValue}"
								<c:if test="${assdIndInfo.grossAnnualIncome eq g.rvLowValue}">
									selected="selected"
								</c:if>
								>${g.rvMeaning}</option>
							</c:forEach> --%>
							<option value="1">below 100,000</option>
							<option value="2">100,001 - 250,000</option>
							<option value="3">250,001 - 500,000</option>
							<option value="4">500,001 - 750,000</option>
							<option value="5">750,001 - 1,000,000</option>
							<option value="6">1,000,001 and above</option>
						</select></td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 140px;">Other Nature</td>
					<td class="leftAligned" colspan="3"><input type="text" id="othNature" name="othNature" style="width: 465px;" maxlength=20 value="${assdIndInfo.othNature}" disabled="disabled"/></td>
				</tr>
			</table>
		</div>
		
		<div class="sectionDiv">
			<table align="center" style="width: 100%;">
				<tr>
					<td class="rightAligned" style="width: 140px;">Company Name</td>
					<td class="leftAligned"><input type="text" id="companyName" name="companyName" style="width: 465px;" maxlength=50 value="${assdIndInfo.companyName}" /></td>
				</tr>
				<tr>
					<td class="rightAligned">Company Address</td>
					<td class="leftAligned"><input type="text" id="companyAddress" name="companyAddress" style="width: 465px;" maxlength=50 value="${assdIndInfo.companyAddress}" /></td>
				</tr>
				<tr>
					<td class="rightAligned">Position</td>
					<td class="leftAligned"><input type="text" id="position" name="position" style="width: 180px;" maxlength=20 value="${assdIndInfo.position}" /></td>
				</tr>
			</table>
		</div>
		
		<div class="sectionDiv">
			<table align="center" style="width: 100%;">
				<tr>
					<td class="rightAligned" style="width: 140px;">Spouse Name</td>
					<td class="leftAligned"><input type="text" id="spouseName" name="spouseName" style="width: 465px;" maxlength=50 value="${assdIndInfo.spouseName}"  disabled="disabled"/></td>
				</tr>
			</table>
		</div>
	</form>
</div>
<div class="buttonsDivPopup">
	<input type="button" class="button" id="btnCancelI" name="btnCancelI" value="Cancel" style="width: 60px;" />
	<input type="button" class="button" id="btnSaveI" name="btnSaveI" value="Save" style="width: 60px;" />
</div>

<script>
	
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	setDefaults();
	
	$("homeOwnership").value = '${assdIndInfo.homeOwnership}';
	$("educationalAttainment").value = '${assdIndInfo.educationalAttainment}';
	$("employment").value = '${assdIndInfo.employment}';
	$("natureOfBusiness").value = '${assdIndInfo.natureOfBusiness}';
	$("grossAnnualIncome").value = '${assdIndInfo.grossAnnualIncome}';
	
	if ($F("natureOfBusiness") == "O") {
		$("othNature").enable();
	}
	
	if ($F("homeOwnership") == "M" || $F("homeOwnership") == "R") {
		$("rentAmt").show();
		$("rentAmtLbl").show();
		$("rentAmt").addClassName("required");
	}else{
		$("rentAmt").disable();
		$("rentAmt").removeClassName("required");
		$("rentAmt").value ="";
	}
	
	if ($F("civilStatus") == "M") {
		$("spouseName").enable();
	} 

	// andrew - 03.02.2011 - added this 'if' block
	if($F("hidViewOnly") == "true") {
		$$("input[type='text']").each(function(input){
			input.writeAttribute("readonly");
		});

		$$("select").each(function(sel){
			sel.disable();
		});
		
		$("btnSaveI").hide();
		$("btnCancelI").value = "Close";
		disableDate("imgBirthdate");
	}
	
	// added by: Nica 01.10.2013 - temporary solution to the  
	// intermittent problem of disabled calendar month and year dropdown
	if($("scwMonths") != null && $("scwYears") != null){
		$("scwMonths").enable();
		$("scwYears").enable();
	}
	
	function setDefaults(){
		var tempArray = [];
		
		/* if($F("rentAmt") == ""){
			$("rentAmt").value = "1.00";
		} */ //Patrick 02.21.2012
		
		for (var i = 0; i < $("grossAnnualIncome").length; i++){
			var stringVar = $("grossAnnualIncome").options[i].value + "/" + $("grossAnnualIncome").options[i].innerHTML;
			tempArray.push(stringVar);
		}

		for (var j = 0; j < $("grossAnnualIncome").length; j++){
			if(j != 0){
				for (var k = 0; k < tempArray.length; k++){
					var split = tempArray[k].split("/");
					if (split[0] == j){
						$("grossAnnualIncome").options[j].value = split[0];
						$("grossAnnualIncome").options[j].innerHTML = split[1];
						break;
					}
				}
			}
		}
	}
	
	/* $("btnCancelI").observe("click", function () {
		Modalbox.hide();
	}); */
	
	function exitI(){
		individualInfoOverlay.close();
		delete individualInfoOverlay;
		changeTag = 0;
	}; // ++robert - 07.08.2011
	
	function saveAndExitI(){
		saveI("Y");
	};// ++robert - 07.11.2011

	$("btnCancelI").observe("click", function(){
		if(changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", saveAndExitI, exitI, "");
		}  else {
			individualInfoOverlay.close();
			delete individualInfoOverlay;
		}
	}); // ++robert - 07.08.2011

	//$("btnSaveI").observe("click", saveI);
	observeSaveForm("btnSaveI", saveI);
	
	function saveI(exitSw){ //marco - 07.09.2014 - added parameter
		var sysdate = new Date();
		var bDay = Date.parse($F("birthdate"));
		var diff = (sysdate - bDay) / (1000 * 60 * 60 * 24 * 365);
		
		if (!validateEmail($F("emailAddress")) && $F("emailAddress") != "") {
			showMessageBox("Invalid email address.", imgMessage.ERROR);
			return false;
		} else if(diff < 0){ // ++robert - 07.12.2011 added to check birthdate
				showMessageBox("Birthdate must not be later than system date.", imgMessage.ERROR);
				return false;
				$("birthdate").focus();
		} else if($("rentAmt").hasClassName("required") && unformatNumber($F("rentAmt")) == ""){
			showWaitingMessageBox("Monthly Amortization/Rent is required.", imgMessage.ERROR, function(){$("rentAmt").focus();});
			$("rentAmt").focus();
		}else if(!validateYearsOfStay() || !validateNoOfCars()){
			return false;
		}else {
			new Ajax.Request(contextPath+"/GIISAssuredController?ajax=1&action=saveI", {
				method: "POST",
				postBody: Form.serialize("individualForm"),
				onCreate: function() {
					showNotice("Saving, please wait...");
				}, 
				onComplete: function (response)	{
					if (checkErrorOnResponse(response)) {
						hideNotice();
						changeTag = 0;
						if (response.responseText == "SUCCESS") {
							showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
								if(nvl(exitSw, "N") == "Y"){
									individualInfoOverlay.close();
									delete individualInfoOverlay;
									fireEvent($("reloadForm"), "click"); //marco - 02.04.2013
								}
							}); //added by robert
						}
					}
				}
			});
		} 
	}

	/* $("homeOwnership").observe("blur", function (){
		if ($("homeOwnership").value == "M" || $("homeOwnership").value == "R"){
			$("rentAmt").addClassName("required");
		} else {
			$("rentAmt").removeClassName("required");
		}
	}); */

	/* $("rentAmt").observe("blur", function (){
		if ($("rentAmt").hasClassName("required")){
			if ($("rentAmt").value == "0.00"){
				showMessageBox("Rent Amount is required.", imgMessage.ERROR);
				$("rentAmt").focus();
			}
		}
		
		if ($F("rentAmt") < 1 || $F("rentAmt") > 99999999999999.99){
			showMessageBox('Invalid Monthly Amortization/Rent. Value should be from 1.00 to 99,999,999,999,999.99.', imgMessage.ERROR);
			$("rentAmt").focus();
		}

		if($F("rentAmt") == ""){
			$("rentAmt").value = "0.00";
		}
	}); */

	$("rentAmt").observe("change", function (){
		var rentAmt = $F("rentAmt").replace(/,/g, "");
		
		if (isNaN(rentAmt)){
			showMessageBox('Invalid Monthly Amortization/Rent. Value should be from 0.00 to 99,999,999,999,999.99.', imgMessage.ERROR);
			$("rentAmt").focus();
		}else if(compareAmounts(rentAmt, "0.00") == 1){
			showWaitingMessageBox("Invalid Monthly Amortization/Rent. Valid value should be from 0.00 to 99,999,999,999,999.99.", imgMessage.ERROR, function(){
				$("rentAmt").clear();
				$("rentAmt").focus();					
			});
			return false;			
		}else if(compareAmounts(rentAmt, "99999999999999.99") == -1){
			showWaitingMessageBox("Invalid Monthly Amortization/Rent. Valid value should be from 0.00 to 99,999,999,999,999.99.", imgMessage.ERROR, function(){
				$("rentAmt").clear();
				$("rentAmt").focus();					
			});
			return false;			
		}
	});

	$("yearsOfStay").observe("change", validateYearsOfStay);
	$("noOfCars").observe("change", validateNoOfCars);
	
	function validateYearsOfStay(){
		if (isNaN($F("yearsOfStay"))){
			showMessageBox('Invalid Years of Stay. Value should range from 0 to 999 and should not exceed to the difference of system year and birth year.', imgMessage.ERROR);
			$("yearsOfStay").value = "";
			$("yearsOfStay").focus();
			return false;
		} else if ($F("yearsOfStay") < 0){
			showMessageBox('Invalid Years of Stay. Value should range from 0 to 999 and should not exceed to the difference of system year and birth year.', imgMessage.ERROR);
			$("yearsOfStay").value = "";
			$("yearsOfStay").focus();
			return false;
		} else if (checkIfDecimal($F("yearsOfStay"))){
			showMessageBox('Invalid Years of Stay. Value should range from 0 to 999 and should not exceed to the difference of system year and birth year.', imgMessage.ERROR);
			$("yearsOfStay").value = "";
			$("yearsOfStay").focus();
			return false;
		} else if (checkIfYearsExist($F("yearsOfStay"))){
			showMessageBox('Invalid Years of Stay. Value should range from 0 to 999 and should not exceed to the difference of system year and birth year.', imgMessage.ERROR);
			$("yearsOfStay").value = "";
			$("yearsOfStay").focus();
			return false;
		}
		return true;
	}
	
	function validateNoOfCars(){
		if (isNaN($F("noOfCars"))){
			showMessageBox('Invalid No. of Owned Cars. Value should be from 0 to 999', imgMessage.ERROR);
			$("noOfCars").focus();
			$("noOfCars").value = 0;
			return false;
		} else if ($F("noOfCars") < 0){
			showMessageBox('Invalid No. of Owned Cars. Value should be from 0 to 999', imgMessage.ERROR);
			$("noOfCars").focus();
			$("noOfCars").value = 0;
			return false;
		} else if (checkIfDecimal($F("noOfCars")) || $F("noOfCars").include(".")){
			showMessageBox('Invalid No. of Owned Cars. Value should be from 0 to 999', imgMessage.ERROR);
			$("noOfCars").focus();
			$("noOfCars").value = 0;
			return false;
		} 
		return true;
	}

	function checkIfDecimal(number){
		var isDecimal = false;
		var newNum = number.split(".");
		var number2 = parseInt(newNum[0]);
		var decVal = number - number2;
		if (decVal > 0 && decVal < 1){
			isDecimal = true;
		}

		return isDecimal;
	}

	function checkIfYearsExist(yearsOfStay){
		var exceeds = false;
		//var testDate = "09-06-1990";

		if ($F("birthdate") != ""){
			var date = new Date();
			var bDay = Date.parse($F("birthdate"));
			//var bDay = Date.parse(testDate);
			var diff = (date - bDay) / (1000 * 60 * 60 * 24 * 365);
			var exactYrs = Math.round(diff);

			if (yearsOfStay > exactYrs){
				exceeds = true;
			}
		}

		return exceeds;
	}
	
	$("civilStatus").observe("change", function (event) {
		if ($F("civilStatus") == "M") {
			$("spouseName").enable();
		} else {
			$("spouseName").value = ""; //marco - 07.08.2014
			$("spouseName").disable();
		}
	}); // ++robert - 07.11.2011
	
	$("homeOwnership").observe("change", function (event) {
		if ($F("homeOwnership") == "M" || $F("homeOwnership") == "R") {
			$("rentAmt").enable(); //$("rentAmt").show();
			//$("rentAmtLbl").show();
			$("rentAmt").addClassName("required");
		} else {
			$("rentAmt").disable();//$("rentAmt").hide();
			//$("rentAmtLbl").hide();
			$("rentAmt").removeClassName("required");
			$("rentAmt").value = "";
		}
	}); // ++robert - 07.12.2011
	
	$("natureOfBusiness").observe("change", function (event) {
		if ($F("natureOfBusiness") == "O") {
			$("othNature").enable();
		} else {
			$("othNature").value = ""; //marco - 07.08.2014
			$("othNature").disable();
		}
	}); // ++robert - 07.12.2011
	
	$("birthdate").setStyle("border: none; width: 70px; margin: 0;");
	$("birthdate").up("span", 0).setStyle("float: left; border: 1px solid gray; padding: 0; background-color: #fff; width: 98px;");
	
	//marco - 07.17.2014
	$("birthdate").observe("keyup", function(event){
		if(event.keyCode == 46){
			changeTag = 1;
		}
	});
	$("imgBirthdate").observe("click", function(){
		scwNextAction =  function(){changeTag = 1;}.runsAfterSCW(this, null);
		scwShow($('birthdate'),this, null );
	});
	
	// ++robert - 07.11.2011
	changeTag = 0;
	initializeChangeTagBehavior(saveI);
	initializeChangeAttribute();
</script>
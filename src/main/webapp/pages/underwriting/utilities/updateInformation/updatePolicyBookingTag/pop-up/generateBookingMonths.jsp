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

<div id="genBookingMthMainDiv">
	<div id="fieldsDiv" class="sectionDiv" style="width: 328px; height: 50px; margin-bottom: 15px;">
		<label id="lblBookingYear" style="padding: 15px 0 0 40px;">Enter Booking Year:</label>
		<input id="txtBookingYear" name="txtBookingYear" type="text" value="${nextBookingYear}" maxlength="4" class="integerNoNegativeUnformattedNoComma rightAligned" style="width: 80px; float: left; margin: 10px 0 0 25px;" errorMessage="Invalid input.">
	</div>
	<div id="btnDiv" align="center" style="margin-top: 10px;">
		<input id="btnReturn" name="btnReturn" type="button" class="button" value="Return" style="width: 100px;">
		<input id="btnGenerate" name="btnGenerate" type="button" class="button" value="Generate" style="width: 100px;">
	</div>
</div>

<script type="text/javascript">
	initializeAll();
	var nextBookingYear = $F("txtBookingYear");
	var haveGenerate = false;
	
	$("txtBookingYear").observe("change", function(){
		if ($F("txtBookingYear") != ""){
			checkBookingYear();
		}
	});
	
	$("btnReturn").observe("click", function(){
		genBookingMthOverlay.close();
		if (haveGenerate){
			showUpdatePolicyBookingTag();
		}
	});
	
	$("btnGenerate").observe("click", function(){
		if ($F("txtBookingYear") == ""){
			showMessageBox("Please input Booking Year.", "I");
		}else if (parseInt($F("txtBookingYear")) < 1900){
			showMessageBox("Booking Year " + $F("txtBookingYear") + " is invalid.", "I");
		}else{
			generateBookingMonths();
		}
	});
	
	function checkBookingYear(){
		try{
			new Ajax.Request(contextPath+"/UpdateUtilitiesController",{
				method: "GET",
				parameters: {
					action:	"checkBookingYear",
					bookingYear: $F("txtBookingYear")
				},
				asynchronous: true,
				evalScripts: true,
				onComplete: function(response){
					if (response.responseText == '12'){
						$("txtBookingYear").value = nextBookingYear;
						showMessageBox("This Booking Year has complete Booking Months.", "I");
					}
				}
			});
		}catch(e){
			showErrorMessage("checkBookingYear", e);
		}
	}
	
	function generateBookingMonths(){
		try{
			new Ajax.Request(contextPath+"/UpdateUtilitiesController",{
				method: "GET",
				parameters: {
					action:		 "generateBookingMonths",
					bookingYear: $F("txtBookingYear")
				},
				asynchronous: true,
				evalScripts: true,
				onComplete: function(response){
					if(response.responseText = "Success"){
						showMessageBox("Booking months for the year " +$F("txtBookingYear")+ " have been generated successfully.", "I");
						$("txtBookingYear").value = parseInt($F("txtBookingYear")) + 1;
						haveGenerate = true;
					}
				}
			});
		}catch(e){
			showErrorMessage("generateBookingMonths", e);
		}
	}
</script>
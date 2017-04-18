<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="edstMainDiv" name="edstMainDiv" style="width: 300px; height: 210px; padding: 5px; margin-bottom: 0px;">
	<div id="filterDiv" name="filterDiv" class="sectionDiv" style="width: 300px;">
		<label style="padding-left: 9px; padding-top: 5px; padding-bottom: 2px; text-align: center; font-weight: bold; border-bottom: 1px solid #E0E0E0; width: 290px;">Filters</label>
		<table align="left" style="margin: 3px;">
			<tr><td colspan="2"><input value="1" title="Positive Records" type="radio" id="positiveRecords" name="filtersRG" style="margin: 0 5px 0 5px; float: left;"><label for="positiveRecords">Positive Records</label></td></tr>
			<tr><td style="width: 17px;"></td><td><input title="Less Negative Amounts" type="checkbox" id="lessNegative" name="lessNegative" style="margin: 0 5px 0 5px; float: left;"><label id="lblLessNegative" for="lessNegative">Less Negative Amounts</label></td></tr>
			<tr><td style="width: 17px;"></td><td><input title="Less Spoiled" type="checkbox" id="lessSpoiled" name=""lessSpoiled"" style="margin: 0 5px 0 5px; float: left;"><label id="lblLessSpoiled" for="lessSpoiled">Less Spoiled</label></td></tr>
			<tr><td colspan="2"><input value="2" title="Negative Amounts Only" type="radio" id="negativeAmounts" name="filtersRG" style="margin: 0 5px 0 5px; float: left;"><label for="negativeAmounts">Negative Amounts Only</label></td></tr>
		</table>
	</div>
	
	<div id="ctplDiv" name="ctplDiv" class="sectionDiv" style="width: 300px;">
		<label style="padding-left: 9px; padding-top: 5px; padding-bottom: 2px; text-align: center; font-weight: bold; border-bottom: 1px solid #E0E0E0; width: 290px;">CTPL</label>
		<table align="left" style="margin: 3px;">
			<tr><td><input value="1" title="Exclude CTPL Premium - Policy" type="radio" id="excludePolicy" name="ctplRG" style="margin: 0 5px 0 5px; float: left;"><label for="excludePolicy">Exclude CTPL Premium - Policy</label></td></tr>
			<tr><td><input value="2" title="Exclude CTPL Premium - Peril" type="radio" id="excludePeril" name="ctplRG" style="margin: 0 5px 0 5px; float: left;"><label for="excludePeril">Exclude CTPL Premium - Peril</label></td></tr>
			<tr><td><input value="3" title="Include CTPL Policies" type="radio" id="includeCtpl" name="ctplRG" style="margin: 0 5px 0 5px; float: left;"><label for="includeCtpl">Include CTPL Policies</label></td></tr>
		</table>
	</div>
	
	<div name="edstButtonsDiv" name="edstButtonsDiv" class="buttonsDiv" align="center" style="width: 300px;">
		<input type="button" class="button" id="btnOk" name="btnOk" value="Ok" style="width: 120px;">
		<input type="button" class="button" id="btnCancel" name="btnCancel" value="Cancel" style="width: 120px;">
	</div>
</div>

<script type="text/javascript">
	toggleEdstParams();
	
	$("btnCancel").observe("click", function(){
		objUW.uwReports.edst = 'N';
		toggleCheckboxes('cancel');
		edstOverlay.close();
	});
	
	$("btnOk").observe("click", function(){
		$$("input[name='filtersRG']").each(function(checkbox) {
			checkbox.checked == true ? objUW.uwReports.edstScope = checkbox.value : null;  
		});
		$$("input[name='ctplRG']").each(function(checkbox) {
			checkbox.checked == true ? objUW.uwReports.edstCtpPol = checkbox.value : null;  
		});
		objUW.uwReports.edst = 'Y';
		toggleCheckboxes('ok');
		edstOverlay.close();
	});
	
	function toggleCheckboxes(btn){
		$$("input[name='dateRG']").each(function(checkbox) {
			btn == 'ok' ? checkbox.disable() : checkbox.enable();
		});
		$$("input[name='scopeRG']").each(function(checkbox) {
			btn == 'ok' ? checkbox.disable() : checkbox.enable();
		});
		$$("input[name='typeRG']").each(function(checkbox) {
			btn == 'ok' ? checkbox.disable() : checkbox.enable();
		});
	}
	
	function toggleEdstParams(){
		$("positiveRecords").checked = true;
		$("excludePolicy").checked = true;
		
		if('${incCancelledSpoiledRecs}' == 'N'){
			$("lessNegative").checked = false;
			$("lessSpoiled").checked = false;
			$("lessNegative").disable();
			$("lessSpoiled").disable();
		}else{
			$("lessNegative").checked = true;
			$("lessSpoiled").checked = true;
		}
	}
</script>
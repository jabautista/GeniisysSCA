<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="ajax" uri="http://ajaxtags.org/tags/ajax" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<select id="selAdviceYear" name="selAdviceYear" title="Advice Year" class="required" disabled="disabled" style="width: 57px; text-align:left;">
	<option></option>
	<c:forEach var="ad" items="${adviceYearList}">
		<option value="${ad}">${ad}</option>
	</c:forEach>
</select>

<script type="text/javascript">
	$("selAdviceYear").observe("change", function(){
		if(!$F("selAdviceYear").blank()){
			$("selAdviceSequenceNo").enable();
			new Ajax.Updater("adviceSequenceDiv", "GIACDirectClaimPaymentController?action=filterAdviceSequence", {
				method:			"GET",
				parameters:	{
					transType:		$F("selTransactionType"),
					adviceLineCd:	$F("selAdviceLineCd"),
					adviceYear:		$F("selAdviceYear"),
					adviceIssCd:	$F("selAdviceIssCd")
				},
				evalScripts:	true,
				asynchronous:	true,
				onCreate: function(){
					
				},
				onComplete:	function(){
					
				}
			});
		}else{
			$("selAdviceSequenceNo").value = "";
			$("selAdviceSequenceNo").disable();
		}
	});
</script>
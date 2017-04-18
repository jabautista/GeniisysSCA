<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="ajax" uri="http://ajaxtags.org/tags/ajax" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="settlingSurveyMainDiv">
	<div style="margin-top: 10px; width: 623px;">
		<table border="0" align="center" style="margin-top: 5px; margin-bottom: 5px;">
			<tr>
				<td class="leftAligned" style="width: 100px;">Survey Agent</td>	
				<td class="leftAligned" > <input type="text" id="txtSurveyAgentCd" name="txtSurveyAgentCd" style="width: 80px;" readonly="readonly"></td>
				<td class="leftAligned" > <input type="text" id="txtDspSurveyName" name="txtDspSurveyName" style="width: 350px;" readonly="readonly"></td>
			</tr>
			<tr>
				<td class="leftAligned" >Settling Agent</td>	
				<td class="leftAligned" > <input type="text" id="txtSettlingAgentCd" name="txtSettlingAgentCd" style="width: 80px;" readonly="readonly"></td>
				<td class="leftAligned" > <input type="text" id="txtDspSettlingName" name="txtDspSettlingName" style="width: 350px;" readonly="readonly"></td>
			</tr>
		</table>
	</div>
</div>
<div id="buttonsDiv" style="text-align: center; margin-bottom: 5px; margin-top: 10px;">
	<input type="button" class="button" id="btnOk" value="Return" style="width: 120px;"/>
</div>
<script>

	$("txtSurveyAgentCd").value = objCLM.basicInfo.surveyAgentCode;
	$("txtDspSurveyName").value = unescapeHTML2(objCLM.basicInfo.dspSurveyName);
	$("txtSettlingAgentCd").value = objCLM.basicInfo.settlingAgentCode;
	$("txtDspSettlingName").value = unescapeHTML2(objCLM.basicInfo.dspSettlingName);
	
	$("btnOk").observe("click", function(){
		Windows.close("modal_dialog_lov");
	});
	
</script>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="distDateMainDiv" name="distDateMainDiv" class="sectionDiv" style="border: none;">
	<table style="padding: 20px;">
		<tr>
			<td class="leftAligned" style="width: 130px;">Distribution Date</td>
			<td>
				<div style="float: left; border: solid 1px gray; width: 148px; height: 20px;">
					<input type="text" style="float: left; margin-top: 0px; width: 120px; border: none; background-color: transparent;" name="txtDistDate" id="txtDistDate" value="${distDate}" readonly="readonly"/>
					<img id="hrefDistDate" alt="goDistDate" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="$('txtDistDate').focus(); scwShow($('txtDistDate'),this, null);" />						
				</div>
			</td>
		</tr>
	</table>
	<div align="center">
		<input type="button" class="button" id="distDateReturn" name="distDateReturn" value="Return" style="width:90px;">
	</div>
</div>

<script type="text/javascript">
	$("distDateReturn").observe("click", function(){
		$("hidDfltDistDate").value = $("txtDistDate").value;
		lossExpHistWin.close();
	});
	
	$("txtDistDate").observe("blur", function(){
		var distDate = makeDate($("txtDistDate").value);
		var polEffDate = makeDate(objCLMGlobal.strPolicyEffectivityDate2);
		
		if(distDate < polEffDate){
			showMessageBox("Distribution date must not be earlier than the policy's effectivity date ("+
						   objCLMGlobal.strPolicyEffectivityDate2+").", "I");
			$("txtDistDate").value = $("hidDfltDistDate").value;
		}
	});
	
</script>
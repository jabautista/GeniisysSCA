<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="messageDetailsMainDiv" name="messageDetailsMainDiv">
	<div class="sectionDiv" style="width: 730px; margin: 10px 0 12px 0;">
		<table style="margin: 15px 0 15px 15px;">
			<tr>
				<td class="rightAligned" style="vertical-align: top;">Message</td>
				<td colspan="3">
					<textarea id="dtlMessage" name="dtlMessage" style="width: 600px; height: 150px;" readonly="readonly" tabindex="201"></textarea>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Message Status</td>
				<td style="width: 200px;">
					<input id="dtlStatus" type="text" readonly="readonly" style="height: 13px; width: 200px;" tabindex="202">
				</td>
				<td class="rightAligned">Date Sent</td>
				<td style="width: 200px;">
					<input id="dtlDateSent" type="text" readonly="readonly" style="height: 13px; width: 200px;" tabindex="203">
				</td>
			</tr>
		</table>
	</div>
	<div align="center">
		<input id="btnOk" name="btnOk" type="button" class="button" value="Ok" style="width: 80px;" tabindex="204"/>
	</div>
</div>

<script type="text/javascript">
	function setFields(){
		var obj = JSON.parse('${detail}');
		$("dtlMessage").value = unescapeHTML2(obj.message);
		$("dtlStatus").value = unescapeHTML2(obj.dspMessageStatus);
		$("dtlDateSent").value = unescapeHTML2(obj.dspSetDate);
	}

	setFields();
	initializeAll();
	$("dtlMessage").focus();

	$("btnOk").observe("click", function(){
		messageDetailOverlay.close();
		delete messageDetailOverlay;
	});
</script>
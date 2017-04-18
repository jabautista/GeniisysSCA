<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>
<div id="copyPolicyOverlayMainDiv">
	<div id="copyPolicyBodyDiv" name="copyPolicyBodyDiv" style="margin-top: 10px; width: 99.5%;" class="sectionDiv">
		<table>
			<tr>
				<td id="oldParText" width="20%" class="rightAligned" style="margin-left: 100px;"> This Policy No. :</td>
				<td id="oldPar" width="20%" class="leftAligned" style=" color: blue;"><input type="text" name="oldParValue" id="oldParValue" style="color: blue; width: 300px; border: none;"/></td>				
			</tr>
			<tr>
				<td id="newParText" width="20%" class="rightAligned" style="margin-left: 100px;"> Has Been Copied to PAR No. :</td>
				<td id="newPar" width="20%" class="leftAligned" style=" color: red;"><input type="text" name="newParValue" id="newParValue" style="color: red; width: 300px; border: none;"/></td>
						
			</tr>
		</table>
	</div>
	
	<div align="center">
		<input type="button" class="button" id="btnReturn" value="Return" style="width: 80px;margin-top: 10px; margin-bottom: 10px;">
	</div>
</div>
<script type="text/javascript">
		var oldPar = '${oldPar}';
		var newPar = '${newPar}';
		$("oldParValue").value = oldPar;
		$("newParValue").value = newPar;
		
		$("btnReturn").observe("click",function(){			
			hideOverlay();
		});
		
</script>
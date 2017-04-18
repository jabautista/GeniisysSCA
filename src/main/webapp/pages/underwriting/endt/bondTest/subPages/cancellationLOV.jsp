<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="cancelLOVMainDiv">
	<div id="cancelLOVTableDiv" style="margin: 10px; height: 130px;">
		<div class="tableHeader">
			<label id="endtNoLabel">Endorsement No.</label>
		</div>
		<div class="tableContainer" id="endtNoListingDiv" name="endtNoListingDiv" style="display: block; overflow: auto;">
			<c:forEach var="polbas" items="${polbasListing}">
				<div id="endtNoRow${polbas.policyId }" name="endtNoRow" class="tableRow">
					<input type="hidden" id="policyId${polbas.policyId }" name="policyId" value="${polbas.policyId }"/>
					<label id="endtNo${polbas.policyId }" name="endtNo">${polbas.endorsement}</label>
				</div>
			</c:forEach>
		</div>
	</div>
	<div>
		<center><input type="button" class="button" id="btnCancelEndt" name="btnCancelEndt" value="OK" style="width: 100px; margin-top: 10px;" onClick="overlayCancellationLOV.close();"/></center>
	</div>
</div>
<script type="text/javascript">
	var policyId = "";
	
	$$("div[name='endtNoRow']").each(function (row){
		row.observe("mouseover", function (){
			row.addClassName("lightblue");
		});

		row.observe("mouseout", function (){
			row.removeClassName("lightblue");
		});

		row.observe("click", function (){
			row.toggleClassName("selectedRow");
			if (row.hasClassName("selectedRow")){
				$$("div[name='endtNoRow']").each(function (a){
					if (row.id != a.id){
						a.removeClassName("selectedRow");
					} else {
						policyId = row.down("input", 0).value;
					}
				});
			}
		});
	});

	$("btnCancelEndt").observe("click", function (){
		if (policyId == ""){
			showMessageBox("No Endorsement chosen to be cancelled.", imgMessage.INFO);
		} else {
			policyIdToBeCancelled = policyId;
		}
	});
</script>
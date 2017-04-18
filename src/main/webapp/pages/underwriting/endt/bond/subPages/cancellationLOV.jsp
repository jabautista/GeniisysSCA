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
	objGipis165.cancelled = "N"; //added by robert 11.22.2013
	
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
			objGipis165.bondSw = "N";
			//objGipis165.cancellationFlag = "Y";
			$("globalParStatus").value = "5";
			policyIdToBeCancelled = policyId;
			processEndtCancellationGipis165(policyIdToBeCancelled);
		}
	});
	
	function processEndtCancellationGipis165(policyIdToBeCancelled){
		try{
			var bondObj = objGipis165.prepareEndtBond(); //added by robert 11.22.2013
			bondObj.gipiWPolbas = prepareJsonAsParameter(bondObj.gipiWPolbas); //added by robert 11.22.2013
			bondObj.gipiParList = objGipis165.prepareParListParams(); //added by robert 11.22.2013
			bondObj.variables = prepareJsonAsParameter(bondObj.variables); //added by robert 11.22.2013
			var bondBasicObj = JSON.stringify(bondObj); //added by robert 11.22.2013
		
		new Ajax.Request(contextPath + "/GIPIParInformationController?action=processEndtCancellationGipis165", {
			method : "GET",
			parameters : {
				parId : $F("globalParId"),
				policyId : policyIdToBeCancelled,
				lineCd : $F("globalLineCd"),
				sublineCd : $F("globalSublineCd"),
				issCd : $F("globalIssCd"),
				issueYy : $F("txtIssueYy"),
				polSeqNo : $F("txtPolSeqNo"),
				renewNo : $F("txtRenewNo"),
				packPolFlag : $("packPolFlag").value,
				cancelType : objGIPIWPolbas.cancelType,	
				coiCancellation : $("chkCoiCancellation").checked ? "Y" : "N",
				effDate : $F("doe"),
				bondBasicObj: bondBasicObj //added by robert 11.22.2013
			},
			asynchronous : false,
			evalScripts : true,
			onCreate : showNotice("Please wait..."),
			onComplete : 
				function(response){
					hideNotice("");
					if (checkErrorOnResponse(response)){
						showMessageBox(" Endorsement successfully cancelled.","I");
						objGipis165.cancelled = "Y"; //added by robert 11.22.2013
						showEndtBondBasicInfo(); //added by robert 11.22.2013
						changeTag = 0; //added by robert 11.22.2013
					}
				}
		});
		} catch(e) {
			showErrorMessage("processEndtCancellationGipis165", e);
		}
	}
	
</script>
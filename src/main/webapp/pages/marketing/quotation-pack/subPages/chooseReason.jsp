<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<%-- <jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include> --%>
<!-- <br/> -->
<div id="chooseReasonDiv" style="margin: 5px;">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="outerDiv">
			<label id="">Please select a reason for denying the proposal.</label>
		</div>
	</div>
	<div class="sectionDiv" id="deleteAddItemDiv" align="center" style="margin-bottom: 10px;">
		<select id="reason" style="width: 90%;" >
			<option value="0"></option>
			<c:forEach items="${reasonListing}" var="r" varStatus="ctr">
				<option value="${r.reasonCd}">${r.reasonDesc}</option>		
			</c:forEach>
		</select>
	</div>
	<div align="center">
		<input type="button" class="button" id="btnReasonOK" value="OK" style="width: 80px;"/>
		<input type="button" class="button" id="btnReasonCancel" value="Cancel" style="width: 80px;"/>
	</div>	
</div>
<script type="text/javascript">
	//$("btnReasonCancel").observe("click", hideOverlay);
	$("btnReasonCancel").observe("click", function(){
		if(objUWGlobal.setSelectedIndexGIIMM001A != null || objUWGlobal.setSelectedIndexGIIMM001A != undefined){
			objUWGlobal.setSelectedIndexGIIMM001A(); // bonok :: set selectedIndex to 0 when cancelled because it is set to -1 when this overlay is displayed :: 05.07.2014
		}
		packDenyReasonOverlay.close();
	});
	
	var packQuoteNo = "${packQuoteNo}";
	var packQuoteId = "${packQuoteId}";
	$("btnReasonOK").observe("click", function(){
		if ("0" == $("reason").value){
			showMessageBox("Please select a reason for denying the proposal.", imgMessage.ERROR);
		}else{
			objMKGlobal.reason = $F("reason");
			packDenyReasonOverlay.close();
			showConfirmBox(/*"Deny Confirmation"*/ "Confirmation",	// changed by shan 07.07.2014 
					   "Deny Quotation No. <br />" +packQuoteNo+"?", 
				   	   "Yes", "No",  function () {denyPackQuotation(packQuoteId, packQuoteNo, objMKGlobal.reason);},
				   		function(){
				   		   if(objUWGlobal.setSelectedIndexGIIMM001A != null || objUWGlobal.setSelectedIndexGIIMM001A != undefined){
					   		   objUWGlobal.setSelectedIndexGIIMM001A(); // bonok :: set selectedIndex to 0 when cancelled because it is set to -1 when chooseReasonOverlay overlay is displayed :: 05.07.2014
				   		   };
				   	   	});
		}
	});

	function denyPackQuotation(packQuoteId,packQuoteNo, reason){
		new Ajax.Request(contextPath+"/GIPIPackQuoteController?action=denyPackQuotation", {
			asynchronouse: true,
			evalScripts: true,
			parameters: {
				packQuoteId: packQuoteId,
				packQuoteNo: packQuoteNo,
				reasonCd: reason
			},
			onCreate: function() {
				showNotice("Denying quotation, please wait...");
			},
			onComplete: function(response) {
				if (checkErrorOnResponse(response)){
					hideNotice(response.responseText);
					showMessageBox("The Quotation "+packQuoteNo+" has been denied.", imgMessage.INFO);
	 				//hideOverlay();
	 				//packDenyReasonOverlay.close();
	 				packQuotationTableGrid.clear();
					packQuotationTableGrid.refresh();
					selectedIndex = -1;
				}
			}
		});
	}
</script>
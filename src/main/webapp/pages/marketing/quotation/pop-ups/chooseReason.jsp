<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<%-- <jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include> --%>
<%-- <br/> --%>
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

<script>

//$("btnReasonCancel").observe("click", hideOverlay);
$("btnReasonCancel").observe("click", function(){
	if(objUWGlobal.setSelectedIndexGIIMM001 != null || objUWGlobal.setSelectedIndexGIIMM001 != undefined){
		objUWGlobal.setSelectedIndexGIIMM001(); // bonok :: set selectedIndex to 0 when cancelled because it is set to -1 when this overlay is displayed :: 05.07.2014
	}
	denyReasonOverlay.close();
});

$("btnReasonOK").observe("click", function(){
	//var quoteId = $F("quotationNo");   rmanalad<for table grid convertion 04.01.2011>
	var quoteNo = "${quoteNo}";
	var quoteId = "${quoteId}";
	var reasonCd = $("reason").value;
	if ("0" == $("reason").value){
		showMessageBox("Please select a reason for denying the proposal.", imgMessage.ERROR);
	} else {
		//hideOverlay();
		denyReasonOverlay.close();
		denyQuotation(quoteId, quoteNo, reasonCd);
	}
});



/*--- commented by rmanalad 5.9.2011
	$("btnReasonCancel").observe("click", hideOverlay);
	$("btnReasonOK").observe("click", function(){
		//var quoteId = $F("quotationNo");   rmanalad<for table grid convertion 04.01.2011>
		var quoteNo = "${quoteNo}";
		var quoteId = "${quoteId}";
		if ("0" == $("reason").value){
			showMessageBox("Please select a reason for denying the proposal.", imgMessage.ERROR);
		} else {
			new Ajax.Request(contextPath + "/GIPIQuotationController?action=updateReasonCd"
					+"&quotationId="+quoteId+"&reasonCd="+$("reason").value,{
				method : "GET",
				asynchronous : false,
				evalScripts : true,
				onComplete : function(response){
					if (checkErrorOnResponse(response)){
						denyQuotation(quoteId, quoteNo);
						hideOverlay();
					}
				}
			});
		}
	});

	*/
</script>
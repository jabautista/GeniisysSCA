<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
		<div style="margin: 5px;" id="uploadEnrolleesTable" name="uploadEnrolleesTable">	
			<div class="tableHeader" style="margin-top: 5px;">
				<label style="text-align: left; width: 20%; margin-right: 10px;">Upload No.</label>
				<label style="text-align: left; width: 30%; margin-right: 10px;">Filename</label>
				<label style="text-align: right; width: 20%; margin-right: 10px;">No. of Records</label>
				<label style="text-align: left; width: 10%; margin-right: 10px;">User Id</label>
				<label style="text-align: left; width: 12%; margin-right: 10px;">Date Loaded</label>
			</div>
			
			<div class="tableContainer" id="uploadEnrolleesListing" name="uploadEnrolleesListing" style="display: block;">
				<c:forEach var="gipiLoadHist" items="${gipiLoadHist}">
					<div id="rowUploadEnrollees${gipiLoadHist.uploadNo}${gipiLoadHist.parId}" itemSeqNo="" uploadNo="${gipiLoadHist.uploadNo}" parId="${gipiLoadHist.parId}" filename="${gipiLoadHist.filename }" name="uploadEnr" class="tableRow" style="padding-left:1px;">
						<label name="textUp" style="width: 20%; margin-right: 10px; text-align: left;">${gipiLoadHist.uploadNo }<c:if test="${empty gipiLoadHist.uploadNo}">---</c:if></label>
						<label name="textUp" style="width: 30%; margin-right: 10px; text-align: left;">${gipiLoadHist.filename }<c:if test="${empty gipiLoadHist.filename}">---</c:if></label>
						<label name="textUp" style="width: 20%; margin-right: 10px; text-align: right;">${gipiLoadHist.noOfRecords }<c:if test="${empty gipiLoadHist.noOfRecords}">---</c:if></label>
						<label name="textUp" style="width: 10%; margin-right: 10px; text-align: left;">${gipiLoadHist.userId }<c:if test="${empty gipiLoadHist.userId}">---</c:if></label>
						<label name="textUp" style="width: 12%; margin-right: 10px; text-align: left;"><fmt:formatDate value="${gipiLoadHist.dateLoaded }" pattern="MM-dd-yyyy" /><c:if test="${empty gipiLoadHist.dateLoaded }">---</c:if></label>
					</div>
				</c:forEach>
			</div>
		</div>
		
<script type="text/javascript">
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	$$("label[name='textUp']").each(function (label)    {
   		if ((label.innerHTML).length > 30)    {
        	label.update((label.innerHTML).truncate(30, "..."));
    	}
	});

	var ctr = 0;
	$$("div[name='uploadEnr']").each(function(newDiv){
		ctr++;
		newDiv.setAttribute("itemSeqNo",ctr); 
	});

	$$("div[name='uploadEnr']").each(
			function (newDiv)	{
				newDiv.observe("mouseover", function ()	{
					newDiv.addClassName("lightblue");
				});
				
				newDiv.observe("mouseout", function ()	{
					newDiv.removeClassName("lightblue");
				});

				newDiv.observe("click", function ()	{
					newDiv.toggleClassName("selectedRow");
					if (newDiv.hasClassName("selectedRow"))	{
						$$("div[name='uploadEnr']").each(function (li)	{
							if (newDiv.getAttribute("itemSeqNo") != li.getAttribute("itemSeqNo"))	{
								li.removeClassName("selectedRow");
							}	
						});
						$$("div[name='uploadEnr2']").each(function(row){						
							if (row.getAttribute("uploadNo") != getSelectedRowAttrValue("uploadEnr","uploadNo")){
								row.hide();
							}else{
								row.show();
							}	
						});
						$("createToParDiv").down("label",0).update("Loading data "+getSelectedRowAttrValue("uploadEnr","filename")+" to "+$F("parNo"));
						checkTableItemInfoAdditional("uploadEnrolleesTable2","uploadEnrolleesListing2","uploadEnr2","uploadNo",getSelectedRowAttrValue("uploadEnr","uploadNo"));
						if (getRowCountInTable("uploadEnrolleesTable2","uploadEnr2","uploadNo",getSelectedRowAttrValue("uploadEnr","uploadNo")) < 1){
							$("detailsEmpty").show();
						}else{
							$("detailsEmpty").hide();
						}
					}
				}); 
				
			}	
	);	

	checkTableItemInfo("uploadEnrolleesTable","uploadEnrolleesListing","uploadEnr");
</script>	
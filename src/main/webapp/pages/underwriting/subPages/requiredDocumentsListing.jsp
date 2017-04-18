<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<!-- commented out items for table grid conversion. agazarraga 5-11-2012  -->
<div id="reqDocsDiv" name="reqDocsDiv" class="sectionDiv">
		<div style="width: 100%;  height: 250px; margin: 10px 125px 5px;" id="docsDivTablegrid">
		</div>
		<!-- <div id="reqDocsListingDiv" name="reqDocsListingDiv" style="">
		<div id="searchResultDocs" align="center">
			
			<%-- <jsp:include page="/pages/underwriting/subPages/requiredDocumentsListingTable.jsp"></jsp:include> --%>
		</div> -->
		<br/>
		<div id="selectedDiv" name="selectedDiv">
			<input type="hidden" id="selectedDocCd" name="selectedDocCd"/>
			<input type="hidden" id="selectedDocSw" name="selectedDocSw"/>
			<input type="hidden" id="selectedDateSubmitted" name="selectedDateSubmitted"/>
			<input type="hidden" id="selectedDocName" name="selectedDocName"/>
			<input type="hidden" id="selectedUserId" name="selectedUserId"/>
			<input type="hidden" id="selectedLastUpdate" name="selectedLastUpdate"/>
			<input type="hidden" id="selectedRemarks" name="selectedRemarks"/>
			<input type="hidden" id="currentDate" name="currentDate" value="<fmt:formatDate value="${dateSubmitted}" pattern="MM-dd-yyyy" />"/>
			<input type="hidden" id="defaultUser"	name="defaultUser" value="${defaultUser}"/>
			<input type="hidden" id="selectedDocCd" name="selectedDocCd"/>
			<!-- <input type="hidden" id="docCd" name="docCd"/> -->
		</div>
		<div id="addDocumentContainerDiv" style="padding-top: 30px;">
			<table align="center">
				<tr>
					<td class="rightAligned">Document Name</td>
					<td class="leftAligned" colspan="3">
						<!-- <select name="document" id="document" class="required" style="width: 300px;" tabindex="0"> -->
							<%-- <option value=""></option>
							<c:forEach var="doc" items="${reqDocsListing}">
								<option title="${fn:escapeXml(doc.docName)}" value="${doc.docCd}">${fn:escapeXml(doc.docName)}</option>
							</c:forEach> --%>
						<!-- </select> -->
						<!-- <input type="text" id="txtDocName" class="required" style="display: none; width: 300px;" readonly="readonly"/> -->
						<span class="required lovSpan" style="width: 430px;">
									<input type="hidden" id="docCd" name="docCd"/> 								
									<input type="text" id="document" name="document" readonly="readonly" class="required" style="width: 405px;  float: left; border: medium none; height: 13px; margin: 0pt;" />								
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchDocName" name="searchDocName" alt="Go" style="float: right;"/>
						</span>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 100px;">Date Submitted</td>
					<td class="leftAligned" style="width: 150px;">
						<span class="" style="float: left; width: 165px; border: 1px solid gray;">
							<input style="float: left; width: 130px; border: none;" id="dateSubmitted" name="dateSubmitted" type="text" value="" readonly="readonly" tabindex="1"/>
							<img id="hrefDateSubmitted" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('dateSubmitted'),this, null);" style="margin-left: 10px; margin-top: 2px;" alt="Date Submitted"  />
						</span>
					</td>
					<!-- <td class="rightAligned" style="width: 100px;"></td>
					<td>
					</td>
				</tr>
				<tr>
					<td class="rightAligned"></td> -->
					<td class="leftAligned">
						<input type="checkbox" id="postSwitch" name="postSwitch" value="Y"  style="float: left;" tabindex="2"/>
						<label style="margin-left: 5px;">OK to be Posted?</label>
					</td>
					<td class="rightAligned" style="display: none;">User</td>
					<td class="leftAligned" style="display: none;">
						<input type="text" id="user" name="user" style="width: 100%" value="${defaultUser}" class="required"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Remarks</td>
					<td class="leftAligned" colspan="3">
						<div style="border: 1px solid gray; height: 20px; width: 430px;">
							<textarea id="remarks" class="leftAligned" name="remarks" style="width: 85%; border: none; height: 13px;" tabindex="3"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" />
						</div>
					</td>
				</tr>
				<tr height="12px">
				</tr>
				<tr>
					<td colspan="4" align="center">
						<input type="button" id="btnAddDocument" name="btnAddDocument" class="button" value="Add" style="width: 80px;"/>
						<input type="button" id="btnDeleteDocument" name="btnDeleteDocument" class="disabledButton" value="Delete" style="width: 80px;"/>
					</td>
				</tr>
				<tr height="8px">
				</tr>
			</table>
		</div>
	</div>
</div>

<!-- <script type="text/javaScript">

/* changeCheckImageColor();
disableButton("btnDeleteDocument"); */
/* $("document").observe("change",function(){
	$("docCd").value = $("document").value;
}); */

//initializeTable("tableContainer", "row", "selectedDocCd,selectedDocSw,selectedDateSubmitted", showDocDetails);

/* $("dateSubmitted").observe("blur", function(){
	checkDateSubmitted();
}); */
 
/* $("btnAddDocument").observe("click", function(){
	if (validateBeforeSave()){
		var submittedDateOk	= true;
		if ($("btnAddDocument").value != "Update") {
			submittedDateOk = checkDateSubmitted();
		}
		if (submittedDateOk) {
			var docExists		= false;
			var docCd 			= $("docCd").value;
			var docName			= changeSingleAndDoubleQuotes2($("document").options[$("document").selectedIndex].text);
			var dateSubmitted 	= $("dateSubmitted").value;
			var docSw			= $("postSwitch").checked? "Y": "N";
			var userId			= $("user").value;
			var remarks			= changeSingleAndDoubleQuotes2($("remarks").value);
			var today			= $("currentDate").value;
			if (remarks == "") {
				remarks = "---";
			}
			if (dateSubmitted == ""){
				dateSubmitted = "---";
			}
			$$("div[name='docRow']").each(function(a){
				if ((((a.getAttribute("id")).substring(3))== docCd) && ($("btnAddDocument").value != "Update")) {
					showMessageBox("Required document must be unique", "error");
					docExists = true;
					return false;
				}
			});
			if (!docExists){

				//to add on docForInsertDiv
				var insertDiv = $("docForInsertDiv");
				var insertContent = "<input type='hidden' id='insDocSw"+docCd+"' name='insDocSw"+docCd+"' 		value='"+docSw+"'/>"
					+"<input type='hidden' id='insDateSubmitted"+docCd+"' 	name='insDateSubmitted"+docCd+"' 	value='"+dateSubmitted+"'/>"
					+"<input type='hidden' id='insDocCd"+docCd+"' 			name='insDocCd"+docCd+"' 			value='"+docCd+"'/>"
					+"<input type='hidden' id='insDocName"+docCd+"' 		name='insDocName"+docCd+"' 			value='"+docName+"'/>"
					+"<input type='hidden' id='insUserId"+docCd+"' 			name='insUserId"+docCd+"' 			value='"+userId+"'/>"
					+"<input type='hidden' id='insLastUpdate"+docCd+"' 		name='insLastUpdate"+docCd+"'		value='"+today+"'/>"
					+"<input type='hidden' id='insRemarks"+docCd+"' 		name='insRemarks"+docCd+"' 			value='"+remarks+"'/>"
					+"<input type='hidden' name='insDocCd' value='"+docCd+"'/>";
				insertDiv.insert({bottom : insertContent});
					
				//to add on visible listing
				if ($F("btnAddDocument") == "Update"){
					var oldDocCd = $F("selectedDocCd");
					$("row"+oldDocCd).writeAttribute("id", "row"+docCd);
					$("row"+docCd).writeAttribute("docCd", docCd);
					var content = "<label name='text' style='width: 30%; text-align: left; margin-left: 50px;'>"+docName+"</label>"
		   				+"<label name='text' style='width: 30%; text-align: center;'>"+dateSubmitted+"</label>"
				   		+"<label style='width: 30%; text-align: right;'>";
					if ("Y" == docSw){
						content += "<img name='checkedImg' style='width: 10px; height: 10px; text-align: left; display: block; margin-left: 1px; float: right;'/>";
					} else {
						content += "<span style='float: right; width: 10px; height: 10px;'>-</span>";
					}
		   			content += "</label>"
			   		+"<input type='hidden' id='docSw"+docCd+"' 			name='docSw"+docCd+"' 			value='"+docSw+"'/>"
					+"<input type='hidden' id='dateSubmitted"+docCd+"' 	name='dateSubmitted"+docCd+"' 	value='"+dateSubmitted+"'/>"
					+"<input type='hidden' id='docCd"+docCd+"' 			name='docCd"+docCd+"' 			value='"+docCd+"'/>"
					+"<input type='hidden' id='docName"+docCd+"' 		name='docName"+docCd+"' 		value='"+docName+"'/>"
					+"<input type='hidden' id='userId"+docCd+"' 		name='userId"+docCd+"' 			value='"+userId+"'/>"
					+"<input type='hidden' id='lastUpdate"+docCd+"' 	name='lastUpdate"+docCd+"'		value='"+today+"'/>"
					+"<input type='hidden' id='remarks"+docCd+"' 		name='remarks"+docCd+"' 		value='"+remarks+"'/>"
					+"<input type='hidden' id='docCode' 				name='docCode' 					value='"+docCd+"'/>";
		   			$("row"+docCd).update(content);
		   			changeCheckImageColor();
		   			$("row"+docCd).removeClassName("selectedRow");
				} else { // if add document button
					var newDiv = new Element("div");
					newDiv.setAttribute("id", "row"+docCd);
					newDiv.setAttribute("name", "docRow");
					newDiv.setAttribute("docCd", docCd);
					newDiv.addClassName("tableRow");
					newDiv.setStyle("display: none;");
					var content = "<label name='docText' style='width: 30%; text-align: left; margin-left: 50px;'>"+docName+"</label>"
		   				+"<label name='text' style='width: 30%; text-align: center;'>"+dateSubmitted+"</label>"
		   				+"<label style='width: 30%; text-align: right;'>";
					if ("Y" == docSw){
						content += "<img name='checkedImg' style='width: 10px; height: 10px; text-align: left; display: block; margin-left: 1px; float: right;'/>";
					} else {
						content += "<span style='float: right; width: 10px; height: 10px;'>-</span>";
					}
		   			content += "</label>"
			   		+"<input type='hidden' id='docSw"+docCd+"' 			name='docSw"+docCd+"' 			value='"+docSw+"'/>"
					+"<input type='hidden' id='dateSubmitted"+docCd+"' 	name='dateSubmitted"+docCd+"' 	value='"+dateSubmitted+"'/>"
					+"<input type='hidden' id='docCd"+docCd+"' 			name='docCd"+docCd+"' 			value='"+docCd+"'/>"
					+"<input type='hidden' id='docName"+docCd+"' 		name='docName"+docCd+"' 		value='"+docName+"'/>"
					+"<input type='hidden' id='userId"+docCd+"' 		name='userId"+docCd+"' 			value='"+userId+"'/>"
					+"<input type='hidden' id='lastUpdate"+docCd+"' 	name='lastUpdate"+docCd+"'		value='"+today+"'/>"
					+"<input type='hidden' id='remarks"+docCd+"' 		name='remarks"+docCd+"' 		value='"+remarks+"'/>"
					+"<input type='hidden' id='docCode' 				name='docCode' 					value='"+docCd+"'/>";
					newDiv.update(content);
					$("docsDiv").insert({bottom: newDiv});
					//initializeRows();
					observeReqDocRow(newDiv);
					//$(newDiv).scrollIntoView(false);
				}
				changeCheckImageColor();
				Effect.Appear("row"+docCd, {
					duration: .2,
					afterFinish: function () {
					clearAddDocFields();
					moderateDocOptions();
					checkIfToResizeTable("docsDiv", "docRow");
					checkTableIfEmpty("docRow", "docsDiv");
					trimLabelTexts();
					}
				});
			}
		}
	}}
); */

/* $("btnDeleteDocument").observe("click", function(){
	disableButton("btnDeleteDocument");
	var isSelectedExist = false;
	$$("div[name='docRow']").each(function (row)	{
		if (row.hasClassName("selectedRow"))	{
			isSelectedExist = true;
			var docCd 			= $("docCd").value;
			var deleteDiv 		= $("docForDeleteDiv");
			var deleteContent 	= "<input type='hidden' id='delDocCd"+docCd+"' name='delDocCd"+docCd+"' 		value='"+docCd+"'/>"+
				"<input type='hidden' name='delDocCd' value='"+docCd+"'/>";
			deleteDiv.insert({bottom : deleteContent});
			Effect.Fade(row, {
				duration: .2,
				afterFinish: function ()	{
					row.remove();
					clearAddDocFields();
					clearSelectedDocs();
					moderateDocOptions();
					checkIfToResizeTable("docsDiv", "docRow");
					checkTableIfEmpty("docRow", "docsDiv");
				}
			});
		}
	});
	if (!isSelectedExist) {
		showMessageBox("Please select document to be deleted.", imgMessage.ERROR);
	}
	enableButton("btnDeleteDocument");
}); */


/* 


function moderateDocOptions(){
	$("document").childElements().each(function (o) {
		//o.show(); o.disabled = false;
		showOption(o);
	});

	$("document").childElements().each(function (o) {
		$$("div[name='docRow']").each(function(doc){
			if (doc.getAttribute("docCd") == o.value){
				//o.hide(); o.disabled = true;
				hideOption(o);
			}
		});
	});
}

moderateDocOptions(); */



</script> -->
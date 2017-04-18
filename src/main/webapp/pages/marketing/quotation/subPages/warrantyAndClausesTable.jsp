<!--
Remarks: For deletion
Date : 03-28-2012
Developer: udel
Replacement : /pages/marketing/quotation/quotationWarrCla.jsp
-->
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	response.setHeader("Cache-control", "No-cache");
	response.setHeader("Pragma", "No-cache");
%>
<div class="tableHeader">
	<label style="width: 300px; text-align: center;">Warranty Title</label>
	<label style="width: 150px; text-align: center; padding-left: 5px;">Type</label>
	<label style="width: 70px; text-align: center;">Prt. Seq.</label>
	<label style="width: 200px; text-align: center;">Warranty Text</label>
	<label style="width: 20px; text-align: center;" title="Print">P</label>
	<label style="width: 20px; text-align: center;">C</label>
</div>
<div class="tableContainer" id="wcTableContainerDiv">
<c:forEach var="wc" items="${gipiQuoteWCs}">
	<div id="wc${wc.wcCd}" name="row" class="tableRow" wcCd="${wc.wcCd}">
		<input type="hidden" id="wcCd${wc.wcCd}" 			name="wcCd" 		value="${fn:escapeXml(wc.wcCd)}" />
		<input type="hidden" id="wcTitle${wc.wcTitle}"  	name="wcTitle" 		value="${fn:escapeXml(wc.wcTitle)}" />
		<input type="hidden" id="wcTitle2${wc.wcCd}" 		name="wcTitle2" 	value="${fn:escapeXml(wc.wcTitle2)}" />
		<input type="hidden" id="warrantyType${wc.wcCd}" 	name="warrantyType" value="${fn:escapeXml(wc.wcSw)}" />
		<input type="hidden" id="printSeqNo${wc.wcCd}" 		name="printSeqNo" 	value="${fn:escapeXml(wc.printSeqNo)}" />
		<input type="hidden" id="printSw${wc.wcCd}" 		name="printSw" 		value="${fn:escapeXml(wc.printSw)}" />
		<input type="hidden" id="changeTag${wc.wcCd}" 		name="changeTag" 	value="${fn:escapeXml(wc.changeTag)}" />
		<input type="hidden" id="wcText${wc.wcCd}"			name="wcText" 		value="${fn:escapeXml(wc.wcText)}" />
		<label style="width: 300px; text-align: left; margin-left: 5px;" title="${wc.wcTitle} - ${wc.wcTitle2}" name="title" id="title${wc.wcCd}">${wc.wcTitle} - ${wc.wcTitle2}</label>
		
		<label style="width: 150px; text-align: center;">${wc.wcSw}</label>
   		<label style="width: 70px; text-align: center;">${wc.printSeqNo}
	   		<c:if test="${empty wc.printSeqNo}">
				-
			</c:if>
		</label>
		<label style="width: 203px; text-align: left;" id="text${wc.wcCd}" name="text" title="Click to view complete text.">
			${fn:escapeXml(wc.wcText)}
			<c:if test="${empty wc.wcText}">
			-
			</c:if>
		</label>
		<div style="display: none;">${wc.wcText}</div>
		<label style="width: 20px; text-align: center;">
			<c:choose>
				<c:when test="${'Y' eq wc.printSw}">
					<img name="checkedImg" class="printCheck" style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 1px;" />
				</c:when>
				<c:otherwise>
					<span style="float: left; width: 10px; height: 10px;">-</span>
				</c:otherwise>
			</c:choose>
		</label>
		<label style="width: 20px; text-align: center;">
			<c:choose>
				<c:when test="${'Y' eq wc.changeTag}">
					<img name="checkedImg" style="width: 10px; height: 10px; text-align: left; display: block; margin-left: 1px;" />
				</c:when>
				<c:otherwise>
					<span style="float: left; width: 10px; height: 10px;">-</span>
				</c:otherwise>
			</c:choose>
		</label>
	</div>
</c:forEach>
</div>

<script>
	$$("label[name='text']").each(function (txt) {
		var id = txt.getAttribute("id");
		txt.update($(id).innerHTML.truncate(30, "...")); //to handle non-unique PK's BJGA 12.23.2010
		//$(id).update($(id).innerHTML.truncate(30, "...")); 
	});
	
	$$("div[name='row']").each(
		function (row)	{
			row.observe("mouseover", function () {
				row.addClassName("lightblue");
			});
			
			row.observe("mouseout", function ()	{
				row.removeClassName("lightblue");
			});
		
			row.observe("click", function ()	{
				row.toggleClassName("selectedRow");
				if (row.hasClassName("selectedRow"))	{
					$$("div[name='row']").each(function (r)	{
						if (row.getAttribute("id") != r.getAttribute("id"))	{
							r.removeClassName("selectedRow");
						}
					});
					
					/*--emsy 11.16.2011
					var s = $("warrantyTitle");
					for (var i=0; i<s.length; i++)	{
						if (s.options[i].value==row.down("input", 0).value)	{
							s.selectedIndex = i;
						}
					}

					// added to hide warranty dropdown and make it readonly field
					s.hide(); 
					$("warratyTitleDisplay").value = s.options[s.selectedIndex].text;
					*/
					$("warratyTitleDisplay").show();
					$("hidWcCd").value = row.down("input", 0).value;// emsy 11.29.2011 
					$("warratyTitleDisplay").value =  row.down("input", 1).value; //emsy 11.16.2011
					$("warrantyTitle2").value = row.down("input", 2).value;
					$("warrantyClauseType").value = row.down("input", 3).value;
					$("printSeqNumber").value = row.down("input", 4).value;
					// grace 10.6.10 remove all references to SWC No.	
					//$("swcNo").value = row.down("input", 5).value;
					$("printSwitch").checked = row.down("input", 5).value == "Y" ? true : false;
					$("changeTag").checked = row.down("input", 6).value == "Y" ? true : false;
					$("warrantyText").value = row.down("input", 7).value;
					
					$("btnAdd").value = "Update";
					enableButton("btnDelete");
					//disableSearch("searchWarrantyTitle");//emsy 11.24.2011 
					$("searchWarrantyTitle").hide();//emsy 11.28.2011 
					//$("warrantyTitle").disable();
					//$("btnDelete").enable(); $("btnDelete").removeClassName("disabledButton"); $("btnDelete").addClassName("button");
				}	else	{ 
					//$("warratyTitleDisplay").show(); emsy 11.28.2011 
					$("warratyTitleDisplay").show();
					$("warratyTitleDisplay").clear();
					$("warratyTitleDisplay").hide();
					$("searchWarrantyTitle").show();//emsy 11.16.2011 
					$("hidWcCd").value = "";
					resetWCForm();
				}
				
			});
		}
	);
	
	/*
	$$("label[name='text']").each(function (text)	{
		text.observe("click", function ()	{
			Modalbox.show("<div>"+(text.next()).innerHTML+"</div>", {
				title: "Warranty and Clause Text",
				width: 800
			});
		});
	});
	*/
	
	$$("label[name='title']").each(function (label)	{
		var id = label.getAttribute("id");
		$(id).update($(id).innerHTML.truncate(40, "..."));
	});

	changeCheckImageColor();
	//checkIfWillPrint(); -- grace 10.6.10 not needed anymore since print button is remove from page

	// hides the already selected warranties from the options to 
	//		prevent the user from selecting it again
	/*
	var wcSelOpts = $("warrantyTitle").options;				
	$$("div[name='row']").pluck("id").findAll(function (a) {
		for (var i=0; i<wcSelOpts.length; i++) {
			if (a.substring(2) == wcSelOpts[i].value) {   
				wcSelOpts[i].hide();
			}
		}
	}); */

	resetWCForm();
</script>
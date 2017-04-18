<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 

<%
	response.setHeader("Cache-control", "No-cache");
	response.setHeader("Pragma", "No-cache");
%>
<div class="tableHeader" id="wpolicyWCTable" name="wpolicyWCTable">
	<label style="width: 28%; text-align: left; margin-left: 5px;">Warranty Title</label>
	<label style="width: 11%; text-align: left;">Type</label>
	<label style="width: 8%; text-align: left; margin-right: 15px;">Prt. Seq.</label>
	<label style="width: 42.5%; text-align: left;">Warranty Text</label>
	<label style="width: 3%; text-align: left;">P</label>
	<label style="width: 3%; text-align: left;">C</label>
</div>

<div class="tableContainer" id="wpolicyWCList" name="wpolicyWCList">
	<c:forEach var="wc" items="${gipiWPolicyWCs}">
		<div id="wc${wc.wcCd}" name="row" class="tableRow" origWarrantyText="${wc.wcText1}${wc.wcText2}${wc.wcText3}${wc.wcText4}${wc.wcText5}${wc.wcText6}${wc.wcText7}${wc.wcText8}${wc.wcText9}${wc.wcText10}${wc.wcText11}${wc.wcText12}${wc.wcText13}${wc.wcText14}${wc.wcText15}${wc.wcText16}${wc.wcText17}">
			<input type="hidden" id="wcCd${wc.wcCd}" 		   	name="wcCd" 		    value="${wc.wcCd}" />
			<input type="hidden" id="wcTitle${wc.wcCd}"  	 	name="wcTitle" 			value="${wc.wcTitle}" />
			<input type="hidden" id="wcTitle2${wc.wcCd}" 	 	name="wcTitle2" 		value="${wc.wcTitle2}" />
			<input type="hidden" id="warrantyType${wc.wcCd}" 	name="warrantyType" 	value="${wc.wcSw}" />
			<input type="hidden" id="printSeqNo${wc.wcCd}" 		name="printSeqNo" 		value="${wc.printSeqNo}" />
			<input type="hidden" id="printSw${wc.wcCd}" 	 	name="printSw" 			value="${wc.printSw}" />
			<input type="hidden" id="changeTag${wc.wcCd}" 		name="changeTag" 		value="${wc.changeTag}" />
			<input type="hidden" id="wcText1${wc.wcCd}"			name="wcText1" 			value="${wc.wcText1}" />
			<input type="hidden" id="wcText2${wc.wcCd}"			name="wcText2" 			value="${wc.wcText2}" />
			<input type="hidden" id="wcText3${wc.wcCd}"			name="wcText3" 			value="${wc.wcText3}" />
			<input type="hidden" id="wcText4${wc.wcCd}"			name="wcText4" 			value="${wc.wcText4}" />
			<input type="hidden" id="wcText5${wc.wcCd}"			name="wcText5" 			value="${wc.wcText5}" />
			<input type="hidden" id="wcText6${wc.wcCd}"			name="wcText6" 			value="${wc.wcText6}" />
			<input type="hidden" id="wcText7${wc.wcCd}"			name="wcText7" 			value="${wc.wcText7}" />
			<input type="hidden" id="wcText8${wc.wcCd}"			name="wcText8" 			value="${wc.wcText8}" />
			<input type="hidden" id="wcText9${wc.wcCd}"			name="wcText9" 			value="${wc.wcText9}" />
			<input type="hidden" id="wcText10${wc.wcCd}"		name="wcText10"			value="${wc.wcText10}" />
			<input type="hidden" id="wcText11${wc.wcCd}"		name="wcText11"			value="${wc.wcText11}" />
			<input type="hidden" id="wcText12${wc.wcCd}"		name="wcText12"			value="${wc.wcText12}" />
			<input type="hidden" id="wcText13${wc.wcCd}"		name="wcText13"			value="${wc.wcText13}" />
			<input type="hidden" id="wcText14${wc.wcCd}"		name="wcText14"			value="${wc.wcText14}" />
			<input type="hidden" id="wcText15${wc.wcCd}"		name="wcText15"			value="${wc.wcText15}" />
			<input type="hidden" id="wcText16${wc.wcCd}"		name="wcText16"			value="${wc.wcText16}" />
			<input type="hidden" id="wcText17${wc.wcCd}"		name="wcText17"			value="${wc.wcText17}" />
									
			<label style="width: 28%; text-align: left; margin-left: 5px;" title="${wc.wcTitle} - ${wc.wcTitle2}" name="title" id="title${wc.wcCd}">
				${wc.wcTitle}
				<c:if test="${not empty wc.wcTitle2}">
					- ${wc.wcTitle2}
				</c:if>
			</label>
			
			<label style="width: 11%; text-align: left;">
				${wc.wcSw}
				<c:if test="${empty wc.wcSw}">
					-
				</c:if>
			</label>
	   		
	   		<label style="width: 8%; text-align: left; margin-right: 15px;">
	   			${wc.printSeqNo}
		   		<c:if test="${empty wc.printSeqNo}">
					-
				</c:if>
			</label>
			
			<label style="width: 42%; text-align: left;" id="text${wc.wcCd}" name="text" title="Click to view complete text.">
				${wc.wcText1}${wc.wcText2}
				<c:if test="${empty wc.wcText1}">
					-
				</c:if>
			</label>

			<label style="width: 3%; text-align: left;">
				<c:choose>
					<c:when test="${'Y' eq wc.printSw}">
						<img name="checkedImg" class="printCheck" style="width: 10px; height: 10px; text-align: center; display: block; margin-left: 10px;" />
					</c:when>
					<c:otherwise>
						<span style="float: left; width: 10px; height: 10px; margin-left: 8px;">-</span>
					</c:otherwise>
				</c:choose>
			</label>
			
			<label style="width: 3%; text-align: left;">
				<c:choose>
					<c:when test="${'Y' eq wc.changeTag}">
						<img name="checkedImg" style="width: 10px; height: 10px; text-align: center; display: block; margin-left: 10px;" />
					</c:when>
					<c:otherwise>
						<span style="float: left; width: 10px; height: 10px; margin-left: 8px;">-</span>
					</c:otherwise>
				</c:choose>
			</label>
		</div>
	</c:forEach>
</div>

<script type="text/javascript">
	changeCheckImageColor();
	initializeTable("tableContainer", "row", "", "");
	checkTableIfEmpty("row", "wcDiv");
	checkIfToResizeTable("wpolicyWCList", "row");
	//setModuleId("GIIMM008"); //andrew - 11.22.2010 - commented this line, this must be in the main page of the module not in table listing
	
	$$("label[name='text']").each(function (txt)	{
		var id = txt.getAttribute("id");
		$(id).update($(id).innerHTML.truncate(50, "..."));
	});
	
	$$("label[name='title']").each(function (label)	{
		var id = label.getAttribute("id");
		$(id).update($(id).innerHTML.truncate(35, "..."));
	});

	$$("div[name='row']").each(
		function (row)	{
			row.observe("click", function (){
				if (row.hasClassName("selectedRow"))	{
					setWarrantyAndClauseForm2(row);
				} else	{ 
					setWarrantyAndClauseForm2(null);
				}
			});
		}
	);

	function setWarrantyAndClauseForm2(row){
		//var s = $("inputWarrantyTitle");
		if (row == null){
			//$("inputWarrantyTitle").selectedIndex = 0;
			//s.show();
			//$("warratyTitleDisplay").clear();
			//$("warratyTitleDisplay").hide();
			$("searchWarrantyTitle").show();
			$("txtWarrantyTitle").clear(); 
			$("inputWarrantyTitle2").clear();
			$("inputWarrantyType").clear();
			$("inputPrintSeqNo").clear();
			$("inputPrintSwitch").checked = false;
			$("inputChangeTag").checked = false;
			$("inputWarrantyText").clear();
		} else {
			/* for (var i=0; i<s.length; i++)	{
				if (s.options[i].value == row.down("input", 0).value)	{
					s.selectedIndex = i;
				}
			}
			s.hide(); */
			//$("warratyTitleDisplay").value = s.options[s.selectedIndex].text;
			//$("warratyTitleDisplay").readOnly = true;
			//$("warratyTitleDisplay").show();
			$("searchWarrantyTitle").hide();
			$("hidWcCd").value 				= (row == null ? "" 	 : row.down("input", 0).value);
			$("txtWarrantyTitle").value 	= (row == null ? "" 	 : row.down("input", 1).value); 
			$("inputWarrantyTitle2").value 	= (row == null ? "" 	 : row.down("input", 2).value);
			$("inputWarrantyType").value 	= (row == null ? "" 	 : row.down("input", 3).value);
			$("inputPrintSeqNo").value 		= (row == null ? "" 	 : row.down("input", 4).value);
			$("inputPrintSwitch").checked 	= (row == null ? false : (row.down("input", 5).value == "Y" ? true : false));
			$("inputChangeTag").checked 	= (row == null ? false : (row.down("input", 6).value == "Y" ? true : false));
			$("inputWarrantyText").value 	= (row == null ? "" 	 : row.down("input", 7).value)+(row == null ? "" : row.down("input", 8).value
												  +(row == null ? "" : row.down("input", 9).value)+(row == null ? "" : row.down("input", 10).value)
												  +(row == null ? "" : row.down("input", 11).value)+(row == null ? "" : row.down("input", 12).value)
												  +(row == null ? "" : row.down("input", 13).value)+(row == null ? "" : row.down("input", 14).value)
												  +(row == null ? "" : row.down("input", 15).value));
			$("hidOrigWarrantyText").value = row.readAttribute("origWarrantyText");
		}
	
		$("btnAdd").value 				= (row == null ? "Add" : "Update");

		(row == null ? disableButton("btnDelete") : enableButton("btnDelete"));		
	}
		
</script>
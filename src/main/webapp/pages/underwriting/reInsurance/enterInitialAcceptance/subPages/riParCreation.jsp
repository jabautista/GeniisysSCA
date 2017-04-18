<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="riParCreationDiv">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="outerDiv">
			<label id="">PAR Information</label> 
			<span class="refreshers" style="margin-top: 0;">
			 	<label name="gro" style="margin-left: 5px;">Hide</label> 
			 	<label id="reloadForm" name="reloadForm">Reload Form</label> 
			</span>
		</div>
	</div>
	<div id="riParCreationSectionDiv" class="sectionDiv" style="padding-bottom: 15px; padding-top: 15px;" changeTagAttr="true">
		<table width="80%" align="center" cellspacing="1" border="0">
			<tr>
				<td class="rightAligned" style="width: 20%;">Line of Business </td>
				<td class="leftAligned" style="width: 30%;">
					<select id="linecd" name="linecd" style="width: 99%;" value="${txtLineCd}" class="required">
						<option></option>
						<c:forEach var="line" items="${lineListing}">
							<option value="${line.lineCd}" menuLineCd="${line.menuLineCd}">${line.lineName}</option>				
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 20%;">Issuing Source </td>
				<td class="leftAligned" style="width: 30%;">
					<select id="isscd" name="isscd" style="width: 99%;" disabled="disabled">
						<option></option>
						<c:forEach var="issource" items="${issourceListing}">
							<option value="${issource.issCd}">${issource.issName}</option>				
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned" style="width: 20%;">Year </td>
				<td class="leftAligned" style="width: 30%;">
					<input id="year" class="leftAligned required" type="text" name="year" style="width: 95%;" value="${year}" maxlength="2"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 20%;">PAR Sequence No. </td>
				<td class="leftAligned" style="width: 30%;">
					<input id="inputParSeqNo" class="leftAligned" type="text" name="inputParSeqNo" style="width: 95%;" readonly="readonly" value="${savedPAR.parSeqNo}"/>
				</td>
				<td class="rightAligned" style="width: 20%;">Quote Sequence No. </td>
				<td class="leftAligned" style="width: 30%;">
					<input id="quoteSeqNo" class="leftAligned required" type="text" name="quoteSeqNo" style="width: 95%;" readonly="readonly" value="00"/>
				</td>
			</tr>
			<tr>
				<td id="assdTitle" class="rightAligned" style="width: 20%;">Assured Name </td>
				<td class="leftAligned" style="width: 30%;">
					<span style="border: 1px solid gray; width: 98%; height: 21px; float: left;" class="required"> 
						<input type="text" id="assuredName" name="assuredName" style="border: none; float: left; width: 87%;" class="required" readonly="readonly" /> 
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="btnSearchAssuredName" name="btnSearchAssuredName" alt="Go" />
					</span>	
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width:20%;">Remarks </td>
				<td class="leftAligned" colspan="3" style="width: 80%;">
					<div style="border: 1px solid gray; height: 20px; width: 99%;">
						<textarea id="remarks" class="leftAligned" name="remarks" style="width: 95%; border: none; height: 13px;"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" />
					</div>
				</td>
			</tr>
		</table>
	</div>
</div>

<script type="text/javascript">
	$("btnSearchAssuredName").observe("click", showAssuredListingTG); /* openSearchClientModal);  changed by shan 03.25.2014 */

	$("editRemarks").observe("click", function () {
		showEditor("remarks", 4000);
	});

	$("remarks").observe("keyup", function () {
		limitText(this, 4000);
	});

	function validateBeforeSave(){
		var result = true;
		if ($("linecd").selectedIndex == 0){
			result = false;
			$("linecd").focus();
			showMessageBox("Line of Business is required.", imgMessage.INFO);
		}
		else if ($("isscd").selectedIndex == 0){
			result = false;
			$("isscd").focus();
			showMessageBox("Issuing source is required.", imgMessage.INFO);
		}
		else if ($F("year")==""){
			result = false;
			$("year").focus();
			showMessageBox("Year is required.", imgMessage.INFO);
		} else if (($F("year").include(".")) || ($F("year").include(","))) {
			result = false;
			$("year").focus();
			showMessageBox("Entered Year is invalid. Valid value is from 00 to 99.", imgMessage.INFO);
		}
		else if ((parseFloat($F("year")) < 00) || (parseFloat($F("year")) > 99) || (isNaN($F("year")))){
			result = false;
			$("year").focus();
			showMessageBox("Entered Year is invalid. Valid value is from 00 to 99.", imgMessage.INFO);
		} 
		else if (($F("quoteSeqNo")=="") || ($F("quoteSeqNo")!="00")){
			result = false;
			$("quoteSeqNo").focus();
			showMessageBox("Cannot create new PAR with quote not equal to zero.", imgMessage.INFO);
		}
		else if ($F("assuredNo")==""){
			result = false;
			$("assuredNo").focus();
			showMessageBox("Assured name is required.", imgMessage.INFO);
		}
		return result;
	}

	$("linecd").observe("change", function(){
		$("vlineCd").value = $("linecd").value;
		$("vlineCd").writeAttribute("menuLineCd", $("linecd").options[$("linecd").selectedIndex].getAttribute("menuLineCd")); // andrew - 04.15.2011
		$("tempLineCd").value = $("linecd").value;
		$("vlineName").value = $("linecd").options[$("linecd").selectedIndex].text;
		var oldIssCd = $("vissCd").value;
		var iss 	 = $("isscd");
		hideAllIssourceOptions();
		moderateIssourceOptionsByLine();
		for (var y=0; y<iss.length; y++){
			if (iss[y].value == oldIssCd){
				if (checkLineCdIssCdMatch($F("vlineCd"), iss[y].value)){
					$("isscd").selectedIndex = y;
				} else {
					setIssCdToDefault();
				}
			}
		}
		if ($("linecd").value == objLineCds.SU){
			$("assdTitle").innerHTML = "Principal Name";
		} else {
			$("assdTitle").innerHTML = "Assured Name";
		}
		$("quotationsLoaded").value = "N";
		
	});

	$("year").observe("change", function(){
		if("" == $F("year")){
			showMessageBox( "Year is required.", imgMessage.ERROR);
			$("year").value = $("defaultYear").value;
			return false;
		}
		$("year").value = (parseFloat($F("year"))).toPaddedString(2); 
		var year = $("year").value;
		if(isNaN(year)){
			showMessageBox( "Entered Year is invalid. Valid value is from 00 to 99.", imgMessage.ERROR);
			$("year").value = $("defaultYear").value;
		} else if((year < 0) || (checkIfDecimal2(year))){
			showMessageBox( "Entered Year is invalid. Valid value is from 00 to 99.", imgMessage.ERROR);
			$("year").value = $("defaultYear").value;
		}
	});

	$("isscd").observe("change",function(){
		$("vissCd").value = $("isscd").value;
		var oldLineCd = $("vlineCd").value;
		var line 	  = $("linecd");
		hideAllLineOptions();
		moderateLineOptionsByIssource();
		for (var y=0; y<line.length; y++){
			if (line[y].value == oldLineCd){
				if (checkLineCdIssCdMatch(line[y].value, $F("vissCd"))){
					$("linecd").selectedIndex = y;
				} else {
					$("linecd").selectedIndex = 0;
				}
			}
		}
		if ($("isscd").value == ""){
			showAllLineOptions();
			$("linecd").value = oldLineCd;
			$("vlineCd").value = oldLineCd;
		}
		$("quotationsLoaded").value = "N";
	});
</script>
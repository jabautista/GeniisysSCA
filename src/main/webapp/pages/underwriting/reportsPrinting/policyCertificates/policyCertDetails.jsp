<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<table style="margin-top: 10px; width: 100%;">
	<tr>
		<td class="rightAligned" style="width: 25%;">
			Policy No.
		</td>
		<td class="leftAligned" style="width: 75%;">
			<span class="" style="">
				<input id="txtLineCd" 	 class="leftAligned required" type="text" name="capsField" style="width: 8%;" value="" title="Line Code" maxlength="2"/>
				<input id="txtSublineCd" class="leftAligned" type="text" name="capsField" style="width: 15%;" value="" title="Subline Code"maxlength="7"/>
				<input id="txtIssCd" 	 class="leftAligned" type="text" name="capsField" style="width: 8%;"  value="" title="Issue Source Code"maxlength="2"/>
				<input id="txtIssueYy"   class="leftAligned" type="text" name="intField"  style="width: 8%;"  value="" title="Year" maxlength="2"/>
				<input id="txtPolSeqNo"  class="leftAligned" type="text" name="intField"  style="width: 15%;" value="" title="Policy Sequence Number" maxlength="7"/>
				<input id="txtRenewNo"   class="leftAligned" type="text" name="intField"  style="width: 8%;"  value="" title="Renew Number" maxlength="2"/>
			 	<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchForPolicy" name="searchForPolicy" alt="Go" style="margin-top: 2px;" title="Search Policy"/>
			 </span>
		</td>
	</tr>
	<tr>
		<td class="rightAligned" style="width: 25%;">
			Endorsement No.
		</td>
		<td class="leftAligned" style="width: 75%;">
			<input id="txtCLineCd" 	  class="leftAligned" type="text" name="capsField" style="width: 8%;"  value="" title="Line Code" maxlength="2"/>
			<input id="txtCSublineCd" class="leftAligned" type="text" name="capsField" style="width: 15%;" value="" title="Subline Code" maxlength="7"/>
			<input id="txtCEndtIssCd" class="leftAligned" type="text" name="capsField" style="width: 8%;"  value="" title="Endorsement Issue Source Code" maxlength="2"/>
			<input id="txtEndtYy"     class="leftAligned" type="text" name="intField"  style="width: 8%;"  value="" title="Endorsement Year" maxlength="2"/>
			<input id="txtEndtSeqNo"  class="leftAligned" type="text" name="intField"  style="width: 15%;" value="" title="Endorsement Sequence Number" maxlength="7"/>
		</td>
	</tr>
	<tr>
		<td class="rightAligned" style="width: 25%;">
			PAR No.
		</td>
		<td class="leftAligned" style="width: 75%;">
			<input id="parNo" class="leftAligned" type="text" name="capsField" style="width: 80%;" readonly="readonly" value=""/>
		</td>
	</tr>
	<tr>
		<td class="rightAligned" style="width: 25%;">
			Assured Name
		</td>
		<td class="leftAligned" style="width: 75%;">
			<input id="assdName" class="leftAligned" type="text" name="capsField" style="width: 80%;" readonly="readonly" value=""/>
		</td>
	</tr>
	<tr>
		<td colspan="2"></td>
	</tr>
</table>
<div>
	<input type="hidden" id="printerNames" value="${printerNames}">
	<input type="hidden" id="policyId" name="policyId" value="">
	<input type="hidden" id="lineCd" name="lineCd" value="">
	<input type="hidden" id="menulineCd" name="menulineCd" value="">
</div>

<script type="text/javascript">

	$("searchForPolicy").observe("click", function(){
		if ("" != $F("txtLineCd")){
			showPolicyListingForCertPrinting();
		} else {
			showWaitingMessageBox("Line code is required.", imgMessage.ERROR, function(){
					$("txtLineCd").focus();
				});
		}
	});

	$$("input[name='capsField']").each(function(field){
		field.observe("keyup", function(){
			field.value = field.value.toUpperCase();
		});
	});

	$("txtPolSeqNo").observe("blur", function(){
		if ($F("txtPolSeqNo")!= ""){
			if (!(isNaN($F("txtPolSeqNo")))){
				$("txtPolSeqNo").value = parseInt($F("txtPolSeqNo")).toPaddedString(7);
			}
		}
	});

	$("txtRenewNo").observe("blur", function(){
		if ($F("txtRenewNo")!= ""){
			if (!(isNaN($F("txtRenewNo")))){
				$("txtRenewNo").value = parseInt($F("txtRenewNo")).toPaddedString(2);
			}
		}
	});
	
</script>
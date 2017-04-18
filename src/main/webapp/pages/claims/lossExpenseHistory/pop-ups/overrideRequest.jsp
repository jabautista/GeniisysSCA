<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="overrideRequestMainDiv" style="width: 99.5%; padding-top: 5px; float: left;" align="center">
	<div class="sectionDiv" style="float: left;" id="overrideRequestFormDiv">
		<input type="hidden" id="hidReqExists" name="hidReqExists" value="${reqExists}"/>
		<input type="hidden" id="hidCanvas"    name="hidCanvas"    value="${canvas}"/>
		<table align="center" style="padding: 10px;">
			<tr>
				<td class="rightAligned">Override Request&nbsp;</td>
				<td class="leftAligned">
					<input type="text" id="txtOverrideRequestDtl" style="float: left; width: 300px;" class="" value="${functionName}" readonly="readonly">					
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Remarks&nbsp;</td>
				<td class="leftAligned">
					<span id="overrideRequestRemarksSpan" style="border: 1px solid gray; width: 306px; height: 21px; float: left;"> 
						<input type="text" id="txtOverrideRequestRemarks" name="txtOverrideRequestRemarks" style="border: none; float: left; width: 91.5%; background: transparent;" maxlength="4000"/> 
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" id="btnOverrideRequestRemarks" name="btnOverrideRequestRemarks" alt="Edit" style="background: transparent; width: 14px; height: 14px; margin: 3px; float: right;"/>
					</span>
				</td>
			</tr>
		</table>
	</div>
	<div id="buttonsDiv" style="float: left; width: 100%; margin-top: 20px; margin-bottom: 5px;">
		<input type="button" class="button" id="btnCreateRequest" name="btnCreateRequest" value="Create Request" style="width: 120px;">
		<input type="button" class="button" id="btnCancel" name="btnCancel" value="Cancel" style="width: 120px;">		
	</div>	
</div>
<script type="text/javascript">
	$("btnCancel").observe("click", function(){
		overlayOverrideRequest.close();
		delete overlayOverrideRequest;
	});
	
	$("btnCreateRequest").observe("click", function(){
		var requestExists = $("hidReqExists").value;
		var canvas = $("hidCanvas").value;
		
		if(canvas == "LOA"){
			checkLOAOverrideRequestExist(objCurrLoa, requestExists, canvas);
		}else if(canvas == "CSL"){
			checkLOAOverrideRequestExist(objCurrCsl, requestExists, canvas);
		}
	});
	
	$("btnOverrideRequestRemarks").observe("click", function(){
		showOverlayEditor("txtOverrideRequestRemarks", 4000, $("txtOverrideRequestRemarks").hasAttribute("readonly"));
	});
</script>
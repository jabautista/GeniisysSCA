<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div id="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" >
   		<label>Other Information</label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label name="gro" id="lblHideOtherInformation" style="margin-left: 5px;">Hide</label>
   		</span>
   	</div>
</div>

<div id="otherInformationDiv" class="sectionDiv">
	<table align="center" style="margin: 10px auto;">
		<tr>
			<td class="rightAligned" style="width: 100px;">
				Remarks </td> 
			<td class="leftAligned" colspan="3">
				<div style="border: 1px solid gray; height: 20px;">
					<textarea id="remarks" name="remarks" style="width: 520px; border: none; height: 13px;" tabindex="34">${assured.remarks}</textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" />
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">
				User ID </td>
			<td class="leftAligned">
				<input type="text" id="userId2" name="userId2" style="width: 210px;  display:none;" readonly="readonly"/> <!-- added by steven 8/24/2012 -->
				<input type="text" id="userId" name="userId" style="width: 210px;" readonly="readonly" 
				<c:choose>
					<c:when test="${not empty assured}">
						value="${assured.userId}"
					</c:when>
					<c:otherwise>
						value="${PARAMETERS['USER'].userId}"
					</c:otherwise>
				</c:choose>
				tabindex="35" /></td>
			<td class="rightAligned" style="width: 100px;">
				Last Update:</td>
			<td class="leftAligned">
				<input type="text" id="lastUpdate2" name="lastUpdate2" style="width: 210px; display:none;" readonly="readonly"/> <!-- added by steven 8/24/2012 -->
				<input type="text" id="lastUpdate" name="lastUpdate" style="width: 210px;" readonly="readonly" 
				<c:choose>
					<c:when test="${not empty assured}">
						value="<fmt:formatDate pattern="MM-dd-yyyy hh:mm:ss a" value="${assured.lastUpdate}" />"
					</c:when>
					<c:otherwise>
						value="<fmt:formatDate pattern="MM-dd-yyyy hh:mm:ss a" value="<%= new java.util.Date() %>" />"
					</c:otherwise>
				</c:choose>
				tabindex="36" /></td>
		</tr>
	</table>
</div>

<script type="text/JavaScript">
	$("editRemarks").observe("click", function () {
		showOverlayEditor("remarks", 4000, $("remarks").hasAttribute("readonly"), function(){
			changeTag = 1;
		});
	});
	
	$("remarks").observe("keyup", function () {
		limitText(this, 4000);
	});
</script>
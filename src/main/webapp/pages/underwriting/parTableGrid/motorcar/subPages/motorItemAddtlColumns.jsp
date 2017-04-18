<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
				String displayCOCAddtlCols = "";
				try {
					Class.forName("com.isap.api.COCRegistration", false, this.getClass().getClassLoader());
					displayCOCAddtlCols = "table-row";
				}catch (Exception e)
				{
					displayCOCAddtlCols = "none";
				}
				
				request.setAttribute("isDisplayed", displayCOCAddtlCols);
%>

<tr style="display:${isDisplayed};">
	<td class="rightAligned" style="width: 120px;">Registration Type</td>
	<td class="leftAligned">
		<select tabindex="2009" id="regType" name="regType" style="width: 181px;">
				<option value=""></option>
				<c:forEach var="regType" items="${regTypeListing}" >
					<option value="${regType.rvLowValue}">${regType.rvMeaning}</option>
				</c:forEach>
		</select>
	</td>
	<td class="rightAligned">MV Type</td>
	<td class="leftAligned">
		<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">
			<input type="hidden" name="mvType" id="mvType" value="" />
			<input type="text" tabindex="2009" style="float: left; margin-top: 0px; margin-right: 3px; width: 150px; border: none;"	name="mvTypeDesc" id="mvTypeDesc" readonly="readonly" value="" />
			<img id="hrefMvType" alt="goMvType" style="height: 18px;" class="hover"	src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />
		</div>
	</td>
	<td class="rightAligned">MV Prem Type</td>
	<td class="leftAligned">
		<div style="float: left; border: solid 1px gray; width: 179px; height: 21px; margin-right: 3px;">
			<input type="hidden" name="mvPremType" id="mvPremType" value="" />
			<input type="text" tabindex="2009" style="float: left; margin-top: 0px; margin-right: 3px; width: 150px; border: none;"	name="mvPremTypeDesc" id="mvPremTypeDesc" readonly="readonly" value="" />
			<img id="hrefMvPremType" alt="goMvPremType"	style="height: 18px;" class="hover"	src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />
		</div>
	</td>
</tr>


<script>

$("hrefMvType").observe("click", showMvTypeLOV);
$("hrefMvPremType").observe("click", function(){
	if($F("mvTypeDesc").trim() == ""){
		showMessageBox("Please enter MV Type first.", "I");
	} else {
		showMvPremTypeLOV($("mvType").value);
	}
});

$("mvTypeDesc").observe("keyup", function(event) {
	if(event.keyCode == 46){
		$("mvPremType").value = "";
		$("mvPremTypeDesc").value = "";
		$("mvType").value = "";
	}
});

$("mvPremTypeDesc").observe("keyup", function(event) {
	if(event.keyCode == 46){
		$("mvPremType").value = "";
	}
});
</script>
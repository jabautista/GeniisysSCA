<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="soaRemarksMainDiv" name="soaRemarksMainDiv">
	<div id="soaRemarksFieldDiv" name="soaRemarksFieldDiv" class="sectionDiv" style="width:350px; height:150px; margin: 20px 10px 10px 10px;" >
		<form >
			<textarea id="textSOARemarks" name="textSOARemarks" value="" style="float:left;width:300px; border:none; height:130px; resize:none;" maxlength="2000" ></textarea>
		</form>
	</div>
	
	<div id="soaRemarksButtonDiv" name="soaRemarksButtonDiv" class="buttonsDiv" style="margin-bottom: 2px;">
		<input type="button" class="button" id="btnReturn" name="btnReturn" value="Return" style="width:90px;" />
	</div>
</div>

<script type="text/javascript">
	if(objSOA.remarksUpdated == null){
		$("textSOARemarks").value = unescapeHTML2('${soaRemarks}');
	} else if(objSOA.remarksUpdated == 1){
		$("textSOARemarks").value = unescapeHTML2(objSOA.remarks);
	}
	
	$("textSOARemarks").observe("change", function(){
		objSOA.remarks = escapeHTML2($F("textSOARemarks"));
		objSOA.remarksUpdated = 1;
	});
	
	$("btnReturn").observe("click", function(){
		overlayRemarks.close();
	});
</script>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div class="sectionDiv">
	<div id="particularsDtlsDiv" style="margin-left: 130px; margin-top: 5px;" changeTagAttr="true">
		<table>
			<tr>
				<td class="rightAligned">Payor</td>
				<td class="leftAligned" colspan="3"><input style="float: left; width: 580px;" type="text" class="" id="txtParticularsPayor" name="txtParticularsPayor" maxlength="150" tabindex="301"/></td>				
			</tr>
			<tr>
				<td class="rightAligned">Address</td>
				<td class="leftAligned" colspan="3"><input style="float: left; width: 580px;" type="text" class="" id="txtAddress1" name="txtAddress1" maxlength="50" tabindex="302"/></td>
			</tr>
			<tr>
				<td class="rightAligned"></td>
				<td class="leftAligned" colspan="3"><input style="float: left; width: 580px;" type="text" class="" id="txtAddress2" name="txtAddress2" maxlength="50"  tabindex="303"/></td>				
			</tr>
			<tr>
				<td class="rightAligned"></td>
				<td class="leftAligned" colspan="3"><input style="float: left; width: 580px;" type="text" class="" id="txtAddress3" name="txtAddress3" maxlength="50"  tabindex="304"/></td>		
			</tr>
			<tr>
				<td class="rightAligned">TIN No.</td>
				<td class="leftAligned"><input style="float: left; width: 151px;" type="text" class="" id="txtTinNo" name="txtTinNo" maxlength="30"  tabindex="305"/></td>
				<td class="rightAligned">&nbsp;&nbsp;Intermediary</td>
				<td class="leftAligned">
					<span class="lovSpan" style="width: 332px; margin-right: 30px;">
						<input type="hidden" id="hidIntmNo" name="hidIntmNo">
						<input type="text" id="txtIntermediary" name="txtIntermediary" style="width: 305px; float: left; border: none; height: 14px; margin: 0;" class="" readonly="readonly" tabindex="306"></input>  
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIntm" name="searchIntm" alt="Go" style="float: right;"/>
					</span>				
					<!-- <input style="float: left; width: 334px;" type="text" class="" id="txtIntermediary" name="txtIntermediary" maxlength="240"  tabindex="306"/> -->
				</td>				
			</tr>	
			<tr>
				<td class="rightAligned">Particulars</td>
				<td class="leftAligned" colspan="3">
					<div id="particularsDtlDiv" name="particularsDtlDiv" style="float: left; width: 586px; border: 1px solid gray;"/>
						<!-- marco - replaced with textarea to handle next line -->
						<!-- <input style="float: left; height: 12px; width: 95%; margin-top: 1px; border: none;" type="text" id="txtParticularsDtl" name="txtParticularsDtl" maxlength="500"  tabindex="307"/> -->
						<textarea id="txtParticularsDtl" name="txtParticularsDtl" style="width: 95%; border: none; height: 12px; margin-top: 1px; resize: none;" maxlength="500"/></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="EditParticulars" id="editParticularsDtlText" />
					</div>
				</td>
			</tr>
		</table>
	</div>
	<div style="margin: 10px; float: left; width: 100%;" align="center">
		<input type="button" class="button" id="btnPdcAdd" name="btnPdcAdd" value="Add" enValue="Add" tabindex="308"/>		
		<input type="button" class="button" id="btnPdcDelete" name="btnPdcDelete" value="Delete" enValue="Delete" tabindex="309"/>		
		<input type="button" class="button" value="Replace" id="btnPdcReplace" name="btnPdcReplace" enValue="Replace" tabindex="310"/>
		<input type="button" class="button" id="btnPdcCancel" name="btnPdcCancel" value="Cancel" enValue="Cancel" tabindex="311"/>
	</div>
</div>
<script>
	$("editParticularsDtlText").observe("click", function (){
		showOverlayEditor("txtParticularsDtl", 500, $("txtParticularsDtl").hasAttribute("readonly"));
	});
</script>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="overlayEditorMainDiv" style="margin-top: 10px; margin-bottom: 10px; float: left; width: 99%;">
	<div id="editorDiv">			
		<textarea id="textarea" name="textarea" rows="" cols="" style="width: 589px; height: 285px; font-size: 10px;" <c:if test="${'true' eq readonly}">readonly="readonly"</c:if>>${initialValue}</textarea>
	</div>
</div>
<div id="buttonsDiv" style="float: left; width: 100%;">
	<table align="center">
		<tr>
			<td>
				<input type="button" class="button" style="width: 90px;" id="btnOk" name="btnOk" value="Ok" />
				<input type="button" class="button" style="width: 90px;" id="btnCancel" name="btnCancel" value="Cancel" />
			</td>
		</tr>
	</table>
</div>	
<script type="text/javascript">
	$("textarea").style.fontFamily = textEditorFont;
	ojbGlobalTextArea.origValue = $F("textarea"); //added by fons to restore the original value in textarea 10.21.2013
	var charLimit = parseInt("${charLimit}");
	var textId = "${textId}";
	$("textarea").observe("keyup", function () {
		limitText(this, charLimit);
	});
	var editorChangeTag = 0;
	$("textarea").observe("change", function () {
		editorChangeTag = 1;
	});
	
	$("btnCancel").observe("click", function(){
		overlayEditor.close();
		$(textId).focus();
		$(textId).setSelectionRange(0, 0);
	});

	$("btnOk").observe("click", function(){
		if (editorChangeTag == 1){
			if (funcHolder.onChangeFunc != null || nvl(funcHolder.onChangeFunc,"") != ""){
				funcHolder.onChangeFunc();
			}
		}
		$(textId).value = $("textarea").value;		
		overlayEditor.close();
		$(textId).focus();
		$(textId).scrollTop = 1;
		$(textId).setSelectionRange(0, 0); // Added by J. Diago - Para mapunta yung cursor sa unahan ng textarea. 09.09.2013
	});
	
	$("textarea").focus();
</script>
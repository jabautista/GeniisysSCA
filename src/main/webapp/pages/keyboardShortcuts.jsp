<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="keyboardShortcutsMainDiv" style="width: 99.5%; padding-top: 5px; float: left;" align="center">
	<div class="sectionDiv" style="float: left; height: 350px;" id="">
		<div style="float: left; margin: 10px 10px 0 10px;">
			<table border="1" cellspacing="0">
				<tr style="background-color: #F0F0F0;">
					<th style="width: 100px; height: 20px;">
						Shortcut
					</th>
					<th style="width: 440px;">
						Functionality
					</th>
				</tr>
			</table>
		</div>
		<div style="float: left; margin: 0 10px 10px 10px; height: 300px; overflow-y: scroll;">
			<table border="1" cellspacing="0">
				<tr>
					<td align="center" style="width: 103px;">
						F9
					</td>
					<td style="padding: 3px; width: 420px;">
						Displays List of Values (LOV) of the field which has the focus.
					</td>					
				</tr>
				<tr>
					<td align="center">
						L
					</td>
					<td style="padding: 3px;">
						Displays List of Values (LOV) of the element in focus.
					</td>					
				</tr>
				<tr>
					<td align="center">
						L
					</td>
					<td style="padding: 3px;">
						Displays List of Values (LOV) of the element in focus.
					</td>					
				</tr>
				<tr>
					<td align="center">
						L
					</td>
					<td style="padding: 3px;">
						Displays List of Values (LOV) of the element in focus.
					</td>					
				</tr>				
			</table>
		</div>
	</div>
	<div id="buttonsDiv" style="float: left; width: 100%; margin-top: 10px; margin-bottom: 5px;">
		<input type="button" class="button" id="btnClose" name="btnClose" value="Close" style="width: 80px;">	
	</div>	
</div>
<script type="text/javascript">
	$("btnClose").observe("click", function(){
		ovlKeyboardShortcuts.close();
		delete ovlKeyboardShortcuts;
	});
</script>
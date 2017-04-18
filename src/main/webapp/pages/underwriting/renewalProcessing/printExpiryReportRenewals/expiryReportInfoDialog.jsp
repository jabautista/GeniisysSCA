<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="infoDialogMainDiv" style="width: 99.5%; padding-top: 5px; float: left;" align="center">
	<div class="sectionDiv" style="float: left;" id="infoDialogFormDiv">
		<table id="infoDialogMainTab" name="infoDialogMainTab" align="center" style="padding: 10px;">
			<tr>
				<td class="leftAligned">Contact Number :</td>
				<td class="rightAligned">
					<input id="telNo1" type="text"/>
				</td>
			</tr>
			<tr>
				<td></td>
				<td class="rightAligned">
					<input id="telNo2" type="text"/>
				</td>
			</tr>
			<tr>
				<td></td>
				<td class="rightAligned">
					<input id="telNo3" type="text"/>
				</td>
			</tr>
			<tr>
				<td></td>
				<td class="rightAligned">
					<input id="telNo4" type="text"/>
				</td>
			</tr>
			<tr>
				<td class="leftAligned">Sales Assistants :</td>
				<td class="rightAligned">
					<input id="salesAsst1" type="text"/>
				</td>
			</tr>
			<tr>
				<td></td>
				<td class="rightAligned">
					<input id="salesAsst2" type="text"/>
				</td>
			</tr>
			<tr>
				<td></td>
				<td class="rightAligned">
					<input id="salesAsst3" type="text"/>
				</td>
			</tr>
		</table>
		<div id="buttonsDiv" style="float: left; width: 100%; margin-top: 0px; margin-bottom: 5px;">
			<input type="button" class="button" id="btnOk" name="btnOk" value="Ok" style="width: 80px;">
			<input type="button" class="button" id="btnCancel" name="btnCancel" value="Cancel">		
		</div>
	</div>
</div>
<script type="text/javascript">
try{
	objGiexs006.dialog = "info";
	
	$("telNo2").disable();
	$("telNo3").disable();
	$("telNo4").disable();
	$("salesAsst2").disable();
	$("salesAsst3").disable();
	
	$("telNo1").observe("keyup", function(){
		if($F("telNo1") != ""){
			$("telNo2").enable();
		}else{
			$("telNo2").disable();
			$("telNo3").disable();
			$("telNo4").disable();
			$("telNo2").clear();
			$("telNo3").clear();
			$("telNo4").clear();
		}
	});
	
	$("telNo2").observe("keyup", function(){
		if($F("telNo2") != ""){
			$("telNo3").enable();
		}else{
			$("telNo3").disable();
			$("telNo4").disable();
			$("telNo3").clear();
			$("telNo4").clear();
		}
	});
	
	$("telNo3").observe("keyup", function(){
		if($F("telNo3") != ""){
			$("telNo4").enable();
		}else{
			$("telNo4").disable();
			$("telNo4").clear();
		}
	});
	
	$("salesAsst1").observe("keyup", function(){
		if($F("salesAsst1") != ""){
			$("salesAsst2").enable();
		}else{
			$("salesAsst2").disable();
			$("salesAsst3").disable();
			$("salesAsst2").clear();
			$("salesAsst3").clear();
		}
	});
	
	$("salesAsst2").observe("keyup", function(){
		if($F("salesAsst2") != ""){
			$("salesAsst3").enable();
		}else{
			$("salesAsst3").disable();
			$("salesAsst3").clear();
		}
	});
	
	$("btnCancel").observe("click", function(){
		overlayExpiryReportInfoDialog.close();
	});

	$("btnOk").observe("click", function(){
		setGiexs006Params();
	});
}catch(e){
	showErrorMessage("expiryReportInfoDialog page",e);
}
</script>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="ajax" uri="http://ajaxtags.org/tags/ajax" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="premWarrLetterMainDiv">
	<div class="sectionDiv" style="margin-top: 10px; width: 623px;">
		<table border="0" align="center" style="margin-top: 5px; margin-bottom: 5px;">
			<tr>
				<td class="leftAligned" style="width: 80px;">Address</td>	
				<td class="leftAligned" > <input type="text" id="nbtMail1" name="nbtMail1" style="width: 487px;" maxlength="50"></td>
			</tr>
			<tr>
				<td class="leftAligned" ></td>	
				<td class="leftAligned" > <input type="text" id="nbtMail2" name="nbtMail2" style="width: 487px;" maxlength="50"></td>
			</tr>
				<td class="leftAligned" ></td>	
				<td class="leftAligned" > <input type="text" id="nbtMail3" name="nbtMail3" style="width: 487px;" maxlength="50"></td>
			</tr>
		</table>
		<table border="0" align="center" style="margin-bottom: 5px;">
			<tr>
				<td class="leftAligned" style="width: 80px;">Attention</td>	
				<td class="leftAligned" > <input type="text" id="nbtAttn" name="nbtAttn" style="width: 297px;" maxlength="240"></td>
				<td class="leftAligned" >
					<input type="button" id="btnPremWarrLetterPrint" name="btnPremWarrLetterPrint" style="width: 90px; float: left; margin-left: 5px;" class="button hover"   value="Print" />
					<input type="button" id="btnPremWarrLetterExit" name="btnPremWarrLetterExit" style="width: 90px; float: left; margin-left: 3px;" class="button hover"   value="Return" />
				</td>
			</tr>
		</table>
	</div>
</div>
<script type="text/javascript">
	var premWarrLetter = JSON.parse('${premWarrLetter}'.replace(/\\/g, '\\\\'));
	
	function supplyPremWarrLetter(obj){
		if (nvl(obj.msgAlert,null) != null){
			showMessageBox(obj.msgAlert, "E");
			disableButton("btnPremWarrLetterPrint");
			return false;
		}	
		$("nbtMail1").value = unescapeHTML2(obj.nbtMail1);
		$("nbtMail2").value = unescapeHTML2(obj.nbtMail2);
		$("nbtMail3").value = unescapeHTML2(obj.nbtMail3);
		$("nbtAttn").value = unescapeHTML2(obj.nbtAttn);
	}
	
	supplyPremWarrLetter(premWarrLetter);
	
	$("btnPremWarrLetterExit").observe("click", function(){
		Windows.close("prem_warr_letter_view");	
	});
	
	function onPrintPremWarr(){
		try{
			
			var content = contextPath+"/PrintPremWarrLetterController?action=populateGiclr010"
				+"&noOfCopies="+$F("txtNoOfCopies")+"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination")
				+"&policyId="+nvl(objCLM.basicInfo.policyId, "")
				+"&claimId="+nvl(objCLM.basicInfo.claimId, "")
				+"&address1="+encodeURIComponent(escapeHTML2($F("nbtMail1")))//encodeURIComponent and escapeHTML2 added by jeffdojello 05.10.2013
				+"&address2="+encodeURIComponent(escapeHTML2($F("nbtMail2")))//encodeURIComponent and escapeHTML2 added by jeffdojello 05.10.2013
				+"&address3="+encodeURIComponent(escapeHTML2($F("nbtMail3")))//encodeURIComponent and escapeHTML2 added by jeffdojello 05.10.2013
				+"&attention="+encodeURIComponent(escapeHTML2($F("nbtAttn")))//encodeURIComponent and escapeHTML2 added by jeffdojello 05.10.2013
				+"&balanceAmtDue="+nvl(objCLM.variables.balanceAmtDue,"")
				+"&clmFileDate="+objCLM.basicInfo.strClaimFileDate
				+"&claimNo="+nvl(objCLM.basicInfo.claimNo, "");	

			printGenericReport(content, "GICLR010-"+nvl(objCLM.basicInfo.claimNo, ""));
		}catch(e){
			showErrorMessage("onPrintPremWarr", e);	
		}	
	}	
	
	$("btnPremWarrLetterPrint").observe("click", function(){
		showGenericPrintDialog("Print", onPrintPremWarr, '');
	});

</script>
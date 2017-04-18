<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="bondDetailsDiv2" name="bondDetailsDiv2" class="sectionDiv" style="border: none; margin: 0px;" changeTagAttr="true">
	<table border="0" style="margin: auto; margin-top: 10px; margin-bottom: 10px;">
		<tr>
			<td class="rightAligned" style="width: 120px;">Bond Amount :</td>
			<td class="leftAligned">
				<input type="text" id="txtBondAmt" name="txtBondAmt" value="" style="width: 250px; text-align: right;" readonly="readonly">
			</td>
			<td class="rightAligned" style="width: 120px;">Premium Amount :</td>
			<td class="leftAligned">
				<input type="text" id="txtPremAmt" name="txtPremAmt" value="" style="width: 200px; text-align: right;" readonly="readonly">
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 120px;">Bond Rate :</td>
			<td class="leftAligned">
				<input type="text" id="txtBondRate" name="txtBondRate" value="" style="width: 250px; text-align: right;" readonly="readonly">
			</td>
			<td class="rightAligned" style="width: 120px;">Tax Amount :</td>
			<td class="leftAligned">
				<input type="text" id="txtTaxAmt" name="txtTaxAmt" value="" style="width: 200px; text-align: right;" readonly="readonly">
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 120px;">Pay't Terms :</td>
			<td class="leftAligned">
				<input type="text" id="txtPaytTerms" name="txtPaytTerms" value="" style="width: 250px;" readonly="readonly">
			</td>
			<td class="rightAligned" style="width: 120px;">Notarial Fee :</td>
			<td class="leftAligned">
				<input type="text" id="txtNotarialFee" name="txtNotarialFee" value="" style="width: 200px; text-align: right;" readonly="readonly">
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 120px;">Invoice No :</td>
			<td class="leftAligned">
				<input type="text" id="txtInvoiceNo" name="txtInvoiceNo" value="" style="width: 250px;" readonly="readonly">
			</td>
			<td class="rightAligned" style="width: 120px;">Total Amount Due :</td>
			<td class="leftAligned">
				<input type="text" id="txtTotalAmtDue" name="txtTotalAmtDue" value="" style="width: 200px; text-align: right;" readonly="readonly">
			</td>
		</tr>
		<tr id = "riCommRt" style = "diplay: none;"> <!-- Modified by Jerome Bautista 08.10.2015 SR 19824 -->
			<td class="rightAligned" style="width: 120px;"></td>
			<td class="leftAligned">
			</td>
			<td class="rightAligned" style="width: 120px;"><label id="txtRiStat" name="txtRiStat" style="width: 120px; text-align: right;"></label></td>
			<td class="leftAligned">
				<input type="text" id="txtRiComm" name="txtRiComm" value="" style="width: 200px; text-align: right;" readonly="readonly">
			</td>
		</tr>
		<!-- START hdrtagudin 07232015 SR19824 -- added additional fields -->
		<tr id = "riCommAmt" style = "display:none;">
			<td class="rightAligned" style="width: 120px;"></td>
			<td class="leftAligned">
			</td>
			<td class="rightAligned" style="width: 120px;">RI Comm. Amount :</td>
			<td class="leftAligned">
				<input type="text" id="txtRiCommAmt" name="txtRiCommAmt" value="" style="width: 200px; text-align: right;" readonly="readonly">
			</td>
		</tr>
		<tr id = "riCommVat" style = "display:none;">
			<td class="rightAligned" style="width: 120px;"></td>
			<td class="leftAligned">
			</td>
			<td class="rightAligned" style="width: 120px;">RI Comm. VAT :</td>
			<td class="leftAligned">
				<input type="text" id="txtRiCommVat" name="txtRiCommVat" value="" style="width: 200px; text-align: right;" readonly="readonly">
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 120px;">Remarks :</td>
			<td class="leftAligned" colspan="5">
				<textarea id="txtRemarks" readonly="readonly" name="remarks" style="width: 615px; height: 30px; float: left; resize: none;" onkeyup="limitText(this, 2000);" onkeydown="limitText(this, 2000);"></textarea>
				<img id="textRemarks" class="hover" alt="EditItemDesc" style="width: 14px; height: 14px; margin: 3px; float: left;" src="${pageContext.request.contextPath}/images/misc/edit.png">
			</td>
			
		</tr>
		<!-- END hdrtagudin 07232015 SR 19824-->
	</table>
</div>
<script type="text/javascript">
		initializeAccordion();
		var bondDetails = new Object();
		bondDetails = JSON.parse('${bondDetails}'.replace(/\\/g,'\\\\'));
		populateDetails(bondDetails);
		
function populateDetails(obj){
	$("txtBondAmt").value  		= (obj == null ? "" : formatCurrency(nvl(obj.rows[0].bondTsiAmt,"")));
	$("txtPremAmt").value  		= (obj == null ? "" : formatCurrency(nvl(obj.rows[0].premAmt,"")));
	$("txtBondRate").value 		= (obj == null ? "" : formatCurrency(nvl(obj.rows[0].bondRate,""))); 
	$("txtTaxAmt").value   		= (obj == null ? "" : formatCurrency(nvl(obj.rows[0].taxAmt,"")));
	$("txtPaytTerms").value 	= (obj == null ? "" : unescapeHTML2(nvl(obj.rows[0].paytTerms,"")));
	$("txtNotarialFee").value 	= (obj == null ? "" : formatCurrency(nvl(obj.rows[0].notarialFee,"")));
	$("txtInvoiceNo").value		= (obj == null ? "" : nvl(obj.rows[0].issCd,"") +" "+ nvl(obj.rows[0].premSeqNo,"") + " / " + nvl(obj.rows[0].refInvNo,""));
	$("txtTotalAmtDue").value	= (obj == null ? "" : formatCurrency(nvl(obj.rows[0].totalAmtDue,"")));
	$("txtRiComm").value		= (obj == null ? "" : formatCurrency(nvl(obj.rows[0].riCommRate,"")));
	//hdrtagudin 07232015 SR 19824 
	$("txtRiCommAmt").value		= (obj == null ? "" : formatCurrency(nvl(obj.rows[0].riCommAmt,"")));
	$("txtRiCommVat").value		= (obj == null ? "" : formatCurrency(nvl(obj.rows[0].riCommVat,"")));
	if(obj.rows[0].issCd == "RI" || obj.rows[0].issCd == "RB"){
		$("txtRiStat").innerHTML	= "RI Comm. Rt." ;
		
		//hdrtagudin 07232015 SR 19824 
		$("riCommAmt").show();
		$("riCommVat").show();
		$("commissionBtn").hide();
	}
	else{
		$("riCommRt").hide(); //Added by Jerome Bautista 08.10.2015 SR 19824
		$("txtRiStat").innerHTML	= "" ;
	}
	$("txtRemarks").value		= (obj == null ? "" : formatCurrency(nvl(obj.rows[0].remarks,""))); 	//hdrtagudin 07232015 SR 19824 
}
//START hdrtagudin 07232015 SR 19824 
$("textRemarks").observe("click", function () {
	showEditor("txtRemarks", 2000, 'true');
	
});


$("commissionBtn").observe("click", function(){
	
		try {
		overlayCommissionDetailsSu = 
			Overlay.show(contextPath+"/GIPIPolbasicController", {
				urlContent: true,
				urlParameters: {action : "getCommissionDetailsSu",																
								ajax : "1",
								policyId : '${policyId}',
								premSeqNo : bondDetails.rows[0].premSeqNo,
								lineCd : 'SU'
				},
			    title: "Commission",
			    height: 350,
			    width: 720,
			    draggable: true
			});
		} catch (e) {
			showErrorMessage("overlay error: " , e);
		}
});
//END hdrtagudin 07232015 SR 19824 
</script>
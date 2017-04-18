<div align="center" class="sectionDiv" style="width: 550px; margin-top: 5px;">
	<table cellspacing="3" style="width: 200px; margin-top: 10px; margin-bottom: 10px;">
		<tr>
			<td><label style="width: 70px; text-align: right;" >Payor</label></td>
			<td class="leftAligned" colspan="3">
				<input id="txtPayor" type="text" ignoreDelKey="1" class="" style="width: 429px;" tabindex="101" maxlength="550">
			</td>
		</tr>
		<tr>
			<td><label style="width: 70px; text-align: right;" >Address</label></td>
			<td class="leftAligned">
				<input id="txtAddress1" type="text" ignoreDelKey="1" class=" " style="width: 300px;" tabindex="102" maxlength="50">
			</td>
			<td><label style="width: 35px ; text-align: right;" >TIN</label></td>
			<td class="leftAligned">
				<input class="integerNoNegativeUnformattedNoComma" id="txtTin" type="text" ignoreDelKey="1" class=" " style="width: 80px;" tabindex="103" maxlength="30">
			</td>
		</tr>
		<tr>
			<td><label style="width: 70px; text-align: right;" ></label></td>
			<td class="leftAligned">
				<input id="txtAddress2" type="text" ignoreDelKey="1" class=" " style="width: 300px;" tabindex="104" maxlength="50">
			</td>
		</tr>
		<tr>
			<td><label style="width: 70px; text-align: right;" ></label></td>
			<td class="leftAligned">
				<input id="txtAddress3" type="text" ignoreDelKey="1" class=" " style="width: 300px;" tabindex="105" maxlength="50">
			</td>
			<td><label style="width: 35px; text-align: right;" >Intm</label></td>
			<td class="leftAligned">
				<input id="txtIntmNo" type="text" ignoreDelKey="1" class=" rightAligned integerNoNegativeUnformattedNoComma" style="width: 80px;" tabindex="106" maxlength="12">
			</td>
		</tr>
		<tr>
			<td><label style="width: 70px; text-align: right;" >Particulars</label></td>
			<td class="leftAligned" colspan="3">
				<input id="txtParticulars" type="text" ignoreDelKey="1" class=" " style="width: 429px;" tabindex="107" maxlength="500">
			</td>
		</tr>
	</table>
	<div style="margin: 10px;" align="center">
		<input type="button" class="button" id="btnUpdateOrParticulars" value="Update" tabindex="201">
		<input type="button" class="button" id="btnReturn" value="Return" tabindex="202">
	</div>
</div>
<script type="text/javascript">
	var objParams = JSON.parse('${objectParams}');
	
	function closeOverlay(){
		overlayOrParticulars.close();
		delete overlayOrParticulars;
	}
	
	$("btnReturn").observe("click", closeOverlay);
	$("btnUpdateOrParticulars").observe("click", saveOrParticulars);
	//added unescapeHTML2 by jdiago 08.05.2014
	$("txtPayor").value = unescapeHTML2(objParams.payor);
	$("txtAddress1").value = unescapeHTML2(objParams.address1);
	$("txtAddress2").value = unescapeHTML2(objParams.address2);
	$("txtAddress3").value = unescapeHTML2(objParams.address3);
	$("txtTin").value = objParams.tin;
	$("txtIntmNo").value = objParams.intmNo;
	$("txtParticulars").value = unescapeHTML2(objParams.particulars);
	
	function saveOrParticulars(){
		new Ajax.Request(contextPath+"/GIACApdcPaytDtlController", {
			method: "POST",
			parameters : {
						action : "saveOrParticulars",
						pdcId: objParams.pdcId,
						payor : $("txtPayor").value,
						address1 : $("txtAddress1").value,
						address2 : $("txtAddress2").value,
						address3 : $("txtAddress3").value,
						tin : $("txtTin").value,
						intmNo : $("txtIntmNo").value,
						particulars : $("txtParticulars").value
					 	  },
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						closeOverlay();
						tbgChecksTable._refreshList();
					});
				}
			}
		}); 
	}

	initializeAll(); //added by jdiago 07.31.2014 for the added class(integerNoNegativeUnformattedNoComma) in Tin field
</script>
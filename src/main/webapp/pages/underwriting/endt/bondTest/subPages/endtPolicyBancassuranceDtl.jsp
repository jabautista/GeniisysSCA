<div style="margin: 10px; float: left;">
	<input type="checkBox" id="chkBancaSw" name="chkBancaSw" style="margin-left: 23px; float: left;" disabled="disabled" />
	<label style="margin-left: 10px;">Bancassurance</label>
</div>
<table style="width:600px;margin:5 auto 0 auto; float: left;">
	<tr>
		<td colspan="3"></td>
	</tr>	
	<tr>
		<td style="width:115px;" class="rightAligned">Bancassurance Type</td>
		<td style="width:60px;">
			<input type="text" id="txtBancTypeCd" name="txtBancTypeCd" style="width:87%;" readonly="readonly"/>
		</td>
		<td>
			<input type="text" id="txtBancTypeDesc" name="txtBancTypeDesc" style="width:98%;" readonly="readonly"/>
		</td>
	</tr>
	<tr>
		<td class="rightAligned">Area</td>
		<td>
			<input type="text" id="txtAreaCd" name="txtAreaCd" style="width:87%;" readonly="readonly"/>
		</td>
		<td>
			<input type="text" id="txtAreaDesc" name="txtAreaDesc" style="width:98%;" readonly="readonly"/>
		</td>
	</tr>
	<tr>
		<td class="rightAligned">Branch</td>
		<td>
			<input type="text" id="txtBranchCd" name="txtBranchCd" style="width:87%;" readonly="readonly"/>
		</td>
		<td>
			<input type="text" id="txtBranchDesc" name="txtBranchDesc" style="width:98%;" readonly="readonly"/>
		</td>
	</tr>
	<tr>
		<td class="rightAligned">Manager</td>
		<td>
			<input type="text" id="txtManagerCd" id="txtManagerCd" style="width:87%;" readonly="readonly"/>
		</td>
		<td>
			<input type="text" id="txtPayeeName" id="txtPayeeName" style="width:98%;" readonly="readonly"/>
		</td>
	</tr>
	<tr>
		<td colspan="3" align="center">
			<input type="button" class="button" id="btnReturn" value="Return"/>
		</td>
	</tr>
</table>

<script>

	try{
		
		var objPolBancassuranceDtl = JSON.parse('${endtBancassuranceDtls}'.replace(/\\/g, '\\\\'));
		
	}catch(e){}

	if(objPolBancassuranceDtl != null){
		
		$("txtBancTypeCd").value	= objPolBancassuranceDtl.bancTypeCd;
		$("txtBancTypeDesc").value	= objPolBancassuranceDtl.bancTypeDesc;
		$("txtAreaCd").value		= objPolBancassuranceDtl.areaCd;
		$("txtAreaDesc").value		= objPolBancassuranceDtl.areaDesc;
		$("txtBranchCd").value		= objPolBancassuranceDtl.branchCd;
		$("txtBranchDesc").value	= objPolBancassuranceDtl.branchDesc;
		$("txtManagerCd").value		= objPolBancassuranceDtl.managerCd;
		$("txtPayeeName").value		= objPolBancassuranceDtl.payeeName;
		$("chkBancaSw").checked		= (objPolBancassuranceDtl.bancassuranceSw == "Y");
		
	}
	
	$("btnReturn").observe("click", function(){
		overlayBancassuranceDtl.close();
	});

</script>
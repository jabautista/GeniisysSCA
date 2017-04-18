<div class="sectionDiv" id="loaSectionDiv" name="loaSectionDiv" style="border: none;">
	<div id="loaDiv" name="loaDiv">
		<div id="hiddenLoaParamDiv" name="hiddenLoaParamDiv" style="display: none;">
			<input type="hidden" id="hidOverrideLoa" name="hidOverrideLoa" value="${overrideLoa}"/>
		</div>
		<div id="loaTableGridDiv" name="loaTableGridDiv" style="margin: 5px;"></div>
		<div style="margin: 10px;">
			<table>
				<tr>
					<td align="right" style="width: 110px;">Remarks</td>
					<td align="left" style="margin-left: 5px;">
						<div style="float: left; border: solid 1px gray; width: 536px; height: 20px;">
							<input type="text" style="float: left; margin-top: 0px; width: 510px; border: none;" name="txtLoaRemarks" id="txtLoaRemarks" value="" maxlength="4000"/>
							<img id="hrefLoaRemarks" alt="goLoaRemarks" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/edit.png" />						
						</div>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div id="mcTpDtlDiv" name="mcTpDtlDiv" align="center">
		<div id="mcTpDtlTableGridDiv" name="mcTpDtlTableGridDiv" style="margin: 5px;"></div>
	</div>
	<div id="dtlLoaDiv" name="dtlLoaDiv" align="center">
		<div id="dtlLoaTableGridDiv" name="dtlLoaTableGridDiv" style="margin: 5px;"></div>
		<div style="float: right;">
			<table>
				<tr>
					<td align="left" style="width: 40px;"><b>Total</b></td>
					<td><input type="text" id="totalDtlLoaAmt" name="totalDtlLoaAmt" class="money" value="0.00" style="width: 150px; margin-right: 86px;" readonly="readonly"/></td>
				</tr>
			</table>
		</div>
	</div>
</div>

<div class="buttonsDiv" style="margin-bottom: 0">
	<input type="button" id="btnGenerateLOA" 	name="btnGenerateLOA" 	 	  class="button"	value="Generate LOA"/>
	<input type="button" id="btnPrintLOA" 		name="btnPrintLOA" 	 	  	  class="button"	value="Print LOA"/>
	<input type="button" id="btnLOAReturn" 	 	name="btnLOAReturn"  	 	  class="button"	value="Main Screen"/>
</div>

<script type="text/javascript">
	retrieveLossExpLOA();
	retrieveMcTpDtlForLOA();
	retrieveDtlLOA();
	
	$("btnLOAReturn").observe("click", function(){
		lossExpHistWin.close();	
	});
	
	$("hrefLoaRemarks").observe("click", function(){
		showEditor("txtLoaRemarks", 4000, "true");
	});
	
	$("btnGenerateLOA").observe("click", function(){
		var loaList = setLOAList();
		
		if(loaList.length > 0){
			generateLoaFromLossExp(loaList);	
		}else{
			showMessageBox("There is no LOA to be generated.", "E");
		}
	});
	
	$("btnPrintLOA").observe("click", function(){
		var loaList = setLOAList("Print");
		
		if(loaList.length > 0){
			showGenericPrintDialog("Print LOA", function(){
				printLOA(loaList,"GICLS030");
			});	
		}else{
			showMessageBox("There is no LOA to be printed.", "E");
		}
	});
	
</script>
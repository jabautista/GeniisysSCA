<div class="sectionDiv" id="cslSectionDiv" name="cslSectionDiv" style="border: none;">
	<div id="cslDiv" name="cslDiv">
		<div id="hiddenCslParamDiv" name="hiddenCslParamDiv" style="display: none;">
			<input type="hidden" id="hidOverrideCsl" name="hidOverrideCsl" value="${overrideCsl}"/>
		</div>
		<div id="cslTableGridDiv" name="cslTableGridDiv" style="margin: 5px;"></div>
		<div style="margin: 10px;">
			<table>
				<tr>
					<td align="right" style="width: 110px;">Remarks</td>
					<td align="left" style="margin-left: 5px;">
						<div style="float: left; border: solid 1px gray; width: 536px; height: 20px;">
							<input type="text" style="float: left; margin-top: 0px; width: 510px; border: none;" name="txtCslRemarks" id="txtCslRemarks" value="" maxlength="4000"/>
							<img id="hrefCslRemarks" alt="goCslRemarks" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/edit.png" />						
						</div>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div id="mcTpDtlDiv" name="mcTpDtlDiv" align="center">
		<div id="mcTpDtlTableGridDiv" name="mcTpDtlTableGridDiv" style="margin: 5px;"></div>
	</div>
	<div id="dtlCslDiv" name="dtlCslDiv" align="center">
		<div id="dtlCslTableGridDiv" name="dtlCslTableGridDiv" style="margin: 5px;"></div>
		<div style="float: right;">
			<table>
				<tr>
					<td align="left" style="width: 40px;"><b>Total</b></td>
					<td><input type="text" id="totalDtlCslAmt" name="totalDtlCslAmt" class="money" value="0.00" style="width: 150px; margin-right: 86px;" readonly="readonly"/></td>
				</tr>
			</table>
		</div>
	</div>
</div>

<div class="buttonsDiv" style="margin-bottom: 10px">
	<input type="button" id="btnGenerateCSL" 	name="btnGenerateCSL" 	 	  class="button"	value="Generate CSL"/>
	<input type="button" id="btnPrintCSL" 		name="btnPrintCSL" 	 	  	  class="button"	value="Print CSL"/>
	<input type="button" id="btnCSLReturn" 	 	name="btnCSLReturn"  	 	  class="button"	value="Main Screen"/>
</div>

<script type="text/javascript">
	retrieveLossExpCSL();
	retrieveMcTpDtlForCSL();
	retrieveDtlCSL();
	
	$("btnCSLReturn").observe("click", function(){
		lossExpHistWin.close();	
	});
	
	$("hrefCslRemarks").observe("click", function(){
		showEditor("txtCslRemarks", 4000, "true");
	});
	
	$("btnGenerateCSL").observe("click", function(){
		var cslList = setCSLList();
		
		if(cslList.length > 0){
			generateCslFromLossExp(cslList);
		}else{
			showMessageBox("There is no CSL to be generated.", "E");
		}
	});
	
	$("btnPrintCSL").observe("click", function(){
		var cslList = setCSLList("Print");
		
		if(cslList.length > 0){
			showGenericPrintDialog("Print CSL", function(){
				printCSL(cslList,"GICLS030");
			});
		}else{
			showMessageBox("There is no CSL to be printed.", "E");
		}
	});
	
</script>
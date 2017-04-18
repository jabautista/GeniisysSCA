<div id="billsUnderAgeSort" style="width: 95%; margin-top: 5px;">
	<div class="sectionDiv" style="padding: 10px 0 10px 10px; height: 190px; width: 101.6%;">
		<div class="sectionDiv" id="sortOptionDiv" style="width: 45%; height: 120px; margin: 8px 8px 8px 8px;">
			<table border="0" id="chkboxTbl" align="center" style="margin-left: 10px; margin-top: 10px; margin-bottom: 0px;">
				<tr><td style="padding-bottom: 0px;"></td></tr>
				<!-- <tr name="columnTR" id="billNoTR" >
					<td>
						<input id="chkIssCd" name="columnCB" type="checkbox" value="iss_cd" style="float: left;">
						<label for="chkIssCd" id="chkIssCd" name="chkboxLbl" style="margin: 2px 0 4px 7px">Issue Code</label>
					</td>
				</tr> -->
				<tr name="columnTR" id="billNoTR" >
					<td>
						<input id="chkBillNo" name="columnCB" type="checkbox" value="bill_no" style="float: left;">
						<label for="chkBillNo" id="chkBillNo" name="chkboxLbl" style="margin: 2px 0 4px 7px">Bill No.</label>
					</td>
				</tr>
				<tr name="columnTR" id="totAmtDueTR">
					<td>
						<input id="chkTotAmtDue" name="columnCB" type="checkbox" value="total_amount_due" style="float: left;" >
						<label for="chkTotAmtDue" id="chkTotAmtDue" name="chkboxLbl" style="margin: 2px 0 4px 7px">Total Amount Due</label>
					</td>
				</tr>
				<tr name="columnTR" id="totPaymentsTR" >
					<td>
						<input id="chkTotPayments" name="columnCB" type="checkbox" value="total_payments" style="float: left;" >
						<label for="chkTotPayments" id="chkTotPayments" name="chkboxLbl" style="margin: 2px 0 4px 7px">Total Payments</label>
					</td>
				</tr>
				<tr name="columnTR" id="balanceDueTR" >
					<td>
						<input id="chkBalanceDue" name="columnCB" type="checkbox" value="balance_amt_due" style="float: left;" >
						<label for="chkBalanceDue" id="chkBalanceDue" name="chkboxLbl" style="margin: 2px 0 4px 7px">Balance Due</label>
					</td>
				</tr>
			</table>
		</div>
		<div class="sectionDiv" id="swapDiv" style="width: 42%; height: 120px; margin: 8px 8px 8px 8px;">
			<table  align="center" style="margin-left: 55px; margin-top: 20px; margin-bottom: 0px;">
				<tr>
					<td>
						<img src="${pageContext.request.contextPath}/images/misc/MUP.ICO" id="btnUp" name="btnUp" title="Move Up" onmouseover="this.style.cursor='pointer';"/></td>
					</td>
				</tr>
				<tr>
					<td>
						<img src="${pageContext.request.contextPath}/images/misc/MDOWN.ICO" id="btnDown" name="btnDown" title="Move Down" onmouseover="this.style.cursor='pointer';"/></td>
					</td>
				</tr>
			</table>
		</div>
		<div class="sectionDiv" id="ascDescDiv" style="width: 92.5%; height: 55px; margin-left: 8px;">
			<table align="center" style="margin-left: 92px; margin-top: 10px; margin-bottom: 0px;">
				<tr>
					<td>
						<input type="radio" id="ascRB" name="sortRG" value=" ASC" style="margin-left: 15px; float: left;" checked="checked"/>
						<label for="rdoAscending" style="margin-top: 3px;">Ascending</label>
					</td>
				</tr>
				<tr>
					<td>
						<input type="radio" id="descRB" name="sortRG" value=" DESC" style="margin-left: 15px; float: left;" checked="checked"/>
						<label for="rdoDescending" style="margin-top: 3px;">Descending</label>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<center>
		<input type="button" class="button" value="Ok" id="btnOk" style="margin-top: 5px; width: 100px;" />
		<input type="button" class="button" value="Cancel" id="btnCancel" style="margin-top: 5px; width: 100px;" />
	</center>
	<div>
		<input id="fundDesc"            type="hidden"  value="${fundDesc}"/>
		<input id="fundCd"              type="hidden"  value="${fundCd}"/>
		<input id="branchName"          type="hidden"  value="${branchName}"/>
		<input id="branchCd"            type="hidden"  value="${branchCd}"/>
		<input id="agingId"             type="hidden"  value="${agingId}"/>
		<input id="assdNo"              type="hidden"  value="${assdNo}"/>
		<input id="selectedAgingId"     type="hidden"  value="${selectedAgingId}"/>
		<input id="selectedBranchCd"    type="hidden"  value="${selectedBranchCd}"/>
	</div>
</div>
<script type="text/javascript">
try{
	var ascDesc = " ASC";
	var selectedTR = null;
	var selectedLbl = null;
	
	var col2 = null;
	var val1 = null;
	var val2 = null;
	var chk1 = false;
	var chk2 = false;
	
	if (objGIACS204.msortOrder != ""){
		for (var i=1; i<=4; i++){
			$("chkboxTbl").down("tr", i).down("td", 0).down("label", 0).innerHTML = objGIACS204.msortOrder[i-1].columnLabel;
			$("chkboxTbl").down("tr", i).down("td", 0).down("input", 0).value = objGIACS204.msortOrder[i-1].columnValue;
			$("chkboxTbl").down("tr", i).down("td", 0).down("input", 0).checked = objGIACS204.msortOrder[i-1].columnState;
		}
		ascDesc = objGIACS204.msortOrder[0].ascDesc;
		if (ascDesc == " ASC"){
			$("ascRB").checked = true;
		}else{
			$("descRB").checked = true;
		}
	}
	
	function moveUpDown(direction){
		if (selectedLbl == null){
			showMessageBox("Please select a checkbox first.", "I");
			return false;
		}
		col2 = null;
		val1 = null;
		val2 = null;
		chk1 = false;
		chk2 = false;
		
		$$("label[name='chkboxLbl']").each(function(lbl){
			if (lbl.innerHTML == selectedLbl){
				lbl.style.fontWeight = "bold";
			}else{
				lbl.style.fontWeight = "normal";
			}
		});		
		
		for (var i=1; i<=4; i++){
			if ((direction == "UP" && i > 1) || (direction == "DOWN" && i < 4)){
				if ($("chkboxTbl").down("tr", i).down("td", 0).down("label", 0).innerHTML == selectedLbl){
					if (direction == "UP"){
						//get values/status of previous checkbox 
						col2 = $("chkboxTbl").down("tr", i-1).down("td", 0).down("label", 0).innerHTML;
						val2 = $("chkboxTbl").down("tr", i-1).down("td", 0).down("input", 0).value;	
						chk2 = $("chkboxTbl").down("tr", i-1).down("td", 0).down("input", 0).checked;
						//get value/status of selected checkbox
						chk1 = $("chkboxTbl").down("tr", i).down("td", 0).down("input", 0).checked;			
						val1 = $("chkboxTbl").down("tr", i).down("td", 0).down("input", 0).value;
						
						$("chkboxTbl").down("tr", i-1).down("td", 0).down("label", 0).innerHTML = selectedLbl;
						$("chkboxTbl").down("tr", i-1).down("td", 0).down("label", 0).style.fontWeight = "bold";
						$("chkboxTbl").down("tr", i-1).down("td", 0).down("input", 0).value = val1;
						$("chkboxTbl").down("tr", i-1).down("td", 0).down("input", 0).checked = chk1;
						
					}else if(direction == "DOWN"){
						//get values/status of next checkbox
						col2 = $("chkboxTbl").down("tr", i+1).down("td", 0).down("label", 0).innerHTML;
						val2 = $("chkboxTbl").down("tr", i+1).down("td", 0).down("input", 0).value;	
						chk2 = $("chkboxTbl").down("tr", i+1).down("td", 0).down("input", 0).checked;	
						//get value/status of selected checkbox			
						chk1 = $("chkboxTbl").down("tr", i).down("td", 0).down("input", 0).checked;			
						val1 = $("chkboxTbl").down("tr", i).down("td", 0).down("input", 0).value;
						
						$("chkboxTbl").down("tr", i+1).down("td", 0).down("label", 0).innerHTML = selectedLbl;
						$("chkboxTbl").down("tr", i+1).down("td", 0).down("label", 0).style.fontWeight = "bold";
						$("chkboxTbl").down("tr", i+1).down("td", 0).down("input", 0).value = val1;
						$("chkboxTbl").down("tr", i+1).down("td", 0).down("input", 0).checked = chk1;
					}
					
					$("chkboxTbl").down("tr", i).down("td", 0).down("label", 0).innerHTML = col2;
					$("chkboxTbl").down("tr", i).down("td", 0).down("label", 0).style.fontWeight = "normal";
					$("chkboxTbl").down("tr", i).down("td", 0).down("input", 0).value = val2;
					$("chkboxTbl").down("tr", i).down("td", 0).down("input", 0).checked = chk2;
					
					break;
				}
			}			
		}
		
	}
	
	$$("input[name='sortRG']").each(function(radio){
		radio.observe("click", function(){
			ascDesc = radio.value;
		});
	});
	
	$$("input[name='columnCB']").each(function(inp){
		inp.observe("click", function(){
			$$("label[name='chkboxLbl']").each(function(lbl){
				if(lbl.id == inp.id){
					if(inp.checked){
						$$("label[name='chkboxLbl']").each(function(unbold){
							unbold.style.fontWeight = "normal";
						});
						
						lbl.style.fontWeight = "bold";
						selectedLbl = lbl.innerHTML;
					} else {
						lbl.style.fontWeight = "normal";
						
						if(lbl.innerHTML == selectedLbl){
							selectedLbl = null;
						}
					}
				}
			});
		});
	});
	
	$("btnUp").observe("click", function(){
		moveUpDown("UP");
	});

	$("btnDown").observe("click", function(){
		moveUpDown("DOWN");
	});
	
	$("btnOk").observe("click", function(){
		objGIACS204.msortOrder = [];
		var columns = "";
		
		for (var i=1; i <= 4; i++){
			if($("chkboxTbl").down("tr", i).down("td", 0).down("input", 0).checked){		
				columns = columns + $("chkboxTbl").down("tr", i).down("td", 0).down("input", 0).value + ascDesc + ",";
			}
			
			// to save selected sorting 
			objGIACS204.msortOrder.push({columnLabel: $("chkboxTbl").down("tr", i).down("td", 0).down("label", 0).innerHTML,
										 columnValue: $("chkboxTbl").down("tr", i).down("td", 0).down("input", 0).value,
										 columnState: $("chkboxTbl").down("tr", i).down("td", 0).down("input", 0).checked,
										 ascDesc:     ascDesc });
		}
		
		objGIACS204.multiSort = columns.substr(0, columns.length - 1);	
		
		if(objGIACS204.multiSort != null){
			objGIACS204.currentForm = "GIACS204Sort";
			tbgBillsAssdAndAgeLevel.url = contextPath + "/GIACInquiryController?action=showGIACS204&refresh=1&selectedAgingId=" + $F("selectedAgingId")
			+ "&selectedBranchCd=" + $F("selectedBranchCd") + "&assdNo=" + $F("assdNo") + "&multiSort=" + objGIACS204.multiSort;
			tbgBillsAssdAndAgeLevel._refreshList();			
		}
		
		objGIACS204.currentForm = "GIACS204";
		overlayBillsUnderAgeSortPopUp.close();
	});
	
	$("btnCancel").observe("click", function(){
		overlayBillsUnderAgeSortPopUp.close();
		delete overlayBillsUnderAgeSortPopUp;
	});
	
	if (objGIACS204.msortOrder == ""){
		$("ascRB").checked = true;	
	}
}catch(e){
	showErrorMessage("Page Error: ", e);
}
</script>
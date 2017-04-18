<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<div id="multiSortMainDiv">
	<table style="margin-left: 10px;">
		<tr>
			<td>
				<div id="chkboxDiv" style="width: 115px; height: 250px; padding: 10px 10px 0 20px; ">
					<table id="chkboxTbl">
						<tr><td style="padding-bottom: 10px;"> Sort By: </td></tr>
						<tr name="columnTR" id="tranNoTR" >
							<td><input id="chkTranNo" name="columnCB" type="checkbox" value="tran_no" style="float: left;" ><label for="chkTranNo" name="chkboxLbl" style="margin: 2px 0 4px 7px">Tran No</label></td>
						</tr>
						<tr name="columnTR" id="tranClassTR">
							<td><input id="chkTranClass" name="columnCB" type="checkbox" value="tran_class" style="float: left;" ><label for="chkTranClass" name="chkboxLbl" style="margin: 2px 0 4px 7px">Tran Class</label></td>
						</tr>
						<tr name="columnTR" id="tranFlagTR" >
							<td><input id="chkTranFlag" name="columnCB" type="checkbox" value="tran_flag" style="float: left;" ><label for="chkTranFlag" name="chkboxLbl" style="margin: 2px 0 4px 7px">Tran Flag</label></td>
						</tr>
						<tr name="columnTR" id="refNoTR">
							<td><input id="chkRefNo" name="columnCB" type="checkbox" value="ref_no" style="float: left;" ><label for="chkRefNo" name="chkboxLbl" style="margin: 2px 0 4px 7px">Ref No</label></td>
						</tr>
						<tr name="columnTR" id="tranDateTR">
							<td><input id="chkTranDate" name="columnCB" type="checkbox" value="tran_date" style="float: left;" ><label for="chkTranDate" name="chkboxLbl" style="margin: 2px 0 4px 7px">Tran Date</label></td>
						</tr>
						<tr name="columnTR" id="dtPostedTR">
							<td><input id="chkDatePosted" name="columnCB" type="checkbox" value="dt_posted" style="float: left;" ><label for="chkDatePosted" name="chkboxLbl" style="margin: 2px 0 4px 7px">Date Posted</label></td>
						</tr>
						<tr name="columnTR" id="debitAmtTR">
							<td><input id="chkDebitAmt" name="columnCB" type="checkbox" value="debit_amt" style="float: left;" ><label for="chkDebitAmt" name="chkboxLbl" style="margin: 2px 0 4px 7px">Debit Amt</label></td>
						</tr>
						<tr name="columnTR" id="creditAmtTR">
							<td><input id="chkCreditAmt" name="columnCB" type="checkbox" value="credit_amt" style="float: left;" ><label for="chkCreditAmt" name="chkboxLbl" style="margin: 2px 0 4px 7px">Credit Amt</label></td>
						</tr>
						<tr name="columnTR" id="slCdTR">
							<td><input id="chkSlCd" name="columnCB" type="checkbox" value="sl_cd" style="float: left;" ><label for="chkSlCd" name="chkboxLbl" style="margin: 2px 0 4px 7px">SL Code</label></td>
						</tr>
						<tr name="columnTR" id="slNameTR">
							<td><input id="chkSlName" name="columnCB" type="checkbox" value="sl_name" style="float: left;" ><label for="chkSlName" name="chkboxLbl" style="margin: 2px 0 4px 7px">SL Name</label></td>
						</tr>			
					</table>
				</div>
			</td>
			<td>
				<div id="btnsDiv" style="width: 130px; height: 220px; padding: 25px 0px 5px 0px; ">
					<table style="padding-left: 25px; margin: 0px 0 10px 0;">
						<tr>
							<td style="padding-bottom: 3px;">Item Order</td>				
						</tr>
						<tr>
							<td><input id="btnMoveUp" type="button" class="button" value="Move Up" style="width: 80px; margin-left: 5px;" ></td>
						</tr>
						<tr>
							<td><input id="btnMoveDown" type="button" class="button" value="Move Down" style="width: 80px; margin-left: 5px;" > </td>
						</tr>
					</table>
					
					<table style="padding-left: 25px; margin-bottom: 5px;">
						<tr>
							<td>Sort Order</td>				
						</tr>
						<tr>
							<td><input id="ascRB" name="sortRG" type="radio" value=" ASC" title="Ascending" checked="checked" style="float: left; margin-left: 15px;" tabindex="119"><label for="ascRB" style="margin: 2px 0 4px 0">Ascending</label> </td>
						</tr>
						<tr>
							<td><input id="descRB" name="sortRG" type="radio" value=" DESC" title="Descending" style="float: left; margin-left: 15px;" tabindex="119"><label for="descRB" style="margin: 2px 0 4px 0">Descending</label> </td>
						</tr>
					</table>
					
					<div class="buttonsDiv" style="padding-left: 5px;">		
						<input id="btnOk" type="button" class="button" value="Ok" style="margin-bottom: 3px;">
						<input id="btnCancel" type="button" class="button" value="Cancel">
					</div>
				</div>
			</td>
		</tr>
	</table>
	
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

	
	// to show previously created sorting
	if (objGIACS230.msortOrder != ""){
		for (var i=1; i<=10; i++){
			$("chkboxTbl").down("tr", i).down("td", 0).down("label", 0).innerHTML = objGIACS230.msortOrder[i-1].columnLabel;
			$("chkboxTbl").down("tr", i).down("td", 0).down("input", 0).value = objGIACS230.msortOrder[i-1].columnValue;
			$("chkboxTbl").down("tr", i).down("td", 0).down("input", 0).checked = objGIACS230.msortOrder[i-1].columnState;
		}
		ascDesc = objGIACS230.msortOrder[0].ascDesc;
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
		
		for (var i=1; i<=10; i++){
			if ((direction == "UP" && i > 1) || (direction == "DOWN" && i < 10)){
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

	$$("label[name='chkboxLbl']").each(function(lbl){
		lbl.observe("click", function(){
			//--- to remove emphasis on the previously selected column
			$$("label[name='chkboxLbl']").each(function(lbl){
				lbl.style.fontWeight = "normal";
			});
			//----
			selectedLbl = lbl.innerHTML;
			lbl.style.fontWeight = "bold";
		});		
		
		lbl.observe("blur", function(){
			lbl.style.fontWeight = "normal";
		});
	});
	
	$$("input[name='columnCB']").each(function(cb){
		cb.observe("click", function(){
			//--- to remove emphasis on the previously selected column
			$$("label[name='chkboxLbl']").each(function(lbl){
				lbl.style.fontWeight = "normal";
			});
			//----to place emphasis on the currently check column
			$$("label[name='chkboxLbl']").each(function(lbl){
				if (lbl.htmlFor == cb.id){
					selectedLbl = lbl.innerHTML;
					lbl.style.fontWeight = "bold";
				}
			});
		});		
		
		cb.observe("blur", function(){
			lbl.style.fontWeight = "normal";
		});
	});
	
	$("btnMoveUp").observe("click", function(){
		moveUpDown("UP");
	});

	$("btnMoveDown").observe("click", function(){
		moveUpDown("DOWN");
	});

	
	$("btnCancel").observe("click", function(){
		objOverlay.close();
	});
	
	$("btnOk").observe("click", function(){
		objGIACS230.msortOrder = [];
		var columns = "";
		
		for (var i=1; i <= 10; i++){
			if($("chkboxTbl").down("tr", i).down("td", 0).down("input", 0).checked){		
				columns = columns + $("chkboxTbl").down("tr", i).down("td", 0).down("input", 0).value + ascDesc + ",";
			}
			
			// to save selected sorting 
			objGIACS230.msortOrder.push({columnLabel: $("chkboxTbl").down("tr", i).down("td", 0).down("label", 0).innerHTML,
										 columnValue: $("chkboxTbl").down("tr", i).down("td", 0).down("input", 0).value,
										 columnState: $("chkboxTbl").down("tr", i).down("td", 0).down("input", 0).checked,
										 ascDesc:     ascDesc });
		}
		
		objGIACS230.multiSort = columns.substr(0, columns.length - 1);	
		
		if(objGIACS230.multiSort != null){
			if (objGIACS230.glTransURL.indexOf("&multiSort=") != -1){	
				objGIACS230.glTransURL = objGIACS230.glTransURL.substr(0, objGIACS230.glTransURL.indexOf("&multiSort=")) 
										 + "&multiSort=" + objGIACS230.multiSort;
				
			}else{
				objGIACS230.glTransURL = objGIACS230.glTransURL + "&multiSort=" + objGIACS230.multiSort;
			}
			
			new Ajax.Updater("glTransactionDiv", contextPath+"/GIACInquiryController?action=getGLAcctTransactionGIACS230"+objGIACS230.glTransURL,{
				method: "POST",
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					enableToolbarButton("btnToolbarEnterQuery");
				}
			});
		}
		
		objOverlay.close();
	});

}catch(e){
	showErrorMessage("Page Error: ", e);
}
</script>
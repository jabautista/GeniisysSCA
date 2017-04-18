<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" name="innerDiv">
		<label>Payee Details</label>
		<span class="refreshers" style="margin-top: 0;">
			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
		</span>
	</div>
</div>
<div class="sectionDiv" id="payeeDetailsSectionDiv" name="payeeDetailsSectionDiv">
	<div id="payeeDetailsDiv" name="payeeDetailsDiv" changeTagAttr="true">
		<div id="payeeDetailsTableGridDiv" style="margin-left: 130px; padding: 10px;"></div>
		<table border="0" style="margin: auto; margin-top: 10px; margin-bottom: 10px;">
			<tr>
				<td class="rightAligned" >Payee Type</td>
				<td class="leftAligned"  >
					<select class="required" id="selPayeeType" name="selPayeeType" style="width: 252px;">
						<option value="L">Loss</option>
						<option value="E">Expense</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Payee Class</td>
				<td class="leftAligned">
					<div class="required" style="float: left; border: solid 1px gray; width: 250px; height: 20px;">
						<input id="payeeClass" name="payeeClass" type="text" style="width: 225px; border: none; background-color: transparent;" value="" readonly="readonly"/>
						<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="btnPayeeClass" name="btnPayeeClass" alt="Go" />						
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Payee</td>
				<td class="leftAligned">
					<div class="required" style="float: left; border: solid 1px gray; width: 250px; height: 20px;">
						<input id="payee" name="payee" type="text" style="width: 225px; border: none; background-color: transparent;" value="" readonly="readonly"/>
						<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="btnPayee" name="btnPayee" alt="Go" />						
					</div>
					<div id="payeeHiddenDiv" name="payeeHiddenDiv" style="display: none;">
						<input type="hidden" id="hidClmClmntNo"       name="hidClmClmntNo" 		 value="" />
						<input type="hidden" id="hidExistClmLossExp"  name="hidExistClmLossExp"  value="" />
						<input type="hidden" id="hidDefaultPayeeType" name="hidDefaultPayeeType" value="" />
						<input type="hidden" id="hidLossReserve" 	  name="hidLossReserve" 	 value="" />
						<input type="hidden" id="hidExpReserve" 	  name="hidExpReserve" 		 value="" />
						<input type="hidden" id="hidMortgExist" 	  name="hidMortgExist" 		 value="" />
					</div>
				</td>
			</tr>
		</table>	
		<div class="buttonsDiv" style="margin-bottom: 15px">
			<input type="button" id="btnAddPayee" 	 name="btnAddPayee" 	class="button"	value="Add" />
			<input type="button" id="btnDeletePayee" name="btnDeletePayee"	class="button"	value="Delete" />			
		</div>
	</div>
</div>

<script type="text/javascript">
	
	$("btnPayee").observe("click", function(){
		if(objCurrGICLItemPeril == null){
			showMessageBox("Please select an item first.", "I");
			return false;
		}else if(nvl($F("payeeClass"), "") == ""){
			showMessageBox("Please enter payee class first.");
		}else{
			var payeeClassCd = $("payeeClass").getAttribute("payeeClassCd");
			var payeeType = $("selPayeeType").value;
			
			if(payeeClassCd == $("hidAdjpClassCd").value){
				showLossExpAdjusterLov(objCurrGICLItemPeril, payeeClassCd, payeeType);
			}else if(payeeClassCd == $("hidMortgClassCd").value){
				validateMortgageeClassCd(payeeClassCd);
				/* if (objCLM.validateMortgageeClassCd == "Y"){ //removed by kenneth 05292015 SR 19283 validateMortgageeClassCd already handled display of LOV
					showLossExpMortgageeLov(objCurrGICLItemPeril, payeeClassCd, payeeType);					
				} */
			}else{
				showLossExpPayeeLov(objCurrGICLItemPeril, payeeClassCd, payeeType);	
			}			
		}
	});
	
	$("btnPayeeClass").observe("click", function(){
		if(objCurrGICLItemPeril == null){
			showMessageBox("Please select an item first.", "I");
			return false;
		}else if(checkLossExpChildRecords()){//added by kenneth 07212015 SR 19789 #2
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			return false;
		}else{
			//Modified to validate AO function Kenneth 05292015 SR 3612
			if(nvl($("hidMortgExist").value, "N") == "Y" && $("btnAddPayee").value == "Add"){
				var payeeClassCd = $("payeeClass").getAttribute("payeeClassCd");
				var payeeType = $("selPayeeType").value;
				if(nvl(objCLMGlobal.totalTag, "N") == "Y"){
					if(payeeClassCd == ""){
						processMortgagedItem();
					}else{
						if(payeeClassCd == $("hidMortgClassCd").value){
							if(payeeType == "E"){
								showLossExpPayeeClassLov();
							}else if(payeeType == "L"){
								if (!validateUserFunc2("AO", "GICLS030")){
									showConfirmBox("User Override.","User is not allowed to change payee class. Would you like to override?","Yes","No",function(){
										showGenericOverride("GICLS030","AO",
											function(ovr, userId, result) {
												if (result == "FALSE") {
													showMessageBox(userId+ " is not allowed to override.",imgMessage.ERROR);
													return false;
												}else if(result == "TRUE"){
													showLossExpPayeeClassLov();
													ovr.close();
													delete ovr;
												}
											}, function() {
												this.close();
											}
										);
									});
								}else{
									showLossExpPayeeClassLov();
								}
							}
						}else{
							showLossExpPayeeClassLov();
						}
					}			
				}else{
					processMortgagedItem();
				}
			}else{
				showLossExpPayeeClassLov();
			}
		}
	});
	
	$("selPayeeType").observe("change", function(){
		$("payee").value = "";
		$("payee").setAttribute("payeeNo", "");
		$("payeeClass").value = "";
		$("payeeClass").setAttribute("payeeClassCd", "");
		
		if(objCurrGICLItemPeril == null){
			showMessageBox("Please select an item first.", "I");
			return false;
		}else if($("selPayeeType").value == "E" && $("hidExpReserve").value == "0"){
			showMessageBox("Expense Reserve was not set-up for this claim.", "I");
			$("selPayeeType").value = "L";
			return false;
		}else if($("selPayeeType").value == "L" && $("hidLossReserve").value == "0"){
			showMessageBox("Loss Reserve was not set-up for this claim.", "I");
			$("selPayeeType").value = "E";
			return false;
		}
	});
	
	$("btnAddPayee").observe("click", function(){
		if(validateAddGiclLossExpPayee()){
			/*
			** Modified by   : MAC
			** Date Modified : 04/15/2013
			** Modifications : Modified GICLS030 to disallow adding of new record with same item number, peril code, item group, payee type, payee class code, and payee code as compared to previously saved records.
			*/
			if ($("payee") != ""){
				var exist = false;
				for (i=0; i<giclLossExpPayeesTableGrid.geniisysRows.length; i++){
					if (giclLossExpPayeesTableGrid.geniisysRows[i].itemNo == objCurrGICLItemPeril.itemNo&&
						giclLossExpPayeesTableGrid.geniisysRows[i].perilCd == objCurrGICLItemPeril.perilCd &&
						giclLossExpPayeesTableGrid.geniisysRows[i].groupedItemNo == objCurrGICLItemPeril.groupedItemNo&&
						giclLossExpPayeesTableGrid.geniisysRows[i].payeeType == $F("selPayeeType")&&
						giclLossExpPayeesTableGrid.geniisysRows[i].payeeClassCd == $("payeeClass").getAttribute("payeeClassCd")&&
						giclLossExpPayeesTableGrid.geniisysRows[i].payeeCd == $("payee").getAttribute("payeeNo")){
						exist = true; 
					}
				}
				if (exist) { //show message and remove value of payee if already exist.
					$("payee").value = "";
					$("payee").setAttribute("payeeNo", "");
					showMessageBox("You can only use the same payee per item-peril and payee type.", "I");
					exist = false;
				}else{
					addGiclLossExpPayee(); //continue adding payee if not yet exist.
				}
			}		
		}
	});
	
	$("btnDeletePayee").observe("click", function(){
		if(objCurrGICLLossExpPayees.recordStatus != "0"){
			showMessageBox("You cannot delete this record.", "I");
		}else{
			var index = giclLossExpPayeesTableGrid.getCurrentPosition()[1];
			var delObj = setPayeeDetailObject();
			delObj.recordStatus = -1;
			replaceLossExpPayeeObject(delObj);
			giclLossExpPayeesTableGrid.deleteVisibleRowOnly(index);
			clearAllRelatedPayeeRecords();
			payeeInsertSw = "N";
		}
	});
	
</script>
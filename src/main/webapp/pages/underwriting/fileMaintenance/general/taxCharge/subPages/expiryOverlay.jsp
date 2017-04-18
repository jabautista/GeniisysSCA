<div id="expiryDiv" name="expiryDiv" style="width: 200px; height: 110px;">
	<div class="sectionDiv" style="width: 200px; margin: 10px; margin-left: 3px; margin-bottom: 0px; margin-top: 13px; height:100px;">
		<div id="expiryDivForm" name="expiryDivForm" style="width: 200px; margin-top: 10px;" align="center">
			<table>	 			
				<tr>
					<td align="center">Expiry date</td>
				</tr>
				<tr>
					<td class="leftAligned">
						<div id="fromDateDiv" style="float: left; border: 1px solid gray; width: 150px; height: 22px;">
							<input id="txtExpiry" type="text" style="width: 120px; height: 13px; border: none; margin: 0px;" tabindex="313">
							<img id="imgExpiryDate" alt="imgExpiryDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtExpiry'),this, null);" tabindex="314"/>
						</div>
					</td>			
				</tr>
			</table>
 			<div align="center" style="margin-top: 5px;">
				<table width="200px">
					<td align="center">
						<input type="button" class="button" style="width: 80px;" id="btnOk" name="btnOk" value="Ok" tabindex="403"/>
					</td>
				</table>
			</div>
		</div>
	</div>
</div>

<script type="text/JavaScript">
	var compareDates1 = null;
	var compareDates2 = null;
	
	$("btnOk").observe("click", function(){
		if($F("txtExpiry") != ""){
			$("txtEndDate").value = $F("txtExpiry");
		}
		overlayTax.close();
	});
	
	function checkInputDates2(currentFieldId, fromDateId, toDateId){
		if ($F(fromDateId) != "" && $F(toDateId) != ""){ 
			compareDates1 = compareDatesIgnoreTime(Date.parse($F("txtExpiry")), Date.parse($F("txtEndDate")));
			compareDates2 = compareDatesIgnoreTime(Date.parse($F("txtExpiry")), Date.parse($F("txtStartDate"))); 
			if(compareDates1 == compareDates2){
				$(currentFieldId).value = "";
				customShowMessageBox("The expiry date of this tax should fall within the given Start Date and End Date.", "E", currentFieldId);
			}
		} else if($F(fromDateId) == "" && $F(toDateId) == "" && $F("txtTaxCd") != "") {
			new Ajax.Request(contextPath + "/GIISTaxChargesController", {
				parameters : {
					action : "valDateOnAdd",
					lineCd : $F("txtLineCd"),
					issCd : $F("txtIssCd"),
					taxCd : $F("txtTaxCd"),
					effDate : $F(currentFieldId)
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response) {
					hideNotice();
					if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {

					}else{
						$(currentFieldId).clear();
					}
				}
			});
			return false;
		} else if ($F(fromDateId) != "" && $F(toDateId) == ""){
			if(compareDatesIgnoreTime(Date.parse($F(fromDateId)), Date.parse($F(currentFieldId))) == -1){
				$(currentFieldId).value = "";
				customShowMessageBox("Start Date should not be later than End Date.", "I", currentFieldId);
			}
		} 
	}
	
	$("txtExpiry").observe("focus", function() {
		if ($("imgExpiryDate").disabled == true) return;
		checkInputDates2("txtExpiry", "txtStartDate", "txtEndDate");
	});
	
	observeBackSpaceOnDate("txtExpiry");
</script>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>
<br/>
<div id="copyPerilSelectItemDiv" name="copyPerilSelectItemDiv" style="width: 100%; font-size: 11px;">
	<div class="sectionDiv" style="width: 280px; margin: 10px;">
		<form id="copyPerilForm" name="copyPerilForm" style="width: 260px;margin: 10px;">
			<div style="margin-bottom: 5px; width: 100%; align: center;">				
				<label style="width: 150px; align: center;">Select item no. to copy: </label> 
				<select id="itemToCopyPeril" name="itemToCopyPeril" style="width: 70px; align: center;">
					<option></option>
						<c:forEach var="a" items="${itemNumber}">
							<c:if test="${a ne selectedItemNo}">
								<option value="${a}">${a}</option>
							</c:if>
						</c:forEach>
				</select>				
			</div>
			<div style="text-align: center;">
				<input type="button" class="button" style="width: 100px; margin-top: 10px;" id="submit" name="submit" value="OK" />
				<input type="button" class="button" style="width: 100px; margin-top: 10px;" id="cancelCopy" name="cancelCopy" value="Cancel" />
			</div>
			</form>
	</div>
</div>
<script type="text/JavaScript">
try{
	function updateSelectElement(){
		var selectContent = "<option></option>";
		/*$$("div#parItemTableContainer div[name='rowItem']").each(function(item){
			var itemNo = item.down("input", 1).value;
			if (itemNo != $F("itemNo")){
				selectContent = selectContent + "<option value='"+itemNo+"'>"+itemNo+"</option>";
			}
		});*/

		for (var i=0; i<objGIPIWItem.length; i++){
			if ((objGIPIWItem[i].itemNo != $F("itemNo")) 
					&& (objGIPIWItem[i].recordStatus != -1)){
				selectContent = selectContent + "<option value='"+objGIPIWItem[i].itemNo+"'>"+objGIPIWItem[i].itemNo+"</option>";
			}
		}
		$("itemToCopyPeril").update(selectContent);
	}
	
	updateSelectElement();

	function addCopiedPeril(){
		try{
			var perilItem = $F("perilItem");
			var itemNo = $F("itemNo");
			var isNew = false;
			
			//removes the peril contents of 
			/*$$("div#itemPerilMotherDiv"+perilItem+" div[name='row2']").each(function (row)	{
				Effect.Fade(row, {
					duration: .001,
					afterFinish: function (){
						row.remove();
						checkTableIfEmpty("row2", "parItemPerilTable");
					}
				});
			});*/

			deleteItemPerilsForItemNo(perilItem);
			//$("itemPerilMotherDiv"+perilItem).setStyle("display: none;");
			for (var i=0; i<objGIPIWItemPeril.length; i++){
				/*if (objGIPIWItemPeril[i].itemNo == itemNo){
					var objCopiedPeril = objGIPIWItemPeril[i];
					objCopiedPeril.itemNo = perilItem;
					addObjToPerilTable(objCopiedPeril);
					addNewPerilObject(objCopiedPeril);*/ 

					//belle 05072011 
				if (objGIPIWItemPeril[i].itemNo == itemNo){ 
					copyPeril1(objGIPIWItemPeril, itemNo, perilItem, "parItemPerilTable", "perilCd", "peril");
					break;
				}
			}

			/*$$("div#itemPerilMotherDiv"+itemNo+" div[name='row2']").each(function (row)	{
				var lineCd = 	row.down("input", 1).value;
				var perilName = row.down("input", 2).value;
				var perilCd = 	row.down("input", 3).value;
				var premRt = 	row.down("input", 4).value;
				var tsiAmt = 	formatCurrency(row.down("input", 5).value);
				var premAmt = 	formatCurrency(row.down("input", 6).value);
				var compRem = 	changeSingleAndDoubleQuotes2(row.down("input", 7).value);
				if ("" == compRem) {
					compRem = "---";
				}
				var perilType = row.down("input", 8).value;
				var wcSw = 		row.down("input", 9).value;
				var tarfCd			= row.down("input", 10).value;
				var annTsiAmt		= row.down("input", 11).value;
				var annPremAmt		= row.down("input", 12).value;
				var prtFlag			= row.down("input", 13).value;
				var riCommRate		= row.down("input", 14).value;
				var riCommAmt		= row.down("input", 15).value;
				var surchargeSw		= row.down("input", 16).value;
				var baseAmt			= row.down("input", 17).value;
				var aggregateSw		= row.down("input", 18).value;
				var discountSw		= row.down("input", 19).value;
				var bascPerlCd		= row.down("input", 20).value;
				var baseAmt			= row.down("input", 21).value;
				var noOfDays		= row.down("input", 22).value;
				
				var itemPerilTable = $("itemPerilMainDiv");
				var itemPerilMotherDiv = $("itemPerilMotherDiv"+perilItem);
				if (itemPerilMotherDiv == undefined)	{
					isNew = true;
					itemPerilMotherDiv = new Element("div");
					itemPerilMotherDiv.setAttribute("id", "itemPerilMotherDiv"+perilItem);
					itemPerilMotherDiv.setAttribute("name", "itemPerilMotherDiv");
					itemPerilMotherDiv.addClassName("tableContainer");
				}
				var newDiv = new Element("div");
				newDiv.setAttribute("id", "rowPeril"+perilItem+perilCd);
				newDiv.setAttribute("name", "row2");
				newDiv.setAttribute("item", perilItem);
				newDiv.setAttribute("peril", perilCd);
				newDiv.addClassName("tableRow");
				newDiv.setStyle("display: none;");
				var divContent = '<label name="text" style="width: 5%; text-align: right; margin-right: 5px;" labelName="itemNo">'+perilItem+'</label>'+
					'<label name="text" style="width: 20%; text-align: left; margin-left: 5px;">'+perilName+'</label>'+
					'<label name="text" style="width: 15%; text-align: right;" class="moneyRate">'+premRt+'</label>'+
					'<label name="text" style="width: 15%; text-align: right; margin-left: 5px;" class="money">'+formatCurrency(tsiAmt)+'</label>'+
					'<label name="text" style="width: 15%; text-align: right; margin-left: 5px;" class="money";>'+formatCurrency(premAmt)+'</label>'+
					'<label name="text" style="width: 15%; text-align: left; margin-left: 10px;margin-right: 10px;">'+compRem+'</label>'+
					'<label style="width: 3%; text-align: right;"><span style="float: right; width: 10px; height: 10px;">-</span>'+ "</label>"+
					'<label style="width: 3%; text-align: right;"><span style="float: right; width: 10px; height: 10px;">-</span>'+ "</label>"+
					'<label style="width: 3%; text-align: right;"><span style="float: right; width: 10px; height: 10px;">-</span>'+ "</label>"+
					'<input type="hidden" name="perilItemNos"		value="'+perilItem+'" />'+			
					'<input type="hidden" name="perilLineCds"		value="'+lineCd+'" />'+
					'<input type="hidden" name="perilPerilNames" 	value="'+perilName+'" />'+
					'<input type="hidden" name="perilPerilCds" 		value="'+perilCd+'" />'+
					'<input type="hidden" name="perilPremRts" 		class="moneyRate" 	value="'+premRt+'" />'+
					'<input type="hidden" name="perilTsiAmts" 		class="money" 		value="'+formatCurrency(tsiAmt)+'" />'+
					'<input type="hidden" name="perilPremAmts" 		class="money" 		value="'+formatCurrency(premAmt)+'" />'+
					'<input type="hidden" name="perilCompRems" 		value="'+compRem+'" />'+
					'<input type="hidden" name="perilPerilTypes"	value="'+perilType+'"/>'+
					'<input type="hidden" name="perilWcSws"			value="'+wcSw+'" />'+
					'<input type="hidden" name="perilTarfCds" 		value="'+tarfCd+'" />'+
					'<input type="hidden" name="perilAnnTsiAmts" 	value="'+annTsiAmt+'" />'+
					'<input type="hidden" name="perilAnnPremAmts" 	value="'+annPremAmt+'" />'+
					'<input type="hidden" name="perilPrtFlags" 		value="'+prtFlag+'" />'+
					'<input type="hidden" name="perilRiCommRates" 	value="'+riCommRate+'" />'+
					'<input type="hidden" name="perilRiCommAmts" 	value="'+riCommAmt+'" />'+
					'<input type="hidden" name="perilSurchargeSws" 	value="'+surchargeSw+'" />'+
					'<input type="hidden" name="perilBaseAmts" 		value="'+baseAmt+'" />'+
					'<input type="hidden" name="perilAggregateSws" 	value="'+aggregateSw+'" />'+
					'<input type="hidden" name="perilDiscountSws" 	value="'+discountSw+'" />'+
					'<input type="hidden" name="perilBascPerlCds" 	value="'+bascPerlCd+'" />'+
					'<input type="hidden" name="perilBaseAmts" 		value="'+baseAmt+'" />'+
					'<input type="hidden" name="perilNoOfDayss" 	value="'+noOfDays+'" />';
				newDiv.update(divContent);

				if (isNew)	{							
					itemPerilTable.insert({bottom: itemPerilMotherDiv});
				}
				itemPerilMotherDiv.insert({bottom: newDiv});
				initializePerilRow(newDiv);
				$("tempPerilItemNos").value = updateTempStorage($F("tempPerilItemNos").blank() ? "" :  $F("tempPerilItemNos"), itemNo);
			});*/
			
			showMessageBox("Perils had been copied and saved to item no."+$F("destinationItem")+".", "info");
			//fireEvent($("row" +perilItem), "click")
		}catch(e){
			showErrorMessage("addCopiedPeril", e);
		}		
	}

	$("submit").observe("click", function () {
		var perilItem = $("itemToCopyPeril").value;
		$("perilItem").value = perilItem;
		if ("" == perilItem){
			showMessageBox("Please select a peril item no.", "error");	
		} else {                   
			hideOverlay();

			var messageBoxContent = "";
			if (countPerilsForItem(perilItem) == 0){
				messageBoxContent = "All peril(s) of this item will be copied to Item No. "+
	            	perilItem+". Would you like to continue ?";
			} else {
				messageBoxContent = "Item No. "+perilItem+" has peril(s) already, would you like to overide these existing peril(s)?";
			}
			
			$("destinationItem").value = perilItem;
			showConfirmBox("Copy Peril", messageBoxContent, "Yes", "No", addCopiedPeril, function(){
					showMessageBox("Copying of Peril had been cancelled.", imgMessage.INFO);
				});
		}
	});	

	$("cancelCopy").observe("click", hideOverlay);
	$("copyPerilPageLoaded").value = "Y";
}catch(e){
	showErrorMessage("Copy Peril Page", e);
}
</script>
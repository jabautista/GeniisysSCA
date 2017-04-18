<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="contentsDiv"><!-- rename this in the future(to be edited -form) -->
	<div align="left">
		<table>
			<tr>
				<td class="rightAligned">Name Keyword </td>
				<td class="leftAligned"><input name="keyword" id="keyword" style="margin-bottom: 0; width: 200px;" type="text" onkeypress="onEnterEvent(event, searchClientModal2);" value="" /></td>
				<td><input class="button" type="button" style="width: 60px;" onclick="searchClientModal2();" value="Search" /></td>
			</tr>
		</table>
	</div>
	
	<div style="padding: 10px; height: 350px; background-color: #ffffff; overflow: auto;" id="searchResult" align="center">
	</div>
	
	<div id="divB" align="right" style="margin: 10px; margin-right: 0;">
		<!-- put "id" for each button (refer to common.js "openSearchClientModal()" function for js function -->
		<input type="button" id="btnAssuredOk" class="button" value="Ok" style="width: 60px;" />
		<input type="button" id="btnCancelAssdListing" class="button" value="Cancel" style="width: 60px;" onclick="Modalbox.hide();" />
	</div>
</div>
<script type="text/javascript">
	if(assuredListingFromPAR == 2){// Added to handle the condition that user must select assured when creating par from select quotation. --irwin
		$("btnCancelAssdListing").hide();
	}
	searchClientModal2();
	$("btnAssuredOk").observe("click", function () {
		var selectedId= $("selectedClientId").value;
		if (selectedId != "0")	{
			useAssured();
			Modalbox.hide();
			if (assuredListingFromPAR == 1) {
				/*disableParCreationButtons();
				$("linecd").disable();
				$("isscd").disable();
				$("year").disable();
				$("quoteSeqNo").disable();
				$("assuredNo").disable();
				$("remarks").disable();*/
				//$("creatPARForm").disable();
				//fireNextFunc();
				fireNextFunc2();
			}else if(assuredListingFromPAR == 2){// added by irwin for packParCreation. 04.12.2011
				getPackAssuredValues();
			}
		}else{// added by Irwin
			if(assuredListingFromPAR == 2){// Added to handle the condition that user must select assured when creating par from select quotation. --irwin 
				showMessageBox("Assured is required. Please Choose from the list.", imgMessage.INFO);
			}else{
				Modalbox.hide();
			}	
			//showMessageBox("No Assured selected.", imgMessage.ERROR);
		}
		
	});

	//added to restore line settings preceding cancel of assured designation
	$("btnCancelAssdListing").observe("click", function(){
		if ($("parCreationMainDiv") != null){
			$("linecd").value = $("tempLineCd").value;
			$$("div#buttonsParCreationDiv input[type='button']").each(function(b){
				enableButton(b.getAttribute("id"));
			});
			$("linecd").enable();
			//$("isscd").enable();
			$("year").enable();
			$("remarks").enable();
			$("quoteSeqNo").enable();
			$("assuredNo").enable();
		}
	});
</script>
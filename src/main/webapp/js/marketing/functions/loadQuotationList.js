/* FOR quotationListing.jsp added by whofeih */

function loadQuotationList(pageNo){
	new Ajax.Updater("searchResult", contextPath + "/GIPIQuotationController?action=getFilterQuoteListing&pageNo="	+ pageNo, {
		method : "POST",
		postBody : Form.serialize("searchForm"),
		evalScripts : true,
		asynchronous : true,
		onCreate : function() {
			fadeElement("searchDiv", .3, null);
			Effect.Fade("quotationListingTable",{
				duration : .001,
				afterFinish : function(){
					showLoading("searchResult", "Getting list, please wait...",	"150px");
				}
			});
		},
		onComplete : function(){
			Effect.Appear("quotationListingTable", {
				duration : .001
			});
			var marRight = parseInt((screen.width - mainContainerWidth)/2);
			$("filterSpan").setStyle("right: " + marRight + "px;");
			$("searchDiv").setStyle("right: " + marRight + "px;");
		}
	});
}
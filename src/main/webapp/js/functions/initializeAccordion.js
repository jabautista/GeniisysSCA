/* initialize all accordions - whofeih */
function initializeAccordion()	{
	$$("label[name='gro']").each(function (label)	{
		label.observe("click", function ()	{
			label.innerHTML = label.innerHTML == "Hide" ? "Show" : "Hide";
			var infoDiv = label.up("div", 1).next().readAttribute("id");
			Effect.toggle(infoDiv, "blind", {duration: .3});
		});
	});
}
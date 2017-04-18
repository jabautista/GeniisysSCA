// fix tilde problem on strings inputs by replacing it with their unicode values, �/� handled
// parameter: str
// str: str that may contain �/�
function fixTildeProblem(str) {
	return (str.replace(/%C3%B1/g, "\u00f1")).replace(/%C3%91/g, "\u00D1");
}
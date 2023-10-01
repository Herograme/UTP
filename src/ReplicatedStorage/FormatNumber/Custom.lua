

return {
	functions = {


		FormaterNumbers = function  (Number)
			local FormatNumber = require(script.Parent.Main)
			local  abbreviations = FormatNumber.Notation.compactWithSuffixThousands({
				"K", "M", "B", "T", "Qa", "Qb", "Qc"
			})
			local formatter = FormatNumber.NumberFormatter.with()
				:Notation(abbreviations)
				:Precision(FormatNumber.Precision.integer():WithMinDigits(3))

			local NumberFormated = formatter:Format(Number)
			return NumberFormated


		end






	}
}

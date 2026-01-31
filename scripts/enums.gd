enum Element {
	NONE,
	AQUA,
	FIRE,
	NATURE
}

func element_to_string(element: Element):
	return {
		Enums.Element.AQUA: "aqua",
		Enums.Element.FIRE: "fire",
		Enums.Element.NATURE: "nature"
	}[element]

func string_to_element(element: String):
	return {
		"aqua": Enums.Element.AQUA,
		"fire": Enums.Element.FIRE,
		"nature": Enums.Element.NATURE
	}[element]

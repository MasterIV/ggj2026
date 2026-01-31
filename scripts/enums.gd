extends Node

enum Element {
	NONE,
	AQUA,
	FIRE,
	NATURE
}

func element_to_string(element: Element):
	return {
		Element.AQUA: "aqua",
		Element.FIRE: "fire",
		Element.NATURE: "nature"
	}[element]

func string_to_element(element: String):
	return {
		"aqua": Element.AQUA,
		"fire": Element.FIRE,
		"nature": Element.NATURE
	}[element]

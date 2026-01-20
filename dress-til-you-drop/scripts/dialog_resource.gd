class_name DialogResource
extends Resource

enum speakers {
	NONE,
	SISTER,
	MC,
}

@export var speaker: Array[speakers]
@export var dialog: Array[String]

var speaker_name: Dictionary = {
	speakers.NONE: "",
	speakers.SISTER: "Sister",
	speakers.MC: "MC",
}

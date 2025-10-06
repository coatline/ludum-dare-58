class_name CardInstance

enum CardGrade {
	POOR,
	OKAY,
	GOOD,
	GREAT,
	PRISTINE
}

var grade: CardGrade
var type: CardType

func _init(grade_: CardGrade, type_: CardType):
	grade = grade_
	type = type_

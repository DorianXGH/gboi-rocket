.DEFINE n_elements $0A
.DEFINE n_sheets $01
.DEFINE n_states $0A
.DEFINE n_isaac_tears $0A
.DEFINE n_ennemy_tears $0A

.STRUCT isaac
	x DB
	y DB
	hp DB
	dmg DB
	upgrades DW
	range DB
	speed DB
	tears DB
	recover DB
	bombs DB
	direction DB
.ENDST

.STRUCT element
	x DB
	y DB
	speed DB
	sheet DB
	state DW
.ENDST

.STRUCT sheet
	size DB
	dmg DB
	function DW
	speed DB
.ENDST

.STRUCT state
	hp DB
.ENDST

.STRUCT tear
	x DB
	y DB
	direction DB
.ENDST

.STRUCT global_var
	sheets INSTANCEOF sheet n_sheets
	isaac INSTANCEOF isaac
	elements INSTANCEOF element n_elements
	issac_tear_pointer DB
	isaac_tears INSTANCEOF tear n_isaac_tears
	ennemy_tear_pointer DB
	ennemy_tears INSTANCEOF tear n_ennemy_tears
	states INSTANCEOF state n_states
.ENDST

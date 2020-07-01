.DEFINE SPRITE_TILES_START_ADDRESS $8000
.DEFINE BACKGROUND_TILES_START_ADDRESS $9000


.DEFINE ISAAC_SPRITESHEET $00
.DEFINE ISAAC_SPRITESHEET_SIZE $0E
.DEFINE ISAAC_TOP_LEFT ISAAC_SPRITESHEET 
.DEFINE ISAAC_TOP_RIGHT ISAAC_SPRITESHEET + $03
.DEFINE ISAAC_BOTTOM_LEFT_STAND ISAAC_SPRITESHEET + $06
.DEFINE ISAAC_BOTTOM_RIGHT_STAND ISAAC_SPRITESHEET  + $0C
.DEFINE ISAAC_BOTTOM_LEFT_WALK ISAAC_BOTTOM_LEFT_STAND
.DEFINE ISAAC_BOTTOM_RIGHT_WALK ISAAC_BOTTOM_RIGHT_STAND - $02
.DEFINE ISAAC_MOUTH_PIXEL_1 $8000 + (ISAAC_BOTTOM_LEFT_WALK+$01)*$10+$01
.DEFINE ISAAC_MOUTH_PIXEL_2 ISAAC_MOUTH_PIXEL_1 + $20

.DEFINE TEAR_SPRITESHEET ISAAC_SPRITESHEET + ISAAC_SPRITESHEET_SIZE
.DEFINE TEAR_SPRITESHEET_SIZE $01

.DEFINE FLY_SPRITESHEET TEAR_SPRITESHEET + TEAR_SPRITESHEET_SIZE 
.DEFINE FLY_SPRITESHEET_SIZE $02

.DEFINE WASP_SPRITESHEET FLY_SPRITESHEET + FLY_SPRITESHEET_SIZE 
.DEFINE WASP_SPRITESHEET_SIZE $06
.DEFINE WASP_BOTTOM WASP_SPRITESHEET + 4

.DEFINE SPRITE_TILES_NUMBER ISAAC_SPRITESHEET_SIZE + TEAR_SPRITESHEET_SIZE + FLY_SPRITESHEET_SIZE + WASP_SPRITESHEET_SIZE 


.DEFINE BACKGROUND_SPRITESHEET $00
.DEFINE BACKGROUND_SPRITESHEET_SIZE $01
.DEFINE EMPTY_FLOOR BACKGROUND_SPRITESHEET

.DEFINE BACKGROUND_WALL_SPRITESHEET BACKGROUND_SPRITESHEET + BACKGROUND_SPRITESHEET_SIZE
.DEFINE BACKGROUND_WALL_SPRITESHEET_SIZE $15
.DEFINE FLAT_BACKGROUND_WALL BACKGROUND_WALL_SPRITESHEET
.DEFINE UP_BACKGROUND_WALL BACKGROUND_WALL_SPRITESHEET + $01
.DEFINE LEFT_BACKGROUND_WALL BACKGROUND_WALL_SPRITESHEET + $02
.DEFINE RIGHT_BACKGROUND_WALL BACKGROUND_WALL_SPRITESHEET + $03
.DEFINE DOWN_BACKGROUND_WALL BACKGROUND_WALL_SPRITESHEET + $04
.DEFINE UP_RIGHT_CORNER BACKGROUND_WALL_SPRITESHEET + $05
.DEFINE UP_LEFT_CORNER BACKGROUND_WALL_SPRITESHEET + $06
.DEFINE DOWN_LEFT_CORNER BACKGROUND_WALL_SPRITESHEET + $07
.DEFINE DOWN_RIGHT_CORNER BACKGROUND_WALL_SPRITESHEET + $08
.DEFINE FIRST_WALL_DETAIL BACKGROUND_WALL_SPRITESHEET + $09

.DEFINE DOORS_SPRITESHEET BACKGROUND_WALL_SPRITESHEET + BACKGROUND_WALL_SPRITESHEET_SIZE
.DEFINE DOORS_SPRITESHEET_SIZE 40
.DEFINE UP_DOOR DOORS_SPRITESHEET
.DEFINE LEFT_DOOR DOORS_SPRITESHEET + $0A
.DEFINE RIGHT_DOOR DOORS_SPRITESHEET + $14
.DEFINE DOWN_DOOR DOORS_SPRITESHEET + $1E

.DEFINE ROCKS_SPRITESHEET DOORS_SPRITESHEET + DOORS_SPRITESHEET_SIZE 
.DEFINE ROCKS_SPRITESHEET_SIZE $0C

.DEFINE PIT_SPRITESHEET ROCKS_SPRITESHEET + ROCKS_SPRITESHEET_SIZE 
.DEFINE PIT_SPRITESHEET_SIZE $04 

.DEFINE HEARTS_SPRITESHEET PIT_SPRITESHEET + PIT_SPRITESHEET_SIZE 
.DEFINE HEARTS_SPRITESHEET_SIZE $03

.DEFINE BACKGROUND_TILES_NUMBER BACKGROUND_SPRITESHEET_SIZE + BACKGROUND_WALL_SPRITESHEET_SIZE + DOORS_SPRITESHEET_SIZE + ROCKS_SPRITESHEET_SIZE + PIT_SPRITESHEET + HEARTS_SPRITESHEET_SIZE 
